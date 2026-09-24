from __future__ import annotations

import importlib.util
import json
import math
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


manifest_module = load_module("reset_campaign_manifest", ROOT / "campaign_manifest.py")
reset = load_module("reset_campaign", ROOT / "reset_campaign.py")

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
    "psf_binary": "/campaign/toolchain/psf",
}

SOURCE_MAP = ROOT / "source_map.rpgraca-ini.json"


class ResetCampaignTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.manifest = manifest_module.build_manifest()

    def representative(self, path: str) -> dict:
        for row in self.manifest["rows"]:
            condition = row["condition"]
            if (
                condition["path"] == path
                and condition["analysis"] == "reset_transient"
                and condition["corner"] == "tt"
                and condition["vdd_v"] == 1.8
                and condition["temperature_c"] == 27
            ):
                return row
        raise AssertionError(f"missing nominal reset row for {path}")

    def test_reset_grid_and_pilot_rungs_are_exact(self) -> None:
        rows = reset.reset_rows(self.manifest)
        self.assertEqual(len(rows), 135)
        self.assertEqual(
            {
                path: sum(row["condition"]["path"] == path for row in rows)
                for path in self.manifest["paths"]
            },
            {path: 45 for path in self.manifest["paths"]},
        )
        nominal = reset.select_pilot_rows(self.manifest, "nominal")
        extremes = reset.select_pilot_rows(self.manifest, "extremes")
        self.assertEqual(len(nominal), 3)
        self.assertEqual(len(extremes), 6)
        self.assertTrue(
            all(row["condition"]["analysis"] == "reset_transient" for row in rows)
        )

    def test_every_ngspice_deck_applies_registered_temperature(self) -> None:
        for row in reset.reset_rows(self.manifest):
            condition = row["condition"]
            if condition["path"] == "quantus_rcc_spectre":
                continue
            deck = reset.build_discovery_deck(row, SOURCES)
            self.assertEqual(
                deck.count(f".temp {reset._plain(condition['temperature_c'])}"),
                1,
            )
            reset.validate_deck(row, deck, SOURCES)

    def test_registered_reset_condition_is_complete(self) -> None:
        expected_biases = {
            "PrBp": 10e-9,
            "PrSFBp": 100e-12,
            "DiffBn": 10e-9,
            "OnBn": 70e-9,
            "OffBn": 1e-9,
            "RefrBp": 4e-9,
        }
        for path in self.manifest["paths"]:
            condition = self.representative(path)["condition"]
            self.assertEqual(condition["biases_a"], expected_biases)
            self.assertEqual(
                set(condition["optical"]["photocurrent_a"].values()), {1e-9}
            )
            self.assertEqual(condition["stimulus"]["stop_s"], 45.5)
            self.assertEqual(
                condition["stimulus"]["protocol_mode"],
                "fixed_common_timeline_v1",
            )
            self.assertEqual(condition["stimulus"]["event_trigger"], "none")
            self.assertEqual(
                condition["stimulus"]["cace_reference"],
                {
                    "configuration_sha256": "68f501f65eea943f0a85300669a6b066c735b4da228ab1ebe3ff4dd4aeea2338",
                    "postprocessor_sha256": "2ce2f3d1e94facbf69213d10ec68b15f19c418b32c6b549ea79e19ff42a92e6f",
                    "testbench_sha256": "91f7ab29b4d7fd108bd733c7b9a4ad962d748d50cda7a00593542401686e8ab5",
                },
            )
            self.assertEqual(
                condition["pin_forcing"]["pixRst[0]"],
                "fixed_timeline_driven",
            )
            self.assertEqual(
                condition["pin_forcing"]["rowReadON[0]"],
                "fixed_timeline_driven",
            )
            self.assertEqual(condition["pin_forcing"]["pixRst[1]"], "inactive_low")
            self.assertEqual(condition["pin_forcing"]["rowReadON[1]"], "inactive_low")
            self.assertEqual(condition["initial_state"]["pixRst[0]"], "high")
            self.assertEqual(condition["initial_state"]["rowReadON[0]"], "high")
            self.assertEqual(
                condition["analysis_conditions"]["coarse_settling_max_step_s"], 100e-6
            )
            self.assertEqual(
                condition["analysis_conditions"],
                {
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
                },
            )

    def test_discovery_decks_are_deterministic_and_path_correct(self) -> None:
        for path in self.manifest["paths"]:
            row = self.representative(path)
            first = reset.build_discovery_deck(row, SOURCES)
            second = reset.build_discovery_deck(row, SOURCES)
            self.assertEqual(first, second)
            reset.validate_deck(row, first, SOURCES, stage="discovery")
            instance = next(
                line
                for line in first.splitlines()
                if line.lower().startswith("xpix2x2 ")
            )
            self.assertEqual(
                instance.split()[1:9],
                ["0", "pixrst", "0", "pixrst", "0", "0", "0", "0"],
            )
            self.assertIn("45.5", first)
            self.assertIn("100u", first)
            self.assertNotIn("maxstep=1n", first)
            self.assertIn("FIXED_RESET_TIMELINE", first)
            self.assertIn("PWL", first.upper())
            self.assertNotIn("stop when", first.lower())
            self.assertNotIn("resume", first.lower())
            if path == "quantus_rcc_spectre":
                self.assertNotIn("ahdl_include", first)
                self.assertIn(
                    "saveOptions options save=allpub currents=none", first
                )
                self.assertNotIn(
                    "save VddA18 pixrst onSense nrstSense vdiffSense", first
                )
                self.assertIn(
                    "simulatorOptions options temp=27 reltol=0.0005 vabstol=1e-06 iabstol=1e-12 gmin=1e-17",
                    first,
                )
                self.assertIn("method=gear2only", first)
                self.assertIn("dcdampsol=yes", first)
                self.assertIn("Xpix2x2.xPix[0]/ON", first)
                self.assertIn("Xpix2x2.xPix[0]/nRst", first)
                self.assertIn("Xpix2x2.xPix[0]/vdiff", first)
                self.assertNotIn("xdiffbn_physical_core", first.lower())
            else:
                self.assertNotIn("dcdampsol", first.lower())
                self.assertIn(SOURCES["ngspice_nonfet_corner_tt"], first)
                self.assertIn(SOURCES[f"{path.split('_')[0]}_reset_netlist"], first)
                self.assertIn(SOURCES["ngspice_parasitic_diode_model"], first)
                self.assertNotIn("BresetController", first)
                if path == "magic_rcc_ngspice":
                    self.assertIn(
                        "xpix2x2.xdiffbn_physical_core.openDVS_pixel_0.ON",
                        first,
                    )
                    self.assertNotIn(
                        "xpix2x2.xdiffbn_physical_core.openDVS_pixel_3.ON",
                        first,
                    )

    def test_fixed_timeline_has_no_controller_source_and_commands_are_exact(
        self,
    ) -> None:
        self.assertEqual(
            reset.SOURCE_HASHES["ngspice_model_library"],
            "48de7c677e2c6e7d09b2559279de9f818be71010a4aa933d728eb4db3b133c84",
        )
        self.assertEqual(
            reset.SOURCE_HASHES["magic_reset_netlist"],
            "04283235bc8397d473af68f2f35c0a9232ea4ed5f003f22d7902c93881f3f5d8",
        )
        self.assertEqual(
            reset.SOURCE_HASHES["schematic_reset_netlist"],
            "60ed15ddfb05644d62e2c4569e995e136cec9ce8b7ff0b92cb646c42345c9e36",
        )
        self.assertEqual(
            reset.SOURCE_HASHES["ngspice_nonfet_corner_tt"],
            "9e442b3828f29c8cf0a4d030c37b913fae11a23b00b58a4622d8bdf6909b56dd",
        )
        source_map = json.loads(SOURCE_MAP.read_text(encoding="utf-8"))
        self.assertNotIn("reset_controller", source_map["sources"])
        resolved = reset._resolve_source_map(source_map, SOURCE_MAP)
        self.assertNotIn("reset_controller", resolved)
        for path in self.manifest["paths"]:
            row = self.representative(path)
            command = reset.simulator_command(row, Path("/run/reset"), SOURCES)
            if path == "quantus_rcc_spectre":
                self.assertEqual(command[0], SOURCES["cadence_launcher"])
                self.assertIn("/run/reset/input.scs", command)
                self.assertIn("psfbin", command)
                self.assertNotIn("psfascii", command)
                self.assertIn("+mt=1", command)
                metrics_command = reset.psf_metrics_command(
                    Path("/run/reset"), SOURCES, 300
                )
                self.assertEqual(metrics_command[0], SOURCES["cadence_launcher"])
                self.assertIn(SOURCES["psf_binary"], metrics_command)
                self.assertIn(
                    "/run/reset/raw_output/tran.tran.tran", metrics_command
                )
                self.assertIn(
                    "/run/reset/metrics_psfascii/tran.tran.tran",
                    metrics_command,
                )
                self.assertEqual(metrics_command.count("-t"), 6)
            else:
                self.assertEqual(command[0], SOURCES["ngspice_binary"])
                self.assertIn("/run/reset/input.deck", command)

    def test_edge_windows_are_derived_from_registered_contracts(self) -> None:
        row = self.representative("magic_rcc_ngspice")
        discovery = {
            "nrst_crossing_s": 0.001015,
            "second_reset_rise_s": 0.5002,
            "second_reset_fall_s": 0.5012,
        }
        windows = reset.edge_windows(row, discovery)
        self.assertEqual(len(windows), 3)
        self.assertAlmostEqual(windows[0][0], 0.000915)
        self.assertAlmostEqual(windows[0][1], 0.001115)
        self.assertAlmostEqual(windows[1][0], 0.5002 - 20e-9)
        self.assertAlmostEqual(windows[1][1], 0.5003)
        self.assertAlmostEqual(windows[2][0], 0.5012 - 20e-9)
        self.assertAlmostEqual(windows[2][1], 0.5012 + 20e-9)
        self.assertTrue(any(start <= 1e-3 <= end for start, end in windows))

    def test_edge_grid_and_timestamp_validation_fail_closed(self) -> None:
        windows = [(1.0, 1.0 + 4e-9), (2.0, 2.0 + 3e-9)]
        grid = reset.edge_grid_times(windows, 1e-9)
        self.assertEqual(grid[0], windows[0][0])
        self.assertEqual(grid[-1], windows[-1][1])
        reset.validate_edge_spacing(grid, windows, 1e-9)
        with self.assertRaises(ValueError):
            reset.validate_edge_spacing(
                [1.0, 1.0 + 2e-9, 2.0, 2.0 + 3e-9], windows, 1e-9
            )
        with self.assertRaises(ValueError):
            reset.validate_edge_spacing([], windows, 1e-9)
        with self.assertRaises(ValueError):
            reset.validate_edge_spacing(
                [1.0, 1.0 + 100e-6], [(1.0, 1.0 + 100e-6)], 1e-9
            )

        late = [(45.0 - 20e-9, 45.0 + 20e-9)]
        late_grid = reset.edge_grid_times(late, 1e-9)
        reset.validate_edge_spacing(late_grid, late, 1e-9)

    def test_rendered_edge_grid_is_isolated_and_attempts_never_overwrite(self) -> None:
        windows = [(1.0, 1.0 + 4e-9)]
        for path in self.manifest["paths"]:
            grid = reset.render_edge_grid(path, windows, 1e-9)
            self.assertIn("edge_grid", grid.lower())
            self.assertIn("Vedge_grid edge_grid 0", grid)
            self.assertNotIn("edge_grid_return", grid.lower())
            self.assertLess(max(map(len, grid.splitlines())), 4096)
            for forbidden in ("vdd", "pixrst", "vdiff", "nrst", "onbn", "offbn"):
                self.assertNotIn(forbidden, grid.lower())

        with tempfile.TemporaryDirectory() as temporary:
            base = Path(temporary) / "row"
            self.assertEqual(reset._next_attempt(base).name, "attempt-1")
            (base / "attempt-1").mkdir(parents=True)
            self.assertEqual(reset._next_attempt(base).name, "attempt-2")

    def test_exact_cace_protocol_prohibits_replay_instrumentation(self) -> None:
        discovery = {
            "nrst_crossing_s": 0.001015,
            "second_reset_rise_s": 0.5002,
            "second_reset_fall_s": 0.5012,
        }
        for path in self.manifest["paths"]:
            row = self.representative(path)
            with self.assertRaises(ValueError):
                reset.build_replay_deck(row, SOURCES, discovery, "edge_grid.inc")

    def test_six_registered_reset_metrics_use_interpolated_crossings(self) -> None:
        times = [
            0.0,
            0.0009,
            0.001,
            0.0011,
            0.0012,
            0.0013,
            0.0099,
            0.0100,
            0.010025,
            0.01005,
            0.010075,
            0.0101,
            0.011,
            0.011001,
        ]
        traces = {
            "vdd": [1.8] * len(times),
            "nrst": [0, 0, 0, 0.8, 1.62, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8],
            "on": [0, 0, 0, 0, 0, 0, 0, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8],
            "pixrst": [1.8, 1.8, 1.8, 0, 0, 0, 0, 0, 1.8, 1.8, 1.8, 1.8, 1.8, 0],
            "vdiff": [
                0.9,
                0.9,
                0.9,
                0.92,
                1.0,
                1.0,
                0.9,
                0.9,
                0.94,
                0.98,
                1.0,
                1.0,
                1.0,
                1.0,
            ],
        }
        metrics = reset.compute_reset_metrics(times, traces)
        self.assertEqual(
            set(metrics),
            {
                "refractory_period",
                "delta_vdiff_ci",
                "leak_event_period",
                "min_reset_time",
                "vdiff_before_ci",
                "vdiff_after_ci",
            },
        )
        self.assertAlmostEqual(metrics["refractory_period"], 0.0002)
        expected = {
            "refractory_period": 0.0002,
            "delta_vdiff_ci": 0.1,
            "leak_event_period": 0.00875,
            "min_reset_time": 0.0000625,
            "vdiff_before_ci": 0.9,
            "vdiff_after_ci": 1.0,
        }
        self.assertTrue(all(math.isfinite(value) for value in metrics.values()))
        for name, value in expected.items():
            self.assertAlmostEqual(metrics[name], value)

    def test_parsers_accept_named_psf_and_ngspice_ascii_fixtures(self) -> None:
        psf = """VALUE
\"time\" 0
\"VddA18\" 1.8
\"pixrst\" 1.8
\"onSense\" 0
\"nrstSense\" 0
\"vdiffSense\" 0.9
\"time\" 51
\"VddA18\" 1.8
\"pixrst\" 0
\"onSense\" 1.8
\"nrstSense\" 1.8
\"vdiffSense\" 1.0
"""
        psf_times, psf_traces = reset.parse_psfascii(psf)
        self.assertEqual(psf_times, [0.0, 51.0])
        self.assertEqual(psf_traces["vdiff"], [0.9, 1.0])

        ng = """Title: reset
No. Variables: 6
No. Points: 2
Variables:
  0 time time
  1 v(VddA18) voltage
  2 v(pixrst) voltage
  3 v(onSense) voltage
  4 v(nrstSense) voltage
  5 v(vdiffSense) voltage
Values:
0 0
  1.8
  1.8
  0
  0
  0.9
1 51
  1.8
  0
  1.8
  1.8
  1.0
"""
        ng_times, ng_traces = reset.parse_ngspice_ascii(ng)
        self.assertEqual(ng_times, [0.0, 51.0])
        self.assertEqual(ng_traces["on"], [0.0, 1.8])

    def test_parsers_reject_ambiguous_or_duplicate_trace_aliases(self) -> None:
        self.assertIsNone(reset._normalise_trace_name("xpix2x2.pixel.on"))
        self.assertIsNone(reset._normalise_trace_name("unrelated_nrst"))
        duplicate_psf = """VALUE
"time" 0
"VddA18" 1.8
"pixrst" 1.8
"onSense" 0
"onSense" 1
"nrstSense" 0
"vdiffSense" 0.9
"""
        with self.assertRaisesRegex(ValueError, "duplicate canonical trace"):
            reset.parse_psfascii(duplicate_psf)
        duplicate_ngspice = """Variables:
0 time time
1 v(VddA18) voltage
2 v(pixrst) voltage
3 v(onSense) voltage
4 v(onSense) voltage
5 v(nrstSense) voltage
6 v(vdiffSense) voltage
Values:
0 0 1.8 1.8 0 1 0 0.9
"""
        with self.assertRaisesRegex(ValueError, "duplicate canonical trace"):
            reset.parse_ngspice_ascii(duplicate_ngspice)

    def test_psf_directory_selects_transient_payload_not_metadata_log(self) -> None:
        payload = """SWEEP
"time" "sweep" PROP(
)
TRACE
"VddA18" "VddA18"
VALUE
"time" 0
"VddA18" 1.8
"pixrst" 1.8
"onSense" 0
"nrstSense" 0
"vdiffSense" 0.9
"""
        with tempfile.TemporaryDirectory() as temporary:
            raw = Path(temporary)
            (raw / "logFile").write_text('VALUE\n"time" "sweep" PROP(\n')
            (raw / "tran.tran.tran").write_text(payload)
            times, traces = reset.parse_psfascii(raw)
        self.assertEqual(times, [0.0])
        self.assertEqual(traces["vdd"], [1.8])

    def test_missing_fixed_reset_edges_fail_protocol_discovery(self) -> None:
        row = self.representative("magic_rcc_ngspice")
        times = [0.0, 45.5]
        traces = {
            "vdd": [1.8, 1.8],
            "pixrst": [1.8, 0.0],
            "on": [0.0, 0.0],
            "nrst": [0.0, 1.8],
            "vdiff": [0.9, 0.9],
        }
        result = reset._classify_discovery(row, 0, "completed", times, traces)
        self.assertEqual(result["execution_validity"], "fail")
        self.assertEqual(result["scientific_validity"], "pending")

    def test_discovery_preserves_on_before_nrst_as_a_scientific_result(self) -> None:
        row = self.representative("magic_rcc_ngspice")
        times = [
            0.0,
            0.0009,
            0.001,
            0.00100001,
            0.00101,
            0.00102,
            0.00103,
            45.0,
            45.00000001,
            45.001,
            45.00100001,
            45.5,
        ]
        traces = {
            "vdd": [1.8] * len(times),
            "pixrst": [1.8, 1.8, 1.8, 0.0, 0.0, 0.0, 0.0, 0.0, 1.8, 1.8, 0.0, 0.0],
            "on": [0.0, 0.0, 0.0, 0.0, 0.0, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8],
            "nrst": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8],
            "vdiff": [0.9] * len(times),
        }
        result = reset._classify_discovery(row, 0, "completed", times, traces)
        self.assertEqual(result["execution_validity"], "pass")
        self.assertEqual(result["scientific_validity"], "valid")
        self.assertLess(
            result["discovery"]["on_90_crossing_s"],
            result["discovery"]["nrst_crossing_s"],
        )
        self.assertGreater(
            result["discovery"]["second_reset_rise_s"],
            result["discovery"]["nrst_crossing_s"],
        )
        self.assertEqual(
            result["event_evidence"]["leak_event_period"]["status"],
            "event_precedes_reference",
        )

    def test_discovery_requires_the_fixed_common_endpoint(self) -> None:
        row = self.representative("schematic_ngspice")
        times = [
            0.0,
            0.001,
            0.00100001,
            45.0,
            45.00000001,
            45.001,
            45.00100001,
            45.2,
        ]
        traces = {
            "vdd": [1.8] * len(times),
            "pixrst": [1.8, 1.8, 0.0, 0.0, 1.8, 1.8, 0.0, 0.0],
            "on": [0.0] * len(times),
            "nrst": [0.0, 0.0, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8],
            "vdiff": [0.9] * len(times),
        }
        result = reset._classify_discovery(row, 0, "completed", times, traces)
        self.assertEqual(result["execution_validity"], "fail")
        self.assertIn("45.5 s stop", result["errors"][0])

    def test_fixed_schedule_has_common_endpoint_without_event_feedback(self) -> None:
        row = self.representative("schematic_ngspice")
        times = [
            0.0,
            0.001,
            0.00100001,
            0.00101,
            45.0,
            45.00000001,
            45.001,
            45.00100001,
            45.5,
        ]
        traces = {
            "vdd": [1.8] * len(times),
            "pixrst": [1.8, 1.8, 0.0, 0.0, 0.0, 1.8, 1.8, 0.0, 0.0],
            "on": [0.0] * len(times),
            "nrst": [0.0, 0.0, 0.0, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8],
            "vdiff": [0.9] * len(times),
        }
        result = reset._classify_discovery(row, 0, "completed", times, traces)
        self.assertEqual(result["execution_validity"], "pass")
        self.assertEqual(result["scientific_validity"], "valid")
        self.assertEqual(result["spec_result"], "fail")
        self.assertEqual(
            result["event_evidence"]["stimulus_control"],
            "fixed_common_timeline",
        )
        self.assertEqual(result["event_evidence"]["event_trigger"], "none")
        leak = result["event_evidence"]["leak_event_period"]
        self.assertEqual(leak["status"], "right_censored")
        self.assertEqual(leak["cace_scalar_s"], 0.0)
        self.assertGreater(leak["lower_bound_s"], 40.0)

    def test_registered_stop_allows_one_nanosecond_coordinate_roundoff(self) -> None:
        reset._validate_registered_stop([0.0, 51.0 + 0.2e-9], 51.0)

    def test_ngspice_reset_decks_pin_the_registered_gear_solver(self) -> None:
        for path in ("magic_rcc_ngspice", "schematic_ngspice"):
            deck = reset.build_discovery_deck(self.representative(path), SOURCES)
            self.assertIn("method=gear", deck.lower())
            self.assertIn("maxord=2", deck.lower())
            self.assertIn("gmin=1e-17", deck.lower())
            self.assertIn("abstol=1p", deck.lower())
            self.assertIn("chgtol=1e-16", deck.lower())
            self.assertIn("trtol=1", deck.lower())
            self.assertIn("itl1=1000 itl2=500 itl4=100", deck.lower())
            self.assertIn("gminsteps=500 srcsteps=500", deck.lower())
            self.assertIn("ramptime=100n", deck.lower())

    def test_exact_cace_ngspice_apparatus_is_explicit_and_path_bound(self) -> None:
        source_map = json.loads(SOURCE_MAP.read_text(encoding="utf-8"))["sources"]
        self.assertIn("magic_reset_netlist", source_map)
        self.assertIn("schematic_reset_netlist", source_map)

        magic = reset.build_discovery_deck(
            self.representative("magic_rcc_ngspice"), SOURCES
        )
        self.assertIn(SOURCES["magic_reset_netlist"], magic)
        self.assertNotIn(f".include {SOURCES['magic_netlist']}", magic)
        self.assertIn(SOURCES["ngspice_parasitic_diode_model"], magic)
        self.assertNotIn("R_cace_pd_", magic)
        self.assertNotIn("R_cace_vdstab", magic)
        self.assertNotIn(".nodeset", magic.lower())
        magic_extremes = [
            row
            for row in reset.select_pilot_rows(self.manifest, "extremes")
            if row["condition"]["path"] == "magic_rcc_ngspice"
        ]
        for row in magic_extremes:
            deck = reset.build_discovery_deck(row, SOURCES)
            self.assertNotIn("MAGIC_NODESET_WITNESS_SHA256", deck)
            self.assertNotIn(".nodeset", deck.lower())
            reset.validate_deck(row, deck, SOURCES)

        schematic = reset.build_discovery_deck(
            self.representative("schematic_ngspice"), SOURCES
        )
        self.assertIn(SOURCES["schematic_reset_netlist"], schematic)
        self.assertNotIn(f".include {SOURCES['schematic_netlist']}", schematic)
        self.assertIn(SOURCES["ngspice_parasitic_diode_model"], schematic)
        self.assertNotIn("R_cace_pd_", schematic)
        self.assertNotIn("R_cace_vdstab", schematic)
        self.assertNotIn(".nodeset", schematic.lower())

    def test_stale_magic_extreme_witnesses_are_excluded(self) -> None:
        self.assertEqual(reset._MAGIC_EXTREME_NODESET_WITNESSES, {})

    def test_frozen_cace_metric_fallbacks_find_no_missing_events(self) -> None:
        times = [0.0, 0.0009, 0.001, 0.002, 0.5]
        traces = {
            "vdd": [1.8] * len(times),
            "pixrst": [1.8, 1.8, 0.0, 0.0, 0.0],
            "on": [0.0] * len(times),
            "nrst": [0.0] * len(times),
            "vdiff": [0.9] * len(times),
        }
        metrics = reset.compute_cace_reset_metrics(times, traces)
        self.assertEqual(metrics["refractory_period"], 0.0)
        self.assertEqual(metrics["leak_event_period"], 0.0)
        self.assertEqual(reset.evaluate_reset_spec(metrics), "fail")

    def test_event_evidence_distinguishes_a_measured_on_crossing(self) -> None:
        times = [0.0, 0.001, 0.00101, 0.01, 0.011, 0.012, 0.013, 0.513]
        traces = {
            "vdd": [1.8] * len(times),
            "pixrst": [1.8, 1.8, 0.0, 0.0, 0.0, 1.8, 0.0, 0.0],
            "on": [0.0, 0.0, 0.0, 0.0, 1.8, 1.8, 0.0, 0.0],
            "nrst": [0.0, 0.0, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8],
            "vdiff": [0.9] * len(times),
        }
        evidence = reset.describe_exact_cace_event_evidence(times, traces)
        self.assertEqual(evidence["controller_outcome"], "on_threshold_crossing")
        leak = evidence["leak_event_period"]
        self.assertEqual(leak["status"], "measured")
        self.assertGreater(leak["cace_scalar_s"], 0.0)

    def test_crossing_after_nrst_in_a_straddling_segment_is_measured_consistently(
        self,
    ) -> None:
        times = [
            0.0,
            0.0009,
            0.001,
            0.0018,
            0.002,
            0.00205,
            0.003,
            0.004,
            0.00425,
            0.0045,
            0.005,
        ]
        traces = {
            "vdd": [1.8] * len(times),
            "pixrst": [1.8, 1.8, 1.8, 0.0, 0.0, 0.0, 0.0, 0.0, 1.8, 1.8, 0.0],
            "on": [0.0, 0.0, 0.0, 0.0, 0.95, 1.8, 1.8, 1.8, 1.8, 1.8, 0.0],
            "nrst": [0.0, 0.0, 0.0, 0.0, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8],
            "vdiff": [0.9] * len(times),
        }
        strict_metrics = reset.compute_reset_metrics(times, traces)
        cace_metrics = reset.compute_cace_reset_metrics(times, traces)
        evidence = reset.describe_exact_cace_event_evidence(times, traces)
        leak = evidence["leak_event_period"]
        self.assertEqual(leak["status"], "measured")
        self.assertGreater(strict_metrics["leak_event_period"], 0.0)
        self.assertAlmostEqual(
            strict_metrics["leak_event_period"], cace_metrics["leak_event_period"]
        )
        self.assertAlmostEqual(cace_metrics["leak_event_period"], leak["cace_scalar_s"])

    def test_fixed_timeline_classification_preserves_missing_nrst_as_a_result(
        self,
    ) -> None:
        row = self.representative("magic_rcc_ngspice")
        times = [
            0.0,
            0.001,
            0.00100001,
            0.00102,
            45.0,
            45.00000001,
            45.001,
            45.00100001,
            45.5,
        ]
        traces = {
            "vdd": [1.8] * len(times),
            "pixrst": [1.8, 1.8, 0.0, 0.0, 0.0, 1.8, 1.8, 0.0, 0.0],
            "on": [0.0, 0.0, 0.0, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8],
            "nrst": [0.0] * len(times),
            "vdiff": [0.9] * len(times),
        }
        result = reset._classify_discovery(row, 0, "completed", times, traces)
        self.assertEqual(result["execution_validity"], "pass")
        self.assertEqual(result["scientific_validity"], "valid")
        self.assertIsNone(result["discovery"]["nrst_crossing_s"])
        self.assertEqual(result["metrics"]["refractory_period"], 0.0)
        self.assertEqual(result["spec_result"], "fail")
        self.assertEqual(
            result["event_evidence"]["leak_event_period"]["status"],
            "missing_reference_crossing",
        )

    def test_ngspice_uses_one_uninterrupted_fixed_timeline_transient(self) -> None:
        for path in ("magic_rcc_ngspice", "schematic_ngspice"):
            deck = reset.build_discovery_deck(self.representative(path), SOURCES)
            self.assertIn(".tran 100u 45.5", deck)
            self.assertIn("VresetController pixrst 0 PWL(", deck)
            self.assertIn("run", deck)
            self.assertIn("write raw_output.raw", deck)
            for forbidden in (
                "stop when",
                "resume",
                "alter VresetController",
                "on_thresh",
                "t_on_event",
            ):
                self.assertNotIn(forbidden.lower(), deck.lower())

    def test_campaign_metadata_is_write_once_or_byte_equivalent(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            path = Path(temporary) / "campaign.json"
            reset._write_once_or_equal_json(path, {"campaign": "one"})
            reset._write_once_or_equal_json(path, {"campaign": "one"})
            with self.assertRaises(ValueError):
                reset._write_once_or_equal_json(path, {"campaign": "two"})

    def test_prepare_writes_and_binds_the_frozen_ngspice_startup(self) -> None:
        row = self.representative("magic_rcc_ngspice")
        deck = reset.build_discovery_deck(row, SOURCES)
        source_hashes = {"fixture": "0" * 64}
        fingerprint = reset._deck_fingerprint(
            deck, source_hashes, reset._ngspice_startup_text()
        )
        with tempfile.TemporaryDirectory() as temporary:
            result = reset._run_attempt(
                row,
                SOURCES,
                source_hashes,
                Path(temporary) / "row",
                deck,
                "discovery",
                fingerprint,
                True,
                None,
            )
            attempt = Path(result["directory"])
            startup = (attempt / ".spiceinit").read_text(encoding="utf-8")
            self.assertEqual(startup, reset._ngspice_startup_text())
            self.assertIn("set ngbehavior=hsa", startup)
            self.assertIn("set num_threads=1", startup)
            self.assertIn("option noinit", startup)
            self.assertIn("SPARSE 1.3", startup)
            self.assertNotIn("option klu", startup)

    def test_existing_pass_rejects_unbound_and_accepts_verified_reclassification(
        self,
    ) -> None:
        row = self.representative("magic_rcc_ngspice")
        source_hashes = {"fixture": "0" * 64}
        with tempfile.TemporaryDirectory() as temporary:
            base = Path(temporary)
            attempt = base / "attempt-1"
            attempt.mkdir()
            raw = attempt / "raw_output.raw"
            raw.write_bytes(b"preserved raw")
            raw_sha256 = reset._raw_sha256(raw)
            input_path = attempt / "input.deck"
            input_path.write_text("registered deck\n")
            deck_sha256 = reset._sha256_file(input_path)
            log_path = attempt / "simulator.log"
            log_path.write_text("clean simulator completion\n")
            log_sha256 = reset._sha256_file(log_path)
            original = {
                "row_id": row["row_id"],
                "condition": row["condition"],
                "fingerprint": "same-deck",
                "stage": "discovery",
                "deck_sha256": deck_sha256,
                "source_hashes": source_hashes,
                "raw_sha256": raw_sha256,
                "execution_validity": "fail",
                "scientific_validity": "pending",
            }
            result_path = attempt / "result.json"
            result_path.write_text(json.dumps(original, sort_keys=True) + "\n")
            (attempt / "fingerprint.json").write_text(
                json.dumps(
                    {
                        "fingerprint": "same-deck",
                        "deck_sha256": deck_sha256,
                        "source_fingerprint": reset._source_fingerprint(source_hashes),
                        "source_hashes": source_hashes,
                        "stage": "discovery",
                    },
                    sort_keys=True,
                )
                + "\n"
            )
            record_path = base / "reclassification-attempt-1-classifier.json"
            unbound = {
                "fingerprint": "same-deck",
                "stage": "discovery",
                "execution_validity": "pass",
                "scientific_validity": "valid",
                "reclassified_from": str(attempt),
            }
            record_path.write_text(json.dumps(unbound))
            self.assertIsNone(
                reset._existing_pass(base, "same-deck", "discovery", row, source_hashes)
            )
            verified = dict(original)
            verified.update(
                {
                    "execution_validity": "pass",
                    "scientific_validity": "valid",
                    "reclassified_from": str(attempt),
                    "directory": str(attempt),
                    "reclassified_result_sha256": reset._sha256_file(result_path),
                    "classifier_sha256": reset._sha256_file(
                        Path(reset.__file__).resolve()
                    ),
                    "source_fingerprint": reset._source_fingerprint(source_hashes),
                    "simulator_log_sha256": log_sha256,
                }
            )
            record_path.write_text(json.dumps(verified, sort_keys=True) + "\n")
            found = reset._existing_pass(
                base, "same-deck", "discovery", row, source_hashes
            )
            self.assertIsNotNone(found)
            self.assertEqual(found[0], attempt)
            self.assertEqual(found[1]["scientific_validity"], "valid")

            log_path.write_text("mutated warning-bearing simulator log\n")
            self.assertIsNone(
                reset._existing_pass(base, "same-deck", "discovery", row, source_hashes)
            )
            log_path.write_text("clean simulator completion\n")

            outside = base.parent / (base.name + "-attempt-outside")
            verified["reclassified_from"] = str(outside)
            record_path.write_text(json.dumps(verified, sort_keys=True) + "\n")
            self.assertIsNone(
                reset._existing_pass(base, "same-deck", "discovery", row, source_hashes)
            )

    def test_registered_adapted_sources_are_rederived_from_checked_bases(self) -> None:
        magic_base = """.subckt openDVS_pixel2x2__diffbn_physical_core a GndA
D0 GndA vpd[0] sky130_fd_pr__model__parasitic__diode_ps2dn area=32.49 pj=22.8 m=1
D1 GndA vpd[1] sky130_fd_pr__model__parasitic__diode_ps2dn area=32.49 pj=22.8 m=1
D2 GndA vpd[2] sky130_fd_pr__model__parasitic__diode_ps2dn area=32.49 pj=22.8 m=1
D3 GndA vpd[3] sky130_fd_pr__model__parasitic__diode_ps2dn area=32.49 pj=22.8 m=1
C0 openDVS_pixel_0.vd GndA 1f
C1 openDVS_pixel_1.vd GndA 1f
C2 openDVS_pixel_2.vd GndA 1f
C3 openDVS_pixel_3.vd GndA 1f
.ends
"""
        # This helper is tested against the full hierarchy by the derivation
        # module tests; here it checks runtime lineage verification itself.
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            base = root / "magic.spice"
            adapted = root / "magic.reset.spice"
            base.write_text(magic_base)
            base_sha256 = reset._sha256_file(base)
            adapted.write_bytes(
                reset._DERIVE.derive(
                    "magic_rcc_ngspice", base.read_bytes(), base_sha256
                )
            )
            sources = {"magic_netlist": str(base), "magic_reset_netlist": str(adapted)}
            hashes = {
                "magic_netlist": base_sha256,
                "magic_reset_netlist": reset._sha256_file(adapted),
            }
            reset._verify_derived_ngspice_sources(
                sources, hashes, paths=("magic_rcc_ngspice",)
            )
            adapted.write_text(
                adapted.read_text().replace("RESET_BASE_SHA256", "BROKEN_BASE_SHA256")
            )
            hashes["magic_reset_netlist"] = reset._sha256_file(adapted)
            with self.assertRaisesRegex(
                ValueError, "does not match deterministic derivation"
            ):
                reset._verify_derived_ngspice_sources(
                    sources, hashes, paths=("magic_rcc_ngspice",)
                )

    def test_extremes_require_matching_nominal_admission(self) -> None:
        nominal = reset.select_pilot_rows(self.manifest, "nominal")
        row_ids = [row["row_id"] for row in nominal]
        with tempfile.TemporaryDirectory() as temporary:
            output = Path(temporary)
            with self.assertRaises(ValueError):
                reset._require_nominal_admission(
                    output, "manifest-hash", "source-fingerprint", row_ids
                )
            (output / "nominal_admission.json").write_text(
                json.dumps(
                    {
                        "manifest_sha256": "manifest-hash",
                        "source_fingerprint": "source-fingerprint",
                        "row_ids": row_ids,
                        "execution_validity": "pass",
                        "scientific_validity": "valid",
                        "fixed_timeline_simulation_health": "pass",
                    },
                    sort_keys=True,
                )
                + "\n",
                encoding="utf-8",
            )
            binding = reset._require_nominal_admission(
                output, "manifest-hash", "source-fingerprint", row_ids
            )
            self.assertEqual(
                binding["path"], str((output / "nominal_admission.json").resolve())
            )
            self.assertEqual(
                binding["sha256"], reset._sha256_file(output / "nominal_admission.json")
            )
            with self.assertRaises(ValueError):
                reset._require_nominal_admission(
                    output, "other-manifest", "source-fingerprint", row_ids
                )

    def test_registered_scalar_limits_are_strict_and_unit_normalized(self) -> None:
        inside = {
            "refractory_period": 100e-6,
            "delta_vdiff_ci": 0.0,
            "leak_event_period": 1.0,
            "min_reset_time": 10e-6,
            "vdiff_before_ci": 0.9,
            "vdiff_after_ci": 1.0,
        }
        self.assertEqual(reset.evaluate_reset_spec(inside), "pass")
        boundary = dict(inside, refractory_period=0.1e-6, delta_vdiff_ci=50e-3)
        self.assertEqual(reset.evaluate_reset_spec(boundary), "pass")
        self.assertEqual(
            reset.evaluate_reset_spec(dict(boundary, refractory_period=0.1e-6 - 1e-15)),
            "fail",
        )

    def test_quantus_warning_summary_fails_execution(self) -> None:
        row = self.representative("quantus_rcc_spectre")
        times = [0.0, 0.001, 0.002, 0.003, 0.004, 0.005, 51.0]
        traces = {
            "vdd": [1.8] * len(times),
            "pixrst": [1.8, 1.8, 0.0, 0.0, 1.8, 0.0, 0.0],
            "on": [0.0, 0.0, 0.0, 1.8, 1.8, 1.8, 1.8],
            "nrst": [0.0, 0.0, 1.8, 1.8, 1.8, 1.8, 1.8],
            "vdiff": [0.9, 0.9, 1.0, 1.0, 0.9, 1.0, 1.0],
        }
        result = reset._classify_discovery(
            row,
            0,
            "spectre completes with 0 errors, 1 warning, and 0 notices",
            times,
            traces,
        )
        self.assertEqual(result["execution_validity"], "fail")

    def test_result_axes_remain_independent(self) -> None:
        row = self.representative("magic_rcc_ngspice")
        failed = reset.classify_execution(
            row,
            exit_code=1,
            log_text="simulator failed",
            raw_times=[],
            traces={},
            windows=[],
        )
        self.assertEqual(failed["execution_validity"], "fail")
        self.assertEqual(failed["scientific_validity"], "pending")
        self.assertEqual(failed["spec_result"], "not_evaluated")
        self.assertEqual(failed["comparison"], "not_evaluated")


if __name__ == "__main__":
    unittest.main()
