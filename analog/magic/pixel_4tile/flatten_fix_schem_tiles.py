#!/usr/bin/env python3
"""Flatten pixel_layout_tile* into pixel_4tile_schem and fix nets for Magics LVS.

Reads pixel_4tile_schem.spice.bak_pre_flatten (or pixel_4tile_schem.spice) and writes
pixel_4tile_schem.spice with:

1. Top-tile column nets merged (orphan readLine nets shorted to col_amp COL_LINE)
2. Bot-tile rowRead ON/OFF polarity + index assignment fixed to match layout
3. Tile hierarchy flattened into pixel_4tile_schem (case-insensitive port map)
4. Duplicate pre_charge_global_bot_left port renamed to pre_charge_global_top_left
5. Bias pin names OnBn/OffBn and PrSFBp/RefrBp swapped to match layout
6. Top dac_config_1/2 and dac_config_4/5 names swapped to match layout
"""
from __future__ import annotations

import re
from collections import defaultdict
from pathlib import Path

DIR = Path(__file__).resolve().parent
SRC_BAK = DIR / "pixel_4tile_schem.spice.bak_pre_flatten"
SRC = DIR / "pixel_4tile_schem.spice"


def unfold_lines(block: str):
    lines, cur = [], ""
    for l in block.splitlines():
        if l.startswith("+"):
            cur += " " + l[1:].strip()
        else:
            if cur:
                lines.append(cur)
            cur = l
    if cur:
        lines.append(cur)
    return lines


def fold_line(line: str, width=90):
    toks = line.split()
    if not toks:
        return line
    rows, cur = [], toks[0]
    for t in toks[1:]:
        if len(cur) + 1 + len(t) > width:
            rows.append(cur)
            cur = "+ " + t
        else:
            cur = cur + " " + t
    rows.append(cur)
    return "\n".join(rows)


def split_subckts(text: str):
    parts, last = [], 0
    pattern = re.compile(r"^\.subckt\s+(\S+)\b.*?^\.ends\s*$", re.M | re.S)
    for m in pattern.finditer(text):
        if m.start() > last:
            parts.append(("text", text[last : m.start()]))
        parts.append(("subckt", m.group(1), m.group(0)))
        last = m.end()
    if last < len(text):
        parts.append(("text", text[last:]))
    return parts


def parse_inst(line: str):
    toks = line.split()
    name = toks[0]
    idx = len(toks) - 1
    while idx > 0 and "=" in toks[idx]:
        idx -= 1
    return name, toks[idx], toks[1:idx], toks[idx + 1 :]


def get_ports_and_body(block: str):
    lines = unfold_lines(block)
    header = lines[0].split()
    name, ports = header[1], header[2:]
    body = []
    for l in lines[1:]:
        if not l or l.startswith("*") or l.lower().startswith(".ends"):
            continue
        if l.lower().startswith(".pininfo"):
            continue
        body.append(l)
    return name, ports, body


def rebuild_subckt(name, ports, body, pininfo=None):
    out = [fold_line(".subckt " + name + " " + " ".join(ports))]
    if pininfo:
        out.append(pininfo)
    for line in body:
        out.append(fold_line(line))
    out.append(".ends")
    return "\n".join(out) + "\n"


def swap_tokens(s: str, a: str, b: str) -> str:
    tmp = f"__TMP_SWAP_{a}__"
    s = re.sub(rf"\b{re.escape(a)}\b", tmp, s)
    s = re.sub(rf"\b{re.escape(b)}\b", a, s)
    s = re.sub(rf"\b{re.escape(tmp)}\b", b, s)
    return s


