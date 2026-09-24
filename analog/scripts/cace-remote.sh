#!/bin/bash
#
# cace-remote — Generate CACE simulation locally, run ngspice on server
#
# Usage: cace-remote <cace_yaml> [cace_args...]
# Example: cace-remote cace/PixelResetTran_2x2.yaml -p reset_tran -s pex
#
# Flow:
#   1. Run cace locally to generate simulation netlists (kills before sims start)
#   2. Bundle run directory + dependencies to server sandbox
#   3. Run ngspice --batch on each corner in parallel on server
#   4. Monitor progress, rsync completed .raw/.data back immediately
#   5. Print summary when done

set -uo pipefail

##############################
# Configuration
##############################
SERVER="${CACE_REMOTE_SERVER:-rpgraca-server.wg0}"
LOCAL_PDK="/usr/local/share/pdk"
MAX_PARALLEL="${CACE_REMOTE_JOBS:-14}"
POLL_INTERVAL=30

# Resolve remote HOME for path expansion
REMOTE_HOME=$(ssh "$SERVER" 'echo $HOME')
SANDBOX="${CACE_REMOTE_SANDBOX:-$REMOTE_HOME/cace_sandbox}"
REMOTE_PDK="${CACE_REMOTE_PDK:-$REMOTE_HOME/.volare}"

