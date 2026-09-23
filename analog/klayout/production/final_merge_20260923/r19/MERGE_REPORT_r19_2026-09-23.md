# openDVS — r19: new pixel with continuous GndD rows in the final user_project_wrapper GDS

**Date:** 2026-09-23 · **Author:** Rui Graça (Claude session opendvs-pex) · **Supersedes:** r18b (2026-09-23 00:45)

## 1. What r19 is

r19 = the r18b pixel (r17b core + the foundry-side tap/fill/waffleDrop changes of the final + three manufacturing-rule micro-fixes) with **GndD as one continuous 0.7 µm met2 line per row through the whole array**, and the array-edge feeds inside `pixel_4tile` adapted so that the pins the digital wrapper sees are unchanged.

Why: in r18b (and r17b) the GndD row line dropped to a met1 corner piece through single via1 pairs at every 2x2 boundary — 32 hops per 64-pixel row, about 10 Ω each, on top of about 130 Ω of met2, against about 160 Ω for production's continuous bar. r19 removes the hops (row resistance about 130 Ω) and also removes the in-pixel met1 jog under the row lines.

Changes, all inside the `pixel_4tile` macro (cell names as in the wrapper):

| cell | change |
|---|---|
| `GS_openDVS_pixel` (array pixel) | west-edge band back to the r15a geometry: straight rowReadON/OFF met2 lines (0.20–0.34 / 0.48–0.62 local) and the GndD met2 line from x 0 (0.76–1.46 local); the r17 GndD met1 corner+bar and its via1 removed; the r17 GndA li vertical, the foundry fixes, the density fill and the three micro-fixes stay |
| `GS_openDVS_pixel2x2_top/bot` | overlay pins and labels of both edge strips at the band heights (rowReadON at A±0.07–0.21, rowReadOFF at A±0.35–0.49, GndD at A±1.07–1.33; A = pair axis) |
| `GS_pixel_layout_biasgen_connector_v3` (west row feed, 64 instances) | the four 0.26 µm met2 stubs at the production heights become 0.14 µm jogged routes from the existing M2M3 via cells into the band; verticals at tile x 1.81–1.95 (ON) and 2.21–2.35 (OFF) |
| `GS_pixel_4tile_left_vdd_gnd_connectors` (west GndD feed, 64 instances) | the met2 bar A±0.31 stops at x 0.60; two via1 (x 0.20–0.35) drop to a met1 bar 0.10 → 3.01 that stays east of the VddA18 met1 tie rail at x −0.665..−0.045; a 0.32 µm met1 post A±1.21 at x 2.69–3.01 with two via1 per row lands on the pixel's GndD lines |
| `GS_pixel_layout_biasgen_connector_v2` (east GndD feed, 63 instances) | the 1.14 µm met2 block A±0.57 becomes two tongues at A±(0.63–1.33) over the line ends plus a plate from tile x 1539.0 to the existing via stack |
| `GS_pixel_layout_tile/_bot` | the 128 met2 pin squares per half at the array edge (and the pair-0 GndD square) become 0.14 µm rectangles at the band heights; the tile's own 128 port labels per half move with them, the `GND` label onto the GndD line |

The test structure keeps the r18b pixel (its own wiring meets the pixel at the production heights); its pixel core is identical to the array pixel.

## 2. Verification

**DRC, precheck deck `sky130A_mr.drc`, whole `pixel_4tile` of the wrapper:** FEOL 3528 = the untouched final's own subtree baseline (periphery items the full-wrapper run does not report), BEOL **0**, off-grid **0**. (r17b: 6 / 68; r18b: 0 / 0 with the periphery untouched.)

