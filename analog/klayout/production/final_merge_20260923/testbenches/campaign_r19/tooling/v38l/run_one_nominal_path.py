#!/usr/bin/env python3
"""Run one fixed-timeline nominal path under a fresh provenance identity."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from datetime import datetime, timezone
from pathlib import Path


def load_runner(path: Path):
    spec = importlib.util.spec_from_file_location("fixed_timeline_runner", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--sources", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument(
        "--path",
        choices=("quantus_rcc_spectre", "magic_rcc_ngspice", "schematic_ngspice"),
        required=True,
    )
    parser.add_argument("--timeout-s", type=float, required=True)
    args = parser.parse_args()
    if args.output.exists():
        raise SystemExit(f"refusing to overwrite {args.output}")

    reset = load_runner(Path(__file__).with_name("reset_campaign.py"))
    manifest, manifest_hash = reset._load_manifest(args.manifest)
    reset._validate_manifest_for_execution(manifest)
    sources, source_hashes = reset._verify_sources(args.sources)
    rows = [
        row
        for row in reset.select_pilot_rows(manifest, "nominal")
        if row["condition"]["path"] == args.path
    ]
    if len(rows) != 1:
        raise SystemExit(f"expected one nominal row for {args.path}, found {len(rows)}")
    row = rows[0]
    args.output.mkdir(parents=True)
    campaign = {
        "schema_version": 1,
        "created_utc": datetime.now(timezone.utc).isoformat(),
        "purpose": "Fresh single-path nominal fixed-timeline admission smoke",
        "manifest": str(args.manifest.resolve()),
        "manifest_sha256": manifest_hash,
        "source_map": str(args.sources.resolve()),
        "source_map_sha256": hashlib.sha256(args.sources.read_bytes()).hexdigest(),
        "source_hashes": source_hashes,
        "source_fingerprint": reset._source_fingerprint(source_hashes),
        "runner": str(Path(__file__).with_name("reset_campaign.py").resolve()),
        "runner_sha256": hashlib.sha256(
            Path(__file__).with_name("reset_campaign.py").read_bytes()
        ).hexdigest(),
        "path": args.path,
        "row_id": reset._row_id(row, row["condition"]),
        "timeout_s": args.timeout_s,
        "confirmation_data_accessed": False,
    }
    (args.output / "campaign.json").write_text(
        json.dumps(campaign, indent=2, sort_keys=True) + "\n"
    )
    result = reset._run_row(
        row, sources, source_hashes, args.output, False, args.timeout_s
    )
    record = {
        "schema_version": 1,
        "completed_utc": datetime.now(timezone.utc).isoformat(),
        "result": result,
        "admission_eligible": reset._results_are_valid([result]),
    }
    (args.output / "single_path_result.json").write_text(
        json.dumps(record, indent=2, sort_keys=True) + "\n"
    )
    print(json.dumps(record, sort_keys=True))
    return (
        0
        if result.get("execution_validity") == "pass"
        and result.get("scientific_validity") == "valid"
        else 1
    )


if __name__ == "__main__":
    raise SystemExit(main())
