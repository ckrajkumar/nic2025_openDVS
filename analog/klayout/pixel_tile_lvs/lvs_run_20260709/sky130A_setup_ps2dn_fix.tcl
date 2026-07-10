# Netgen LVS setup: sky130A + ps2dn parasitic diode pin merge for openDVS_pixel.
source $::env(PDK_ROOT)/$::env(PDK)/libs.tech/netgen/sky130A_setup.tcl

# Magic extract emits 4-terminal ps2dn with substrate taps at (0,0);
# schematic uses 2-terminal D GndA vpd.  Permute extra taps onto main pins.
foreach ckt {1 2} {
    set dev sky130_fd_pr__model__parasitic__diode_ps2dn
    if {[lsearch [cells list -all -circuit$ckt] $dev] >= 0} {
        permute "-circuit$ckt $dev" 1 3
        permute "-circuit$ckt $dev" 2 4
    }
}
