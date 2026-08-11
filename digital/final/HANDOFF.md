# HANDOFF: sky130 tapeout tooling — what changed, where, why, how to redo or undo it

Status as of 2026-08-07. Covers the `rawbits` ring-synthesis → sky130 cell-mapping
effort for this project. Written so a human can decide what to keep, and so
another agent could reproduce (or undo) any of it without re-deriving it.

> **REVERTED 2026-08-07.** All of §2–§5 below (the sky130l config rewrite,
> `std/cells.act` additions, filtered liberty file, and project-local
> synthesis output) has been rolled back at the user's request — none of it
> exists on disk anymore. The ciel PDK enable and the `cad_setup` fix (§1)
> were kept. This document is preserved as a record of the investigation —
> the root causes described (config first-write-wins, the hardcoded
> `bundled.cell_lib` path, the deny-list→allow-list liberty story, the X-vs-Y
> pin-naming convention) are all still true and still apply if this work is
> picked up again; the recipe in "Full reproduction recipe" is exactly how
> to redo it from scratch.

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
- **Working today, verified:** `synth2 -F ring -ref=2 -Tsky130l -C bd
  -cnf=local_cache.conf` on this design completes cleanly and produces a
  netlist genuinely mapped onto real `sky130_fd_sc_hd` standard cells (47
  distinct cells, all drive-strength variants of ~19 basic gate families).
  Output: `async_readout_ring_bd.decomp.act` + `expr_bd.act`.
- **Not yet done:** running that bundled-data output through
  `interact`/`ckt:cell-map`/phyDB (the QDI path got this far before — see
  Bug 2 and `layout_gen.scm` — bundled-data hasn't been tried through that
  stage yet).
- **Known still-broken:** the default QDI/DI ring-synthesis path hits a
  `probe_clause`/`sdtexprchan` type-mismatch bug that was never resolved
  (found in this session, not documented elsewhere — see "Open issues"
  below). Bundled-data (`-C bd`) was adopted specifically to route around
  this, at the user's direction.
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
4. **`synth.conf`'s delay-line calibration numbers are placeholders** (§2)
   and **this session's new `cells.act` sizing hints are approximate** (§5)
   — both affect only ABC's/ring's internal timing *estimates*, not
   functional correctness or physical layout sizing (confirmed separately
   correct, via `prs2net.conf`). Real sky130 characterization (e.g. via
   `xcell` — there's a partial setup already at `digital/final/xcell_char/`)
   would be needed before trusting any timing numbers this flow reports.
5. **`act2lef` (the standalone binary) crashes unconditionally**, unrelated
   to this design (bugs.md Bug 3) — use `interact` directly instead
   (`layout_gen.scm` shows the working pattern).
