"""Generate and run the frozen three-path static PVT campaign.

The manifest is the source of truth for every value in a generated deck.  The
runner deliberately handles only the three static analyses; reset and
automatic-read rows remain outside this bounded pilot.
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
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from typing import Any


def _load_manifest_contract():
    """Load the colocated manifest contract when this file is run or imported."""
    path = Path(__file__).with_name("campaign_manifest.py")
    spec = importlib.util.spec_from_file_location("_full_pvt_campaign_manifest", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load manifest contract from {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


_MANIFEST_CONTRACT = _load_manifest_contract()


# These six values are part of the frozen interface.  Toolchain hashes are
# kept separately so source and launcher identity cannot be conflated.
SOURCE_HASHES = {
    "quantus_netlist": "842cc5e2d846ef6a1cf4ead139235f378a2518e0067f65b3c3d834135241484a",
    "magic_netlist": "2195a17b357abcb202a1b36e70bb4342956ebee2ede20a8a952f61209c4866fa",
    "schematic_netlist": "6453d01af285ebb688036192a8e527087b1cd066e3f3d43b2de94a8e44e1e3a2",
    "native_model_library": "b7144180bb5d548a57113182e6244d991d1953beb1b0f6e5676b94d6884bdd67",
    "ngspice_model_library": "48de7c677e2c6e7d09b2559279de9f818be71010a4aa933d728eb4db3b133c84",
    "ngspice_binary": "857e68200e929cfd5c2ab0a52924b602715081f570aeb5736c284b733f3650a4",
    "ngspice_parasitic_diode_model": "47f9c12a2ff58b5602906873474b9a305e42bee36b09154cb7bf36b9002f5792",
    "ngspice_nonfet_corner_tt": "9e442b3828f29c8cf0a4d030c37b913fae11a23b00b58a4622d8bdf6909b56dd",
    "ngspice_nonfet_corner_ss": "7aa4c20bf9cc7d8e16239ccc750e435433f959123a2e6c2214a549f0f76395b1",
    "ngspice_nonfet_corner_ff": "d03e3604898888b64c71a6ddba5f03dd8a05b298ac6a10a5dc2ae1c01ab73a74",
    "ngspice_nonfet_corner_sf": "4f790eb5083d1e202820839b58099c423fc5aa83e6ede764b14e5eb70c8397f8",
    "ngspice_nonfet_corner_fs": "739c7e8da3ef68d2452f8f5e7a0f9d6696b8ee22cf58c4904e3bfa637fc23014",
}

TOOLCHAIN_HASHES = {
    "native_model_adapter": "56dc6a66ee6b45d42af8e6b0e5ffcc38c38faecd47414db94f4e651fc71aac29",
    "cadence_launcher": "8cc23e5355d28f953ea678e5bb5cb2aaba37259b7bc8372629047ec681d8f102",
}
_TOOLCHAIN_KEYS = tuple(TOOLCHAIN_HASHES)
_STATIC_ANALYSES = ("photoreceptor_dc", "comparator_dc", "ac_gain")
_PATHS = tuple(_MANIFEST_CONTRACT.PATHS)
_BIAS_NAMES = tuple(_MANIFEST_CONTRACT.BIAS_NAMES)
_MANIFEST_SOURCE_DEFINITIONS = _MANIFEST_CONTRACT.SOURCE_DEFINITIONS
_PIXELS = tuple(f"vpd[{index}]" for index in range(4))
_CONTROL_PINS = (
    "pixRst[0]",
    "pixRst[1]",
    "rowReadON[0]",
    "rowReadON[1]",
    "rowReadOFF[0]",
    "rowReadOFF[1]",
    "readLine[0]",
    "readLine[1]",
    "VddA18",
    "GndA",
    "GndD",
)
_CONTROL_PIN_FORCING = {
    **{pin: "inactive_low" for pin in _CONTROL_PINS[:8]},
    "VddA18": "rail_tied_to_vdd",
    "GndA": "rail_tied_to_ground",
    "GndD": "rail_tied_to_ground",
}
_TOP_PORTS = (
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
)
_BIAS_PIN_FORCING = {
    analysis: dict(_MANIFEST_CONTRACT._BIAS_PIN_FORCING[analysis])
    for analysis in _STATIC_ANALYSES
}
_MIRROR_SPECS = {
    "PrBp": {
        "polarity": "p",
        "model": "sky130_fd_pr__pfet_01v8",
        "L": "0.15u",
        "l": "0.15",
        "W": "0.5u",
        "w": "0.5",
        "ad": "0.145p",
        "as": "0.145p",
        "pd": "1.58u",
        "ps": "1.58u",
        "nrd": "0.58",
        "nrs": "0.58",
    },
    "PrSFBp": {
        "polarity": "p",
        "model": "sky130_fd_pr__pfet_01v8",
        "L": "1.5u",
        "l": "1.5",
        "W": "0.42u",
        "w": "0.42",
        "ad": "0.1218p",
        "as": "0.1218p",
        "pd": "1.42u",
        "ps": "1.42u",
        "nrd": "0.69047619047619",
        "nrs": "0.69047619047619",
    },
    "RefrBp": {
        "polarity": "p",
        "model": "sky130_fd_pr__pfet_01v8",
        "L": "1.5u",
        "l": "1.5",
        "W": "0.42u",
        "w": "0.42",
        "ad": "0.1218p",
        "as": "0.1218p",
        "pd": "1.42u",
        "ps": "1.42u",
        "nrd": "0.69047619047619",
        "nrs": "0.69047619047619",
    },
    "DiffBn": {
        "polarity": "n",
        "model": "sky130_fd_pr__nfet_01v8",
        "L": "1.5u",
        "l": "1.5",
        "W": "1.5u",
        "w": "1.5",
        "ad": "0.435p",
        "as": "0.435p",
        "pd": "3.58u",
        "ps": "3.58u",
        "nrd": "0.193333333333333",
        "nrs": "0.193333333333333",
    },
    "OnBn": {
        "polarity": "n",
        "model": "sky130_fd_pr__nfet_01v8",
        "L": "1.5u",
        "l": "1.5",
        "W": "1.5u",
        "w": "1.5",
        "ad": "0.435p",
        "as": "0.435p",
        "pd": "3.58u",
        "ps": "3.58u",
        "nrd": "0.193333333333333",
        "nrs": "0.193333333333333",
    },
    "OffBn": {
        "polarity": "n",
        "model": "sky130_fd_pr__nfet_01v8",
        "L": "1.5u",
        "l": "1.5",
        "W": "1.5u",
        "w": "1.5",
        "ad": "0.435p",
        "as": "0.435p",
        "pd": "3.58u",
        "ps": "3.58u",
        "nrd": "0.193333333333333",
        "nrs": "0.193333333333333",
    },
}
_EXPECTED_ROW_COUNTS = {
    "photoreceptor_dc": 26,
    "comparator_dc": None,
    "ac_gain": 601,
}
_NUMBER = r"[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?"
_COORDINATE_RE = re.compile(
    rf"\b(?:coordinate|frequency|freq|vdiff|vexp|sweep)\b\s*[:=]?\s*({_NUMBER}(?:meg|[fpnumkgtu])?)",
    re.IGNORECASE,
)
_ROW_COUNT_RE = re.compile(r"No\.\s*of\s*Data\s*Rows\s*:\s*(\d+)", re.IGNORECASE)
_NG_POINT_COUNT_RE = re.compile(r"^\s*No\.\s*Points\s*:\s*(\d+)\s*$", re.IGNORECASE | re.MULTILINE)


def _canonical_json(value: Any) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"), allow_nan=False)


def _require_number(value: Any, label: str) -> float:
    if isinstance(value, bool) or not isinstance(value, (int, float)):
        raise ValueError(f"{label} must be a number")
    parsed = float(value)
    if not math.isfinite(parsed):
        raise ValueError(f"{label} must be finite")
    return parsed


def _plain(value: Any) -> str:
    number = _require_number(value, "value")
    if number == 0:
        return "0"
    if number.is_integer():
        return str(int(number))
    return repr(number)


def _spice_value(value: Any) -> str:
    """Format the registered currents/capacities with simulator aliases."""
    number = _require_number(value, "value")
    if number == 0:
        return "0"
    # Keep the spellings used by the frozen pilot contract.  In particular,
    # 200 nA must not be shortened to 0.2 uA because deck checks and evidence
    # readers use the registered current units.
    registered = (
        (200e-9, "200n"),
        (100e-9, "100n"),
        (70e-9, "70n"),
        (10e-9, "10n"),
        (1e-9, "1n"),
        (0.5e-9, "0.5n"),
        (400e-12, "400p"),
        (250e-12, "250p"),
        (100e-12, "100p"),
        (10e-12, "10p"),
        (1e-12, "1p"),
        (30e-15, "30f"),
    )
    for registered_value, spelling in registered:
        if math.isclose(number, registered_value, rel_tol=0.0, abs_tol=registered_value * 1e-12):
            return spelling
    suffixes = (
        (1e15, "P"),
        (1e12, "T"),
        (1e9, "G"),
        (1e6, "Meg"),
        (1e-3, "m"),
        (1e-6, "u"),
        (1e-9, "n"),
        (1e-12, "p"),
        (1e-15, "f"),
    )
    for scale, suffix in suffixes:
        scaled = number / scale
        if abs(scaled) >= 0.1 and abs(scaled) < 1000:
            # Prefer the smaller unit when the larger unit would spell an
            # exact 0.1 (100 nA is clearer as 100n than 0.1u).  Values such as
            # 0.5n remain in their natural unit.
            if math.isclose(abs(scaled), 0.1, rel_tol=0.0, abs_tol=1e-15):
                continue
            if math.isclose(scaled, round(scaled), rel_tol=0.0, abs_tol=1e-12):
                return f"{int(round(scaled))}{suffix}"
            return f"{scaled:.12g}{suffix}"
    return _plain(number)


def _path_source_key(path: str) -> str:
    if path == "quantus_rcc_spectre":
        return "quantus_netlist"
    if path == "magic_rcc_ngspice":
        return "magic_netlist"
    if path == "schematic_ngspice":
        return "schematic_netlist"
    raise ValueError(f"unsupported simulation path: {path}")


def _source_path(sources: dict[str, str], key: str) -> str:
    if key not in sources:
        raise ValueError(f"source map is missing {key}")
    value = sources[key]
    if not isinstance(value, str) or not value:
        raise ValueError(f"source map entry {key} must be a non-empty path")
    return value


def _quote_path(path: str) -> str:
    return json.dumps(path)


def _condition(row: dict) -> dict[str, Any]:
    if not isinstance(row, dict):
        raise ValueError("row must be an object")
    condition = row.get("condition")
    if not isinstance(condition, dict):
        raise ValueError("row.condition must be an object")
    required = {
        "path",
        "simulator",
        "view",
        "analysis",
        "corner",
        "vdd_v",
        "temperature_c",
        "biases_a",
        "pin_forcing",
        "optical",
        "initial_state",
        "stimulus",
        "analysis_conditions",
    }
    missing = sorted(required - set(condition))
    if missing:
        raise ValueError("row.condition is missing " + ", ".join(missing))
    path = condition["path"]
    if path not in _PATHS:
        raise ValueError(f"unsupported simulation path: {path}")
    expected_simulator = "spectre" if path == "quantus_rcc_spectre" else "ngspice"
    expected_view = {
        "quantus_rcc_spectre": "quantus_rcc",
        "magic_rcc_ngspice": "magic_rcc",
        "schematic_ngspice": "schematic",
    }[path]
    if condition["simulator"] != expected_simulator or condition["view"] != expected_view:
        raise ValueError("row condition simulator/view does not match its path")
    analysis = condition["analysis"]
    if analysis not in _STATIC_ANALYSES:
        raise ValueError("only static photoreceptor, comparator, and AC rows are supported")
    _require_number(condition["vdd_v"], "row.condition.vdd_v")
    _require_number(condition["temperature_c"], "row.condition.temperature_c")
    biases = condition["biases_a"]
    if not isinstance(biases, dict) or set(biases) != set(_BIAS_NAMES):
        raise ValueError("row.condition.biases_a must contain all six bias names")
    for name, value in biases.items():
        if _require_number(value, f"biases_a.{name}") < 0:
            raise ValueError(f"biases_a.{name} must not be negative")
    forcing = condition["pin_forcing"]
    expected_forcing_pins = set(_CONTROL_PINS) | set(_BIAS_NAMES)
    if not isinstance(forcing, dict) or set(forcing) != expected_forcing_pins:
        raise ValueError("row.condition.pin_forcing must be an object")
    for name, expected in _CONTROL_PIN_FORCING.items():
        if forcing.get(name) != expected:
            raise ValueError(f"pin_forcing.{name} must be {expected}")
    for name, expected in _BIAS_PIN_FORCING[analysis].items():
        if forcing.get(name) != expected:
            raise ValueError(f"pin_forcing.{name} must be {expected}")
    optical = condition["optical"]
    if not isinstance(optical, dict) or not isinstance(optical.get("photocurrent_a"), dict):
        raise ValueError("row.condition.optical.photocurrent_a must be an object")
    if set(optical["photocurrent_a"]) != set(_PIXELS):
        raise ValueError("optical.photocurrent_a must explicitly name all four pixels")
    for pixel, value in optical["photocurrent_a"].items():
        if analysis == "photoreceptor_dc" and pixel == "vpd[0]":
            if not isinstance(value, dict) or len(value.get("values_a", [])) != 26:
                raise ValueError("photoreceptor vpd[0] must contain the 26-point sweep")
        elif _require_number(value, f"optical.photocurrent_a.{pixel}") < 0:
            raise ValueError(f"optical.photocurrent_a.{pixel} must not be negative")
    for name in ("initial_state", "stimulus", "analysis_conditions"):
        if not isinstance(condition[name], dict) or not condition[name]:
            raise ValueError(f"row.condition.{name} must be explicit and non-empty")
    source = row.get("source")
    if not isinstance(source, dict):
        raise ValueError("row.source must be present")
    if source != _MANIFEST_SOURCE_DEFINITIONS[path]:
        raise ValueError("row.source does not match the frozen path source identity and hash")
    return condition


def _row_id(row: dict, condition: dict[str, Any]) -> str:
    expected = "row-" + hashlib.sha256(_canonical_json(condition).encode("utf-8")).hexdigest()
    actual = row.get("row_id")
    if actual is not None and actual != expected:
        raise ValueError("row_id is not derived from the complete condition")
    return actual or expected


def pending_static_rows(manifest: dict) -> list[dict]:
    """Return pending photoreceptor, comparator, and AC rows in manifest order."""
    if not isinstance(manifest, dict) or not isinstance(manifest.get("rows"), list):
        raise ValueError("manifest.rows must be an array")
    pending: list[dict] = []
    for row in manifest["rows"]:
        condition = row.get("condition", {}) if isinstance(row, dict) else {}
        execution = row.get("execution", {}) if isinstance(row, dict) else {}
        if (
            isinstance(condition, dict)
            and condition.get("analysis") in _STATIC_ANALYSES
            and isinstance(execution, dict)
            and execution.get("state") == "pending"
            and execution.get("eligible") is True
        ):
            pending.append(row)
    return pending


def select_pilot_rows(manifest: dict, rung: str) -> list[dict]:
    """Select the exact nominal or extreme static pilot rung."""
    if rung not in {"nominal", "extremes"}:
        raise ValueError(f"unsupported pilot rung: {rung!r}; expected nominal or extremes")
    target = (
        ("tt", 1.8, 27)
        if rung == "nominal"
        else {("ss", 1.62, 0), ("ff", 1.98, 70)}
    )
    selected: list[dict] = []
    for row in pending_static_rows(manifest):
        condition = row["condition"]
        identity = (condition["corner"], condition["vdd_v"], condition["temperature_c"])
        if (identity == target if rung == "nominal" else identity in target):
            selected.append(row)
    return selected


def _hierarchies(path: str) -> tuple[str, ...]:
    if path == "quantus_rcc_spectre":
        return tuple(f"Xpix2x2.xPix[{index}]" for index in range(4))
    if path == "magic_rcc_ngspice":
        # The composed Magic hierarchy orders physical pixel cells 3, 1, 0, 2.
        return tuple(
            f"xpix2x2.xdiffbn_physical_core.openDVS_pixel_{index}"
            for index in (3, 1, 0, 2)
        )
    return tuple(f"xpix2x2.xpix[{index}]" for index in range(4))


def _signal(path: str, hierarchy: str, name: str) -> str:
    leaf = name
    if name == "vd":
        if path == "quantus_rcc_spectre":
            leaf = "xchAmp/vd"
        elif path == "schematic_ngspice":
            leaf = "xchamp.vd"
    return f"{hierarchy}/{leaf}" if path == "quantus_rcc_spectre" else f"{hierarchy}.{leaf}"


def _pixel_node(index: int) -> str:
    return f"vpd{index}"


def _pin_nodes(condition: dict[str, Any]) -> list[str]:
    forcing = condition["pin_forcing"]
    nodes: dict[str, str] = {}
    for pin in _CONTROL_PINS:
        state = forcing[pin]
        if state == "inactive_low":
            nodes[pin] = "0"
        elif state == "rail_tied_to_vdd":
            nodes[pin] = "VddA18"
        elif state == "rail_tied_to_ground":
            nodes[pin] = "0"
        else:
            nodes[pin] = pin
    for pin in ("VddA18", "GndA", "GndD", *_BIAS_NAMES):
        state = forcing.get(pin)
        if state == "rail_tied_to_vdd":
            nodes[pin] = "VddA18"
        elif state == "rail_tied_to_ground":
            nodes[pin] = "0"
        elif state == "current_mirror_driven":
            nodes[pin] = pin
        else:
            nodes[pin] = "0"
    for index in range(4):
        nodes[f"vpd[{index}]"] = _pixel_node(index)
    if condition["analysis"] in {"photoreceptor_dc", "ac_gain"}:
        nodes["vpd[0]"] = "vpd0_in"
    return [nodes.get(pin, pin) for pin in _TOP_PORTS]


def _include_lines(condition: dict[str, Any], sources: dict[str, str]) -> list[str]:
    path = condition["path"]
    corner = condition["corner"]
    netlist = _source_path(sources, _path_source_key(path))
    if path == "quantus_rcc_spectre":
        native_library = _source_path(sources, "native_model_library")
        adapter = _source_path(sources, "native_model_adapter")
        return [
            "simulator lang=spice",
            f".lib {native_library} {corner}",
            f".include {adapter}",
            f".include {netlist}",
        ]
    ng_library = _source_path(sources, "ngspice_model_library")
    return [
        f".lib {ng_library} {corner}",
        f".include {_source_path(sources, 'ngspice_nonfet_corner_' + corner)}",
        f".include {_source_path(sources, 'ngspice_parasitic_diode_model')}",
        f".include {netlist}",
    ]


def _options_lines(condition: dict[str, Any]) -> list[str]:
    analysis = condition["analysis"]
    settings = condition["analysis_conditions"]
    gmin = _plain(settings["gmin_s"])
    reltol = _plain(settings["reltol"])
    vabstol = _plain(settings["vabstol_v"])
    iabstol = _plain(settings["iabstol_a"])
    temperature = _plain(condition["temperature_c"])
    if condition["path"] == "quantus_rcc_spectre":
        return [
            f"simulatorOptions options temp={temperature} reltol={reltol} vabstol={vabstol} iabstol={iabstol} gmin={gmin}",
        ]
    options = f".options gmin={gmin} reltol={reltol} abstol={iabstol} vntol={vabstol}"
    if analysis in {"photoreceptor_dc", "comparator_dc"}:
        solver = settings.get("ngspice_dc_solver")
        if not isinstance(solver, dict):
            raise ValueError("NGSPICE DC solver contract is missing")
        options += (
            f" chgtol={_plain(solver['chgtol_c'])}"
            f" itl1={int(solver['itl1'])}"
            f" itl2={int(solver['itl2'])}"
            f" gminsteps={int(solver['gminsteps'])}"
            f" srcsteps={int(solver['srcsteps'])}"
        )
    return [f".temp {temperature}", options]


def _source_line(path: str, name: str, positive: str, negative: str, value: str, extra: str = "") -> str:
    return f"{name} {positive} {negative} dc {value}{extra}"


def _voltage_line(path: str, name: str, positive: str, negative: str, value: str) -> str:
    return f"{name} {positive} {negative} dc {value}"


def _capacitor_line(path: str, name: str, positive: str, negative: str, value: str) -> str:
    return f"{name} {positive} {negative} {value}"


def _bsource_line(path: str, name: str, positive: str, negative: str) -> str:
    if path == "quantus_rcc_spectre":
        return f"{name} ({positive} {negative}) bsource i=pow(10,V(exp))"
    return f"{name} {positive} {negative} I=pow(10,V(exp))"


def _eprobe_line(name: str, probe: str, node: str) -> str:
    return f"{name} {probe} 0 {node} 0 1"


def _mirror_line(path: str, name: str) -> str:
    spec = _MIRROR_SPECS[name]
    if spec["polarity"] == "p":
        source = bulk = "VddA18"
    else:
        source = bulk = "0"
    if path == "quantus_rcc_spectre":
        return (
            f"XM{name} {name} {name} {source} {bulk} {spec['model']} "
            f"L={spec['L']} W={spec['W']} nf=1 ad={spec['ad']} as={spec['as']} "
            f"pd={spec['pd']} ps={spec['ps']} nrd={spec['nrd']} nrs={spec['nrs']} mult=1"
        )
    return (
        f"XM{name} {name} {name} {source} {bulk} {spec['model']} "
        f"l={spec['l']} w={spec['w']} nf=1 ad={spec['ad'].removesuffix('p')} "
        f"as={spec['as'].removesuffix('p')} pd={spec['pd'].removesuffix('u')} "
        f"ps={spec['ps'].removesuffix('u')} nrd={spec['nrd']} nrs={spec['nrs']} mult=1"
    )


def _probe_lines(condition: dict[str, Any]) -> list[str]:
    path = condition["path"]
    hierarchy = _hierarchies(path)[0]
    analysis = condition["analysis"]
    if path == "magic_rcc_ngspice" and analysis == "ac_gain":
        # Saving the hierarchy nodes directly is electrically equivalent to
        # the non-loading unity probes, but avoids adding four decoupled
        # equations that make NGSPICE's operating-point solve fall back.
        return []
    probes: list[tuple[str, str, str]]
    if analysis == "photoreceptor_dc":
        probes = [
            ("Eprobe_vpr", "vpr_probe", _signal(path, hierarchy, "vpr")),
            ("Eprobe_vsf", "vsf_probe", _signal(path, hierarchy, "vsf")),
        ]
    elif analysis == "comparator_dc":
        probes = [
            ("Eprobe_vdiff", "vdiff_probe", _signal(path, hierarchy, "vdiff")),
            ("Eprobe_on", "on_probe", _signal(path, hierarchy, "ON")),
            ("Eprobe_noff", "noff_probe", _signal(path, hierarchy, "nOFF")),
        ]
    else:
        probes = [
            ("Eprobe_vpr", "vpr_probe", _signal(path, hierarchy, "vpr")),
            ("Eprobe_vsf", "vsf_probe", _signal(path, hierarchy, "vsf")),
            ("Eprobe_vdiff", "vdiff_probe", _signal(path, hierarchy, "vdiff")),
            ("Eprobe_vd", "vd_probe", _signal(path, hierarchy, "vd")),
        ]
    return [_eprobe_line(name, probe, node) for name, probe, node in probes]


def _behavioral_lines(condition: dict[str, Any]) -> list[str]:
    if condition["analysis"] == "photoreceptor_dc":
        return [_bsource_line(condition["path"], "Bipd0", _pixel_node(0), "0")]
    return []


def _ng_saved_expressions(condition: dict[str, Any]) -> list[str]:
    """Return the bounded NGSPICE raw-vector inventory for one analysis."""
    analysis = condition["analysis"]
    if analysis == "photoreceptor_dc":
        nodes = ("vpd0", "vpd0_in", "exp", "vpr_probe", "vsf_probe")
    elif analysis == "comparator_dc":
        nodes = ("vdiff_probe", "on_probe", "noff_probe")
    elif condition["path"] == "magic_rcc_ngspice":
        hierarchy = _hierarchies(condition["path"])[0]
        nodes = (
            "vpd0_in",
            _signal(condition["path"], hierarchy, "vpr"),
            _signal(condition["path"], hierarchy, "vsf"),
            _signal(condition["path"], hierarchy, "vdiff"),
            _signal(condition["path"], hierarchy, "vd"),
        )
    else:
        nodes = ("vpd0_in", "vpr_probe", "vsf_probe", "vdiff_probe", "vd_probe")
    return [f"v({node})" for node in nodes]


def _ng_control_lines(condition: dict[str, Any]) -> list[str]:
    expressions = _ng_saved_expressions(condition)
    return [
        ".control",
        "set num_threads=1",
        "set filetype=ascii",
        "run",
        "write raw_output.raw " + " ".join(expressions),
        "quit",
        ".endc",
        ".end",
    ]


def _top_instance(condition: dict[str, Any]) -> str:
    path = condition["path"]
    nodes = _pin_nodes(condition)
    instance = "Xpix2x2" if path == "quantus_rcc_spectre" else "xpix2x2"
    return f"{instance} {' '.join(nodes)} openDVS_pixel2x2"


def _bias_lines(condition: dict[str, Any]) -> list[str]:
    path = condition["path"]
    biases = condition["biases_a"]
    lines: list[str] = []
    for name in _BIAS_NAMES:
        if condition["pin_forcing"][name] == "current_mirror_driven":
            spec = _MIRROR_SPECS[name]
            if spec["polarity"] == "p":
                positive, negative = name, "0"
            else:
                positive, negative = "VddA18", name
            lines.append(_source_line(path, f"I{name}", positive, negative, _spice_value(biases[name])))
            lines.append(_mirror_line(path, name))
    return lines


def _photodiode_lines(condition: dict[str, Any]) -> list[str]:
    path = condition["path"]
    analysis = condition["analysis"]
    lines: list[str] = []
    if analysis == "photoreceptor_dc":
        stimulus = condition["stimulus"]
        sweep = condition["optical"]["photocurrent_a"]["vpd[0]"]
        if sweep["expression"] != "10**Vexp" or stimulus["control"] != "Vexp":
            raise ValueError("photoreceptor Vexp/B-source controls do not match")
        lines.append(_voltage_line(path, "Vexp", "exp", "0", _plain(stimulus["start_v"])))
        lines.append(_voltage_line(path, "Vmeas_ipd0", "vpd0_in", _pixel_node(0), "0"))
        lines.append(
            _capacitor_line(
                path,
                "CloadPD0",
                _pixel_node(0),
                "0",
                _spice_value(condition["analysis_conditions"]["photodiode_load_f"]),
            )
        )
        for index in range(1, 4):
            current = condition["optical"]["photocurrent_a"][f"vpd[{index}]"]
            lines.append(_source_line(path, f"Iipd{index}", _pixel_node(index), "0", _spice_value(current)))
    elif analysis == "comparator_dc":
        for index in range(4):
            current = condition["optical"]["photocurrent_a"][f"vpd[{index}]"]
            lines.append(_source_line(path, f"Iipd{index}", _pixel_node(index), "0", _spice_value(current)))
    else:
        stimulus = condition["stimulus"]
        ac_current = _spice_value(stimulus["ac_current_a"])
        dc_current = _spice_value(condition["optical"]["photocurrent_a"]["vpd[0]"])
        lines.append(_source_line(path, "Iipd0", _pixel_node(0), "0", dc_current, f" ac {ac_current}"))
        lines.append(_voltage_line(path, "Vmeas_ipd0", "vpd0_in", _pixel_node(0), "0"))
        for index in range(1, 4):
            current = condition["optical"]["photocurrent_a"][f"vpd[{index}]"]
            lines.append(_source_line(path, f"Iipd{index}", _pixel_node(index), "0", _spice_value(current)))
    return lines


def _stabilization_lines(condition: dict[str, Any]) -> list[str]:
    if condition["analysis"] != "ac_gain":
        return []
    path = condition["path"]
    lines: list[str] = []
    for index, hierarchy in enumerate(_hierarchies(path)):
        vdiff = _signal(path, hierarchy, "vdiff")
        vd = _signal(path, hierarchy, "vd")
        n_rst = _signal(path, hierarchy, "nRst")
        if path == "quantus_rcc_spectre":
            lines.append(f"Lbias{index} {vdiff} {vd} 1000T")
            lines.append(f"Rfix_nRst{index} {n_rst} VddA18 1T")
        else:
            # NGSPICE's model-library SCALE convention is micrometres; these
            # very large stabilizers are therefore written without Spectre
            # aliases, while device geometry remains owned by the source.
            lines.append(f"Lbias{index} {vdiff} {vd} 1e15")
            lines.append(f"Rfix_nRst{index} {n_rst} VddA18 1e12")
    return lines


def _analysis_lines(condition: dict[str, Any]) -> list[str]:
    path = condition["path"]
    analysis = condition["analysis"]
    if analysis == "photoreceptor_dc":
        stimulus = condition["stimulus"]
        if path == "quantus_rcc_spectre":
            return [
                "save vpd0 vpd0_in exp vpr_probe vsf_probe",
                (
                    "dc dc dev=Vexp param=dc "
                    f"start={_plain(stimulus['start_v'])} "
                    f"stop={_plain(stimulus['stop_v'])} "
                    f"step={_plain(stimulus['step_v'])}"
                ),
            ]
        return [
            ".save " + " ".join(_ng_saved_expressions(condition)),
            (
                ".dc Vexp "
                f"{_plain(stimulus['start_v'])} "
                f"{_plain(stimulus['stop_v'])} "
                f"{_plain(stimulus['step_v'])}"
            ),
        ]
    if analysis == "comparator_dc":
        stimulus = condition["stimulus"]
        if path == "quantus_rcc_spectre":
            return [
                "save vdiff_probe on_probe noff_probe",
                (
                    "dc dc dev=Vdiff param=dc "
                    f"start={_plain(stimulus['start_v'])} "
                    f"stop={_plain(stimulus['stop_v'])} "
                    f"step={_plain(stimulus['step_v'])}"
                ),
            ]
        return [
            ".save " + " ".join(_ng_saved_expressions(condition)),
            (
                ".dc Vdiff "
                f"{_plain(stimulus['start_v'])} "
                f"{_plain(stimulus['stop_v'])} "
                f"{_plain(stimulus['step_v'])}"
            ),
        ]
    stimulus = condition["stimulus"]
    start_frequency = _spice_value(stimulus["start_frequency_hz"])
    stop_frequency = _spice_value(stimulus["stop_frequency_hz"])
    points_per_decade = _plain(stimulus["points_per_decade"])
    if path == "quantus_rcc_spectre":
        return [
            "save vpd0_in vpr_probe vsf_probe vdiff_probe vd_probe",
            f"ac ac start={start_frequency} stop={stop_frequency} dec={points_per_decade}",
        ]
    return [
        ".save " + " ".join(_ng_saved_expressions(condition)),
        f".ac dec {points_per_decade} {start_frequency} {stop_frequency}",
    ]


def build_deck(row: dict, sources: dict[str, str]) -> str:
    """Build one deterministic deck from the row's complete condition."""
    condition = _condition(row)
    row_id = _row_id(row, condition)
    path = condition["path"]
    for key in (_path_source_key(path), "ngspice_model_library"):
        if path == "quantus_rcc_spectre" and key == "ngspice_model_library":
            continue
        _source_path(sources, key)
    if path == "quantus_rcc_spectre":
        _source_path(sources, "native_model_library")
        _source_path(sources, "native_model_adapter")

    claim = row["source"]
    if set(claim) != {"identity", "sha256"}:
        raise ValueError("row.source must contain exactly identity and sha256")
    comment = "//" if path == "quantus_rcc_spectre" else "*"
    geometry = (
        "geometry_convention=spectre_u_p_suffixes"
        if path == "quantus_rcc_spectre"
        else "geometry_convention=ngspice_SCALE_micrometre"
    )
    lines = [
        f"{comment} STATIC_ROW_BEGIN",
        f"{comment} STATIC_ROW_ID {row_id}",
        f"{comment} CONDITION_JSON {_canonical_json(condition)}",
        f"{comment} SOURCE_CLAIM {_canonical_json(claim)}",
        f"{comment} {geometry}",
    ]
    lines.extend(_include_lines(condition, sources))
    if path != "quantus_rcc_spectre":
        lines.extend(_options_lines(condition))
    lines.append(_voltage_line(path, "Vvdd", "VddA18", "0", _plain(condition["vdd_v"])))
    lines.extend(_bias_lines(condition))
    lines.extend(_photodiode_lines(condition))
    if path != "quantus_rcc_spectre":
        lines.extend(_behavioral_lines(condition))
    if condition["analysis"] == "comparator_dc":
        comparator_node = _signal(path, _hierarchies(path)[0], "vdiff")
        lines.append(_voltage_line(path, "Vdiff", comparator_node, "0", "0"))
    lines.append(_top_instance(condition))
    lines.extend(_probe_lines(condition))
    lines.extend(_stabilization_lines(condition))
    if path == "quantus_rcc_spectre":
        lines.append("simulator lang=spectre")
        lines.extend(_behavioral_lines(condition))
        lines.extend(_options_lines(condition))
    lines.extend(_analysis_lines(condition))
    lines.append(f"{comment} STATIC_ROW_END")
    if path != "quantus_rcc_spectre":
        lines.extend(_ng_control_lines(condition))
    return "\n".join(lines) + "\n"


