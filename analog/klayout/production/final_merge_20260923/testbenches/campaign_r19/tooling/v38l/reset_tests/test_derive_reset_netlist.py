from __future__ import annotations

import importlib.util
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "derive_reset_netlist", ROOT / "derive_reset_netlist.py"
)
assert spec and spec.loader
derive = importlib.util.module_from_spec(spec)
spec.loader.exec_module(derive)


def magic_source() -> str:
    return """* source
.subckt unrelated a b
R0 a b 1
.ends
.subckt openDVS_pixel2x2__diffbn_physical_core a GndA
D0 GndA.t0 vpd[0] sky130_fd_pr__model__parasitic__diode_ps2dn area=32.49 pj=22.8 m=1
D1 GndA.t1 vpd[1] sky130_fd_pr__model__parasitic__diode_ps2dn area=32.49 pj=22.8 m=1
D2 GndA.t2 vpd[2] sky130_fd_pr__model__parasitic__diode_ps2dn area=32.49 pj=22.8 m=1
D3 GndA.t3 vpd[3] sky130_fd_pr__model__parasitic__diode_ps2dn area=32.49 pj=22.8 m=1
C0 openDVS_pixel_0.vd GndA 1f
C1 openDVS_pixel_1.vd GndA 1f
C2 openDVS_pixel_2.vd GndA 1f
C3 openDVS_pixel_3.vd GndA 1f
.ends
.subckt openDVS_pixel2x2 a GndA
Xcore a GndA openDVS_pixel2x2__diffbn_physical_core
.ends openDVS_pixel2x2
"""


def schematic_source(pixel_instances: int = 4) -> str:
    pixels = "\n".join(
        f"xpix[{index}] row{index} VddA18 PrBp GndA vpd[{index}] openDVS_pixel"
        for index in range(pixel_instances)
    )
    return f"""* source
.subckt openDVS_pixel2x2 VddA18 GndA
{pixels}
.ends
.subckt openDVS_pixel row VddA18 PrBp GndA vpd
xpr VddA18 PrBp GndA vpd vpr PixelPhotoreceptor
xchamp VddA18 DiffBn GndA vsf vdiff nRst PixelChangeAmplifier
.ends
.subckt PixelPhotoreceptor VddA18 PrBp GndA vpd vpr
D1 GndA vpd sky130_fd_pr__model__parasitic__diode_ps2dn area=32.49 pj=22.8 m=1
.ends
.subckt PixelChangeAmplifier VddA18 DiffBn GndA vsf vdiff nRst
C1 vd GndA 1p
.ends
"""


class DeriveResetNetlistTests(unittest.TestCase):
    def test_magic_derivation_retains_four_physical_diodes(self) -> None:
        source = magic_source()
        output = derive.derive_magic(source, "a" * 64)
        self.assertEqual(output.count(derive._DIODE_MODEL), 4)
        self.assertNotIn("R_cace_pd_", output)
        self.assertNotIn("R_cace_vdstab", output)
        self.assertIn("RESET_BASE_SHA256 " + "a" * 64, output)
        self.assertTrue(output.endswith(source))

    def test_magic_derivation_rejects_wrong_scope_binding_and_preexisting_apparatus(
        self,
    ) -> None:
        source = magic_source()
        with self.assertRaisesRegex(ValueError, "outside the physical-core"):
            derive.derive_magic(
                source.replace(
                    ".subckt unrelated a b",
                    ".subckt unrelated a b\nD9 a b " + derive._DIODE_MODEL,
                ),
                "a" * 64,
            )
        with self.assertRaisesRegex(ValueError, "pre-existing CACE"):
            derive.derive_magic(
                source.replace("R0 a b 1", "R0 a b 1\nR_cace_vdstab_0 a b 1e12"),
                "a" * 64,
            )
        with self.assertRaisesRegex(ValueError, "must retain area=32.49"):
            derive.derive_magic(source.replace("area=32.49", "area=1", 1), "a" * 64)

    def test_schematic_derivation_retains_one_effective_physical_diode(self) -> None:
        source = schematic_source()
        output = derive.derive_schematic(source, "b" * 64)
        self.assertEqual(output.count(derive._DIODE_MODEL), 1)
        self.assertNotIn("R_cace_pd_", output)
        self.assertNotIn("R_cace_vdstab", output)
        self.assertTrue(output.endswith(source))
        with self.assertRaisesRegex(ValueError, "exactly four openDVS_pixel instances"):
            derive.derive_schematic(schematic_source(3), "b" * 64)
        with self.assertRaisesRegex(ValueError, "must retain area=32.49"):
            derive.derive_schematic(source.replace("pj=22.8", "pj=1"), "b" * 64)

    def test_schematic_derivation_rejects_photodiode_outside_target(self) -> None:
        source = schematic_source().replace(
            ".subckt PixelChangeAmplifier",
            ".subckt Other a b\nD1 a b "
            + derive._DIODE_MODEL
            + "\n.ends\n.subckt PixelChangeAmplifier",
        )
        with self.assertRaisesRegex(ValueError, "outside PixelPhotoreceptor"):
            derive.derive_schematic(source, "b" * 64)


if __name__ == "__main__":
    unittest.main()
