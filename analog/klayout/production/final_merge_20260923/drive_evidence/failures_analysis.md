# OEB (Open Electrical Budget) FAILURE — ROOT CAUSE, FIX ATTEMPTS, RECOMMENDATION

**Date:** 2026-09-20 · **Run:** `cf precheck` (failed OEB) · **Design:** OpenDVS user_project_wrapper (Analog-macro)
**Status:** Documented. **No image rebuild performed.** No push without express permission.

---

## 1. WHAT OEB CHECKS (and why it matters)

The `cf precheck` OEB (Open Electrical Budget) check runs **CVC** against the design's extracted
`user_project_wrapper.cdl.gz`. CVC uses the power definition file
`lvs/user_project_wrapper/cvc.power.user_project_wrapper` (specified in `lvs_config.json`) to know
which nets are power/ground (`vssa* 0.0`, `vssd* 0.0`, `vdda* 3.3`, `vccd* 1.8`) and which pins are
I/O, then verifies every gate/IO has a valid power path (open-electrical-budget). **It only runs
meaningfully if a model/power/fuse file loads successfully.**

## 2. THE FAILURE SYMPTOM

`precheck_results/20_SEP_2026___05_12_00/logs/OEB_check.log`:
```
CVC: 730457(730457) instances, 362927(362927) nets, 759089(759089) devices.
ERROR: could not expand signal vssa* signal vssa* not found
ERROR: Could not find net vssa*
Power definition error
CVC: Setting models ... skipped due to problems in model/power/fuse files
... No warnings or errors detected
```
The "No warnings or errors detected" is **vacuous** — CVC skipped model-setting because the power
file's `vssa*` pattern could not expand. OEB therefore did NOT analyze anything.

## 3. ROOT CAUSE (proven by extraction comparison)

**The extracted CDL is missing `vssa1` and `vssa2` at the wrapper's top level.** Comparison of the SAME
design's two extractions:

| Power net | FLOW netgen extraction (verified LVS-clean) | PRECHECK OEB extraction (fails) |
|---|---|---|
| `vssa1` | **3 refs + matched in netgen report** | **0** |
| `vssa2` | **5 refs + matched** | **0** (present only inside macro subckts) |
| `vdda1/2`, `vssd1/2`, `vccd1/2` | present | present |

The flow's top-level `.subckt user_project_wrapper` has `vssa1 vssa2`; the precheck's CDL drops
**exactly** `vssa1 vssa2`. Since the `cvc.power.user_project_wrapper` file says `vssa* power 0.0`,
CVC's glob fails → models skipped.

**Mechanism (why it only affects the precheck, not the flow):**
- The **flow's Netgen.LVS** extraction (LibreLane `Magic.SPICEExtraction`) does NOT run the precheck's
  `abstract.tcl` step → keeps `vssa1/vssa2` → we verified them matched in netgen (LVS_CLEAN.md).
- The **precheck's** `run_extract` builds macro abstracts via
  `cf_precheck/be_checks/run_extract` (baked in the `chipfoundry/mpw_precheck` image at
  `/usr/local/lib/python3.9/site-packages/cf_precheck/be_checks/run_extract`). Its `abstract.tcl`
  heredoc runs, on **every child-bearing or >10-port cell**:
  ```tcl
  lef nocheck vssd1 vssd2 vccd1 vccd2 vssa1 vssa2 vdda1 vdda2
  lef write $cell -hide -pinonly
  ```
  The **new foundry-fixed pixel_4tile GDS is hierarchical (has child instances)** → it hits this branch
  → its `vssa1/vssa2` ports are told "not checked" and stripped by the pin-only LEF export → they
  never surface at the wrapper top → CVC `vssa*` can't expand.

**The `cvc.power` file is correct and unchanged** (verified `vssa* power 0.0` present); it is not the
cause. The design is electrically correct for vssa (flow netgen matched it).

## 4. FIX ATTEMPTS

