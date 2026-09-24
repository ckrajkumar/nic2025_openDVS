#!/usr/bin/env python3
"""Consolidate hash-bound production Magic/Quantus extraction evidence."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import math
import re
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

PINS = [
    "pixRst[1]", "pixRst[0]", "rowReadON[1]", "rowReadON[0]",
    "rowReadOFF[1]", "rowReadOFF[0]", "readLine[1]", "readLine[0]",
    "vpd[3]", "vpd[2]", "vpd[1]", "vpd[0]", "VddA18", "GndA", "GndD",
    "OnBn", "OffBn", "DiffBn", "PrSFBp", "RefrBp", "PrBp",
]
EXPECTED = {
    "production_gds": "7f080d6e16f33d86803b0f8454c861af0cd21d8f2cb2d7954639d9534e53acea",
    "magic_composed": "1a0fd2e54436790b367672478e80f6cff1c73890306db47620dc71b8a99562d1",
    "magic_adapted": "c93cd8b0cad09088f8448eb687377f822f0a15cf6b7ef68c2344391f65330e9c",
    "magic_reset": "04283235bc8397d473af68f2f35c0a9232ea4ed5f003f22d7902c93881f3f5d8",
    "quantus_raw": "fce65d451d33d1ed86a66553381259f38c30f794a5d5c85a4ab15742fefa051d",
    "quantus_adapted": "b7b06ba057968e85facc4f97b965401bba961b274ad42072dc1c05c2f9b1d499",
    "quantus_corrected": "0668aca3082314fb885cb685e0f082f2e53096ede2e5b38aed00f5b0b93dfb9e",
    "schematic": "6453d01af285ebb688036192a8e527087b1cd066e3f3d43b2de94a8e44e1e3a2",
    "schematic_reset": "60ed15ddfb05644d62e2c4569e995e136cec9ce8b7ff0b92cb646c42345c9e36",
    "native_alias": "56dc6a66ee6b45d42af8e6b0e5ffcc38c38faecd47414db94f4e651fc71aac29",
    "mim_model": "0794014d550230556b1f3354c7e476afbeae155b2985bda4bfbece9d8443eaa8",
    "tt_rc": "3b1f8cbce726e224bb4afb365393f07140e4f7287d61662bd42cd096d9403d1b",
    "tt_cap": "aa793ec63ab459d26ef90afefde9601494ba6d4baa7311d6890d643b5c6cccc1",
}
MIM_EXPECTED = {
    "CC1a": {"width_um": 3.985, "length_um": 2.27, "capacitance_ff": 20.1383},
    "CC1b": {"width_um": 6.47, "length_um": 1.505, "capacitance_ff": 22.0887},
    "CC2": {"width_um": 1.0, "length_um": 1.0, "capacitance_ff": 2.64225},
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def load_json(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(value, dict):
        raise ValueError(f"expected object in {path}")
    return value


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def card_count(text: str, prefix: str) -> int:
    return sum(line.lstrip().upper().startswith(prefix) for line in text.splitlines())


def source_pins(text: str, name: str) -> list[str]:
    tokens: list[str] = []
    active = False
    for line in text.splitlines():
        stripped = line.strip()
        if not active:
            fields = stripped.split()
            if len(fields) >= 2 and fields[0].lower() == ".subckt" and fields[1].lower() == name.lower():
                tokens.extend(fields[2:])
                active = True
        elif stripped.startswith("+"):
            tokens.extend(stripped[1:].split())
        else:
            break
    return tokens


def mim_values(adapter_report: dict[str, Any]) -> tuple[dict[str, Any], bool]:
    grouped: dict[str, list[tuple[float, float]]] = {name: [] for name in MIM_EXPECTED}
    for record in adapter_report["mim_geometries"]:
        instance = record["instance"]
        name = next((key for key in MIM_EXPECTED if instance.endswith("/" + key)), None)
        if name is None:
            raise ValueError(f"unrecognized MIM instance {instance}")
        grouped[name].append((record["width_m"] * 1e6, record["length_m"] * 1e6))
    result: dict[str, Any] = {}
    passed = True
    for name, expected in MIM_EXPECTED.items():
        geometries = grouped[name]
        geometry_ok = len(geometries) == 4 and all(
            math.isclose(width, expected["width_um"], rel_tol=0, abs_tol=1e-12)
            and math.isclose(length, expected["length_um"], rel_tol=0, abs_tol=1e-12)
            for width, length in geometries
        )
        wc = expected["width_um"] - 0.025
        lc = expected["length_um"] - 0.025
        capacitance_ff = 2.00 * wc * lc + 2 * 0.19 * (wc + lc)
        value_ok = math.isclose(
            capacitance_ff, expected["capacitance_ff"], rel_tol=0, abs_tol=5e-12
        )
        result[name] = {
            "instances": len(geometries),
            "width_um": expected["width_um"],
            "length_um": expected["length_um"],
            "tt_27c_capacitance_ff": capacitance_ff,
            "geometry_pass": geometry_ok,
            "value_pass": value_ok,
        }
        passed = passed and geometry_ok and value_ok
    return result, passed


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--campaign-root", type=Path, required=True)
    parser.add_argument("--mim-model", type=Path, required=True)
    parser.add_argument("--tt-rc", type=Path, required=True)
    parser.add_argument("--tt-cap", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    root = args.campaign_root.resolve()
    extraction = root / "extraction/production_top_v1"
    sources = root / "sources"
    production = sources / "production_gds_v1"
    tooling = root / "tooling_v37"

    paths = {
        "production_gds": production / "openDVS_pixel2x2.gds",
        "magic_composed": production / "openDVS_pixel2x2_magic_rcc_composed.spice",
        "magic_adapted": production / "openDVS_pixel2x2_magic_rcc_ngspice.spice",
        "magic_reset": production / "openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.spice",
        "quantus_raw": production / "openDVS_pixel2x2_quantus_rcc.raw.spice",
        "quantus_adapted": production / "openDVS_pixel2x2_quantus_rcc_spectre.spice",
        "quantus_corrected": production / "openDVS_pixel2x2_quantus_rcc_spectre.junction_corrected.spice",
        "schematic": sources / "openDVS_pixel2x2.c1b_diode_corrected.spice",
        "schematic_reset": sources / "openDVS_pixel2x2.c1b_diode_corrected.reset_physical_pd_v2.spice",
        "native_alias": sources / "native_call_alias_adapter.spice",
        "mim_model": args.mim_model,
        "tt_rc": args.tt_rc,
        "tt_cap": args.tt_cap,
    }
    hashes = {name: sha256(path) for name, path in paths.items()}
    hash_checks = {name: hashes[name] == expected for name, expected in EXPECTED.items()}

    composition_path = extraction / "composition_report_v3.json"
    magic_adapter_path = extraction / "magic_ngspice_adapter.production_v2.json"
    quantus_adapter_path = extraction / "quantus_spectre_adapter_report.production_v1.json"
    junction_path = extraction / "quantus_junction_transfer.production_v2.json"
    rcx_path = extraction / "RCXspiceINIT"
    source_map_path = tooling / "source_map.rpgraca-ini.json"
    composition = load_json(composition_path)
    magic_adapter = load_json(magic_adapter_path)
    quantus_adapter = load_json(quantus_adapter_path)
    junction = load_json(junction_path)
    source_map = load_json(source_map_path)
    rcx = rcx_path.read_text(encoding="utf-8", errors="replace")
    corrected = paths["quantus_corrected"].read_text(encoding="utf-8", errors="replace")
    alias = paths["native_alias"].read_text(encoding="utf-8", errors="replace")

    reset_module = load_module("production_reset_derivation", tooling / "derive_reset_netlist.py")
    expected_magic_reset = reset_module.derive(
        "magic_rcc_ngspice", paths["magic_adapted"].read_bytes(), hashes["magic_adapted"]
    )
    expected_schematic_reset = reset_module.derive(
        "schematic_ngspice", paths["schematic"].read_bytes(), hashes["schematic"]
    )
    campaign_module = load_module("production_reset_campaign", tooling / "reset_campaign.py")
    _, verified_source_hashes = campaign_module._verify_sources(source_map_path)

    mim, mim_pass = mim_values(quantus_adapter)
    magic_inventory = magic_adapter["inventory"]
    quantus_inventory = quantus_adapter["inventory"]
    checks = {
        **{f"hash_{name}": value for name, value in hash_checks.items()},
        "source_map_all_hashes_verified_by_runner": bool(verified_source_hashes),
        "source_map_declares_no_confirmation_access": source_map["derivation"]["confirmation_data_accessed"] is False,
        "source_map_binds_production_gds": source_map["derivation"]["production_gds_sha256"] == hashes["production_gds"],
        "source_map_binds_magic": source_map["derivation"]["magic_rcc_sha256"] == hashes["magic_adapted"],
        "source_map_binds_corrected_quantus": source_map["derivation"]["quantus_corrected_sha256"] == hashes["quantus_corrected"],
        "magic_composition_accepted": composition["accepted"] is True,
        "magic_body_preserved": composition["body_preserved"] is True,
        "magic_composition_hash_chain": composition["output_sha256"] == hashes["magic_composed"],
        "magic_21_port_interface": composition["external_port_count"] == 21 and composition["external_ports"] == PINS,
        "magic_virtual_diffbn_wrapper": composition["wrapper_diffbn_actual_count"] == 3 and composition["repeated_wrapper_actuals"] == {"DiffBn": 3},
        "magic_topology_inventory": composition["body_card_counts"] == {"capacitors": 663, "devices": 96, "resistors": 3230},
        "magic_adapter_hash_chain": magic_adapter["source"]["sha256"] == hashes["magic_composed"] and magic_adapter["derived"]["sha256"] == hashes["magic_adapted"],
        "magic_adapter_preserves_rc_and_wrapper": magic_adapter["preservation"]["rc_cards_preserved"] == 3893 and magic_adapter["preservation"]["wrapper_topology_preserved"] is True,
        "magic_adapter_inventory": magic_inventory == {"capacitors": 663, "diodes": 4, "mim": 12, "mos": {"sky130_fd_pr__nfet_01v8": 44, "sky130_fd_pr__pfet_01v8": 28, "sky130_fd_pr__pfet_01v8_hvt": 8, "total": 80}, "resistors": 3230},
        "magic_reset_derivation_reproducible": expected_magic_reset == paths["magic_reset"].read_bytes(),
        "schematic_reset_derivation_reproducible": expected_schematic_reset == paths["schematic_reset"].read_bytes(),
        "quantus_adapter_hash_chain": quantus_adapter["input"]["sha256"] == hashes["quantus_raw"] and quantus_adapter["output"]["sha256"] == hashes["quantus_adapted"],
        "quantus_adapter_interface": quantus_adapter["top_ports"] == PINS,
        "quantus_adapter_inventory": quantus_inventory["distributed_resistors"] == 1175 and quantus_inventory["parasitic_capacitors"] == 9161 and quantus_inventory["mim_capacitors"] == 12 and quantus_inventory["photodiodes"] == 4 and sum(quantus_inventory["mos"].values()) == 80,
        "quantus_passivity": quantus_adapter["passivity_checks"]["all_parasitic_capacitors_finite_positive"] is True and quantus_adapter["passivity_checks"]["all_resistors_finite_positive"] is True,
        "junction_transfer_hash_chain": junction["inputs"]["fresh_magic"]["sha256"] == hashes["magic_composed"] and junction["inputs"]["quantus"]["sha256"] == hashes["quantus_adapted"] and junction["output"]["sha256"] == hashes["quantus_corrected"],
        "junction_transfer_full_coverage": junction["checks"]["fresh_magic_mos_count"] == 80 and junction["checks"]["quantus_mos_cards_changed"] == 80 and len(junction["mapping"]) == 80 and junction["checks"]["role_map_bijective"] is True,
        "junction_transfer_preserves_non_mos": junction["checks"]["non_mos_records_unchanged"] is True,
        "junction_transfer_order_and_geometry_equivalent": junction["checks"]["ordered_terminal_model_and_geometry_equivalence"] is True,
        "junction_transfer_has_registered_38_swaps": junction["checks"]["source_drain_swaps_applied"] == 38,
        "no_nrd_or_nrs_added_to_quantus_rcc": re.search(r"\bnr[ds]\s*=", corrected, re.IGNORECASE) is None,
        "corrected_quantus_card_counts": card_count(corrected, "R") == 1175 and card_count(corrected, "C") == 9161 and len(re.findall(r"(?mi)^X.*(?:nfet|pfet)", corrected)) == 80,
        "quantus_corrected_interface": source_pins(corrected, "openDVS_pixel2x2") == PINS,
        "native_mim_alias_passes_si_dimensions": "Xnative c0 c1 cap_mim_m3_1 l=l w=w mf=1" in alias,
        "production_mim_geometry_and_tt_values": mim_pass,
        "quantus_canonical_capacitance_not_duplicated": 'CAP_CORRECTION="N"' in rcx and 'CANONICAL_RES_CAPS="Y"' in rcx,
        "quantus_extraction_exit_zero": (extraction / "quantus.exit").read_text().strip() == "0",
    }
    passed = all(checks.values())
    result = {
        "schema_version": 1,
        "created_utc": datetime.now(timezone.utc).isoformat(),
        "certificate_verdict": "pass" if passed else "fail",
        "scope": "Production top-row 2x2 Magic RCC and Quantus RCC extraction, adapters, interface, MIM treatment, and junction transfer",
        "checks": checks,
        "source_hashes": hashes,
        "verified_campaign_source_hashes": verified_source_hashes,
        "evidence_hashes": {
            str(path.relative_to(root)): sha256(path)
            for path in (composition_path, magic_adapter_path, quantus_adapter_path, junction_path, rcx_path, source_map_path)
        },
        "inventories": {"magic": magic_inventory, "quantus": quantus_inventory},
        "mim_tt_27c": {
            "parameters": {"m3_dw_um": -0.025, "tol_m3_um": 0.0, "camimc_ff_per_um2": 2.0, "cpmimc_ff_per_um": 0.19},
            "devices": mim,
            "claim_boundary": "Values are native compact-model functional MIM capacitances; distributed RCC capacitances around the terminals are additional interconnect, fringe, coupling, and device capacitance.",
        },
        "junction_policy": junction["policy"],
        "junction_claim_boundary": junction["claim_boundary"],
        "extraction_claim_boundary": quantus_adapter["claim_boundary"],
        "confirmation_data_accessed": False,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    if not passed:
        failed = [name for name, value in checks.items() if not value]
        raise SystemExit("failed checks: " + ", ".join(failed))


if __name__ == "__main__":
    main()
