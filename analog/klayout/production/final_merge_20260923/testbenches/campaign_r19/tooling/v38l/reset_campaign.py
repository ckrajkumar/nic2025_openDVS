"""Generate, run, and classify the fixed-timeline reset-transient campaign.

The manifest owns the condition identity.  Every path receives one explicit
absolute reset waveform, independent of ON and nRst.  The registered CACE
postprocessor is retained as a labelled metric calculation, not as control
feedback.  Automatic-read rows are deliberately not accepted by any selection
or execution path here.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import math
import os
import re
import shlex
import statistics
import sys
from pathlib import Path
from typing import Any


def _load_sibling(name: str, filename: str):
    path = Path(__file__).with_name(filename)
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load campaign helper from {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


_STATIC = _load_sibling("_full_pvt_static_campaign", "static_campaign.py")
_MANIFEST = _STATIC._MANIFEST_CONTRACT
_DERIVE = _load_sibling("_reset_netlist_derivation", "derive_reset_netlist.py")

_FROZEN_NGSPICE_STARTUP = """* CACE-aligned NGSPICE startup settings
set ngbehavior=hsa
set skywaterpdk
set ng_nomodcheck
set num_threads=1
option noinit
* Linear solver remains at the NGSPICE default (SPARSE 1.3)
"""

# Reuse the static campaign's source identity where the two campaigns consume
# the same file.  The reset waveform is part of every manifest row and rendered
# directly, so there is no simulator-specific controller source.
SOURCE_HASHES = dict(_STATIC.SOURCE_HASHES)
SOURCE_HASHES["quantus_netlist"] = (
    "842cc5e2d846ef6a1cf4ead139235f378a2518e0067f65b3c3d834135241484a"
)
SOURCE_HASHES["ngspice_model_library"] = (
    "48de7c677e2c6e7d09b2559279de9f818be71010a4aa933d728eb4db3b133c84"
)
SOURCE_HASHES["ngspice_parasitic_diode_model"] = (
    "47f9c12a2ff58b5602906873474b9a305e42bee36b09154cb7bf36b9002f5792"
)
SOURCE_HASHES.update(
    {
        "magic_reset_netlist": "74c494940fe72631b241006894bf37f25fdf3d9bd97edb9b75aceb77e406a32c",
        "schematic_reset_netlist": "60ed15ddfb05644d62e2c4569e995e136cec9ce8b7ff0b92cb646c42345c9e36",
        "ngspice_nonfet_corner_tt": "9e442b3828f29c8cf0a4d030c37b913fae11a23b00b58a4622d8bdf6909b56dd",
        "ngspice_nonfet_corner_ss": "7aa4c20bf9cc7d8e16239ccc750e435433f959123a2e6c2214a549f0f76395b1",
        "ngspice_nonfet_corner_ff": "d03e3604898888b64c71a6ddba5f03dd8a05b298ac6a10a5dc2ae1c01ab73a74",
        "ngspice_nonfet_corner_sf": "4f790eb5083d1e202820839b58099c423fc5aa83e6ede764b14e5eb70c8397f8",
        "ngspice_nonfet_corner_fs": "739c7e8da3ef68d2452f8f5e7a0f9d6696b8ee22cf58c4904e3bfa637fc23014",
    }
)
TOOLCHAIN_HASHES = dict(_STATIC.TOOLCHAIN_HASHES)
TOOLCHAIN_HASHES["psf_binary"] = (
    "97693f47ec868a5669693c31efbb3a54a04afff0cba4bcd6f66c14808b3dbbaa"
)

_PATHS = tuple(_MANIFEST.PATHS)
_BIAS_NAMES = tuple(_MANIFEST.BIAS_NAMES)
_TOP_PORTS = tuple(_STATIC._TOP_PORTS)
_RESET_ANALYSIS = "reset_transient"
_COMMENT = {
    "quantus_rcc_spectre": "//",
    "magic_rcc_ngspice": "*",
    "schematic_ngspice": "*",
}
_RESET_TRACES = ("vdd", "pixrst", "on", "nrst", "vdiff")
_DISCOVERY_KEYS = ("nrst_crossing_s", "second_reset_rise_s", "second_reset_fall_s")
_EDGE_LINE_LIMIT = 4000
_RESET_SPEC_LIMITS = {
    "refractory_period": (0.1e-6, 1000e-6),
    "delta_vdiff_ci": (-50e-3, 50e-3),
    "leak_event_period": (50e-3, 40.0),
    "min_reset_time": (0.01e-6, 100e-6),
}
_NUMBER = r"[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eEdD][+-]?\d+)?"
_COMPLETION_RE = re.compile(
    r"spectre completes with (\d+) errors?, (\d+) warnings?, and (\d+) notices?",
    re.IGNORECASE,
)
# The earlier-geometry extreme-corner nodesets are deliberately excluded.
# Fresh production-GDS witnesses may be registered here only after reacquisition.
_MAGIC_EXTREME_NODESET_WITNESSES: dict[
    tuple[str, float, int], tuple[str, str, tuple[tuple[int, str, str], ...]]
] = {}


def _canonical_json(value: Any) -> str:
    return _STATIC._canonical_json(value)


def _row_id(row: dict[str, Any], condition: dict[str, Any]) -> str:
    expected = (
        "row-" + hashlib.sha256(_canonical_json(condition).encode("utf-8")).hexdigest()
    )
    actual = row.get("row_id")
    if actual is not None and actual != expected:
        raise ValueError("row_id is not derived from the complete condition")
    return actual or expected


def _condition(row: dict[str, Any]) -> dict[str, Any]:
    if not isinstance(row, dict):
        raise ValueError("row must be an object")
    condition = row.get("condition")
    if not isinstance(condition, dict):
        raise ValueError("row.condition must be an object")
    if condition.get("analysis") != _RESET_ANALYSIS:
        raise ValueError("only reset_transient rows are supported")
    # The manifest validator contains the frozen complete condition contract.
    _MANIFEST._validate_condition(condition, "row.condition")
    path = condition["path"]
    if path not in _PATHS:
        raise ValueError(f"unsupported simulation path: {path}")
    expected_simulator = "spectre" if path == "quantus_rcc_spectre" else "ngspice"
    expected_view = {
        "quantus_rcc_spectre": "quantus_rcc",
        "magic_rcc_ngspice": "magic_rcc",
        "schematic_ngspice": "schematic",
    }[path]
    if (
        condition["simulator"] != expected_simulator
        or condition["view"] != expected_view
    ):
        raise ValueError("row condition simulator/view does not match its path")
    _fixed_reset_timeline(condition)
    source = row.get("source")
    if source != _MANIFEST.SOURCE_DEFINITIONS[path]:
        raise ValueError(
            "row.source does not match the frozen path source identity and hash"
        )
    _row_id(row, condition)
    return condition


def reset_rows(manifest: dict[str, Any]) -> list[dict[str, Any]]:
    """Return exactly the 45 reset rows for each of the three paths."""
    if not isinstance(manifest, dict) or not isinstance(manifest.get("rows"), list):
        raise ValueError("manifest.rows must be an array")
    selected: list[dict[str, Any]] = []
    for row in manifest["rows"]:
        if isinstance(row, dict) and isinstance(row.get("condition"), dict):
            if row["condition"].get("analysis") == _RESET_ANALYSIS:
                _condition(row)
                execution = row.get("execution", {})
                if (
                    isinstance(execution, dict)
                    and execution.get("eligible") is not True
                ):
                    raise ValueError("reset row is not execution eligible")
                selected.append(row)
    if len(selected) != len(_PATHS) * 45:
        raise ValueError("manifest does not contain exactly 45 reset rows per path")
    return selected


def _pending_reset_rows(manifest: dict[str, Any]) -> list[dict[str, Any]]:
    return [
        row
        for row in reset_rows(manifest)
        if row.get("execution", {}).get("state") == "pending"
        and row.get("execution", {}).get("eligible") is True
    ]


pending_reset_rows = _pending_reset_rows


def select_pilot_rows(manifest: dict[str, Any], rung: str) -> list[dict[str, Any]]:
    """Select the exact nominal or registered-extreme reset pilot rung."""
    if rung not in {"nominal", "extremes"}:
        raise ValueError(
            f"unsupported pilot rung: {rung!r}; expected nominal or extremes"
        )
    target = (
        {("tt", 1.8, 27)} if rung == "nominal" else {("ss", 1.62, 0), ("ff", 1.98, 70)}
    )
    return [
        row
        for row in _pending_reset_rows(manifest)
        if (
            row["condition"]["corner"],
            row["condition"]["vdd_v"],
            row["condition"]["temperature_c"],
        )
        in target
    ]


def _selected_rows_base(manifest: dict[str, Any], rung: str) -> list[dict[str, Any]]:
    if rung == "all":
        return _pending_reset_rows(manifest)
    return select_pilot_rows(manifest, rung)


ROW_FILTER = {"paths": None, "shard": None}


def _selected_rows_filter(rows):
    if ROW_FILTER["paths"]:
        rows = [r for r in rows if r["condition"]["path"] in ROW_FILTER["paths"]]
    if ROW_FILTER["shard"]:
        k, n = ROW_FILTER["shard"]
        rows = [r for i, r in enumerate(rows) if i % n == k]
    return rows


def _selected_rows(manifest, rung):
    rows = _selected_rows_base(manifest, rung)
    if ROW_FILTER["paths"]:
        rows = [r for r in rows if r["condition"]["path"] in ROW_FILTER["paths"]]
    if ROW_FILTER["shard"]:
        k, n = ROW_FILTER["shard"]
        rows = [r for i, r in enumerate(rows) if i % n == k]
    return rows


def _source_path(sources: dict[str, str], key: str) -> str:
    return _STATIC._source_path(sources, key)


def _spice_value(value: Any) -> str:
    return _STATIC._spice_value(value)


def _plain(value: Any) -> str:
    return _STATIC._plain(value)


def _reset_pin_nodes(condition: dict[str, Any]) -> list[str]:
    nodes = _STATIC._pin_nodes(condition)
    forcing = condition["pin_forcing"]
    port_indices = {pin: index for index, pin in enumerate(_STATIC._TOP_PORTS)}
    for pin in ("pixRst[0]", "rowReadON[0]"):
        if forcing[pin] == "fixed_timeline_driven":
            nodes[port_indices[pin]] = "pixrst"
    return nodes


def _top_instance(condition: dict[str, Any]) -> str:
    instance = "Xpix2x2" if condition["path"] == "quantus_rcc_spectre" else "xpix2x2"
    return f"{instance} {' '.join(_reset_pin_nodes(condition))} openDVS_pixel2x2"


def _pixel0_signal(path: str, name: str) -> str:
    if path == "quantus_rcc_spectre":
        return f"Xpix2x2.xPix[0]/{name}"
    if path == "magic_rcc_ngspice":
        return f"xpix2x2.xdiffbn_physical_core.openDVS_pixel_0.{name}"
    return f"xpix2x2.xpix[0].{name}"


def _reset_source_key(path: str) -> str:
    if path == "magic_rcc_ngspice":
        return "magic_reset_netlist"
    if path == "schematic_ngspice":
        return "schematic_reset_netlist"
    return _STATIC._path_source_key(path)


def _probe_lines(condition: dict[str, Any]) -> list[str]:
    path = condition["path"]
    probes = (
        ("EonSense", "onSense", _pixel0_signal(path, "ON")),
        ("EnrstSense", "nrstSense", _pixel0_signal(path, "nRst")),
        ("EvdiffSense", "vdiffSense", _pixel0_signal(path, "vdiff")),
    )
    return [_STATIC._eprobe_line(name, probe, node) for name, probe, node in probes]


def _photodiode_lines(condition: dict[str, Any]) -> list[str]:
    path = condition["path"]
    current = _spice_value(condition["optical"]["photocurrent_a"]["vpd[0]"])
    return [
        _STATIC._source_line(path, f"Iipd{index}", f"vpd{index}", "0", current)
        for index in range(4)
    ]


def _reset_save_lines(path: str) -> list[str]:
    if path == "quantus_rcc_spectre":
        return ["saveOptions options save=allpub currents=none"]
    return [".save v(VddA18) v(pixrst) v(onSense) v(nrstSense) v(vdiffSense)"]


def _reset_include_lines(
    condition: dict[str, Any], sources: dict[str, str]
) -> list[str]:
    """Render path includes while retaining validated physical photodiodes."""
    lines = _STATIC._include_lines(condition, sources)
    if condition["path"] == "quantus_rcc_spectre":
        return lines
    base_source = _source_path(sources, _STATIC._path_source_key(condition["path"]))
    reset_source = _source_path(sources, _reset_source_key(condition["path"]))
    lines = [line.replace(base_source, reset_source) for line in lines]
    # edit20260922 v38l: the static include builder now emits the nonfet corner
    # and parasitic-diode includes itself; drop them here and re-insert them in
    # the frozen reset order (lib, nonfet, diode, DUT) so they occur exactly once.
    nonfet = f".include {_source_path(sources, 'ngspice_nonfet_corner_' + condition['corner'])}"
    diode = f".include {_source_path(sources, 'ngspice_parasitic_diode_model')}"
    lines = [line for line in lines if line not in (nonfet, diode)]
    return [lines[0], nonfet, diode, *lines[1:]]


def _reset_nodeset_lines(path: str, condition: dict[str, Any]) -> list[str]:
    """Use only source- and condition-matched, seed-independent Magic witnesses."""
    if path != "magic_rcc_ngspice":
        return []
    witness = _MAGIC_EXTREME_NODESET_WITNESSES.get(
        (condition["corner"], condition["vdd_v"], condition["temperature_c"])
    )
    if witness is None:
        return []
    witness_sha256, witness_name, values = witness
    witness_path = Path(__file__).resolve().parent / "witnesses" / witness_name
    if (
        not witness_path.is_file()
        or _STATIC._sha256_file(witness_path) != witness_sha256
    ):
        raise ValueError(f"Magic nodeset witness changed or is missing: {witness_name}")
    record = json.loads(witness_path.read_text(encoding="utf-8"))
    expected_values = {
        f"xpix2x2.xdiffbn_physical_core.openDVS_pixel_{pixel}.{node}": float(value)
        for pixel, node, value in values
    }
    if (
        record.get("source_fingerprint")
        != "df6907aad17efe3b5e8c8f4b1ebf410129f43d2371e20546b948a64d09713d59"
        or record.get("condition")
        != {
            "path": path,
            "corner": condition["corner"],
            "vdd_v": condition["vdd_v"],
            "temperature_c": condition["temperature_c"],
        }
        or record.get("values") != expected_values
    ):
        raise ValueError(
            f"Magic nodeset witness content does not match: {witness_name}"
        )
    return [
        f"* MAGIC_NODESET_WITNESS_SHA256 {witness_sha256}",
        *[
            ".nodeset v("
            f"xpix2x2.xdiffbn_physical_core.openDVS_pixel_{pixel}.{node}"
            f")={value}"
            for pixel, node, value in values
        ],
    ]


def _reset_spectre_options_lines(condition: dict[str, Any]) -> list[str]:
    """Render exact reset options plus the qualified DC damping route."""
    options = _STATIC._options_lines(condition)
    if len(options) != 1 or "dcdampsol" in options[0].lower():
        raise ValueError("unexpected base Spectre options for reset recovery")
    return [options[0] + " dcdampsol=yes"]


def _reset_ngspice_options_lines(condition: dict[str, Any]) -> list[str]:
    """Render the frozen CACE NGSPICE options without substituting defaults."""
    settings = condition["analysis_conditions"]
    return [
        ".option "
        f"gmin={_spice_value(settings['gmin_s'])} "
        f"abstol={_spice_value(settings['iabstol_a'])} "
        f"vntol={_spice_value(settings['vabstol_v'])} "
        f"reltol={_spice_value(settings['reltol'])} "
        f"chgtol={_spice_value(settings['chgtol_c'])}",
        f".option method=gear maxord=2 trtol={_plain(settings['trtol'])}",
        ".option "
        f"itl1={settings['itl1']} itl2={settings['itl2']} itl4={settings['itl4']}",
        f".option gminsteps={settings['gminsteps']} srcsteps={settings['srcsteps']}",
        f".option ramptime={_spice_value(settings['ramptime_s'])}",
    ]


def _ngspice_startup_text() -> str:
    """Return the hash-bound startup file used by the CACE-aligned run."""
    return _FROZEN_NGSPICE_STARTUP


def _reset_analysis_lines(condition: dict[str, Any], stage: str) -> list[str]:
    if stage not in {"discovery", "replay"}:
        raise ValueError(f"unsupported reset deck stage: {stage}")
    path = condition["path"]
    settings = condition["analysis_conditions"]
    max_step = _spice_value(settings["coarse_settling_max_step_s"])
    stop = _plain(condition["stimulus"]["stop_s"])
    if path == "quantus_rcc_spectre":
        return [
            f"tran tran stop={stop} maxstep={max_step} "
            f"method={settings['integration_method']}"
        ]
    if stage == "replay":
        return [
            f".tran {max_step} {stop}",
            ".control",
            "set num_threads=1",
            "set filetype=ascii",
            "run",
            "write raw_output.raw v(VddA18) v(pixrst) v(onSense) v(nrstSense) v(vdiffSense)",
            "quit",
            ".endc",
            ".end",
        ]
    # The explicit PWL source owns every protocol boundary.  A single
    # uninterrupted transient prevents signal-dependent controller feedback
    # from changing the stimulus or endpoint.
    return [
        f".tran {max_step} {stop}",
        ".control",
        "set num_threads=1",
        "set filetype=ascii",
        "run",
        "write raw_output.raw v(VddA18) v(pixrst) v(onSense) v(nrstSense) v(vdiffSense)",
        "quit",
        ".endc",
        ".end",
    ]


def _normalise_discovery(discovery: Any) -> dict[str, float]:
    if not isinstance(discovery, dict) or set(discovery) != set(_DISCOVERY_KEYS):
        raise ValueError("discovery must contain exactly the registered event times")
    values = {name: _finite_number(discovery[name], name) for name in _DISCOVERY_KEYS}
    stop = 51.0
    if not (
        1e-3 <= values["nrst_crossing_s"] <= stop
        and 1e-3 < values["second_reset_rise_s"] < values["second_reset_fall_s"] <= stop
    ):
        raise ValueError("discovery event ordering is outside the reset protocol")
    return values


def _fixed_reset_timeline(condition: dict[str, Any]) -> list[tuple[float, float]]:
    """Return the exact VDD-normalized timeline registered in the row."""
    stimulus = condition.get("stimulus")
    if not isinstance(stimulus, dict):
        raise ValueError("reset stimulus must be an object")
    if stimulus.get("protocol_mode") != "fixed_common_timeline_v1":
        raise ValueError("reset stimulus is not the fixed common timeline")
    if stimulus.get("event_trigger") != "none":
        raise ValueError("fixed reset stimulus must not have an event trigger")
    timeline = stimulus.get("timeline")
    if not isinstance(timeline, list) or len(timeline) != 8:
        raise ValueError("fixed reset timeline must contain exactly eight points")
    parsed: list[tuple[float, float]] = []
    for index, point in enumerate(timeline):
        if not isinstance(point, dict) or set(point) != {
            "time_s",
            "level_fraction_vdd",
        }:
            raise ValueError(f"fixed reset timeline point {index} is malformed")
        time = _finite_number(point["time_s"], f"fixed timeline point {index} time")
        fraction = _finite_number(
            point["level_fraction_vdd"],
            f"fixed timeline point {index} level",
        )
        if fraction not in {0.0, 1.0}:
            raise ValueError("fixed reset levels must be zero or one times VDD")
        parsed.append((time, fraction))
    expected = [
        (float(point["time_s"]), float(point["level_fraction_vdd"]))
        for point in _MANIFEST.FIXED_RESET_TIMELINE
    ]
    if parsed != expected:
        raise ValueError("fixed reset timeline differs from the registered schedule")
    if any(after[0] <= before[0] for before, after in zip(parsed, parsed[1:])):
        raise ValueError("fixed reset timeline times must be strictly increasing")
    if parsed[-1][0] != _finite_number(stimulus.get("stop_s"), "reset stop time"):
        raise ValueError(
            "fixed reset timeline endpoint differs from the registered stop"
        )
    return parsed


def _render_fixed_reset_source(condition: dict[str, Any]) -> str:
    """Render one SPICE PWL source shared byte-for-byte by all paths at a VDD."""
    points = _fixed_reset_timeline(condition)
    values = " ".join(
        f"{_plain(time)} {_plain(fraction * condition['vdd_v'])}"
        for time, fraction in points
    )
    return f"VresetController pixrst 0 PWL({values})"


def _fixed_timeline_half_crossings(condition: dict[str, Any]) -> dict[str, float]:
    """Return the three 50%-VDD edge times implied by the PWL schedule."""
    falling: list[float] = []
    rising: list[float] = []
    points = _fixed_reset_timeline(condition)
    for (before_time, before), (after_time, after) in zip(points, points[1:]):
        if before == after:
            continue
        crossing = before_time + (0.5 - before) * (after_time - before_time) / (
            after - before
        )
        (rising if after > before else falling).append(crossing)
    if len(rising) != 1 or len(falling) != 2:
        raise ValueError("fixed reset timeline must contain one rise and two falls")
    return {
        "initial_reset_release_s": falling[0],
        "second_reset_rise_s": rising[0],
        "second_reset_fall_s": falling[1],
    }


def _discovery_fingerprint(discovery: dict[str, Any]) -> str:
    return hashlib.sha256(
        _canonical_json(_normalise_discovery(discovery)).encode("utf-8")
    ).hexdigest()


def _build_deck(
    row: dict[str, Any],
    sources: dict[str, str],
    stage: str,
    discovery: dict[str, Any] | None = None,
    edge_include: str | None = None,
) -> str:
    condition = _condition(row)
    path = condition["path"]
    if stage == "replay":
        if condition["stimulus"].get("protocol_mode") in {
            "exact_frozen_cace",
            "fixed_common_timeline_v1",
        }:
            raise ValueError("the registered reset protocol does not use replay")
        if not isinstance(discovery, dict) or not edge_include:
            raise ValueError("replay deck requires discovery and edge-grid include")
        if edge_include != "edge_grid.inc":
            raise ValueError("replay deck requires the deterministic edge-grid include")
        discovery = _normalise_discovery(discovery)
        # Validate the values before putting any of them in a deck.
        windows = edge_windows(row, discovery)
        edge_grid_times(
            windows, condition["analysis_conditions"]["edge_window_max_step_s"]
        )
    if stage == "discovery" and (discovery is not None or edge_include is not None):
        raise ValueError("discovery deck cannot contain replay inputs")

    source_keys = [_STATIC._path_source_key(path), "ngspice_model_library"]
    if path == "quantus_rcc_spectre":
        source_keys.extend(("native_model_library", "native_model_adapter"))
    else:
        source_keys.extend(
            (
                _reset_source_key(path),
                "ngspice_nonfet_corner_" + condition["corner"],
                "ngspice_parasitic_diode_model",
            )
        )
    for key in source_keys:
        _source_path(sources, key)

    comment = _COMMENT[path]
    claim = row["source"]
    lines = [
        f"{comment} RESET_ROW_BEGIN",
        f"{comment} RESET_ROW_ID {_row_id(row, condition)}",
        f"{comment} CONDITION_JSON {_canonical_json(condition)}",
        f"{comment} SOURCE_CLAIM {_canonical_json(claim)}",
        f"{comment} FIXED_RESET_TIMELINE {_canonical_json(condition['stimulus']['timeline'])}",
        f"{comment} geometry_convention={'spectre_u_p_suffixes' if path == 'quantus_rcc_spectre' else 'ngspice_SCALE_micrometre'}",
    ]
    if path != "quantus_rcc_spectre":
        lines.extend(
            (
                f"{comment} RESET_BASE_SOURCE_CLAIM {_source_path(sources, _STATIC._path_source_key(path))}",
                f"{comment} RESET_ADAPTED_SOURCE_CLAIM {_source_path(sources, _reset_source_key(path))}",
            )
        )
    if stage == "replay":
        lines.append(f"{comment} DISCOVERY_JSON {_canonical_json(discovery)}")
        lines.append(f"{comment} DISCOVERY_SHA256 {_discovery_fingerprint(discovery)}")
    lines.extend(_reset_include_lines(condition, sources))
    if edge_include is not None:
        lines.append(f'.include "{edge_include}"')
    if path != "quantus_rcc_spectre":
        lines.append(f".temp {_plain(condition['temperature_c'])}")
        lines.extend(_reset_ngspice_options_lines(condition))
    lines.append(
        _STATIC._voltage_line(path, "Vvdd", "VddA18", "0", _plain(condition["vdd_v"]))
    )
    lines.append(_render_fixed_reset_source(condition))
    lines.extend(_STATIC._bias_lines(condition))
    lines.extend(_photodiode_lines(condition))
    lines.extend(_probe_lines(condition))
    lines.append(_top_instance(condition))
    lines.extend(_reset_nodeset_lines(path, condition))
    if path == "quantus_rcc_spectre":
        lines.append("simulator lang=spectre")
        lines.extend(_reset_save_lines(path))
        lines.extend(_reset_spectre_options_lines(condition))
    else:
        lines.extend(_reset_save_lines(path))
    lines.extend(_reset_analysis_lines(condition, stage))
    lines.append(f"{comment} RESET_ROW_END")
    return "\n".join(lines) + "\n"


def build_discovery_deck(row: dict[str, Any], sources: dict[str, str]) -> str:
    """Render the deterministic 100 us coarse discovery deck."""
    return _build_deck(row, sources, "discovery")


def build_replay_deck(
    row: dict[str, Any],
    sources: dict[str, str],
    discovery: dict[str, Any],
    edge_include: str,
) -> str:
    """Render a replay deck with only the registered local breakpoint grid."""
    return _build_deck(row, sources, "replay", discovery, edge_include)


def _require_once(deck: str, needle: str, label: str) -> None:
    count = deck.count(needle)
    if count != 1:
        raise ValueError(f"{label} anchor occurs {count} times")


def validate_deck(
    row: dict[str, Any],
    deck: str,
    sources: dict[str, str],
    *,
    stage: str = "discovery",
) -> None:
    """Fail closed when a reset deck drifts from its row or path contract."""
    if not isinstance(deck, str) or not deck:
        raise ValueError("deck must be non-empty text")
    if stage == "discovery":
        expected = build_discovery_deck(row, sources)
    elif stage == "replay":
        include = _find_edge_include(deck)
        if include != "edge_grid.inc":
            raise ValueError("replay deck is missing its edge-grid include")
        discovery = _discovery_from_deck(deck, _COMMENT[_condition(row)["path"]])
        expected = build_replay_deck(row, sources, discovery, include)
    else:
        raise ValueError(f"unsupported reset deck stage: {stage}")
    if deck != expected:
        raise ValueError("deck differs from the deterministic reset rendering")

    condition = _condition(row)
    path = condition["path"]
    comment = _COMMENT[path]
    row_id = _row_id(row, condition)
    for marker, label in (
        (f"{comment} RESET_ROW_BEGIN", "row begin"),
        (f"{comment} RESET_ROW_ID {row_id}", "row identity"),
        (f"{comment} CONDITION_JSON {_canonical_json(condition)}", "condition"),
        (f"{comment} SOURCE_CLAIM {_canonical_json(row['source'])}", "source claim"),
        (f"{comment} RESET_ROW_END", "row end"),
    ):
        _require_once(deck, marker, label)
    if "edge_grid" in deck.lower() and stage != "replay":
        raise ValueError("discovery deck contains replay edge-grid material")
    if stage == "replay" and "edge_grid.inc" not in deck:
        raise ValueError("replay deck has no edge-grid include")

    source_key = _STATIC._path_source_key(path)
    if path == "quantus_rcc_spectre":
        _require_once(deck, _source_path(sources, source_key), "DUT source")
    else:
        _require_once(deck, _source_path(sources, source_key), "base DUT source claim")
        _require_once(
            deck,
            f".include {_source_path(sources, _reset_source_key(path))}",
            "adapted reset DUT source",
        )
    _require_once(
        deck,
        f"{comment} FIXED_RESET_TIMELINE "
        f"{_canonical_json(condition['stimulus']['timeline'])}",
        "fixed reset timeline claim",
    )
    _require_once(
        deck,
        _render_fixed_reset_source(condition),
        "fixed reset voltage source",
    )
    for forbidden in (
        "stop when",
        "resume",
        "alter VresetController",
        "on_thresh",
        "ahdl_include",
        "reset_controller.va",
        "Xreset_control",
    ):
        if forbidden.lower() in deck.lower():
            raise ValueError(f"fixed-timeline deck contains forbidden {forbidden}")
    if path == "quantus_rcc_spectre":
        _require_once(
            deck, _source_path(sources, "native_model_library"), "native model library"
        )
        _require_once(
            deck, _source_path(sources, "native_model_adapter"), "native model adapter"
        )
        if deck.count("simulator lang=spectre") != 1:
            raise ValueError("Quantus deck is missing Spectre language mode")
        _require_once(deck, "dcdampsol=yes", "qualified Spectre DC damping route")
    else:
        if "simulator lang=spectre" in deck:
            raise ValueError("NGSPICE deck must not use Spectre language mode")
        _require_once(
            deck,
            _source_path(sources, "ngspice_model_library"),
            "NGSPICE model library",
        )
        _require_once(
            deck,
            _source_path(sources, "ngspice_parasitic_diode_model"),
            "physical photodiode model",
        )
        _require_once(
            deck,
            _source_path(sources, "ngspice_nonfet_corner_" + condition["corner"]),
            "NGSPICE non-FET corner parameters",
        )
        _require_once(
            deck,
            f".temp {_plain(condition['temperature_c'])}",
            "registered NGSPICE temperature",
        )
        for option in _reset_ngspice_options_lines(condition):
            _require_once(deck, option, "frozen CACE NGSPICE option")
        expected_nodesets = _reset_nodeset_lines(path, condition)
        if path == "magic_rcc_ngspice":
            for nodeset in expected_nodesets:
                _require_once(deck, nodeset, "Magic reset initial guess")
        elif ".nodeset" in deck.lower():
            raise ValueError(
                "schematic exact-CACE reset deck must not contain a nodeset"
            )
        if stage == "discovery":
            transient = (
                f".tran {_spice_value(condition['analysis_conditions']['coarse_settling_max_step_s'])} "
                f"{_plain(condition['stimulus']['stop_s'])}"
            )
            for marker in (
                ".control",
                "run",
                "write raw_output.raw",
                ".endc",
                ".end",
                transient,
            ):
                if marker.lower() not in deck.lower():
                    raise ValueError(f"NGSPICE discovery deck is missing {marker}")
        else:
            for marker in ("stop when", "resume", "BresetController"):
                if marker.lower() in deck.lower():
                    raise ValueError(f"NGSPICE replay deck contains {marker}")
            for marker in (".control", "run", "write raw_output.raw", ".endc", ".end"):
                if marker.lower() not in deck.lower():
                    raise ValueError(f"NGSPICE replay deck is missing {marker}")
            _require_once(
                deck,
                "VresetController pixrst 0 PWL(",
                "NGSPICE replay reset controller",
            )

    coarse_marker = (
        f"maxstep={_spice_value(condition['analysis_conditions']['coarse_settling_max_step_s'])}"
        if path == "quantus_rcc_spectre"
        else (
            f".tran {_spice_value(condition['analysis_conditions']['coarse_settling_max_step_s'])} "
            f"{_plain(condition['stimulus']['stop_s'])}"
        )
    )
    _require_once(deck, coarse_marker, "coarse transient")
    if re.search(r"maxstep\s*=\s*1n\b", deck, re.IGNORECASE) or re.search(
        r"(?:^|\s)\.tran\s+1n\b", deck, re.IGNORECASE | re.MULTILINE
    ):
        raise ValueError("global 1 ns transient step is prohibited")
    if _top_line(deck, path) != _top_instance(condition):
        raise ValueError("top instance pin order or forcing does not match the row")
    for probe in _probe_lines(condition):
        _require_once(deck, probe, "reported-signal probe")
    for bias in _BIAS_NAMES:
        if condition["pin_forcing"][bias] == "current_mirror_driven":
            _require_once(
                deck,
                _STATIC._source_line(
                    path,
                    f"I{bias}",
                    bias
                    if _STATIC._MIRROR_SPECS[bias]["polarity"] == "p"
                    else "VddA18",
                    "0" if _STATIC._MIRROR_SPECS[bias]["polarity"] == "p" else bias,
                    _spice_value(condition["biases_a"][bias]),
                ),
                f"{bias} bias",
            )
    for index in range(4):
        _require_once(deck, f"Iipd{index} vpd{index} 0 dc 1n", f"photodiode {index}")
    stop = _plain(condition["stimulus"]["stop_s"])
    if f"stop={stop}" not in deck and f".tran 100u {stop}" not in deck:
        raise ValueError("reset stop time differs from the fixed common timeline")


def _top_line(deck: str, path: str) -> str:
    marker = "Xpix2x2 " if path == "quantus_rcc_spectre" else "xpix2x2 "
    matches = [line for line in deck.splitlines() if line.startswith(marker)]
    if len(matches) != 1:
        raise ValueError("top instance anchor is missing or repeated")
    return matches[0]


def _find_edge_include(deck: str) -> str | None:
    for line in deck.splitlines():
        if line.lower().startswith(".include") and "edge_grid" in line.lower():
            return line.split(maxsplit=1)[1].strip().strip('"')
    return None


def _discovery_from_deck(deck: str, comment: str) -> dict[str, float]:
    marker = f"{comment} DISCOVERY_JSON "
    matches = [
        line[len(marker) :] for line in deck.splitlines() if line.startswith(marker)
    ]
    if len(matches) != 1:
        raise ValueError(
            "replay deck must contain exactly one discovery metadata record"
        )
    try:
        discovery = json.loads(matches[0])
    except json.JSONDecodeError as exc:
        raise ValueError("replay discovery metadata is not valid JSON") from exc
    normalised = _normalise_discovery(discovery)
    digest_marker = f"{comment} DISCOVERY_SHA256 "
    digests = [
        line[len(digest_marker) :]
        for line in deck.splitlines()
        if line.startswith(digest_marker)
    ]
    if len(digests) != 1 or digests[0] != _discovery_fingerprint(normalised):
        raise ValueError("replay discovery metadata integrity check failed")
    return normalised


def simulator_command(
    row: dict[str, Any], run_dir: Path, sources: dict[str, str]
) -> list[str]:
    """Return the bounded simulator argv without invoking it."""
    condition = _condition(row)
    run_path = Path(run_dir)
    if condition["path"] == "quantus_rcc_spectre":
        return [
            _source_path(sources, "cadence_launcher"),
            "spectre",
            "-64",
            "+mt=1",
            "-I",
            str(run_path / "input.scs"),
            "-format",
            "psfbin",
            "-raw",
            str(run_path / "raw_output"),
            "+lqtimeout",
            "300",
            "+log",
            str(run_path / "simulator.log"),
        ]
    return [
        _source_path(sources, "ngspice_binary"),
        "-b",
        "-o",
        str(run_path / "simulator.log"),
        str(run_path / "input.deck"),
    ]


def psf_metrics_command(
    run_dir: Path, sources: dict[str, str], timeout_s: float | None
) -> list[str]:
    """Extract the five registered metrics from the all-node binary PSF."""
    run_path = Path(run_dir)
    command = [
        _source_path(sources, "cadence_launcher"),
        _source_path(sources, "psf_binary"),
        "-i",
        str(run_path / "raw_output" / "tran.tran.tran"),
        "-t",
        "time",
        "-t",
        "VddA18",
        "-t",
        "pixrst",
        "-t",
        "onSense",
        "-t",
        "nrstSense",
        "-t",
        "vdiffSense",
        "-f",
        "%.17g",
        "-o",
        str(run_path / "metrics_psfascii" / "tran.tran.tran"),
    ]
    return _STATIC._bounded_simulator_command(
        command, "quantus_rcc_spectre", timeout_s
    )


def _finite_number(value: Any, label: str) -> float:
    if isinstance(value, bool) or not isinstance(value, (int, float)):
        raise ValueError(f"{label} must be numeric")
    result = float(value)
    if not math.isfinite(result):
        raise ValueError(f"{label} must be finite")
    return result


def _normalise_windows(windows: Any) -> list[tuple[float, float]]:
    if not isinstance(windows, (list, tuple)) or not windows:
        raise ValueError("at least one edge window is required")
    parsed: list[tuple[float, float]] = []
    for index, window in enumerate(windows):
        if not isinstance(window, (list, tuple)) or len(window) != 2:
            raise ValueError(f"edge window {index} must contain start and end")
        start = _finite_number(window[0], f"edge window {index} start")
        end = _finite_number(window[1], f"edge window {index} end")
        if start < 0 or end < start:
            raise ValueError(f"edge window {index} is outside the time domain")
        parsed.append((start, end))
    parsed.sort()
    merged: list[tuple[float, float]] = []
    for start, end in parsed:
        if merged and start <= merged[-1][1]:
            merged[-1] = (merged[-1][0], max(merged[-1][1], end))
        else:
            merged.append((start, end))
    return merged


def edge_windows(
    row: dict[str, Any], discovery: dict[str, Any]
) -> list[tuple[float, float]]:
    """Derive the three registered local windows from coarse event times."""
    condition = _condition(row)
    values = _normalise_discovery(discovery)
    stop = _finite_number(condition["stimulus"]["stop_s"], "stimulus.stop_s")
    if values["second_reset_fall_s"] > stop or values["nrst_crossing_s"] > stop:
        raise ValueError("discovery event exceeds the registered stop time")
    raw_windows = [
        (1e-3 - 20e-9, 1e-3 + 20e-9),
        (values["nrst_crossing_s"] - 100e-6, values["nrst_crossing_s"] + 100e-6),
        (values["second_reset_rise_s"] - 20e-9, values["second_reset_rise_s"] + 100e-6),
        (values["second_reset_fall_s"] - 20e-9, values["second_reset_fall_s"] + 20e-9),
    ]
    normalised = _normalise_windows(raw_windows)
    if any(start < 0 or end > stop for start, end in normalised):
        raise ValueError("edge window exceeds the registered stop time")
    return normalised


def _edge_tolerance(*values: float, max_step_s: float | None = None) -> float:
    """Return a small ULP/relative-roundoff allowance for time arithmetic."""
    parsed = [_finite_number(value, "edge time") for value in values]
    scale = max(1.0, *(abs(value) for value in parsed))
    tolerance = 8.0 * math.ulp(scale) + 8.0 * sys.float_info.epsilon * scale
    # Even for unusually large absolute times, numerical slack may not turn a
    # physically meaningful extra edge gap into an accepted one.
    caps = [0.5e-9]
    if max_step_s is not None:
        step = _finite_number(max_step_s, "edge max step")
        if step <= 0:
            raise ValueError("edge max step must be positive")
        caps.append(0.5 * step)
    return min(tolerance, *caps)


def _validate_registered_stop(times: list[float], stop_s: float) -> None:
    """Accept the registered endpoint within the runner's 1 ns coordinate allowance."""
    actual = _finite_number(times[-1], "raw stop time")
    expected = _finite_number(stop_s, "registered stop time")
    tolerance = 1e-9 + _edge_tolerance(actual, expected)
    if abs(actual - expected) > tolerance:
        raise ValueError(
            f"raw result does not reach the registered {expected:g} s stop"
        )