def _expected_gmin(condition: dict[str, Any]) -> str:
    return _plain(condition["analysis_conditions"]["gmin_s"])


def _require_once(deck: str, needle: str, label: str) -> None:
    count = deck.count(needle)
    if count != 1:
        raise ValueError(f"{label} anchor occurs {count} times")


def _top_line(deck: str, path: str) -> str:
    marker = "Xpix2x2 " if path == "quantus_rcc_spectre" else "xpix2x2 "
    matches = [line for line in deck.splitlines() if line.startswith(marker)]
    if len(matches) != 1:
        raise ValueError("top instance anchor is missing or repeated")
    return matches[0]


def validate_deck(row: dict, deck: str, sources: dict[str, str]) -> None:
    """Fail closed if a deck drifts from its row, path, or analysis contract."""
    if not isinstance(deck, str) or not deck:
        raise ValueError("deck must be non-empty text")
    condition = _condition(row)
    row_id = _row_id(row, condition)
    path = condition["path"]
    analysis = condition["analysis"]
    expected_deck = build_deck(row, sources)
    if deck != expected_deck:
        raise ValueError("deck differs from the deterministic row rendering")
    comment = "//" if path == "quantus_rcc_spectre" else "*"
    _require_once(deck, f"{comment} STATIC_ROW_BEGIN", "row begin")
    _require_once(deck, f"{comment} STATIC_ROW_ID {row_id}", "row identity")
    _require_once(deck, f"{comment} CONDITION_JSON {_canonical_json(condition)}", "condition")
    _require_once(deck, f"{comment} SOURCE_CLAIM {_canonical_json(row['source'])}", "source claim")
    _require_once(deck, f"{comment} STATIC_ROW_END", "row end")
    source_key = _path_source_key(path)
    source = _source_path(sources, source_key)
    _require_once(deck, source, "DUT source")
    if path == "quantus_rcc_spectre":
        _require_once(deck, _source_path(sources, "native_model_library"), "native model library")
        _require_once(deck, _source_path(sources, "native_model_adapter"), "native model adapter")
        if deck.count("simulator lang=spectre") != 1:
            raise ValueError("Quantus deck is missing Spectre language mode")
        if "xdiffbn_physical_core" in deck.lower():
            raise ValueError("Quantus deck contains Magic hierarchy")
        spectre_index = deck.index("simulator lang=spectre")
        top_index = deck.index(_top_line(deck, path))
        if spectre_index <= top_index:
            raise ValueError("Quantus language switch precedes ordinary SPICE cards")
        ordinary = deck[:spectre_index]
        if any(token in ordinary for token in (" isource", " vsource", " capacitor ", " inductor ", " resistor ")):
            raise ValueError("Quantus ordinary cards use Spectre element syntax")
        for line in deck.splitlines():
            if line.startswith("save ") and "V(" in line:
                raise ValueError("Quantus save statement contains a V() expression")
    elif path == "magic_rcc_ngspice":
        if "simulator lang=spectre" in deck:
            raise ValueError("Magic deck must use NGSPICE syntax")
    else:
        if "simulator lang=spectre" in deck or "xdiffbn_physical_core" in deck.lower():
            raise ValueError("schematic deck has the wrong simulator or hierarchy")
    if path != "quantus_rcc_spectre":
        write_card = "write raw_output.raw " + " ".join(_ng_saved_expressions(condition))
        for card in (".control", "set filetype=ascii", write_card, "quit", ".endc"):
            _require_once(deck, card, f"NGSPICE ASCII control card {card}")
        if "write raw_output.raw all" in deck:
            raise ValueError("NGSPICE raw output must not save every extracted node")
        if sum(line.strip() == ".end" for line in deck.splitlines()) != 1:
            raise ValueError("NGSPICE ASCII control card .end occurs an incorrect number of times")
    top = _top_line(deck, path)
    if path == "quantus_rcc_spectre":
        parts = top.split()
        if not parts or parts[-1] != "openDVS_pixel2x2":
            raise ValueError("Quantus top instance has the wrong DUT")
        top_body = parts[1:-1]
    else:
        parts = top.split()
        if not parts or parts[-1] != "openDVS_pixel2x2":
            raise ValueError("NGSPICE top instance has the wrong DUT")
        top_body = parts[1:-1]
    if top_body != list(_pin_nodes(condition)):
        raise ValueError("top instance pin order or forcing does not match the row")
    for probe in _probe_lines(condition):
        _require_once(deck, probe, "reported-signal probe")
    for behavioral in _behavioral_lines(condition):
        _require_once(deck, behavioral, "photoreceptor behavioral source")
    _require_once(deck, f"gmin={_expected_gmin(condition)}", "gmin")
    if path == "quantus_rcc_spectre":
        _require_once(
            deck,
            f".lib {_source_path(sources, 'native_model_library')} {condition['corner']}",
            "native model corner",
        )
    else:
        _require_once(
            deck,
            f".lib {_source_path(sources, 'ngspice_model_library')} {condition['corner']}",
            "NGSPICE model corner",
        )
        if analysis in {"photoreceptor_dc", "comparator_dc"}:
            for setting in (
                "chgtol=1e-16",
                "itl1=500",
                "itl2=200",
                "gminsteps=200",
                "srcsteps=200",
            ):
                _require_once(deck, setting, f"NGSPICE DC solver option {setting}")
    _require_once(
        deck,
        _voltage_line(path, "Vvdd", "VddA18", "0", _plain(condition["vdd_v"])),
        "VDD",
    )
    for name in _BIAS_NAMES:
        forcing = _BIAS_PIN_FORCING[analysis][name]
        if forcing == "current_mirror_driven":
            spec = _MIRROR_SPECS[name]
            positive, negative = (name, "0") if spec["polarity"] == "p" else ("VddA18", name)
            _require_once(
                deck,
                _source_line(
                    path,
                    f"I{name}",
                    positive,
                    negative,
                    _spice_value(condition["biases_a"][name]),
                ),
                f"{name} bias",
            )
            _require_once(deck, _mirror_line(path, name), f"{name} diode-connected mirror")
    if analysis == "photoreceptor_dc":
        if "30f" not in deck or "-7" not in deck or "-12" not in deck or "-0.2" not in deck:
            raise ValueError("photoreceptor sweep or load is missing")
        if deck.count("Iipd1") != 1 or deck.count("Iipd2") != 1 or deck.count("Iipd3") != 1:
            raise ValueError("all three photoreceptor neighbor sources are required")
    elif analysis == "comparator_dc":
        if "200n" not in deck or "0.5n" not in deck or "0.0001" not in deck:
            raise ValueError("comparator bias or sweep is missing")
        if deck.count("Iipd0") != 1 or any(deck.count(f"Iipd{index}") != 1 for index in range(1, 4)):
            raise ValueError("all four comparator photodiode sources are required")
    else:
        if "10p" not in deck or "10n" not in deck or "1m" not in deck or "1G" not in deck:
            raise ValueError("AC stimulus, bias, or frequency sweep is missing")
        if "Cload" in deck:
            raise ValueError("AC deck must not contain a Cload card")
        for index, hierarchy in enumerate(_hierarchies(path)):
            _require_once(deck, f"Lbias{index}", f"AC stabilization pixel {index}")
            _require_once(deck, f"Rfix_nRst{index}", f"AC reset stabilization pixel {index}")
        if deck.count("Lbias") != 4 or deck.count("Rfix_nRst") != 4:
            raise ValueError("AC stabilization must contain four paths")
        for index, hierarchy in enumerate(_hierarchies(path)):
            vdiff = _signal(path, hierarchy, "vdiff")
            vd = _signal(path, hierarchy, "vd")
            n_rst = _signal(path, hierarchy, "nRst")
            if path == "quantus_rcc_spectre":
                expected_lbias = f"Lbias{index} {vdiff} {vd} 1000T"
                expected_reset = f"Rfix_nRst{index} {n_rst} VddA18 1T"
            else:
                expected_lbias = f"Lbias{index} {vdiff} {vd} 1e15"
                expected_reset = f"Rfix_nRst{index} {n_rst} VddA18 1e12"
            _require_once(deck, expected_lbias, f"AC hierarchy {index}")
            _require_once(deck, expected_reset, f"AC reset hierarchy {index}")


