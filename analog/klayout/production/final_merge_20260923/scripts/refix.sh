#!/bin/bash
# workstation: restore the r18 originals, apply microfix (A, B, B2, C), re-export, relaunch DRC + tile extraction/LVS + precheck
set -uo pipefail; cd ~/opendvs_final
cp -f merged/user_project_wrapper.r18.gds merged/user_project_wrapper.gds && cp -f merged/pixel_4tile.r18.orig.gds merged/pixel_4tile.r18.gds
timeout 1200 klayout -b -r ~/microfix.py -rd gds=merged/user_project_wrapper.gds -rd cells="GS_openDVS_pixel:r0,S7_openDVS_pixel:r270" 2>&1 | grep -E "70/20|wrote"
timeout 600 klayout -b -r ~/microfix.py -rd gds=merged/pixel_4tile.r18.gds -rd cells="openDVS_pixel:r0" 2>&1 | grep -E "70/20|wrote"
timeout 1800 klayout -b -r subtrees.py -rd fin=merged/user_project_wrapper.gds -rd prod=$HOME/tile_r15a/pixel_4tile.prod.gds -rd r18=merged/pixel_4tile.r18.gds -rd outdir=$HOME/opendvs_final/merged 2>&1 | grep -v "xschem\|^ERROR\|^$"
klayout -b -r export2x2.py 2>&1 | grep -v "xschem\|^ERROR\|^$"
sha256sum merged/openDVS_pixel2x2_top.r18.gds merged/pixel_4tile.r18.gds merged/user_project_wrapper.gds | cut -c1-16,66-
rm -f drc/r18_tile_*; rm -rf lvs/tile_b lvs/ts_b project/precheck_results/nonlvs
nohup bash ~/drc_attrib.sh > ~/drc_attrib.log 2>&1 < /dev/null &
nohup bash ~/tile_b.sh > ~/tile_b.log 2>&1 < /dev/null &
nohup bash ~/precheck_setup.sh > ~/precheck_nonlvs.log 2>&1 < /dev/null &
sleep 3; echo "relaunched drc + tile_b + precheck $(date +%H:%M:%S)"
