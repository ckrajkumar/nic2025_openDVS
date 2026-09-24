#!/usr/bin/env -S -u LD_LIBRARY_PATH bash
# run a KLayout batch script in the production dir with the clean library path: kl.sh <script.py> [-rd k=v ...]
cd ~/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog/klayout/production
export LD_LIBRARY_PATH=$HOME/git/klayout/bin-release:$HOME/anaconda3/lib
exec "$HOME/git/klayout/bin-release/klayout" -b -r "$@" 2>&1 | grep -v libcurl