### Option 1 — Patch `run_extract` `lef nocheck` (the true fix, CF-side)
**Attempted (host):** removed `vssa1 vssa2` from the `lef nocheck` list in the HOST copy of
`cf_precheck/be_checks/run_extract`:
```diff
- lef nocheck vssd1 vssd2 vccd1 vccd2 vssa1 vssa2 vdda1 vdda2
+ lef nocheck vssd1 vssd2 vccd1 vccd2 vdda1 vdda2
```
Backups: `run_extract.bak_pre_v4` (host) + `/tmp/run_extract.bak`. **Reverted after testing** (not
effective, see limitation).

**MOUNT LIMITATION (why the host patch does not work for `cf precheck`):**
`cf precheck` runs the `chipfoundry/mpw_precheck:latest` container with a **fixed mount list** —
verified in `chipfoundry_cli/main.py` `precheck()` (docker_cmd ~lines 4930-4938):
```
docker run --rm --init \
  -v {project_root}:{project_root} \
  -v {pdk_root}:{pdk_root}   \
  chipfoundry/mpw_precheck:latest ...
```
Only **project_root + pdk_root** are mounted. The container uses its **baked**
`/usr/local/lib/python3.9/site-packages/cf_precheck/` (NOT the host venv's copy). Therefore a host
patch to `site-packages/cf_precheck/be_checks/run_extract` **does not reach the running check**.
No bind-mount of host site-packages exists to override it.
**A real fix requires rebuilding/tagging the image with the patch** (or CF shipping it). Per the user
directive, **no container was built** — this is documented for the ChipFoundry support ticket.

### Option 2 — `EXTRACT_FLATGLOB=[pixel_4tile]` (config-driven, no image build) — **TESTED, FAILS**
Set in `lvs_config.json` `EXTRACT_FLATGLOB=["pixel_4tile"]` (flatten the macro → fewer children →
hope it skips the abstract branch), then `cf precheck --checks oeb`:
- Result: **OEB FAILED (stat=5)**, worse than before:
  `Fatal error: could not find subcircuit: user_project_wrapper`; CDL only 20 bytes (empty).
- The flatten broke the extraction (magic+CVC couldn't compose a valid top). **Not viable.** Reverted.

## 5. CONCLUSION / RECOMMENDATION

- **The OEB failure here is a precheck-tooling artifact** (the `lef nocheck vssa*` abstraction of the
  new hierarchical analog macro), **not a design/electrical defect.** Independent evidence: the flow's
  own Netgen.LVS extraction keeps `vssa1/vssa2` and they **match** layout↔netlist (LVS_CLEAN.md §5).
- **No OEB pass is achievable on this box cleanly** via config: FLATGLOB breaks extraction; the real
  fix (patch `lef nocheck`) requires image rebuild which we are explicitly NOT doing.
- **Recommended:** document OEB as "vacuous-by-construction for this analog-macro design" + send this
  file to ChipFoundry (there is already an LVS support ticket). The `cvc.power` file is correct; the
  ask to CF is the `lef nocheck vssa1 vssa2` abstraction of user macros in `run_extract`.
- **Push decision:** rests on the flow's LVS_CLEAN proof + the 12/13 (all-but-LVS) precheck record;
  OEB documented as N/A-by-tooling. **No push without explicit user permission.**

## 6. ARTIFACTS / STATE

- `lvs/user_project_wrapper/lvs_config.json` — restored to baseline (FLATGLOB=[''], NOFLATTEN=4
  macros, stub `_lvs_lef.spice` LVS_SPICE_FILES). Backup: `lvs_config.json.bak_pre_oeb`.
- Host patch artifact: `cf_precheck/be_checks/run_extract.bak_pre_v4` (for CF reference only).
- OEB failure logs: `precheck_results/20_SEP_2026___05_12_00/logs/OEB_check.log`,
  `precheck_results/20_SEP_2026___07_15_42/logs/OEB_check.log` (FLATGLOB attempt).
- Power file: `lvs/user_project_wrapper/cvc.power.user_project_wrapper` (correct, unchanged).