def _validate_discovery_stop(
    row: dict[str, Any],
    times: list[float],
    traces: dict[str, list[float]],
    discovery: dict[str, Any],
) -> None:
    """Validate the common endpoint and delivered fixed reset waveform."""
    condition = _condition(row)
    _validate_registered_stop(times, condition["stimulus"]["stop_s"])
    expected = _fixed_timeline_half_crossings(condition)
    actual = {
        "initial_reset_release_s": discovery.get("initial_reset_release_s"),
        "second_reset_rise_s": discovery.get("second_reset_rise_s"),
        "second_reset_fall_s": discovery.get("second_reset_fall_s"),
    }
    for name, expected_time in expected.items():
        actual_time = _finite_number(actual[name], name)
        tolerance = 1e-9 + _edge_tolerance(actual_time, expected_time)
        if abs(actual_time - expected_time) > tolerance:
            raise ValueError(f"delivered {name} differs from the fixed reset timeline")


def edge_grid_times(
    windows: list[tuple[float, float]], max_step_s: float
) -> list[float]:
    """Return deterministic endpoints and <= max-step timestamps per window."""
    step = _finite_number(max_step_s, "edge max step")
    if step <= 0:
        raise ValueError("edge max step must be positive")
    merged = _normalise_windows(windows)
    result: list[float] = []
    for start, end in merged:
        if not result or start > result[-1]:
            result.append(start)
        current = start
        tolerance = _edge_tolerance(start, end, step, max_step_s=step)
        while end - current > step + tolerance:
            next_time = current + step
            if next_time >= end:
                break
            current = next_time
            result.append(current)
        if abs(result[-1] - end) > tolerance:
            result.append(end)
        else:
            result[-1] = end
    validate_edge_spacing(result, merged, step)
    return result


