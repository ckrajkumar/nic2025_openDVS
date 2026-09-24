#!/usr/bin/env python3
"""Certify that the selected 2x2 is the production macro's top-row variant."""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path

import klayout.db as kdb

EXPECTED_MACRO_SHA256 = "209d312b041d3c48bd698cb549701a58fee506361b6d133c8d57d08e2bf05101"
EXPECTED_WRAPPER_SHA256 = "7c2179175152539731328659921f674012c829c6ac6a1f073185658395d224eb"
EXPECTED_SELECTED_SHA256 = "7f080d6e16f33d86803b0f8454c861af0cd21d8f2cb2d7954639d9534e53acea"
EXPECTED_PIXEL_TRANSFORMS = {
    "m90 6245,-310",
    "m0 -18075,-50",
    "r180 6245,-50",
    "r0 -18075,-310",
}
EXPECTED_VARIANT_DIFFERENCE_LAYERS = {"70/16", "70/20", "71/20"}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def load(path: Path) -> kdb.Layout:
    layout = kdb.Layout()
    layout.read(str(path))
    return layout


def child_inventory(layout: kdb.Layout, cell_name: str) -> dict[str, object]:
    cell = layout.cell(cell_name)
    if cell is None:
        raise ValueError(f"missing cell {cell_name}")
    children = [(layout.cell(inst.cell_index).name, str(inst.trans)) for inst in cell.each_inst()]
    return {
        "child_counts": dict(sorted(Counter(name for name, _ in children).items())),
        "openDVS_pixel_transforms": sorted(
            transform for name, transform in children if name == "openDVS_pixel"
        ),
    }


def region(layout: kdb.Layout, cell: kdb.Cell, layer: int, datatype: int) -> kdb.Region:
    index = layout.find_layer(layer, datatype)
    if index is None:
        return kdb.Region()
    value = kdb.Region(cell.begin_shapes_rec(index))
    value.merge()
    return value


def compare_cells(
    left_layout: kdb.Layout,
    left_name: str,
    right_layout: kdb.Layout,
    right_name: str,
) -> dict[str, object]:
    if left_layout.dbu != right_layout.dbu:
        raise ValueError("GDS database units differ")
    left = left_layout.cell(left_name)
    right = right_layout.cell(right_name)
    if left is None or right is None:
        raise ValueError("comparison cell is missing")
    layers = sorted(
        {
            (info.layer, info.datatype)
            for layout in (left_layout, right_layout)
            for info in layout.layer_infos()
        }
    )
    differences = []
    compared = 0
    for layer, datatype in layers:
        left_region = region(left_layout, left, layer, datatype)
        right_region = region(right_layout, right, layer, datatype)
        if left_region.is_empty() and right_region.is_empty():
            continue
        compared += 1
        difference = left_region ^ right_region
        difference.merge()
        if not difference.is_empty():
            differences.append(
                {
                    "layer": f"{layer}/{datatype}",
                    "xor_area_um2": difference.area() * left_layout.dbu**2,
                    "xor_polygons": difference.count(),
                }
            )
    return {
        "left_cell": left_name,
        "right_cell": right_name,
        "compared_nonempty_layers": compared,
        "differences": differences,
        "equal": not differences,
    }


