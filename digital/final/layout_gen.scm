act:read "async_readout_ring.decomp.act"
act:merge "/Users/kamerongano/git/actflow/sky130l/cells/control/cells.act"
act:expand
act:top "ring_decomp_rawbits"
ckt:cell-map -l
ckt:map
ckt:cell-save "async_readout_cells.act"
load-scm "phydb.scm"
phydb:create 1.8 1 "out.lef"
act:layout:rect
quit
