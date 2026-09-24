import pya, sys
sys.path.insert(0, '.'); import opendvs_l2n
ly = pya.Layout(); ly.read('pixel_4tile_work.gds'); c = ly.cell('openDVS_pixel2x2_top')
l2n = opendvs_l2n.build_l2n(ly, c); top = l2n.netlist().top_circuit()
n = 0
for net in top.each_net():
    nm = net.expanded_name()
    if nm and not nm.startswith('$'): continue
    n += 1
    if n > 8: break
    parts = []
    for ln in ('li', 'met1', 'via1', 'met2', 'met3', 'met4', 'poly'):
        r = l2n.shapes_of_net(net, l2n.layer_by_name(ln), True)
        if not r.is_empty(): b = r.bbox(); parts.append('%s(%.2f,%.2f;%.2f,%.2f)' % (ln, b.left/1e3, b.bottom/1e3, b.right/1e3, b.top/1e3))
    print('unnamed net', nm, ' '.join(parts) or '(no conductor shapes)')
print('unnamed nets total:', sum(1 for net in top.each_net() if not net.expanded_name() or net.expanded_name().startswith('$')))
