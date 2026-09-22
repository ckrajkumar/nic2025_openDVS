#!/usr/bin/env -S -u LD_LIBRARY_PATH bash
# HPelite: open the merged wrapper + the r18b tile in a NEW KLayout instance (the old one, pid 997072, keeps the pre-edit work file)
set -uo pipefail
D=~/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog/klayout/production/final_merge_20260923
export PDK_ROOT="$HOME/.ciel" PDK=sky130A KLAYOUT_PATH="$HOME/.ciel/sky130A/libs.tech/klayout" LD_LIBRARY_PATH="$HOME/git/klayout/bin-release:$HOME/anaconda3/lib" QT_PLUGIN_PATH="$HOME/anaconda3/plugins" QT_QPA_PLATFORM=xcb DISPLAY=:0 WAYLAND_DISPLAY=wayland-1 XDG_RUNTIME_DIR=/run/user/$(id -u)
ls -la $D/*.gds | cut -c24-
nohup "$HOME/git/klayout/bin-release/klayout" -n sky130 "$D/user_project_wrapper.r18b.gds" "$D/pixel_4tile.r18b.gds" > /tmp/klayout_r18b.log 2>&1 < /dev/null &
sleep 8; pgrep -af "klayout.*r18b" | grep -v pgrep | cut -c1-100; tail -2 /tmp/klayout_r18b.log
