#!/usr/bin/env python3
"""Issue a hash-bound structural certificate for the three nominal reset decks."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path

PINS = [
    "pixRst[1]",
    "pixRst[0]",
    "rowReadON[1]",
    "rowReadON[0]",
    "rowReadOFF[1]",
    "rowReadOFF[0]",
    "readLine[1]",
    "readLine[0]",
    "vpd[3]",
    "vpd[2]",
    "vpd[1]",
    "vpd[0]",
    "VddA18",
    "GndA",
    "GndD",
    "OnBn",
    "OffBn",
    "DiffBn",
    "PrSFBp",
    "RefrBp",
    "PrBp",
]
DUT_NODES = [
    "0",
    "pixrst",
    "0",
    "pixrst",
    "0",
    "0",
    "0",
    "0",
    "vpd3",
    "vpd2",
    "vpd1",
    "vpd0",
    "VddA18",
    "0",
    "0",
    "OnBn",
    "OffBn",
    "DiffBn",
    "PrSFBp",
    "RefrBp",
    "PrBp",
]
PWL = "VresetController pixrst 0 PWL(0 1.8 0.001 1.8 0.00100001 0 45 0 45.00000001 1.8 45.001 1.8 45.00100001 0 45.5 0)"
FET_MODELS = {
    "sky130_fd_pr__nfet_01v8",
    "sky130_fd_pr__pfet_01v8",
    "sky130_fd_pr__pfet_01v8_hvt",
}
PD_MODEL = "sky130_fd_pr__model__parasitic__diode_ps2dn"
MIM_MODEL = "sky130_fd_pr__cap_mim_m3_1"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def logical_records(text: str) -> list[list[str]]:
    records: list[list[str]] = []
    for line in text.splitlines():
        stripped = line.strip()
        if stripped.startswith("+"):
            if not records:
                raise ValueError("orphan continuation")
            records[-1].extend(stripped[1:].split())
        elif stripped:
            records.append(stripped.split())
    return records


def subckt_pins(records: list[list[str]], name: str) -> list[str]:
    matches = [record for record in records if len(record) >= 2 and record[0].lower() == ".subckt" and record[1].lower() == name.lower()]
    if len(matches) != 1:
        raise ValueError(f"expected one {name} subcircuit, found {len(matches)}")
    return matches[0][2:]


def numeric(value: str) -> float:
    suffixes = {"u": 1e-6, "p": 1e-12, "n": 1e-9, "m": 1e-3, "f": 1e-15}
    match = re.fullmatch(r"([+-]?[\d.eE+-]+)([upnmf]?)", value, re.IGNORECASE)
    if not match:
        raise ValueError(value)
    return float(match.group(1)) * suffixes.get(match.group(2).lower(), 1.0)


class UnionFind:
    def __init__(self) -> None:
        self.parent: dict[str, str] = {}

    def find(self, value: str) -> str:
        key = value.lower()
        self.parent.setdefault(key, key)
        if self.parent[key] != key:
            self.parent[key] = self.find(self.parent[key])
        return self.parent[key]

    def union(self, left: str, right: str) -> None:
        a, b = self.find(left), self.find(right)
        if a != b:
            self.parent[b] = a


def flat_inventory(path: Path) -> tuple[dict[str, object], UnionFind, list[list[str]]]:
    records = logical_records(path.read_text())
    union = UnionFind()
    for record in records:
        if len(record) == 4 and record[0][0:1].lower() == "r":
            union.union(record[1], record[2])
    fets = [record for record in records if any(token.lower() in FET_MODELS for token in record)]
    mims = [record for record in records if any(token.lower() == MIM_MODEL for token in record)]
    diodes = [record for record in records if any(token.lower() == PD_MODEL for token in record)]
    resistors = [record for record in records if len(record) == 4 and re.fullmatch(r"r\S+", record[0], re.IGNORECASE)]
    extracted_caps = [record for record in records if len(record) == 4 and re.fullmatch(r"c\d+", record[0], re.IGNORECASE)]

    junction_keys = {"ad", "as", "pd", "ps"}
    explicit_junction = 0
    bulk_failures: list[dict[str, str]] = []
    for record in fets:
        model_index = next(index for index, token in enumerate(record) if token.lower() in FET_MODELS)
        model = record[model_index].lower()
        if model_index < 5:
            raise ValueError(f"malformed FET card: {record}")
        params = {token.split("=", 1)[0].lower(): token.split("=", 1)[1] for token in record[model_index + 1 :] if "=" in token}
        if junction_keys <= params.keys():
            explicit_junction += 1
        expected_bulk = "gnda" if "nfet" in model else "vdda18"
        if union.find(record[4]) != union.find(expected_bulk):
            bulk_failures.append({"instance": record[0], "bulk": record[4], "expected_component": expected_bulk})

    mim_geometry = Counter()
    for record in mims:
        model_index = next(index for index, token in enumerate(record) if token.lower() == MIM_MODEL)
        params = {token.split("=", 1)[0].lower(): numeric(token.split("=", 1)[1]) for token in record[model_index + 1 :] if "=" in token}
        if not {"l", "w"} <= params.keys():
            raise ValueError(f"MIM lacks L/W: {record}")
        dimensions_um = sorted((round(params["l"] * (1e6 if params["l"] < 1e-3 else 1.0), 6), round(params["w"] * (1e6 if params["w"] < 1e-3 else 1.0), 6)))
        mim_geometry[tuple(dimensions_um)] += 1

    diode_failures: list[list[str]] = []
    for record in diodes:
        params = {token.split("=", 1)[0].lower(): token.split("=", 1)[1] for token in record if "=" in token}
        if params.get("area") != "32.49" or params.get("pj") != "22.8" or params.get("m") != "1":
            diode_failures.append(record)

    return (
        {
            "path": str(path),
            "sha256": sha256(path),
            "ordered_top_pins": subckt_pins(records, "openDVS_pixel2x2"),
            "ordered_top_pins_match": subckt_pins(records, "openDVS_pixel2x2") == PINS,
            "fet_count": len(fets),
            "fet_cards_with_explicit_ad_as_pd_ps": explicit_junction,
            "fet_bulk_failures": bulk_failures,
            "mim_count": len(mims),
            "mim_geometry_um": {" x ".join(map(str, key)): value for key, value in sorted(mim_geometry.items())},
            "photodiode_count": len(diodes),
            "photodiode_property_failures": diode_failures,
            "distributed_resistor_count": len(resistors),
            "extracted_capacitor_count": len(extracted_caps),
        },
        union,
        fets,
    )


def find_fet(fets: list[list[str]], instance: str) -> list[str]:
    matches = [record for record in fets if record[0].lower() == instance.lower()]
    if len(matches) != 1:
        raise ValueError(f"expected one {instance}, found {len(matches)}")
    return matches[0]


def component_check(union: UnionFind, actual: str, expected: str) -> bool:
    return union.find(actual) == union.find(expected)


def quantus_reset_chain(union: UnionFind, fets: list[list[str]]) -> dict[str, object]:
    expected = {
        "XxPix[0]/xrst/MMPDrefrCol": ("xPix[0]/nRst", "pixRst[0]", "xPix[0]/xrst/net1", "GndA"),
        "XxPix[0]/xrst/MMPDRefrRow": ("xPix[0]/xrst/net1", "rowReadON[0]", "GndA", "GndA"),
        "XxPix[0]/xrst/MMrefrBias": ("xPix[0]/nRst", "RefrBp", "VddA18", "VddA18"),
        "XxPix[0]/xrst/MMcapRefr": ("VddA18", "xPix[0]/nRst", "VddA18", "VddA18"),
        "XxPix[0]/xchAmp/MMrst": ("xPix[0]/vdiff", "xPix[0]/nRst", "xPix[0]/xchAmp/vd", "VddA18"),
    }
    checks: dict[str, object] = {}
    for instance, terminals in expected.items():
        record = find_fet(fets, instance)
        actual = record[1:5]
        checks[instance] = {
            "actual_terminals": actual,
            "expected_components": list(terminals),
            "component_match": all(component_check(union, a, e) for a, e in zip(actual, terminals)),
        }
    return checks


def magic_reset_chain(union: UnionFind, fets: list[list[str]]) -> dict[str, object]:
    targets = {
        "column_reset": ("pixRst[0]", {"openDVS_pixel_0.nRst", "a_n3520_435#"}, "GndA"),
        "row_reset": ("rowReadON[0]", {"a_n3520_435#", "GndA"}, "GndA"),
        "refractory_bias": ("RefrBp", {"openDVS_pixel_0.nRst", "VddA18"}, "VddA18"),
        "reset_capacitor_fet": ("openDVS_pixel_0.nRst", {"VddA18"}, "VddA18"),
        "change_amplifier_reset": ("openDVS_pixel_0.nRst", {"openDVS_pixel_0.vdiff", "openDVS_pixel_0.vd"}, "VddA18"),
    }
    checks: dict[str, object] = {}
    for name, (gate, diffusion, bulk) in targets.items():
        matches = []
        for record in fets:
            actual_diffusion = {union.find(record[1]), union.find(record[3])}
            expected_diffusion = {union.find(node) for node in diffusion}
            if component_check(union, record[2], gate) and actual_diffusion == expected_diffusion and component_check(union, record[4], bulk):
                matches.append(record[0])
        checks[name] = {"matching_instances": matches, "unique_match": len(matches) == 1}
    return checks


def condition_json(text: str) -> dict[str, object]:
    match = re.search(r"^[*/ ]*CONDITION_JSON (\{.*\})$", text, re.MULTILINE)
    if not match:
        raise ValueError("missing CONDITION_JSON")
    return json.loads(match.group(1))


def deck_inventory(path: Path, expected_monitor: str) -> dict[str, object]:
    text = path.read_text()
    records = logical_records(text)
    dut = [record for record in records if record and record[0].lower() == "xpix2x2"]
    includes = [record[1] for record in records if len(record) == 2 and record[0].lower() == ".include"]
    monitor_ok = expected_monitor.lower() in text.lower()
    return {
        "path": str(path),
        "sha256": sha256(path),
        "condition": condition_json(text),
        "pwl_match": PWL.lower() in text.lower(),
        "dut_count": len(dut),
        "dut_nodes": dut[0][1:-1] if len(dut) == 1 else [],
        "dut_binding_match": len(dut) == 1 and [node.lower() for node in dut[0][1:-1]] == [node.lower() for node in DUT_NODES],
        "dut_subcircuit": dut[0][-1] if len(dut) == 1 else None,
        "include_paths": includes,
        "logical_pixel_zero_monitor": expected_monitor,
        "logical_pixel_zero_monitor_present": monitor_ok,
        "saved_public_monitors_present": all(name.lower() in text.lower() for name in ("onsense", "nrstsense", "vdiffsense")),
    }


def condition_envelope(condition: dict[str, object]) -> dict[str, object]:
    return {
        key: condition[key]
        for key in ("biases_a", "corner", "initial_state", "optical", "temperature_c", "vdd_v")
    } | {"timeline": condition["stimulus"]["timeline"]}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--schematic-source", type=Path, required=True)
    parser.add_argument("--magic-source", type=Path, required=True)
    parser.add_argument("--quantus-source", type=Path, required=True)
    parser.add_argument("--adapter", type=Path, required=True)
    parser.add_argument("--schematic-deck", type=Path, required=True)
    parser.add_argument("--magic-deck", type=Path, required=True)
    parser.add_argument("--quantus-deck", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    schematic_records = logical_records(args.schematic_source.read_text())
    schematic_fets = [record for record in schematic_records if any(token.lower() in FET_MODELS for token in record)]
    schematic_mims = [record for record in schematic_records if any(token.lower() == MIM_MODEL for token in record)]
    schematic_diodes = [record for record in schematic_records if any(token.lower() == PD_MODEL for token in record)]
    schematic = {
        "path": str(args.schematic_source),
        "sha256": sha256(args.schematic_source),
        "ordered_top_pins": subckt_pins(schematic_records, "openDVS_pixel2x2"),
        "ordered_top_pins_match": subckt_pins(schematic_records, "openDVS_pixel2x2") == PINS,
        "fet_definitions_per_pixel": len(schematic_fets),
        "effective_fet_count_for_four_pixels": len(schematic_fets) * 4,
        "fet_definitions_with_explicit_ad_as_pd_ps": sum(
            all(re.search(rf"\b{key}=", " ".join(record), re.IGNORECASE) for key in ("ad", "as", "pd", "ps")) for record in schematic_fets
        ),
        "mim_definitions_per_pixel": len(schematic_mims),
        "effective_mim_count_for_four_pixels": len(schematic_mims) * 4,
        "photodiode_definitions_per_pixel": len(schematic_diodes),
        "effective_photodiode_count_for_four_pixels": len(schematic_diodes) * 4,
        "logical_pixel_zero_instance_present": any(record[0].lower() == "xpix[0]" for record in schematic_records),
        "pixel_reset_subcircuit_present": subckt_pins(schematic_records, "PixelResetGen") == ["rowRst", "GndA", "colRst", "nRst", "RefrBp", "VddA18"],
    }
    magic, magic_union, magic_fets = flat_inventory(args.magic_source)
    quantus, quantus_union, quantus_fets = flat_inventory(args.quantus_source)
    magic["logical_pixel_zero_physical_hierarchy"] = "openDVS_pixel_0"
    magic["physical_to_logical_pixel_map"] = {
        "openDVS_pixel_0": "xPix[0]",
        "openDVS_pixel_1": "xPix[3]",
        "openDVS_pixel_2": "xPix[1]",
        "openDVS_pixel_3": "xPix[2]",
    }
    magic["reset_chain"] = magic_reset_chain(magic_union, magic_fets)
    quantus["logical_pixel_zero_hierarchy"] = "xPix[0]"
    quantus["reset_chain"] = quantus_reset_chain(quantus_union, quantus_fets)

    decks = {
        "schematic": deck_inventory(args.schematic_deck, "xpix2x2.xpix[0].ON"),
        "magic": deck_inventory(args.magic_deck, "xpix2x2.xdiffbn_physical_core.openDVS_pixel_0.ON"),
        "quantus": deck_inventory(args.quantus_deck, "Xpix2x2.xPix[0]/ON"),
    }
    envelopes = {name: condition_envelope(record["condition"]) for name, record in decks.items()}
    matched_envelope = len({json.dumps(value, sort_keys=True) for value in envelopes.values()}) == 1
    source_claims = {}
    for name, deck in decks.items():
        text = Path(deck["path"]).read_text()
        match = re.search(r"^[*/ ]*SOURCE_CLAIM (\{.*\})$", text, re.MULTILINE)
        source_claims[name] = json.loads(match.group(1)) if match else None

    adapter_text = args.adapter.read_text()
    adapter_defaults_zero = all(
        re.search(rf"\.param[^\n]*\b{key}=0(?:\s|$)", adapter_text, re.IGNORECASE)
        for key in ("ad", "as", "pd", "ps")
    )
    topology_pass = all(
        (
            schematic["ordered_top_pins_match"],
            magic["ordered_top_pins_match"],
            quantus["ordered_top_pins_match"],
            matched_envelope,
            *(record["pwl_match"] and record["dut_binding_match"] and record["logical_pixel_zero_monitor_present"] for record in decks.values()),
            not magic["fet_bulk_failures"],
            not quantus["fet_bulk_failures"],
            *(record["unique_match"] for record in magic["reset_chain"].values()),
            *(record["component_match"] for record in quantus["reset_chain"].values()),
        )
    )
    device_property_pass = (
        magic["fet_cards_with_explicit_ad_as_pd_ps"] == 80
        and (
            quantus["fet_cards_with_explicit_ad_as_pd_ps"] == 80
            or not adapter_defaults_zero
        )
    )
    result = {
        "schema_version": 1,
        "created_utc": datetime.now(timezone.utc).isoformat(),
        "expected_ordered_pins": PINS,
        "sources": {"schematic": schematic, "magic": magic, "quantus": quantus},
        "adapter": {"path": str(args.adapter), "sha256": sha256(args.adapter), "junction_defaults_zero": adapter_defaults_zero},
        "decks": decks,
        "source_claims": source_claims,
        "matched_condition_envelope": matched_envelope,
        "topology_and_binding_pass": topology_pass,
        "device_property_pass": device_property_pass,
        "certificate_verdict": "pass" if topology_pass and device_property_pass else "fail",
        "failure_reasons": ([] if topology_pass else ["topology, binding, bulk, reset-chain, or condition-envelope check failed"])
        + ([] if device_property_pass else ["Quantus MOS cards omit AD/AS/PD/PS and the native adapter supplies zero defaults"]),
        "claim_boundary": "Photodiodes remain engineering surrogates because the PVS deck excluded the four areaid.photo devices.",
        "confirmation_data_accessed": False,
    }
    args.output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