def simulator_command(row: dict, run_dir, sources: dict[str, str]) -> list[str]:
    """Return the bounded simulator argv without invoking it."""
    condition = _condition(row)
    run_path = Path(run_dir)
    if condition["path"] == "quantus_rcc_spectre":
        launcher = _source_path(sources, "cadence_launcher")
        return [
            launcher,
            "spectre",
            "-64",
            "-I",
            str(run_path / "input.scs"),
            "-format",
            "psfascii",
            "-raw",
            str(run_path / "raw_output"),
            "+lqtimeout",
            "300",
            "+log",
            str(run_path / "simulator.log"),
        ]
    binary = _source_path(sources, "ngspice_binary")
    return [
        binary,
        "-b",
        "-o",
        str(run_path / "simulator.log"),
        str(run_path / "input.deck"),
    ]


def _expected_points(condition: dict[str, Any]) -> int:
    analysis = condition["analysis"]
    if analysis == "comparator_dc":
        return round(float(condition["vdd_v"]) / 0.0001) + 1
    return _EXPECTED_ROW_COUNTS[analysis]  # type: ignore[return-value]


def _parse_scaled_number(value: str) -> float:
    suffix = ""
    match = re.fullmatch(rf"({_NUMBER})(meg|[fpnumkgtu])?", value, re.IGNORECASE)
    if not match:
        raise ValueError(f"not a simulator number: {value}")
    number = float(match.group(1))
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
    result = number * scale
    if not math.isfinite(result):
        raise ValueError("non-finite simulator number")
    return result


