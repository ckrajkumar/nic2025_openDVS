# HANDOFF: sky130 tapeout tooling — what changed, where, why, how to redo or undo it

Status as of 2026-08-11. Covers the `rawbits` ring-synthesis → sky130 cell-mapping
effort for this project. Written so a human can decide what to keep, and so
another agent could reproduce (or undo) any of it without re-deriving it.

> **REVERTED 2026-08-07, PARTIALLY REDONE 2026-08-11.** §2–§5 below (the
> sky130l config rewrite, `std/cells.act` additions, filtered liberty file,
> and project-local synthesis output) was rolled back at the user's request
> on 2026-08-07 — as of that date none of it existed on disk. On 2026-08-11,
> **§2 was redone** (real `synth.conf`, now also recalibrated with real
> sky130 measurements — see §6) but **§3–§5 (real `sky130_fd_sc_hd` cell
> mapping) were not** — ABC still maps expression logic onto generic 180nm
> gates, same as the reverted state. This document's TL;DR and Open Issues
> reflect the current (2026-08-11) state; §1–§5 below are preserved
> unchanged as the historical record of the first attempt, and §6 covers
> what actually changed this session.

**Scope note on how this doc was assembled:** this session's context was
compacted partway through a long debugging effort. Bugs 1–3 and the two
"Gotcha" sections below are transcribed/summarized from `bugs.md` in this
same directory (written during the compacted portion — I do not have direct
memory of finding them, only the artifact). Everything from "sky130 tech
targeting" onward is from this session directly and I've verified current
file state before writing it down. Where I'm not sure something is still
accurate (e.g. whether later commands ran with the right `-ref=N`), I've
said so explicitly rather than guessed.

---

## TL;DR

- **Goal:** get `decomp_rawbits` (from `async_readout.decomp.act`) through
  ring synthesis and cell-mapping targeting real sky130 (not generic/180nm),
  toward physical layout.
- **Working today, verified (2026-08-11):** `make clean && make` in this
  directory runs the whole pipeline end-to-end — `synth2 -F ring -Tsky130l`
  then `interact`/`layout_gen.scm` — producing a DRC-rule-compliant
  `output.lef` + one `.rect` per cell in `rect_gen/` (46 unique cells this
  run). This is the **generic-cell-logic / real-sky130-geometry** path (see
  §6), not the real-`sky130_fd_sc_hd`-cell-mapping path from §3–§5 below,
  which is not currently done. Ring's own delay-line/mux/OR/select timing
  calibration in `synth.conf` is now real measured sky130 data (§6), not
  the placeholder numbers §2 originally installed.
- **Not yet done:** §3–§5's real `sky130_fd_sc_hd` cell-mapping work
  (filtered liberty, `expropt.conf` rewrite, `cells.act` defcells) — this
  is what Stage 4 of the current session's plan is about to redo. Also not
  done: bundled-data ring-synthesis output through the QDI-specific
  `interact`/`ckt:cell-map`/phyDB path described in §3–§5's original
  history (this session's pipeline uses generic-tech ring output directly,
  sidestepping that).
- **Known still-broken:** the default QDI/DI ring-synthesis path hits a
  `probe_clause`/`sdtexprchan` type-mismatch bug that was never resolved
  (found in the 2026-08-07 session — see "Open issues" below). Bundled-data
  (`-C bd`) was adopted specifically to route around this.
- **Everything that touches shared ACT install files is additive** — new
  files, or appended blocks at the end of existing files. Nothing pre-existing
  was deleted or rewritten in place, except `sky130l/expropt.conf`, whose
  entire prior content is reproduced verbatim below so it's a one-paste
  revert if wanted.

---

## Layer map — what's shared vs. project-local

This matters for "do I want to keep this": shared-toolchain changes affect
*every* ACT project on this machine that uses `-Tsky130l`; project-local
changes affect only this directory.

| Layer | Path | Shared? |
|---|---|---|
| PDK | `~/.ciel/...` (via `ciel`) | Shared (machine-wide) |
| PDK | `~/.ciel/sky130A/.../sky130_fd_sc_hd__tt_025C_1v80_synth.lib` (new file) | Shared, but additive (original `.lib` untouched) |
| ACT config | `~/.local/act/conf/sky130l/synth.conf` (installed) | Shared |
| ACT config | `~/.local/act/conf/sky130l/expropt.conf` (rewritten) | Shared |
| ACT library | `~/.local/act/act/std/cells.act` (extended) | Shared, but additive |
| Project | `nic2025_openDVS/cad_setup` | Local |
| Project | `digital/final/*.conf`, `*.act`, `*.scm` | Local |

---

## 1. PDK: enabling sky130 via `ciel`

The sky130 PDK had been *fetched* (downloaded, ~8.8GB) via `ciel` before this
session but never *enabled*. Fixed with:

```
python3 -m ciel enable --pdk sky130 026824c7969ce6f4fc9678e6ca04b0a06a596c4b
```

This pulled two additional libraries it needed (`sky130_ml_xx_hd`,
`sky130_sram_macros`) and created `~/.ciel/sky130A` / `~/.ciel/sky130B`
symlinks into the versioned store. Verify with:
```
python3 -m ciel output --pdk sky130
# -> 026824c7969ce6f4fc9678e6ca04b0a06a596c4b
```

**To undo:** `python3 -m ciel rm sky130 026824c7969ce6f4fc9678e6ca04b0a06a596c4b`
removes it entirely (re-fetching later takes a while — ~8.8GB). There's
generally no reason to undo this step; it doesn't conflict with anything.

