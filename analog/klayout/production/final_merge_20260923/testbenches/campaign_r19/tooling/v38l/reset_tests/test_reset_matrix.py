from __future__ import annotations

import hashlib
import importlib.util
import json
import tempfile
import textwrap
import unittest
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


manifest_module = load("reset_matrix_manifest", ROOT / "campaign_manifest.py")
runner = load("reset_matrix_runner", ROOT / "reset_campaign.py")
matrix = load("reset_matrix_orchestrator", ROOT / "reset_matrix.py")


class ResetMatrixTests(unittest.TestCase):
    def test_partition_excludes_exactly_the_nine_pilot_rows(self) -> None:
        manifest = manifest_module.build_manifest()
        pilots = matrix._pilot_rows(runner, manifest)
        remaining = matrix._remaining_rows(runner, manifest)
        self.assertEqual(len(pilots), 9)
        self.assertEqual(len(remaining), 126)
        self.assertFalse(
            {row["row_id"] for row in pilots} & {row["row_id"] for row in remaining}
        )
        self.assertEqual(
            {
                path: sum(row["condition"]["path"] == path for row in remaining)
                for path in matrix.PATHS
            },
            {path: 42 for path in matrix.PATHS},
        )

    def test_orchestration_is_bound_to_validated_version(self) -> None:
        self.assertEqual(matrix.RUNNER_REL, Path("tooling_v33/reset_campaign.py"))
        self.assertEqual(
            matrix.MANIFEST_REL,
            Path("inputs/campaign_manifest.fixed_timing_v1.json"),
        )
        self.assertEqual(
            matrix.SOURCE_MAP_REL,
            Path("inputs/source_map.fixed_timing_v1.json"),
        )
        self.assertEqual(matrix.EXTREME_RUN_ID, "reset_fixed_timeline_extremes_v2")
        self.assertEqual(
            set(matrix.NOMINAL_RUN_IDS.values()),
            {"reset_fixed_timeline_nominal_v2"},
        )
        self.assertEqual(matrix.PATHS, matrix.ALL_PATHS)
        self.assertEqual(matrix.TIMEOUT_S, 28800.0)

    def fixture_project(self, root: Path) -> tuple[Path, list[dict]]:
        tooling = root / matrix.RUNNER_REL.parent
        inputs = root / "inputs"
        tooling.mkdir(parents=True)
        inputs.mkdir()
        runner_source = textwrap.dedent(
            """
            import hashlib
            import json
            from pathlib import Path

            def _sha256_file(path):
                return hashlib.sha256(Path(path).read_bytes()).hexdigest()

            def _load_manifest(path):
                payload = Path(path).read_bytes()
                return json.loads(payload), hashlib.sha256(payload).hexdigest()

            def _validate_manifest_for_execution(manifest):
                if manifest.get("confirmation_data_accessed") is not False:
                    raise ValueError("confirmation data must remain sealed")

            def _verify_sources(path):
                json.loads(Path(path).read_text())
                return {"fixture": str(Path(path))}, {"fixture": _sha256_file(path)}

            def _source_fingerprint(source_hashes):
                return hashlib.sha256(json.dumps(source_hashes, sort_keys=True).encode()).hexdigest()

            def select_pilot_rows(manifest, rung):
                return [row for row in manifest["rows"] if row.get("pilot") == rung]

            def _pending_reset_rows(manifest):
                return list(manifest["rows"])

            def _condition(row):
                return row["condition"]

            def build_discovery_deck(row, sources):
                return "fixture deck " + row["row_id"]

            def validate_deck(row, deck, sources, stage):
                if stage != "discovery" or row["row_id"] not in deck:
                    raise ValueError("bad fixture deck")

            def _ngspice_startup_text():
                return "fixture startup\\n"

            def _deck_fingerprint(deck, source_hashes, startup=""):
                return hashlib.sha256((deck + startup + json.dumps(source_hashes, sort_keys=True)).encode()).hexdigest()

            def _existing_pass(base, fingerprint, stage, row, source_hashes):
                base = Path(base)
                if (base / "invalid").exists():
                    return None
                attempt = base / "attempt-1"
                result_path = attempt / "result.json"
                log_path = attempt / "simulator.log"
                if not result_path.is_file() or not log_path.is_file():
                    return None
                result = json.loads(result_path.read_text())
                if result.get("simulator_log_sha256") != _sha256_file(log_path):
                    return None
                return attempt, result

            def _reclassify_existing_discovery(row, base, fingerprint, source_hashes):
                return None

            def _atomic_write_json(path, value):
                Path(path).write_text(json.dumps(value, sort_keys=True, indent=2, allow_nan=False) + "\\n")

            def _run_rows(rows, sources, source_hashes, output, prepare_only, timeout_s):
                path = rows[0]["condition"]["path"]
                row_ids = [row["row_id"] for row in rows]
                (Path(output) / ("executed-" + path + ".json")).write_text(json.dumps(row_ids))
                results = []
                for row in rows:
                    base = Path(output) / path / "reset_transient" / row["row_id"]
                    attempt = base / "attempt-1"
                    result_path = attempt / "result.json"
                    log_path = attempt / "simulator.log"
                    attempt.mkdir(parents=True, exist_ok=True)
                    if result_path.is_file():
                        result = json.loads(result_path.read_text())
                    else:
                        log_path.write_text("clean matrix fixture completion\\n")
                        result = {
                            "row_id": row["row_id"],
                            "directory": str(attempt),
                            "raw_sha256": hashlib.sha256(row["row_id"].encode()).hexdigest(),
                            "simulator_log_sha256": _sha256_file(log_path),
                            "execution_validity": "pass",
                            "scientific_validity": "valid",
                            "spec_result": "fail",
                        }
                        result_path.write_text(json.dumps(result, sort_keys=True) + "\\n")
                    results.append(result)
                return results
            """
        )
        (root / matrix.RUNNER_REL).write_text(runner_source)
        (root / matrix.SOURCE_MAP_REL).write_text('{"fixture": true}\n')
        rows: list[dict] = []
        for path in matrix.ALL_PATHS:
            for index in range(45):
                if index == 0:
                    pilot, corner, vdd, temperature = "nominal", "tt", 1.8, 27
                elif index == 1:
                    pilot, corner, vdd, temperature = "extremes", "ss", 1.62, 0
                elif index == 2:
                    pilot, corner, vdd, temperature = "extremes", "ff", 1.98, 70
                else:
                    pilot, corner, vdd, temperature = None, "tt", 1.8, index
                row = {
                    "row_id": f"row-{path}-{index:02d}",
                    "condition": {
                        "path": path,
                        "analysis": "reset_transient",
                        "corner": corner,
                        "vdd_v": vdd,
                        "temperature_c": temperature,
                    },
                }
                if pilot is not None:
                    row["pilot"] = pilot
                rows.append(row)
        manifest = {"confirmation_data_accessed": False, "rows": rows}
        (root / matrix.MANIFEST_REL).write_text(
            json.dumps(manifest, sort_keys=True) + "\n"
        )

        runner_sha256 = hashlib.sha256(runner_source.encode()).hexdigest()
        for row in rows:
            pilot = row.get("pilot")
            if pilot is None:
                continue
            path = row["condition"]["path"]
            run_id = (
                matrix.NOMINAL_RUN_IDS[path]
                if pilot == "nominal"
                else matrix.EXTREME_RUN_ID
            )
            base = root / "runs" / run_id / path / "reset_transient" / row["row_id"]
            attempt = base / "attempt-1"
            attempt.mkdir(parents=True)
            log = b"clean fixture completion\n"
            (attempt / "simulator.log").write_bytes(log)
            result = {
                "row_id": row["row_id"],
                "classifier_sha256": runner_sha256,
                "raw_sha256": hashlib.sha256(row["row_id"].encode()).hexdigest(),
                "simulator_log_sha256": hashlib.sha256(log).hexdigest(),
                "execution_validity": "pass",
                "scientific_validity": "valid",
                "spec_result": "fail",
            }
            (attempt / "result.json").write_text(
                json.dumps(result, sort_keys=True) + "\n"
            )
        return root / "runs" / "matrix", rows

    def test_prepare_and_concurrent_run_paths_use_exact_versioned_records(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            output, _ = self.fixture_project(root)
            prepared = matrix.prepare(root, output)
            self.assertEqual(prepared["remaining_rows"], 126)

            campaign_path = output / "campaign.json"
            campaign_bytes = campaign_path.read_bytes()
            campaign_path.write_bytes(campaign_bytes + b"\n")
            with self.assertRaisesRegex(RuntimeError, "record bytes"):
                matrix.run_path(root, output, matrix.PATHS[0])
            campaign_path.write_bytes(campaign_bytes)

            with ThreadPoolExecutor(max_workers=len(matrix.PATHS)) as pool:
                results = list(
                    pool.map(
                        lambda path: matrix.run_path(root, output, path), matrix.PATHS
                    )
                )
            self.assertEqual(
                [len(result) for result in results], [42] * len(matrix.PATHS)
            )
            for path in matrix.PATHS:
                evidence_path = output / matrix.PATH_EVIDENCE_TEMPLATE.format(path=path)
                evidence = json.loads(evidence_path.read_text())
                self.assertEqual(evidence["path"], path)
                self.assertEqual(len(evidence["evidence"]), 42)
            executed = {
                row_id
                for path in matrix.PATHS
                for row_id in json.loads((output / f"executed-{path}.json").read_text())
            }
            self.assertEqual(len(executed), 126)

            path = matrix.PATHS[0]
            evidence = json.loads(
                (output / matrix.PATH_EVIDENCE_TEMPLATE.format(path=path)).read_text()
            )
            result_path = Path(evidence["evidence"][0]["result_record"])
            result = json.loads(result_path.read_text())
            result["spec_result"] = "pass"
            result_path.write_text(json.dumps(result, sort_keys=True) + "\n")
            with self.assertRaisesRegex(RuntimeError, "changed matrix evidence"):
                matrix.run_path(root, output, path)

    def test_prepare_rejects_invalid_pilot_evidence(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            output, rows = self.fixture_project(root)
            row = next(row for row in rows if row.get("pilot") == "nominal")
            path = row["condition"]["path"]
            base = (
                root
                / "runs"
                / matrix.NOMINAL_RUN_IDS[path]
                / path
                / "reset_transient"
                / row["row_id"]
            )
            (base / "invalid").write_text("invalidate fixture evidence\n")
            with self.assertRaisesRegex(RuntimeError, "not provenance-verified"):
                matrix.prepare(root, output)

    def test_invalid_matrix_result_never_creates_path_evidence(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            output, _ = self.fixture_project(root)
            matrix.prepare(root, output)
            path = matrix.PATHS[0]
            remaining = [
                row
                for row in matrix._remaining_rows(
                    load("invalid_matrix_runner", root / matrix.RUNNER_REL),
                    json.loads((root / matrix.MANIFEST_REL).read_text()),
                )
                if row["condition"]["path"] == path
            ]
            row = remaining[0]
            attempt = output / path / "reset_transient" / row["row_id"] / "attempt-1"
            attempt.mkdir(parents=True)
            log = attempt / "simulator.log"
            log.write_text("invalid fixture completion\n")
            (attempt / "result.json").write_text(
                json.dumps(
                    {
                        "row_id": row["row_id"],
                        "directory": str(attempt),
                        "raw_sha256": hashlib.sha256(
                            row["row_id"].encode()
                        ).hexdigest(),
                        "simulator_log_sha256": hashlib.sha256(
                            log.read_bytes()
                        ).hexdigest(),
                        "execution_validity": "fail",
                        "scientific_validity": "pending",
                        "spec_result": "not_evaluated",
                    },
                    sort_keys=True,
                )
                + "\n"
            )
            with self.assertRaisesRegex(RuntimeError, "cannot write path evidence"):
                matrix.run_path(root, output, path)
            self.assertFalse(
                (output / matrix.PATH_EVIDENCE_TEMPLATE.format(path=path)).exists()
            )


if __name__ == "__main__":
    unittest.main()