def validate_edge_spacing(
    raw_times: list[float], windows: list[tuple[float, float]], max_step_s: float
) -> None:
    """Prove directly from timestamps that each local window is covered."""
    step = _finite_number(max_step_s, "edge max step")
    if step <= 0:
        raise ValueError("edge max step must be positive")
    if not isinstance(raw_times, (list, tuple)) or not raw_times:
        raise ValueError("raw timestamps are missing")
    times = [_finite_number(value, "raw timestamp") for value in raw_times]
    if any(after <= before for before, after in zip(times, times[1:])):
        raise ValueError("raw timestamps must be strictly increasing")
    for start, end in _normalise_windows(windows):
        tolerance = _edge_tolerance(start, end, step, max_step_s=step)
        inside = [
            time for time in times if start - tolerance <= time <= end + tolerance
        ]
        if not inside:
            raise ValueError("edge window has no raw timestamp coverage")
        if abs(inside[0] - start) > tolerance or abs(inside[-1] - end) > tolerance:
            raise ValueError("edge window boundary is not covered by raw timestamps")
        if any(
            after - before
            > step + _edge_tolerance(before, after, step, max_step_s=step)
            for before, after in zip(inside, inside[1:])
        ):
            raise ValueError("raw timestamp spacing exceeds the registered edge step")


