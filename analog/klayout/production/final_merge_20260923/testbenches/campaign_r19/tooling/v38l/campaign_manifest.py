"""Build and validate the deterministic full-array PVT campaign manifest."""

from __future__ import annotations

import argparse
import copy
import hashlib
import json
import math
import os
import sys
from collections.abc import Iterator
from pathlib import Path
from typing import Any

SCHEMA_VERSION = 1
CAMPAIGN_ID = "full-pvt-three-path-edit20260922r19-v1"

PATHS = (
    "quantus_rcc_spectre",
    "magic_rcc_ngspice",
    "schematic_ngspice",
)
ANALYSIS_ORDER = (
    "photoreceptor_dc",
    "comparator_dc",
    "ac_gain",
    "reset_transient",
    "automatic_read",
)
ANALYSIS_COUNTS = {
    "photoreceptor_dc": 180,
    "comparator_dc": 45,
    "ac_gain": 90,
    "reset_transient": 45,
    "automatic_read": 45,
}
CORNERS = ("tt", "ss", "ff", "sf", "fs")
VDD_VALUES = (1.62, 1.8, 1.98)
TEMPERATURES = (0, 27, 70)
PIXELS = ("vpd[0]", "vpd[1]", "vpd[2]", "vpd[3]")
BIAS_NAMES = ("PrBp", "PrSFBp", "DiffBn", "OnBn", "OffBn", "RefrBp")
FIXED_RESET_TIMELINE = (
    {"time_s": 0.0, "level_fraction_vdd": 1.0},
    {"time_s": 0.001, "level_fraction_vdd": 1.0},
    {"time_s": 0.00100001, "level_fraction_vdd": 0.0},
    {"time_s": 45.0, "level_fraction_vdd": 0.0},
    {"time_s": 45.00000001, "level_fraction_vdd": 1.0},
    {"time_s": 45.001, "level_fraction_vdd": 1.0},
    {"time_s": 45.00100001, "level_fraction_vdd": 0.0},
    {"time_s": 45.5, "level_fraction_vdd": 0.0},
)

SOURCE_DEFINITIONS = {
    "quantus_rcc_spectre": {
        "identity": "edit20260922r19_quantus_rcc_spectre_junction_corrected_view",
        "sha256": "5d310937e01bbc7420b3c3affc4fa27264e9cc72d119dd87e41595309d4c6acf",
    },
    "magic_rcc_ngspice": {
        "identity": "edit20260922r19_magic_composed_21_port_rcc",
        "sha256": "9d03d2940e53d926331a13600899545719f388e7f37ac72847564c7265170086",
    },
    "schematic_ngspice": {
        "identity": "c1b_and_photodiode_corrected_normalized_schematic",
        "sha256": "6453d01af285ebb688036192a8e527087b1cd066e3f3d43b2de94a8e44e1e3a2",
    },
}

PATH_DEFINITIONS = {
    "quantus_rcc_spectre": {"simulator": "spectre", "view": "quantus_rcc"},
    "magic_rcc_ngspice": {"simulator": "ngspice", "view": "magic_rcc"},
    "schematic_ngspice": {"simulator": "ngspice", "view": "schematic"},
}

RESULT_AXES = {
    "execution_validity": {"pending", "pass", "fail"},
    "scientific_validity": {"pending", "valid", "invalid", "blocked_at_protocol"},
    "spec_result": {"not_evaluated", "pass", "fail"},
    "comparison": {"not_evaluated", "diagnostic", "comparable", "not_comparable"},
}

