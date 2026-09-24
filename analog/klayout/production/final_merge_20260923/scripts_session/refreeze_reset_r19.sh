#!/bin/bash
# Re-derive the Magic reset netlist of the r19 campaign from the (shunted) base and re-freeze its hash.
set -euo pipefail
C=~/.cache/opencode/opendvs-pex/campaign-edit20260922r19-v1; cd "$C"
B=sources/openDVS_pixel2x2_magic_rcc_ngspice.spice; R=sources/openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.spice
OLDMR=$(sha256sum $R | cut -c1-64)
[ -e $R.stale-hash ] || cp $R $R.stale-hash
python3 - "$B" "$R" <<'PY'
import sys, hashlib, importlib.util
b, r = sys.argv[1], sys.argv[2]
spec = importlib.util.spec_from_file_location("d", "tooling/v38l/derive_reset_netlist.py"); m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
data = open(b, "rb").read(); sha = hashlib.sha256(data).hexdigest()
out = m.derive("magic_rcc_ngspice", data, sha)
if isinstance(out, str): out = out.encode()
open(r, "wb").write(out); print("derived", len(out), "base sha", sha[:16])
PY
NEWMR=$(sha256sum $R | cut -c1-64)
echo "reset sha $OLDMR -> $NEWMR"
echo "old hash in tooling: $(grep -c "$OLDMR" tooling/v38l/static_campaign.py tooling/v38l/reset_campaign.py | tr '\n' ' ')  manifest: $(grep -c "$OLDMR" manifest.json || true)"
sed -i "s/$OLDMR/$NEWMR/g" tooling/v38l/static_campaign.py tooling/v38l/reset_campaign.py manifest.json
python3 tooling/v38l/campaign_manifest.py --validate manifest.json | tail -2 || { echo "manifest invalid after sed -> regenerate"; python3 tooling/v38l/campaign_manifest.py --write manifest.json | tail -2; python3 tooling/v38l/campaign_manifest.py --validate manifest.json | tail -2; }
diff <(tail -n +5 $R) $B > /dev/null && echo "reset body identical to base"
cp $R ~/.cache/opencode/opendvs-pex/edited-pixel-magic-20260921-v1/r19/openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.spice
echo done