def main():
    text = (SRC_BAK if SRC_BAK.exists() else SRC).read_text(errors="replace")
    if not SRC_BAK.exists():
        SRC_BAK.write_text(text)

    parts = split_subckts(text)
    subckts = {p[1]: p[2] for p in parts if p[0] == "subckt"}

    # ----- Bot rowRead: pin[i] <- matching-polarity bus at (lo,hi) -----
    def fix_bot_rowread(block: str) -> str:
        name, ports, body = get_ports_and_body(block)
        pix = "openDVS_pixel2x2_bot"
        pix_ports = get_ports_and_body(subckts[pix])[1]
        row_pins = {p: i for i, p in enumerate(pix_ports) if p.startswith("rowRead")}
        fixed = 0
        new_body = []
        for line in body:
            if not line.lower().startswith("x"):
                new_body.append(line)
                continue
            iname, cell, pins, params = parse_inst(line)
            if cell != pix:
                new_body.append(line)
                continue
            pins = list(pins)
            nets = [pins[i] for i in row_pins.values()]
            idxs = sorted({int(re.search(r"\[(\d+)\]", n).group(1)) for n in nets})
            if len(idxs) != 2:
                raise RuntimeError(f"{iname}: expected 2 row indices, got {idxs}")
            lo, hi = idxs
            desired = {
                "rowReadOFF[0]": f"rowReadOFF[{lo}]",
                "rowReadOFF[1]": f"rowReadOFF[{hi}]",
                "rowReadON[0]": f"rowReadON[{lo}]",
                "rowReadON[1]": f"rowReadON[{hi}]",
            }
            changed = False
            for pin_name, idx in row_pins.items():
                if pins[idx] != desired[pin_name]:
                    pins[idx] = desired[pin_name]
                    changed = True
            if changed:
                fixed += 1
            new_body.append(" ".join([iname] + pins + [cell] + params))
        pininfo = next(
            (l for l in unfold_lines(block) if l.lower().startswith(".pininfo")), None
        )
        print(f"fixed bot rowRead instances: {fixed}")
        return rebuild_subckt(name, ports, new_body, pininfo)

    subckts["pixel_layout_tile_bot"] = fix_bot_rowread(subckts["pixel_layout_tile_bot"])

    # ----- Merge orphan column nets in top tile -----
    def column_merge_map(tile_name: str, pix_cell: str):
        _, _, body = get_ports_and_body(subckts[tile_name])
        pix_ports = get_ports_and_body(subckts[pix_cell])[1]
        amp_ports = get_ports_and_body(subckts["col_amp_2x1"])[1]
        portmap = {pix_cell: pix_ports, "col_amp_2x1": amp_ports}
        net_use = defaultdict(list)
        for line in body:
            if not line.lower().startswith("x"):
                continue
            name, cell, pins, _ = parse_inst(line)
            pm = portmap.get(cell)
            for i, p in enumerate(pins):
                if re.fullmatch(r"net\d+", p):
                    pn = pm[i] if pm and i < len(pm) else f"#{i}"
                    net_use[p].append((name, cell, pn))
        amp_map = {}
        for net, uses in net_use.items():
            for name, cell, pn in uses:
                if cell != "col_amp_2x1":
                    continue
                m = re.match(r"COL_LINE(\d)", pn)
                if m:
                    amp_map.setdefault(name, {})[int(m.group(1))] = net
        orphan = {
            n
            for n, uses in net_use.items()
            if all(c == pix_cell for _, c, _ in uses)
        }
        mapping = {}
        for amp, lines in amp_map.items():
            for li, net_amp in lines.items():
                pix_on = [n for n, c, _ in net_use[net_amp] if c == pix_cell]
                if not pix_on:
                    continue
                base_num = int(pix_on[0][1:])
                want = f"readLine[{li}]"
                cands = []
                for net in orphan:
                    uses = net_use[net]
                    pixs = [n for n, c, _ in uses if c == pix_cell]
                    nums = [int(p[1:]) for p in pixs]
                    pins = {pn for _, c, pn in uses if c == pix_cell}
                    if (
                        want in pins
                        and nums
                        and all((n % 32) == (base_num % 32) for n in nums)
                    ):
                        cands.append(net)
                if len(cands) != 1:
                    raise RuntimeError(f"{tile_name}: bad merge for {net_amp}: {cands}")
                mapping[cands[0]] = net_amp
        return mapping

    merge_top = column_merge_map("pixel_layout_tile", "openDVS_pixel2x2_top")
    print("column merges", len(merge_top))

    def apply_net_renames(block: str, mapping: dict) -> str:
        if not mapping:
            return block
        name, ports, body = get_ports_and_body(block)
        new_body = []
        for line in body:
            if line.lower().startswith("x"):
                n, cell, pins, params = parse_inst(line)
                pins = [mapping.get(p, p) for p in pins]
                new_body.append(" ".join([n] + pins + [cell] + params))
            else:
                new_body.append(" ".join(mapping.get(t, t) for t in line.split()))
        pininfo = next(
            (l for l in unfold_lines(block) if l.lower().startswith(".pininfo")), None
        )
        return rebuild_subckt(name, ports, new_body, pininfo)

    subckts["pixel_layout_tile"] = apply_net_renames(
        subckts["pixel_layout_tile"], merge_top
    )

    # ----- Flatten tiles into top -----
    TILE_CELLS = {"pixel_layout_tile", "pixel_layout_tile_bot"}

    def map_token(tok, portmap, lower_ports, local_prefix):
        if tok in portmap:
            return portmap[tok]
        key = tok.lower()
        if key in lower_ports:
            return lower_ports[key][1]
        if re.fullmatch(r"net\d+", tok):
            return f"{local_prefix}{tok}"
        return tok

    def flatten_top(top_block: str) -> str:
        name, ports, body = get_ports_and_body(top_block)
        new_body = []
        for line in body:
            if not line.lower().startswith("x"):
                new_body.append(line)
                continue
            iname, cell, pins, params = parse_inst(line)
            if cell not in TILE_CELLS:
                new_body.append(line)
                continue
            _, tports, tbody = get_ports_and_body(subckts[cell])
            if len(pins) != len(tports):
                raise RuntimeError(f"{iname}: pin count mismatch")
            portmap = dict(zip(tports, pins))
            lower_ports = {p.lower(): (p, pins[i]) for i, p in enumerate(tports)}
            prefix = f"{iname}_"
            for tline in tbody:
                if tline.lower().startswith("x"):
                    n, c, ps, pr = parse_inst(tline)
                    ps = [map_token(p, portmap, lower_ports, prefix) for p in ps]
                    new_body.append(" ".join([prefix + n] + ps + [c] + pr))
                else:
                    toks = [
                        map_token(t, portmap, lower_ports, prefix)
                        for t in tline.split()
                    ]
                    new_body.append(" ".join(toks))

        new_ports, seen, fixed_dup = [], set(), False
        for p in ports:
            if p == "pre_charge_global_bot_left" and p in seen and not fixed_dup:
                new_ports.append("pre_charge_global_top_left")
                fixed_dup = True
                continue
            new_ports.append(p)
            seen.add(p)
        if "pre_charge_global_top_left" not in new_ports:
            new_ports.append("pre_charge_global_top_left")
        print("fixed duplicate pre_charge port", fixed_dup)
        pininfo = next(
            (l for l in unfold_lines(top_block) if l.lower().startswith(".pininfo")),
            None,
        )
        if (
            pininfo
            and pininfo.count("pre_charge_global_bot_left") >= 2
            and "pre_charge_global_top_left" not in pininfo
        ):
            pininfo = pininfo.replace(
                "pre_charge_global_bot_left", "pre_charge_global_top_left", 1
            )
        return rebuild_subckt(name, new_ports, new_body, pininfo)

    subckts["pixel_4tile_schem"] = flatten_top(subckts["pixel_4tile_schem"])

    # Bias + dac name swaps to match layout
    for cell in [
        "openDVS_pixel",
        "openDVS_pixel2x2_top",
        "openDVS_pixel2x2_bot",
        "openDVS_pixel2x2",
    ]:
        if cell in subckts:
            block = subckts[cell]
            block = swap_tokens(block, "OnBn", "OffBn")
            block = swap_tokens(block, "PrSFBp", "RefrBp")
            subckts[cell] = block
            print("swapped bias names in", cell)

    top = subckts["pixel_4tile_schem"]
    top = swap_tokens(top, "dac_config_1", "dac_config_2")
    top = swap_tokens(top, "dac_config_4", "dac_config_5")
    subckts["pixel_4tile_schem"] = top
    print("swapped dac_config 1/2 and 4/5 in top")

    out_parts = []
    for p in parts:
        if p[0] == "text":
            out_parts.append(p[1])
        else:
            _, sname, _ = p
            if sname in TILE_CELLS:
                out_parts.append(f"* Removed (flattened into top): {sname}\n")
                continue
            block = subckts.get(sname, p[2])
            out_parts.append(block if block.endswith("\n") else block + "\n")

    SRC.write_text("".join(out_parts))
    print("wrote", SRC)


if __name__ == "__main__":
    main()
