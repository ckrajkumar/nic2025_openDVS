"""Run the post-pilot fixed-timeline reset matrix with provenance-bound admission."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
from typing import Any

RUNNER_REL = Path("tooling_v33/reset_campaign.py")
MANIFEST_REL = Path("inputs/campaign_manifest.fixed_timing_v1.json")
SOURCE_MAP_REL = Path("inputs/source_map.fixed_timing_v1.json")
EXTREME_RUN_ID = "reset_fixed_timeline_extremes_v2"
NOMINAL_RUN_IDS = {
    "schematic_ngspice": "reset_fixed_timeline_nominal_v2",
    "magic_rcc_ngspice": "reset_fixed_timeline_nominal_v2",
    "quantus_rcc_spectre": "reset_fixed_timeline_nominal_v2",
}
ALL_PATHS = tuple(NOMINAL_RUN_IDS)
PATHS = ALL_PATHS
TIMEOUT_S = 28800.0
PATH_EVIDENCE_TEMPLATE = "path_evidence.{path}.json"


def _load_module(path: Path):
    spec = importlib.util.spec_from_file_location("reset_campaign_matrix", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load reset runner: {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def _sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def _json_bytes(value: Any) -> bytes:
    return (
        json.dumps(value, sort_keys=True, indent=2, allow_nan=False) + "\n"
    ).encode()


def _context(project_root: Path):
    runner_path = project_root / RUNNER_REL
    manifest_path = project_root / MANIFEST_REL
    source_map_path = project_root / SOURCE_MAP_REL
    runner = _load_module(runner_path)
    manifest, manifest_sha256 = runner._load_manifest(manifest_path)
    runner._validate_manifest_for_execution(manifest)
    sources, source_hashes = runner._verify_sources(source_map_path)
    return {
        "runner": runner,
        "runner_path": runner_path,
        "manifest": manifest,
        "manifest_path": manifest_path,
        "manifest_sha256": manifest_sha256,
        "source_map_path": source_map_path,
        "sources": sources,
        "source_hashes": source_hashes,
        "source_fingerprint": runner._source_fingerprint(source_hashes),
    }


def _pilot_rows(runner, manifest: dict[str, Any]) -> list[dict[str, Any]]:
    rows = runner.select_pilot_rows(manifest, "nominal") + runner.select_pilot_rows(
        manifest, "extremes"
    )
    row_ids = [row["row_id"] for row in rows]
    if len(rows) != 9 or len(set(row_ids)) != 9:
        raise RuntimeError(
            f"expected nine unique pilot rows, found {len(set(row_ids))}"
        )
    return rows


def _remaining_rows(runner, manifest: dict[str, Any]) -> list[dict[str, Any]]:
    pilot_ids = {row["row_id"] for row in _pilot_rows(runner, manifest)}
    rows = [
        row
        for row in runner._pending_reset_rows(manifest)
        if row["row_id"] not in pilot_ids and row["condition"]["path"] in PATHS
    ]
    counts = {
        path: sum(row["condition"]["path"] == path for row in rows) for path in PATHS
    }
    if len(rows) != 126 or counts != {path: 42 for path in PATHS}:
        raise RuntimeError(
            f"unexpected remaining reset partition: total={len(rows)}, {counts}"
        )
    return rows


def _result_record(runner, base: Path, attempt: Path, result: dict[str, Any]) -> Path:
    if result.get("reclassified_from"):
        return (
            base
            / f"reclassification-{attempt.name}-{result['classifier_sha256'][:12]}.json"
        )
    return attempt / "result.json"


def _pilot_evidence(project_root: Path, ctx: dict[str, Any]) -> list[dict[str, Any]]:
    runner = ctx["runner"]
    manifest = ctx["manifest"]
    sources = ctx["sources"]
    source_hashes = ctx["source_hashes"]
    nominal_ids = {
        row["row_id"] for row in runner.select_pilot_rows(manifest, "nominal")
    }
    evidence: list[dict[str, Any]] = []
    for row in _pilot_rows(runner, manifest):
        condition = runner._condition(row)
        path = condition["path"]
        run_id = (
            NOMINAL_RUN_IDS[path] if row["row_id"] in nominal_ids else EXTREME_RUN_ID
        )
        base = (
            project_root
            / "runs"
            / run_id
            / path
            / condition["analysis"]
            / row["row_id"]
        )
        deck = runner.build_discovery_deck(row, sources)
        runner.validate_deck(row, deck, sources, stage="discovery")
        startup = (
            runner._ngspice_startup_text() if path != "quantus_rcc_spectre" else ""
        )
        fingerprint = runner._deck_fingerprint(deck, source_hashes, startup)
        found = runner._existing_pass(
            base, fingerprint, "discovery", row, source_hashes
        )
        if found is None:
            runner._reclassify_existing_discovery(row, base, fingerprint, source_hashes)
            found = runner._existing_pass(
                base, fingerprint, "discovery", row, source_hashes
            )
        if found is None:
            raise RuntimeError(
                f"pilot evidence is not provenance-verified: {row['row_id']}"
            )
        attempt, result = found
        record_path = _result_record(runner, base, attempt, result)
        log_path = attempt / "simulator.log"
        log_sha256 = runner._sha256_file(log_path)
        if result.get("simulator_log_sha256") != log_sha256:
            raise RuntimeError(
                f"pilot simulator log is not provenance-bound: {row['row_id']}"
            )
        evidence.append(
            {
                "path": path,
                "corner": condition["corner"],
                "vdd_v": condition["vdd_v"],
                "temperature_c": condition["temperature_c"],
                "row_id": row["row_id"],
                "attempt": str(attempt),
                "result_record": str(record_path),
                "result_record_sha256": runner._sha256_file(record_path),
                "raw_sha256": result["raw_sha256"],
                "simulator_log_sha256": log_sha256,
                "fingerprint": fingerprint,
                "classifier_sha256": result["classifier_sha256"],
                "execution_validity": result["execution_validity"],
                "scientific_validity": result["scientific_validity"],
                "spec_result": result["spec_result"],
            }
        )
    return evidence


def _records(project_root: Path, output: Path, ctx: dict[str, Any]):
    runner = ctx["runner"]
    remaining = _remaining_rows(runner, ctx["manifest"])
    evidence = _pilot_evidence(project_root, ctx)
    evidence_value = {
        "schema_version": 1,
        "manifest_sha256": ctx["manifest_sha256"],
        "source_fingerprint": ctx["source_fingerprint"],
        "classifier_sha256": runner._sha256_file(ctx["runner_path"]),
        "orchestrator_sha256": _sha256(Path(__file__).resolve()),
        "evidence": evidence,
    }
    evidence_bytes = _json_bytes(evidence_value)
    evidence_sha256 = hashlib.sha256(evidence_bytes).hexdigest()
    admission_value = {
        "schema_version": 1,
        "manifest_sha256": ctx["manifest_sha256"],
        "source_fingerprint": ctx["source_fingerprint"],
        "pilot_row_ids": [item["row_id"] for item in evidence],
        "pilot_evidence_sha256": evidence_sha256,
        "execution_validity": "pass",
        "scientific_validity": "valid",
    }
    campaign_value = {
        "schema_version": 1,
        "manifest": str(ctx["manifest_path"].resolve()),
        "manifest_sha256": ctx["manifest_sha256"],
        "source_map": str(ctx["source_map_path"].resolve()),
        "source_map_sha256": runner._sha256_file(ctx["source_map_path"]),
        "source_hashes": ctx["source_hashes"],
        "source_fingerprint": ctx["source_fingerprint"],
        "classifier_sha256": runner._sha256_file(ctx["runner_path"]),
        "orchestrator_sha256": _sha256(Path(__file__).resolve()),
        "rung": "remaining_after_valid_pilot",
        "timeout_s": TIMEOUT_S,
        "row_ids": [row["row_id"] for row in remaining],
        "output": str(output.resolve()),
    }
    return remaining, campaign_value, admission_value, evidence_value


def prepare(project_root: Path, output: Path) -> dict[str, Any]:
    if output.exists():
        raise RuntimeError(f"refusing existing output: {output}")
    ctx = _context(project_root)
    remaining, campaign, admission, evidence = _records(project_root, output, ctx)
    output.mkdir(parents=True)
    ctx["runner"]._atomic_write_json(output / "campaign.json", campaign)
    ctx["runner"]._atomic_write_json(output / "pilot_admission.json", admission)
    ctx["runner"]._atomic_write_json(output / "pilot_evidence.json", evidence)
    return {
        "status": "prepared",
        "output": str(output),
        "remaining_rows": len(remaining),
        "rows_per_path": {path: 42 for path in PATHS},
    }


def _require_exact_json(path: Path, expected: dict[str, Any]) -> None:
    try:
        actual = path.read_bytes()
    except OSError as exc:
        raise RuntimeError(f"missing matrix record: {path}") from exc
    if actual != _json_bytes(expected):
        raise RuntimeError(
            f"matrix record bytes no longer match verified inputs: {path}"
        )


def _path_evidence_value(
    output: Path,
    path: str,
    rows: list[dict[str, Any]],
    results: list[dict[str, Any]],
    ctx: dict[str, Any],
) -> dict[str, Any]:
    if len(rows) != 42 or len(results) != 42:
        raise RuntimeError(
            f"cannot bind incomplete path evidence for {path}: "
            f"rows={len(rows)}, results={len(results)}"
        )
    runner = ctx["runner"]
    evidence: list[dict[str, Any]] = []
    for row, result in zip(rows, results, strict=True):
        row_id = row["row_id"]
        if result.get("row_id") != row_id:
            raise RuntimeError(f"matrix result order or identity changed for {row_id}")
        directory = result.get("directory") or result.get("reclassified_from")
        if not isinstance(directory, str):
            raise RuntimeError(f"matrix result has no attempt directory: {row_id}")
        attempt = Path(directory)
        base = output / path / "reset_transient" / row_id
        try:
            if attempt.resolve(strict=True).parent != base.resolve(strict=True):
                raise RuntimeError(
                    f"matrix attempt escapes its row directory: {row_id}"
                )
        except OSError as exc:
            raise RuntimeError(f"matrix attempt cannot be resolved: {row_id}") from exc
        record_path = _result_record(runner, base, attempt, result)
        log_path = attempt / "simulator.log"
        if not record_path.is_file() or not log_path.is_file():
            raise RuntimeError(f"matrix result evidence is incomplete: {row_id}")
        record = json.loads(record_path.read_text(encoding="utf-8"))
        if not isinstance(record, dict) or record.get("row_id") != row_id:
            raise RuntimeError(f"matrix result record identity changed: {row_id}")
        log_sha256 = runner._sha256_file(log_path)
        if record.get("simulator_log_sha256") != log_sha256:
            raise RuntimeError(f"matrix result log binding changed: {row_id}")
        evidence.append(
            {
                "path": path,
                "row_id": row_id,
                "attempt": str(attempt.resolve()),
                "result_record": str(record_path.resolve()),
                "result_record_sha256": runner._sha256_file(record_path),
                "raw_sha256": record.get("raw_sha256"),
                "simulator_log_sha256": log_sha256,
                "execution_validity": record.get("execution_validity"),
                "scientific_validity": record.get("scientific_validity"),
                "spec_result": record.get("spec_result"),
            }
        )
    return {
        "schema_version": 1,
        "manifest_sha256": ctx["manifest_sha256"],
        "source_fingerprint": ctx["source_fingerprint"],
        "classifier_sha256": runner._sha256_file(ctx["runner_path"]),
        "orchestrator_sha256": _sha256(Path(__file__).resolve()),
        "campaign_sha256": runner._sha256_file(output / "campaign.json"),
        "path": path,
        "row_ids": [row["row_id"] for row in rows],
        "evidence": evidence,
    }


def _write_once_json(runner, path: Path, value: dict[str, Any]) -> None:
    expected = _json_bytes(value)
    if path.exists():
        if path.read_bytes() != expected:
            raise RuntimeError(f"refusing changed matrix evidence record: {path}")
        return
    runner._atomic_write_json(path, value)


def run_path(project_root: Path, output: Path, path: str) -> list[dict[str, Any]]:
    ctx = _context(project_root)
    remaining, campaign, admission, evidence = _records(project_root, output, ctx)
    _require_exact_json(output / "campaign.json", campaign)
    _require_exact_json(output / "pilot_admission.json", admission)
    _require_exact_json(output / "pilot_evidence.json", evidence)
    rows = [row for row in remaining if row["condition"]["path"] == path]
    if len(rows) != 42:
        raise RuntimeError(f"expected 42 remaining rows for {path}, found {len(rows)}")
    results = ctx["runner"]._run_rows(
        rows, ctx["sources"], ctx["source_hashes"], output, False, TIMEOUT_S
    )
    invalid = [
        item.get("row_id")
        for item in results
        if item.get("execution_validity") != "pass"
        or item.get("scientific_validity") != "valid"
    ]
    if invalid:
        raise RuntimeError(
            f"cannot write path evidence for {path}: "
            f"{len(invalid)} result(s) are not execution-pass and scientifically valid"
        )
    path_evidence = _path_evidence_value(output, path, rows, results, ctx)
    _write_once_json(
        ctx["runner"],
        output / PATH_EVIDENCE_TEMPLATE.format(path=path),
        path_evidence,
    )
    return results


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project-root", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--mode", required=True, choices=("prepare", "run-path"))
    parser.add_argument("--path", choices=PATHS)
    args = parser.parse_args()
    try:
        if args.mode == "prepare":
            if args.path is not None:
                raise RuntimeError("--path is not allowed with --mode prepare")
            result: Any = prepare(args.project_root, args.output)
        else:
            if args.path is None:
                raise RuntimeError("--path is required with --mode run-path")
            result = run_path(args.project_root, args.output, args.path)
        print(json.dumps(result, sort_keys=True))
        if args.mode == "run-path" and not all(
            item.get("execution_validity") == "pass"
            and item.get("scientific_validity") == "valid"
            for item in result
        ):
            return 1
        return 0
    except (OSError, RuntimeError, ValueError, json.JSONDecodeError) as exc:
        print(json.dumps({"status": "error", "error": str(exc)}, sort_keys=True))
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
