#!/usr/bin/env python3
"""Certify the fresh production PVS match and its explicit amendment boundary."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from datetime import datetime, timezone
from pathlib import Path

EXPECTED_GDS_SHA256 = "7f080d6e16f33d86803b0f8454c861af0cd21d8f2cb2d7954639d9534e53acea"
EXPECTED_PINS = 21
EXPECTED_LAYOUT_INSTANCES = 92
EXPECTED_SCHEMATIC_INSTANCES = 92
EXPECTED_MOS = 80
EXPECTED_MIM = 12


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def logical_records(text: str) -> list[list[str]]:
    records: list[list[str]] = []
    for line in text.splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith("*"):
            continue
        if stripped.startswith("+"):
            records[-1].extend(stripped[1:].split())
        else:
            records.append(stripped.split())
    return records


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--gds", type=Path, required=True)
    parser.add_argument("--source-cdl", type=Path, required=True)
    parser.add_argument("--rules", type=Path, required=True)
    parser.add_argument("--exit", dest="exit_file", type=Path, required=True)
    parser.add_argument("--log", type=Path, required=True)
    parser.add_argument("--report", type=Path, required=True)
    parser.add_argument("--comparison", type=Path, required=True)
    parser.add_argument("--invocation", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    log = args.log.read_text(encoding="utf-8", errors="replace")
    report = args.report.read_text(encoding="utf-8", errors="replace")
    comparison = args.comparison.read_text(encoding="utf-8", errors="replace")
    rules = args.rules.read_text(encoding="utf-8", errors="replace")
    source = args.source_cdl.read_text(encoding="utf-8", errors="replace")
    invocation = args.invocation.read_text(encoding="utf-8", errors="replace")
    records = logical_records(source)
    mos_definitions = [
        record
        for record in records
        if record[0].lower().startswith("mm")
        and any("fet_01v8" in token.lower() for token in record)
    ]
    mim_definitions = [
        record
        for record in records
        if record[0].lower().startswith("cc")
        and any("cap_mim_m3" in token.lower() for token in record)
    ]
    diode_definitions = [
        record
        for record in records
        if record[0].lower().startswith("dd")
        or any("diode" in token.lower() for token in record)
    ]

    checks = {
        "fresh_process_exit_zero": args.exit_file.read_text(encoding="utf-8").strip() == "0",
        "selected_production_gds_hash": sha256(args.gds) == EXPECTED_GDS_SHA256,
        "pvs_summary_reports_match": "# Run Result             : MATCH" in log,
        "top_cell_has_92_to_92_instance_match": re.search(
            r"Top Cell\s+openDVS_pixel2x2\s+vs\s+openDVS_pixel2x2\s+92 insts vs 92 insts.*-match",
            log,
        )
        is not None,
        "comparison_reports_match": "#####  Run Result                    :   MATCH" in comparison,
        "comparison_has_no_mismatched_cells": re.search(
            r"Cells which mismatch\s+\|\s+0", comparison
        )
        is not None,
        "comparison_has_21_to_21_pins": re.search(
            r"openDVS_pixel2x2\s+\|\s+21\s+:\s+21\s+\|\s+21\s+:\s+21\s+\|\s+match",
            comparison,
        )
        is not None,
        "source_effective_mos_count": len(mos_definitions) * 4 == EXPECTED_MOS,
        "source_effective_mim_count": len(mim_definitions) * 4 == EXPECTED_MIM,
        "source_cdl_omits_photodiode_cards": not diode_definitions,
        "rules_state_photodiode_generation_is_unavailable": (
            "// Create Photodiode and PhotoArray" in rules
            and "// Can't do right now, DRM missing information" in rules
            and "// Excluding PhotoArray for now" in rules
        ),
        "diffbn_virtual_connection_is_reported": (
            "Label \"DiffBn\"" in report and "have been connected internally" in report
        ),
        "diffbn_virtual_connect_is_in_rules": (
            "virtual_connect -name DiffBn" in rules
            and "virtual_connect -report yes" in rules
            and "virtual_connect -depth primary" in rules
        ),
        "invocation_binds_selected_gds": str(args.gds) in invocation
        or "openDVS_pixel2x2.gds" in invocation,
        "invocation_binds_recorded_source_cdl": args.source_cdl.name in invocation,
        "invocation_binds_recorded_rules": args.rules.name in invocation,
        "no_pvs_fatal_run_error": "PVS Comparison Finished." in log,
    }
    passed = all(checks.values())
    result = {
        "schema_version": 1,
        "created_utc": datetime.now(timezone.utc).isoformat(),
        "certificate_verdict": "pass" if passed else "fail",
        "classification": "amended_match" if passed else "uncertified",
        "summary": {
            "layout_instances": EXPECTED_LAYOUT_INSTANCES,
            "schematic_instances": EXPECTED_SCHEMATIC_INSTANCES,
            "pins": EXPECTED_PINS,
            "effective_mos_devices": len(mos_definitions) * 4,
            "effective_mim_devices": len(mim_definitions) * 4,
            "source_photodiode_cards": len(diode_definitions),
        },
        "checks": checks,
        "hashes": {
            "selected_gds": sha256(args.gds),
            "source_cdl": sha256(args.source_cdl),
            "rules": sha256(args.rules),
            "exit": sha256(args.exit_file),
            "log": sha256(args.log),
            "extraction_report": sha256(args.report),
            "comparison_report": sha256(args.comparison),
            "invocation": sha256(args.invocation),
        },
        "claim_boundary": (
            "PVS proves a 92-device, 21-pin MOS-plus-MIM match after virtually "
            "connecting the three layout DiffBn islands. It is not clean full-design "
            "LVS because the installed SKY130 rules explicitly cannot generate the "
            "areaid.photo photodiodes; both compared sides therefore omit all four. "
            "Simulation restores them only as separately registered engineering surrogates."
        ),
        "confirmation_data_accessed": False,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    if not passed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