##############################
# Parse arguments
##############################
if [ $# -lt 1 ]; then
    echo "Usage: cace-remote <cace_yaml> [cace_args...]"
    echo ""
    echo "Environment variables:"
    echo "  CACE_REMOTE_SERVER   server hostname (default: rpgraca-server.wg0)"
    echo "  CACE_REMOTE_SANDBOX  sandbox dir on server (default: ~/cace_sandbox)"
    echo "  CACE_REMOTE_PDK      PDK root on server (default: ~/.volare)"
    echo "  CACE_REMOTE_JOBS     max parallel ngspice jobs (default: 14)"
    exit 1
fi

CACE_YAML="$1"
shift
CACE_ARGS=("$@")

# Resolve project root (CACE yaml is relative to cace/ subdir)
YAML_DIR="$(cd "$(dirname "$CACE_YAML")" && pwd)"
PROJECT_ROOT="$(cd "$YAML_DIR/.." && pwd)"
YAML_BASENAME="$(basename "$CACE_YAML")"

log() { echo "$(date +%H:%M:%S) | $*"; }
die() { echo "FATAL: $*" >&2; exit 1; }

##############################
# Phase 1: Generate simulation files
##############################
log "Phase 1: Generating simulation netlists..."

cd "$PROJECT_ROOT"

# Snapshot existing run directories so we can detect the new one
EXISTING_RUNS=$(ls -d runs/RUN_* 2>/dev/null | sort)

# Run cace, capture its log, wait for netlist generation to finish
CACE_LOG=$(mktemp /tmp/cace-remote-XXXXXX.log)
cace "cace/$YAML_BASENAME" ${CACE_ARGS[@]+"${CACE_ARGS[@]}"} --no-progress-bar -l INFO \
    > "$CACE_LOG" 2>&1 &
CACE_PID=$!

# Wait for netlist generation to complete
log "  Waiting for netlist generation (cace pid $CACE_PID)..."

# Wait for a NEW run directory (one that wasn't in the snapshot)
RUN_DIR=""
while kill -0 $CACE_PID 2>/dev/null; do
    for d in $(ls -td runs/RUN_* 2>/dev/null); do
        if ! echo "$EXISTING_RUNS" | grep -qxF "$d"; then
            RUN_DIR="$d"
            break 2
        fi
    done
    sleep 2
done
if [ -z "$RUN_DIR" ]; then
    echo "--- CACE log ---"
    cat "$CACE_LOG"
    die "No new run directory created. Check log above."
fi

# Wait for run_* dirs with .spice files to appear and stabilize
PREV_COUNT=0
STABLE=0
while kill -0 $CACE_PID 2>/dev/null; do
    CUR_COUNT=$(find "$RUN_DIR" -name "tb_*.spice" 2>/dev/null | wc -l)
    if [ "$CUR_COUNT" -gt 0 ] && [ "$CUR_COUNT" -eq "$PREV_COUNT" ]; then
        STABLE=$((STABLE + 1))
        [ "$STABLE" -ge 3 ] && break
    else
        STABLE=0
    fi
    PREV_COUNT=$CUR_COUNT
    sleep 2
done

# If cace died before generating netlists, check the log
if ! kill -0 $CACE_PID 2>/dev/null; then
    CUR_COUNT=$(find "$RUN_DIR" -name "tb_*.spice" 2>/dev/null | wc -l)
    if [ "$CUR_COUNT" -eq 0 ]; then
        echo "--- CACE log ---"
        cat "$CACE_LOG"
        die "CACE exited before generating netlists"
    fi
fi

# Extract parameter directory (e.g., parameters/reset_tran)
PARAM_DIR=$(ls -d "$RUN_DIR"/parameters/*/ 2>/dev/null | head -1)
PARAM_DIR="${PARAM_DIR%/}"  # strip trailing slash (rsync semantics)
[ -z "$PARAM_DIR" ] && die "No parameter directory found in $RUN_DIR"
PARAM_NAME=$(basename "$PARAM_DIR")

# Count corners
TOTAL_RUNS=$(ls -d "$PARAM_DIR"/run_*/ 2>/dev/null | wc -l)
log "  Netlists generated."
log "  Run directory: $RUN_DIR"
log "  Parameter: $PARAM_NAME ($TOTAL_RUNS corners)"

# Kill cace and all its descendants (ngspice children)
kill $CACE_PID 2>/dev/null
sleep 1
# Kill all descendants recursively
_kill_tree() {
    local pid=$1
    for child in $(pgrep -P "$pid" 2>/dev/null); do
        _kill_tree "$child"
    done
    kill "$pid" 2>/dev/null || true
}
_kill_tree $CACE_PID
wait $CACE_PID 2>/dev/null || true
log "  Local cace stopped."

##############################
# Phase 2: Prepare and transfer
##############################
log "Phase 2: Preparing files for server..."

RUN_TAG=$(basename "$RUN_DIR")
REMOTE_RUN="$SANDBOX/$RUN_TAG"

# Collect all .include/.lib paths referenced in netlists
INCLUDES=$(grep -rh '^\.\(include\|lib\) ' "$PARAM_DIR"/run_*/tb_*.spice 2>/dev/null \
    | sed 's/^\.include //; s/^\.lib //' \
    | awk '{print $1}' \
    | sort -u \
    | grep -v "^$")

# Collect scripts referenced in shell commands
SHELL_SCRIPTS=$(grep -rh '^shell ' "$PARAM_DIR"/run_*/tb_*.spice 2>/dev/null \
    | grep -oE '/[^ ]+\.py' \
    | sort -u)

# Identify local files that need to be copied (exclude PDK — use server's)
LOCAL_DEPS=()
for inc in $INCLUDES; do
    if [[ "$inc" == "$LOCAL_PDK"* ]]; then
        continue  # PDK handled via path rewrite
    elif [ -f "$inc" ]; then
        LOCAL_DEPS+=("$inc")
    fi
done
for script in $SHELL_SCRIPTS; do
    if [ -f "$script" ]; then
        LOCAL_DEPS+=("$script")
    fi
done

log "  Local dependencies: ${#LOCAL_DEPS[@]} file(s)"
for dep in "${LOCAL_DEPS[@]+"${LOCAL_DEPS[@]}"}"; do
    log "    $(basename "$dep")"
done

# Rewrite PDK paths in all netlists
log "  Rewriting PDK paths: $LOCAL_PDK → $REMOTE_PDK"
find "$PARAM_DIR" -name "*.spice" -exec \
    sed -i "s|$LOCAL_PDK|$REMOTE_PDK|g" {} +

# Rewrite local run directory path to server sandbox path
LOCAL_RUN_PATH="$PROJECT_ROOT/$RUN_DIR"
log "  Rewriting run paths: $LOCAL_RUN_PATH → $REMOTE_RUN"
find "$PARAM_DIR" -name "*.spice" -exec \
    sed -i "s|$LOCAL_RUN_PATH|$REMOTE_RUN|g" {} +

# Rewrite python3 to anaconda python (server system python lacks numpy/spicelib)
REMOTE_PYTHON="$REMOTE_HOME/anaconda3/bin/python3"
find "$PARAM_DIR" -name "*.spice" -exec \
    sed -i "s|shell python3 |shell $REMOTE_PYTHON |g" {} +

# Rewrite local dependency paths to server sandbox paths
for dep in "${LOCAL_DEPS[@]+"${LOCAL_DEPS[@]}"}"; do
    dep_base=$(basename "$dep")
    find "$PARAM_DIR" -name "*.spice" -exec \
        sed -i "s|$dep|$REMOTE_RUN/deps/$dep_base|g" {} +
done

# Transfer to server
log "  Creating sandbox on server..."
ssh "$SERVER" "mkdir -p $REMOTE_RUN/deps"

log "  Transferring run directory ($TOTAL_RUNS corners)..."
rsync -az --info=progress2 \
    "$PARAM_DIR" "$SERVER:$REMOTE_RUN/parameters/"

# Transfer dependencies
for dep in "${LOCAL_DEPS[@]+"${LOCAL_DEPS[@]}"}"; do
    log "  Transferring $(basename "$dep")..."
    rsync -azL "$dep" "$SERVER:$REMOTE_RUN/deps/"
done

# Copy .spiceinit to each run dir on server (limit threads to avoid oversubscription)
THREADS_PER_JOB=$(( $(ssh "$SERVER" nproc) / MAX_PARALLEL ))
[ "$THREADS_PER_JOB" -lt 1 ] && THREADS_PER_JOB=1
ssh "$SERVER" "bash -s" << SPICEINIT_EOF
spiceinit="$REMOTE_PDK/sky130B/libs.tech/ngspice/spinit"
if [ ! -f "\$spiceinit" ]; then
    spiceinit="$REMOTE_PDK/sky130B/libs.tech/ngspice/.spiceinit"
fi
if [ -f "\$spiceinit" ]; then
    find "$REMOTE_RUN/parameters" -type d -name 'run_*' -exec cp "\$spiceinit" {}/.spiceinit \;
    find "$REMOTE_RUN/parameters" -type d -name 'run_*' -exec sed -i 's/set num_threads=.*/set num_threads=$THREADS_PER_JOB/' {}/.spiceinit \;
fi
SPICEINIT_EOF

##############################
# Phase 3: Run simulations on server
##############################
log "Phase 3: Launching $TOTAL_RUNS ngspice jobs on $SERVER (max $MAX_PARALLEL parallel)..."

# Create a launcher script on the server
REMOTE_LOG="$REMOTE_RUN/sim.log"
ssh "$SERVER" "cat > $REMOTE_RUN/run_sims.sh" << 'LAUNCHER'
#!/bin/bash
set -u
REMOTE_RUN="$1"
MAX_PARALLEL="$2"
PARAM_DIR=$(ls -d "$REMOTE_RUN"/parameters/*/ | head -1)

run_job() {
    local rundir="$1"
    local spicefile tag rc
    spicefile=$(ls "$rundir"/tb_*.spice 2>/dev/null | head -1)
    [ -z "$spicefile" ] && return
    tag=$(basename "$rundir")

    cd "$rundir"
    echo "$(date +%H:%M:%S) START $tag"
    nice ngspice --batch "$(basename "$spicefile")" \
        > ngspice_stdout.out 2> ngspice_stderr.out
    rc=$?
    if [ $rc -eq 0 ]; then
        echo "$(date +%H:%M:%S) DONE  $tag (exit $rc)"
    else
        echo "$(date +%H:%M:%S) FAIL  $tag (exit $rc)"
    fi
}

# Launch all jobs with throttling
PIDS=()
for rundir in "$PARAM_DIR"/run_*/; do
    # Throttle: wait if at max parallel
    while [ ${#PIDS[@]} -ge $MAX_PARALLEL ]; do
        # Wait for any child to finish
        for i in "${!PIDS[@]}"; do
            if ! kill -0 "${PIDS[$i]}" 2>/dev/null; then
                wait "${PIDS[$i]}" 2>/dev/null || true
                unset 'PIDS[$i]'
            fi
        done
        PIDS=("${PIDS[@]}")  # reindex
        [ ${#PIDS[@]} -ge $MAX_PARALLEL ] && sleep 5
    done

    run_job "$rundir" &
    PIDS+=($!)
done

# Wait for remaining
for pid in "${PIDS[@]}"; do
    wait "$pid" 2>/dev/null || true
done

echo "ALL_DONE"
LAUNCHER

ssh "$SERVER" "chmod +x $REMOTE_RUN/run_sims.sh"

# Launch simulations in background on server
ssh "$SERVER" "nohup bash $REMOTE_RUN/run_sims.sh '$REMOTE_RUN' $MAX_PARALLEL \
    > $REMOTE_LOG 2>&1 & echo \$!"

log "  Simulations launched on server."

##############################
# Phase 4: Monitor and stream results back
##############################
log "Phase 4: Monitoring progress (polling every ${POLL_INTERVAL}s)..."

# Restore local paths in the local copy (we modified them for server)
find "$PARAM_DIR" -name "*.spice" -exec \
    sed -i "s|$REMOTE_PDK|$LOCAL_PDK|g" {} +
find "$PARAM_DIR" -name "*.spice" -exec \
    sed -i "s|$REMOTE_RUN|$LOCAL_RUN_PATH|g" {} +
find "$PARAM_DIR" -name "*.spice" -exec \
    sed -i "s|shell $REMOTE_PYTHON |shell python3 |g" {} +
for dep in "${LOCAL_DEPS[@]+"${LOCAL_DEPS[@]}"}"; do
    dep_base=$(basename "$dep")
    find "$PARAM_DIR" -name "*.spice" -exec \
        sed -i "s|$LOCAL_RUN_PATH/deps/$dep_base|$dep|g" {} +
done

PREV_DONE=0
while true; do
    # Sync all completed results back (raw, data, stdout, stderr)
    rsync -az --include='*/' \
        --include='*.raw' --include='*.data' \
        --include='ngspice_stdout.out' --include='ngspice_stderr.out' \
        --exclude='*' \
        "$SERVER:$REMOTE_RUN/parameters/" "$PARAM_DIR/" 2>/dev/null

    # Count completed (has .raw or ngspice_stdout.out with content)
    DONE=$(find "$PARAM_DIR" -name "*.raw" 2>/dev/null | wc -l)
    FAILED=$(ssh "$SERVER" "grep -c 'FAIL' $REMOTE_LOG 2>/dev/null" 2>/dev/null | tr -dc '0-9') ; FAILED=${FAILED:-0}

    if [ "$DONE" -ne "$PREV_DONE" ]; then
        log "  Progress: $DONE/$TOTAL_RUNS completed, $FAILED failed"
        PREV_DONE=$DONE
    fi

    # Check if server is done
    if ssh "$SERVER" "grep -q 'ALL_DONE' $REMOTE_LOG 2>/dev/null" 2>/dev/null; then
        # Final sync
        rsync -az --include='*/' \
            --include='*.raw' --include='*.data' \
            --include='ngspice_stdout.out' --include='ngspice_stderr.out' \
            --exclude='*' \
            "$SERVER:$REMOTE_RUN/parameters/" "$PARAM_DIR/"
        DONE=$(find "$PARAM_DIR" -name "*.raw" 2>/dev/null | wc -l)
        FAILED=$(ssh "$SERVER" "grep -c 'FAIL' $REMOTE_LOG 2>/dev/null" 2>/dev/null | tr -dc '0-9') ; FAILED=${FAILED:-0}
        break
    fi

    sleep "$POLL_INTERVAL"
done

##############################
# Summary
##############################
log ""
log "=== Complete ==="
log "  Total corners: $TOTAL_RUNS"
log "  Succeeded:     $DONE"
log "  Failed:        $FAILED"
log "  Results in:    $RUN_DIR"
log "  Server log:    ssh $SERVER cat $REMOTE_LOG"
log ""

if [ "$FAILED" -gt 0 ]; then
    log "Failed corners:"
    ssh "$SERVER" "grep 'FAIL' $REMOTE_LOG" 2>/dev/null | while read line; do
        log "  $line"
    done
fi

log ""
log "To post-process with cace, re-run:"
log "  cace cace/$YAML_BASENAME ${CACE_ARGS[*]} --run-path $RUN_DIR"

rm -f "$CACE_LOG"