def render_edge_grid(
    path: str, windows: list[tuple[float, float]], max_step_s: float
) -> str:
    """Render an isolated PWL source whose only purpose is local timestamps."""
    if path not in _PATHS:
        raise ValueError(f"unsupported simulation path: {path}")
    grid = edge_grid_times(windows, max_step_s)
    lines = [
        "* EDGE_GRID_BEGIN",
        "* EDGE_GRID_ISOLATED_SOURCE",
        "Vedge_grid edge_grid 0 PWL(",
    ]
    current = lines[-1]
    values = ["0 0"]
    values.extend(
        f"{_plain(time)} {1 if index % 2 == 0 else 0}"
        for index, time in enumerate(grid)
    )
    for value in values:
        candidate = f"{current} {value}"
        if len(candidate) + 1 > _EDGE_LINE_LIMIT:
            lines.append(f"+ {value}")
            current = lines[-1]
        else:
            lines[-1] = candidate
            current = candidate
    lines[-1] += ")"
    lines.extend(("* EDGE_GRID_END", ""))
    return "\n".join(lines)


def _crossing_times(
    times: list[float],
    values: list[float],
    threshold: float,
    start: float = 0.0,
    rising: bool = True,
) -> list[float]:
    crossings: list[float] = []
    for index in range(len(times) - 1):
        if times[index] < start:
            continue
        before, after = values[index], values[index + 1]
        crossed = before < threshold <= after if rising else before > threshold >= after
        if not crossed:
            continue
        delta = after - before
        fraction = 0.0 if abs(delta) < 1e-300 else (threshold - before) / delta
        crossings.append(times[index] + fraction * (times[index + 1] - times[index]))
    return crossings


def _trace_data(times: Any, traces: Any) -> tuple[list[float], dict[str, list[float]]]:
    if not isinstance(times, (list, tuple)) or not times:
        raise ValueError("raw timestamps are missing")
    parsed_times = [_finite_number(value, "raw timestamp") for value in times]
    if any(after <= before for before, after in zip(parsed_times, parsed_times[1:])):
        raise ValueError("raw timestamps must be strictly increasing")
    if not isinstance(traces, dict):
        raise ValueError("traces must be an object")
    parsed: dict[str, list[float]] = {}
    for key in _RESET_TRACES:
        values = traces.get(key)
        if not isinstance(values, (list, tuple)) or len(values) != len(parsed_times):
            raise ValueError(f"missing or unequal trace: {key}")
        parsed[key] = [_finite_number(value, f"trace {key}") for value in values]
    return parsed_times, parsed


def compute_reset_metrics(
    times: list[float], traces: dict[str, list[float]]
) -> dict[str, float]:
    """Compute the six frozen reset scalars with linearly interpolated edges."""
    times, traces = _trace_data(times, traces)
    vdd = statistics.median(traces["vdd"])
    if vdd <= 0:
        raise ValueError("VDD must be positive")
    threshold = 0.9 * vdd
    nrst_crossings = _crossing_times(
        times, traces["nrst"], threshold, start=1e-3, rising=True
    )
    t_nrst_vdd = nrst_crossings[0] if nrst_crossings else None
    if t_nrst_vdd is None:
        raise ValueError("nRst threshold crossing is missing")

    reset_samples = [
        value for time, value in zip(times, traces["vdiff"]) if 0.9e-3 <= time <= 1e-3
    ]
    if not reset_samples:
        raise ValueError("vdiff-before reset evidence is missing")
    vdiff_before = statistics.fmean(reset_samples)
    post_samples = [
        value
        for time, value in zip(times, traces["vdiff"])
        if t_nrst_vdd <= time <= t_nrst_vdd + 100e-6
    ]
    if not post_samples:
        raise ValueError("vdiff-after reset evidence is missing")
    vdiff_after = statistics.fmean(post_samples)
    on_crossings = [
        crossing
        for crossing in _crossing_times(
            times, traces["on"], vdd / 2, start=1e-3, rising=True
        )
        if crossing >= t_nrst_vdd
    ]
    if not on_crossings:
        raise ValueError("ON threshold crossing is missing")

    reset_rises = _crossing_times(
        times, traces["pixrst"], vdd / 2, start=1e-3 + 1e-6, rising=True
    )
    t_rst2_start = reset_rises[0] if reset_rises else None
    if t_rst2_start is None:
        raise ValueError("second reset assertion is missing")
    if t_rst2_start < on_crossings[0]:
        raise ValueError("second reset assertion precedes the ON threshold crossing")
    reset_falls = _crossing_times(
        times, traces["pixrst"], vdd / 2, start=t_rst2_start + 1e-6, rising=False
    )
    if not reset_falls:
        raise ValueError("second reset release is missing")
    t_rst2_end = reset_falls[0]
    settling_samples = [
        (time, value)
        for time, value in zip(times, traces["vdiff"])
        if t_rst2_start <= time <= t_rst2_end
    ]
    if len(settling_samples) < 2:
        raise ValueError("post-measurement reset evidence is missing")
    final = settling_samples[-1][1]
    band = abs(final * 0.01) if abs(final) > 1e-12 else 1e-8
    outside = [
        index
        for index, (_, value) in enumerate(settling_samples)
        if abs(value - final) > band
    ]
    if not outside:
        min_reset_time = 0.0
    elif outside[-1] + 1 >= len(settling_samples):
        min_reset_time = settling_samples[-1][0] - t_rst2_start
    else:
        min_reset_time = settling_samples[outside[-1] + 1][0] - t_rst2_start

    metrics = {
        "refractory_period": t_nrst_vdd - 1e-3,
        "delta_vdiff_ci": vdiff_after - vdiff_before,
        "leak_event_period": on_crossings[0] - t_nrst_vdd,
        "min_reset_time": min_reset_time,
        "vdiff_before_ci": vdiff_before,
        "vdiff_after_ci": vdiff_after,
    }
    if not all(math.isfinite(value) for value in metrics.values()):
        raise ValueError("reset metrics contain a non-finite value")
    return metrics


def compute_cace_reset_metrics(
    times: list[float], traces: dict[str, list[float]]
) -> dict[str, float]:
    """Reproduce the frozen CACE postprocessor's six scalar calculations."""
    times, traces = _trace_data(times, traces)
    vdd = statistics.median(traces["vdd"])
    if vdd <= 0:
        raise ValueError("VDD must be positive")
    t_nrst = next(
        iter(
            _crossing_times(times, traces["nrst"], 0.9 * vdd, start=1e-3, rising=True)
        ),
        None,
    )
    refractory = t_nrst - 1e-3 if t_nrst is not None else 0.0

    reset_values = [
        value for time, value in zip(times, traces["vdiff"]) if 0.9e-3 <= time <= 1e-3
    ]
    vdiff_before = (
        statistics.fmean(reset_values) if reset_values else traces["vdiff"][0]
    )
    if t_nrst is None:
        vdiff_after = vdiff_before
    else:
        post_values = [
            value
            for time, value in zip(times, traces["vdiff"])
            if t_nrst <= time <= t_nrst + 100e-6
        ]
        if not post_values:
            post_values = [
                value
                for time, value in zip(times, traces["vdiff"])
                if t_nrst <= time <= t_nrst + 1e-3
            ]
        vdiff_after = statistics.fmean(post_values) if post_values else vdiff_before

    on_crossings = (
        [
            crossing
            for crossing in _crossing_times(
                times, traces["on"], vdd / 2, start=1e-3, rising=True
            )
            if crossing >= t_nrst
        ]
        if t_nrst is not None
        else []
    )
    leak_period = (
        on_crossings[0] - t_nrst if on_crossings and t_nrst is not None else 0.0
    )

    reset_rises = _crossing_times(
        times, traces["pixrst"], vdd / 2, start=1e-3 + 1e-6, rising=True
    )
    min_reset_time = 0.0
    if reset_rises:
        reset_start = reset_rises[0]
        reset_falls = _crossing_times(
            times, traces["pixrst"], vdd / 2, start=reset_start + 1e-6, rising=False
        )
        reset_end = reset_falls[0] if reset_falls else times[-1]
        settling = [
            (time, value)
            for time, value in zip(times, traces["vdiff"])
            if reset_start <= time <= reset_end
        ]
        if len(settling) >= 2:
            final = settling[-1][1]
            band = abs(final * 0.01) if abs(final) > 1e-12 else 1e-8
            outside = [
                index
                for index, (_, value) in enumerate(settling)
                if abs(value - final) > band
            ]
            if outside:
                if outside[-1] + 1 >= len(settling):
                    min_reset_time = settling[-1][0] - reset_start
                else:
                    min_reset_time = settling[outside[-1] + 1][0] - reset_start

    metrics = {
        "refractory_period": refractory,
        "delta_vdiff_ci": vdiff_after - vdiff_before,
        "leak_event_period": leak_period,
        "min_reset_time": min_reset_time,
        "vdiff_before_ci": vdiff_before,
        "vdiff_after_ci": vdiff_after,
    }
    if not all(math.isfinite(value) for value in metrics.values()):
        raise ValueError("reset metrics contain a non-finite value")
    return metrics


def describe_exact_cace_event_evidence(
    times: list[float], traces: dict[str, list[float]]
) -> dict[str, Any]:
    """Describe whether the frozen CACE leak scalar is measured or censored.

    The frozen postprocessor deliberately emits 0 s when the ON event is
    absent.  Preserve that scalar for method parity, but do not present the
    sentinel as a physical zero-period event.
    """
    times, traces = _trace_data(times, traces)
    vdd = statistics.median(traces["vdd"])
    if vdd <= 0:
        raise ValueError("VDD must be positive")

    nrst_crossings = _crossing_times(
        times, traces["nrst"], 0.9 * vdd, start=1e-3, rising=True
    )
    t_nrst = nrst_crossings[0] if nrst_crossings else None
    all_metric_crossings = _crossing_times(
        times, traces["on"], vdd / 2, start=1e-3, rising=True
    )
    metric_crossings = (
        [crossing for crossing in all_metric_crossings if crossing >= t_nrst]
        if t_nrst is not None
        else []
    )

    control_sample = next(
        (
            (time, on_value, vdd_value)
            for time, on_value, vdd_value in zip(
                times, traces["on"], traces["vdd"], strict=True
            )
            if time > 1e-3 and (on_value > 0.9 * vdd_value or time > 45.0)
        ),
        None,
    )
    if control_sample is None:
        raise ValueError(
            "raw result does not contain the frozen ON-or-timeout control stop"
        )
    control_stop, on_at_stop, vdd_at_stop = control_sample
    controller_outcome = (
        "on_threshold_crossing" if on_at_stop > 0.9 * vdd_at_stop else "timeout"
    )

    leak_evidence: dict[str, Any] = {
        "cace_scalar_s": (
            metric_crossings[0] - t_nrst
            if metric_crossings and t_nrst is not None
            else 0.0
        ),
        "metric_threshold_v": vdd / 2,
    }
    if t_nrst is None:
        leak_evidence.update(
            {
                "status": "missing_reference_crossing",
                "interpretation": "the frozen 0 s scalar is a missing-nRst fallback",
            }
        )
    elif metric_crossings:
        leak_evidence.update(
            {
                "status": "measured",
                "crossing_s": metric_crossings[0],
            }
        )
    elif any(crossing < t_nrst for crossing in all_metric_crossings):
        leak_evidence.update(
            {
                "status": "event_precedes_reference",
                "interpretation": "the frozen 0 s scalar represents ON preceding nRst",
            }
        )
    else:
        lower_bound = max(0.0, control_stop - t_nrst)
        leak_upper_limit = _RESET_SPEC_LIMITS["leak_event_period"][1]
        leak_evidence.update(
            {
                "status": "right_censored",
                "lower_bound_s": lower_bound,
                "registered_upper_limit_s": leak_upper_limit,
                "spec_conclusion": (
                    "fail_above_registered_upper_limit"
                    if lower_bound > leak_upper_limit
                    else "not_determined_from_censoring"
                ),
                "interpretation": (
                    "no ON crossing was observed; the frozen 0 s scalar is a sentinel, "
                    "not a physical zero-period event"
                ),
            }
        )

    return {
        "controller_outcome": controller_outcome,
        "controller_stop_s": control_stop,
        "controller_threshold_fraction_vdd": 0.9,
        "leak_event_period": leak_evidence,
    }


def evaluate_reset_spec(metrics: dict[str, Any]) -> str:
    """Evaluate the SI-normalized limits registered by PixelResetTran_2x2."""
    if not isinstance(metrics, dict):
        return "fail"
    required = (*_RESET_SPEC_LIMITS, "vdiff_before_ci", "vdiff_after_ci")
    values: dict[str, float] = {}
    try:
        values = {name: _finite_number(metrics[name], name) for name in required}
    except (KeyError, ValueError, TypeError):
        return "fail"
    for name, (lower, upper) in _RESET_SPEC_LIMITS.items():
        if not lower <= values[name] <= upper:
            return "fail"
    return "pass"


