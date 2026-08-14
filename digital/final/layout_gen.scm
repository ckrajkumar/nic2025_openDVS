act:read "async_readout_ring.decomp.act"
act:merge "/Users/kamerongano/actflow/sky130l/cells/control/cells.act"
act:expand
act:top "ring_decomp_rawbits"
ckt:cell-map -l
ckt:map
ckt:cell-save "async_readout_cells.act"
load-scm "phydb.scm"

# Self-draw everything (real-sky130-mapped cells included - the hybrid
# swap happens afterward, outside interact: build_hybrid_lef.py replaces
# the self-drawn macros for real-mapped cells with SkyWater's actual LEF,
# then Dali places the result. See HANDOFF.md's hybrid-placement section.
act:layout:create
act:layout:lef "custom.lef" "custom.cell"
act:layout:def "seed.def" #t 3.0 1
act:layout:rect
quit
