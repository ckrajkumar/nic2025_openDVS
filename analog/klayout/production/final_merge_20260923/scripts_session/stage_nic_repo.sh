#!/bin/bash
# Collect the openDVS final-merge tooling, testbenches, audit and reports from ws / ini / server
# into the nic2025_openDVS repo on HPelite (final_merge_20260923/). Idempotent; copies only.
set -euo pipefail
S=/tmp/claude-1000/-home-rpgraca--claude-sessions-opendvs-pex/bb43ae85-dc92-434a-9028-3710c9ed05d7/scratchpad/nic_stage
A=/home/rpgraca/.claude-sessions/opendvs-pex/.cs/artifacts
HP=rpgracaHPelite.wg0
REPO=research/projects/telluride/2025/nic_eventcam/nic2025_openDVS
FM=$REPO/analog/klayout/production/final_merge_20260923
SSH="ssh -o BatchMode=yes"
RS="rsync -a --prune-empty-dirs --exclude=__pycache__ --exclude=.omc"
rm -rf "$S"; mkdir -p "$S"/{tooling_ws,audit_20260924/{lvs/baseline_lvs,conn,drc},testbenches/{campaign_r19,xtalk_reset,cace/analog},scripts_session,scripts,klayout_production_session,dashboard,reports}

echo "== workstation tooling + precheck logs"
$RS -e "$SSH" --include='*.py' --include='*.sh' --include='*.tcl' --include='*.sed' --include='*.log' --exclude='*' \
  rpgraca-workstation.wg0:opendvs_final/ "$S/tooling_ws/"

echo "== audit 2026-09-24 (small text outputs + scripts)"
for d in lvs conn drc; do
  $RS -e "$SSH" --max-size=2m --include='*/' --exclude='proj_r21b/***' --exclude='ant_*/*.ext' \
    --include='*.py' --include='*.sh' --include='*.tcl' --include='*.txt' --include='*.log' --include='*.md' \
    --include='*.json' --include='*.report' --exclude='*' \
    rpgraca-workstation.wg0:opendvs_final/audit_$d/ "$S/audit_20260924/$d/"
done
$RS -e "$SSH" --include='*/' --include='*.log' --include='*.report' --include='*.txt' --include='*.json' --exclude='*' --max-size=5m \
  rpgraca-workstation.wg0:opendvs_final/project_audit_orig/precheck_results/baseline_lvs/ "$S/audit_20260924/lvs/baseline_lvs/"
cp "$A/final-gds-drive/AUDIT_r21b_2026-09-24.md" "$S/audit_20260924/"

echo "== campaign r19 tooling (ws)"
C=.cache/opencode/opendvs-pex/campaign-edit20260922r19-v1
$RS -e "$SSH" rpgraca-workstation.wg0:$C/tooling rpgraca-workstation.wg0:$C/manifest.json \
  rpgraca-workstation.wg0:$C/source_map.json rpgraca-workstation.wg0:$C/campaign_status.py "$S/testbenches/campaign_r19/"

echo "== crosstalk / reset bench (ini)"
$RS -e "$SSH" --exclude=outputs rpgraca-ini.wg0:opendvs-sims/opendvs_reset_rise_20260921/ "$S/testbenches/xtalk_reset/"

echo "== CACE runner (ini)"
$RS -e "$SSH" --include='*.py' --include='*.sh' --include='cace_tables.json' --include='logs_run_*.txt' --exclude='*' \
  rpgraca-ini.wg0:opendvs-cace/ "$S/testbenches/cace/"
$RS -e "$SSH" rpgraca-ini.wg0:opendvs-cace/analog/ "$S/testbenches/cace/analog/"
$SSH rpgraca-ini.wg0 'cd ~/git/cace && git diff -- cace/parameter/parameter_ngspice.py' > "$S/testbenches/cace/cace_parameter_ngspice_datasheet_fix.patch"

echo "== session scripts (no mail/Drive/OAuth scripts)"
$RS --exclude='send_*' --exclude='reply_*' --exclude='draft_*' --exclude='resend_*' --exclude='build_r20_email.py' \
  --exclude='drive_upload.py' --exclude='reauth_google.py' --exclude='mkfolder.py' "$A/scripts/" "$S/scripts_session/"
$RS "$A/final-gds-drive/scripts/" "$S/scripts/"
$RS --exclude='*.png' "$A/klayout-production/" "$S/klayout_production_session/"

echo "== dashboard + reports"
$RS --exclude='*.raw.txt' "$A/dashboard/" "$S/dashboard/"
mkdir -p "$S/reports"
cp "$A"/final-gds-drive/{MERGE_REPORT_r19_2026-09-23.md,MERGE_REPORT_r20_2026-09-23.md,failures_analysis.md,LVS_CLEAN_evidence.txt,LVS_CLEAN_wb_lvs_v4.md,campaign_r19_reset_summary_1049.txt,lvs_config.json} "$S/reports/"

echo "== push stage to HPelite"
$SSH $HP "mkdir -p ~/$FM"
rsync -a --update -e "$SSH" "$S/" "$HP:$FM/"
# session klayout copies: only files the repo production dir lacks
$SSH $HP "cd ~/$FM && rsync -a --ignore-existing klayout_production_session/ ../ && rm -rf klayout_production_session"

echo "== r21b GDS as xz + checksums"
$SSH $HP "cd ~/$FM/r21b && { [ -f user_project_wrapper.r21b.gds.xz ] || xz -T8 -9 -k user_project_wrapper.r21b.gds; } && sha256sum user_project_wrapper.r21b.gds user_project_wrapper.r21b.gds.xz > SHA256SUMS && cat SHA256SUMS && ls -la"
echo "== staged size"; $SSH $HP "cd ~/$FM && du -sh tooling_ws audit_20260924 testbenches scripts_session dashboard reports r21b"
