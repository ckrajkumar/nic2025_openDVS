#!/usr/bin/bash

exec bash

export VENV_DIR="/home/alienfalcon/Projects/skywater/open_dvs_py312"
NIC2025_DIR="/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/git_dvs/nic2025_openDVS/"
ANALOG_DIR="$NIC2025_DIR/analog"
CACE_DIR="$ANALOG_DIR/cace"
#cd "$VENV_DIR"
#source ./bin/activate
cd "$CACE_DIR/scripts"
exec python3 $1 $2 $3 $4