def _coordinate_values(raw_text: str) -> list[float]:
    values: list[float] = []
    for match in _COORDINATE_RE.finditer(raw_text):
        values.append(_parse_scaled_number(match.group(1)))
    return values


def _psf_ascii_details(raw_text: str) -> tuple[list[float], set[str]]:
    """Return PSFASCII sweep coordinates and the saved TRACE names."""
    upper = raw_text.upper()
    trace_start = upper.find("TRACE")
    value_start = upper.find("VALUE")
    if trace_start < 0 or value_start < 0 or value_start <= trace_start:
        return [], set()
    trace_text = raw_text[trace_start + len("TRACE") : value_start]
    names = {
        match.group(1)
        for match in re.finditer(r'^\s*"([^"]+)"\s+', trace_text, re.MULTILINE)
    }
    coordinates: list[float] = []
    value_text = raw_text[value_start + len("VALUE") :]
    coordinate_re = re.compile(
        rf'^\s*"(?:dc|freq|frequency)"\s+({_NUMBER}(?:meg|[fpnumkgtu])?)\s*$',
        re.IGNORECASE | re.MULTILINE,
    )
    for match in coordinate_re.finditer(value_text):
        coordinates.append(_parse_scaled_number(match.group(1)))
    return coordinates, names


def _ng_ascii_details(raw_text: str) -> tuple[int | None, list[float], set[str]]:
    """Return NGSPICE ASCII point count, coordinate rows, and variable names."""
    point_match = _NG_POINT_COUNT_RE.search(raw_text)
    point_count = int(point_match.group(1)) if point_match else None
    upper = raw_text.upper()
    variables_start = upper.find("VARIABLES:")
    values_start = upper.find("VALUES:")
    names: set[str] = set()
    if variables_start >= 0 and values_start > variables_start:
        variables_text = raw_text[variables_start + len("VARIABLES:") : values_start]
        names = {
            match.group(1)
            for match in re.finditer(r"^\s*\d+\s+(\S+)", variables_text, re.MULTILINE)
        }
    coordinates: list[float] = []
    if values_start >= 0:
        values_text = raw_text[values_start + len("VALUES:") :]
        for line in values_text.splitlines():
            match = re.match(rf"^\s*\d+\s+({_NUMBER})(?:\s*,\s*{_NUMBER})?\s*$", line)
            if match:
                coordinates.append(_parse_scaled_number(match.group(1)))
    return point_count, coordinates, names


