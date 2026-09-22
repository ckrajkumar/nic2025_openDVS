#!/usr/bin/env -S -u LD_LIBRARY_PATH bash
# One-shot check of the saved pixel_4tile_work.gds: what changed vs the pristine macro (per cell,
# per layer), that no variant cells appeared, and the 2x2 LVS verdict against the xschem schematic.
set -euo pipefail
D="$(cd "$(dirname "$0")" && pwd)"; cd "$D"
K="$HOME/git/klayout/bin-release/klayout"; export LD_LIBRARY_PATH="$HOME/git/klayout/bin-release:$HOME/anaconda3/lib"
echo "== work file: $(stat -c '%y' pixel_4tile_work.gds)"
echo "== 1. changes vs pristine (own shapes per cell; instances; new cells)"
cat > lvs/propcheck.py <<'PY'
import pya
A = pya.Layout(); A.read("pixel_4tile_mag_9_1_pruned.gds"); B = pya.Layout(); B.read("pixel_4tile_work.gds")
ca, cb = {c.name for c in A.each_cell()}, {c.name for c in B.each_cell()}
print("   cells %d -> %d; new: %s; removed: %s" % (len(ca), len(cb), sorted(cb - ca), sorted(ca - cb)))
def own(ly, c): return {(ly.get_info(l).layer, ly.get_info(l).datatype): pya.Region(c.shapes(l)) for l in ly.layer_indexes() if c.shapes(l).size()}
def insts(c): return sorted((i.cell.name, str(i.trans)) for i in c.each_inst())
for name in sorted(ca & cb):
    a, b = A.cell(name), B.cell(name); oa, ob = own(A, a), own(B, b); d = []
    for k in sorted(set(oa) | set(ob)):
        x = oa.get(k, pya.Region()) ^ ob.get(k, pya.Region())
        if not x.is_empty(): d.append("%d/%d %d->%d shapes, xor %.3f um2 at %s" % (k[0], k[1], oa.get(k, pya.Region()).count(), ob.get(k, pya.Region()).count(), x.area() / 1e6, x.bbox()))
    if d or insts(a) != insts(b):
        print("   CHANGED", name); [print("      " + s) for s in d]
        if insts(a) != insts(b): print("      instances changed")
for n in ("openDVS_pixel_4x4", "pixel_layout_tile", "pixel_layout_tile_bot"):
    c = B.cell(n); print("   %s -> %s" % (n, sorted({i.cell.name for i in c.each_inst() if "pixel2x2" in i.cell.name})))
PY
"$K" -b -r lvs/propcheck.py 2>&1 | grep -v libcurl
echo "== 2. LVS 2x2 (deep extraction + flattened compare)"
RUN_MODE=deep TAG=.work.deep ./run_lvs_2x2.sh >/dev/null 2>&1 || true
"$K" -b -r lvs_compare_flat.py -rd db=lvs/openDVS_pixel2x2_top.work.deep.lvsdb 2>&1 | grep -v libcurl | head -25
echo "== 3. flat 2x2 connectivity: nets per label name (4 = one per pixel, shared lines = 1)"
cat > lvs/flatnets.py <<'PY'
import pya, sys; sys.path.insert(0, "."); import opendvs_l2n
from collections import Counter
for tag, f in (("pristine", "pixel_4tile_mag_9_1_pruned.gds"), ("work    ", "pixel_4tile_work.gds")):
    ly = pya.Layout(); ly.read(f); c = ly.cell("openDVS_pixel2x2_top"); c.flatten(True)
    l2n = opendvs_l2n.build_l2n(ly, c); top = l2n.netlist().top_circuit(); cnt = Counter(n.name for n in top.each_net() if n.name)
    print("   %s %d nets  %s" % (tag, len(list(top.each_net())), dict(sorted(cnt.items()))))
PY
"$K" -b -r lvs/flatnets.py 2>&1 | grep -v libcurl
