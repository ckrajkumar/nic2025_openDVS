from __future__ import annotations

import hashlib
import importlib.util
import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EXPECTED = "0668aca3082314fb885cb685e0f082f2e53096ede2e5b38aed00f5b0b93dfb9e"


def load_runner():
    spec = importlib.util.spec_from_file_location(
        "corrected_quantus_runner", ROOT / "reset_campaign.py"
    )
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class CorrectedQuantusSourceContractTests(unittest.TestCase):
    def test_runner_and_source_map_bind_the_magic_derived_corrected_source(
        self,
    ) -> None:
        reset = load_runner()
        source_map = json.loads((ROOT / "source_map.rpgraca-ini.json").read_text())
        path = (ROOT / source_map["sources"]["quantus_netlist"]).resolve()
        self.assertEqual(reset.SOURCE_HASHES["quantus_netlist"], EXPECTED)
        self.assertEqual(
            path.name,
            "openDVS_pixel2x2_quantus_rcc_spectre.junction_corrected.spice",
        )
        self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), EXPECTED)


if __name__ == "__main__":
    unittest.main()
