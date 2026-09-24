from __future__ import annotations

import importlib.util
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location(
    "fixed_timing_health_runner", ROOT / "reset_campaign.py"
)
assert SPEC and SPEC.loader
reset = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(reset)


def traces(on_mode: str) -> tuple[list[float], dict[str, list[float]]]:
    times = [
        0.0,
        0.001,
        0.00100001,
        0.001004,
        0.001007,
        0.1,
        0.2,
        45.0,
        45.00000001,
        45.0001,
        45.001,
        45.00100001,
        45.001004,
        45.001007,
        45.5,
    ]
    pixrst = [1.8, 1.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.8, 1.8, 1.8, 0.0, 0.0, 0.0, 0.0]
    nrst = [0.0, 0.0, 0.0, 0.0, 1.8, 1.8, 1.8, 1.8, 0.0, 0.0, 0.0, 0.0, 0.0, 1.8, 1.8]
    if on_mode == "before_reference":
        on = [0.0, 0.0, 0.0, 1.8, 1.8, 1.8, 1.8, 1.8, 0.0, 0.0, 0.0, 0.0, 1.8, 1.8, 1.8]
    elif on_mode == "physical_event":
        on = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.8, 1.8, 0.0, 0.0, 0.0, 0.0, 1.8, 1.8, 1.8]
    elif on_mode == "forced_retrigger_only":
        on = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.8, 1.8, 1.8]
    else:
        raise AssertionError(on_mode)
    return times, {
        "vdd": [1.8] * len(times),
        "pixrst": pixrst,
        "nrst": nrst,
        "on": on,
        "vdiff": [0.9] * len(times),
    }


def result(evidence: dict) -> dict:
    return {
        "execution_validity": "pass",
        "scientific_validity": "valid",
        "condition": {"stimulus": {"protocol_mode": "fixed_common_timeline_v1"}},
        "event_evidence": evidence,
    }


class FixedTimingHealthTests(unittest.TestCase):
    def test_early_on_is_not_relabelled_by_the_forced_reset_retrigger(self) -> None:
        times, values = traces("before_reference")
        evidence = reset.describe_fixed_timeline_event_evidence(times, values)
        leak = evidence["leak_event_period"]
        self.assertEqual(leak["status"], "event_precedes_reference")
        self.assertIsNone(leak["physical_interval_s"])
        self.assertGreater(leak["selected_cace_crossing_s"], 45.0)
        self.assertEqual(evidence["simulation_health"]["status"], "fail")
        self.assertFalse(reset._results_are_valid([result(evidence)]))

    def test_only_a_pre_reset_post_reference_event_passes_health_gate(self) -> None:
        times, values = traces("physical_event")
        evidence = reset.describe_fixed_timeline_event_evidence(times, values)
        leak = evidence["leak_event_period"]
        self.assertEqual(leak["status"], "measured")
        self.assertAlmostEqual(leak["physical_interval_s"], leak["cace_scalar_s"])
        self.assertLess(leak["crossing_s"], 45.0)
        self.assertEqual(evidence["simulation_health"]["status"], "pass")
        self.assertTrue(reset._results_are_valid([result(evidence)]))

    def test_a_crossing_created_only_by_second_reset_is_not_a_leak_event(self) -> None:
        times, values = traces("forced_retrigger_only")
        evidence = reset.describe_fixed_timeline_event_evidence(times, values)
        leak = evidence["leak_event_period"]
        self.assertEqual(leak["status"], "forced_reset_retrigger")
        self.assertIsNone(leak["physical_interval_s"])
        self.assertEqual(evidence["simulation_health"]["status"], "fail")
        self.assertFalse(reset._results_are_valid([result(evidence)]))


if __name__ == "__main__":
    unittest.main()
