#!/usr/bin/env -S -u LD_LIBRARY_PATH bash
# Open the production openDVS pixel_4tile working copy in KLayout, editable, sky130 tech.
# Shebang drops the inherited LD_LIBRARY_PATH: with the anaconda env active it points bash at
# anaconda's libreadline ("undefined symbol: rl_print_keybinding"). KLayout gets its own below.
#   ./open_production.sh            -> pixel_4tile_work.gds
#   ./open_production.sh other.gds  -> that file
set -euo pipefail
D="$(cd "$(dirname "$0")" && pwd)"
export PDK_ROOT="$HOME/.ciel" PDK=sky130A
export KLAYOUT_PATH="$HOME/.ciel/sky130A/libs.tech/klayout"
export LD_LIBRARY_PATH="$HOME/git/klayout/bin-release:$HOME/anaconda3/lib"
export QT_PLUGIN_PATH="$HOME/anaconda3/plugins"
export QT_QPA_PLATFORM=xcb
exec "$HOME/git/klayout/bin-release/klayout" -e -n sky130 "${1:-$D/pixel_4tile_work.gds}"
