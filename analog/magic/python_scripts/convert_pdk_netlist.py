#!/usr/bin/env python3
"""Convert sky130 netlists between the three PDK dialects used in openDVS.

Dialects:
  open     open_pdks / ciel (xschem + ngspice).  Devices are subckt calls:
             XM1 d g s b sky130_fd_pr__nfet_01v8 L=0.15 W=1 nf=1 ...
  s130     closed SkyWater-for-Cadence PDK (CDL / auCdl style):
             MM1 d g s b nmos W=1 L=0.15 M=1
             CC1 a b cm3m4 A=6.79 P=15.04 m=1
             DD1 a c ddnw_sub area=32.49 pj=22.8 m=1
  cadence  Cadence-distributed sky130 release (~/sky130).  Same card style as
           s130 but with nfet_01v8 / pfet_01v8 / cap_mim_m3 / diode_* names;
           diodes netlist positionally: DD0 a c diode_pd2nw_05v5 0.36 2.4 m=1

Usage:
  convert_pdk_netlist.py IN --to {open,s130,cadence} [-o OUT]
                         [--from {auto,open,s130,cadence}] [--format {bare,lvs,sim}]
                         [--keep-geom]

The device table below is seeded with the mappings verified against
pixel_4tile.spice vs pixel_4tile.src.net (same design in two dialects).
Entries marked verified=False are educated guesses -- extend/correct the table
from the closed PDK's PV/Calibre/LVS/source.cdl + rule deck when available.
Unknown devices are a hard error.
"""

import argparse
import math
import os
import re
import sys

DIALECTS = ("open", "s130", "cadence")