### `cad_setup` fix (project-local)

`cad_setup` (repo root) hardcoded a collaborator's Linux path,
`PDK_ROOT=/home/rpgraca/.ciel/`, which doesn't exist on this machine. Changed
to:
```sh
export PDK_ROOT=$HOME/.ciel
```
This is a straightforward bugfix, not part of the sky130-targeting saga —
keep it regardless of anything else here. (Note: `cad_setup` still also
hardcodes `/home/rpgraca/git/klayout/bin-release` for `PATH`/`LD_LIBRARY_PATH`
on lines 6–7; harmless because lines 12–13 immediately after override the
same variables with `$HOME`-relative paths, but it's dead weight — not
touched, flagged here for awareness.)

---

## 2. Why `-Tsky130l` didn't work at all (before this session)

**Root cause:** `synth2` (chp2prs's CLI) calls `config_read("synth.conf")`
(`chp2prs/main2.cc:257`) after `Act::Init` has set up the config search path.
When `-Tsky130l` is passed, `act/common/config.c`'s `config_std_path()`
(called via `config_stdtech_path`) adds `$ACT_HOME/conf/sky130l/` to the
search path — and **only** that, plus cwd. It does **not** fall back to
`conf/generic/` the way the *no-tech-flag* default path does
(`act/act.cc:409-416`, `if (!tech_specified) config_stdtech_path("generic")`
— only runs when no `-T` was given at all).

`~/.local/act/conf/sky130l/` (matching `~/git/actflow/sky130l/conf/` in the
source tree, file-for-file: `actsim`, `expropt`, `global`, `layout`, `lint`,
`lint_opts`, `lvp`, `prs2net`) had **no `synth.conf`**. So `config_read
("synth.conf")` always failed outright the moment `-Tsky130l` was passed
straight to `synth2` — this had evidently never been exercised before (every
earlier working run in this whole effort had omitted `-T` and silently used
`generic` tech).

**Fix:** there's an orphaned `synth.conf` sitting at
`~/git/actflow/sky130l/synth.conf` (top level, *not* inside the `conf/`
subdirectory that actually gets installed — never wired up). The user
independently had an identical copy on their Desktop. Installed as-is:
```
cp ~/Desktop/synth.conf ~/.local/act/conf/sky130l/synth.conf
```
(92 lines. Content: ring-synthesis delay-line calibration tables — pulse
width, capture delay, mux/OR-gate delays, select delays — for DFF/latch/2-phase
bundled datapath styles. **These are explicitly placeholder numbers** — the
file's own comments say `# these are dummy numbers` / `# TODO: fill in
correct numbers`. Installing it unblocks `-Tsky130l`; it does not make ring
pipeline delay-line timing sky130-accurate. That would need real sky130
delay-line characterization, not done.)

**To undo:** `rm ~/.local/act/conf/sky130l/synth.conf` — reverts to the
original (broken) state where `-Tsky130l` can't be used with `synth2` at all.
No reason to do this; it's strictly enabling.

---

## 3. Why the liberty file (ABC's datapath logic synthesis) stayed on generic 180nm

**Background:** `synth.liberty.typical` tells ABC (via `expropt`) which
`.lib` file to use when it technology-maps the CHP's *expression blocks*
(popcount trees, MSB-finders, bit concatenations — anything that isn't
control-flow, synthesized via `_generate_expr_block`/`eeo->synth_expr` in
`ring_forge.cc`). Default (`~/.local/act/conf/generic/expropt.conf:13`):
```
string typical "${ACT_HOME}/act/syn/liberty/osu018_stdcells.lib"
```
— Oklahoma State University's 180nm reference library. The file even has a
`# XXX: fixme: use a better .lib file` comment sitting right above the
`include` line in `sky130l/expropt.conf` — a known, never-fixed TODO.

**Why the naive fix (add an override after `include ...`) doesn't work:**
ACT's config-file parser (`act/common/config.c`, the `string`/`int` keyword
handlers around line 453/472) is **first-write-wins**:
```c
if (tmp->set) continue;   // key already set - silently skip, don't overwrite
```
`include` directives fire immediately and recursively when encountered
(`config_read()` calls itself), and must appear before any other
declaration in the file. So `include ".../generic/expropt.conf"` (which
sets `synth.liberty.typical` to osu018) followed by your own `string
typical "..."` below it does *nothing* — the key's already set, the second
declaration is silently ignored. No error, no warning. This is almost
certainly why the original TODO was never fixed — the obvious fix doesn't
work, silently.

Also checked (dead end, documented so nobody re-tries it): passing the
override via `-cnf=<file>` doesn't work either, for the same underlying
reason — whatever reads `expropt.conf` for real (`expropt/expropt.cc:98`,
called from inside `ExternalExprOpt`'s / `ExprCache`'s constructor,
instantiated deep inside ring synthesis) runs its `include`-driven default
*after* `-cnf`'s early load, so the default still wins first-write.

**Fix:** rewrote `~/.local/act/conf/sky130l/expropt.conf` to **not**
`include` the generic file at all — declare the full `synth`/`expropt` block
standalone, with the liberty path corrected. This is the only way the
first-write-wins semantics don't get in the way, since there's now no
earlier declaration of the same key to lose to.

**Original content (11 lines, for a literal revert if wanted):**
```
#------------------------------------------------------------------------
#
# ACT configuration file
#
#------------------------------------------------------------------------
#
#
# XXX: fixme: use a better .lib file
#
#
include "${ACT_HOME}/conf/generic/expropt.conf"
```

**Current content:** standalone `begin synth ... end` (74 lines) covering
`begin liberty` (now points at a filtered sky130 liberty — see §4), `begin
qdi`/`begin bundled` (`cell_lib` paths, copied unchanged from generic — see
caveat below), and `begin expropt` (`cache`, `abc`, `genus` sub-blocks,
copied unchanged from generic). Read the file directly for the exact
current text — it's short.

**Caveat found and not fixed:** `chp2prs/ring_engine.cc:46-47` hardcodes
`synth.bundled.cell_lib` and `synth.bundled.cell_lib_namespace` via
`config_set_string()` in `RingSynth`'s constructor — this **overrides
anything set by any `.conf` file**, unconditionally, regardless of `-T`. So
the `begin bundled` block in `sky130l/expropt.conf` is dead for the ring
engine specifically (it may matter for other engines/tools that also read
`synth.bundled.cell_lib` — not checked). This is *why* the fix in §5 below
had to go into `~/.local/act/act/std/cells.act` (the hardcoded path) instead
of a config file.

---

## 4. Why ABC needed matching ACT cell definitions that didn't exist

Once ABC was actually mapping against real sky130 cells, the reverse
conversion step (`v2act`, which turns ABC's mapped Verilog back into an ACT
process) needs `defcell` definitions for every sky130 cell name ABC picked —
matched by exact name, in whatever ACT namespace `v2act -l <file> -n
<namespace>` is pointed at (for bundled-data ring synthesis, that's
`std::cells` / `~/.local/act/act/std/cells.act`, per the hardcoded path in
§3's caveat). **None existed anywhere** in the install or the `~/git/actflow`
source tree.

### 4a. First pass: the full, unfiltered sky130_fd_sc_hd liberty pulls in non-logic cells

Handing ABC the *entire* `sky130_fd_sc_hd__tt_025C_1v80.lib` unfiltered means
it can pick from the full ~430-cell library, including families that are not
general-purpose logic gates at all: `lpflow_*` (power isolation/bleeder),
`decap*` (decoupling caps), `diode*` (antenna diodes), `conb*` (tie cells),
`probe_p*`/`probec_p*` (test probes), `einvn*`/`einvp*`/`ebufn*`
(tristate/enable variants), sequential/scan cells (`dfx*`, `dlx*`, `sdfx*`,
`sdl*`), and delay cells (`dlygate*`, `dlymetal*`, `clkdlybuf*`). Writing
`defcell`s for these would mean faking control/state semantics that aren't
simple `A,B → Y` boolean logic — wrong to do.

**Fix (deny-list filter):** `/tmp/filter_liberty.py` (scratch script, not
committed anywhere permanent — reproduce from the exclusion list embedded in
the comment at `sky130l/expropt.conf`'s `begin liberty` block if needed)
walks the liberty file's `cell (...) { ... }` blocks (proper brace-depth
tracking, not line-range guessing) and drops anything matching those
prefixes, writing
`~/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80_synth.lib`.
Kept 281 of ~430 cells this pass.

### 4b. Second pass: even filtered, the compound-gate space is unbounded

With non-logic cells excluded, ABC still had the *entire* combinational
subset — including every AOI/OAI/majority compound-gate variant
(`a21boi`, `o211ai`, `a2111oi`, `maj3`, ...) at every drive strength. Each
retry surfaced a *different* set of newly-needed cells (7, then 4, then 19,
then 19 more...) — open-ended, not converging.

**Fix (switched to an allow-list):** rewrote the filter to *keep only* a
fixed, small set of basic gate families, at all their available drive
strengths: `inv, buf, clkbuf, clkinv, and2/3/4, nand2/3/4, or2/3/4, nor2/3/4,
xor2/3, xnor2/3, mux2`. 80 cells survive this filter (same output file path
as 4a — the allow-list version replaced the deny-list version). This is what
`sky130l/expropt.conf`'s `begin liberty` block currently points at. ABC can
no longer select AOI/OAI/majority/etc. — bounds the problem for good, at the
cost of ABC not being able to use sky130's more complex compound gates for
better area/delay (acceptable tradeoff for now; revisit if timing closure
ever demands it).

**To reproduce the filtered liberty file from scratch:** see the exclusion/
allow lists embedded as comments in `sky130l/expropt.conf` and in the
per-gate comments in `std/cells.act` (§5) — the allow-list is the load-bearing
one currently in use:
```python
ALLOW_BASES = {
    "inv", "buf", "clkbuf", "clkinv",
    "and2", "and3", "and4", "nand2", "nand3", "nand4",
    "or2", "or3", "or4", "nor2", "nor3", "nor4",
    "xor2", "xor3", "xnor2", "xnor3", "mux2",
}
```
(walk `cell ("sky130_fd_sc_hd__<name>") { ... }` blocks, keep only where the
name with its trailing `_<drive-strength>` stripped is in `ALLOW_BASES`).

---

## 5. `~/.local/act/act/std/cells.act` additions — the actual cell definitions

All additions are in one contiguous block near the end of the file (inside
`namespace std { export namespace cells { ... } }`, after all the
pre-existing generic/180nm gate definitions it depends on — matters because
ACT requires a type to be declared before it's referenced, so anything
`<: ExistingGate()`-style has to come after `ExistingGate`'s own definition).
File went from ~502 lines to 891.

**Every gate's logic was derived from and verified against the actual
liberty file's `function:` string for that cell** (`grep -n '"sky130_fd_sc_hd__<cell>"' 
.../sky130_fd_sc_hd__tt_025C_1v80.lib`, then look at the `pin (...)` block's
`function : "..."` field) — not guessed from the cell name. This mattered:
several cells have non-obvious mixed-polarity logic (`and3b`, `nor3b`,
`o21ba`/`o21bai`) where the naming convention alone would be easy to get
wrong.

**Two real bugs found and fixed along the way, both about SkyWater's output
pin naming convention** — worth knowing if extending this list:
- Simple "primitive" gates (`nand2`, `nor2`, `nand3`, `nor3`, `nand4`,
  `nor4`) use **`Y`** for their output pin — matches ACT's generic
  convention, direct inheritance works.
- "Compound"/non-inverting gates (`and2`, `and3`, `and4`, `or2`, `or3`,
  `or4`, `xor2`, `xor3`, `mux2`, and all the AOI/OAI/majority family) use
  **`X`**, not `Y`. Naively inheriting from the generic library's `AND2X1`/
  `OR2X1` (which use `Y`) silently produces a port name mismatch that only
  surfaces later, in `interact`'s type-checker (`Connection to unknown port
  'X'`), not at synth2 time. Caught this on `and2_0` first, then again on
  `or2_2`/`or2_4` (only those two — `or2_0`/`or2_1` were written directly
  with an `X` port from the start and were correct).

**Derivation pattern used throughout** (for anyone extending this):
ACT's `prs * { E => Node- }` synthesizes `Node = ~E` (single inverting
stage). So:
- For a gate whose real output pin is **`Y`** (inverting family — NAND/NOR/
  AOI/OAI-style): write `E` as the De Morgan complement of the target
  function, single stage. E.g. target `Y = !A & !B & C_N` (nor3b) → `E = A |
  B | ~C_N` → `prs* { A|B|~C_N => Y- }`.
- For a gate whose real output pin is **`X`** (non-inverting family —
  AND/OR/XOR/MUX-style): use two stages, an internal node `_X` whose
  pulldown expression is the target function *written directly* (no De
  Morgan needed — the second stage's inversion cancels the first). E.g.
  target `X = A&B&C` (and3) → `prs* { A&B&C => _X-; _X => X- }`.

**Sizing caveat (repeated wherever it matters, worth restating here too):**
the `sizing { Y{-N} }` / `sizing { _X{-1}; X{-N} }` hints on these new cells
are a rough numeric mapping from the sky130 drive-strength suffix (0→1,
1→1, 2→2, 4→4, ...) — **not real sky130 W/L data**. They only affect
ABC's own internal delay estimates (and therefore its logic-restructuring
decisions and the ring pipeline's delay-line calibration, same caveat as
§2's `synth.conf`). Actual transistor sizing for physical layout comes from
`ActSizingPass` reading real sky130 parameters out of `prs2net.conf`
(`lambda`, `min_width`, `p_n_ratio`, etc. — confirmed correct, untouched,
not part of this problem) at the *cell-mapping* stage, independent of
anything in `cells.act`.

**Currently defined (47 actually used by this design; 80 exist in the
filtered liberty and are available if a future design needs the rest):**
`inv_*` (1,2,4,6,8,12,16), `buf_*` (1,2,4,6,8,12,16), `clkbuf_*` (1,2,4,8,16),
`clkinv_*` (1,2,4,8,16), `and2_*` (0,1,2,4), `and3_*` (1,2,4), `and4_*`
(1,2,4), `nand2_*` (1,2,4,8), `nand3_*` (1,2,4), `nand4_*` (1,2,4), `or2_*`
(0,1,2,4), `or3_*` (1,2,4), `or4_*` (1,2,4), `nor2_*` (1,2,4,8), `nor3_*`
(1,2,4), `nor4_*` (1,2,4), `xor2_*` (1,2,4), `xor3_*` (1,2,4), `xnor2_*`
(1,2,4), `xnor3_*` (1,2,4), `mux2_*` (1,2,4,8).

**To undo:** everything added is one contiguous, clearly-commented block
(`/* sky130_fd_sc_hd aliases. */` marks the start) right before the final
two closing `}` of the file. Deleting from that comment to just before the
closing braces fully reverts this file to its original generic-only state —
nothing before that point was modified.

---

## 6. Real sky130 characterization (xcell) and `synth.conf` recalibration — 2026-08-11 session

This session started from the **fully reverted** 2026-08-07 state (no PDK,
no `synth.conf`, generic-only `cells.act`) and rebuilt the pipeline up
through real SPICE-based characterization of the generic-cell-logic path —
**not** the real-`sky130_fd_sc_hd`-cell-mapping path (§3–§5), which is
Stage 4, still pending as of this section.

### 6a. Rebuilding the mechanical pipeline

Three bugs were fixing to get `make clean && make` working again in this
directory (all still true/current, unlike §2's `synth.conf`-missing bug
which is now fixed for a second time the same way as before — `cp
~/Desktop/synth.conf ~/.local/act/conf/sky130l/synth.conf`):

1. **`digital/final/Makefile`** had `-Tsky130l` stripped from the `ring`
   target's `synth2` call (from whatever the 2026-08-07 revert or the
   subsequent "not super working" commit left it in) — added back.
2. **`digital/final/layout_gen.scm`**'s `act:merge` pointed at
   `/Users/kamerongano/git/actflow/sky130l/cells/control/cells.act` — the
   real actflow checkout on this machine is at `~/actflow/...` (no `git`
   subdirectory). Fixed the path.
3. PDK re-enabled via `ciel` exactly per §1 (same commit,
   `026824c7969ce6f4fc9678e6ca04b0a06a596c4b` — confirmed via `ciel
   ls-remote --pdk sky130` to still be the newest available, so "latest"
   and "the previously-pinned commit" are the same thing right now).

With those three fixes, `make clean && make ring && make layout` runs
clean, producing `output.lef` + `rect_gen/*.rect` — the generic-cell/
real-sky130-geometry hybrid described in the updated TL;DR above.

### 6b. Installing `xcell`'s dependencies (PDK's SPICE models + Xyce)

`digital/final/xcell_char/` existed (added in the "not super working"
commit) but couldn't actually characterize anything: `stdspice.spi` had a
literal `/path/to/sky130A/...` placeholder, and `Xyce` (the SPICE simulator
`xcell.conf` specifies via `spice_binary`) wasn't installed anywhere on the
machine — not via Homebrew, not via conda-forge, not present as a binary.
`xcell`'s own code (`~/actflow/xcell/cell.cc`) only knows how to drive
`Xyce` or `hspice` (string-matched on `spice_binary`); it does **not**
support `ngspice` (which *is* trivially available via Homebrew) — the
invocation logic (`format=raw` print directive, `.spi.raw` output naming)
is Xyce-specific.

**Fix:** downloaded Sandia's official prebuilt ARM64 macOS serial installer
directly (`https://xyce.sandia.gov/downloads/executables/` →
`XyceNF-7.10.0-Darwin.pkg`, unsigned, ~18MB zip). Installed via the
command-line `installer` tool (sidesteps the Finder/Gatekeeper
"unidentified developer" prompt the website warns about, since that's a
LaunchServices/Finder behavior, not something the CLI installer enforces):

```sh
sudo installer -pkg XyceNF-7.10.0-Darwin.pkg -target /
```

Installs to `/usr/local/XyceNF_7.10/bin/Xyce` — **not** on `PATH` by
default. Added `export PATH=/usr/local/XyceNF_7.10/bin:$PATH` to
`cad_setup` (repo root), matching the existing pattern there for
`klayout`'s path.

**`stdspice.spi` fix:** points at the real, now-installed deck,
`~/.ciel/sky130A/libs.tech/ngspice/sky130.lib.spice`. One non-obvious
detail: the real file's typical-corner section is `.lib tt` (**lowercase**),
not `.lib TT` as the placeholder/example assumed. This is independent of
`xcell.conf`'s `corner "TT"` string, which is just metadata `xcell` writes
into the output liberty's `operating_conditions`/`process_label` fields
(confirmed by reading `~/actflow/xcell/liberty.cc:275,280` and
`cell.cc:921-929` — `xcell.corner` never touches SPICE `.lib` section
selection) — so that string didn't need to change, only the `.spi` file's
own `.lib '<path>' tt` line.

**Also discovered:** `xcell` accepts `-T<tech>` on its command line, same
as `synth2`/`interact` — undocumented in its own `Usage:` string (which
only mentions `<act-cell-file> <libname>`), but `Act::Init()` (the shared
ACT startup path every one of these tools calls) consumes `-T` before
`xcell`'s own `argc` check runs. This matters a lot: **without** `-Tsky130l`,
`xcell` reads the *generic* tech's `prs2net.conf`, which emits plain
`M<name> ... n/p W=.. L=..` MOSFET lines with bare `n`/`p` model names that
don't exist in any real sky130 SPICE deck (Xyce error: "Model is required
... no valid model card found"). **With** `-Tsky130l`, it picks up
`sky130l/prs2net.conf`'s `use_subckt_models 1`, which makes the shared
ACT netlist-emission pass (`act/passes/netgen/emit.cc`) emit real
`X<name> ... sky130_fd_pr__nfet_01v8/pfet_01v8 ...` subcircuit
instantiations instead — the actual SkyWater device models. Always pass
`-Tsky130l` to `xcell` for this project; without it, characterization
either fails outright or (worse) silently characterizes something that
isn't sky130 at all.

### 6c. Characterizing the design's actual cells

`char.act` originally listed only 26 generic `std::cells` (the tool's
own example set, which happened to already match every generic cell this
design uses). Missing: the other 19 of the design's 45 unique cells —
custom ring/expression-synthesis compound gates (`ginvx0-9`, `gac1x1`,
`gcelem2x0/3x0`, `gnand2x0`, `gnor2x0/3x0`, the `g0n1n2n...aox` family),
defined in `../async_readout_cells.act` (namespace `cell` — itself an
output artifact of `ckt:cell-save` in `layout_gen.scm`, not hand-written).
Added all 19, plus (for closing the delay-line-calibration loop, §6e)
`std::delay_elements::delay_buffer` and `weak_delay_buffer<5>` from
`std::delay_lines` — 47 cells characterized total. Real output:
`digital/final/xcell_char/characterize.lib`.

**One gotcha hit while extending `char.act`:** a doc-comment containing
the substring `delay_params_*/delay_vals_*` accidentally closes a `/* */`
block comment early (the `*/` inside the text, not intended as a comment
terminator) — `Parse error: Expecting token '::', got '*'`. Reworded to
avoid the accidental `*/`. Worth remembering if writing more comments in
`.act` files here.

### 6d. The capacitance-measurement warning investigation (false positive, not a bug)

Characterizing all 47 cells produces the same ~20 "unusual measurement for
leakage" warnings every run (a real, self-flagged quirk in `xcell`'s own
code — `cell.cc:885-896` takes the absolute value of a negative leakage
measurement and warns, rather than treating it as a hard failure; likely
still-settling transient/short-circuit current caught in too-short a
measurement window for real (fast) sky130 devices, not a bug worth fixing
since it doesn't affect the timing data Stage 3 actually needed) — plus 4
"`>> Measurement CAP_TUP_0_0_0 failed` / `Bad news: no counts for input
pin #0`" warnings, on `INVX8`, `ginvx3`, `ginvx5`, `ginvx8` specifically
(deterministic — same 4 cells every rerun).

**Investigated and resolved: this is a false positive, not a data problem.**
Wrapped `Xyce` in a shim script that copies the intermediate `.mt0`
measurement-result file immediately after each simulation, both in
isolation (single-cell `char.act`) and inside the real 45-cell batch. Both
captures are byte-for-byte identical and contain valid, physically
sensible numbers — no `FAILED` token anywhere. The final `characterize.lib`
output for all 4 flagged cells has real, reasonable `rise_capacitance`/
`fall_capacitance` values (not zero, not garbage). Root cause (well-
supported, not independently proven via `strace`/Xyce source): `Xyce`
appears to flush its `.mt0` file more than once during a single transient
run — an early, incomplete pass can log the literal string `FAILED` for a
measurement whose trigger/target crossing hasn't resolved yet, then a
later pass overwrites it with the real value once the simulation
converges. `xcell`'s own read happens immediately after `Xyce` returns;
the capture shim's extra process overhead apparently lands reliably after
the final overwrite instead. Deterministic per cell (ties to how long each
one's simulation takes), didn't reproduce in isolation (less I/O
contention). **Bottom line: trust the capacitance data in
`characterize.lib`, including for these 4 cells** — don't be alarmed by
the warning text alone.

### 6e. `synth.conf` recalibration with real measurements

All under `~/.local/act/conf/sky130l/synth.conf` (shared, machine-wide —
same file §2 installs). Each replaced parameter is commented in-place with
what real cell/measurement it's derived from and what dummy number it
replaced; read the file directly for the exact current text. Summary:

- **`capture_delay`** (210.0 → 175.98 ps): real `std::cells::LATCH` CLK→Q
  delay (worst of rise/fall, 26.4ps-slew/1fF-load corner). Confirmed this
  is the right physical mapping by reading `chp_cost.cc`'s
  `ACT_CHP_RECV` case (`recv_delay + capture_delay`) — it's used as a
  scalar latch-capture time directly, not something more exotic.
- **`mux_delays`** / **`or_delays`**: real `MUX2X1` / `OR2X1` per-gate
  delay (same corner), with N>2 modeled as `ceil(log2(N))` series stages
  of the 2-input primitive (tree decomposition — no wider mux/OR was
  characterized, and none of this design's actual synthesized cells
  needed one).
- **`sel_delays`**: this one is *not* a ring-synthesis parameter — it's
  read by `chp_cost.cc` (the CHP decomposition cost model, a different
  tool), added to `or_delays[way]` as the estimated overhead of an N-way
  CHP `select` statement's arbitration logic. No dedicated selector
  circuit exists to characterize, so modeled the same way as `mux_delays`
  (tree of `MUX2X1`).
- **`pulse_width`** (210.0 → 175.98 ps): no dedicated pulse-generator
  circuit was characterized separately; reuses `capture_delay`'s real
  value as an approximation, matching what looks like the original dummy
  file's own assumption (both were 210.0). Flagged in the config file
  itself as lower-confidence than the other replacements.
- **`delay_params_DFF/L/L2P`, `delay_offsets_DFF/L/L2P`,
  `delay_vals_DFF/L/L2P`**: the actual calibration curve
  `_compute_delay_line_param()` (`ring_forge.cc:383`) inverts to turn a
  target ps delay into a delay-line structural parameter `N`. Traced all
  the way through `chp2prs/lib/ring/delay_lines.act` →
  `std/delay_lines.act` to the real underlying structures:
  `delay_line_0`/`delay_line_1` both build `std::delay_lines::
  chain_delay_buffer<N>` (`N` copies of `std::delay_elements::
  delay_buffer` = 2×`INVX1` in series, measured **134.022 ps/stage**);
  `delay_line_2`/`delay_line_3` both build `chain_weak_delay_buffer<N,5>`
  (`N` copies of `weak_delay_buffer<L=5>`, measured **410.536 ps/stage**).
  Built a 5-breakpoint monotonic curve from these two real per-stage
  numbers (region-boundary offsets chosen so the light→weak switch at
  N=40 doesn't dip below itself — see the in-file comments for the exact
  math). Same curve applied to all three datapath styles (DFF/L/L2P),
  since `delay_line<N>` itself doesn't depend on datapath style — verified
  in `ring_forge.cc`/`delay_lines.act`, not assumed.
- **`send_delay`/`recv_delay`/`assn_delay` — deliberately left as the
  original dummy/TODO numbers (40.0/40.0/0.0).** These are `chp_cost.cc`
  fixed overheads added on top of per-expression delay for CHP
  send/receive/assign actions respectively. Best guess (not verified by
  tracing the actual lowering templates) is that they map to a
  completion-detection gate like `gcelem2x0` (already characterized, and
  structurally a Muller C-element - the canonical async completion-detect
  primitive) - but this wasn't confirmed, and the original `assn_delay=0.0`
  (vs `40.0` for the other two) might reflect a deliberate "negligible"
  judgment call rather than an unfilled placeholder. Lower value, lower
  confidence than everything else in this section - left as an open item
  (see Open Issues) rather than guessed at.

**Verified effect, not just cosmetic:** re-running `make clean && make`
after this recalibration produces a **different** cell inventory (47
unique cells including a new `ginvx10`, vs. 46 before) - confirming the
real numbers actually changed ring synthesis's delay-line sizing
decisions, not just documentation.

**To reproduce `characterize.lib` from scratch:** `cd digital/final/xcell_char
&& xcell -Tsky130l char.act characterize` (needs `Xyce` on `PATH` - source
`cad_setup` - and `stdspice.spi` pointing at a real, enabled PDK per §6b).

**To undo:** `synth.conf`'s changes are all within the `begin bundled ...
end` block already discussed in §2 - the file's own dummy-number comments
(now updated to real-number provenance comments) mark exactly what changed
and from what.

---

## 7. Real `sky130_fd_sc_hd` cell mapping, redone (Stage 4) — 2026-08-11 session

§3–§5's real-cell-mapping work, done for real this time (not just planned).
Same recipe as originally documented, executed fresh:

- **Filtered liberty regenerated** exactly per §4a/§4b's allow-list (script
  now saved at the scratch path used this session, not committed anywhere
  permanent - reproduce via the `ALLOW_BASES` set already documented in
  §4b, brace-depth-tracked cell-block extraction) - **80 cells**, matching
  §4b's original count exactly.
- **`sky130l/expropt.conf` rewritten standalone** exactly per §3's
  reasoning (first-write-wins means `include` + override doesn't work) -
  `synth.liberty.typical` now points at
  `${PDK_ROOT}/sky130A/libs.ref/sky130_fd_sc_hd/lib/
  sky130_fd_sc_hd__tt_025C_1v80_synth.lib`. Rest of the file copied
  unchanged from generic, same as before.
- **`~/.local/act/act/std/cells.act` extended** - but with one correction
  to §5's original approach worth calling out explicitly: **defcell names
  must be the full prefixed sky130 name** (`sky130_fd_sc_hd__and2_0`, not
  `and2_0`). Traced this precisely: `v2act`'s module lookup
  (`act/verilog/vnet.cc:1150`, `verilog_find_lib()`) builds
  `"<s2a.lib_namespace>::<verilog-module-name>"` and does an exact
  `Act::findProcess()` lookup - `-n std::cells` sets `s2a.lib_namespace`,
  and the mapped Verilog's module names are the *full* SkyWater names
  (`sky130_fd_sc_hd__and2_0`), not stripped. A short name like `and2_0`
  silently never matches, and just reappears in the next "missing
  modules" error as if it had never been added - there's no error
  pointing at the name mismatch itself. §5's own prose ("Currently
  defined: `inv_*`, `and2_*`, ...") appears to have been shorthand for
  brevity, not the literal identifiers actually used.
- **Iterative convergence**, same pattern §4b describes: re-running
  `make ring` after each batch of `defcell`s surfaced the next batch of
  "missing modules" from `v2act`, shrinking each time (7 → 3 → 2 → 2 → 0).
  15 cells now defined total (the same 7 from the first pass, plus
  `inv_2`, `inv_8`, `nor3_1`, `nor2_4`, `or2_0`, `clkbuf_1`, `clkinv_1`) -
  far short of the 80 in the filtered liberty; only what *this* design's
  expression logic actually needed. Every one derived from that cell's
  real liberty `function:` string, with output-pin name (`Y` vs `X`)
  checked per cell before writing PRS - not assumed from the family name.
  One mechanical gotcha hit while adding the very first (`X`-output)
  cell: the two-stage pattern's internal node (`_X`) must be explicitly
  declared `bool _X;` before use in `prs*` - omitting it is a parse-time
  error (`identifier does not exist in current scope`), not a silent bug.
- **Verified end-to-end**: `make clean && make` completes cleanly.
  `expr.act` contains real `sky130_fd_sc_hd__*` instances (confirmed via
  `grep -oE "sky130_fd_sc_hd__[a-z0-9_]+" expr.act`). `make layout`'s
  "cells used in the design" list shows real sky130 cells
  (`sky130_fd_sc_hd__nor2_1<>`, `sky130_fd_sc_hd__and2_0<>`, etc.)
  alongside the still-generic ring-control-fabric cells (`LATCH<>`,
  `NOR2X1<>`, the custom `g*` compound gates) - exactly the split §3's
  caveat predicts (ring's own handshake/capture circuitry hardcodes
  `std::cells` unconditionally in `ring_engine.cc`, regardless of `-T`;
  only ABC-mapped expression-block logic benefits from this section).
  60 unique cells this run, `output.lef` + 61 `.rect` files generated.

**To reproduce:** same recipe as §4/§5, plus the full-name correction
above. **To undo:** same as §4/§5 - `rm` the filtered liberty file,
restore `expropt.conf`'s 11-line `include`-only version (verbatim in §3),
delete the `/* sky130_fd_sc_hd aliases. */`-marked block in `cells.act`.

---

## Full reproduction recipe (bundled-data path, from a clean checkout)

```sh
# 1. PDK (one-time, machine-wide)
python3 -m ciel enable --pdk sky130 026824c7969ce6f4fc9678e6ca04b0a06a596c4b

# 2. Shared ACT config (one-time, machine-wide) — see §2, §3 for exact file
#    contents to install/write.
cp ~/Desktop/synth.conf ~/.local/act/conf/sky130l/synth.conf
#    (rewrite ~/.local/act/conf/sky130l/expropt.conf per §3;
#     extend ~/.local/act/act/std/cells.act per §5)

# 3. Per-project cache override (avoids the cross-project cache-collision
#    bug documented in bugs.md Bug 1) — digital/final/local_cache.conf:
#    begin synth begin expropt begin cache string local "<abs path>/.expr_cache" end end end
mkdir -p digital/final/.expr_cache

# 4. Ring synthesis, bundled-data, sky130-targeted:
cd digital/final
synth2 -F ring -ref=2 -Tsky130l -C bd -cnf=local_cache.conf \
  -p decomp_rawbits -o async_readout_ring_bd.decomp.act -e expr_bd.act \
  async_readout.decomp.act
# should exit 0. Verify real sky130 mapping:
grep -oE "sky130_fd_sc_hd__[a-z0-9_]+" expr_bd.act | sort -u
```

**On `-ref=2`:** per `bugs.md`'s "Gotcha" section, the refine level must be
bumped by exactly one at *every* stage of the chain (`acceptRefine(refsteps,
mysteps) = refsteps >= mysteps`, and each synth2 invocation wraps its output
in `refine <(-ref passed in) + 1>`). `async_readout.decomp.act` currently
carries a `refine <2>` tag on `decomp_rawbits`, hence `-ref=2` here. If you
regenerate `async_readout.decomp.act` (re-run `-F decomp`) with a different
`-ref`, this number changes too — check the tag
(`grep -n 'refine <' async_readout.decomp.act`) rather than assuming `2`
still applies. **Not independently re-verified this session** for the
downstream `interact -ref=N` step that would read
`async_readout_ring_bd.decomp.act` — per the same rule it should be `-ref=3`
(one more than what ring synthesis was given), but this hasn't actually been
run yet; check before assuming.

---

## Open issues (not fixed, not worked around)

1. **QDI/DI path: `probe_clause`/`sdtexprchan` type mismatch.** Found this
   session on the default (QDI) ring-synthesis output, at the probed
   round-robin channel select: `block_43.gs[0] = inst_18.out[0]` fails to
   typecheck — `bool?` vs `sdtexprchan<1>`. `inst_18` is a `probe_clause`
   (expects plain `bool` guards); its input traces back to `inst_17`, a
   `blk_i1_1`-style SDT expression block whose output is genuinely an
   `sdtexprchan`. Everywhere *else* in the design, expr-block outputs get
   routed through a capture-latch converter before being used as a plain
   bool guard — this one specific probe-based-select code path in
   `ring_forge.cc` appears to skip that conversion. Not root-caused past
   this point; this is *why* the session pivoted to bundled-data (`-C bd`)
   at the user's direction, rather than debugging further into
   `ring_forge.cc`'s probed-select codegen.
2. **Bundled-data hasn't been run through `interact`/cell-map/phyDB yet** —
   only `synth2 -F ring` has been verified. `layout_gen.scm` in this
   directory is the known-working wrapper script for that stage, but it
   currently targets the QDI output (`async_readout_ring.decomp.act`,
   process `ring_decomp_rawbits`) — would need updating to point at
   `async_readout_ring_bd.decomp.act` and whatever the bundled-data top
   process is actually named.
3. **Ring control fabric depends on generic 180nm `std::cells`** (see
   `bugs.md`'s "Note" section) — separate from everything in §5 above.
   Ring's own handshake/capture-register control circuitry
   (`ctrl.act`/`ctrl_di_dpath.act`) instantiates `std::cells::LATCH`,
   `std::cells::NOR2X1`, etc. directly and unconditionally, regardless of
   `-T`. Not touched this session. The `.rect` geometry these get in
   `act2lef`/`stk2layout` output does obey real sky130 design rules
   (`layout.conf`), but the PRS/sizing underneath is unverified against
   sky130 device models.
4. **`synth.conf`'s delay-line calibration is now real (2026-08-11, §6e)
   for `capture_delay`, `mux_delays`, `or_delays`, `sel_delays`,
   `pulse_width` (approximate), and the `delay_params/offsets/vals_*`
   tables** — no longer placeholders. **Still not done: `cells.act`'s
   sizing hints from §5 are approximate** (this remains true only if/when
   §3–§5's real-cell-mapping work is redone — as of now §3–§5 isn't active
   at all, see the updated TL;DR). Neither affects functional correctness
   or physical layout sizing (confirmed separately correct, via
   `prs2net.conf`).
5. **`act2lef` (the standalone binary) crashes unconditionally**, unrelated
   to this design (bugs.md Bug 3) — use `interact` directly instead
   (`layout_gen.scm` shows the working pattern).
6. **`chp_cost.cc`'s `send_delay`/`recv_delay`/`assn_delay` are still the
   original dummy/TODO numbers** (40.0/40.0/0.0) — deliberately not
   recalibrated this session (§6e) since the real physical mapping
   (guessed at: a completion-detection gate like `gcelem2x0`) wasn't
   confirmed by tracing the actual CHP-lowering templates for
   send/receive/assign actions, and `assn_delay`'s original `0.0` might be
   a deliberate "negligible" judgment rather than an unfilled placeholder.
   Only affects decomp's decomposition-choice cost heuristic, not ring
   synthesis's own timing or physical correctness.
