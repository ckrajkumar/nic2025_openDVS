# Lumped resistive model of the VddA18 supply of the pixel array (r19 vs r20), sky130 typical sheet/via resistances.
# Geometry measured on the wrapper: top/bottom met3 rings 10 um x 1692 um fed at the corners from the met4 side bars;
# 64 2x2-columns at 24.08 um pitch, each fed from both rings through two 0.73 um met4 lines across the 100 um periphery (~3.2 ohm per end);
# column mesh ~27 ohm end to end (64 2x2 segments); r20 adds 10 wrapper met4 stripe feeds per edge (1.6 um wide, 227-258 um from the
# nearest via4 crossing of the met5 grid) landing on the first 2x2 of the column under them.
import numpy as np, sys
RS = dict(met3=0.047, met4=0.047, met5=0.0285); R_via4 = 0.38
NCOL, NSEG = 64, 64
pitch = 24.08; ring_seg = pitch/10*RS["met3"]           # ring resistance per column pitch
R_corner = 0.40                                          # bar segment to nearest via4 crossing + via4 group + corner via3 array
R_end = 3.2                                              # periphery feed line per column end
R_col = 27.0/NSEG                                        # per 2x2 segment
feeds_x = [1263.04 + k*153.6 for k in range(10)]         # wrapper x of the vdda1 stripes (um)
feed_len = {1263.04:227.6, 1416.64:230.0, 1570.24:227.6, 1723.84:257.6, 1877.44:227.6, 2031.04:227.6, 2184.64:230.0, 2338.24:227.6, 2491.84:227.6, 2645.44:227.6}
def solve(with_feeds, feed_R_override=None, I_total=3.7e-3):
    # nodes: ring_top[64] (0..63), ring_bot[64] (64..127), col[c][s] (128 + c*NSEG + s), s=0 at the top
    N = 2*NCOL + NCOL*NSEG; G = np.zeros((N, N)); I = np.zeros(N)
    def add(a, b, R):
        g = 1.0/R
        if a is not None: G[a, a] += g
        if b is not None: G[b, b] += g
        if a is not None and b is not None: G[a, b] -= g; G[b, a] -= g
    rt = lambda c: c; rb = lambda c: NCOL + c; cn = lambda c, s: 2*NCOL + c*NSEG + s
    for c in range(NCOL - 1): add(rt(c), rt(c+1), ring_seg); add(rb(c), rb(c+1), ring_seg)
    for r in (rt(0), rt(NCOL-1), rb(0), rb(NCOL-1)): add(r, None, R_corner)          # corners to the PDN (0 V)
    for c in range(NCOL):
        add(rt(c), cn(c, 0), R_end); add(rb(c), cn(c, NSEG-1), R_end)
        for s in range(NSEG - 1): add(cn(c, s), cn(c, s+1), R_col)
        for s in range(NSEG): I[cn(c, s)] = -I_total/(NCOL*NSEG)
    if with_feeds:
        for x in feeds_x:
            c = int((x - 1206.885)/pitch); L = feed_len[round(x, 2)]
            Rf = feed_R_override if feed_R_override is not None else RS["met4"]*L/1.6 + R_via4
            add(cn(c, 0), None, Rf); add(cn(c, NSEG-1), None, Rf)
    V = np.linalg.solve(G, I)
    cols = V[2*NCOL:].reshape(NCOL, NSEG)
    return -cols, -V[:NCOL]
for label, wf, Rf in (("r19 (rings fed at the corners only)", False, None), ("r20 (+20 met4 stripe feeds, ~7 ohm each)", True, None),
                      ("r20 + met5 plate over the periphery band (feeds ~0.5 ohm)", True, 0.5)):
    for I in (2.1e-3, 3.7e-3):
        d, ring = solve(wf, Rf, I)
        print("%-62s I=%.1f mA: worst VddA18 drop %.3f mV (column %d, row %d), ring mid %.3f mV, mean %.3f mV, R_eff(worst) %.2f ohm" % (
            label, I*1e3, d.max()*1e3, np.unravel_index(d.argmax(), d.shape)[0], np.unravel_index(d.argmax(), d.shape)[1], ring[NCOL//2]*1e3, d.mean()*1e3, d.max()/I))