# ---------------------------------------------------------------------------
# Device mapping table.
# kind: mos | mimcap | diode
# names per dialect; None = no known equivalent (hard error if requested).
# verified: mapping confirmed against real netlists / PDK collateral.
# ---------------------------------------------------------------------------
# s130 names verified against the closed PDK's spectre models
# (open_src_spice_pixel_4tile/models.scs, obtained 2026-07-08).  Its MOS
# subckts take the same parameter set as the open PDK (l w ad as pd ps nrd
# nrs sa sb sd nf); cm3m4/cm4m5 subckts take w l, while auCdl netlists A/P.
# Not mapped (extend if ever needed): s130 BJTs (npn_1x1, npn_1x2, pnp,
# pnp_5x), resistors (rpoly, rpoly_hp, rpoly_hp2K, rpwell), drain-extended
# FETs (nmos_de_v12, pmos_de_v12), and dnw_sub_photo / dnw_ipw diodes.
DEVICES = [
    # --- 1.8 V FETs (verified: pixel_4tile.spice <-> pixel_4tile.cdl) ---
    dict(kind="mos", open="sky130_fd_pr__nfet_01v8", s130="nmos",
         cadence="nfet_01v8", verified=True),
    dict(kind="mos", open="sky130_fd_pr__pfet_01v8", s130="pmos",
         cadence="pfet_01v8", verified=True),
    dict(kind="mos", open="sky130_fd_pr__pfet_01v8_hvt", s130="pmos_hvt",
         cadence="pfet_01v8_hvt", verified=True),
    dict(kind="mos", open="sky130_fd_pr__nfet_01v8_lvt", s130="nmos_lvt",
         cadence="nfet_01v8_lvt", verified=True),
    dict(kind="mos", open="sky130_fd_pr__pfet_01v8_lvt", s130="pmos_lvt",
         cadence="pfet_01v8_lvt", verified=True),
    # --- 5 V / native FETs ---
    dict(kind="mos", open="sky130_fd_pr__nfet_g5v0d10v5", s130="nmos_v5",
         cadence="nfet_g5v0d10v5", verified=True),
    dict(kind="mos", open="sky130_fd_pr__pfet_g5v0d10v5", s130="pmos_v5",
         cadence="pfet_g5v0d10v5", verified=True),
    dict(kind="mos", open="sky130_fd_pr__nfet_03v3_nvt", s130="nmos_nat_v3",
         cadence="nfet_03v3_nvt", verified=True),
    dict(kind="mos", open="sky130_fd_pr__nfet_05v0_nvt", s130="nmos_nat_v5",
         cadence="nfet_05v0_nvt", verified=True),
    # --- ESD FETs (name pairing plausible, semantics unchecked) ---
    dict(kind="mos", open="sky130_fd_pr__esd_nfet_01v8", s130="nmos_esd",
         cadence="esd_nfet_01v8", verified=False),
    dict(kind="mos", open="sky130_fd_pr__esd_nfet_g5v0d10v5",
         s130="nmos_esd_v5", cadence="esd_nfet_g5v0d10v5", verified=False),
    dict(kind="mos", open="sky130_fd_pr__esd_nfet_05v0_nvt",
         s130="nmos_esd_nat_v5", cadence="esd_nfet_05v0_nvt", verified=False),
    dict(kind="mos", open="sky130_fd_pr__esd_pfet_g5v0d10v5",
         s130="pmos_esd_v5", cadence="esd_pfet_g5v0d10v5", verified=False),
    # --- MiM caps (open<->s130 verified incl. A=W*L, P=2(W+L) arithmetic) ---
    dict(kind="mimcap", open="sky130_fd_pr__cap_mim_m3_1", s130="cm3m4",
         cadence="cap_mim_m3", verified=True, cadence_verified=False),
    dict(kind="mimcap", open="sky130_fd_pr__cap_mim_m3_2", s130="cm4m5",
         cadence=None, verified=True),
    # --- parasitic diodes (photodiode pair verified in extracted netlist) ---
    dict(kind="diode", open="sky130_fd_pr__model__parasitic__diode_ps2dn",
         s130="ddnw_sub", cadence=None, verified=True),
    dict(kind="diode", open="sky130_fd_pr__model__parasitic__diode_pw2dn",
         s130="dipw_dnw", cadence=None, verified=True),
    # --- junction diodes (s130 names from models.scs; voltage-class pairing
    #     inferred: 05v5 <-> base/_lvt/_hvt/_nat, 11v0 <-> _v5) ---
    dict(kind="diode", open="sky130_fd_pr__diode_pw2nd_05v5", s130="dnsd_pw",
         cadence="diode_pw2nd_05v5", verified=False),
    dict(kind="diode", open="sky130_fd_pr__diode_pw2nd_05v5_lvt",
         s130="dnsd_pw_lvt", cadence="diode_pw2nd_05v5_lvt", verified=False),
    dict(kind="diode", open="sky130_fd_pr__diode_pw2nd_05v5_nvt",
         s130="dnsd_pw_nat", cadence="diode_pw2nd_05v5_nvt", verified=False),
    dict(kind="diode", open="sky130_fd_pr__diode_pw2nd_11v0",
         s130="dnsd_pw_v5", cadence="diode_pw2nd_11v0", verified=False),
    dict(kind="diode", open="sky130_fd_pr__diode_pd2nw_05v5", s130="dpsd_nw",
         cadence="diode_pd2nw_05v5", verified=False),
    dict(kind="diode", open="sky130_fd_pr__diode_pd2nw_05v5_hvt",
         s130="dpsd_nw_hvt", cadence="diode_pd2nw_05v5_hvt", verified=False),
    dict(kind="diode", open="sky130_fd_pr__diode_pd2nw_05v5_lvt",
         s130="dpsd_nw_lvt", cadence="diode_pd2nw_05v5_lvt", verified=False),
    dict(kind="diode", open="sky130_fd_pr__diode_pd2nw_11v0",
         s130="dpsd_nw_v5", cadence="diode_pd2nw_11v0", verified=False),
]

OPEN_PREFIX = "sky130_fd_pr__"

