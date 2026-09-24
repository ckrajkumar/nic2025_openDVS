# Corrected Quantus nominal convergence recovery

## Outcome

Render the corrected Quantus reset transient with Spectre DC solution damping so
its initial operating point reaches the registered `reltol`, instead of allowing
Spectre to relax `reltol` from 0.0005 to 0.005. The physical circuit, registered
biases, 1 nA-per-pixel optical input, 1.8 V supply, 27 °C temperature, tt corner,
10 ns reset release, Gear integration, 100 µs maximum step, and transient `gmin`
remain unchanged.

## Evidence and acceptance checks

The bounded 2 ms diagnostic with `dcdampsol=yes` completed with zero errors and
zero warnings. The option damps Newton updates; it does not change the circuit
equations or convergence tolerances. The fixed-timeline renderer must include
`dcdampsol=yes` on Quantus/Spectre rows and no NGSPICE row.

Run before implementation and require failure because the unmodified copied
renderer omits `dcdampsol=yes`:

```text
python -m unittest tests.test_reset_campaign.ResetCampaignTests.test_discovery_decks_are_deterministic_and_path_correct -v
```

After implementation, require the focused test plus the project formatter,
fatal/import lint checks, Python compilation, main suite, and reset-specific
suite to pass. A fresh deterministic prepare-only run must contain the option in
the Quantus deck and preserve byte-identical reset PWL sources across all three
views. A fresh full 45.5 s corrected-Quantus nominal attempt must then complete
with zero errors and zero warnings before it can be classified.

## Rejected routes

- `dc_pivot_check=yes`, `pivotdc=yes`, `bin_relref=yes`, `dcmaxiters=1000`,
  larger dptran/ptran budgets, generated nodesets, and `++aps` did not remove
  `SPECTRE-16093`.
- Directly encoding NGSPICE `gminsteps`/`srcsteps` as Spectre options is invalid;
  Spectre rejected both names.
- No `gmin`, tolerance, edge, bias, optical, model, or extracted-network change
  is admitted by this recovery.
