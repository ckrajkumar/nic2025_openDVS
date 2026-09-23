# openDVS — r20: r19 pixel + wrapper-level power joins in the final user_project_wrapper GDS

**Date:** 2026-09-23 · **Author:** Rui Graça (Claude session opendvs-pex) · **Supersedes:** r19 wrapper file (2026-09-23 04:20); the r19 pixel, tile and netlists are unchanged

## 0. What r20 adds (wrapper level only)

r20 = the r19 wrapper + 40 same-net shapes at the top level of `user_project_wrapper`, nothing inside `pixel_4tile` or the pixel:

- **20 vdda1 met4 joins**: each of the 10 vertical vdda1 PDN stripes (1.6 µm, x = 1263.0 + k·153.6 µm) that ends at the tile's top edge (y 2379.4) and at its bottom edge (y 584.5) is extended through the tile periphery into the array until it overlaps the 2x2's VddA18 met4 by ≥ 0.3 µm (10.0 / 12.45 / 40.0 µm past the array edge, the deepest full-width box that keeps 0.3 µm from any other-net met4; the 10.0 µm ones stop 0.33 µm above the 2x2's GndA met4 pad).
- **20 vssa1 met5 stubs** (16.6 × 1.6 µm): each vssa1 PDN stripe that ends at the west (x 1190.29) or east (x 2764.87) side bar inside the GndA plane's y-range is extended onto the plane (x 1206.885 / 2748.265).

Why: measured on r19, the wrapper's met5 grid lands on the tile's three ring bars only (72 via4 per bar); the vdda1 top/bottom met3 rings are fed at their corners alone and the array's VddA18 columns hang on those rings, so the middle of the array sees the whole 10 µm half-ring (≈ 4 Ω) in series. The joins are the "extend the existing stripes" idea (Rui, 12:50), scripted from the verified r19 by `r20_build.py` with a full-layer extraction before and after: every join probes to its own net, the vdda1/vssa1 pin sets are unchanged, the eight power nets stay distinct.

**Effect (lumped network model, `vdda18_net.py`: sky130 typical sheet resistances met3/met4 0.047, met5 0.0285 Ω/sq, via4 0.38 Ω; rings 10 µm met3 fed at the corners through ≈ 0.4 Ω; 64 2x2-columns at 24.08 µm pitch, 3.2 Ω periphery feed per column end, 27 Ω per column, uniformly distributed sinks; array current 2.1 mA at Iph 1 nA / 3.7 mA at 100 nA from the schematic .op at the reset-test biases):**

| | worst VddA18 drop, 2.1 mA | worst drop, 3.7 mA | ring midpoint, 3.7 mA | R_eff (worst node) |
|---|---|---|---|---|
| r19 (rings fed at the corners) | 1.29 mV | 2.27 mV | 1.99 mV | 0.61 Ω |
| r20 (+20 met4 feeds, ≈ 7 Ω each) | 0.73 mV | 1.29 mV | 1.01 mV | 0.35 Ω |
| optional r21: met5 plate over the periphery band with via4 onto the joins (feeds ≈ 0.5 Ω) | 0.44 mV | 0.78 mV | 0.49 mV | 0.21 Ω |

The 20 feeds cut the worst-case supply drop by 43 % and the ring-midpoint drop by half. They are limited by their own resistance: each joined stripe is fed by a single 0.8 µm via4 at the nearest met5 crossing, 227–258 µm away (y 500.3 / 2491.6), i.e. ≈ 7 Ω of 1.6 µm met4 per feed (`feed_geom.py`). The vssa1 stubs (≈ 0.6 Ω each) sit in parallel with an existing mΩ path (72 via4 per bar → 64 arrays of 25 via3 per side → met5 plane) and change nothing measurable; they are belt-and-braces. All numbers are static IR drop; the gradient corner→mid-array was the only real term (a 2x2 column itself drops ≈ 0.1 mV).

**Verification of r20 (`check_r20.sh`, workstation):** cf_precheck 1.3.7 non-LVS stage on the r20 wrapper: XOR 0 differences, klayout feol / beol / offgrid / met_min_ca_density / pin_label_purposes_overlapping_drawing / zeroarea "No DRC violations found" (all `.total` 0), "No spikes found"; the native KLayout 0.30.12 run of the precheck BEOL deck on the whole wrapper: 0 items (714 s, 32 threads); LVS+OEB stage: the top-level compare ends exactly as r19 and as the collaborators' own run ("Subcell(s) failed matching" = the top-port-order artefact, 116 mismatch lines; the sorted diff of the r20 and r19 reports is 30 lines, all reordered pairings inside symmetric classes: decap pin classes, one mux2_8 A0/A1 pairing, two `_noconnect_` nets), OEB "No warnings or errors detected".

### Bias lines to the array (assessment, no change made)

Index mapping (2x2 instance pin order in the tile schematic; verilog `dac_config_k` = `core_inst.dac_bias[k]` = `BiasBranchnMasterx11.Bias[k]`): dac_config_0 = DiffBn, 1 = OffBn, 2 = OnBn, 3 = PrBp, 4 = PrSFBp, 5 = RefrBp, 6 = VTHRESH of the 128 `col_amp_2x1` column amplifiers; Bias[7] feeds the test structures, Bias[9] goes to analog_io[0].

As routed by the digital router (metal-only extraction of the wrapper, `bias_nets.py` / `bias_nbrs3.py`): 0.26 µm met1/met2 with met3/met4 pieces, 5.1–5.6 mm of wire per net, 16–43 via1, 3–16 `diode_2` antenna cells (16 on VTHRESH, 11 on OffBn, 9 on OnBn, 3 on the others). Neighbours within 0.35 µm on the same layer: the long parallel runs are other bias lines (PrBp‖PrSFBp 2020 µm, PrBp‖DiffBn 1857, OnBn‖RefrBp 1588, RefrBp‖PrSFBp 1489, RefrBp‖PrBp 887 — static, harmless) and the vccd1/vssd1 rails; toggling neighbours are short: clock-tree segments of 120 µm (PrBp, met2), 149 µm (OffBn, met1 at 0.2 µm), 152 µm (VTHRESH) and ≤ 19 µm on the others; data/control nets 40–180 µm each; OffBn and VTHRESH also run 240–400 µm beside bias-generator configuration bits (static after configuration). Line resistance 2–3 kΩ is irrelevant for gate lines.

What the coupling does: the load of a pixel bias line is 16 k gates plus the in-tile distribution wiring (≈ 50 pF for PrBp with its 0.5/0.15 pfet, ≈ 100 pF for PrSFBp/RefrBp, ≈ 350 pF for DiffBn/OnBn/OffBn), so 7 fF of clock adjacency on PrBp (120 µm at ≈ 0.06 fF/µm) is a 0.25 mV step per edge, recovering with the bias mirror's 1/gm (τ ≈ 0.2 ms at 10 nA). Injected into the schematic 2x2 after reset release (`/tmp/biasinj/inj2_*.deck`, PrBp 10 nA, PrSFBp 100 pA, Iph 1 nA, C_load 50 pF): a 1.8 V edge through 7 fF moves vpr by 1.1 mV for the edge instant and vdiff by +0.7 mV, no event; through 50 fF (a hypothetical 1 mm unshielded neighbour) PrBp moves 1.8 mV, vpr 8 mV at the edge, vdiff +5.4 / −7.1 mV, no event. At the clock frequency the ripple is filtered by the photoreceptor and source follower; isolated control-line edges give the sub-mV vdiff steps above. OffBn/OnBn/DiffBn see ≤ 0.1 mV (larger loads); VTHRESH (128 column amps, small load) may carry a ≈ 1–2 mV ripple at the clock frequency on the column-event threshold — a digital-side observation for the collaborators. Antenna-diode leakage: ≤ 3 pA at 85 °C on PrBp/PrSFBp (3 diodes, 1 pA each as a conservative bound) → ≤ 1 mV on a 100 pA master, 3 %; on the 16-diode VTHRESH line it depends on that bias's current.

Verdict: functional for this tape-out, identical to the collaborators' wrapper. Re-wiring the seven bias nets in met4/met5 by hand at the wrapper level is possible in principle (met5 carries only the 322 PDN stripes; met4 is 82 % router wiring, so vertical runs would have to thread between it) but means deleting the router's 5 mm of wire per net while keeping every antenna diode attached (else the gate-level LVS changes), then a full precheck rerun — a day of work for a gain from ≈ 0.7 mV to ≈ 0 on vdiff. Not recommended now. For a revision: route the bias nets in the digital flow with non-default rules (wider spacing, shielding by vssd1/vssa1 guard wires) and keep them off the clock tree's tracks; the 16-diode VTHRESH and 11-diode OffBn lines can lose most of their diodes by routing them with fewer layer changes.

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
- July-flow check (PDK `sky130A_setup.tcl`, no stub, July xschem `pixel_4tile_schem.spice`) on the Magic 8.3.471 extractions of the collaborators' production tile and of the r19 tile: both "Top level cell failed pin matching" with 778 mismatch lines each (the known top-level artefact); the two mismatch lists differ only in the arbitrary pairing inside symmetric net classes (vpd[k] orderings, dummy nets). A rerun with the frozen July Magic on the corrected tile crashed the extractor (memory, while three Quantus reset shards were starting on the same machine) and was not repeated.
- Test structure of the r19 wrapper: precheck deck feol/beol/offgrid 0/0/0, category counts identical to the untouched final's test structure.
- Wrapper-level connections of the two analog macros, checked twice: in the precheck's Magic extraction of the r19 wrapper every port of `pixel_test_structure` and `pixel_4tile` pairs with the same wrapper net as in `verilog/gl/user_project_wrapper.v` (all grounds merge into one net through the substrate there, the documented artefact); a metal-only KLayout extraction of the whole wrapper (li…met5 and vias, no substrate) gives tile vdda1 ← vdda1, tile vssa1 ← vssa1, tile vssc1 ← vssa2, test structure vdda2 ← vdda2, vssa2 and vssd2 ← vssa2, bias master GndA/VddA18 ← vssa1/vdda1, exactly as the verilog. Power reaches the tile through its three 10 µm rings at the tile boundary (met3 bars top and bottom, met4 bars west and east: vssa1 inner, vdda1 middle, vssc1 outer) from the wrapper's met4/met5 grid; inside the tile vdda1 runs on the pixels' met4 columns, vssa1 on the met5 mesh over the array and the met4 columns, vssc1 on the met2 row lines fed by the west and east connectors.
- One observation for the digital side (not touched by the merge): the test structure's `pixRst[0..1]` are driven by two `sky130_fd_sc_hd__conb_1` cells (`core_inst.i_pixel_test_struct_851/852`, LO pins), i.e. tied to 0 in the gate-level netlist; the test pixel can then only be reset through its own handshake. If a global reset of the test pixel was intended, that is an RTL change.
- Connectivity check on a clipped west-edge window (KLayout extraction, two pairs): GndD, VddA18 and each rowReadON/OFF[k] are separate nets.

**Parasitics (Quantus, pixel 0, fF, r19 vs r18b):** vsf–vd 2.204 / 2.203, vsf–vdiff 0.518 / 0.518, vd–vdiff 0.543 / 0.543, nRst→vsf 0.119 / 0.119, pixRst→vsf 0.052 / 0.053, rowReadOFF→vsf 0.096 / 0.101, rowReadON→vsf 0.031 / 0.031, readLine→vsf 0.055 / 0.055, GndD→vsf 0.444 / 0.434 — no coupling changed by more than 0.01 fF.

**cf_precheck 1.3.7 on the r19 wrapper** (run 04:19–04:52 on the r19 `user_project_wrapper.gds`, GDS hash 0746a1dd… in the precheck log): topcell pass, gpio_defines pass, xor 0 differences, klayout feol / beol / offgrid / met_min_ca_density / pin_label_purposes_overlapping_drawing (with the moved tile labels) / zeroarea "No DRC violations found" (all `.total` 0), spike "No spikes found", illegal cellname pass; LVS+OEB stage (32 min): the top-level `user_project_wrapper` compare ends exactly as the collaborators' own run and as r18b (30466 = 30466 devices, "Subcell(s) failed matching" = the top-port-order artefact, 116 mismatch lines; the sorted diff of the two reports is seven reordered lines inside symmetric pin classes), OEB stat=5 (the vssa* extraction-tooling artefact documented in their `failures_analysis.md`). An earlier pair of runs at 02:19–03:00 had been started on the r18b wrapper by a stale symlink; they are superseded by these.

**Full cf_precheck rerun (09:05–09:58, all checks, plus the optional Magic DRC):** non-LVS stage again all clean (xor 0, feol/beol/offgrid/density/pin-label/zeroarea 0, no spikes; one concurrent run of the FEOL deck reported 65272 MR_licon.WID.1 items that three further runs of the same deck on the same file, in the image at 32 and 8 threads and natively, do not reproduce — a KLayout 0.29.12 threading artefact under load); LVS+OEB stage byte-for-byte the same report as before. Magic DRC on the whole wrapper, r19 vs the untouched final: 77769 vs 132761 items; every rule count in the array is equal or lower (subcell abut/overlap 53130 = 53130, li.3 10664 = 10664, met1.2/met2.2 4232 = 4232, capm.11 1062 = 1062, "Can't overlap those layers" 578 vs 39010, met1.7/met2.7 hole items 0 vs 8464 each); the only increases are inside the test structure (met1.2 +48, met2.2 +48, met1.7 +64, met2.7 +72, "Can't overlap" +136), all located on the 0.29 µm met1/met2 density-fill squares that the array pixel already carries in the original and that the test-structure pixel now carries too; KLayout finds the merged geometry there clean (fill square to test-structure wiring 0.34 µm on met1, 0.26 µm on met2, no 0.14 µm spacing violation), and the precheck decks report 0 on the test structure. Magic DRC is not part of the ChipFoundry signoff.

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

Three-path PEX campaign (Quantus/Spectre, Magic/ngspice, schematic/ngspice × 46 corners, static and reset-transient rows): static rows running since 03:06 (Quantus/Spectre complete, 322/322 valid, on rpgraca-ini; schematic 315/322 with the usual 9 comparator gmin failures and the Magic path in progress on the workstation); the reset-transient rows had failed at launch on a stale base hash in the Magic reset netlist (the fill shunts were added after its derivation) and were re-derived and relaunched at 05:09 on both machines; results in a follow-up.

## 4. Files

- `user_project_wrapper.r20.gds` (160 MB, sha256 `8d82a945…`) — the wrapper to submit (r19 wrapper `ca19f18b…` + the 40 power joins of section 0; the r19 file is superseded); `pixel_4tile.r19.gds` (sha256 `351cac6d…`, 9.7 MB) — the wrapper's `pixel_4tile` subtree with the `GS_` prefix stripped, i.e. production cell names with the r19 pixel, 2x2 and the adapted periphery cells (the collaborators' wrapper-level via cells `vias_gen$7/9` are kept and their `vias_gen$8`, which differs from the tile's own `vias_gen$8`, is renamed `vias_gen$8_wrap`); `openDVS_pixel2x2_top.r19.gds` (sha256 `622cf47f…`). An earlier `pixel_4tile.r19.gds` (sha256 `60a8d956…`, 3.9 MB) carried the r19 pixel with the production periphery and is not a connected tile; it is kept as `pixel_4tile.r19.pixelonly.gds` and should not be used.
- `pixel_4tile_layout_lvs2.spice`, `pixel_test_structure_layout_lvs.spice` — regenerated layout netlists for `lvs/user_project_wrapper/`.
- Scripts: `r20_build.py` / `join_plan.py` / `join_check.py` / `check_r20.sh` (r20 joins and their checks), `vdda18_net.py`, `feed_geom.py`, `bias_nets.py` / `bias_nbrs3.py` (section 0 measurements), `r19_build.py` (all r19 edits, with built-in checks), `merge_final.py` + `microfix.py` (r18b), `strip_gs.py` (production-named tile from the wrapper subtree), `add_fill_shunts.py`, DRC/LVS/precheck runners — in nic2025_openDVS `analog/klayout/production/final_merge_20260923/`.