# rule-based open<->cadence fallback: cadence cell name == open name minus
# prefix, for these families (confirmed by ~/sky130/cells listing)
CADENCE_RULE = re.compile(r"^(nfet_|pfet_|esd_nfet_|esd_pfet_|diode_|res_)")


def build_lookup():
    lut = {d: {} for d in DIALECTS}
    for entry in DEVICES:
        for d in DIALECTS:
            name = entry.get(d)
            if name:
                lut[d][name.lower()] = entry
    return lut


LOOKUP = build_lookup()

warned = set()


def warn(msg):
    if msg not in warned:
        warned.add(msg)
        sys.stderr.write("WARNING: %s\n" % msg)


# ---------------------------------------------------------------------------
# Netlist reading: join '+' continuations into logical lines, keep comments.
# ---------------------------------------------------------------------------
def logical_lines(text):
    out = []  # list of [kind, text]  kind: card|comment|blank
    for raw in text.splitlines():
        line = raw.rstrip()
        s = line.strip()
        if not s:
            out.append(["blank", ""])
        elif s.startswith("*"):
            out.append(["comment", line])
        elif s.startswith("+"):
            for item in reversed(out):
                if item[0] == "card":
                    item[1] += " " + s[1:].strip()
                    break
            else:
                out.append(["comment", "* orphan continuation: " + s])
        else:
            out.append(["card", s])
    return out


NUM_RE = re.compile(r"^[-+]?(\d+\.?\d*|\.\d+)([eE][-+]?\d+)?$")


def clean_token(tok):
    """Normalize Calibre-extracted annotations: $[model] -> model,
    $A=/$P=/$W=/$L= -> A=/P=/W=/L=, drop $X/$Y/$D/$T/$SUB etc."""
    if tok.startswith("$["):
        return tok[2:].rstrip("]")
    m = re.match(r"^\$(\w+)=(.*)$", tok)
    if m:
        if m.group(1).upper() in ("A", "P", "W", "L", "AREA", "PJ", "PERIM"):
            return "%s=%s" % (m.group(1), m.group(2))
        return None
    if tok.startswith("$"):
        return None
    return tok


class Card:
    __slots__ = ("name", "nodes", "model", "params", "positional", "is_call")

    def __init__(self, name, nodes, model, params, positional, is_call):
        self.name = name
        self.nodes = nodes
        self.model = model
        self.params = params          # dict, lowercase keys, insertion order
        self.positional = positional  # tokens after model that are numbers
        self.is_call = is_call        # True if written as X subckt call


def parse_card(line):
    toks = [clean_token(t) for t in line.split()]
    toks = [t for t in toks if t]
    name = toks[0]
    rest = toks[1:]
    # auCdl hierarchical call:  X... nodes / subcktName [params]
    if "/" in rest:
        i = rest.index("/")
        nodes, model = rest[:i], rest[i + 1]
        tail = rest[i + 2:]
    else:
        # model = last token that is neither k=v nor a bare number
        idx = None
        for i in range(len(rest) - 1, -1, -1):
            t = rest[i]
            if "=" in t or NUM_RE.match(t):
                continue
            idx = i
            break
        if idx is None or idx == 0:
            return None
        nodes, model, tail = rest[:idx], rest[idx], rest[idx + 1:]
    params, positional = {}, []
    for t in tail:
        if "=" in t:
            k, v = t.split("=", 1)
            params[k.lower()] = v
        elif NUM_RE.match(t):
            positional.append(t)
    return Card(name, nodes, model, params, positional,
                name[0] in "xX")


