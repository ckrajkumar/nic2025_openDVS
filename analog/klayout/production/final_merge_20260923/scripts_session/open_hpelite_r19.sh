#!/bin/bash
# HPelite: open the r19 wrapper in Rui's KLayout build (linked against the anaconda klayout env python 3.12)
set -uo pipefail
D=~/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog/klayout/production/final_merge_20260923/r19
ls ~/anaconda3/envs/klayout/lib/libpython3.12.so.1.0 ~/anaconda3/lib/libpython3.12.so.1.0 2>&1 | head -2
export PDK_ROOT="$HOME/.ciel" PDK=sky130A KLAYOUT_PATH="$HOME/.ciel/sky130A/libs.tech/klayout" \
  LD_LIBRARY_PATH="$HOME/git/klayout/bin-release:$HOME/anaconda3/envs/klayout/lib:$HOME/anaconda3/lib" \
  QT_PLUGIN_PATH="$HOME/anaconda3/plugins" QT_QPA_PLATFORM=xcb DISPLAY=:0 WAYLAND_DISPLAY=wayland-1 XDG_RUNTIME_DIR=/run/user/$(id -u)
ldd "$HOME/git/klayout/bin-release/klayout" | grep -c "not found"
nohup "$HOME/git/klayout/bin-release/klayout" -n sky130 "$D/user_project_wrapper.r19.gds" > /tmp/klayout_r19_full.log 2>&1 < /dev/null &
P=$!; echo "pid $P"; sleep 45
ps -o pid,rss,etime -p $P; grep -v -e gdsfactory -e "^$" /tmp/klayout_r19_full.log | tail -5 | cut -c1-160