def _normalise_saved_name(name: str) -> str:
    value = name.strip().strip('"').lower()
    while value.startswith("v(") and value.endswith(")"):
        value = value[2:-1].strip()
    return value


def _expected_saved_names(condition: dict[str, Any]) -> set[str]:
    analysis = condition["analysis"]
    if analysis == "photoreceptor_dc":
        return {"vpd0", "vpd0_in", "exp", "vpr_probe", "vsf_probe"}
    if analysis == "comparator_dc":
        return {"vdiff_probe", "on_probe", "noff_probe"}
    if condition["path"] == "magic_rcc_ngspice":
        hierarchy = _hierarchies(condition["path"])[0]
        return {
            "vpd0_in",
            _signal(condition["path"], hierarchy, "vpr"),
            _signal(condition["path"], hierarchy, "vsf"),
            _signal(condition["path"], hierarchy, "vdiff"),
            _signal(condition["path"], hierarchy, "vd"),
        }
    return {"vpd0_in", "vpr_probe", "vsf_probe", "vdiff_probe", "vd_probe"}


def _endpoints(condition: dict[str, Any]) -> tuple[float, float]:
    analysis = condition["analysis"]
    stimulus = condition["stimulus"]
    if analysis == "photoreceptor_dc":
        return float(stimulus["start_v"]), float(stimulus["stop_v"])
    if analysis == "comparator_dc":
        return float(stimulus["start_v"]), float(stimulus["stop_v"])
    return (
        _parse_scaled_number(_spice_value(stimulus["start_frequency_hz"])),
        _parse_scaled_number(_spice_value(stimulus["stop_frequency_hz"])),
    )