def evidence(path: Path) -> dict[str, object]:
    record = json.loads(path.read_text(encoding="utf-8"))
    return {
        "path": str(path),
        "sha256": sha256(path),
        "reported_equal": record.get("equal"),
        "difference_layers": sorted(
            item["layer"] for item in record.get("layers", []) if not item.get("equal")
        ),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--macro-gds", type=Path, required=True)
    parser.add_argument("--selected-gds", type=Path, required=True)
    parser.add_argument("--authority-record", type=Path, required=True)
    parser.add_argument("--production-binding", type=Path, required=True)
    parser.add_argument("--normalized-top-evidence", type=Path, required=True)
    parser.add_argument("--top-bottom-evidence", type=Path, required=True)
    parser.add_argument("--macro-wrapper-top-evidence", type=Path, required=True)
    parser.add_argument("--macro-wrapper-bottom-evidence", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    macro_layout = load(args.macro_gds)
    selected_layout = load(args.selected_gds)
    macro_sha = sha256(args.macro_gds)
    selected_sha = sha256(args.selected_gds)
    authorities = json.loads(args.authority_record.read_text(encoding="utf-8"))
    binding = json.loads(args.production_binding.read_text(encoding="utf-8"))
    macro_inputs = {
        item["macro"]: item for item in binding.get("macro_inputs", []) if item.get("kind") == "gds"
    }

    macro_inventory = {
        name: child_inventory(macro_layout, name)
        for name in (
            "pixel_4tile",
            "pixel_layout_tile",
            "pixel_layout_tile_bot",
            "openDVS_pixel2x2_top",
            "openDVS_pixel2x2_bot",
        )
    }
    selected_inventory = child_inventory(selected_layout, "openDVS_pixel2x2")
    selected_matches_top = compare_cells(
        macro_layout, "openDVS_pixel2x2_top", selected_layout, "openDVS_pixel2x2"
    )
    variants = compare_cells(
        macro_layout,
        "openDVS_pixel2x2_top",
        macro_layout,
        "openDVS_pixel2x2_bot",
    )
    evidence_records = {
        "normalized_top_export": evidence(args.normalized_top_evidence),
        "top_vs_bottom": evidence(args.top_bottom_evidence),
        "macro_vs_wrapper_top": evidence(args.macro_wrapper_top_evidence),
        "macro_vs_wrapper_bottom": evidence(args.macro_wrapper_bottom_evidence),
    }

    checks = {
        "production_macro_hash": macro_sha == EXPECTED_MACRO_SHA256,
        "production_wrapper_hash": authorities["authorities"]["production_wrapper"]["sha256"]
        == EXPECTED_WRAPPER_SHA256,
        "selected_top_hash": selected_sha == EXPECTED_SELECTED_SHA256,
        "binding_selects_same_production_macro": macro_inputs["pixel_4tile"]["sha256"]
        == macro_sha,
        "selected_geometry_equals_production_top": selected_matches_top["equal"],
        "selected_and_production_top_have_same_pixel_transforms": set(
            selected_inventory["openDVS_pixel_transforms"]
        )
        == set(macro_inventory["openDVS_pixel2x2_top"]["openDVS_pixel_transforms"])
        == EXPECTED_PIXEL_TRANSFORMS,
        "production_top_has_four_pixel_instances": macro_inventory["openDVS_pixel2x2_top"][
            "child_counts"
        ].get("openDVS_pixel")
        == 4,
        "production_bottom_has_four_pixel_instances": macro_inventory["openDVS_pixel2x2_bot"][
            "child_counts"
        ].get("openDVS_pixel")
        == 4,
        "top_tile_uses_only_top_variant": macro_inventory["pixel_layout_tile"][
            "child_counts"
        ].get("openDVS_pixel2x2_top")
        == 1024
        and "openDVS_pixel2x2_bot"
        not in macro_inventory["pixel_layout_tile"]["child_counts"],
        "bottom_tile_uses_only_bottom_variant": macro_inventory["pixel_layout_tile_bot"][
            "child_counts"
        ].get("openDVS_pixel2x2_bot")
        == 1024
        and "openDVS_pixel2x2_top"
        not in macro_inventory["pixel_layout_tile_bot"]["child_counts"],
        "production_macro_has_two_top_and_two_bottom_tiles": macro_inventory["pixel_4tile"][
            "child_counts"
        ].get("pixel_layout_tile")
        == 2
        and macro_inventory["pixel_4tile"]["child_counts"].get("pixel_layout_tile_bot")
        == 2,
        "variant_difference_is_exactly_registered_layers": {
            item["layer"] for item in variants["differences"]
        }
        == EXPECTED_VARIANT_DIFFERENCE_LAYERS,
        "normalized_export_evidence_passes": evidence_records["normalized_top_export"][
            "reported_equal"
        ]
        is True,
        "macro_wrapper_top_evidence_passes": evidence_records["macro_vs_wrapper_top"][
            "reported_equal"
        ]
        is True,
        "macro_wrapper_bottom_evidence_passes": evidence_records["macro_vs_wrapper_bottom"][
            "reported_equal"
        ]
        is True,
        "top_bottom_evidence_matches_fresh_comparison": set(
            evidence_records["top_vs_bottom"]["difference_layers"]
        )
        == EXPECTED_VARIANT_DIFFERENCE_LAYERS,
    }
    passed = all(checks.values())
    result = {
        "schema_version": 1,
        "created_utc": datetime.now(timezone.utc).isoformat(),
        "certificate_verdict": "pass" if passed else "fail",
        "selection": {
            "selected_cell": "openDVS_pixel2x2",
            "production_role": "top-row 2x2 variant",
            "source_cell": "openDVS_pixel2x2_top",
            "scope_boundary": (
                "This campaign characterizes the production top-row 2x2 variant. "
                "The bottom-row variant is separately present in production and differs "
                "on layers 70/16, 70/20, and 71/20; it is not claimed equivalent."
            ),
        },
        "hashes": {
            "production_macro_gds": macro_sha,
            "production_wrapper_gds": authorities["authorities"]["production_wrapper"][
                "sha256"
            ],
            "selected_normalized_top_gds": selected_sha,
            "authority_record": sha256(args.authority_record),
            "production_binding": sha256(args.production_binding),
        },
        "checks": checks,
        "macro_inventory": macro_inventory,
        "selected_inventory": selected_inventory,
        "selected_matches_top": selected_matches_top,
        "top_bottom_comparison": variants,
        "evidence": evidence_records,
        "confirmation_data_accessed": False,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    if not passed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
