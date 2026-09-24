"""Derive immutable NGSPICE reset sources while preserving physical photodiodes."""

from __future__ import annotations

import argparse
import hashlib
import re
from pathlib import Path


APPARATUS_VERSION = "exact-cace-reset-physical-photodiode-v2"
_DIODE_MODEL = "sky130_fd_pr__model__parasitic__diode_ps2dn"
_MAGIC_CORE = "openDVS_pixel2x2__diffbn_physical_core"
_PHYSICAL_BINDING = {"area=32.49", "pj=22.8", "m=1"}


def sha256_bytes(payload: bytes) -> str:
    return hashlib.sha256(payload).hexdigest()


def _header(path: str, source_sha256: str) -> list[str]:
    return [
        f"* RESET_APPARATUS {APPARATUS_VERSION}",
        f"* RESET_BASE_PATH {path}",
        f"* RESET_BASE_SHA256 {source_sha256}",
        "* Physical photodiodes retained; no artificial photodiode or vd DC paths",
    ]


def _reject_preexisting_apparatus(lines: list[str]) -> None:
    lowered = "\n".join(lines).lower()
    if any(
        marker in lowered
        for marker in ("reset_apparatus", "r_cace_pd_", "r_cace_vdstab")
    ):
        raise ValueError("source contains pre-existing CACE reset apparatus")


def _subckt_range(lines: list[str], name: str) -> tuple[int, int]:
    starts = [
        index
        for index, line in enumerate(lines)
        if len(line.split()) >= 2
        and line.split()[0].lower() == ".subckt"
        and line.split()[1].lower() == name.lower()
    ]
    if len(starts) != 1:
        raise ValueError(f"source must contain exactly one {name} subcircuit; found {len(starts)}")
    start = starts[0]
    for index in range(start + 1, len(lines)):
        fields = lines[index].split()
        if fields and fields[0].lower() == ".subckt":
            raise ValueError(f"{name} subcircuit is missing .ends before the next subcircuit")
        if fields and fields[0].lower() == ".ends":
            if len(fields) > 1 and fields[1].lower() != name.lower():
                raise ValueError(f"{name} subcircuit closes with mismatched .ends {fields[1]}")
            return start, index
    raise ValueError(f"{name} subcircuit has no .ends")


def _logical_cards(lines: list[str], start: int, end: int) -> list[list[str]]:
    cards: list[list[str]] = []
    current: list[str] | None = None
    for line in lines[start + 1 : end]:
        stripped = line.strip()
        if not stripped or stripped.startswith("*"):
            continue
        if stripped.startswith("+"):
            if current is None:
                # The subcircuit port list itself may continue onto the first
                # body line; it is not an instance card.
                continue
            current.extend(stripped[1:].split())
            continue
        current = stripped.split()
        cards.append(current)
    return cards


def _model_diodes(lines: list[str]) -> list[int]:
    return [
        index
        for index, line in enumerate(lines)
        if len(line.split()) >= 4
        and re.fullmatch(r"D\d+", line.split()[0], re.IGNORECASE)
        and line.split()[3].lower() == _DIODE_MODEL
    ]


def _require_physical_binding(line: str, label: str) -> None:
    fields = line.split()
    actual = {field.lower() for field in fields[4:]}
    if not _PHYSICAL_BINDING <= actual:
        raise ValueError(f"{label} must retain area=32.49 pj=22.8 m=1")


def derive_magic(text: str, source_sha256: str) -> str:
    lines = text.splitlines()
    _reject_preexisting_apparatus(lines)
    start, end_index = _subckt_range(lines, _MAGIC_CORE)
    diode_indices = _model_diodes(lines)
    scoped = [index for index in diode_indices if start < index < end_index]
    outside = [index for index in diode_indices if index not in scoped]
    if outside:
        raise ValueError("Magic photodiode model occurs outside the physical-core subcircuit")
    names = [lines[index].split()[0].upper() for index in scoped]
    if sorted(names) != ["D0", "D1", "D2", "D3"]:
        raise ValueError(f"Magic physical core must contain exactly D0..D3 photodiodes; found {names}")
    for index in scoped:
        _require_physical_binding(lines[index], lines[index].split()[0])
    return "\n".join([*_header("magic_rcc_ngspice", source_sha256), *lines]) + "\n"


def derive_schematic(text: str, source_sha256: str) -> str:
    lines = text.splitlines()
    _reject_preexisting_apparatus(lines)
    top_start, top_end = _subckt_range(lines, "openDVS_pixel2x2")
    pixel_start, pixel_end = _subckt_range(lines, "openDVS_pixel")
    photo_start, photo_end = _subckt_range(lines, "PixelPhotoreceptor")

    pixel_instances = [
        fields
        for fields in _logical_cards(lines, top_start, top_end)
        if fields[0].lower().startswith("x") and fields[-1].lower() == "opendvs_pixel"
    ]
    if sorted(fields[0].lower() for fields in pixel_instances) != [
        "xpix[0]",
        "xpix[1]",
        "xpix[2]",
        "xpix[3]",
    ]:
        raise ValueError("schematic top must contain exactly four openDVS_pixel instances xpix[0..3]")
    pixel_cards = _logical_cards(lines, pixel_start, pixel_end)
    if sum(fields[-1].lower() == "pixelphotoreceptor" for fields in pixel_cards) != 1:
        raise ValueError("openDVS_pixel must instantiate PixelPhotoreceptor exactly once")
    if sum(fields[-1].lower() == "pixelchangeamplifier" for fields in pixel_cards) != 1:
        raise ValueError("openDVS_pixel must instantiate PixelChangeAmplifier exactly once")

    diode_indices = _model_diodes(lines)
    scoped = [index for index in diode_indices if photo_start < index < photo_end]
    outside = [index for index in diode_indices if index not in scoped]
    if outside:
        raise ValueError("schematic photodiode model occurs outside PixelPhotoreceptor")
    if len(scoped) != 1 or lines[scoped[0]].split()[0].lower() != "d1":
        raise ValueError("PixelPhotoreceptor must contain exactly one D1 photodiode")
    _require_physical_binding(lines[scoped[0]], "D1")
    return "\n".join([*_header("schematic_ngspice", source_sha256), *lines]) + "\n"


def derive(path: str, payload: bytes, expected_input_sha256: str) -> bytes:
    actual = sha256_bytes(payload)
    if actual != expected_input_sha256:
        raise ValueError(f"input hash mismatch: {actual} != {expected_input_sha256}")
    text = payload.decode("utf-8")
    if path == "magic_rcc_ngspice":
        transformed = derive_magic(text, actual)
    elif path == "schematic_ngspice":
        transformed = derive_schematic(text, actual)
    else:
        raise ValueError(f"unsupported reset derivation path: {path}")
    return transformed.encode("utf-8")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--path", choices=("magic_rcc_ngspice", "schematic_ngspice"), required=True)
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--expected-input-sha256", required=True)
    args = parser.parse_args()
    if args.output.exists():
        raise ValueError(f"refusing to overwrite existing output: {args.output}")
    output = derive(args.path, args.input.read_bytes(), args.expected_input_sha256)
    args.output.write_bytes(output)
    print(sha256_bytes(output))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
