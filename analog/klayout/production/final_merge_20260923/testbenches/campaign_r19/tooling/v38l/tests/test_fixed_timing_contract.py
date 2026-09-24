from __future__ import annotations

import importlib.util
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


manifest_module = load_module("fixed_timing_manifest", ROOT / "campaign_manifest.py")
reset = load_module("fixed_timing_runner", ROOT / "reset_campaign.py")

SOURCES = {
    "quantus_netlist": "/campaign/sources/openDVS_pixel2x2_quantus_rcc_spectre.spice",
    "native_model_adapter": "/campaign/sources/native_call_alias_adapter.spice",
    "native_model_library": "/home/rpgraca/sky130/models/sky130.lib.spice",
    "magic_netlist": "/campaign/sources/openDVS_pixel2x2_rcc_diffbn_virtual_ngspice.spice",
    "magic_reset_netlist": "/campaign/sources/openDVS_pixel2x2_rcc_diffbn_virtual_ngspice.reset_physical_pd_v2.spice",
    "schematic_netlist": "/campaign/sources/openDVS_pixel2x2.schematic.spice",
    "schematic_reset_netlist": "/campaign/sources/openDVS_pixel2x2.schematic.reset_physical_pd_v2.spice",
    "ngspice_model_library": "/usr/local/share/pdk/sky130B/libs.tech/combined/sky130.lib.spice",
    "ngspice_nonfet_corner_ff": "/usr/local/share/pdk/sky130B/libs.tech/ngspice/corners/ff/nonfet.spice",
    "ngspice_nonfet_corner_fs": "/usr/local/share/pdk/sky130B/libs.tech/ngspice/corners/fs/nonfet.spice",
    "ngspice_nonfet_corner_sf": "/usr/local/share/pdk/sky130B/libs.tech/ngspice/corners/sf/nonfet.spice",
    "ngspice_nonfet_corner_ss": "/usr/local/share/pdk/sky130B/libs.tech/ngspice/corners/ss/nonfet.spice",
    "ngspice_nonfet_corner_tt": "/usr/local/share/pdk/sky130B/libs.tech/ngspice/corners/tt/nonfet.spice",
    "ngspice_parasitic_diode_model": "/usr/local/share/pdk/sky130B/libs.tech/ngspice/parasitics/sky130_fd_pr__model__parasitic__diode_ps2dn.model.spice",
    "ngspice_binary": "/usr/local/bin/ngspice",
    "cadence_launcher": "/campaign/toolchain/run_in_cadence.sh",
}

EXPECTED_TIMELINE = [
    {"time_s": 0.0, "level_fraction_vdd": 1.0},
    {"time_s": 0.001, "level_fraction_vdd": 1.0},
    {"time_s": 0.00100001, "level_fraction_vdd": 0.0},
    {"time_s": 45.0, "level_fraction_vdd": 0.0},
    {"time_s": 45.00000001, "level_fraction_vdd": 1.0},
    {"time_s": 45.001, "level_fraction_vdd": 1.0},
    {"time_s": 45.00100001, "level_fraction_vdd": 0.0},
    {"time_s": 45.5, "level_fraction_vdd": 0.0},
]


class FixedTimingContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.manifest = manifest_module.build_manifest()
        cls.rows = [
            row
            for row in cls.manifest["rows"]
            if row["condition"]["analysis"] == "reset_transient"
        ]

    def representative(self, path: str) -> dict:
        return next(
            row
            for row in self.rows
            if row["condition"]["path"] == path
            and row["condition"]["corner"] == "tt"
            and row["condition"]["vdd_v"] == 1.8
            and row["condition"]["temperature_c"] == 27
        )

    def test_every_reset_row_has_one_common_absolute_timeline(self) -> None:
        self.assertEqual(len(self.rows), 135)
        stimuli = [row["condition"]["stimulus"] for row in self.rows]
        self.assertTrue(all(item == stimuli[0] for item in stimuli))
        self.assertEqual(stimuli[0]["protocol_mode"], "fixed_common_timeline_v1")
        self.assertEqual(stimuli[0]["stop_s"], 45.5)
        self.assertEqual(stimuli[0]["event_trigger"], "none")
        self.assertEqual(stimuli[0]["timeline"], EXPECTED_TIMELINE)
        self.assertEqual(
            self.manifest["protocol"]["reset_transient"]["timeline"],
            EXPECTED_TIMELINE,
        )

    def test_all_paths_render_the_same_ten_nanosecond_pwl_schedule(self) -> None:
        expected_fractions = [
            (point["time_s"], point["level_fraction_vdd"])
            for point in EXPECTED_TIMELINE
        ]
        rendered_sources = []
        for path in self.manifest["paths"]:
            row = self.representative(path)
            condition = row["condition"]
            self.assertEqual(reset._fixed_reset_timeline(condition), expected_fractions)
            rendered_sources.append(reset._render_fixed_reset_source(condition))
            deck = reset.build_discovery_deck(row, SOURCES)
            self.assertIn("FIXED_RESET_TIMELINE", deck)
            self.assertIn("VresetController", deck)
            self.assertIn("PWL", deck.upper())
            self.assertNotIn("stop when", deck.lower())
            self.assertNotIn("resume", deck.lower())
            self.assertNotIn("alter vresetcontroller", deck.lower())
            self.assertNotIn("on_thresh", deck.lower())
            self.assertNotIn("ahdl_include", deck.lower())
            self.assertNotIn("reset_controller.va", deck)
            reset.validate_deck(row, deck, SOURCES)
        self.assertEqual(len(set(rendered_sources)), 1)

    def test_fixed_schedule_is_independent_of_on_and_nrst(self) -> None:
        source = (ROOT / "reset_campaign.py").read_text(encoding="utf-8")
        fixed_renderer = source[
            source.index("def _render_fixed_reset_source") : source.index(
                "def _build_deck"
            )
        ]
        self.assertNotIn("onSense", fixed_renderer)
        self.assertNotIn("nrstSense", fixed_renderer)
        self.assertNotIn("cross(", fixed_renderer)


if __name__ == "__main__":
    unittest.main()
