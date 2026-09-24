# Virtual connect rules for openDVS_pixel2x2 LVS
# Merge split nets (Magic _uq suffixes) within pixel subcircuit
s/DiffBn_uq[0-9]*/DiffBn/g
#s/GndA_uq[0-9]*/GndA/g
#s/VddA18_uq[0-9]*/VddA18/g
# Convert primitive diode D0 to subcircuit instance XD0
# (matches schematic XD1 subcircuit call)
s/^D0 /XD0 /