def _ac_coordinates_match_deck(condition: dict[str, Any], coordinates: list[float]) -> bool:
    """Check every AC frequency against the registered logarithmic sweep."""
    if condition["analysis"] != "ac_gain":
        return True
    stimulus = condition["stimulus"]
    start = _parse_scaled_number(_spice_value(stimulus["start_frequency_hz"]))
    points_per_decade = int(stimulus["points_per_decade"])
    for index, observed in enumerate(coordinates):
        expected = start * 10 ** (index / points_per_decade)
        if not math.isclose(observed, expected, rel_tol=2e-6, abs_tol=1e-15):
            return False
    return True


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


def _scientific_failure(condition: dict[str, Any], log_text: str) -> str | None:
    if condition["path"] == "quantus_rcc_spectre":
        return None
    lowered = log_text.lower()
    patterns = (
        (r"transient\s+op", "transient operating-point fallback"),
        (r"(?:failed|failure).*?(?:dynamic|true[- ]?gmin|gmin)\s+stepping", "failed gmin stepping"),
        (r"(?:dynamic|true[- ]?gmin|gmin)\s+stepping.*?(?:failed|failure)", "failed gmin stepping"),
        (r"(?:failed|failure).*?(?:dynamic|true[- ]?gmin|gmin)", "failed gmin sequence"),
        (r"(?:dynamic|true[- ]?gmin|gmin).*?(?:failed|failure)", "failed gmin sequence"),
        (r"(?:failed|failure).*?source\s+stepping", "failed source stepping"),
        (r"source\s+stepping.*?(?:failed|failure)", "failed source stepping"),
    )
    for pattern, reason in patterns:
        if re.search(pattern, lowered):
            return reason
    return None


def classify_execution(row: dict, exit_code: int, log_text: str, raw_text: str) -> dict:
    """Classify each simulator's raw output separately from scientific validity."""
    condition = _condition(row)
    expected = _expected_points(condition)
    result: dict[str, Any] = {
        "execution_validity": "fail",
        "scientific_validity": "pending",
        "spec_result": "not_evaluated",
        "comparison": "not_evaluated",
        "expected_points": expected,
        "reported_points": None,
        "coordinate_points": None,
        "errors": [],
    }
    if not isinstance(log_text, str) or not isinstance(raw_text, str):
        result["errors"].append("log and raw output must be text")
        return result
    path = condition["path"]
    row_counts = [int(value) for value in _ROW_COUNT_RE.findall(log_text)]
    coordinates: list[float] = []
    saved_names: set[str] = set()
    ng_point_count: int | None = None
    synthetic_coordinate_witness = False
    real_raw_format = path == "quantus_rcc_spectre"
    if path == "quantus_rcc_spectre":
        try:
            coordinates, saved_names = _psf_ascii_details(raw_text)
        except ValueError as exc:
            result["errors"].append(str(exc))
    else:
        try:
            ng_point_count, coordinates, saved_names = _ng_ascii_details(raw_text)
            if not coordinates and ng_point_count is None:
                # The frozen fixture is deliberately a two-endpoint text
                # witness rather than a complete NGSPICE raw file.
                coordinates = _coordinate_values(raw_text)
                synthetic_coordinate_witness = bool(coordinates)
            else:
                real_raw_format = True
        except ValueError as exc:
            result["errors"].append(str(exc))
    result["reported_points"] = row_counts[-1] if row_counts else None
    result["coordinate_points"] = len(coordinates)
    if exit_code != 0:
        result["errors"].append(f"simulator exit code {exit_code}")
    if _has_simulator_error(log_text):
        result["errors"].append("simulator reported an error")
    if path != "quantus_rcc_spectre" and (not row_counts or any(count != expected for count in row_counts)):
        result["errors"].append(f"reported row count is not {expected}")
    if path != "quantus_rcc_spectre" and ng_point_count is not None and ng_point_count != expected:
        result["errors"].append(f"ASCII raw point count is not {expected}")
    if not raw_text.strip():
        result["errors"].append("raw result is missing or empty")
    if re.search(r"\b(?:nan|[+-]?inf(?:inity)?)\b", raw_text, re.IGNORECASE):
        result["errors"].append("raw result contains a non-finite value")

    endpoints = _endpoints(condition)
    if len(coordinates) == 0:
        result["errors"].append("raw result has no coordinate evidence")
    elif (
        condition["analysis"] != "ac_gain"
        and synthetic_coordinate_witness
        and len(coordinates) == 2
    ):
        # The frozen synthetic fixture supplies only endpoint evidence.  A
        # simulator raw file containing the complete coordinate vector is
        # checked for its exact shape below.
        observed = (coordinates[0], coordinates[-1])
        if not (
            math.isclose(observed[0], endpoints[0], rel_tol=1e-9, abs_tol=1e-12)
            and math.isclose(observed[1], endpoints[1], rel_tol=1e-9, abs_tol=1e-12)
        ):
            result["errors"].append("raw coordinate endpoints do not match the deck")
    elif len(coordinates) != expected:
        result["errors"].append("raw coordinate count does not match the deck")
    else:
        if not (
            math.isclose(coordinates[0], endpoints[0], rel_tol=1e-9, abs_tol=1e-12)
            and math.isclose(coordinates[-1], endpoints[1], rel_tol=1e-9, abs_tol=1e-12)
        ):
            result["errors"].append("raw coordinate endpoints do not match the deck")
        if not _ac_coordinates_match_deck(condition, coordinates):
            result["errors"].append("raw AC coordinate grid does not match the deck")

    if real_raw_format and not saved_names:
        result["errors"].append("raw output has no parsed saved-signal inventory")
    elif saved_names:
        actual_names = {_normalise_saved_name(name) for name in saved_names}
        missing_names = {
            _normalise_saved_name(name)
            for name in _expected_saved_names(condition)
        } - actual_names
        if missing_names:
            result["errors"].append("raw output is missing saved signals: " + ", ".join(sorted(missing_names)))

    if not result["errors"]:
        result["execution_validity"] = "pass"
    scientific_failure = _scientific_failure(condition, log_text)
    if scientific_failure:
        result["scientific_validity"] = "invalid"
        result["scientific_reason"] = scientific_failure
    elif result["execution_validity"] == "pass":
        result["scientific_validity"] = "valid"
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


