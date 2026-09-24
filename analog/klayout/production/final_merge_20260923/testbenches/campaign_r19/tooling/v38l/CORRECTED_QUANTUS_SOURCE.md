# Production-GDS corrected Quantus source binding

This tooling version binds the fixed-timeline comparison to the Quantus RCC
view extracted from the production `openDVS_pixel2x2_top` geometry. The raw
Quantus netlist is adapted to native Sky130 device calls, then receives fresh
Magic-derived MOS `AD`/`AS`/`PD`/`PS` values. The corrected source SHA-256 is
`0668aca3082314fb885cb685e0f082f2e53096ede2e5b38aed00f5b0b93dfb9e`.

The transfer reused only the previously verified device-role and source/drain
orientation map. It checked all 80 fresh Magic MOS cards against the reference
ordered terminal, model, W/L, and junction geometry before transferring fresh
production-GDS values. It applied the registered 38 source/drain swaps. It did
not add `NRD` or `NRS`; both RCC views already contain distributed resistance.

Quantus reset decks retain `dcdampsol=yes`, which previously reached the
registered tolerances without changing circuit equations, biases, optical
input, reset waveform, integration method, or `gmin`. Direct PVS junction
properties remain excluded because shared diffusion is duplicated on adjacent
MOS cards and the PVS match checks W/L rather than those added properties.