def discover_events(
    times: list[float], traces: dict[str, list[float]]
) -> dict[str, float]:
    """Find the three event times needed to derive local replay windows."""
    times, traces = _trace_data(times, traces)
    vdd = statistics.median(traces["vdd"])
    if vdd <= 0:
        raise ValueError("VDD must be positive")
    threshold = 0.9 * vdd
    nrst = _crossing_times(times, traces["nrst"], threshold, start=1e-3, rising=True)
    if not nrst:
        raise ValueError("nRst threshold crossing is missing")
    t_nrst = nrst[0]
    # The frozen CACE controller asserts the second reset on the first ON
    # threshold event.  A path that glitches ON before nRst reaches threshold
    # is a scientific result, not a reason to lose the mechanically complete
    # trace.  Discover the actual reset pulse independently; replay will then
    # classify the frozen metrics and protocol ordering.
    reset_rises = _crossing_times(
        times, traces["pixrst"], vdd / 2, start=1e-3 + 1e-6, rising=True
    )
    if not reset_rises:
        raise ValueError("second reset assertion is missing")
    second_rise = reset_rises[0]
    reset_falls = _crossing_times(
        times, traces["pixrst"], vdd / 2, start=second_rise + 1e-6, rising=False
    )
    if not reset_falls:
        raise ValueError("second reset release is missing")
    return {
        "nrst_crossing_s": t_nrst,
        "second_reset_rise_s": second_rise,
        "second_reset_fall_s": reset_falls[0],
    }


def discover_exact_cace_protocol_events(
    times: list[float], traces: dict[str, list[float]]
) -> dict[str, float | None]:
    """Locate controller events while preserving the CACE missing-nRst fallback."""
    times, traces = _trace_data(times, traces)
    vdd = statistics.median(traces["vdd"])
    if vdd <= 0:
        raise ValueError("VDD must be positive")
    nrst = _crossing_times(times, traces["nrst"], 0.9 * vdd, start=1e-3, rising=True)
    reset_rises = _crossing_times(
        times, traces["pixrst"], vdd / 2, start=1e-3 + 1e-6, rising=True
    )
    if not reset_rises:
        raise ValueError("second reset assertion is missing")
    second_rise = reset_rises[0]
    reset_falls = _crossing_times(
        times, traces["pixrst"], vdd / 2, start=second_rise + 1e-6, rising=False
    )
    if not reset_falls:
        raise ValueError("second reset release is missing")
    return {
        "nrst_crossing_s": nrst[0] if nrst else None,
        "second_reset_rise_s": second_rise,
        "second_reset_fall_s": reset_falls[0],
    }


def discover_fixed_timeline_events(
    times: list[float], traces: dict[str, list[float]]
) -> dict[str, float | None]:
    """Locate the delivered fixed source edges and the observed circuit events."""
    times, traces = _trace_data(times, traces)
    vdd = statistics.median(traces["vdd"])
    if vdd <= 0:
        raise ValueError("VDD must be positive")
    reset_falls = _crossing_times(
        times, traces["pixrst"], vdd / 2, start=0.0, rising=False
    )
    reset_rises = _crossing_times(
        times, traces["pixrst"], vdd / 2, start=1e-3 + 1e-6, rising=True
    )
    if len(reset_falls) != 2 or len(reset_rises) != 1:
        raise ValueError(
            "delivered reset waveform must contain exactly two releases and one assertion"
        )
    nrst = _crossing_times(times, traces["nrst"], 0.9 * vdd, start=1e-3, rising=True)
    on_90 = _crossing_times(times, traces["on"], 0.9 * vdd, start=1e-3, rising=True)
    return {
        "initial_reset_release_s": reset_falls[0],
        "nrst_crossing_s": nrst[0] if nrst else None,
        "on_90_crossing_s": on_90[0] if on_90 else None,
        "second_reset_rise_s": reset_rises[0],
        "second_reset_fall_s": reset_falls[1],
    }


def describe_fixed_timeline_event_evidence(
    times: list[float], traces: dict[str, list[float]]
) -> dict[str, Any]:
    """Describe physical event ordering without counting a forced retrigger."""
    times, traces = _trace_data(times, traces)
    vdd = statistics.median(traces["vdd"])
    if vdd <= 0:
        raise ValueError("VDD must be positive")
    nrst_crossings = _crossing_times(
        times, traces["nrst"], 0.9 * vdd, start=1e-3, rising=True
    )
    t_nrst = nrst_crossings[0] if nrst_crossings else None
    on_half = _crossing_times(times, traces["on"], vdd / 2, start=1e-3, rising=True)
    reset_rises = _crossing_times(
        times, traces["pixrst"], vdd / 2, start=1e-3 + 1e-6, rising=True
    )
    if len(reset_rises) != 1:
        raise ValueError("fixed reset trace must contain one second-reset assertion")
    second_reset_assertion = reset_rises[0]
    after_reference = (
        [crossing for crossing in on_half if crossing >= t_nrst]
        if t_nrst is not None
        else []
    )
    pre_reference = (
        [crossing for crossing in on_half if crossing < t_nrst]
        if t_nrst is not None
        else []
    )
    physical_crossings = (
        [crossing for crossing in after_reference if crossing < second_reset_assertion]
        if t_nrst is not None
        else []
    )
    forced_retriggers = [
        crossing for crossing in after_reference if crossing >= second_reset_assertion
    ]
    selected_cace_crossing = after_reference[0] if after_reference else None
    leak_evidence: dict[str, Any] = {
        "cace_scalar_s": (
            selected_cace_crossing - t_nrst
            if selected_cace_crossing is not None and t_nrst is not None
            else 0.0
        ),
        "metric_threshold_v": vdd / 2,
        "all_crossings_s": on_half,
        "first_on_crossing_s": on_half[0] if on_half else None,
        "selected_cace_crossing_s": selected_cace_crossing,
        "forced_retrigger_crossings_s": forced_retriggers,
        "physical_interval_s": None,
    }
    health: dict[str, Any] = {
        "criterion": "registered_leak_event_maximum_40_s",
        "registered_upper_limit_s": _RESET_SPEC_LIMITS["leak_event_period"][1],
    }
    if t_nrst is None:
        leak_evidence.update(
            {
                "status": "missing_reference_crossing",
                "interpretation": "nRst did not reach 90% of VDD in the fixed observation window",
            }
        )
        health.update(
            {
                "status": "fail",
                "reason": "the nRst reference required by the leak metric is missing",
            }
        )
    elif pre_reference:
        leak_evidence.update(
            {
                "status": "event_precedes_reference",
                "pre_reference_crossings_s": pre_reference,
                "interpretation": (
                    "ON crossed before nRst reached 90% of VDD; any later crossing "
                    "created by the forced second reset is not a physical leak event"
                ),
            }
        )
        health.update(
            {
                "status": "fail",
                "reason": "ON precedes the nRst reference, so no valid leak interval exists",
            }
        )
    elif physical_crossings:
        physical_interval = physical_crossings[0] - t_nrst
        leak_evidence.update(
            {
                "status": "measured",
                "crossing_s": physical_crossings[0],
                "physical_interval_s": physical_interval,
            }
        )
        maximum = _RESET_SPEC_LIMITS["leak_event_period"][1]
        health.update(
            {
                "status": "pass" if physical_interval <= maximum else "fail",
                "reason": (
                    "a physical pre-reset leak event is within the registered maximum"
                    if physical_interval <= maximum
                    else "the physical leak interval exceeds the registered maximum"
                ),
            }
        )
    elif forced_retriggers:
        leak_evidence.update(
            {
                "status": "forced_reset_retrigger",
                "interpretation": (
                    "the only post-reference ON crossing was created by the forced "
                    "second reset and is not a physical leak event"
                ),
            }
        )
        health.update(
            {
                "status": "fail",
                "reason": "no physical leak event occurs before the second reset",
            }
        )
    else:
        lower_bound = max(0.0, second_reset_assertion - t_nrst)
        maximum = _RESET_SPEC_LIMITS["leak_event_period"][1]
        leak_evidence.update(
            {
                "status": "right_censored",
                "lower_bound_s": lower_bound,
                "registered_upper_limit_s": maximum,
                "interpretation": (
                    "no ON crossing occurred before the fixed second reset"
                ),
            }
        )
        health.update(
            {
                "status": "fail" if lower_bound > maximum else "inconclusive",
                "reason": (
                    "the censored lower bound exceeds the registered maximum"
                    if lower_bound > maximum
                    else "the observation ends before the registered maximum is resolved"
                ),
            }
        )
    return {
        "stimulus_control": "fixed_common_timeline",
        "event_trigger": "none",
        "undisturbed_observation_end_s": second_reset_assertion,
        "leak_event_period": leak_evidence,
        "simulation_health": health,
    }


def fixed_timeline_measurements(
    times: list[float], traces: dict[str, list[float]]
) -> dict[str, float | None]:
    """Return threshold times on one common initial-release epoch."""
    times, traces = _trace_data(times, traces)
    vdd = statistics.median(traces["vdd"])
    if vdd <= 0:
        raise ValueError("VDD must be positive")
    reset_release = next(
        iter(_crossing_times(times, traces["pixrst"], vdd / 2, rising=False)),
        None,
    )
    if reset_release is None:
        raise ValueError("initial reset release is missing")
    nrst = next(
        iter(_crossing_times(times, traces["nrst"], 0.9 * vdd, start=reset_release)),
        None,
    )
    on = next(
        iter(_crossing_times(times, traces["on"], 0.9 * vdd, start=reset_release)),
        None,
    )
    return {
        "initial_reset_release_50_s": reset_release,
        "initial_release_to_nrst_90_s": (
            nrst - reset_release if nrst is not None else None
        ),
        "initial_release_to_on_90_s": on - reset_release if on is not None else None,
        "on_90_minus_nrst_90_s": (
            on - nrst if on is not None and nrst is not None else None
        ),
    }


event_discovery = discover_events
discover_reset_events = discover_events


def _parse_simulator_number(token: str) -> float:
    token = token.strip().rstrip(",;")
    match = re.fullmatch(rf"({_NUMBER})(meg|[fpnumkgtu])?", token, re.IGNORECASE)
    if not match:
        raise ValueError(f"not a simulator number: {token}")
    value = float(match.group(1).replace("D", "E").replace("d", "e"))
    suffix = (match.group(2) or "").lower()
    scale = {
        "f": 1e-15,
        "p": 1e-12,
        "n": 1e-9,
        "u": 1e-6,
        "m": 1e-3,
        "k": 1e3,
        "meg": 1e6,
        "g": 1e9,
        "t": 1e12,
    }.get(suffix, 1.0)
    result = value * scale
    if not math.isfinite(result):
        raise ValueError("non-finite simulator number")
    return result


def _normalise_trace_name(name: str) -> str | None:
    value = name.strip().strip('"').replace("\\", "").lower()
    while value.startswith("v(") and value.endswith(")"):
        value = value[2:-1].strip()
    compact = re.sub(r"[^a-z0-9]", "", value)
    return {
        "time": "time",
        "vdda18": "vdd",
        "pixrst": "pixrst",
        "onsense": "on",
        "nrstsense": "nrst",
        "vdiffsense": "vdiff",
    }.get(compact)


def _parse_named_rows(text: str) -> tuple[list[float], dict[str, list[float]]]:
    in_values = False
    current: dict[str, float] | None = None
    records: list[dict[str, float]] = []
    for line in text.splitlines():
        if line.strip().upper() == "VALUE":
            in_values = True
            continue
        if not in_values or not line.strip():
            continue
        match = re.match(r'^\s*"([^"]+)"\s+(.+?)\s*$', line)
        if match is None:
            continue
        name, token_text = match.groups()
        key = _normalise_trace_name(name)
        if key is None:
            continue
        number_match = re.search(
            rf"({_NUMBER}(?:meg|[fpnumkgtu])?)", token_text, re.IGNORECASE
        )
        if number_match is None:
            raise ValueError(f"missing numeric value for {name}")
        value = _parse_simulator_number(number_match.group(1))
        if key == "time":
            if current is not None:
                records.append(current)
            current = {"time": value}
        elif current is None:
            raise ValueError(f"canonical trace {key} appears before time")
        elif key in current:
            raise ValueError(f"duplicate canonical trace {key} in PSFASCII record")
        else:
            current[key] = value
    if current is not None:
        records.append(current)
    if not records:
        raise ValueError("PSFASCII result has no VALUE records")
    if any(set(record) != {"time", *_RESET_TRACES} for record in records):
        raise ValueError("PSFASCII result has missing or unequal traces")
    times = [record["time"] for record in records]
    traces = {key: [record[key] for record in records] for key in _RESET_TRACES}
    return _trace_data(times, traces)


def parse_psfascii(raw: str | Path) -> tuple[list[float], dict[str, list[float]]]:
    """Parse the named VALUE records emitted by Spectre PSFASCII."""
    if isinstance(raw, Path) and raw.is_dir():
        candidates = [child for child in raw.rglob("tran.tran.tran") if child.is_file()]
        if len(candidates) != 1:
            raise ValueError(
                f"PSFASCII directory must contain exactly one tran.tran.tran payload; found {len(candidates)}"
            )
        text = candidates[0].read_text(encoding="utf-8", errors="replace")
    else:
        text = _raw_text(raw)
    return _parse_named_rows(text)


def _variable_names(text: str) -> list[str]:
    match_start = re.search(r"\bVARIABLES:\s*", text, re.IGNORECASE)
    match_end = re.search(r"\bVALUES:\s*", text, re.IGNORECASE)
    if (
        match_start is None
        or match_end is None
        or match_end.start() <= match_start.end()
    ):
        return []
    names: list[str] = []
    for line in text[match_start.end() : match_end.start()].splitlines():
        match = re.match(r"\s*\d+\s+(\S+)", line)
        if match:
            names.append(match.group(1))
    return names


