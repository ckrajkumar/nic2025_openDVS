# openDVS — new pixel (r18b) merged into the final user_project_wrapper GDS

**Date:** 2026-09-23 (night of 22→23 September) · **Author:** Rui Graça's Claude session (opendvs-pex) · **Status:** merged, DRC-clean under the precheck deck, macro LVS green, cf_precheck in progress

## 1. What this delivers

- `user_project_wrapper.r18b.gds` — the submission GDS from `lvs_final_submission_run/` (sha256 of the original `57d41be6…`) with the new pixel in every pixel cell of the array (`GS_openDVS_pixel`, `GS_openDVS_pixel2x2_top/bot`) and of the test structure (`S7_openDVS_pixel`, `S7_openDVS_pixel2x2_bot`). Everything else is byte-identical (checked cell by cell). sha256 `c9909cc9c7329f20…`.
- `pixel_4tile.r18b.gds` — the same pixel in the nic2025 tile with production cell names (for our own LVS/PEX flows; the tile-level periphery fixes of the final are not in this file by design).
- `openDVS_pixel2x2_top.r18b.gds` — the 2x2 macro alone (sha256 `14bbadf222ddbcf5…`), the input of the Magic RCC and Quantus extractions.
- `pixel_4tile_layout_lvs2.spice`, `pixel_test_structure_layout_lvs.spice` — regenerated layout netlists (Magic 8.3.471, the precheck image) that replace the two files of the same name in `lvs/user_project_wrapper/` for the wrapper LVS.
- `merge_report.txt` — the per-layer log of the merge.

## 2. The pixel: r17b (nic2025_openDVS 6ccefa01) + the foundry-side fixes of the final + three micro-fixes

**r17b** is the decoupled pixel: pixRst and readLine columns on met4 with GndA shielding, rowReadON/rowReadOFF inside the pair-mirror band clear of the MIM plates, GndD as a quiet met2 line per row with two vias per plate, the change-amp core wiring trimmed (vd–vdiff 0.65 → 0.55 fF), the nRst run shielded by VddA18, and a west-edge interface identical to production. Quantus, pixel 0, production → r17b (fF): nRst→vd 0.654 → 0.063, nRst→vsf 0.458 → 0.119, pixRst→vsf 0.202 → 0.053, pixRst→vd 0.109 → 0.002, rowReadON→vsf/vdiff 0.17/0.10 → 0.032/0.011, rowReadOFF→vsf/vdiff 0.26/0.29 → 0.10/0.03, readLine→vsf 0.055. Gain 0.297 → 0.307 V per e-fold.

**Foundry-side changes found in the final's pixel** (final − nic2025 production, per layer): seven diff→tap conversions (substrate/well ties drawn as diff), a VddA18 well-tie L (block 8.49–10.50 × 11.05–12.33 µm plus a strip 10.09–10.50 × 8.21–11.05 with 12 licon), a p-tap licon row at y 10.25–10.42 with its li and psdm, an nsdm extension, 23 met1 and 23 met2 density tiles (0.29 µm squares) over the photodiode, waffleDrop markers (cfom, cmm1–cmm5; cp1m removed) and 65/98…72/98 markers over the photodiode; at the 2x2 level two GndA tie blocks (tap + li + 16 licon + psdm) at the pair-column ends of the mirror band. The test-structure pixel in the final had none of these.

**Merge rule:** new = r17b + (final − production) − (production − final), computed as regions per layer, with every collision probed by net (KLayout connectivity extraction):

| item | decision |
|---|---|
| well-tie strip (VddA18) 10.09–10.50 × 8.21–11.05 + 6 licon + nsdm strip | **dropped** — it runs through r17b's GndA li ring extension and the nRst gate-feed li (would short VddA18 to GndA and nRst); the tie block above y 11.05 is kept, its li kept east of x 10.035 only above y 11.47 |
| 4 met2 density tiles at x 2.77–3.06 | **dropped** — under 0.14 µm from r17b met2 |
| `contact$26$1$1` | the final's original cell is kept (Rui's narrowed met1 version is the source of 64 met1-width items) |
| everything else (tap conversions, p-tap row, 19+23 tiles, markers, 2x2 tie blocks) | carried |

**Micro-fixes (r18 → r18b)** required by the precheck's manufacturing-rule deck `sky130A_mr.drc` (stricter than the PDK `sky130A.lydrc` used during the design rounds; production is 0/0 under it, r17b was not):

| rule | item in r17b | fix |
|---|---|---|
| MR_licon.SP.6 (psdm ≥ 0.11 from poly licon) | psdm piece top 5.225 vs licon row at 5.325 (0.100) | psdm top → 5.210 (diff enclosure 0.130 ≥ 0.125) |
| MR_capm.SP.2 (met3 ≥ 1.2 from capm footprint + 0.14) | vd via pad corner (9.465, 3.495) 1.181 from the C2 footprint corner | pad west edge → 9.555; via2 → 9.62–9.82 with its met2 landing extended to 9.905; via3 → 9.69–9.89; pad top → 3.925 and the VddA18 met3 shield above trimmed 4.195 → 4.225 (keeps the pad ≥ 0.24 µm²) |
| m2.5 (two adjacent met2 enclosures < 0.085) | second GndD via1 at y 0.82–0.97 (bottom 0.06, right 0.075) | via → y 0.85–1.00 |

## 3. Verification

**DRC, precheck deck `sky130A_mr.drc` (feol + beol), whole `pixel_4tile` cell**

