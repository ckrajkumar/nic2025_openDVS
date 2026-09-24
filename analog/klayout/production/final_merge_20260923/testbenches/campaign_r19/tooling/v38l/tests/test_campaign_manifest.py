from __future__ import annotations

import copy
import importlib.util
import json
import unittest
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location(
    "campaign_manifest", ROOT / "campaign_manifest.py"
)
assert SPEC and SPEC.loader
campaign_manifest = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(campaign_manifest)


PATHS = (
    "quantus_rcc_spectre",
    "magic_rcc_ngspice",
    "schematic_ngspice",
)
ANALYSIS_COUNTS = {
    "photoreceptor_dc": 180,
    "comparator_dc": 45,
    "ac_gain": 90,
    "reset_transient": 45,
    "automatic_read": 45,
}
BASE_CONDITION_KEYS = {
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
RESULT_AXES = {
    "execution_validity",
    "scientific_validity",
    "spec_result",
    "comparison",
}


class CampaignManifestTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.manifest = campaign_manifest.build_manifest()
        cls.rows = cls.manifest["rows"]

    def test_exact_paths_analyses_and_counts(self) -> None:
        self.assertEqual(tuple(self.manifest["paths"]), PATHS)
        self.assertEqual(len(self.rows), 1215)
        by_path = Counter(row["condition"]["path"] for row in self.rows)
        self.assertEqual(by_path, Counter({path: 405 for path in PATHS}))
        by_path_analysis = Counter(
            (row["condition"]["path"], row["condition"]["analysis"])
            for row in self.rows
        )
        self.assertEqual(
            by_path_analysis,
            Counter(
                {
                    (path, analysis): count
                    for path in PATHS
                    for analysis, count in ANALYSIS_COUNTS.items()
                }
            ),
        )

    def test_pvt_and_analysis_grids_are_exact(self) -> None:
        self.assertEqual(
            self.manifest["grid"]["corners"], ["tt", "ss", "ff", "sf", "fs"]
        )
        self.assertEqual(self.manifest["grid"]["vdd_v"], [1.62, 1.8, 1.98])
        self.assertEqual(self.manifest["grid"]["temperature_c"], [0, 27, 70])

        dc = [r for r in self.rows if r["condition"]["analysis"] == "photoreceptor_dc"]
        self.assertEqual(
            {r["condition"]["biases_a"]["PrBp"] for r in dc}, {1e-9, 100e-9}
        )
        self.assertEqual(
            {r["condition"]["biases_a"]["PrSFBp"] for r in dc}, {100e-12, 10e-9}
        )
        self.assertEqual(
            {r["condition"]["analysis_conditions"]["gmin_s"] for r in dc}, {1e-13}
        )

        comparator = [
            r for r in self.rows if r["condition"]["analysis"] == "comparator_dc"
        ]
        self.assertEqual(
            {r["condition"]["biases_a"]["OnBn"] for r in comparator}, {200e-9}
        )
        self.assertEqual(
            {r["condition"]["biases_a"]["OffBn"] for r in comparator}, {0.5e-9}
        )
        self.assertEqual(
            {r["condition"]["analysis_conditions"]["gmin_s"] for r in comparator},
            {1e-13},
        )

        ac = [r for r in self.rows if r["condition"]["analysis"] == "ac_gain"]
        self.assertEqual(
            {r["condition"]["biases_a"]["DiffBn"] for r in ac}, {1e-9, 10e-9}
        )
        self.assertEqual({r["condition"]["biases_a"]["PrSFBp"] for r in ac}, {10e-12})
        self.assertEqual(
            {r["condition"]["analysis_conditions"]["gmin_s"] for r in ac}, {1e-16}
        )
        self.assertEqual(
            {r["condition"]["analysis_conditions"]["added_load_f"] for r in ac}, {0.0}
        )

        reset = [
            r for r in self.rows if r["condition"]["analysis"] == "reset_transient"
        ]
        self.assertEqual(
            {r["condition"]["analysis_conditions"]["gmin_s"] for r in reset}, {1e-17}
        )
        self.assertEqual(
            {r["condition"]["analysis_conditions"]["iabstol_a"] for r in reset}, {1e-12}
        )
        self.assertEqual(
            {r["condition"]["analysis_conditions"]["chgtol_c"] for r in reset}, {1e-16}
        )
        self.assertEqual(
            {r["condition"]["analysis_conditions"]["trtol"] for r in reset}, {1}
        )
        self.assertEqual(
            {r["condition"]["stimulus"]["protocol_mode"] for r in reset},
            {"fixed_common_timeline_v1"},
        )

    def test_every_condition_is_explicit_and_optical_input_is_never_implicit(
        self,
    ) -> None:
        for row in self.rows:
            condition = row["condition"]
            self.assertEqual(set(condition), BASE_CONDITION_KEYS)
            self.assertIsInstance(condition["biases_a"], dict)
            self.assertIsInstance(condition["pin_forcing"], dict)
            self.assertIsInstance(condition["optical"], dict)
            self.assertIn("mode", condition["optical"])
            self.assertIn("photocurrent_a", condition["optical"])
            self.assertNotEqual(condition["optical"]["mode"], "implicit")
            self.assertIsInstance(condition["initial_state"], dict)
            self.assertIsInstance(condition["stimulus"], dict)
            self.assertIsInstance(condition["analysis_conditions"], dict)

    def test_result_axes_are_independent_and_exact(self) -> None:
        for row in self.rows:
            self.assertEqual(set(row["result"]), RESULT_AXES)
            self.assertIn(
                row["result"]["execution_validity"], {"pending", "pass", "fail"}
            )
            self.assertIn(
                row["result"]["scientific_validity"],
                {"pending", "valid", "invalid", "blocked_at_protocol"},
            )
            self.assertIn(
                row["result"]["spec_result"], {"not_evaluated", "pass", "fail"}
            )
            self.assertIn(
                row["result"]["comparison"],
                {"not_evaluated", "diagnostic", "comparable", "not_comparable"},
            )

    def test_automatic_read_is_blocked_without_blocking_other_analyses(self) -> None:
        automatic = [
            r for r in self.rows if r["condition"]["analysis"] == "automatic_read"
        ]
        other = [r for r in self.rows if r["condition"]["analysis"] != "automatic_read"]
        self.assertEqual(len(automatic), 135)
        self.assertTrue(all(not r["execution"]["eligible"] for r in automatic))
        self.assertTrue(
            all(
                r["result"]["scientific_validity"] == "blocked_at_protocol"
                for r in automatic
            )
        )
        self.assertTrue(all(r["execution"]["eligible"] for r in other))
        self.assertEqual(len(other), 1080)

    def test_only_exact_quantus_nominal_ac_evidence_is_reused(self) -> None:
        reused = [r for r in self.rows if r["execution"]["state"] == "complete_reused"]
        self.assertEqual(len(reused), 1)
        self.assertEqual(
            {r["condition"]["path"] for r in reused},
            {"quantus_rcc_spectre"},
        )
        for row in reused:
            condition = row["condition"]
            self.assertEqual(condition["analysis"], "ac_gain")
            self.assertEqual(condition["corner"], "tt")
            self.assertEqual(condition["vdd_v"], 1.8)
            self.assertEqual(condition["temperature_c"], 27)
            self.assertEqual(condition["biases_a"]["DiffBn"], 1e-9)
            self.assertEqual(condition["biases_a"]["PrSFBp"], 10e-12)
            self.assertEqual(row["result"]["execution_validity"], "pass")
            self.assertEqual(row["result"]["scientific_validity"], "valid")
            self.assertIn("evidence_sha256", row["execution"])

    def test_row_ids_are_unique_stable_and_source_hashes_are_frozen(self) -> None:
        ids = [row["row_id"] for row in self.rows]
        self.assertEqual(len(ids), len(set(ids)))
        rebuilt = campaign_manifest.build_manifest()
        self.assertEqual(ids, [row["row_id"] for row in rebuilt["rows"]])
        self.assertEqual(
            self.manifest["sources"]["quantus_rcc_spectre"]["sha256"],
            "8cca5a0fd443a85d532acd52d3c5bf4fb3507782e48252e2decbf0d3d0f0ceb6",
        )
        self.assertEqual(
            self.manifest["sources"]["magic_rcc_ngspice"]["sha256"],
            "e016ed5834155460c0a743b450d398080a850f3221c3a631583ae30a56452775",
        )
        self.assertEqual(
            self.manifest["sources"]["schematic_ngspice"]["sha256"],
            "6453d01af285ebb688036192a8e527087b1cd066e3f3d43b2de94a8e44e1e3a2",
        )
        self.assertFalse(self.manifest["scope"]["confirmation_data_accessed"])
        self.assertFalse(self.manifest["scope"]["confirmation_data_authorized"])

    def test_validator_accepts_generated_manifest(self) -> None:
        campaign_manifest.validate_manifest(self.manifest)

    def test_validator_rejects_duplicate_and_implicit_optical_condition(self) -> None:
        duplicate = copy.deepcopy(self.manifest)
        duplicate["rows"][1]["row_id"] = duplicate["rows"][0]["row_id"]
        with self.assertRaisesRegex(ValueError, "duplicate row_id"):
            campaign_manifest.validate_manifest(duplicate)

        implicit = copy.deepcopy(self.manifest)
        implicit["rows"][0]["condition"]["optical"].pop("photocurrent_a")
        with self.assertRaisesRegex(ValueError, "photocurrent_a"):
            campaign_manifest.validate_manifest(implicit)

    def test_json_round_trip_is_lossless(self) -> None:
        encoded = json.dumps(self.manifest, sort_keys=True, separators=(",", ":"))
        decoded = json.loads(encoded)
        self.assertEqual(decoded, self.manifest)


if __name__ == "__main__":
    unittest.main()
