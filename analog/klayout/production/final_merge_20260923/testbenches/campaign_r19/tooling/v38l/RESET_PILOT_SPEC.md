# Three-path fixed-timeline reset-transient contract

## Outcome

Run the openDVS 2×2 reset-transient PVT grid with matched absolute stimulus
timing on the native Quantus RCC/Spectre, Magic RCC/NGSPICE, and corrected
schematic/NGSPICE paths. The event-driven CACE run remains preserved as prior
protocol-conditioned evidence; none of its rows is directly reusable because
the reset waveform and stop time changed.

No confirmation data are authorized or accessed.

## Fixed reset waveform

Pixel 0 `pixRst[0]` and `rowReadON[0]` share one explicit PWL voltage source.
Pixel 1 reset/read controls and every OFF/read control remain low. The source is
independent of `ON`, `nRst`, and every other circuit response.

The same VDD-normalized points are rendered in all three simulator paths and in
all 135 reset rows:

| Absolute time | Reset level |
|---:|---:|
| 0 s | VDD |
| 1 ms | VDD |
| 1.00001 ms | 0 V |
| 45 s | 0 V |
| 45.00000001 s | VDD |
| 45.001 s | VDD |
| 45.00100001 s | 0 V |
| 45.5 s | 0 V |

This gives a 10 ns initial release, an undisturbed observation interval through
45 s, a fixed 1 ms second reset, a 10 ns second release, and a common 45.5 s
endpoint. The 45 s assertion uses the existing CACE protocol's registered
absolute timeout path, and the final 0.5 s observation preserves its registered
post-event duration. Choosing the existing timeout removes signal-dependent
timing without introducing a path-selected event time.

Both NGSPICE paths use a single uninterrupted transient with `run`; there are no
`stop when`, `alter`, or `resume` commands. Spectre uses the same explicit PWL
points rather than a Verilog-A controller. The delivered `pixrst` trace must
contain exactly two falling 50%-VDD crossings and one rising crossing at the
registered PWL midpoints, and every raw trace must reach 45.5 s.

## Conditions retained from the registered campaign

- Complete corner, VDD, and explicit temperature grid.
- Six registered current-mirror biases.
- Four physical photodiodes at 1 nA DC photocurrent per pixel.
- The registered 21-port binding and inactive-pin states.
- Gear order, tolerances, 100 µs maximum coarse step, and NGSPICE SPARSE startup.
- Quantus reset rows use `dcdampsol=yes`, which Spectre documents as damping DC
  Newton solution updates. This keeps the circuit equations, registered `gmin`,
  and convergence tolerances unchanged while avoiding the corrected-source
  initial-condition route that relaxed `reltol` from 0.0005 to 0.005.
- An explicit bounded per-row resource timeout recorded by each launch.
- No `.ic` or `uic`.
- The two source- and condition-matched Magic extreme `.nodeset` witnesses only;
  they are numerical initial guesses and do not alter circuit equations.

The three paths still use their registered extractor, simulator, model view, and
photodiode representation. Those differences remain explicit comparison
boundaries; matched conditions do not make them simulator-equivalent.

## Measurements and validity

Execution validity and scientific validity remain independent from
`spec_result`. Simulator errors, incomplete traces, unexpected reset-source
edges, failed NGSPICE homotopy followed by transient-OP fallback, or Spectre
warnings invalidate an attempt as already registered.

The six frozen CACE formulas and limits are retained as a labelled calculation
on the fixed waveform. Additional fixed-timeline measurements report initial
release to `nRst` at 90% of VDD, initial release to `ON` at 90% of VDD, and the
signed ordering between those two crossings. A zero CACE leak-event scalar is
reported as a sentinel when `ON` precedes `nRst` or a crossing is absent, never
as a zero physical interval.

The fixed second reset cannot create a leak event. If `ON` crosses before the
`nRst` reference, that ordering takes precedence over any later retrigger. If
the only post-reference crossing follows the fixed second reset, it is labelled
`forced_reset_retrigger`, not `measured`. A nominal row passes the simulation-
health gate only when a physical `ON` crossing occurs after `nRst`, before the
fixed second reset, and no later than the registered 40 s maximum. Missing,
censored, pre-reference, and forced-retrigger-only events prevent nominal
admission while preserving the raw trajectory and the legacy CACE scalar.

No numerical cross-path equivalence threshold is registered. Differences are
diagnostic and must not be attributed to parasitics alone.

## Progressive execution and evidence

1. Hash-check the manifest, source map, netlists, models, simulator binaries,
   launcher, tooling, and Magic witness records before creating output.
2. Prepare and inspect one nominal TT, 1.8 V, 27 °C deck per path.
3. Run the three nominal rows under fresh output identities. Admit the rung only
   when all three pass execution validity, scientific validity, and the fixed-
   timeline simulation-health gate. Other frozen scalar failures remain
   independent through `spec_result`.
4. Run the SS/1.62 V/0 °C and FF/1.98 V/70 °C rows on all paths under another
   fresh identity and apply the same validity gate.
5. Run the remaining 42 rows per path. The fixed waveform affects Quantus too,
   so its earlier event-driven matrix is not reused.
6. Write immutable path evidence only after all 42 rows for that path pass
   execution and scientific validity. Preserve every invalid or timed-out
   attempt and reacquire it under a fresh attempt identity after a changed,
   justified recovery.

The nominal, extreme, and matrix outputs bind the manifest, source fingerprint,
tooling, decks, raw outputs, logs, and result records by SHA-256. No old output
is overwritten or deleted.

## Mechanical checks

```text
python -m py_compile campaign_manifest.py reset_campaign.py reset_matrix.py
python -m unittest discover -s tests -v
python -m unittest discover -s reset_tests -v
```
