# Custom LVS setup for openDVS_pixel2x2
# Sources the PDK setup, then applies fixes
#
# Requires pre-processing of the layout netlist:
#   sed -e 's/DiffBn_uq[0-9]*/DiffBn/g' \
#       -e 's/GndA_uq[0-9]*/GndA/g'     \
#       -e 's/^D0 /XD0 /'                \
#       layout.spice > layout_vc.spice
#
# Fix 1: Virtual connect on DiffBn (Magic splits into DiffBn_uq*)
# Fix 2: Virtual connect on GndA  (Magic splits into GndA_uq*)
# Fix 3: D0 -> XD0 so parasitic diode is treated as subcircuit
#         (matches schematic XD1 instance)

if {[info exists ::env(PDK_ROOT)]} {
    set PDK_ROOT $::env(PDK_ROOT)
} else {
    set PDK_ROOT /usr/local/share/pdk
}
if {[info exists ::env(PDK)]} {
    set PDK $::env(PDK)
} else {
    set PDK sky130A
}
source $PDK_ROOT/$PDK/libs.tech/netgen/${PDK}_setup.tcl

# Ignore diode area/perim mismatch (layout has real area,
# schematic has symbolic 1e12 area)
property "-circuit1 sky130_fd_pr__model__parasitic__diode_ps2dn" delete area
property "-circuit1 sky130_fd_pr__model__parasitic__diode_ps2dn" delete perim