_CONDITION_KEYS = {
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
_ROW_KEYS = {"row_id", "condition", "source", "execution", "result"}
_SOURCE_KEYS = {"identity", "sha256"}
_OPTICAL_KEYS = {"mode", "photocurrent_a"}
_REUSED_EVIDENCE = {}
_PHOTOCURRENT_SWEEP_KEYS = {
    "kind",
    "expression",
    "control",
    "exponent_start",
    "exponent_stop",
    "exponent_step",
    "values_a",
}
_PHOTOCURRENT_SWEEP = {
    "kind": "power_law_sweep",
    "expression": "10**Vexp",
    "control": "Vexp",
    "exponent_start": -7.0,
    "exponent_stop": -12.0,
    "exponent_step": -0.2,
}
_BIAS_PIN_FORCING = {
    "photoreceptor_dc": {
        "PrBp": "current_mirror_driven",
        "PrSFBp": "current_mirror_driven",
        "OnBn": "rail_tied_to_vdd",
        "OffBn": "rail_tied_to_vdd",
        "RefrBp": "rail_tied_to_vdd",
        "DiffBn": "rail_tied_to_ground",
    },
    "comparator_dc": {
        "OnBn": "current_mirror_driven",
        "OffBn": "current_mirror_driven",
        "DiffBn": "rail_tied_to_ground",
        "RefrBp": "rail_tied_to_ground",
        "PrBp": "rail_tied_to_ground",
        "PrSFBp": "rail_tied_to_vdd",
    },
    "ac_gain": {
        "PrBp": "current_mirror_driven",
        "PrSFBp": "current_mirror_driven",
        "DiffBn": "current_mirror_driven",
        "OnBn": "rail_tied_to_vdd",
        "OffBn": "rail_tied_to_vdd",
        "RefrBp": "rail_tied_to_vdd",
    },
    "reset_transient": {name: "current_mirror_driven" for name in BIAS_NAMES},
    "automatic_read": {name: "current_mirror_driven" for name in BIAS_NAMES},
}
_PIXEL_NODES = tuple(f"pixel[{index}]" for index in range(4))


def _canonical_json(value: Any) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"), allow_nan=False)


def _row_id(condition: dict[str, Any]) -> str:
    """Return an ID derived from the complete canonical condition identity."""
    digest = hashlib.sha256(_canonical_json(condition).encode("utf-8")).hexdigest()
    return "row-" + digest


def _biases(**overrides: float) -> dict[str, float]:
    values = {name: 0.0 for name in BIAS_NAMES}
    values.update(overrides)
    return values


def _optical(mode: str, current_a: float) -> dict[str, Any]:
    return {
        "mode": mode,
        "photocurrent_a": {pixel: current_a for pixel in PIXELS},
    }


def _photoreceptor_optical() -> dict[str, Any]:
    sweep = dict(_PHOTOCURRENT_SWEEP)
    sweep["values_a"] = [
        10 ** (sweep["exponent_start"] + sweep["exponent_step"] * index)
        for index in range(26)
    ]
    return {
        "mode": "photocurrent_dc_sweep",
        "photocurrent_a": {
            "vpd[0]": sweep,
            "vpd[1]": 1e-9,
            "vpd[2]": 1e-9,
            "vpd[3]": 1e-9,
        },
    }


def _pin_forcing(analysis: str) -> dict[str, str]:
    controls = {
        "pixRst[0]": "inactive_low",
        "pixRst[1]": "inactive_low",
        "rowReadON[0]": "inactive_low",
        "rowReadON[1]": "inactive_low",
        "rowReadOFF[0]": "inactive_low",
        "rowReadOFF[1]": "inactive_low",
        "readLine[0]": "inactive_low",
        "readLine[1]": "inactive_low",
        "VddA18": "rail_tied_to_vdd",
        "GndA": "rail_tied_to_ground",
        "GndD": "rail_tied_to_ground",
    }
    controls.update(_BIAS_PIN_FORCING[analysis])
    if analysis == "reset_transient":
        controls["pixRst[0]"] = "fixed_timeline_driven"
        controls["rowReadON[0]"] = "fixed_timeline_driven"
    elif analysis == "automatic_read":
        controls["pixRst[0]"] = "controller_driven"
        controls["pixRst[1]"] = "controller_driven"
        controls["rowReadON[0]"] = "controller_driven"
        controls["rowReadON[1]"] = "controller_driven"
        controls["rowReadOFF[0]"] = "controller_driven"
        controls["rowReadOFF[1]"] = "controller_driven"
        controls["readLine[0]"] = "pullup_to_vdd"
        controls["readLine[1]"] = "pullup_to_vdd"
    return controls


def _initial_state(analysis: str) -> dict[str, str]:
    state = {
        "pixRst[0]": "low",
        "pixRst[1]": "low",
        "rowReadON[0]": "low",
        "rowReadON[1]": "low",
        "rowReadOFF[0]": "low",
        "rowReadOFF[1]": "low",
        "readLine[0]": "low",
        "readLine[1]": "low",
        "vpd[0]": "optical_source_defined",
        "vpd[1]": "optical_source_defined",
        "vpd[2]": "optical_source_defined",
        "vpd[3]": "optical_source_defined",
    }
    if analysis == "automatic_read":
        state["readLine[0]"] = "pulled_high"
        state["readLine[1]"] = "pulled_high"
    elif analysis == "reset_transient":
        state["pixRst[0]"] = "high"
        state["rowReadON[0]"] = "high"
    return state


def _stimulus(analysis: str, vdd_v: float | None = None) -> dict[str, Any]:
    if analysis == "photoreceptor_dc":
        return {
            "kind": "dc_sweep",
            "control": "Vexp",
            "start_v": -7.0,
            "stop_v": -12.0,
            "step_v": -0.2,
            "photocurrent_model": "10**Vexp",
        }
    if analysis == "comparator_dc":
        return {
            "kind": "dc_sweep",
            "control": "vdiff",
            "start_v": 0.0,
            "stop_v": vdd_v,
            "step_v": 0.0001,
            "forced_pixel": "pixel[0].vdiff",
        }
    if analysis == "ac_gain":
        return {
            "kind": "ac_sweep",
            "source": "vpd[0]",
            "dc_current_a": 1e-8,
            "ac_current_a": 1e-8,
            "start_frequency_hz": 1e-3,
            "stop_frequency_hz": 1e9,
            "points_per_decade": 50,
        }
    if analysis == "reset_transient":
        return {
            "kind": "reset_release_transient",
            "stop_s": 45.5,
            "reset_drive": "explicit_piecewise_linear_voltage_source",
            "reset_phase": "fixed_two_pulse_timeline",
            "protocol_mode": "fixed_common_timeline_v1",
            "event_trigger": "none",
            "timeline": copy.deepcopy(list(FIXED_RESET_TIMELINE)),
            "cace_reference": {
                "configuration_sha256": "68f501f65eea943f0a85300669a6b066c735b4da228ab1ebe3ff4dd4aeea2338",
                "postprocessor_sha256": "2ce2f3d1e94facbf69213d10ec68b15f19c418b32c6b549ea79e19ff42a92e6f",
                "testbench_sha256": "91f7ab29b4d7fd108bd733c7b9a4ad962d748d50cda7a00593542401686e8ab5",
            },
            "adaptation": (
                "The CACE event-triggered second reset is replaced by its registered "
                "45 s timeout path so every matched path and PVT row receives the same "
                "absolute waveform. All three simulators use the same 10 ns edge duration."
            ),
        }
    return {
        "kind": "automatic_read_transient",
        "stop_s": 0.39,
        "baseline_current_a": 1e-9,
        "event_pulses": [
            {
                "pixel": "vpd[0]",
                "start_a": 50e-9,
                "end_a": 100e-9,
                "delay_s": 0.120,
            },
            {
                "pixel": "vpd[0]",
                "start_a": 50e-9,
                "end_a": 25e-9,
                "delay_s": 0.240,
            },
        ],
    }


def _analysis_conditions(analysis: str) -> dict[str, Any]:
    if analysis == "photoreceptor_dc":
        return {
            "gmin_s": 1e-13,
            "reltol": 1e-4,
            "vabstol_v": 1e-9,
            "iabstol_a": 1e-15,
            "photodiode_load_f": 30e-15,
            "ngspice_dc_solver": {
                "chgtol_c": 1e-16,
                "itl1": 500,
                "itl2": 200,
                "gminsteps": 200,
                "srcsteps": 200,
            },
        }
    if analysis == "comparator_dc":
        return {
            "gmin_s": 1e-13,
            "reltol": 1e-4,
            "vabstol_v": 1e-9,
            "iabstol_a": 1e-15,
            "ngspice_dc_solver": {
                "chgtol_c": 1e-16,
                "itl1": 500,
                "itl2": 200,
                "gminsteps": 200,
                "srcsteps": 200,
            },
        }
    if analysis == "ac_gain":
        return {
            "gmin_s": 1e-16,
            "reltol": 1e-4,
            "vabstol_v": 1e-9,
            "iabstol_a": 1e-15,
            "added_load_f": 0.0,
            "load_contract": "no_added_load",
            "dc_stabilization": {
                "pixels": list(_PIXEL_NODES),
                "inductor_h": 1e15,
                "nRst_resistance_ohm": 1e12,
            },
        }
    if analysis == "reset_transient":
        return {
            "gmin_s": 1e-17,
            "reltol": 5e-4,
            "vabstol_v": 1e-6,
            "iabstol_a": 1e-12,
            "chgtol_c": 1e-16,
            "coarse_settling_max_step_s": 100e-6,
            "integration_method": "gear2only",
            "trtol": 1,
            "itl1": 1000,
            "itl2": 500,
            "itl4": 100,
            "gminsteps": 500,
            "srcsteps": 500,
            "ramptime_s": 100e-9,
        }
    return {
        "gmin_s": 1e-16,
        "reltol": 1e-4,
        "vabstol_v": 1e-9,
        "iabstol_a": 1e-15,
        "max_step_s": 1e-6,
        "skipdc": True,
        "integration_method": "gear2only",
        "photodiode_load_f": 30e-15,
        "read_line_load_f": 300e-15,
        "read_line_pullup_ohm": 10000,
    }


def _bias_condition(analysis: str, **variant: float) -> dict[str, float]:
    if analysis == "photoreceptor_dc":
        return _biases(PrBp=variant["PrBp"], PrSFBp=variant["PrSFBp"])
    if analysis == "comparator_dc":
        return _biases(OnBn=200e-9, OffBn=0.5e-9)
    if analysis == "ac_gain":
        return _biases(PrBp=10e-9, PrSFBp=10e-12, DiffBn=variant["DiffBn"])
    if analysis == "reset_transient":
        return _biases(
            PrBp=10e-9,
            PrSFBp=100e-12,
            DiffBn=10e-9,
            OnBn=70e-9,
            OffBn=1e-9,
            RefrBp=4e-9,
        )
    return _biases(
        PrBp=10e-9,
        PrSFBp=100e-12,
        DiffBn=5e-9,
        OnBn=200e-9,
        OffBn=250e-12,
        RefrBp=400e-12,
    )


def _optical_condition(analysis: str) -> dict[str, Any]:
    if analysis == "photoreceptor_dc":
        return _photoreceptor_optical()
    if analysis == "ac_gain":
        return _optical("photocurrent_dc_plus_ac", 10e-9)
    if analysis == "automatic_read":
        return _optical("photocurrent_baseline_with_event_pulses", 1e-9)
    return _optical("photocurrent_dc", 1e-9)


def _condition(
    path: str,
    analysis: str,
    corner: str,
    vdd_v: float,
    temperature_c: int,
    **variant: float,
) -> dict[str, Any]:
    path_definition = PATH_DEFINITIONS[path]
    return {
        "path": path,
        "simulator": path_definition["simulator"],
        "view": path_definition["view"],
        "analysis": analysis,
        "corner": corner,
        "vdd_v": vdd_v,
        "temperature_c": temperature_c,
        "biases_a": _bias_condition(analysis, **variant),
        "pin_forcing": _pin_forcing(analysis),
        "optical": _optical_condition(analysis),
        "initial_state": _initial_state(analysis),
        "stimulus": _stimulus(analysis, vdd_v),
        "analysis_conditions": _analysis_conditions(analysis),
    }


def _iter_condition_records() -> Iterator[tuple[dict[str, Any], bool]]:
    """Yield the frozen condition grid and whether each row reuses evidence."""
    for path in PATHS:
        for corner in CORNERS:
            for vdd_v in VDD_VALUES:
                for temperature_c in TEMPERATURES:
                    common = {
                        "path": path,
                        "corner": corner,
                        "vdd_v": vdd_v,
                        "temperature_c": temperature_c,
                    }
                    for prbp in (1e-9, 100e-9):
                        for prsfbp in (100e-12, 10e-9):
                            condition = _condition(
                                analysis="photoreceptor_dc",
                                PrBp=prbp,
                                PrSFBp=prsfbp,
                                **common,
                            )
                            yield condition, False
                    yield (
                        _condition(analysis="comparator_dc", **common),
                        False,
                    )
                    for diffbn in (1e-9, 10e-9):
                        condition = _condition(
                            analysis="ac_gain",
                            DiffBn=diffbn,
                            **common,
                        )
                        reusable = (
                            corner == "tt"
                            and vdd_v == 1.8
                            and temperature_c == 27
                            and diffbn == 1e-9
                            and path in _REUSED_EVIDENCE
                        )
                        yield condition, reusable
                    yield (
                        _condition(analysis="reset_transient", **common),
                        False,
                    )
                    yield (
                        _condition(analysis="automatic_read", **common),
                        False,
                    )


def _execution_record(path: str, analysis: str, reusable: bool) -> dict[str, Any]:
    if reusable:
        return {
            "eligible": True,
            "state": "complete_reused",
            "evidence_sha256": _REUSED_EVIDENCE[path],
        }
    if analysis == "automatic_read":
        return {
            "eligible": False,
            "state": "blocked_at_protocol",
            "reason": "paired_nominal_optical_null_contrast_controls_required",
        }
    return {"eligible": True, "state": "pending"}


def _result_record(analysis: str, reusable: bool) -> dict[str, str]:
    return {
        "execution_validity": "pass" if reusable else "pending",
        "scientific_validity": (
            "valid"
            if reusable
            else "blocked_at_protocol"
            if analysis == "automatic_read"
            else "pending"
        ),
        "spec_result": "not_evaluated",
        "comparison": "diagnostic" if reusable else "not_evaluated",
    }


def build_manifest() -> dict:
    """Return the complete deterministic three-path manifest."""
    rows = []
    for condition, reusable in _iter_condition_records():
        analysis = condition["analysis"]
        path = condition["path"]
        rows.append(
            {
                "row_id": _row_id(condition),
                "condition": condition,
                "source": copy.deepcopy(SOURCE_DEFINITIONS[path]),
                "execution": _execution_record(path, analysis, reusable),
                "result": _result_record(analysis, reusable),
            }
        )

    manifest = {
        "schema_version": SCHEMA_VERSION,
        "campaign_id": CAMPAIGN_ID,
        "paths": list(PATHS),
        "grid": {
            "corners": list(CORNERS),
            "vdd_v": list(VDD_VALUES),
            "temperature_c": list(TEMPERATURES),
        },
        "analysis_counts": dict(ANALYSIS_COUNTS),
        "rows_per_path": sum(ANALYSIS_COUNTS.values()),
        "sources": copy.deepcopy(SOURCE_DEFINITIONS),
        "scope": {
            "array": "full_2x2",
            "confirmation_data_accessed": False,
            "confirmation_data_authorized": False,
            "comparison_boundary": (
                "Differences are cross-extractor/cross-simulator diagnostics, "
                "not simulator-only attribution; no numerical equivalence "
                "threshold is registered."
            ),
        },
        "protocol": {
            "reset_transient": {
                "mode": "fixed_common_timeline_v1",
                "event_trigger": "none",
                "stop_s": 45.5,
                "timeline": copy.deepcopy(list(FIXED_RESET_TIMELINE)),
                "comparison_rule": (
                    "Matched path comparisons use identical absolute reset-source "
                    "times and VDD-normalized levels."
                ),
            },
            "automatic_read": {
                "status": "blocked_at_protocol",
                "execution_eligible": False,
                "reason": "paired_nominal_optical_null_contrast_controls_required",
                "required_before_scale_up": [
                    "nominal schematic optical control with initialized reference",
                    "nominal schematic null control with zero events",
                    "nominal schematic contrast control",
                    "one extracted null check",
                ],
            },
        },
        "rows": rows,
    }
    return manifest


def _located(path: str, message: str) -> ValueError:
    return ValueError(f"{path}: {message}")


def _require_mapping(value: Any, path: str) -> dict[str, Any]:
    if not isinstance(value, dict):
        raise _located(path, "must be an object")
    return value


def _require_keys(value: dict[str, Any], expected: set[str], path: str) -> None:
    actual = set(value)
    missing = sorted(expected - actual)
    extra = sorted(actual - expected)
    if missing:
        raise _located(path, "missing " + ", ".join(missing))
    if extra:
        raise _located(path, "unexpected " + ", ".join(extra))


def _require_string(value: Any, path: str) -> str:
    if not isinstance(value, str) or not value:
        raise _located(path, "must be a non-empty string")
    return value


def _require_number(value: Any, path: str) -> None:
    if isinstance(value, bool) or not isinstance(value, (int, float)):
        raise _located(path, "must be a number")
    if not math.isfinite(float(value)):
        raise _located(path, "must be finite")


def _validate_photoreceptor_sweep(value: Any, path: str) -> None:
    sweep = _require_mapping(value, path)
    _require_keys(sweep, _PHOTOCURRENT_SWEEP_KEYS, path)
    for name in ("exponent_start", "exponent_stop", "exponent_step"):
        _require_number(sweep[name], f"{path}.{name}")
        if sweep[name] != _PHOTOCURRENT_SWEEP[name]:
            raise _located(f"{path}.{name}", "does not match the frozen Vexp sweep")
    for name in ("kind", "expression", "control"):
        if sweep[name] != _PHOTOCURRENT_SWEEP[name]:
            raise _located(f"{path}.{name}", "does not match the frozen Vexp sweep")

    values = sweep["values_a"]
    if not isinstance(values, list):
        raise _located(f"{path}.values_a", "must be an array")
    if len(values) != 26:
        raise _located(f"{path}.values_a", "must contain exactly 26 values")
    expected_values = [
        10
        ** (
            _PHOTOCURRENT_SWEEP["exponent_start"]
            + _PHOTOCURRENT_SWEEP["exponent_step"] * index
        )
        for index in range(26)
    ]
    for index, current_a in enumerate(values):
        _require_number(current_a, f"{path}.values_a[{index}]")
        if current_a < 0:
            raise _located(f"{path}.values_a[{index}]", "must not be negative")
        if current_a != expected_values[index]:
            raise _located(
                f"{path}.values_a[{index}]",
                "does not match the frozen 10**Vexp sweep",
            )
    if values[0] != 1e-7 or values[-1] != 1e-12:
        raise _located(f"{path}.values_a", "must run from 1e-7 A through 1e-12 A")


def _validate_condition(condition: Any, path: str) -> dict[str, Any]:
    condition = _require_mapping(condition, path)
    _require_keys(condition, _CONDITION_KEYS, path)
    for name in ("path", "simulator", "view", "analysis", "corner"):
        _require_string(condition[name], f"{path}.{name}")
    _require_number(condition["vdd_v"], f"{path}.vdd_v")
    _require_number(condition["temperature_c"], f"{path}.temperature_c")

    biases = _require_mapping(condition["biases_a"], f"{path}.biases_a")
    _require_keys(biases, set(BIAS_NAMES), f"{path}.biases_a")
    for name, value in biases.items():
        _require_number(value, f"{path}.biases_a.{name}")
        if value < 0:
            raise _located(f"{path}.biases_a.{name}", "must not be negative")

    pin_forcing = _require_mapping(condition["pin_forcing"], f"{path}.pin_forcing")
    if not pin_forcing:
        raise _located(f"{path}.pin_forcing", "must explicitly record forced pins")
    for name, value in pin_forcing.items():
        _require_string(name, f"{path}.pin_forcing key")
        _require_string(value, f"{path}.pin_forcing.{name}")
    expected_bias_forcing = _BIAS_PIN_FORCING.get(condition["analysis"])
    if expected_bias_forcing is None:
        raise _located(f"{path}.analysis", "is not a frozen analysis")
    for name, expected_value in expected_bias_forcing.items():
        if pin_forcing.get(name) != expected_value:
            raise _located(
                f"{path}.pin_forcing.{name}",
                f"must be {expected_value}",
            )

    optical = _require_mapping(condition["optical"], f"{path}.optical")
    _require_keys(optical, _OPTICAL_KEYS, f"{path}.optical")
    _require_string(optical["mode"], f"{path}.optical.mode")
    photocurrents = _require_mapping(
        optical["photocurrent_a"], f"{path}.optical.photocurrent_a"
    )
    _require_keys(photocurrents, set(PIXELS), f"{path}.optical.photocurrent_a")
    for pixel, value in photocurrents.items():
        pixel_path = f"{path}.optical.photocurrent_a.{pixel}"
        if condition["analysis"] == "photoreceptor_dc" and pixel == "vpd[0]":
            _validate_photoreceptor_sweep(value, pixel_path)
        else:
            _require_number(value, pixel_path)
            if value < 0:
                raise _located(pixel_path, "must not be negative")

    for name in ("initial_state", "stimulus", "analysis_conditions"):
        nested = _require_mapping(condition[name], f"{path}.{name}")
        if not nested:
            raise _located(f"{path}.{name}", "must be explicit and non-empty")
    return condition


def _validate_source(source: Any, path: str, expected: dict[str, str]) -> None:
    source = _require_mapping(source, path)
    _require_keys(source, _SOURCE_KEYS, path)
    if source != expected:
        raise _located(path, "does not match the frozen source identity and hash")


def _validate_result(result: Any, path: str) -> dict[str, str]:
    result = _require_mapping(result, path)
    _require_keys(result, set(RESULT_AXES), path)
    for axis, allowed in RESULT_AXES.items():
        value = _require_string(result[axis], f"{path}.{axis}")
        if value not in allowed:
            raise _located(f"{path}.{axis}", f"unsupported value {value!r}")
    return result


def _validate_execution(
    execution: Any,
    path: str,
    expected_path: str,
    expected_analysis: str,
    reusable: bool,
) -> dict[str, Any]:
    execution = _require_mapping(execution, path)
    required = {"eligible", "state"}
    if reusable:
        required.add("evidence_sha256")
    elif expected_analysis == "automatic_read":
        required.add("reason")
    _require_keys(execution, required, path)
    if not isinstance(execution["eligible"], bool):
        raise _located(f"{path}.eligible", "must be boolean")

    if reusable:
        if execution["eligible"] is not True or execution["state"] != "complete_reused":
            raise _located(
                path, "reusable row is not marked complete_reused and eligible"
            )
        evidence = _require_string(
            execution["evidence_sha256"], f"{path}.evidence_sha256"
        )
        if len(evidence) != 64 or any(
            character not in "0123456789abcdef" for character in evidence
        ):
            raise _located(f"{path}.evidence_sha256", "must be a lowercase SHA-256")
    elif expected_analysis == "automatic_read":
        if (
            execution["eligible"] is not False
            or execution["state"] != "blocked_at_protocol"
        ):
            raise _located(path, "automatic-read row must be blocked at protocol")
        if (
            execution["reason"]
            != "paired_nominal_optical_null_contrast_controls_required"
        ):
            raise _located(f"{path}.reason", "does not match the protocol block")
    else:
        if execution["eligible"] is not True or execution["state"] != "pending":
            raise _located(path, "non-reused row must be pending and eligible")
    return execution


def validate_manifest(manifest: dict) -> None:
    """Raise a located ``ValueError`` if *manifest* violates the frozen contract."""
    if not isinstance(manifest, dict):
        raise _located("manifest", "must be an object")
    try:
        json.dumps(manifest, allow_nan=False)
    except (TypeError, ValueError) as exc:
        raise _located("manifest", f"must be JSON-serializable ({exc})") from exc

    required_top_level = {
        "schema_version",
        "campaign_id",
        "paths",
        "grid",
        "analysis_counts",
        "rows_per_path",
        "sources",
        "scope",
        "protocol",
        "rows",
    }
    actual_top_level = set(manifest)
    missing = sorted(required_top_level - actual_top_level)
    if missing:
        raise _located("manifest", "missing " + ", ".join(missing))

    if manifest["schema_version"] != SCHEMA_VERSION:
        raise _located("manifest.schema_version", "does not match the frozen schema")
    if manifest["campaign_id"] != CAMPAIGN_ID:
        raise _located("manifest.campaign_id", "does not match the frozen campaign")
    if manifest["paths"] != list(PATHS):
        raise _located("manifest.paths", "does not match the frozen path order")

    grid = _require_mapping(manifest["grid"], "manifest.grid")
    if grid != {
        "corners": list(CORNERS),
        "vdd_v": list(VDD_VALUES),
        "temperature_c": list(TEMPERATURES),
    }:
        raise _located("manifest.grid", "does not match the frozen PVT axes")

    if manifest["analysis_counts"] != ANALYSIS_COUNTS:
        raise _located(
            "manifest.analysis_counts", "does not match the frozen analysis counts"
        )
    if manifest["rows_per_path"] != sum(ANALYSIS_COUNTS.values()):
        raise _located("manifest.rows_per_path", "must equal 405")

    sources = _require_mapping(manifest["sources"], "manifest.sources")
    if set(sources) != set(PATHS):
        raise _located(
            "manifest.sources", "must contain exactly the three path sources"
        )
    for path in PATHS:
        _validate_source(
            sources[path], f"manifest.sources.{path}", SOURCE_DEFINITIONS[path]
        )

    scope = _require_mapping(manifest["scope"], "manifest.scope")
    for name in ("confirmation_data_accessed", "confirmation_data_authorized"):
        if scope.get(name) is not False:
            raise _located(f"manifest.scope.{name}", "must be false")
    comparison_boundary = (
        "Differences are cross-extractor/cross-simulator diagnostics, "
        "not simulator-only attribution; no numerical equivalence threshold "
        "is registered."
    )
    if scope.get("comparison_boundary") != comparison_boundary:
        raise _located(
            "manifest.scope.comparison_boundary",
            "does not match the frozen comparison boundary",
        )

    protocol = _require_mapping(manifest["protocol"], "manifest.protocol")
    expected_reset_protocol = {
        "mode": "fixed_common_timeline_v1",
        "event_trigger": "none",
        "stop_s": 45.5,
        "timeline": copy.deepcopy(list(FIXED_RESET_TIMELINE)),
        "comparison_rule": (
            "Matched path comparisons use identical absolute reset-source "
            "times and VDD-normalized levels."
        ),
    }
    if protocol.get("reset_transient") != expected_reset_protocol:
        raise _located(
            "manifest.protocol.reset_transient",
            "does not match the fixed common reset timeline",
        )
    automatic_protocol = _require_mapping(
        protocol.get("automatic_read"), "manifest.protocol.automatic_read"
    )
    if automatic_protocol.get("status") != "blocked_at_protocol":
        raise _located(
            "manifest.protocol.automatic_read.status",
            "must block automatic-read at protocol",
        )
    if automatic_protocol.get("execution_eligible") is not False:
        raise _located(
            "manifest.protocol.automatic_read.execution_eligible",
            "must be false",
        )

    rows = manifest["rows"]
    if not isinstance(rows, list):
        raise _located("manifest.rows", "must be an array")
    expected_records = list(_iter_condition_records())
    expected_by_identity = {
        _canonical_json(condition): (condition, reusable)
        for condition, reusable in expected_records
    }
    if len(expected_by_identity) != 1215:
        raise _located(
            "implementation",
            "frozen condition generator did not produce 1,215 unique rows",
        )
    if len(rows) != len(expected_by_identity):
        raise _located("manifest.rows", "must contain exactly 1,215 rows")

    seen_ids: set[str] = set()
    seen_identities: set[str] = set()
    for index, row in enumerate(rows):
        row_path = f"manifest.rows[{index}]"
        row = _require_mapping(row, row_path)
        _require_keys(row, _ROW_KEYS, row_path)
        row_id = _require_string(row["row_id"], f"{row_path}.row_id")
        if row_id in seen_ids:
            raise _located(f"{row_path}.row_id", f"duplicate row_id {row_id}")
        seen_ids.add(row_id)

        condition = _validate_condition(row["condition"], f"{row_path}.condition")
        identity = _canonical_json(condition)
        expected = expected_by_identity.get(identity)
        if expected is None:
            raise _located(
                f"{row_path}.condition", "is not in the frozen condition grid"
            )
        expected_condition, reusable = expected
        seen_identities.add(identity)
        expected_id = _row_id(expected_condition)
        if row_id != expected_id:
            raise _located(
                f"{row_path}.row_id",
                "is not derived from the canonical row identity",
            )

        path = condition["path"]
        if path not in PATHS:
            raise _located(f"{row_path}.condition.path", "is not a frozen path")
        if condition["simulator"] != PATH_DEFINITIONS[path]["simulator"]:
            raise _located(f"{row_path}.condition.simulator", "does not match its path")
        if condition["view"] != PATH_DEFINITIONS[path]["view"]:
            raise _located(f"{row_path}.condition.view", "does not match its path")
        _validate_source(row["source"], f"{row_path}.source", SOURCE_DEFINITIONS[path])
        _validate_execution(
            row["execution"],
            f"{row_path}.execution",
            path,
            condition["analysis"],
            reusable,
        )
        result = _validate_result(row["result"], f"{row_path}.result")
        expected_result = _result_record(condition["analysis"], reusable)
        if result != expected_result:
            raise _located(
                f"{row_path}.result", "does not preserve independent frozen result axes"
            )

    if len(seen_identities) != len(expected_by_identity):
        raise _located(
            "manifest.rows", "does not cover every frozen condition exactly once"
        )


def _write_manifest(path: Path) -> None:
    manifest = build_manifest()
    validate_manifest(manifest)
    payload = _canonical_json(manifest) + "\n"
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + ".tmp")
    try:
        temporary.write_text(payload, encoding="utf-8")
        os.replace(temporary, path)
    finally:
        if temporary.exists():
            temporary.unlink()


def main(argv: list[str] | None = None) -> int:
    """Write or validate the manifest from the command line."""
    parser = argparse.ArgumentParser(description=__doc__)
    modes = parser.add_mutually_exclusive_group(required=True)
    modes.add_argument("--write", type=Path, metavar="PATH")
    modes.add_argument("--validate", type=Path, metavar="PATH")
    args = parser.parse_args(argv)

    try:
        if args.write is not None:
            _write_manifest(args.write)
            print(f"wrote {args.write}")
        else:
            with args.validate.open("r", encoding="utf-8") as handle:
                manifest = json.load(handle)
            validate_manifest(manifest)
            print(f"validated {args.validate}")
    except (OSError, json.JSONDecodeError, ValueError) as exc:
        print(f"campaign manifest error: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