# ---------------------------------------------------------------------------
# Dialect detection
# ---------------------------------------------------------------------------
def detect_dialect(lines):
    """Score actual device-card model names per dialect (raw text matching is
    unreliable: extracted netlists carry sky130_fd_pr__* layout cell names)."""
    local = set()
    for kind, t in lines:
        if kind == "card" and t.lower().startswith(".subckt"):
            parts = t.split()
            if len(parts) > 1:
                local.add(parts[1].lower())
    score = {d: 0 for d in DIALECTS}
    for kind, t in lines:
        if kind != "card" or t[0] == ".":
            continue
        if t[0].lower() not in "xmcdrq":
            continue
        card = parse_card(t)
        if card is None:
            continue
        ml = card.model.lower()
        if ml in local:
            continue
        for d in DIALECTS:
            if ml in LOOKUP[d]:
                score[d] += 1
        if ml.startswith(OPEN_PREFIX):
            score["open"] += 1
    best = max(score, key=score.get)
    if score[best] == 0:
        sys.exit("ERROR: cannot auto-detect source dialect; use --from")
    return best


# ---------------------------------------------------------------------------
# Instance-name helpers
# ---------------------------------------------------------------------------
def as_prim_name(name, letter):
    """X-call name -> primitive card name starting with `letter`."""
    n = name[1:] if name[0] in "xX" else name
    if not n or n[0].upper() != letter:
        n = letter + n
    return n


def as_call_name(name):
    return name if name[0] in "xX" else "X" + name


def fmt(v):
    if isinstance(v, float):
        s = ("%.6f" % v).rstrip("0").rstrip(".")
        return s if s else "0"
    return str(v)


def num(v):
    return float(v)


# ---------------------------------------------------------------------------
# Per-kind emitters
# ---------------------------------------------------------------------------
def convert_mos(card, entry, target, keep_geom):
    p = card.params
    W, L = p.get("w"), p.get("l")
    if W is None or L is None:
        raise ValueError("MOS %s missing W/L" % card.name)
    mult = p.get("m") or p.get("mult") or "1"
    nf = p.get("nf", "1")
    tname = entry[target]
    if target == "open":
        out = [as_call_name(card.name)] + card.nodes[:4] + [tname,
               "L=" + L, "W=" + W, "nf=" + nf, "mult=" + mult]
        if keep_geom:
            for k in ("ad", "as", "pd", "ps", "nrd", "nrs", "sa", "sb", "sd"):
                if k in p:
                    out.append("%s=%s" % (k, p[k]))
        return " ".join(out)
    out = [as_prim_name(card.name, "M")] + card.nodes[:4] + [tname,
           "W=" + W, "L=" + L, "M=" + mult]
    if nf not in ("1", "1.0"):
        out.append("nf=" + nf)
    if keep_geom:
        for k in ("ad", "as", "pd", "ps"):
            if k in p:
                out.append("%s=%s" % (k.upper(), p[k]))
    return " ".join(out)


def convert_mimcap(card, entry, target, keep_geom):
    p = card.params
    if "w" in p and "l" in p:
        W, L = num(p["w"]), num(p["l"])
        A, P = W * L, 2 * (W + L)
        mult = p.get("mf") or p.get("m") or "1"
    elif "a" in p and "p" in p:
        A, P = num(p["a"]), num(p["p"])
        disc = (P / 4.0) ** 2 - A
        if disc >= 0:
            W = P / 4.0 + math.sqrt(disc)
            L = A / W
        else:
            W = L = math.sqrt(A)
            warn("cap %s: A/P inconsistent (P too small for A); "
                 "using square W=L=sqrt(A)" % card.name)
        mult = p.get("m", "1")
    else:
        raise ValueError("cap %s: need W/L or A/P params" % card.name)
    tname = entry[target]
    if target == "open":
        return " ".join([as_call_name(card.name)] + card.nodes[:2] +
                        [tname, "W=" + fmt(W), "L=" + fmt(L), "MF=" + fmt(mult)])
    if target == "cadence" and not entry.get("cadence_verified", True):
        warn("cap_mim_m3 line format for the Cadence-distributed PDK is "
             "unverified; emitting CDL style 'C.. a b cap_mim_m3 A= P= m='")
    return " ".join([as_prim_name(card.name, "C")] + card.nodes[:2] +
                    [tname, "A=" + fmt(A), "P=" + fmt(P), "m=" + fmt(mult)])


