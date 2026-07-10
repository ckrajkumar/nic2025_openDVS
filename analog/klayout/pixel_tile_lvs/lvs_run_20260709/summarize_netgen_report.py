#!/usr/bin/env python3
"""Extract a short summary from a large netgen LVS report."""

from __future__ import annotations

import re
import sys


def main() -> int:
    if len(sys.argv) != 3:
        print(f"usage: {sys.argv[0]} <report> <out>", file=sys.stderr)
        return 2

    src, dst = sys.argv[1], sys.argv[2]
    with open(src, encoding="utf-8", errors="replace") as f:
        text = f.read()

    lines: list[str] = []
    lines.append("Netgen LVS report summary")
    lines.append(f"Source: {src}")
    lines.append("")

    for pat, label in [
        (r"Circuit 1 contains (\d+) devices, Circuit 2 contains (\d+) devices\.",
         "Device counts (top-level summary lines)"),
        (r"Circuit 1 contains (\d+) nets,\s+Circuit 2 contains (\d+) nets\. \*\*\* MISMATCH \*\*\*",
         "Net count mismatches"),
        (r"Final result: (.+)", "Final result"),
    ]:
        hits = re.findall(pat, text)
        if hits:
            lines.append(f"=== {label} ===")
            for h in hits[:10]:
                lines.append("  " + (h if isinstance(h, str) else " / ".join(h)))
            if len(hits) > 10:
                lines.append(f"  ... ({len(hits) - 10} more)")
            lines.append("")

    # Top-level pin section for pixel_4tile if present
    m = re.search(
        r"Contents of circuit 1:\s+Circuit: 'pixel_4tile'.*?Final result:",
        text,
        re.DOTALL,
    )
    if m:
        chunk = m.group(0)
        lines.append("=== pixel_4tile compare excerpt ===")
        for line in chunk.splitlines()[:40]:
            if line.strip():
                lines.append(line)
        lines.append("  ...")
        lines.append("")

    # Pin mismatch lines mentioning supply nets
    supply = []
    for net in ("vssc1", "vssa1", "vdda1", "GndD", "GND"):
        supply += re.findall(rf".*{net}.*", text, re.IGNORECASE)
    if supply:
        lines.append(f"=== Ground/supply-related pin-net lines ({min(len(supply), 100)} shown) ===")
        for s in supply[:100]:
            lines.append(s.strip())
        if len(supply) > 100:
            lines.append(f"  ... ({len(supply) - 100} more)")
        lines.append("")

    final = re.findall(r"Final result: (.+)", text)
    lines.append("=== Result ===")
    if final:
        lines.append(final[-1])
    else:
        lines.append("UNKNOWN")

    out = "\n".join(lines) + "\n"
    with open(dst, "w", encoding="utf-8") as f:
        f.write(out)
    print(f"Wrote {dst}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
