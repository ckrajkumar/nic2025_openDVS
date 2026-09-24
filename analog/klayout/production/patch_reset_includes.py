import sys, pathlib
p = pathlib.Path(sys.argv[1]); s = p.read_text()
old = '''    lines = [line.replace(base_source, reset_source) for line in lines]
    return [
        lines[0],
        f".include {_source_path(sources, 'ngspice_nonfet_corner_' + condition['corner'])}",
        f".include {_source_path(sources, 'ngspice_parasitic_diode_model')}",
        *lines[1:],
    ]
'''
new = '''    lines = [line.replace(base_source, reset_source) for line in lines]
    # edit20260922 v38l: the static include builder now emits the nonfet corner
    # and parasitic-diode includes itself; drop them here and re-insert them in
    # the frozen reset order (lib, nonfet, diode, DUT) so they occur exactly once.
    nonfet = f".include {_source_path(sources, 'ngspice_nonfet_corner_' + condition['corner'])}"
    diode = f".include {_source_path(sources, 'ngspice_parasitic_diode_model')}"
    lines = [line for line in lines if line not in (nonfet, diode)]
    return [lines[0], nonfet, diode, *lines[1:]]
'''
assert s.count(old) == 1, "anchor not found once"
p.write_text(s.replace(old, new)); print("patched", p)