def _resolve_source_map(source_map: dict[str, Any], source_map_path: Path) -> dict[str, str]:
    if isinstance(source_map.get("sources"), dict):
        source_map = source_map["sources"]
    required = set(SOURCE_HASHES) | set(_TOOLCHAIN_KEYS)
    missing = sorted(required - set(source_map))
    if missing:
        raise ValueError("source map is missing " + ", ".join(missing))
    resolved: dict[str, str] = {}
    for key in required:
        raw = _source_map_value(source_map[key], key)
        path = Path(raw).expanduser()
        if not path.is_absolute():
            path = source_map_path.parent / path
        resolved[key] = str(path.resolve())
    return resolved


def _verify_sources(source_map_path: Path) -> tuple[dict[str, str], dict[str, str]]:
    """Resolve and hash every source before the output directory is touched."""
    try:
        source_map = json.loads(source_map_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ValueError(f"cannot read source map {source_map_path}: {exc}") from exc
    if not isinstance(source_map, dict):
        raise ValueError("source map must be an object")
    sources = _resolve_source_map(source_map, source_map_path)
    computed: dict[str, str] = {}
    for key, expected in SOURCE_HASHES.items():
        path = Path(sources[key])
        if not path.is_file():
            raise ValueError(f"source file does not exist: {path}")
        actual = _sha256_file(path)
        computed[key] = actual
        if actual != expected:
            raise ValueError(f"source hash mismatch for {key}: {actual} != {expected}")
    for key in _TOOLCHAIN_KEYS:
        path = Path(sources[key])
        if not path.is_file():
            raise ValueError(f"required toolchain file does not exist: {path}")
        actual = _sha256_file(path)
        computed[key] = actual
        if actual != TOOLCHAIN_HASHES[key]:
            raise ValueError(f"toolchain hash mismatch for {key}: {actual} != {TOOLCHAIN_HASHES[key]}")
    return sources, computed


def _atomic_write_text(path: Path, text: str) -> None:
    temporary = path.with_name(path.name + ".tmp")
    temporary.write_text(text, encoding="utf-8")
    os.replace(temporary, path)


def _atomic_write_json(path: Path, value: Any) -> None:
    _atomic_write_text(path, json.dumps(value, sort_keys=True, indent=2, allow_nan=False) + "\n")


def _bounded_simulator_command(
    command: list[str], path: str, timeout_s: float | None
) -> list[str]:
    """Put GNU timeout next to the simulator so detached launchers cannot escape it."""
    if timeout_s is None:
        return list(command)
    timeout = [
        "/usr/bin/timeout",
        "--signal=TERM",
        "--kill-after=10s",
        f"{timeout_s:.12g}s",
    ]
    if path == "quantus_rcc_spectre":
        # The launcher enters a container and its conmon process detaches from
        # the caller.  Running timeout *inside* that container keeps Spectre in
        # the timeout process group instead of trying to recover reparented
        # host PIDs after the deadline.
        return [command[0], *timeout, *command[1:]]
    return [*timeout, *command]


def _run_subprocess(command: list[str], cwd: Path) -> subprocess.CompletedProcess[str]:
    """Run an already bounded simulator command and capture its output."""
    return subprocess.run(
        command,
        cwd=cwd,
        text=True,
        capture_output=True,
        check=False,
    )


def _read_raw_path(path: Path) -> str:
    if path.is_file():
        return path.read_text(encoding="utf-8", errors="replace")
    if path.is_dir():
        chunks: list[str] = []
        for child in sorted(path.rglob("*")):
            if child.is_file():
                chunks.append(child.read_text(encoding="utf-8", errors="replace"))
        return "\n".join(chunks)
    return ""


def _source_fingerprint(source_hashes: dict[str, str]) -> str:
    return hashlib.sha256(_canonical_json(source_hashes).encode("utf-8")).hexdigest()


def _deck_fingerprint(deck: str, source_hashes: dict[str, str]) -> str:
    source_fingerprint = _source_fingerprint(source_hashes)
    return hashlib.sha256((source_fingerprint + "\n" + deck).encode("utf-8")).hexdigest()


def _attempt_dirs(base: Path) -> list[Path]:
    if not base.is_dir():
        return []
    attempts = []
    for candidate in base.glob("attempt-*"):
        if candidate.is_dir() and candidate.name.removeprefix("attempt-").isdigit():
            attempts.append(candidate)
    return sorted(attempts, key=lambda item: int(item.name.removeprefix("attempt-")))


def _existing_valid(
    base: Path, fingerprint: str, row: dict[str, Any]
) -> tuple[Path, dict[str, Any]] | None:
    """Reuse only evidence that still passes the current classifiers."""
    condition = row["condition"]
    for attempt in _attempt_dirs(base):
        result_path = attempt / "result.json"
        try:
            result = json.loads(result_path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            continue
        if result.get("fingerprint") != fingerprint:
            continue
        exit_code = result.get("exit_code")
        if not isinstance(exit_code, int):
            continue
        log_path = attempt / "simulator.log"
        raw_path = attempt / (
            "raw_output" if condition["path"] == "quantus_rcc_spectre" else "raw_output.raw"
        )
        try:
            log_text = log_path.read_text(encoding="utf-8", errors="replace")
        except OSError:
            continue
        current = classify_execution(row, exit_code, log_text, _read_raw_path(raw_path))
        if (
            current["execution_validity"] == "pass"
            and current["scientific_validity"] == "valid"
        ):
            refreshed = dict(result)
            refreshed.update(current)
            refreshed["reclassified_on_reuse"] = True
            return attempt, refreshed
    return None


def _next_attempt(base: Path) -> Path:
    attempts = _attempt_dirs(base)
    next_number = 1 if not attempts else int(attempts[-1].name.removeprefix("attempt-")) + 1
    return base / f"attempt-{next_number}"


def _row_result_base(row: dict, fingerprint: str, source_hashes: dict[str, str]) -> dict[str, Any]:
    condition = row["condition"]
    return {
        "schema_version": 1,
        "row_id": row.get("row_id"),
        "condition": condition,
        "fingerprint": fingerprint,
        "deck_sha256": hashlib.sha256(b"").hexdigest(),
        "source_hashes": source_hashes,
        "execution_validity": "pending",
        "scientific_validity": "pending",
        "spec_result": "not_evaluated",
        "comparison": "not_evaluated",
        "exit_code": None,
        "resource_outcome": "pending",
        "timeout_s": None,
    }


def _run_row(
    row: dict,
    sources: dict[str, str],
    source_hashes: dict[str, str],
    output: Path,
    prepare_only: bool,
    timeout_s: float | None,
) -> dict[str, Any]:
    deck = build_deck(row, sources)
    validate_deck(row, deck, sources)
    fingerprint = _deck_fingerprint(deck, source_hashes)
    condition = row["condition"]
    base = output / condition["path"] / condition["analysis"] / (row.get("row_id") or _row_id(row, condition))
    reused = _existing_valid(base, fingerprint, row)
    if reused is not None:
        reused_dir, reused_result = reused
        reused_result = dict(reused_result)
        reused_result.update({"row_id": row.get("row_id"), "status": "reused", "directory": str(reused_dir)})
        return reused_result
    attempt = _next_attempt(base)
    attempt.mkdir(parents=True, exist_ok=False)
    if condition["path"] != "quantus_rcc_spectre":
        # edit20260922l addition: same startup file as the reset runner, so ngspice runs single-threaded
        # (the desktop is in use) and keeps the PDK-compatible behaviour of ~/.spiceinit, which a cwd .spiceinit replaces.
        _atomic_write_text(attempt / ".spiceinit", "\n".join(["* CACE-aligned NGSPICE startup settings", "set ngbehavior=hsa", "set skywaterpdk", "set ng_nomodcheck", "set num_threads=1", "option noinit", ""]))
    input_path = attempt / ("input.scs" if condition["path"] == "quantus_rcc_spectre" else "input.deck")
    _atomic_write_text(input_path, deck)
    _atomic_write_json(
        attempt / "fingerprint.json",
        {
            "fingerprint": fingerprint,
            "deck_sha256": hashlib.sha256(deck.encode("utf-8")).hexdigest(),
            "source_fingerprint": _source_fingerprint(source_hashes),
            "source_hashes": source_hashes,
        },
    )
    command = _bounded_simulator_command(
        simulator_command(row, attempt, sources), condition["path"], timeout_s
    )
    _atomic_write_json(attempt / "command.json", command)
    _atomic_write_text(attempt / "command.txt", shlex.join(command) + "\n")
    result = _row_result_base(row, fingerprint, source_hashes)
    result["row_id"] = row.get("row_id") or _row_id(row, condition)
    result["deck_sha256"] = hashlib.sha256(deck.encode("utf-8")).hexdigest()
    result["command"] = command
    result["directory"] = str(attempt)
    result["timeout_s"] = timeout_s
    if prepare_only:
        result["status"] = "prepared"
        result["resource_outcome"] = "not_run"
        _atomic_write_text(attempt / "stdout.txt", "")
        _atomic_write_text(attempt / "stderr.txt", "")
        _atomic_write_text(attempt / "simulator.log", "not run (--prepare-only)\n")
        if condition["path"] == "quantus_rcc_spectre":
            (attempt / "raw_output").mkdir()
        else:
            _atomic_write_text(attempt / "raw_output.raw", "")
        _atomic_write_text(attempt / "exit_code", "not-run\n")
        _atomic_write_json(attempt / "result.json", result)
        return result

    stdout = ""
    stderr = ""
    exit_code: int
    try:
        completed = _run_subprocess(command, attempt)
        stdout = completed.stdout or ""
        stderr = completed.stderr or ""
        exit_code = completed.returncode
        resource_outcome = "timeout" if completed.returncode == 124 and timeout_s is not None else "completed"
        if resource_outcome == "timeout":
            stderr += f"\nprocess timed out after {timeout_s} seconds\n"
    except OSError as exc:
        stderr = f"{exc}\n"
        exit_code = 127
        resource_outcome = "launch_error"
    _atomic_write_text(attempt / "stdout.txt", stdout)
    _atomic_write_text(attempt / "stderr.txt", stderr)
    log_path = attempt / "simulator.log"
    if log_path.exists():
        log_text = log_path.read_text(encoding="utf-8", errors="replace")
    else:
        log_text = stdout + ("\n" if stdout and stderr else "") + stderr
        _atomic_write_text(log_path, log_text)
    raw_path = attempt / ("raw_output" if condition["path"] == "quantus_rcc_spectre" else "raw_output.raw")
    raw_text = _read_raw_path(raw_path)
    diagnostic_text = "\n".join(part for part in (log_text, stdout, stderr) if part)
    classified = classify_execution(row, exit_code, diagnostic_text, raw_text)
    result.update(classified)
    result["exit_code"] = exit_code
    result["status"] = "complete"
    result["resource_outcome"] = resource_outcome
    result["log"] = str(log_path)
    result["raw_output"] = str(raw_path)
    _atomic_write_text(attempt / "exit_code", f"{exit_code}\n")
    _atomic_write_json(attempt / "result.json", result)
    return result


def _run_rows(
    rows: list[dict],
    sources: dict[str, str],
    source_hashes: dict[str, str],
    output: Path,
    jobs: int,
    prepare_only: bool,
    timeout_s: float | None,
) -> list[dict[str, Any]]:
    if jobs == 1:
        return [_run_row(row, sources, source_hashes, output, prepare_only, timeout_s) for row in rows]
    with ThreadPoolExecutor(max_workers=jobs) as executor:
        futures = [
            executor.submit(_run_row, row, sources, source_hashes, output, prepare_only, timeout_s)
            for row in rows
        ]
        return [future.result() for future in futures]


def _selected_rows_base(manifest: dict, rung: str) -> list[dict]:
    if rung == "all":
        return pending_static_rows(manifest)
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


def _validate_manifest_for_execution(manifest: dict) -> None:
    """Bind execution to this campaign and prohibit confirmation-data access."""
    _MANIFEST_CONTRACT.validate_manifest(manifest)
    if manifest.get("schema_version") != _MANIFEST_CONTRACT.SCHEMA_VERSION:
        raise ValueError("manifest schema_version is not the frozen campaign schema")
    if manifest.get("campaign_id") != _MANIFEST_CONTRACT.CAMPAIGN_ID:
        raise ValueError("manifest campaign_id is not the frozen campaign")
    scope = manifest.get("scope")
    if not isinstance(scope, dict):
        raise ValueError("manifest.scope must be an object")
    if scope.get("confirmation_data_accessed") is not False:
        raise ValueError("confirmation data must not be accessed")
    if scope.get("confirmation_data_authorized") is not False:
        raise ValueError("confirmation data must not be authorized")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--sources", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--rung", choices=("nominal", "extremes", "all"), required=True)
    parser.add_argument("--jobs", type=int, choices=(1, 2, 3, 4, 5, 6), default=1)
    parser.add_argument("--prepare-only", action="store_true")
    parser.add_argument("--paths", default=None, help="comma list of paths to run (edit20260922l addition)")
    parser.add_argument("--shard", default=None, help="k/n: run every n-th selected row starting at k (edit20260922l addition)")
    parser.add_argument(
        "--timeout-s",
        type=float,
        default=None,
        help="optional explicit per-row resource timeout; omitted means no runner timeout",
    )
    args = parser.parse_args(argv)
    ROW_FILTER["paths"] = set(args.paths.split(",")) if args.paths else None
    ROW_FILTER["shard"] = tuple(int(x) for x in args.shard.split("/")) if args.shard else None
    try:
        manifest = json.loads(args.manifest.read_text(encoding="utf-8"))
        if not isinstance(manifest, dict):
            raise ValueError("manifest must be an object")
        if args.timeout_s is not None and (not math.isfinite(args.timeout_s) or args.timeout_s <= 0):
            raise ValueError("--timeout-s must be a finite positive number")
        _validate_manifest_for_execution(manifest)
        # This is deliberately before output.mkdir(): a bad manifest or source
        # claim must leave no newly-created campaign directory behind.
        sources, source_hashes = _verify_sources(args.sources)
        rows = _selected_rows(manifest, args.rung)
        args.output.mkdir(parents=True, exist_ok=True)
        _atomic_write_json(
            args.output / "campaign.json",
            {
                "manifest": str(args.manifest.resolve()),
                "source_map": str(args.sources.resolve()),
                "source_hashes": source_hashes,
                "rung": args.rung,
                "jobs": args.jobs,
                "prepare_only": args.prepare_only,
                "timeout_s": args.timeout_s,
                "row_ids": [row.get("row_id") for row in rows],
            },
        )
        if args.prepare_only:
            results = _run_rows(rows, sources, source_hashes, args.output, args.jobs, True, args.timeout_s)
        elif args.rung == "all":
            results = []
            for stage in ("nominal", "extremes"):
                stage_results = _run_rows(
                    _selected_rows_filter(select_pilot_rows(manifest, stage)),
                    sources,
                    source_hashes,
                    args.output,
                    args.jobs,
                    False,
                    args.timeout_s,
                )
                results.extend(stage_results)
                if not all(
                    result.get("execution_validity") == "pass"
                    and result.get("scientific_validity") == "valid"
                    for result in stage_results
                ):
                    print(json.dumps({"status": f"{stage}_not_admitted_continuing_edit20260922l", "stage": stage}, sort_keys=True), flush=True)
            pilot_ids = {
                row.get("row_id") or _row_id(row, row["condition"])
                for stage in ("nominal", "extremes")
                for row in select_pilot_rows(manifest, stage)
            }
            remaining = [
                row
                for row in pending_static_rows(manifest)
                if (row.get("row_id") or _row_id(row, row["condition"])) not in pilot_ids
            ]
            remaining = _selected_rows_filter(remaining)
            analysis_order = {"comparator_dc": 0, "photoreceptor_dc": 1, "ac_gain": 2}
            remaining.sort(key=lambda row: analysis_order[row["condition"]["analysis"]])
            results.extend(
                _run_rows(remaining, sources, source_hashes, args.output, args.jobs, False, args.timeout_s)
            )
        else:
            results = _run_rows(rows, sources, source_hashes, args.output, args.jobs, False, args.timeout_s)
        print(json.dumps({"status": "prepared" if args.prepare_only else "complete", "results": results}, sort_keys=True))
        if args.prepare_only:
            return 0
        return (
            0
            if all(
                result.get("execution_validity") == "pass"
                and result.get("scientific_validity") == "valid"
                for result in results
            )
            else 1
        )
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        print(f"static campaign error: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