def convert_diode(card, entry, target, keep_geom):
    p = card.params
    if card.positional and "area" not in p:
        area = card.positional[0]
        perim = card.positional[1] if len(card.positional) > 1 else "0"
    else:
        area = p.get("area") or p.get("a")
        perim = p.get("pj") or p.get("perim") or p.get("p") or "0"
    if area is None:
        raise ValueError("diode %s missing area" % card.name)
    mult = p.get("m", "1")
    tname = entry[target]
    if target == "open":
        return " ".join([as_call_name(card.name)] + card.nodes[:2] +
                        [tname, "area=" + area, "perim=" + perim])
    if target == "cadence":
        # positional area/perim per Sky130_LVS README
        return " ".join([as_prim_name(card.name, "D")] + card.nodes[:2] +
                        [tname, area, perim, "m=" + mult])
    return " ".join([as_prim_name(card.name, "D")] + card.nodes[:2] +
                    [tname, "area=" + area, "pj=" + perim, "m=" + mult])


CONVERTERS = {"mos": convert_mos, "mimcap": convert_mimcap,
              "diode": convert_diode}


# ---------------------------------------------------------------------------
# Fallback open<->cadence rule (systematic prefix strip/add)
# ---------------------------------------------------------------------------
def rule_entry(model, source, target):
    ml = model.lower()
    if source == "open" and target == "cadence" and ml.startswith(OPEN_PREFIX):
        short = ml[len(OPEN_PREFIX):]
        if CADENCE_RULE.match(short):
            kind = "mos" if "fet_" in short else "diode"
            return dict(kind=kind, open=model, cadence=short, s130=None,
                        verified=False)
    if source == "cadence" and target == "open" and CADENCE_RULE.match(ml):
        kind = "mos" if "fet_" in ml else "diode"
        return dict(kind=kind, open=OPEN_PREFIX + ml, cadence=model,
                    s130=None, verified=False)
    return None


# ---------------------------------------------------------------------------
# Headers
# ---------------------------------------------------------------------------
def header_lines(target, out_format):
    if out_format == "bare":
        return []
    h = ["* converted by convert_pdk_netlist.py (target=%s, format=%s)"
         % (target, out_format)]
    pdk_root = os.environ.get("PDK_ROOT",
                              os.path.expanduser("~/.ciel"))
    if target == "open":
        if out_format == "sim":
            h.append(".lib %s/sky130A/libs.tech/ngspice/sky130.lib.spice tt"
                     % pdk_root)
        else:
            h.append("* LVS source for netgen; no include needed")
    elif target == "s130":
        if out_format == "lvs":
            h.append(".INCLUDE $PDK_HOME/PV/Calibre/LVS/source.cdl")
        else:
            h.append("* TODO: s130 simulation models are not installed on "
                     "this machine; add the proper .lib/.include here")
    elif target == "cadence":
        if out_format == "lvs":
            h.append(".INCLUDE %s" %
                     os.path.expanduser("~/sky130/Sky130_LVS/source.cdl"))
        else:
            h.append("* simulation under the Cadence PDK is normally "
                     "netlisted by ADE/spectre; models in ~/sky130/models")
    return h


def wrap(line, width=100):
    if len(line) <= width:
        return [line]
    toks = line.split()
    out, cur = [], toks[0]
    for t in toks[1:]:
        if len(cur) + 1 + len(t) > width and cur.strip("+ "):
            out.append(cur)
            cur = "+ " + t
        else:
            cur += " " + t
    out.append(cur)
    return out


# ---------------------------------------------------------------------------
# Main conversion
# ---------------------------------------------------------------------------
DIRECTIVE_DROP = (".include", ".lib", ".option", ".param")