def parse_ngspice_ascii(raw: str | Path) -> tuple[list[float], dict[str, list[float]]]:
    """Parse a conventional NGSPICE ASCII raw file into canonical traces."""
    text = _raw_text(raw)
    names = _variable_names(text)
    if not names:
        # A named VALUE witness is useful for small parser tests and is also
        # accepted by NGSPICE wrappers that convert the header before parsing.
        return _parse_named_rows(text)
    values_match = re.search(r"\bVALUES:\s*", text, re.IGNORECASE)
    if values_match is None:
        raise ValueError("NGSPICE ASCII result has no VALUES section")
    rows: list[list[float]] = []
    current: list[float] | None = None

    def flush() -> None:
        if current:
            rows.append(list(current))

    for line in text[values_match.end() :].splitlines():
        stripped = line.strip()
        if not stripped:
            continue
        parts = stripped.split()
        indexed = re.match(r"^(\d+)\s+(.*)$", stripped)
        if indexed is not None:
            flush()
            current = []
            parts = indexed.group(2).split()
        elif current is None:
            continue
        numeric: list[float] = []
        for token in parts:
            try:
                numeric.append(_parse_simulator_number(token))
            except ValueError:
                break
        if numeric:
            if current is None:
                current = []
            current.extend(numeric)
    flush()
    if not rows:
        raise ValueError("NGSPICE ASCII result has no data rows")
    if any(len(row) < len(names) for row in rows):
        raise ValueError("NGSPICE ASCII result has incomplete data rows")
    indices: dict[str, int] = {}
    for index, name in enumerate(names):
        key = _normalise_trace_name(name)
        if key is None:
            continue
        if key in indices:
            raise ValueError(f"duplicate canonical trace {key} in NGSPICE variables")
        indices[key] = index
    missing = (set(_RESET_TRACES) | {"time"}) - set(indices)
    if missing:
        raise ValueError(
            "NGSPICE ASCII result is missing traces: " + ", ".join(sorted(missing))
        )
    times = [row[indices["time"]] for row in rows]
    traces = {key: [row[indices[key]] for row in rows] for key in _RESET_TRACES}
    return _trace_data(times, traces)


read_psfascii = parse_psfascii
read_ngspice_ascii = parse_ngspice_ascii
parse_psf_ascii = parse_psfascii
parse_ng_ascii = parse_ngspice_ascii


def _raw_text(raw: str | Path) -> str:
    if isinstance(raw, Path):
        if raw.is_file():
            return raw.read_text(encoding="utf-8", errors="replace")
        if raw.is_dir():
            chunks = [
                child.read_text(encoding="utf-8", errors="replace")
                for child in sorted(raw.rglob("*"))
                if child.is_file()
            ]
            return "\n".join(chunks)
        raise ValueError(f"raw output does not exist: {raw}")
    if not isinstance(raw, str):
        raise ValueError("raw output must be text or a path")
    return raw


def parse_raw_output(
    raw: str | Path, path: str
) -> tuple[list[float], dict[str, list[float]]]:
    """Parse raw output according to the registered simulator path."""
    if path == "quantus_rcc_spectre":
        return parse_psfascii(raw)
    if path in {"magic_rcc_ngspice", "schematic_ngspice"}:
        return parse_ngspice_ascii(raw)
    raise ValueError(f"unsupported simulation path: {path}")


def _has_simulator_error(log_text: str) -> bool:
    for line in log_text.splitlines():
        lowered = line.lower()
        if re.search(r"\b(?:fatal|segmentation fault|abort)\b", lowered):
            return True
        if re.search(r"\berror\b", lowered) and not re.search(
            r"\b(?:no errors|0 errors|errors?\s*[:=]\s*0)\b", lowered
        ):
            return True
    return False


def _spectre_completion_is_clean(log_text: str) -> bool:
    summaries = list(_COMPLETION_RE.finditer(log_text))
    return bool(summaries) and all(
        int(summary.group(1)) == 0 and int(summary.group(2)) == 0
        for summary in summaries
    )


def _base_result(row: dict[str, Any]) -> dict[str, Any]:
    return {
        "row_id": _row_id(row, row["condition"]),
        "execution_validity": "fail",
        "scientific_validity": "pending",
        "spec_result": "not_evaluated",
        "comparison": "not_evaluated",
        "errors": [],
    }


def classify_execution(
    row: dict[str, Any],
    exit_code: int,
    log_text: str,
    raw_times: list[float],
    traces: dict[str, list[float]],
    windows: list[tuple[float, float]],
) -> dict[str, Any]:
    """Classify mechanical execution separately from scientific validity."""
    _condition(row)
    result = _base_result(row)
    if exit_code != 0:
        result["errors"].append(f"simulator exit code {exit_code}")
        return result
    if not isinstance(log_text, str):
        result["errors"].append("simulator log must be text")
        return result
    if _condition(row)[
        "path"
    ] == "quantus_rcc_spectre" and not _spectre_completion_is_clean(log_text):
        result["errors"].append("Spectre completion summary is missing or not clean")
    if _has_simulator_error(log_text):
        result["errors"].append("simulator reported an error")
    try:
        parsed_times, parsed_traces = _trace_data(raw_times, traces)
        if not windows:
            raise ValueError("edge windows are missing")
        validate_edge_spacing(
            parsed_times,
            windows,
            _condition(row)["analysis_conditions"]["edge_window_max_step_s"],
        )
        _validate_registered_stop(parsed_times, _condition(row)["stimulus"]["stop_s"])
    except ValueError as exc:
        result["errors"].append(str(exc))
        return result
    if result["errors"]:
        return result

    result["execution_validity"] = "pass"
    try:
        discovery = discover_events(parsed_times, parsed_traces)
        metrics = compute_reset_metrics(parsed_times, parsed_traces)
        result["discovery"] = discovery
        result["metrics"] = metrics
        result["spec_result"] = evaluate_reset_spec(metrics)
        result["scientific_validity"] = "valid"
    except ValueError as exc:
        result["scientific_validity"] = "invalid"
        result["errors"].append(str(exc))
    return result


def _sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def _source_map_value(value: Any, key: str) -> str:
    if isinstance(value, str):
        return value
    if isinstance(value, dict) and isinstance(value.get("path"), str):
        return value["path"]
    raise ValueError(f"source map entry {key} must be a path or {{path: ...}} object")


def _resolve_source_map(
    source_map: dict[str, Any], source_map_path: Path
) -> dict[str, str]:
    if isinstance(source_map.get("sources"), dict):
        source_map = source_map["sources"]
    required = set(SOURCE_HASHES) | set(TOOLCHAIN_HASHES)
    missing = sorted(required - set(source_map))
    if missing:
        raise ValueError("source map is missing " + ", ".join(missing))
    resolved: dict[str, str] = {}
    for key in required:
        path = Path(_source_map_value(source_map[key], key)).expanduser()
        if not path.is_absolute():
            path = source_map_path.parent / path
        resolved[key] = str(path.resolve())
    return resolved


def _verify_derived_ngspice_sources(
    sources: dict[str, str],
    computed: dict[str, str],
    *,
    paths: tuple[str, ...] = ("magic_rcc_ngspice", "schematic_ngspice"),
) -> None:
    """Re-derive adapted DUTs from checked bases and require byte identity."""
    keys = {
        "magic_rcc_ngspice": ("magic_netlist", "magic_reset_netlist"),
        "schematic_ngspice": ("schematic_netlist", "schematic_reset_netlist"),
    }
    for path in paths:
        if path not in keys:
            raise ValueError(f"unsupported adapted source path: {path}")
        base_key, adapted_key = keys[path]
        try:
            base_path = Path(sources[base_key])
            adapted_path = Path(sources[adapted_key])
            base_sha256 = computed[base_key]
            registered_adapted_sha256 = computed[adapted_key]
        except KeyError as exc:
            raise ValueError(
                f"adapted source verification is missing {exc.args[0]}"
            ) from exc
        try:
            expected = _DERIVE.derive(path, base_path.read_bytes(), base_sha256)
            actual = adapted_path.read_bytes()
        except OSError as exc:
            raise ValueError(f"cannot verify adapted source for {path}: {exc}") from exc
        if hashlib.sha256(actual).hexdigest() != registered_adapted_sha256:
            raise ValueError(f"adapted source hash record is inconsistent for {path}")
        if actual != expected:
            raise ValueError(
                f"adapted source for {path} does not match deterministic derivation from checked base"
            )