**LVS:**
- 2x2 macro: PVS (Cadence, production deck) **MATCH**.
- `pixel_test_structure`: **Circuits match uniquely**, 143 devices / 90 nets (unchanged from r18b).
- `pixel_4tile` vs `pixel_4tile_schem_lvs.spice` (Magic 8.3.471 + netgen, `lvs_setup_2x2.tcl`, diode stub): **Circuits match uniquely** (netgen 1.5 on rpgraca-ini, 7 min, on the Magic 8.3.471 extraction of the merged `pixel_4tile`; 381440 devices on both sides).
- Connectivity check on a clipped west-edge window (KLayout extraction, two pairs): GndD, VddA18 and each rowReadON/OFF[k] are separate nets.

**Parasitics (Quantus, pixel 0, fF, r19 vs r18b):** vsf–vd 2.204 / 2.203, vsf–vdiff 0.518 / 0.518, vd–vdiff 0.543 / 0.543, nRst→vsf 0.119 / 0.119, pixRst→vsf 0.052 / 0.053, rowReadOFF→vsf 0.096 / 0.101, rowReadON→vsf 0.031 / 0.031, readLine→vsf 0.055 / 0.055, GndD→vsf 0.444 / 0.434 — no coupling changed by more than 0.01 fF.

**cf_precheck 1.3.7 on the r19 wrapper:** topcell pass, gpio_defines pass, xor 0 differences, klayout feol/beol/offgrid/met_min_ca_density/pin_label/zeroarea "No DRC violations found", spike none, illegal cellname pass; LVS+OEB stage (32 min): the top-level `user_project_wrapper` compare ends exactly as the collaborators' own run and as r18b (30466 = 30466 devices, 28815 vs 29262 nets, "Subcell(s) failed matching" = the top-port-order artefact, 116 mismatch lines), OEB stat=5 (the vssa* extraction-tooling artefact documented in their `failures_analysis.md`).

## 3. Simulations on the r19 pixel (Magic RCC netlist with the density fill; every floating fill node tied to ground through 1e15 Ω so the operating point is not singular)

| bench | result |
|---|---|
| reset test bench, nominal | no ON event, vdiff 0.864 V after release |
| gain (photocurrent ×2 / ×0.5) | 0.307 / 0.309 V per e-fold |
| PVT and bias matrix (36 cases) | 35 clean; fires only at OnBn 70 nA + DiffBn 10 nA (16.7 µs) — the RefrBp 3 nA + DiffBn 10 nA corner that fired on r14d–r17b is clean |
| 64-pixel GndD ladder stress (62 simultaneous pull-downs, with and without a concurrent reset, 5 and 95 pA) | no ON in any pixel, far-end bounce 0.27 V, worst vdiff dip 29 mV |
| crosstalk at 1 ms: pixRst pulse | clean at 5 and 95 pA |
| crosstalk at 1 ms: rowReadOFF / readLine pulse | fires only in the pixels that already sit 30 mV low from the coincident edge at the reset release (the known periphery-timing case: keep row/column edges ≥ 3 µs away from pixRst) |
| coincident-edge control | row-0 offset −21.5 mV at 5 pA, −32.3 mV at 95 pA (as r15a/r17b) |

Three-path PEX campaign (Quantus/Spectre, Magic/ngspice, schematic/ngspice × 45 corners): running since 03:20 on rpgraca-ini (Quantus/Spectre) and the workstation (Magic and schematic ngspice); results in a follow-up.

## 4. Files

- `user_project_wrapper.r19.gds` (160 MB) — the wrapper to submit; `pixel_4tile.r19.gds` (production cell names, pixel/2x2 only); `openDVS_pixel2x2_top.r19.gds`.
- `pixel_4tile_layout_lvs2.spice`, `pixel_test_structure_layout_lvs.spice` — regenerated layout netlists for `lvs/user_project_wrapper/`.
- Scripts: `r19_build.py` (all edits, with built-in checks), `merge_final.py` + `microfix.py` (r18b), `add_fill_shunts.py`, DRC/LVS/precheck runners — in nic2025_openDVS `analog/klayout/production/final_merge_20260923/`.