def convert(text, source, target, out_format, keep_geom):
    lines = logical_lines(text)
    if source == "auto":
        source = detect_dialect(lines)
        sys.stderr.write("INFO: detected source dialect: %s\n" % source)
    if source == target:
        warn("source and target dialect are both '%s'" % source)

    # first pass: collect local subckt names (hierarchy, passed through)
    local = set()
    for kind, t in lines:
        if kind == "card" and t.lower().startswith(".subckt"):
            parts = t.split()
            if len(parts) > 1:
                local.add(parts[1].lower())

    out = header_lines(target, out_format)
    stats = {}
    errors = []

    for kind, t in lines:
        if kind in ("comment", "blank"):
            out.append(t)
            continue
        tl = t.lower()
        if tl.startswith("."):
            word = tl.split()[0]
            if word in DIRECTIVE_DROP:
                out.append("* [dropped] " + t)
            else:
                out.append(t)
            continue
        first = t[0].lower()
        if first not in "xmcdrq":
            out.append(t)  # V/I sources etc. pass through
            continue
        card = parse_card(t)
        if card is None:
            out.append(t)
            continue
        ml = card.model.lower()
        # hierarchy?
        if ml in local:
            nodes = " ".join(card.nodes)
            extra = " ".join("%s=%s" % (k, v) for k, v in card.params.items())
            sep = " / " if target in ("s130", "cadence") else " "
            line = "%s %s%s%s" % (as_call_name(card.name), nodes, sep,
                                  card.model)
            if extra:
                line += " " + extra
            out.extend(wrap(line))
            continue
        entry = LOOKUP[source].get(ml) or rule_entry(card.model, source,
                                                     target)
        if entry is None:
            errors.append("unknown %s device '%s' (instance %s)"
                          % (source, card.model, card.name))
            out.append("* [UNCONVERTED] " + t)
            continue
        if entry.get(target) is None:
            errors.append("no %s equivalent known for '%s' (instance %s) -- "
                          "extend DEVICES table" % (target, card.model,
                                                    card.name))
            out.append("* [UNCONVERTED] " + t)
            continue
        if not entry.get("verified", False):
            warn("mapping %s -> %s is UNVERIFIED; check against PDK "
                 "collateral" % (card.model, entry[target]))
        try:
            line = CONVERTERS[entry["kind"]](card, entry, target, keep_geom)
        except ValueError as e:
            errors.append(str(e))
            out.append("* [UNCONVERTED] " + t)
            continue
        stats[entry[target]] = stats.get(entry[target], 0) + 1
        out.extend(wrap(line))

    return out, stats, errors, source


def main():
    ap = argparse.ArgumentParser(
        description="Convert sky130 netlists between PDK dialects "
                    "(open / s130 / cadence).")
    ap.add_argument("input")
    ap.add_argument("-o", "--output", help="output file (default stdout)")
    ap.add_argument("--to", required=True, choices=DIALECTS,
                    dest="target")
    ap.add_argument("--from", default="auto", dest="source",
                    choices=("auto",) + DIALECTS)
    ap.add_argument("--format", default="bare",
                    choices=("bare", "lvs", "sim"),
                    help="header/include style of the output (default bare)")
    ap.add_argument("--keep-geom", action="store_true",
                    help="keep ad/as/pd/ps... geometry params on FETs")
    args = ap.parse_args()

    with open(args.input) as f:
        text = f.read()

    out, stats, errors, source = convert(text, args.source, args.target,
                                         args.format, args.keep_geom)

    result = "\n".join(out) + "\n"
    if args.output:
        with open(args.output, "w") as f:
            f.write(result)
    else:
        sys.stdout.write(result)

    sys.stderr.write("INFO: %s -> %s: converted %d device(s): %s\n"
                     % (source, args.target, sum(stats.values()),
                        ", ".join("%s x%d" % kv for kv in
                                  sorted(stats.items())) or "none"))
    if errors:
        for e in errors:
            sys.stderr.write("ERROR: %s\n" % e)
        sys.exit(1)


if __name__ == "__main__":
    main()