def _verify_sources(source_map_path: Path) -> tuple[dict[str, str], dict[str, str]]:
    """Resolve and hash all inputs before the output tree is touched."""
    try:
        source_map = json.loads(source_map_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ValueError(f"cannot read source map {source_map_path}: {exc}") from exc
    if not isinstance(source_map, dict):
        raise ValueError("source map must be an object")
    sources = _resolve_source_map(source_map, source_map_path)
    computed: dict[str, str] = {}
    for key, expected in {**SOURCE_HASHES, **TOOLCHAIN_HASHES}.items():
        path = Path(sources[key])
        if not path.is_file():
            raise ValueError(f"required source file does not exist: {path}")
        actual = _sha256_file(path)
        computed[key] = actual
        if actual != expected:
            raise ValueError(f"source hash mismatch for {key}: {actual} != {expected}")
    _verify_derived_ngspice_sources(sources, computed)
    return sources, computed


def _source_fingerprint(source_hashes: dict[str, str]) -> str:
    return hashlib.sha256(_canonical_json(source_hashes).encode("utf-8")).hexdigest()


def _deck_fingerprint(deck: str, source_hashes: dict[str, str], extra: str = "") -> str:
    return hashlib.sha256(
        (_source_fingerprint(source_hashes) + "\n" + deck + "\n" + extra).encode(
            "utf-8"
        )
    ).hexdigest()


def _attempt_dirs(base: Path) -> list[Path]:
    if not base.is_dir():
        return []
    attempts = [
        candidate
        for candidate in base.glob("attempt-*")
        if candidate.is_dir() and candidate.name.removeprefix("attempt-").isdigit()
    ]
    return sorted(attempts, key=lambda item: int(item.name.removeprefix("attempt-")))


def _next_attempt(base: Path) -> Path:
    attempts = _attempt_dirs(base)
    next_number = (
        1 if not attempts else int(attempts[-1].name.removeprefix("attempt-")) + 1
    )
    return base / f"attempt-{next_number}"


def _confined_attempt(base: Path, attempt: Path) -> bool:
    try:
        resolved_base = base.resolve(strict=True)
        resolved_attempt = attempt.resolve(strict=True)
    except OSError:
        return False
    return (
        resolved_attempt.parent == resolved_base
        and resolved_attempt.is_dir()
        and re.fullmatch(r"attempt-\d+", resolved_attempt.name) is not None
    )


def _attempt_provenance_matches(
    base: Path,
    attempt: Path,
    result: dict[str, Any],
    fingerprint: str,
    stage: str | None,
    row: dict[str, Any],
    source_hashes: dict[str, str],
    *,
    require_log_hash: bool = True,
) -> bool:
    if not _confined_attempt(base, attempt):
        return False
    try:
        condition = _condition(row)
        expected_row_id = _row_id(row, condition)
        fingerprint_record = json.loads(
            (attempt / "fingerprint.json").read_text(encoding="utf-8")
        )
    except (OSError, json.JSONDecodeError, ValueError):
        return False
    expected_stage = result.get("stage") if stage is None else stage
    if not isinstance(expected_stage, str):
        return False
    if any(
        (
            result.get("row_id") != expected_row_id,
            result.get("condition") != condition,
            result.get("fingerprint") != fingerprint,
            result.get("stage") != expected_stage,
            result.get("source_hashes") != source_hashes,
            fingerprint_record.get("fingerprint") != fingerprint,
            fingerprint_record.get("stage") != expected_stage,
            fingerprint_record.get("source_hashes") != source_hashes,
            fingerprint_record.get("source_fingerprint")
            != _source_fingerprint(source_hashes),
        )
    ):
        return False
    input_path = attempt / (
        "input.scs" if condition["path"] == "quantus_rcc_spectre" else "input.deck"
    )
    raw_path = attempt / (
        "raw_output" if condition["path"] == "quantus_rcc_spectre" else "raw_output.raw"
    )
    metrics_path = (
        attempt / "metrics_psfascii"
        if condition["path"] == "quantus_rcc_spectre"
        else None
    )
    log_path = attempt / "simulator.log"
    try:
        deck_sha256 = _sha256_file(input_path)
        raw_sha256 = _raw_sha256(raw_path)
        metrics_sha256 = (
            _raw_sha256(metrics_path) if metrics_path is not None else None
        )
        log_sha256 = _sha256_file(log_path)
    except OSError:
        return False
    return (
        result.get("deck_sha256") == deck_sha256
        and fingerprint_record.get("deck_sha256") == deck_sha256
        and result.get("raw_sha256") == raw_sha256
        and (
            metrics_path is None
            or result.get("metrics_psfascii_sha256") == metrics_sha256
        )
        and (not require_log_hash or result.get("simulator_log_sha256") == log_sha256)
    )


def _existing_pass(
    base: Path,
    fingerprint: str,
    stage: str | None,
    row: dict[str, Any],
    source_hashes: dict[str, str],
) -> tuple[Path, dict[str, Any]] | None:
    for attempt in _attempt_dirs(base):
        result_path = attempt / "result.json"
        try:
            result = json.loads(result_path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            continue
        if (
            result.get("execution_validity") == "pass"
            and result.get("scientific_validity") == "valid"
            and result.get("classifier_sha256")
            == _sha256_file(Path(__file__).resolve())
            and _attempt_provenance_matches(
                base, attempt, result, fingerprint, stage, row, source_hashes
            )
        ):
            return attempt, result

    classifier_sha256 = _sha256_file(Path(__file__).resolve())
    source_fingerprint = _source_fingerprint(source_hashes)
    for record_path in (
        sorted(base.glob("reclassification-*.json")) if base.is_dir() else []
    ):
        try:
            record = json.loads(record_path.read_text(encoding="utf-8"))
            attempt = Path(record["reclassified_from"])
        except (OSError, json.JSONDecodeError, KeyError, TypeError):
            continue
        if not _confined_attempt(base, attempt):
            continue
        original_path = attempt / "result.json"
        try:
            original = json.loads(original_path.read_text(encoding="utf-8"))
            original_sha256 = _sha256_file(original_path)
        except (OSError, json.JSONDecodeError):
            continue
        if not _attempt_provenance_matches(
            base,
            attempt,
            original,
            fingerprint,
            stage,
            row,
            source_hashes,
            require_log_hash=False,
        ):
            continue
        try:
            recorded_directory_matches = Path(record.get("directory", "")).resolve(
                strict=True
            ) == attempt.resolve(strict=True)
            log_sha256 = _sha256_file(attempt / "simulator.log")
        except (OSError, TypeError):
            recorded_directory_matches = False
            log_sha256 = None
        if any(
            (
                record.get("reclassified_result_sha256") != original_sha256,
                record.get("classifier_sha256") != classifier_sha256,
                record.get("raw_sha256") != original.get("raw_sha256"),
                record.get("simulator_log_sha256") != log_sha256,
                record.get("row_id") != _row_id(row, _condition(row)),
                record.get("fingerprint") != fingerprint,
                stage is not None and record.get("stage") != stage,
                record.get("source_hashes") != source_hashes,
                record.get("source_fingerprint") != source_fingerprint,
                not recorded_directory_matches,
                record.get("execution_validity") != "pass",
                record.get("scientific_validity") != "valid",
            )
        ):
            continue
        return attempt, record
    return None


def _reclassify_existing_discovery(
    row: dict[str, Any],
    base: Path,
    fingerprint: str,
    source_hashes: dict[str, str],
) -> dict[str, Any] | None:
    """Reclassify preserved raw discovery data without mutating its attempt."""
    condition = _condition(row)
    classifier_sha256 = _sha256_file(Path(__file__).resolve())
    for attempt in reversed(_attempt_dirs(base)):
        result_path = attempt / "result.json"
        try:
            previous = json.loads(result_path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            continue
        if (
            previous.get("stage") != "discovery"
            or previous.get("fingerprint") != fingerprint
        ):
            continue
        if not _attempt_provenance_matches(
            base,
            attempt,
            previous,
            fingerprint,
            "discovery",
            row,
            source_hashes,
            require_log_hash=False,
        ):
            continue
        raw_path = attempt / (
            "raw_output"
            if condition["path"] == "quantus_rcc_spectre"
            else "raw_output.raw"
        )
        parse_path = (
            attempt / "metrics_psfascii"
            if condition["path"] == "quantus_rcc_spectre"
            else raw_path
        )
        log_path = attempt / "simulator.log"
        exit_path = attempt / "exit_code"
        if (
            not raw_path.exists()
            or not parse_path.exists()
            or not log_path.is_file()
            or not exit_path.is_file()
        ):
            continue
        raw_sha256 = _raw_sha256(raw_path)
        log_sha256 = _sha256_file(log_path)
        if previous.get("raw_sha256") != raw_sha256:
            continue
        try:
            exit_code = int(exit_path.read_text(encoding="utf-8").strip())
            raw_times, traces = parse_raw_output(parse_path, condition["path"])
            classified = _classify_discovery(
                row,
                exit_code,
                log_path.read_text(encoding="utf-8", errors="replace"),
                raw_times,
                traces,
            )
        except (OSError, ValueError):
            continue
        if not (
            classified.get("execution_validity") == "pass"
            and classified.get("scientific_validity") == "valid"
        ):
            continue
        previous_result_sha256 = _sha256_file(result_path)
        record = dict(previous)
        record.update(classified)
        record.update(
            {
                "schema_version": 1,
                "status": "reclassified",
                "resource_outcome": "reused_preserved_raw",
                "directory": str(attempt),
                "reclassified_from": str(attempt),
                "reclassified_result_sha256": previous_result_sha256,
                "classifier_sha256": classifier_sha256,
                "raw_sha256": raw_sha256,
                "simulator_log_sha256": log_sha256,
                "source_fingerprint": _source_fingerprint(source_hashes),
            }
        )
        record_path = base / (
            f"reclassification-{attempt.name}-{classifier_sha256[:12]}.json"
        )
        _write_once_or_equal_json(record_path, record)
        return record
    return None


def _atomic_write_text(path: Path, text: str) -> None:
    temporary = path.with_name(path.name + ".tmp")
    temporary.write_text(text, encoding="utf-8")
    os.replace(temporary, path)


def _atomic_write_json(path: Path, value: Any) -> None:
    _atomic_write_text(
        path, json.dumps(value, sort_keys=True, indent=2, allow_nan=False) + "\n"
    )


def _write_once_or_equal_json(path: Path, value: Any) -> None:
    """Write JSON once, allowing only a canonical-equivalent rerun."""
    expected = _canonical_json(value)
    if path.exists():
        try:
            existing = json.loads(path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            raise ValueError(f"existing JSON at {path} is unreadable") from exc
        if _canonical_json(existing) != expected:
            raise ValueError(f"refusing to overwrite different JSON at {path}")
        return
    _atomic_write_json(path, value)


def _atomic_attempt(base: Path) -> tuple[Path, Path]:
    base.mkdir(parents=True, exist_ok=True)
    final = _next_attempt(base)
    temporary = base / f"{final.name}.tmp-{os.getpid()}"
    counter = 1
    while temporary.exists() or final.exists():
        final = base / f"attempt-{int(final.name.removeprefix('attempt-')) + 1}"
        temporary = base / f"{final.name}.tmp-{os.getpid()}-{counter}"
        counter += 1
    temporary.mkdir(parents=False, exist_ok=False)
    return final, temporary


def _read_raw_path(path: Path) -> str:
    return _raw_text(path) if path.exists() else ""


def _raw_sha256(path: Path) -> str:
    if path.is_file():
        return _sha256_file(path)
    digest = hashlib.sha256()
    if path.is_dir():
        for child in sorted(path.rglob("*")):
            if child.is_file():
                digest.update(str(child.relative_to(path)).encode("utf-8"))
                digest.update(b"\0")
                with child.open("rb") as handle:
                    for block in iter(lambda: handle.read(1024 * 1024), b""):
                        digest.update(block)
    return digest.hexdigest()


def _run_attempt(
    row: dict[str, Any],
    sources: dict[str, str],
    source_hashes: dict[str, str],
    base: Path,
    deck: str,
    stage: str,
    fingerprint: str,
    prepare_only: bool,
    timeout_s: float | None,
    discovery: dict[str, Any] | None = None,
    windows: list[tuple[float, float]] | None = None,
) -> dict[str, Any]:
    condition = _condition(row)
    final, temporary = _atomic_attempt(base)
    input_name = (
        "input.scs" if condition["path"] == "quantus_rcc_spectre" else "input.deck"
    )
    input_path = temporary / input_name
    _atomic_write_text(input_path, deck)
    startup_sha256 = None
    if condition["path"] != "quantus_rcc_spectre":
        startup = _ngspice_startup_text()
        _atomic_write_text(temporary / ".spiceinit", startup)
        startup_sha256 = hashlib.sha256(startup.encode("utf-8")).hexdigest()
    if stage == "replay" and windows is not None:
        _atomic_write_text(
            temporary / "edge_grid.inc",
            render_edge_grid(
                condition["path"],
                windows,
                condition["analysis_conditions"]["edge_window_max_step_s"],
            ),
        )
    command = _STATIC._bounded_simulator_command(
        simulator_command(row, final, sources), condition["path"], timeout_s
    )
    run_command = _STATIC._bounded_simulator_command(
        simulator_command(row, temporary, sources), condition["path"], timeout_s
    )
    metrics_command = None
    run_metrics_command = None
    if condition["path"] == "quantus_rcc_spectre":
        metrics_command = psf_metrics_command(final, sources, timeout_s)
        run_metrics_command = psf_metrics_command(temporary, sources, timeout_s)
        _atomic_write_json(temporary / "metrics_command.json", metrics_command)
        _atomic_write_text(
            temporary / "metrics_command.txt", shlex.join(metrics_command) + "\n"
        )
    _atomic_write_json(
        temporary / "fingerprint.json",
        {
            "fingerprint": fingerprint,
            "deck_sha256": hashlib.sha256(deck.encode("utf-8")).hexdigest(),
            "source_fingerprint": _source_fingerprint(source_hashes),
            "source_hashes": source_hashes,
            "ngspice_startup_sha256": startup_sha256,
            "stage": stage,
        },
    )
    _atomic_write_json(temporary / "command.json", command)
    _atomic_write_text(temporary / "command.txt", shlex.join(command) + "\n")
    result: dict[str, Any] = {
        "schema_version": 1,
        "row_id": _row_id(row, condition),
        "condition": condition,
        "stage": stage,
        "fingerprint": fingerprint,
        "classifier_sha256": _sha256_file(Path(__file__).resolve()),
        "deck_sha256": hashlib.sha256(deck.encode("utf-8")).hexdigest(),
        "source_hashes": source_hashes,
        "source_fingerprint": _source_fingerprint(source_hashes),
        "ngspice_startup_sha256": startup_sha256,
        "execution_validity": "pending",
        "scientific_validity": "pending",
        "spec_result": "not_evaluated",
        "comparison": "not_evaluated",
        "exit_code": None,
        "resource_outcome": "not_run" if prepare_only else "pending",
        "timeout_s": timeout_s,
        "command": command,
        "executed_command": run_command,
        "directory": str(final),
    }
    if metrics_command is not None and run_metrics_command is not None:
        result["metrics_command"] = metrics_command
        result["executed_metrics_command"] = run_metrics_command
        result["stored_voltage_scope"] = "all public circuit-node voltages"
        result["stored_current_scope"] = "none"
        result["raw_output_format"] = "PSF binary"
    try:
        if prepare_only:
            _atomic_write_text(temporary / "stdout.txt", "")
            _atomic_write_text(temporary / "stderr.txt", "")
            _atomic_write_text(
                temporary / "simulator.log", "not run (--prepare-only)\n"
            )
            if condition["path"] == "quantus_rcc_spectre":
                (temporary / "raw_output").mkdir()
                (temporary / "metrics_psfascii").mkdir()
            else:
                _atomic_write_text(temporary / "raw_output.raw", "")
            _atomic_write_text(temporary / "exit_code", "not-run\n")
            result["status"] = "prepared"
        else:
            try:
                completed = _STATIC._run_subprocess(run_command, temporary)
                stdout = completed.stdout or ""
                stderr = completed.stderr or ""
                exit_code = completed.returncode
                resource_outcome = (
                    "timeout"
                    if completed.returncode == 124 and timeout_s is not None
                    else "completed"
                )
                if resource_outcome == "timeout":
                    stderr += f"\nprocess timed out after {timeout_s} seconds\n"
            except OSError as exc:
                stdout = ""
                stderr = f"{exc}\n"
                exit_code = 127
                resource_outcome = "launch_error"
            _atomic_write_text(temporary / "stdout.txt", stdout)
            _atomic_write_text(temporary / "stderr.txt", stderr)
            log_path = temporary / "simulator.log"
            if log_path.exists():
                log_text = log_path.read_text(encoding="utf-8", errors="replace")
            else:
                log_text = stdout + ("\n" if stdout and stderr else "") + stderr
                _atomic_write_text(log_path, log_text)
            raw_path = temporary / (
                "raw_output"
                if condition["path"] == "quantus_rcc_spectre"
                else "raw_output.raw"
            )
            parse_path = raw_path
            if condition["path"] == "quantus_rcc_spectre":
                parse_path = temporary / "metrics_psfascii"
                parse_path.mkdir(exist_ok=False)
                metrics_stdout = ""
                metrics_stderr = ""
                metrics_exit_code = None
                if exit_code == 0 and (raw_path / "tran.tran.tran").is_file():
                    try:
                        assert run_metrics_command is not None
                        metrics_completed = _STATIC._run_subprocess(
                            run_metrics_command, temporary
                        )
                        metrics_stdout = metrics_completed.stdout or ""
                        metrics_stderr = metrics_completed.stderr or ""
                        metrics_exit_code = metrics_completed.returncode
                    except OSError as exc:
                        metrics_stderr = f"{exc}\n"
                        metrics_exit_code = 127
                _atomic_write_text(
                    temporary / "metrics_stdout.txt", metrics_stdout
                )
                _atomic_write_text(
                    temporary / "metrics_stderr.txt", metrics_stderr
                )
                _atomic_write_text(
                    temporary / "metrics_exit_code",
                    "not-run\n"
                    if metrics_exit_code is None
                    else f"{metrics_exit_code}\n",
                )
                result["metrics_extraction_exit_code"] = metrics_exit_code
                result["metrics_psfascii"] = str(final / "metrics_psfascii")
                result["metrics_psfascii_sha256"] = _raw_sha256(parse_path)
            try:
                if (
                    condition["path"] == "quantus_rcc_spectre"
                    and result.get("metrics_extraction_exit_code") != 0
                ):
                    raise ValueError("PSF metric extraction did not exit cleanly")
                raw_times, traces = parse_raw_output(
                    parse_path if parse_path.exists() else "", condition["path"]
                )
            except ValueError as exc:
                raw_times, traces = [], {}
                result["parse_error"] = str(exc)
            classified = (
                _classify_discovery(row, exit_code, log_text, raw_times, traces)
                if stage == "discovery"
                else classify_execution(
                    row, exit_code, log_text, raw_times, traces, windows or []
                )
            )
            result.update(classified)
            result.update(
                {
                    "exit_code": exit_code,
                    "status": "complete",
                    "resource_outcome": resource_outcome,
                    "log": str(final / "simulator.log"),
                    "simulator_log_sha256": _sha256_file(log_path),
                    "raw_output": str(final / raw_path.name),
                    "raw_sha256": _raw_sha256(raw_path),
                }
            )
            _atomic_write_text(temporary / "exit_code", f"{exit_code}\n")
        if "simulator_log_sha256" not in result:
            result["simulator_log_sha256"] = _sha256_file(temporary / "simulator.log")
        if discovery is not None:
            result["discovery"] = discovery
        _atomic_write_json(temporary / "result.json", result)
        os.replace(temporary, final)
    except BaseException:
        # The final attempt name is never exposed until every file is complete.
        # Keep no partial attempt directory after a failed local preparation.
        for child in sorted(temporary.rglob("*"), reverse=True):
            if child.is_file() or child.is_symlink():
                child.unlink()
            elif child.is_dir():
                child.rmdir()
        temporary.rmdir()
        raise
    return result


def _classify_discovery(
    row: dict[str, Any],
    exit_code: int,
    log_text: str,
    raw_times: list[float],
    traces: dict[str, list[float]],
) -> dict[str, Any]:
    result = _base_result(row)
    if exit_code != 0:
        result["errors"].append(f"simulator exit code {exit_code}")
        return result
    if not isinstance(log_text, str) or _has_simulator_error(log_text):
        result["errors"].append("simulator reported an error")
        return result
    if _condition(row)[
        "path"
    ] == "quantus_rcc_spectre" and not _spectre_completion_is_clean(log_text):
        result["errors"].append("Spectre completion summary is missing or not clean")
        return result
    try:
        parsed_times, parsed_traces = _trace_data(raw_times, traces)
        protocol_mode = _condition(row)["stimulus"].get("protocol_mode")
        if protocol_mode == "fixed_common_timeline_v1":
            discovery = discover_fixed_timeline_events(parsed_times, parsed_traces)
        elif protocol_mode == "exact_frozen_cace":
            discovery = discover_exact_cace_protocol_events(parsed_times, parsed_traces)
        else:
            discovery = discover_events(parsed_times, parsed_traces)
        _validate_discovery_stop(row, parsed_times, parsed_traces, discovery)
    except ValueError as exc:
        result["errors"].append(str(exc))
        return result
    result.update(
        {
            "execution_validity": "pass",
            "discovery": discovery,
        }
    )
    scientific_failure = _STATIC._scientific_failure(_condition(row), log_text)
    if scientific_failure is not None:
        result["scientific_validity"] = "invalid"
        result["errors"].append(scientific_failure)
        return result
    try:
        metrics = compute_cace_reset_metrics(parsed_times, parsed_traces)
        if protocol_mode == "fixed_common_timeline_v1":
            event_evidence = describe_fixed_timeline_event_evidence(
                parsed_times, parsed_traces
            )
            comparison_metrics = fixed_timeline_measurements(
                parsed_times, parsed_traces
            )
            metric_method = "cace_postprocessor_on_fixed_common_timeline"
        else:
            event_evidence = describe_exact_cace_event_evidence(
                parsed_times, parsed_traces
            )
            comparison_metrics = None
            metric_method = "frozen_cace_postprocessor"
    except ValueError as exc:
        result["scientific_validity"] = "invalid"
        result["errors"].append(str(exc))
        return result
    result.update(
        {
            "scientific_validity": "valid",
            "metrics": metrics,
            "spec_result": evaluate_reset_spec(metrics),
            "metric_method": metric_method,
            "event_evidence": event_evidence,
        }
    )
    if comparison_metrics is not None:
        result["fixed_timeline_measurements"] = comparison_metrics
    return result


def _run_row(
    row: dict[str, Any],
    sources: dict[str, str],
    source_hashes: dict[str, str],
    output: Path,
    prepare_only: bool,
    timeout_s: float | None,
) -> dict[str, Any]:
    condition = _condition(row)
    base = output / condition["path"] / condition["analysis"] / _row_id(row, condition)
    discovery_deck = build_discovery_deck(row, sources)
    validate_deck(row, discovery_deck, sources, stage="discovery")
    startup_fingerprint = (
        _ngspice_startup_text() if condition["path"] != "quantus_rcc_spectre" else ""
    )
    discovery_fp = _deck_fingerprint(discovery_deck, source_hashes, startup_fingerprint)
    if not prepare_only:
        _reclassify_existing_discovery(row, base, discovery_fp, source_hashes)
    existing = _existing_pass(base, discovery_fp, "discovery", row, source_hashes)
    if existing is None:
        discovery_result = _run_attempt(
            row,
            sources,
            source_hashes,
            base,
            discovery_deck,
            "discovery",
            discovery_fp,
            prepare_only,
            timeout_s,
        )
    else:
        attempt, discovery_result = existing
        discovery_result = dict(discovery_result)
        discovery_result.update({"status": "reused", "directory": str(attempt)})
    if prepare_only or not (
        discovery_result.get("execution_validity") == "pass"
        and discovery_result.get("scientific_validity") == "valid"
    ):
        return discovery_result

    if condition["stimulus"].get("protocol_mode") in {
        "exact_frozen_cace",
        "fixed_common_timeline_v1",
    }:
        return discovery_result

    discovery = discovery_result.get("discovery")
    windows = edge_windows(row, discovery)
    edge_grid = render_edge_grid(
        condition["path"],
        windows,
        condition["analysis_conditions"]["edge_window_max_step_s"],
    )
    replay_deck = build_replay_deck(row, sources, discovery, "edge_grid.inc")
    validate_deck(row, replay_deck, sources, stage="replay")
    replay_fp = _deck_fingerprint(replay_deck, source_hashes, edge_grid)
    existing = _existing_pass(base, replay_fp, "replay", row, source_hashes)
    if existing is not None:
        attempt, replay_result = existing
        replay_result = dict(replay_result)
        replay_result.update({"status": "reused", "directory": str(attempt)})
        return replay_result
    return _run_attempt(
        row,
        sources,
        source_hashes,
        base,
        replay_deck,
        "replay",
        replay_fp,
        prepare_only,
        timeout_s,
        discovery=discovery,
        windows=windows,
    )


def _run_rows(
    rows: list[dict[str, Any]],
    sources: dict[str, str],
    source_hashes: dict[str, str],
    output: Path,
    prepare_only: bool,
    timeout_s: float | None,
) -> list[dict[str, Any]]:
    return [
        _run_row(row, sources, source_hashes, output, prepare_only, timeout_s)
        for row in rows
    ]


def _nominal_admission_value(
    manifest_hash: str, source_fingerprint: str, row_ids: list[str]
) -> dict[str, Any]:
    return {
        "manifest_sha256": manifest_hash,
        "source_fingerprint": source_fingerprint,
        "row_ids": list(row_ids),
        "execution_validity": "pass",
        "scientific_validity": "valid",
        "fixed_timeline_simulation_health": "pass",
    }


def _require_nominal_admission(
    output: Path,
    manifest_hash: str,
    source_fingerprint: str,
    row_ids: list[str],
) -> dict[str, str]:
    path = output / "nominal_admission.json"
    try:
        actual = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ValueError("matching nominal admission is missing") from exc
    expected = _nominal_admission_value(manifest_hash, source_fingerprint, row_ids)
    if actual != expected:
        raise ValueError("nominal admission does not match the current campaign")
    return {"path": str(path.resolve()), "sha256": _sha256_file(path)}


def _results_are_valid(results: list[dict[str, Any]]) -> bool:
    def admissible(result: dict[str, Any]) -> bool:
        if not (
            result.get("execution_validity") == "pass"
            and result.get("scientific_validity") == "valid"
        ):
            return False
        condition = result.get("condition")
        stimulus = condition.get("stimulus") if isinstance(condition, dict) else None
        if not isinstance(stimulus, dict) or stimulus.get("protocol_mode") != (
            "fixed_common_timeline_v1"
        ):
            return True
        evidence = result.get("event_evidence")
        health = (
            evidence.get("simulation_health") if isinstance(evidence, dict) else None
        )
        return isinstance(health, dict) and health.get("status") == "pass"

    return all(admissible(result) for result in results)


def _validate_manifest_for_execution(manifest: dict[str, Any]) -> None:
    _MANIFEST.validate_manifest(manifest)
    if manifest.get("schema_version") != _MANIFEST.SCHEMA_VERSION:
        raise ValueError("manifest schema_version is not the frozen campaign schema")
    if manifest.get("campaign_id") != _MANIFEST.CAMPAIGN_ID:
        raise ValueError("manifest campaign_id is not the frozen campaign")
    scope = manifest.get("scope")
    if (
        not isinstance(scope, dict)
        or scope.get("confirmation_data_accessed") is not False
    ):
        raise ValueError("confirmation data must not be accessed")
    if scope.get("confirmation_data_authorized") is not False:
        raise ValueError("confirmation data must not be authorized")


def _load_manifest(path: Path) -> tuple[dict[str, Any], str]:
    payload = path.read_bytes()
    manifest = json.loads(payload.decode("utf-8"))
    if not isinstance(manifest, dict):
        raise ValueError("manifest must be an object")
    return manifest, hashlib.sha256(payload).hexdigest()


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--sources", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--rung", choices=("nominal", "extremes", "all"), required=True)
    parser.add_argument("--nominal-output", type=Path)
    parser.add_argument("--prepare-only", action="store_true")
    parser.add_argument("--paths", default=None, help="comma list of paths to run (edit20260922l addition)")
    parser.add_argument("--shard", default=None, help="k/n: run every n-th selected row starting at k (edit20260922l addition)")
    parser.add_argument("--timeout-s", type=float, default=None)
    args = parser.parse_args(argv)
    ROW_FILTER["paths"] = set(args.paths.split(",")) if args.paths else None
    ROW_FILTER["shard"] = tuple(int(x) for x in args.shard.split("/")) if args.shard else None
    try:
        manifest, manifest_hash = _load_manifest(args.manifest)
        if args.timeout_s is not None and (
            not math.isfinite(args.timeout_s) or args.timeout_s <= 0
        ):
            raise ValueError("--timeout-s must be a finite positive number")
        _validate_manifest_for_execution(manifest)
        # This is deliberately before output.mkdir(): a bad manifest or source
        # claim cannot leave a newly-created campaign directory behind.
        sources, source_hashes = _verify_sources(args.sources)
        source_map_hash = _sha256_file(args.sources)
        source_fingerprint = _source_fingerprint(source_hashes)
        if args.rung == "all":
            rows_for_campaign = _pending_reset_rows(manifest)
        else:
            rows_for_campaign = select_pilot_rows(manifest, args.rung)
        rows_for_campaign = _selected_rows_filter(rows_for_campaign)

        nominal_rows = select_pilot_rows(manifest, "nominal")
        nominal_row_ids = [_row_id(row, row["condition"]) for row in nominal_rows]
        if args.rung == "extremes":
            if args.nominal_output is None:
                raise ValueError("--nominal-output is required for the extremes rung")
            nominal_admission = _require_nominal_admission(
                args.nominal_output,
                manifest_hash,
                source_fingerprint,
                nominal_row_ids,
            )
        elif args.nominal_output is not None:
            raise ValueError("--nominal-output is only valid for the extremes rung")
        else:
            nominal_admission = None

        args.output.mkdir(parents=True, exist_ok=True)
        campaign_metadata = {
            "manifest": str(args.manifest.resolve()),
            "manifest_sha256": manifest_hash,
            "source_map": str(args.sources.resolve()),
            "source_map_sha256": source_map_hash,
            "source_hashes": source_hashes,
            "rung": args.rung,
            "prepare_only": args.prepare_only,
            "timeout_s": args.timeout_s,
            "row_ids": [_row_id(row, row["condition"]) for row in rows_for_campaign],
        }
        if nominal_admission is not None:
            campaign_metadata["nominal_admission"] = nominal_admission
        _write_once_or_equal_json(args.output / "campaign.json", campaign_metadata)

        if args.prepare_only:
            results = _run_rows(
                rows_for_campaign,
                sources,
                source_hashes,
                args.output,
                True,
                args.timeout_s,
            )
        elif args.rung == "all":
            # edit20260922r19 patch: honour --paths/--shard for the pilot rows too
            # (the unpatched staging ran every path's nominal + extreme pilots in
            # every runner); the admission gates are diagnostic, non-fatal here.
            nominal_ids = {_row_id(r, r["condition"]) for r in nominal_rows}
            extreme_rows = select_pilot_rows(manifest, "extremes")
            extreme_ids = {_row_id(r, r["condition"]) for r in extreme_rows}
            selected = _selected_rows_filter(_pending_reset_rows(manifest))
            stages = (
                ("nominal", [r for r in selected if _row_id(r, r["condition"]) in nominal_ids]),
                ("extremes", [r for r in selected if _row_id(r, r["condition"]) in extreme_ids]),
                ("remaining", [r for r in selected if _row_id(r, r["condition"]) not in (nominal_ids | extreme_ids)]),
            )
            print(json.dumps({"status": "all_rung_selection_edit20260922r19", "counts": {k: len(v) for k, v in stages}}), flush=True)
            results = []
            for stage, stage_rows in stages:
                stage_results = _run_rows(
                    stage_rows, sources, source_hashes, args.output, False, args.timeout_s
                )
                results.extend(stage_results)
                if stage_rows and not _results_are_valid(stage_results):
                    print(json.dumps({"status": f"{stage}_not_admitted_continuing_edit20260922r19"}), flush=True)
            nominal_done = [r for r in results if r.get("row_id") in nominal_ids]
            if nominal_ids <= {r.get("row_id") for r in nominal_done} and _results_are_valid(nominal_done):
                _write_once_or_equal_json(
                    args.output / "nominal_admission.json",
                    _nominal_admission_value(manifest_hash, source_fingerprint, nominal_row_ids),
                )
        else:
            results = _run_rows(
                rows_for_campaign,
                sources,
                source_hashes,
                args.output,
                False,
                args.timeout_s,
            )
            if args.rung == "nominal" and _results_are_valid(results):
                _write_once_or_equal_json(
                    args.output / "nominal_admission.json",
                    _nominal_admission_value(
                        manifest_hash, source_fingerprint, nominal_row_ids
                    ),
                )
        status = "prepared" if args.prepare_only else "complete"
        print(json.dumps({"status": status, "results": results}, sort_keys=True))
        if args.prepare_only:
            return 0
        return 0 if _results_are_valid(results) else 1
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        print(f"reset campaign error: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
