#!/usr/bin/env python3
"""Summarize a KLayout #%lvsdb-klayout text database into a readable report."""

from __future__ import annotations

import re
import sys
from collections import Counter


def main() -> int:
    if len(sys.argv) != 3:
        print(f"usage: {sys.argv[0]} <input.lvsdb> <output.txt>", file=sys.stderr)
        return 2

    src, dst = sys.argv[1], sys.argv[2]
    with open(src, encoding="utf-8", errors="replace") as f:
        text = f.read()

    lines: list[str] = []
    lines.append(f"KLayout LVS report summary")
    lines.append(f"Source: {src}")
    lines.append("")

    # Top-level status messages
    status = re.findall(r"X\([^)]* S B\('([^']*(?:\\n[^']*)*)'\)", text, re.DOTALL)
    lines.append("=== Circuit comparison status ===")
    if status:
        for msg in status:
            lines.append(msg.replace("\\n", "\n"))
    else:
        lines.append("(no explicit circuit status messages found)")
    lines.append("")

    # Net mismatch markers
    net_errs = re.findall(r"M\(E B\('Net ([^']+) is not matching[^']*'\)", text)
    lines.append(f"=== Unmatched layout nets ({len(net_errs)}) ===")
    for n in net_errs[:100]:
        lines.append(f"  {n}")
    if len(net_errs) > 100:
        lines.append(f"  ... ({len(net_errs) - 100} more)")
    lines.append("")

    # Device mismatch markers (if present)
    dev_errs = re.findall(r"M\(E B\('Device ([^']+)", text)
    if dev_errs:
        lines.append(f"=== Device errors ({len(dev_errs)}) ===")
        for d in dev_errs[:50]:
            lines.append(f"  {d}")
        if len(dev_errs) > 50:
            lines.append(f"  ... ({len(dev_errs) - 50} more)")
        lines.append("")

    # Generic error messages
    generic = re.findall(r"M\(E B\('([^']+)'\)", text)
    other = [g for g in generic if not g.startswith("Net ")]
    if other:
        c = Counter(other)
        lines.append(f"=== Other markers ({len(other)}) ===")
        for msg, cnt in c.most_common(50):
            lines.append(f"  [{cnt}x] {msg}")
        lines.append("")

    lines.append("=== Result ===")
    if "could not be compared" in text or net_errs or other:
        lines.append("FAIL — netlists do not match (see details above)")
    else:
        lines.append("PASS — no mismatch markers found")

    out = "\n".join(lines) + "\n"
    with open(dst, "w", encoding="utf-8") as f:
        f.write(out)
    print(f"Wrote {dst}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