| tile | FEOL | BEOL |
|---|---|---|
| production (nic2025) | 0 | 0 |
| r17b | 6 (4 MR_licon.SP.6, 2 MR_capm.SP.2) | 68 (64 MR_met1.WID.1 from the contact edit, 4 m2.5) |
| r18b | **0** | **0** |

On the merged wrapper's `pixel_4tile` and `pixel_test_structure` subtrees the same decks reproduce the untouched final's item lists exactly (3528 pre-existing periphery items that the full-wrapper run does not report), plus nothing. cf_precheck on the merged wrapper: single top cell, GPIO defines pass, XOR against the empty wrapper 0, klayout_feol "No DRC violations"; beol/offgrid/density/pin-label/zeroarea/spike/cellname and the LVS/OEB stage: see §5.

**LVS**

- 2x2 macro: KLayout LVS MATCH, PVS (Cadence, production deck) MATCH.
- `pixel_test_structure` vs `pixel_test_structure_schem_lvs.spice` (`openDVS2x2_test_pixel`), Magic 8.3.471 + netgen with `lvs_setup_TestPixel.tcl` and `lvs_vc_TestPixel.sed`: **Circuits match uniquely**, 143 devices, 90 nets on both sides (the collaborators' numbers). The extracted netlist needs a two-line stub `.subckt sky130_fd_pr__model__parasitic__diode_ps2dn anode cathode / .ends` appended; without it netgen invents proxy pins for the photodiode and reports a mismatch even on the untouched final.
- `pixel_4tile` vs `pixel_4tile_schem_lvs.spice` with `lvs_setup_2x2.tcl` / `lvs_vc_2x2.sed`: **Circuits match uniquely** (netgen on the Magic 8.3.471 extraction of the merged `pixel_4tile`, 00:39–00:52). The July flow on this tile (PDK setup, no stub) gave the known top-level pin-order failure with identical mismatch sets for production and r17b.
- Tile LVS of r17b in the July flow (frozen Magic on ini, netgen vs the July xschem netlist): identical verdict, mismatch set, net and device counts to today's production run.

**Parasitics of the merged pixel (Quantus, pixel 0, fF):** vsf–vd 2.203, vsf–vdiff 0.518, vd–vdiff 0.543, nRst→vsf 0.119, nRst→vd 0.062, pixRst→vsf 0.053, rowReadOFF→vsf 0.101, rowReadON→vsf 0.031, readLine→vsf 0.055, GndD→vsf 0.434 — all within 0.005 fF of r17b; the density tiles add ≈ 30 floating-node couplings of 0.006–0.038 fF to vsf. Magic RCC: 1011 capacitors / 3402 resistors (r17b 683 / 3208, the extra ones are the tiles).

## 4. Known items handed over

1. The dropped VddA18 well-tie strip: the tie block that remains is the original n-tap of the pixel enlarged; if the strip was placed for a well-tap-distance rule, DRC does not show it (0/0 with the precheck deck).
2. The 2x2-level GndA tie blocks are inside the pair-mirror band under r17b's GndA li strap (same net) and abut the pixel's own tap fingers; they merge.
3. `contact$26$1$1`: the submission keeps the original via cell. The narrowed version in nic2025_openDVS should be reverted there.
4. Behaviour (Magic-RCC bench on r17b, to be repeated on r18b): reset test bench clean at nominal bias (vdiff 0.864 V, no ON); gain 0.307 V per e-fold; PVT/bias matrix 34/36 (fires at RefrBp 3 nA + DiffBn 10 nA and at OnBn 70 nA + DiffBn 10 nA); 64-pixel GndD/readLine stress bench clean; the only harmful timing is a row/column edge inside ~1 µs of the reset release (periphery timing: rowReadOFF ≥ 3 µs after pixRst); a readLine pulse at 95 pA dips vdiff by 26 mV on the Magic netlist (r15a 15 mV), being re-checked on r18b.

## 5. Precheck status

cf_precheck 1.3.7 (image `chipfoundry/mpw_precheck:latest`, sky130A mirrored from rpgraca-ini) on the merged wrapper, 2026-09-23 00:13–00:45: topcell_check pass (single top), gpio_defines pass, xor 0 differences, klayout_feol / klayout_beol / klayout_offgrid / klayout_met_min_ca_density / klayout_pin_label_purposes_overlapping_drawing / klayout_zeroarea "No DRC violations found", spike_check "No spikes found", illegal_cellname_check pass. The LVS + OEB stage (`run_be_checks`, with the regenerated `pixel_4tile_layout_lvs2.spice` and `pixel_test_structure_layout_lvs.spice`) was started at 00:45 and takes a few hours; its result will be reported separately. The collaborators' own run of this stage on the original wrapper ended in the top-port-order LVS report and the vssa* OEB tooling artefact documented in `failures_analysis.md`; the same outcome is expected.

## 6. Reproduction

Scripts (workstation `~/opendvs_final/`, mirrored in the session artifacts `final-gds-drive/scripts/`): `merge_final.py` (merge + verification), `microfix.py` (the three fixes), `subtrees.py`/`export2x2.py`, `drc_merged.sh`/`drc_attrib.sh` (precheck deck), `tile_b.sh` (Magic extraction + netgen, in the `chipfoundry/mpw_precheck` image via podman), `precheck_setup.sh` (cf_precheck project skeleton and run). PDK: sky130A mirrored from rpgraca-ini (`~/pdk/sky130A`). Magic 8.3.471 / KLayout 0.29.12 / netgen from the precheck image; DRC decks run natively with KLayout 0.30.12 (same results as the image's 0.29.12 on the wrapper).
