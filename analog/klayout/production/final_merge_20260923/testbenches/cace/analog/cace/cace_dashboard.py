#!/usr/bin/env python3
"""CACE Characterization Dashboard — Panel server."""

import os
import json
import shutil
import subprocess
import re
from pathlib import Path
from datetime import datetime

import numpy as np
import pandas as pd
import panel as pn
import yaml
import holoviews as hv
from bokeh.models import HoverTool
from scipy import stats

hv.extension('bokeh')

# ── Paths ──────────────────────────────────────────────────────────
ANALOG_ROOT = Path(__file__).resolve().parent.parent
CACE_DIR = ANALOG_ROOT / 'cace'
RUNS_DIR = ANALOG_ROOT / 'runs'
XSCHEM_DIR = ANALOG_ROOT / 'xschem'
CAD_SETUP = ANALOG_ROOT.parent / 'cad_setup'
REFS_FILE = CACE_DIR / 'reference_runs.json'

# ── Theme (Catppuccin Macchiato) ───────────────────────────────────
_BG = '#1e2030'
_BORDER = '#24273a'
_SURFACE = '#363a4f'
_OVERLAY = '#494d64'
_AXIS = '#6e738d'
_TICK = '#8087a2'
_TEXT = '#cad3f5'
_SUBTEXT = '#a5adcb'
_GREEN = '#a6da95'
_RED = '#ed8796'
_YELLOW = '#eed49f'
_ACCENT = '#8aadf4'
_PEACH = '#f5a97f'
_MAUVE = '#c6a0f6'
_TEAL = '#8bd5ca'
_PINK = '#f5bde6'
_FLAMINGO = '#f0c6c6'

# Base columns always treated as parameters (not measurements)
_BASE_PARAM_COLS = {'run', 'corner', 'temperature', 'temp'}

CORNER_COLORS = {
    'tt': _ACCENT,
    'ss': _RED,
    'ff': _GREEN,
    'sf': _PEACH,
    'fs': _MAUVE,
}

_DARK_CSS = f'''
body, .bk-root, .pn-container {{
    background-color: {_BG} !important;
    color: {_TEXT} !important;
    font-family: 'JetBrains Mono', 'Fira Code', monospace;
    font-size: 15px;
}}
h1, h2, h3, h4, p, span, td, th, label, div {{
    color: {_TEXT} !important;
}}
.bk-btn {{
    background-color: {_SURFACE} !important;
    color: {_TEXT} !important;
    border: 1px solid {_OVERLAY} !important;
    border-radius: 6px !important;
    font-size: 14px !important;
    padding: 6px 14px !important;
}}
.bk-btn-primary {{
    background-color: {_ACCENT} !important;
    color: {_BG} !important;
}}
.bk-btn-danger {{
    background-color: {_RED} !important;
    color: {_BG} !important;
}}
.bk-btn-success {{
    background-color: {_GREEN} !important;
    color: {_BG} !important;
}}
.bk-btn-warning {{
    background-color: {_YELLOW} !important;
    color: {_BG} !important;
}}
.bk-input, select.bk-input {{
    background-color: {_SURFACE} !important;
    color: {_TEXT} !important;
    border: 1px solid {_OVERLAY} !important;
    font-size: 14px !important;
}}
.bk-tab {{
    background-color: {_SURFACE} !important;
    color: {_SUBTEXT} !important;
    border: 1px solid {_OVERLAY} !important;
    font-size: 14px !important;
    padding: 8px 16px !important;
}}
.bk-tab.bk-active {{
    background-color: {_ACCENT} !important;
    color: {_BG} !important;
}}
.bk-header {{
    background-color: {_BG} !important;
}}
.bk-input-group label {{
    color: {_TEXT} !important;
    font-size: 14px !important;
}}
.bk label {{
    color: {_TEXT} !important;
    font-size: 14px !important;
}}
'''

pn.extension(raw_css=[_DARK_CSS])


# ── Bokeh plot styling ─────────────────────────────────────────────
def _style_hv(plot, element):
    p = plot.state
    p.background_fill_color = _BORDER
    p.border_fill_color = _BG
    p.outline_line_color = _OVERLAY
    p.title.text_color = _TEXT
    p.title.text_font_size = '14pt'
    for ax in (p.xaxis, p.yaxis):
        ax.axis_label_text_color = _SUBTEXT
        ax.axis_label_text_font_size = '13pt'
        ax.major_label_text_color = _TICK
        ax.major_label_text_font_size = '12pt'
        ax.major_tick_line_color = _OVERLAY
        ax.minor_tick_line_color = _OVERLAY
        ax.axis_line_color = _OVERLAY
    p.xgrid.grid_line_color = _SURFACE
    p.ygrid.grid_line_color = _SURFACE
    if p.legend:
        for legend in p.legend:
            legend.background_fill_color = _SURFACE
            legend.border_line_color = _OVERLAY
            legend.label_text_color = _TEXT
            legend.label_text_font_size = '12pt'


# ── Reference run management ──────────────────────────────────────
def load_refs():
    if REFS_FILE.exists():
        return json.loads(REFS_FILE.read_text())
    return {}


def save_refs(refs):
    REFS_FILE.write_text(json.dumps(refs, indent=2))


# ── CACE YAML parsing ─────────────────────────────────────────────
def discover_blocks():
    blocks = {}
    for yf in sorted(CACE_DIR.glob('*.yaml')):
        if yf.name.startswith('#'):
            continue
        try:
            cfg = yaml.safe_load(yf.read_text())
        except Exception:
            continue
        if not cfg or 'name' not in cfg:
            continue

        name = cfg['name']
        # Use YAML filename stem as block key to avoid collisions
        # (multiple YAMLs can share the same 'name' for CACE schematic lookup)
        block_key = yf.stem
        params = {}
        for pname, pdata in (cfg.get('parameters') or {}).items():
            specs = {}
            for sname, sdata in (pdata.get('spec') or {}).items():
                spec_info = {
                    'display': sdata.get('display', sname),
                    'unit': sdata.get('unit', ''),
                }
                for bound in ('minimum', 'maximum'):
                    bdata = sdata.get(bound, {})
                    if isinstance(bdata, dict) and bdata.get('value') != 'any':
                        spec_info[bound] = bdata.get('value')
                        spec_info[f'{bound}_fail'] = bdata.get('fail', False)
                specs[sname] = spec_info
            conditions = pdata.get('conditions', {})
            tool_cfg = pdata.get('tool', {}).get('ngspice', {})
            params[pname] = {
                'display': pdata.get('display', pname),
                'specs': specs,
                'conditions': conditions,
                'template': tool_cfg.get('template', ''),
                'variables': tool_cfg.get('variables', []),
                'collate': tool_cfg.get('collate', ''),
            }

        blocks[block_key] = {
            'yaml_path': str(yf),
            'dut_name': name,
            'description': cfg.get('description', ''),
            'pdk': cfg.get('PDK', ''),
            'designer': (cfg.get('authorship') or {}).get('designer', ''),
            'parameters': params,
            'schematic': str(XSCHEM_DIR / f'{name}.sch'),
        }
    return blocks


# ── Run discovery ──────────────────────────────────────────────────
def discover_runs():
    """Discover runs with lightweight metadata only (no DataFrame loading)."""
    runs = {}
    if not RUNS_DIR.exists():
        return runs

    # Collect RUN_ dirs from both flat (runs/RUN_*) and nested (runs/block/RUN_*)
    run_dirs = []
    for entry in RUNS_DIR.iterdir():
        if not entry.is_dir():
            continue
        if entry.name.startswith('RUN_'):
            run_dirs.append((None, entry))
        else:
            # Block subdirectory — scan for RUN_ inside
            for sub in entry.iterdir():
                if sub.is_dir() and sub.name.startswith('RUN_'):
                    run_dirs.append((entry.name, sub))
    run_dirs.sort(key=lambda x: x[1].name, reverse=True)

    for block_subdir, run_dir in run_dirs:

        tag = run_dir.name
        m = re.match(r'RUN_(\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2})', tag)
        timestamp = m.group(1).replace('_', ' ') if m else tag

        # Read root summary once
        root_summary = run_dir / 'summary.md'
        root_text = ''
        if root_summary.exists():
            root_text = root_summary.read_text()
        cace_summary = _parse_cace_summary_text(root_text) if root_text else []

        # Detect status from root summary text (already read)
        status = 'unknown'
        if 'Error' in root_text and 'Pass' not in root_text and 'Fail' not in root_text:
            status = 'error'
        elif 'Fail' in root_text:
            status = 'fail'
        elif 'Pass' in root_text:
            status = 'pass'

        params_dir = run_dir / 'parameters'
        if not params_dir.is_dir():
            continue

        for param_dir in params_dir.iterdir():
            if not param_dir.is_dir():
                continue
            param_name = param_dir.name

            is_mc = False

            # Detect MC: nested run_0/run_N structure
            collate_dir = param_dir / 'run_0'
            if (collate_dir.is_dir()
                    and any(d.is_dir() and d.name.startswith('run_')
                            for d in collate_dir.iterdir())):
                is_mc = True

            # Count sub-runs without sorting (just count)
            num_sims = sum(1 for d in param_dir.iterdir()
                          if d.is_dir() and d.name.startswith('run_'))

            # Read summary text (small file)
            summary_md = param_dir / 'simulation_summary.md'
            summary_text = ''
            if summary_md.exists():
                summary_text = summary_md.read_text()

            # Detect block from subdirectory name or conditions.yaml
            block_name = block_subdir or _detect_block_fast(param_dir)

            key = f'{tag}/{param_name}'
            runs[key] = {
                'tag': tag,
                'param_name': param_name,
                'block_name': block_name,
                'timestamp': timestamp,
                'path': str(run_dir),
                'param_path': str(param_dir),
                'num_sims': num_sims,
                'status': status,
                'df': None,  # loaded on demand
                'is_mc': is_mc,
                'summary_text': summary_text,
                'cace_summary': cace_summary,
                '_data_loaded': False,
            }
    return runs


def _load_run_data(rdata):
    """Load the DataFrame for a single run entry on demand."""
    if rdata.get('_data_loaded'):
        return rdata['df']

    param_dir = Path(rdata['param_path'])
    is_mc = rdata.get('is_mc', False)

    if is_mc:
        rdata['df'] = None  # MC loads via _build_mc_df with variables
    else:
        summary_csv = param_dir / 'simulation_summary.csv'
        if summary_csv.exists():
            try:
                raw_df = pd.read_csv(summary_csv)
                # Coerce ERROR entries from failed simulation runs to NaN
                for col in raw_df.columns:
                    if raw_df[col].dtype == object and col not in _BASE_PARAM_COLS:
                        raw_df[col] = pd.to_numeric(raw_df[col], errors='coerce')
                # Mark rows where all measurement columns are NaN as error rows
                meas_cols = [c for c in raw_df.columns if c not in _BASE_PARAM_COLS
                             and not c.startswith('x') and c != 'run' and c != 'vdd']
                if meas_cols:
                    raw_df['_is_error'] = raw_df[meas_cols].isna().all(axis=1)
                rdata['df'] = raw_df
            except Exception:
                pass
        else:
            rdata['df'] = _build_df_from_data(param_dir)

    rdata['_data_loaded'] = True
    return rdata['df']


def _parse_cace_summary(summary_path):
    """Parse the CACE summary.md table into per-spec pass/fail info.

    Returns a list of dicts (not a dict) to support duplicate result names
    from multiple parameter blocks in the same run.
    """
    specs = []
    try:
        text = summary_path.read_text()
        for line in text.splitlines():
            if '|' not in line or line.strip().startswith('|:') or line.strip().startswith('| :'):
                continue
            parts = [p.strip() for p in line.split('|')]
            parts = [p for p in parts if p]
            _STATUS_MAP = {'Pass ✅': 'pass', 'Fail ❌': 'fail', 'Error ❗': 'error'}
            if len(parts) >= 10 and parts[-1] in _STATUS_MAP:
                param_name = parts[0].strip()
                result_name = parts[2].strip()
                status = _STATUS_MAP[parts[-1]]
                min_limit = parts[3].strip() if len(parts) > 3 else ''
                min_val = parts[4].strip() if len(parts) > 4 else ''
                typ_val = parts[6].strip() if len(parts) > 6 else ''
                max_limit = parts[7].strip() if len(parts) > 7 else ''
                max_val = parts[8].strip() if len(parts) > 8 else ''
                specs.append({
                    'result_name': result_name,
                    'display': param_name,
                    'status': status,
                    'min_limit': min_limit,
                    'min_value': min_val,
                    'typ_value': typ_val,
                    'max_limit': max_limit,
                    'max_value': max_val,
                })
    except Exception:
        pass
    return specs


def _parse_cace_summary_text(text):
    """Parse CACE summary from already-read text (avoids re-reading file)."""
    specs = []
    try:
        for line in text.splitlines():
            if '|' not in line or line.strip().startswith('|:') or line.strip().startswith('| :'):
                continue
            parts = [p.strip() for p in line.split('|')]
            parts = [p for p in parts if p]
            _STATUS_MAP = {'Pass ✅': 'pass', 'Fail ❌': 'fail', 'Error ❗': 'error'}
            if len(parts) >= 10 and parts[-1] in _STATUS_MAP:
                param_name = parts[0].strip()
                result_name = parts[2].strip()
                status = _STATUS_MAP[parts[-1]]
                min_limit = parts[3].strip() if len(parts) > 3 else ''
                min_val = parts[4].strip() if len(parts) > 4 else ''
                typ_val = parts[6].strip() if len(parts) > 6 else ''
                max_limit = parts[7].strip() if len(parts) > 7 else ''
                max_val = parts[8].strip() if len(parts) > 8 else ''
                specs.append({
                    'result_name': result_name,
                    'display': param_name,
                    'status': status,
                    'min_limit': min_limit,
                    'min_value': min_val,
                    'typ_value': typ_val,
                    'max_limit': max_limit,
                    'max_value': max_val,
                })
    except Exception:
        pass
    return specs


def _detect_block_fast(param_dir):
    """Detect block name from first sub-run's conditions.yaml without listing all sub-runs."""
    run_0 = param_dir / 'run_0'
    if run_0.is_dir():
        cond_file = run_0 / 'conditions.yaml'
        if cond_file.exists():
            try:
                cond = yaml.safe_load(cond_file.read_text())
                dut_path = cond.get('DUT_path', '')
                if dut_path:
                    return Path(dut_path).stem
            except Exception:
                pass
    return 'unknown'


def _build_df_from_data(param_dir):
    rows = []
    sub_runs = sorted([d for d in param_dir.iterdir()
                       if d.is_dir() and d.name.startswith('run_')],
                      key=lambda x: int(x.name.split('_')[1]))
    for rd in sub_runs:
        cond_file = rd / 'conditions.yaml'
        data_files = list(rd.glob('*.data'))
        if not data_files:
            continue
        row = {'run': rd.name}
        if cond_file.exists():
            try:
                cond = yaml.safe_load(cond_file.read_text())
                for k, v in cond.items():
                    if k not in ('DUT_path', 'filename', 'N', 'simpath', 'root',
                                 'seed', 'iterations'):
                        row[k] = v
            except Exception:
                pass
        try:
            vals = data_files[0].read_text().strip().split()
            for i, v in enumerate(vals):
                row[f'var_{i}'] = float(v)
        except Exception:
            pass
        if len(row) > 1:
            rows.append(row)
    if rows:
        return pd.DataFrame(rows)
    return None


def _is_mc_param(param_name, blocks):
    """Check if a parameter is a Monte Carlo parameter (has collate)."""
    for bname, binfo in blocks.items():
        for pn_, pdata in binfo['parameters'].items():
            if pn_ == param_name and pdata.get('collate'):
                return True
    return False


def _build_mc_df(param_dir, variables):
    """Build a DataFrame from MC nested run_0/run_N/ directories."""
    rows = []
    # MC structure: param_dir/run_0/run_N/*.data
    collate_dir = param_dir / 'run_0'
    if not collate_dir.is_dir():
        return None

    iter_dirs = sorted(
        [d for d in collate_dir.iterdir()
         if d.is_dir() and d.name.startswith('run_')],
        key=lambda x: int(x.name.split('_')[1]))

    for rd in iter_dirs:
        data_files = list(rd.glob('*.data'))
        if not data_files:
            continue
        row = {'iteration': int(rd.name.split('_')[1])}
        try:
            vals = data_files[0].read_text().strip().split()
            if len(vals) == len(variables):
                for i, v in enumerate(variables):
                    row[v] = float(vals[i])
            else:
                for i, val in enumerate(vals):
                    row[f'var_{i}'] = float(val)
        except (ValueError, Exception):
            continue
        if len(row) > 1:
            rows.append(row)

    if rows:
        return pd.DataFrame(rows)
    return None


def _vline_seg(x, y_max, color, dash='dashed', width=1.2, alpha=0.8, label=''):
    """Draw a vertical line as a bounded Curve segment (avoids VLine axis stretch)."""
    return hv.Curve(
        [(x, 0), (x, y_max)], label=label
    ).opts(color=color, line_dash=dash, line_width=width, alpha=alpha)


def _mc_histogram_hv(values, name, unit, spec=None):
    """Generate a histogram with σ markers as a HoloViews overlay."""
    from bokeh.models import Range1d

    mu = np.mean(values)
    sigma = np.std(values)

    factor = _UNIT_SI_FACTOR.get(unit, 1)
    dv = values / factor if factor and factor != 1 else values
    d_mu = mu / factor if factor and factor != 1 else mu
    d_sigma = sigma / factor if factor and factor != 1 else sigma

    unit_str = f' [{unit}]' if unit else ''

    n_bins = min(50, max(15, len(dv) // 10))
    freqs, edges = np.histogram(dv, bins=n_bins, density=True)
    y_max = float(freqs.max()) * 1.15

    hist = hv.Histogram((edges, freqs)).opts(
        color=_ACCENT, alpha=0.8, line_color=_SURFACE)

    plots = [hist]

    # Normal PDF overlay
    if d_sigma > 0:
        x_pdf = np.linspace(dv.min() - d_sigma, dv.max() + d_sigma, 200)
        pdf = stats.norm.pdf(x_pdf, d_mu, d_sigma)
        y_max = max(y_max, float(pdf.max()) * 1.1)
        plots.append(hv.Curve(
            (x_pdf, pdf), label='Normal PDF'
        ).opts(color=_TEXT, line_width=1.5, alpha=0.7))

    # σ markers — draw as bounded vertical segments
    sigma_colors = [_GREEN, _YELLOW, _RED, _MAUVE]
    sigma_labels = ['1σ', '2σ', '3σ', '4σ']
    for i, (c, lbl) in enumerate(zip(sigma_colors, sigma_labels)):
        n = i + 1
        lo = d_mu - n * d_sigma
        hi = d_mu + n * d_sigma
        plots.append(_vline_seg(lo, y_max, c))
        plots.append(_vline_seg(hi, y_max, c,
                                label=f'±{lbl} ({lo:.4g}, {hi:.4g})'))

    # Mean line
    plots.append(_vline_seg(d_mu, y_max, _PEACH, dash='solid', width=2,
                            label=f'μ = {d_mu:.4g}'))

    # Spec limits — only show if within 5σ of the data
    if spec and d_sigma > 0:
        for bound, lbl_prefix in [('minimum', 'Spec min'), ('maximum', 'Spec max')]:
            if bound in spec:
                spec_val = float(spec[bound])
                if abs(spec_val - d_mu) < 5 * d_sigma:
                    plots.append(_vline_seg(spec_val, y_max, _FLAMINGO,
                                           dash='dotted', width=2.5,
                                           label=f'{lbl_prefix} = {spec_val}'))

    # Explicit axis range via hook
    x_pad = max(5 * d_sigma, (dv.max() - dv.min()) * 0.2) if d_sigma > 0 else 1
    x_lo, x_hi = float(dv.min() - x_pad), float(dv.max() + x_pad)

    def _fix_range(plot, element):
        _style_hv(plot, element)
        p = plot.state
        p.x_range = Range1d(x_lo, x_hi)
        p.y_range = Range1d(0, y_max)

    overlay = hv.Overlay(plots).opts(
        hv.opts.Overlay(
            width=550, height=380,
            xlabel=f'{name}{unit_str}',
            ylabel='Density',
            title=f'{name} — N={len(values)}, μ={d_mu:.4g}, σ={d_sigma:.4g}{unit_str}',
            legend_position='right',
            hooks=[_fix_range],
            show_grid=True,
        )
    )
    return overlay


def _mc_qq_hv(values, name, unit):
    """Generate a QQ plot as a HoloViews overlay."""
    factor = _UNIT_SI_FACTOR.get(unit, 1)
    dv = values / factor if factor and factor != 1 else values

    unit_str = f' [{unit}]' if unit else ''

    from bokeh.models import Range1d

    (osm, osr), (slope, intercept, r) = stats.probplot(dv, dist='norm')

    scatter = hv.Scatter(
        (osm, osr), kdims='Theoretical Quantiles (σ)',
        vdims=f'Sample{unit_str}'
    ).opts(color=_ACCENT, size=4, alpha=0.6)

    # Clip reference line to data range to prevent y-axis stretch
    x_line = np.array([osm.min(), osm.max()])
    ref_line = hv.Curve(
        (x_line, slope * x_line + intercept),
        kdims='Theoretical Quantiles (σ)',
        vdims=f'Sample{unit_str}',
        label=f'R² = {r**2:.4f}',
    ).opts(color=_RED, line_width=1.5)

    # Force y-range to data bounds
    y_pad = (osr.max() - osr.min()) * 0.08
    y_lo, y_hi = float(osr.min() - y_pad), float(osr.max() + y_pad)

    def _fix_qq_range(plot, element):
        _style_hv(plot, element)
        p = plot.state
        p.y_range = Range1d(y_lo, y_hi)

    overlay = (scatter * ref_line).opts(
        hv.opts.Overlay(
            width=400, height=380,
            title=f'Q-Q Plot: {name}',
            legend_position='top_left',
            hooks=[_fix_qq_range],
            show_grid=True,
        )
    )
    return overlay


def _mc_summary_table_html(mc_df, variables, specs):
    """Build μ±3σ summary table for MC results."""
    header = (f'<th style="padding:6px 10px; color:{_ACCENT}; '
              f'border-bottom:2px solid {_OVERLAY}; text-align:left;">Parameter</th>'
              f'<th style="padding:6px 10px; color:{_ACCENT}; '
              f'border-bottom:2px solid {_OVERLAY}; text-align:right;">Unit</th>'
              f'<th style="padding:6px 10px; color:{_ACCENT}; '
              f'border-bottom:2px solid {_OVERLAY}; text-align:right;">Mean</th>'
              f'<th style="padding:6px 10px; color:{_ACCENT}; '
              f'border-bottom:2px solid {_OVERLAY}; text-align:right;">σ</th>'
              f'<th style="padding:6px 10px; color:{_ACCENT}; '
              f'border-bottom:2px solid {_OVERLAY}; text-align:right;">Min</th>'
              f'<th style="padding:6px 10px; color:{_ACCENT}; '
              f'border-bottom:2px solid {_OVERLAY}; text-align:right;">Max</th>'
              f'<th style="padding:6px 10px; color:{_ACCENT}; '
              f'border-bottom:2px solid {_OVERLAY}; text-align:right;">μ-3σ</th>'
              f'<th style="padding:6px 10px; color:{_ACCENT}; '
              f'border-bottom:2px solid {_OVERLAY}; text-align:right;">μ+3σ</th>'
              f'<th style="padding:6px 10px; color:{_ACCENT}; '
              f'border-bottom:2px solid {_OVERLAY}; text-align:center;">Status</th>')

    rows = ''
    for var in variables:
        if var not in mc_df.columns:
            continue
        vals = mc_df[var].dropna().values
        if len(vals) == 0:
            continue

        spec = specs.get(var, {})
        unit = spec.get('unit', '')
        display = spec.get('display', var)
        factor = _UNIT_SI_FACTOR.get(unit, 1)

        mu = np.mean(vals)
        sigma = np.std(vals)
        d_mu = mu / factor if factor and factor != 1 else mu
        d_sigma = sigma / factor if factor and factor != 1 else sigma
        d_min = np.min(vals) / factor if factor and factor != 1 else np.min(vals)
        d_max = np.max(vals) / factor if factor and factor != 1 else np.max(vals)
        d_m3s = d_mu - 3 * d_sigma
        d_p3s = d_mu + 3 * d_sigma

        # Check pass/fail: all samples must be within spec
        status_html = ''
        all_pass = True
        if 'minimum' in spec:
            spec_min_si = _spec_to_si(spec['minimum'], unit)
            if np.any(vals < spec_min_si):
                all_pass = False
        if 'maximum' in spec:
            spec_max_si = _spec_to_si(spec['maximum'], unit)
            if np.any(vals > spec_max_si):
                all_pass = False

        if 'minimum' in spec or 'maximum' in spec:
            if all_pass:
                status_html = f'<span style="color:{_GREEN}; font-weight:bold;">PASS</span>'
                row_border = _GREEN
            else:
                status_html = f'<span style="color:{_RED}; font-weight:bold;">FAIL</span>'
                row_border = _RED
        else:
            status_html = f'<span style="color:{_SUBTEXT};">—</span>'
            row_border = _OVERLAY

        rows += (f'<tr style="border-bottom:1px solid {_SURFACE}; '
                 f'border-left:3px solid {row_border};">'
                 f'<td style="padding:5px 10px; color:{_TEXT}; font-weight:bold;">{display}</td>'
                 f'<td style="padding:5px 10px; text-align:right; color:{_SUBTEXT};">{unit}</td>'
                 f'<td style="padding:5px 10px; text-align:right; color:{_TEXT};">{d_mu:.4g}</td>'
                 f'<td style="padding:5px 10px; text-align:right; color:{_TEXT};">{d_sigma:.4g}</td>'
                 f'<td style="padding:5px 10px; text-align:right; color:{_TEXT};">{d_min:.4g}</td>'
                 f'<td style="padding:5px 10px; text-align:right; color:{_TEXT};">{d_max:.4g}</td>'
                 f'<td style="padding:5px 10px; text-align:right; color:{_PEACH};">{d_m3s:.4g}</td>'
                 f'<td style="padding:5px 10px; text-align:right; color:{_PEACH};">{d_p3s:.4g}</td>'
                 f'<td style="padding:5px 10px; text-align:center;">{status_html}</td>'
                 f'</tr>\n')

    n_samples = len(mc_df)
    return f'''
    <div style="overflow-x:auto; border:1px solid {_OVERLAY}; border-radius:6px;">
    <table style="width:100%; border-collapse:collapse; font-size:14px;">
        <caption style="text-align:left; padding:8px 10px; color:{_MAUVE};
                        font-size:15px; font-weight:bold;">
            Monte Carlo Summary — N={n_samples}</caption>
        <tr>{header}</tr>
        {rows}
    </table>
    </div>'''


def _mc_plots_panel(mc_df, variables, specs):
    """Generate all MC histograms and QQ plots as Panel Column of HoloViews panes."""
    items = []
    for var in variables:
        if var not in mc_df.columns:
            continue
        vals = mc_df[var].dropna().values
        if len(vals) == 0:
            continue

        spec = specs.get(var, {})
        unit = spec.get('unit', '')
        display = spec.get('display', var)

        hist_plot = _mc_histogram_hv(vals, display, unit, spec)
        qq_plot = _mc_qq_hv(vals, display, unit)

        items.append(pn.pane.HTML(
            f'<h4 style="color:{_PEACH}; margin:12px 0 4px 0;">{display}</h4>'))
        items.append(pn.Row(
            pn.pane.HoloViews(hist_plot, sizing_mode='fixed'),
            pn.pane.HoloViews(qq_plot, sizing_mode='fixed'),
        ))
    return pn.Column(*items, sizing_mode='stretch_width')


def _mc_cace_summary_html(mc_df, variables, specs):
    """Generate CACE-style spec results for MC, showing μ±3σ ranges."""
    rows = ''
    for var in variables:
        if var not in mc_df.columns:
            continue
        vals = mc_df[var].dropna().values
        if len(vals) == 0:
            continue

        spec = specs.get(var, {})
        unit = spec.get('unit', '')
        display = spec.get('display', var)
        factor = _UNIT_SI_FACTOR.get(unit, 1)

        mu = np.mean(vals)
        sigma = np.std(vals)
        d_mu = mu / factor if factor and factor != 1 else mu
        d_sigma = sigma / factor if factor and factor != 1 else sigma
        d_min = np.min(vals) / factor if factor and factor != 1 else np.min(vals)
        d_max = np.max(vals) / factor if factor and factor != 1 else np.max(vals)

        # Format spec limits
        min_limit_str = f'{spec["minimum"]} {unit}'.strip() if 'minimum' in spec else '—'
        max_limit_str = f'{spec["maximum"]} {unit}'.strip() if 'maximum' in spec else '—'

        # Check pass
        all_pass = True
        if 'minimum' in spec:
            spec_min_si = _spec_to_si(spec['minimum'], unit)
            if np.any(vals < spec_min_si):
                all_pass = False
        if 'maximum' in spec:
            spec_max_si = _spec_to_si(spec['maximum'], unit)
            if np.any(vals > spec_max_si):
                all_pass = False

        has_spec = 'minimum' in spec or 'maximum' in spec
        if has_spec:
            if all_pass:
                status_html = f'<span style="color:{_GREEN}; font-weight:bold;">PASS</span>'
                row_border = _GREEN
            else:
                status_html = f'<span style="color:{_RED}; font-weight:bold;">FAIL</span>'
                row_border = _RED
        else:
            status_html = f'<span style="color:{_SUBTEXT};">—</span>'
            row_border = _OVERLAY

        rows += (f'<tr style="border-bottom:1px solid {_SURFACE}; '
                 f'border-left:3px solid {row_border};">'
                 f'<td style="padding:6px 12px; color:{_TEXT}; font-weight:bold;">{display}</td>'
                 f'<td style="padding:6px 12px; color:{_SUBTEXT}; font-size:13px;">{var}</td>'
                 f'<td style="padding:6px 12px; text-align:right; color:{_ACCENT}; font-weight:bold;">'
                 f'{min_limit_str}</td>'
                 f'<td style="padding:6px 12px; text-align:right; color:{_TEXT};">'
                 f'{d_min:.4g} {unit}</td>'
                 f'<td style="padding:6px 12px; text-align:right; color:{_TEXT};">'
                 f'{d_mu:.4g} ± {d_sigma:.4g} {unit}</td>'
                 f'<td style="padding:6px 12px; text-align:right; color:{_ACCENT}; font-weight:bold;">'
                 f'{max_limit_str}</td>'
                 f'<td style="padding:6px 12px; text-align:right; color:{_TEXT};">'
                 f'{d_max:.4g} {unit}</td>'
                 f'<td style="padding:6px 12px; text-align:center;">{status_html}</td>'
                 f'</tr>\n')

    n_samples = len(mc_df)
    return f'''
    <div style="margin:8px 0;">
    <div style="color:{_MAUVE}; font-size:14px; margin-bottom:6px;">
        Monte Carlo — N={n_samples} iterations (mismatch)</div>
    <table style="width:100%; border-collapse:collapse; font-size:14px;">
        <tr style="border-bottom:2px solid {_OVERLAY};">
            <th style="text-align:left; padding:6px 12px; color:{_ACCENT};">Parameter</th>
            <th style="text-align:left; padding:6px 12px; color:{_ACCENT};">Result</th>
            <th style="text-align:right; padding:6px 12px; color:{_ACCENT};">Min Limit</th>
            <th style="text-align:right; padding:6px 12px; color:{_ACCENT};">Min Value</th>
            <th style="text-align:right; padding:6px 12px; color:{_ACCENT};">μ ± σ</th>
            <th style="text-align:right; padding:6px 12px; color:{_ACCENT};">Max Limit</th>
            <th style="text-align:right; padding:6px 12px; color:{_ACCENT};">Max Value</th>
            <th style="text-align:center; padding:6px 12px; color:{_ACCENT};">Status</th>
        </tr>
        {rows}
    </table>
    </div>'''


def _detect_block(param_dir, sub_runs):
    if sub_runs:
        cond_file = sub_runs[0] / 'conditions.yaml'
        if cond_file.exists():
            try:
                cond = yaml.safe_load(cond_file.read_text())
                dut_path = cond.get('DUT_path', '')
                if dut_path:
                    return Path(dut_path).stem
            except Exception:
                pass
    return 'unknown'


# ── HTML helpers ───────────────────────────────────────────────────
def _card(title, content, accent=_ACCENT):
    return f'''
    <div style="background:{_BORDER}; border:1px solid {_OVERLAY};
                border-radius:8px; padding:20px; margin:10px 0;
                border-left:4px solid {accent};">
        <h3 style="color:{accent}; margin:0 0 12px 0; font-size:18px;">{title}</h3>
        <div style="color:{_TEXT}; font-size:15px;">{content}</div>
    </div>'''


def _badge(text, color):
    return (f'<span style="background:{color}; color:{_BG}; '
            f'padding:3px 10px; border-radius:4px; font-size:13px; '
            f'font-weight:bold;">{text}</span>')


def _status_badge(status):
    if status == 'pass':
        return _badge('PASS', _GREEN)
    elif status == 'fail':
        return _badge('FAIL', _RED)
    elif status == 'error':
        return _badge('ERROR', _YELLOW)
    return _badge('???', _OVERLAY)


def _fmt_val(val):
    if isinstance(val, float):
        if np.isnan(val):
            return 'ERROR'
        if abs(val) < 1e-3 and val != 0:
            return f'{val:.3e}'
        return f'{val:.4f}'
    return str(val)


def _spec_table(specs):
    rows = ''
    for sname, sdata in specs.items():
        disp = sdata.get('display', sname)
        unit = sdata.get('unit', '')
        lo = sdata.get('minimum', '')
        hi = sdata.get('maximum', '')
        lo_str = f'{lo} {unit}'.strip() if lo != '' else '—'
        hi_str = f'{hi} {unit}'.strip() if hi != '' else '—'
        rows += (f'<tr style="border-bottom:1px solid {_SURFACE};">'
                 f'<td style="padding:6px 10px; color:{_TEXT};">{disp}</td>'
                 f'<td style="padding:6px 10px; text-align:right; color:{_TEXT};">{lo_str}</td>'
                 f'<td style="padding:6px 10px; text-align:right; color:{_TEXT};">{hi_str}</td>'
                 f'</tr>\n')
    return f'''
    <table style="width:100%; border-collapse:collapse; font-size:14px;">
        <tr style="border-bottom:2px solid {_OVERLAY};">
            <th style="text-align:left; padding:6px 10px; color:{_ACCENT};">Spec</th>
            <th style="text-align:right; padding:6px 10px; color:{_ACCENT};">Min</th>
            <th style="text-align:right; padding:6px 10px; color:{_ACCENT};">Max</th>
        </tr>
        {rows}
    </table>'''


def _cace_summary_html(cace_summary):
    """Render CACE per-spec pass/fail summary as styled HTML table.

    cace_summary is a list of dicts (one per spec row).
    """
    if not cace_summary:
        return ''

    rows = ''
    for info in cace_summary:
        result_name = info.get('result_name', '')
        status = info.get('status', 'unknown')
        if status == 'pass':
            status_html = f'<span style="color:{_GREEN}; font-weight:bold;">PASS</span>'
            row_border = _GREEN
        elif status == 'error':
            status_html = f'<span style="color:{_YELLOW}; font-weight:bold;">ERROR</span>'
            row_border = _YELLOW
        elif status == 'fail':
            status_html = f'<span style="color:{_RED}; font-weight:bold;">FAIL</span>'
            row_border = _RED
        else:
            status_html = f'<span style="color:{_OVERLAY}; font-weight:bold;">???</span>'
            row_border = _OVERLAY

        rows += (f'<tr style="border-bottom:1px solid {_SURFACE}; '
                 f'border-left:3px solid {row_border};">'
                 f'<td style="padding:6px 12px; color:{_TEXT}; font-weight:bold;">'
                 f'{info.get("display", result_name)}</td>'
                 f'<td style="padding:6px 12px; color:{_SUBTEXT}; font-size:13px;">'
                 f'{result_name}</td>'
                 f'<td style="padding:6px 12px; text-align:right; color:{_ACCENT}; '
                 f'font-weight:bold;">'
                 f'{info.get("min_limit", "—")}</td>'
                 f'<td style="padding:6px 12px; text-align:right; color:{_TEXT};">'
                 f'{info.get("min_value", "—")}</td>'
                 f'<td style="padding:6px 12px; text-align:right; color:{_TEXT};">'
                 f'{info.get("typ_value", "—")}</td>'
                 f'<td style="padding:6px 12px; text-align:right; color:{_ACCENT}; '
                 f'font-weight:bold;">'
                 f'{info.get("max_limit", "—")}</td>'
                 f'<td style="padding:6px 12px; text-align:right; color:{_TEXT};">'
                 f'{info.get("max_value", "—")}</td>'
                 f'<td style="padding:6px 12px; text-align:center;">'
                 f'{status_html}</td>'
                 f'</tr>\n')

    return f'''
    <div style="margin:8px 0;">
    <table style="width:100%; border-collapse:collapse; font-size:14px;">
        <tr style="border-bottom:2px solid {_OVERLAY};">
            <th style="text-align:left; padding:6px 12px; color:{_ACCENT};">Parameter</th>
            <th style="text-align:left; padding:6px 12px; color:{_ACCENT};">Result</th>
            <th style="text-align:right; padding:6px 12px; color:{_ACCENT};">Min Limit</th>
            <th style="text-align:right; padding:6px 12px; color:{_ACCENT};">Min Value</th>
            <th style="text-align:right; padding:6px 12px; color:{_ACCENT};">Typ Value</th>
            <th style="text-align:right; padding:6px 12px; color:{_ACCENT};">Max Limit</th>
            <th style="text-align:right; padding:6px 12px; color:{_ACCENT};">Max Value</th>
            <th style="text-align:center; padding:6px 12px; color:{_ACCENT};">Status</th>
        </tr>
        {rows}
    </table>
    </div>'''


_UNIT_SI_FACTOR = {
    'fA': 1e-15, 'pA': 1e-12, 'nA': 1e-9, 'uA': 1e-6, 'mA': 1e-3, 'A': 1,
    'fV': 1e-15, 'pV': 1e-12, 'nV': 1e-9, 'uV': 1e-6, 'mV': 1e-3, 'V': 1,
    'fs': 1e-15, 'ps': 1e-12, 'ns': 1e-9, 'us': 1e-6, 'ms': 1e-3, 's': 1,
}


def _spec_to_si(value, unit):
    """Convert a spec limit from display units to base SI."""
    return float(value) * _UNIT_SI_FACTOR.get(unit, 1)


def _check_cell_pass(val, spec):
    """Check if a single value passes its spec. Returns True/False/None (no spec)."""
    if spec is None or not isinstance(val, (int, float)):
        return None
    if isinstance(val, float) and np.isnan(val):
        return None
    unit = spec.get('unit', '')
    if 'minimum' in spec:
        if val < _spec_to_si(spec['minimum'], unit):
            return False
    if 'maximum' in spec:
        if val > _spec_to_si(spec['maximum'], unit):
            return False
    return True


def _check_row_pass(row, meas_cols, spec_limits):
    """Check if all measurements in a row pass spec limits.
    Returns True (pass), False (fail), or None (error/all NaN)."""
    # Check if this is an error row (all measurements NaN)
    if row.get('_is_error', False):
        return None
    all_nan = all(
        isinstance(row.get(c), float) and np.isnan(row.get(c))
        for c in meas_cols if c in row
    )
    if all_nan and meas_cols:
        return None
    for c in meas_cols:
        val = row.get(c)
        result = _check_cell_pass(val, spec_limits.get(c))
        if result is False:
            return False
    return True


def _results_table_html(df, specs=None, param_path=None, variables=None):
    """Build styled HTML results table with row-level pass/fail coloring
    and clickable run names that open gawm via a returned lookup dict."""
    if df is None or df.empty:
        return (f'<p style="color:{_SUBTEXT};">No results available.</p>', {})

    _hidden = {'_is_error'}
    meas_set = set(variables) if variables else set()
    if meas_set:
        param_cols = [c for c in df.columns if c not in meas_set and c not in _hidden]
        meas_cols = [c for c in df.columns if c in meas_set]
    else:
        # Fallback: treat base param cols as params, rest as measurements
        param_cols = [c for c in df.columns if c in _BASE_PARAM_COLS]
        meas_cols = [c for c in df.columns if c not in _BASE_PARAM_COLS and c not in _hidden]

    spec_limits = {}
    if specs:
        for sname, sdata in specs.items():
            spec_limits[sname] = sdata

    # Build raw file lookup for gawm
    raw_lookup = {}
    if param_path:
        pp = Path(param_path)
        if pp.exists():
            for rd in pp.iterdir():
                if rd.is_dir() and rd.name.startswith('run_'):
                    raws = list(rd.glob('*.raw'))
                    if raws:
                        raw_lookup[rd.name] = str(raws[0])

    # Header
    header = ''
    for c in param_cols:
        header += (f'<th style="padding:6px 10px; color:{_TEAL}; '
                   f'background:{_SURFACE}; '
                   f'border-bottom:2px solid {_OVERLAY}; font-size:14px; '
                   f'text-align:right; position:sticky; top:0;">{c}</th>')
    for c in meas_cols:
        unit = spec_limits.get(c, {}).get('unit', '')
        unit_label = f' <span style="color:{_SUBTEXT}; font-size:11px;">[{unit}]</span>' if unit else ''
        header += (f'<th style="padding:6px 10px; color:{_PEACH}; '
                   f'background:{_SURFACE}; '
                   f'border-bottom:2px solid {_OVERLAY}; font-size:14px; '
                   f'text-align:right; position:sticky; top:0;">{c}{unit_label}</th>')

    rows = ''
    for _, row in df.iterrows():
        row_pass = _check_row_pass(row, meas_cols, spec_limits)
        if row_pass is None:
            row_border_color = _YELLOW
            param_bg = 'rgba(238,212,159,0.15)'
        elif row_pass:
            row_border_color = _GREEN
            param_bg = _SURFACE
        else:
            row_border_color = _RED
            param_bg = 'rgba(237,135,150,0.22)'
        cells = ''
        for c in param_cols:
            val = row[c]
            if c == 'run':
                cells += (f'<td style="padding:5px 10px; text-align:right; '
                          f'font-size:13px; color:{_ACCENT}; '
                          f'font-weight:bold; '
                          f'background:{param_bg};">{_fmt_val(val)}</td>')
            else:
                cells += (f'<td style="padding:5px 10px; text-align:right; '
                          f'font-size:13px; color:{_TEAL}; '
                          f'background:{param_bg};">{_fmt_val(val)}</td>')
        for c in meas_cols:
            val = row[c]
            cell_pass = _check_cell_pass(val, spec_limits.get(c))
            is_nan = isinstance(val, float) and np.isnan(val)
            if is_nan:
                cell_color = _YELLOW
                cell_bg = 'rgba(238,212,159,0.15)'
            elif cell_pass is True:
                cell_color = _GREEN
                cell_bg = 'rgba(166,218,149,0.12)'
            elif cell_pass is False:
                cell_color = _RED
                cell_bg = 'rgba(237,135,150,0.18)'
            else:
                cell_color = _TEXT
                cell_bg = 'transparent'

            # Convert SI value to display units
            disp_val = val
            if isinstance(val, (int, float)):
                unit = spec_limits.get(c, {}).get('unit', '')
                factor = _UNIT_SI_FACTOR.get(unit, 1)
                if factor != 0 and factor != 1:
                    disp_val = val / factor

            cells += (f'<td style="padding:5px 10px; text-align:right; '
                      f'font-size:13px; color:{cell_color}; '
                      f'background:{cell_bg};">{_fmt_val(disp_val)}</td>')
        rows += (f'<tr style="border-bottom:1px solid {_SURFACE}; '
                 f'border-left:3px solid {row_border_color};">{cells}</tr>\n')

    html = f'''
    <div style="overflow-x:auto; max-height:500px; overflow-y:auto;
                border:1px solid {_OVERLAY}; border-radius:6px;">
    <table style="width:100%; border-collapse:collapse;">
        <tr>{header}</tr>
        {rows}
    </table>
    </div>'''
    return html, raw_lookup


def _stats_table_html(df, variables):
    if df is None or df.empty:
        return f'<p style="color:{_SUBTEXT};">No data for statistics.</p>'

    numeric_cols = [c for c in df.columns if c in variables]
    if not numeric_cols:
        numeric_cols = [c for c in df.columns
                        if df[c].dtype in ('float64', 'float32')]

    if not numeric_cols:
        return f'<p style="color:{_SUBTEXT};">No numeric data for statistics.</p>'

    header = (f'<th style="padding:6px 10px; color:{_ACCENT}; '
              f'border-bottom:2px solid {_OVERLAY}; text-align:left;">Statistic</th>')
    for c in numeric_cols:
        header += (f'<th style="padding:6px 10px; color:{_PEACH}; '
                   f'border-bottom:2px solid {_OVERLAY}; text-align:right;">{c}</th>')

    stats = {
        'Mean': lambda s: s.mean(),
        'Std': lambda s: s.std(),
        'Min': lambda s: s.min(),
        'Max': lambda s: s.max(),
        'Median': lambda s: s.median(),
    }

    rows = ''
    for stat_name, stat_fn in stats.items():
        cells = (f'<td style="padding:5px 10px; color:{_ACCENT}; '
                 f'font-weight:bold;">{stat_name}</td>')
        for c in numeric_cols:
            val = stat_fn(df[c])
            cells += (f'<td style="padding:5px 10px; text-align:right; '
                      f'color:{_TEXT}; font-size:14px;">{_fmt_val(val)}</td>')
        rows += f'<tr style="border-bottom:1px solid {_SURFACE};">{cells}</tr>\n'

    return f'''
    <div style="overflow-x:auto; border:1px solid {_OVERLAY}; border-radius:6px;">
    <table style="width:100%; border-collapse:collapse; font-size:14px;">
        <tr>{header}</tr>
        {rows}
    </table>
    </div>'''


# ── Plotting ───────────────────────────────────────────────────────
def _make_corner_plot(df, y_col, y_label, spec_info=None):
    if df is None or df.empty or y_col not in df.columns:
        return hv.Div(f'<p style="color:{_SUBTEXT}; font-size:15px;">'
                      f'No data for {y_label}</p>')

    has_corner = 'corner' in df.columns
    has_temp = 'temperature' in df.columns
    has_vdd = 'vdd' in df.columns

    if not has_temp:
        return hv.Div(f'<p style="color:{_SUBTEXT};">No temperature data.</p>')

    plots = []
    corners = sorted(df['corner'].unique()) if has_corner else ['all']

    for corner in corners:
        sub = df[df['corner'] == corner] if has_corner else df
        color = CORNER_COLORS.get(corner, _TEXT)

        if has_vdd:
            for vdd in sorted(sub['vdd'].unique()):
                vsub = sub[sub['vdd'] == vdd]
                label = f'{corner} VDD={vdd}V'
                curve = hv.Curve(
                    vsub.sort_values('temperature'),
                    kdims='temperature', vdims=y_col, label=label,
                ).opts(color=color, line_dash='solid' if vdd == 1.8 else 'dashed',
                       line_width=2)
                scatter = hv.Scatter(
                    vsub, kdims='temperature', vdims=y_col, label=label
                ).opts(color=color, size=8, marker='circle')
                plots.extend([curve, scatter])
        else:
            curve = hv.Curve(
                sub.sort_values('temperature'), kdims='temperature',
                vdims=y_col, label=corner,
            ).opts(color=color, line_width=2)
            scatter = hv.Scatter(
                sub, kdims='temperature', vdims=y_col, label=corner,
            ).opts(color=color, size=8)
            plots.extend([curve, scatter])

    overlay = hv.Overlay(plots)

    if spec_info:
        if 'minimum' in spec_info:
            overlay = overlay * hv.HLine(float(spec_info['minimum'])).opts(
                color=_RED, line_dash='dotted', line_width=2)
        if 'maximum' in spec_info:
            overlay = overlay * hv.HLine(float(spec_info['maximum'])).opts(
                color=_RED, line_dash='dotted', line_width=2)

    overlay = overlay.opts(
        hv.opts.Overlay(
            width=600, height=380,
            xlabel='Temperature (C)',
            ylabel=y_label,
            title=y_label,
            legend_position='right',
            hooks=[_style_hv],
            show_grid=True,
        )
    )
    return overlay


def _make_bar_plot(df, y_col, y_label, spec_info=None):
    if df is None or df.empty or y_col not in df.columns:
        return hv.Div(f'<p style="color:{_SUBTEXT};">No data for {y_label}</p>')

    if 'corner' not in df.columns:
        return hv.Div(f'<p style="color:{_SUBTEXT};">No corner data.</p>')

    stats = df.groupby('corner')[y_col].agg(['mean', 'min', 'max']).reset_index()

    bars = hv.Bars(
        stats, kdims='corner', vdims='mean',
    ).opts(
        color=hv.dim('corner').categorize(CORNER_COLORS, default=_TEXT),
        width=400, height=350,
        xlabel='Corner', ylabel=f'{y_label} (mean)',
        title=f'{y_label} by Corner',
        hooks=[_style_hv],
    )

    overlay = bars
    if spec_info:
        if 'minimum' in spec_info:
            overlay = overlay * hv.HLine(float(spec_info['minimum'])).opts(
                color=_RED, line_dash='dotted', line_width=2)
        if 'maximum' in spec_info:
            overlay = overlay * hv.HLine(float(spec_info['maximum'])).opts(
                color=_RED, line_dash='dotted', line_width=2)

    return overlay


# ── Dashboard factory ──────────────────────────────────────────────
def create_dashboard():
    blocks = discover_blocks()
    runs = discover_runs()
    refs = load_refs()

    header_html = f'''
    <div style="background:{_BORDER}; padding:24px; border-radius:8px;
                margin-bottom:20px; border-bottom:3px solid {_ACCENT};">
        <h1 style="color:{_ACCENT}; margin:0; font-size:28px;">
            CACE Characterization Dashboard</h1>
        <p style="color:{_SUBTEXT}; margin:6px 0 0 0; font-size:16px;">
            openDVS &mdash; {ANALOG_ROOT}</p>
    </div>'''

    block_tabs = []

    for bname, binfo in blocks.items():
        block_runs = {}
        for rkey, rdata in runs.items():
            if rdata['block_name'] == bname:
                block_runs[rkey] = rdata
            elif any(rdata['param_name'] == pn_
                     for pn_ in binfo['parameters']):
                block_runs[rkey] = rdata

        ref_tag = refs.get(bname, '')

        # Block info card
        params_html = ''
        for pn_, pdata in binfo['parameters'].items():
            conds = pdata.get('conditions', {})
            cond_parts = []
            for ck, cv in conds.items():
                if 'enumerate' in cv:
                    cond_parts.append(
                        f'<b style="color:{_TEAL};">{ck}</b>: {cv["enumerate"]}')
                elif 'typical' in cv:
                    cond_parts.append(
                        f'<b style="color:{_TEAL};">{ck}</b>: {cv["typical"]}')
            cond_str = ' &middot; '.join(cond_parts) if cond_parts else '—'
            params_html += f'''
            <div style="margin:12px 0; padding:10px; background:{_SURFACE};
                        border-radius:6px;">
                <b style="color:{_PEACH}; font-size:16px;">{pdata["display"]}</b>
                <span style="color:{_SUBTEXT}; font-size:13px;"> ({pn_})</span>
                <br><span style="color:{_TEXT}; font-size:14px; margin-top:4px;
                           display:inline-block;">
                    Conditions: {cond_str}</span>
                <div style="margin-top:8px;">{_spec_table(pdata['specs'])}</div>
            </div>'''

        info_html = _card(
            bname,
            f'''<p style="color:{_TEXT}; font-size:15px;">{binfo["description"]}</p>
                <p style="font-size:14px; color:{_SUBTEXT};">
                PDK: <b style="color:{_TEAL};">{binfo["pdk"]}</b> &middot;
                Designer: <b style="color:{_TEAL};">{binfo["designer"]}</b></p>
                {params_html}''',
            _ACCENT)

        btn_open_sch = pn.widgets.Button(
            name=f'Open {bname}.sch in xschem',
            button_type='primary', width=300, height=40)

        def _open_sch(event, sch=binfo['schematic']):
            subprocess.Popen(
                ['/bin/zsh', '-c',
                 f'source {CAD_SETUP} && xschem {sch}'],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL)

        btn_open_sch.on_click(_open_sch)

        btn_refresh = pn.widgets.Button(
            name='Refresh runs', button_type='default', width=160, height=40)

        runs_content = pn.Column(sizing_mode='stretch_width')
        analysis_content = pn.Column(sizing_mode='stretch_width')

        def _build_analysis(block_name=bname, block_info=binfo,
                            container=analysis_content, cached_runs=None):
            container.clear()
            fresh_runs = cached_runs if cached_runs is not None else discover_runs()
            fresh_refs = load_refs()
            ref_tag = fresh_refs.get(block_name, '')

            b_runs = {}
            for rkey, rdata in fresh_runs.items():
                if rdata['block_name'] == block_name:
                    b_runs[rkey] = rdata
                elif any(rdata['param_name'] == pn_
                         for pn_ in block_info['parameters']):
                    b_runs[rkey] = rdata

            if not b_runs:
                container.append(pn.pane.HTML(
                    f'<p style="color:{_SUBTEXT}; font-size:16px; padding:20px;">'
                    f'No runs available for analysis.</p>'))
                return

            # Separate MC and regular runs
            regular_runs = {k: v for k, v in b_runs.items()
                            if not v.get('is_mc', False)}
            mc_runs = {k: v for k, v in b_runs.items()
                       if v.get('is_mc', False)}

            # Get variable names and specs from block info
            all_vars = []
            all_specs = {}
            for pn_, pdata in block_info['parameters'].items():
                all_vars.extend(pdata.get('variables', []))
                for sname, sdata in pdata.get('specs', {}).items():
                    all_specs[sname] = sdata

            # ── Regular (corner sweep) analysis ──
            # Group regular runs by param_name, pick best run per param
            param_targets = {}
            for rkey, rdata in regular_runs.items():
                pname = rdata['param_name']
                existing = param_targets.get(pname)
                if existing is None:
                    param_targets[pname] = rdata
                elif rdata['tag'] == ref_tag:
                    param_targets[pname] = rdata
                elif (existing['tag'] != ref_tag
                      and rdata['tag'] > existing['tag']):
                    param_targets[pname] = rdata

            # Show run header (use tag from any target)
            if param_targets:
                first_target = next(iter(param_targets.values()))
                run_label = first_target['tag']
                is_ref = first_target['tag'] == ref_tag
                label_badge = (_badge('REFERENCE', _GREEN) if is_ref
                               else _badge('LATEST', _ACCENT))

                container.append(pn.pane.HTML(
                    f'<div style="margin:10px 0;">'
                    f'<span style="color:{_TEXT}; font-size:16px;">Analyzing: '
                    f'<b style="color:{_ACCENT};">{run_label}</b></span> {label_badge}'
                    f'</div>'))

                # CACE per-spec summary (shared across param blocks)
                cace_summary = first_target.get('cace_summary', [])
                if cace_summary:
                    container.append(pn.pane.HTML(
                        f'<h3 style="color:{_MAUVE}; font-size:20px; margin:16px 0 8px;">'
                        f'Spec Results — Corner Sweep</h3>'))
                    container.append(pn.pane.HTML(
                        _cace_summary_html(cace_summary),
                        sizing_mode='stretch_width'))

            # Show Statistics and Plots per parameter block
            for pidx, (pname, target_run) in enumerate(param_targets.items()):
                df = _load_run_data(target_run)
                # Get variables for this specific param block
                p_vars = []
                p_specs = {}
                for pn_, pdata in block_info['parameters'].items():
                    if pn_ == pname:
                        p_vars = pdata.get('variables', [])
                        for sname, sdata in pdata.get('specs', {}).items():
                            p_specs[sname] = sdata
                        break
                if not p_vars:
                    p_vars = all_vars
                    p_specs = all_specs

                if df is not None and not df.empty:
                    var_col_map = {v: v for v in p_vars if v in df.columns}

                    if var_col_map:
                        # Section header for this param block
                        pdata_info = block_info['parameters'].get(pname, {})
                        p_display = pdata_info.get('display', pname)
                        # Show conditions if available
                        conds = pdata_info.get('conditions', {})
                        cond_parts = []
                        for ck, cv in conds.items():
                            if isinstance(cv, dict) and 'enumerate' in cv:
                                cond_parts.append(
                                    f'<b style="color:{_PEACH};">{ck}</b>: '
                                    f'{cv["enumerate"]}')
                        cond_str = (' · '.join(cond_parts)
                                    if cond_parts else '')

                        if len(param_targets) > 1:
                            container.append(pn.pane.HTML(
                                f'<h3 style="color:{_TEAL}; font-size:18px; '
                                f'margin:20px 0 4px;">'
                                f'{p_display}</h3>'
                                + (f'<div style="color:{_SUBTEXT}; '
                                   f'font-size:13px; margin-bottom:8px;">'
                                   f'{cond_str}</div>' if cond_str else '')))

                        # Statistics
                        container.append(pn.pane.HTML(
                            f'<h3 style="color:{_MAUVE}; font-size:20px; margin:20px 0 10px;">'
                            f'Statistics</h3>'))
                        container.append(pn.pane.HTML(
                            _stats_table_html(df, list(var_col_map.keys())),
                            sizing_mode='stretch_width'))

                        # Filter widgets
                        container.append(pn.pane.HTML(
                            f'<h3 style="color:{_MAUVE}; font-size:20px; margin:24px 0 10px;">'
                            f'Plots</h3>'))

                        corners = (sorted(df['corner'].unique().tolist())
                                   if 'corner' in df.columns else [])
                        vdds = (sorted(df['vdd'].unique().tolist())
                                if 'vdd' in df.columns else [])

                        # Detect extra condition columns (not standard)
                        _std_cols = ({'run', 'corner', 'temperature', 'temp',
                                      'vdd'}
                                     | set(p_vars) | set(var_col_map.keys()))
                        extra_conds = [c for c in df.columns
                                       if c not in _std_cols
                                       and df[c].nunique() > 1]

                        w_corners = pn.widgets.CheckBoxGroup(
                            name='Corners', value=corners, options=corners,
                            inline=True)
                        w_vdds = pn.widgets.CheckBoxGroup(
                            name='VDD', value=[str(v) for v in vdds],
                            options=[str(v) for v in vdds], inline=True)
                        w_var = pn.widgets.Select(
                            name='Variable',
                            value=p_vars[0] if p_vars else '',
                            options=[v for v in p_vars if v in var_col_map],
                            width=250)

                        # Build extra condition widgets
                        extra_widgets = {}
                        for ec in extra_conds:
                            ec_vals = sorted(
                                df[ec].unique().tolist(),
                                key=lambda x: str(x))
                            ec_opts = [str(v) for v in ec_vals]
                            extra_widgets[ec] = pn.widgets.CheckBoxGroup(
                                name=ec, value=ec_opts, options=ec_opts,
                                inline=True)

                        filter_cols = [
                            pn.Column(
                                pn.pane.HTML(
                                    f'<b style="color:{_ACCENT}; '
                                    f'font-size:15px;">Corners:</b>'),
                                w_corners),
                            pn.Column(
                                pn.pane.HTML(
                                    f'<b style="color:{_ACCENT}; '
                                    f'font-size:15px;">VDD (V):</b>'),
                                w_vdds),
                        ]
                        for ec, ew in extra_widgets.items():
                            filter_cols.append(pn.Column(
                                pn.pane.HTML(
                                    f'<b style="color:{_ACCENT}; '
                                    f'font-size:15px;">{ec}:</b>'),
                                ew))
                        filter_cols.append(pn.Column(
                            pn.pane.HTML(
                                f'<b style="color:{_ACCENT}; '
                                f'font-size:15px;">Variable:</b>'),
                            w_var))

                        filter_row = pn.Row(
                            *filter_cols,
                            margin=(0, 0, 10, 0),
                        )
                        container.append(filter_row)

                        plot_area = pn.Column(sizing_mode='stretch_width')
                        container.append(plot_area)

                        def _make_update_plots(pa, wc, wv, wvar, the_df,
                                               the_specs, extra_w=None):
                            def _update_plots(event=None):
                                pa.clear()
                                sel_corners = wc.value
                                sel_vdds = [float(v) for v in wv.value]
                                sel_var = wvar.value

                                filt = the_df.copy()
                                if 'corner' in filt.columns and sel_corners:
                                    filt = filt[
                                        filt['corner'].isin(sel_corners)]
                                if 'vdd' in filt.columns and sel_vdds:
                                    filt = filt[filt['vdd'].isin(sel_vdds)]
                                # Apply extra condition filters
                                if extra_w:
                                    for ecol, ew in extra_w.items():
                                        if ecol in filt.columns:
                                            sel = ew.value
                                            filt = filt[filt[ecol].astype(
                                                str).isin(sel)]

                                if filt.empty:
                                    pa.append(pn.pane.HTML(
                                        f'<p style="color:{_SUBTEXT}; '
                                        f'font-size:15px;">'
                                        f'No data for selected filters.</p>'))
                                    return

                                spec = the_specs.get(sel_var, {})
                                disp = (spec.get('display', sel_var)
                                        if spec else sel_var)

                                curve_plot = _make_corner_plot(
                                    filt, sel_var, disp, spec)
                                bar_plot = _make_bar_plot(
                                    filt, sel_var, disp, spec)

                                pa.append(pn.Row(
                                    pn.pane.HoloViews(
                                        curve_plot, sizing_mode='fixed'),
                                    pn.pane.HoloViews(
                                        bar_plot, sizing_mode='fixed'),
                                ))

                                pa.append(pn.pane.HTML(
                                    f'<h4 style="color:{_PEACH}; '
                                    f'font-size:17px; '
                                    f'margin:16px 0 8px;">'
                                    f'Filtered Statistics</h4>'))
                                pa.append(pn.pane.HTML(
                                    _stats_table_html(filt, [sel_var]),
                                    sizing_mode='stretch_width'))
                            return _update_plots

                        updater = _make_update_plots(
                            plot_area, w_corners, w_vdds, w_var,
                            df, p_specs, extra_w=extra_widgets)
                        w_corners.param.watch(updater, 'value')
                        w_vdds.param.watch(updater, 'value')
                        w_var.param.watch(updater, 'value')
                        for ew in extra_widgets.values():
                            ew.param.watch(updater, 'value')
                        updater()

            # ── Monte Carlo analysis ──
            if mc_runs:
                # Find latest MC run
                mc_target = sorted(mc_runs.values(),
                                   key=lambda x: x['tag'], reverse=True)[0]

                mc_param_name = mc_target['param_name']
                mc_vars = all_vars
                mc_specs = all_specs
                for pn_, pdata in block_info['parameters'].items():
                    if pn_ == mc_param_name:
                        mc_vars = pdata.get('variables', all_vars)
                        mc_specs = {}
                        for sname, sdata in pdata.get('specs', {}).items():
                            mc_specs[sname] = sdata
                        break

                mc_df = _build_mc_df(Path(mc_target['param_path']), mc_vars)

                if mc_df is not None and not mc_df.empty:
                    container.append(pn.pane.HTML(
                        f'<h3 style="color:{_MAUVE}; font-size:20px; '
                        f'margin:24px 0 8px;">Spec Results — Monte Carlo</h3>'
                        f'<div style="color:{_SUBTEXT}; font-size:14px; '
                        f'margin-bottom:8px;">Run: {mc_target["tag"]} '
                        f'({mc_param_name})</div>'))
                    container.append(pn.pane.HTML(
                        _mc_cace_summary_html(mc_df, mc_vars, mc_specs),
                        sizing_mode='stretch_width'))

                    # MC summary table
                    container.append(pn.pane.HTML(
                        f'<h3 style="color:{_MAUVE}; font-size:20px; '
                        f'margin:20px 0 10px;">MC Statistics (μ±3σ)</h3>'))
                    container.append(pn.pane.HTML(
                        _mc_summary_table_html(mc_df, mc_vars, mc_specs),
                        sizing_mode='stretch_width'))

                    # MC histograms and QQ plots
                    container.append(pn.pane.HTML(
                        f'<h3 style="color:{_MAUVE}; font-size:20px; '
                        f'margin:20px 0 10px;">MC Distributions</h3>'))
                    container.append(
                        _mc_plots_panel(mc_df, mc_vars, mc_specs))

        def _build_runs_list(block_name=bname, container=runs_content,
                             block_info=binfo,
                             analysis_container=analysis_content,
                             cached_runs=None):
            container.clear()
            fresh_runs = cached_runs if cached_runs is not None else discover_runs()
            fresh_refs = load_refs()
            ref_tag = fresh_refs.get(block_name, '')

            b_runs = {}
            for rkey, rdata in fresh_runs.items():
                if rdata['block_name'] == block_name:
                    b_runs[rkey] = rdata
                elif any(rdata['param_name'] == pn_
                         for pn_ in block_info['parameters']):
                    b_runs[rkey] = rdata

            if not b_runs:
                container.append(pn.pane.HTML(
                    f'<p style="color:{_SUBTEXT}; font-size:16px; padding:20px;">'
                    f'No runs found for this block.</p>'))
                return

            # Collect all specs and variable names for cell coloring / param detection
            all_specs = {}
            all_vars = []
            for pn_, pdata in block_info['parameters'].items():
                all_vars.extend(pdata.get('variables', []))
                for sname, sdata in pdata.get('specs', {}).items():
                    all_specs[sname] = sdata

            for rkey, rdata in sorted(b_runs.items(),
                                       key=lambda x: x[1]['tag'],
                                       reverse=True):
                is_ref = rdata['tag'] == ref_tag
                border_color = _GREEN if is_ref else _OVERLAY
                ref_label = (_badge('REFERENCE', _GREEN) if is_ref else '')

                status = rdata['status']
                status_color = (_GREEN if status == 'pass'
                                else _RED if status == 'fail'
                                else _YELLOW if status == 'error'
                                else _OVERLAY)

                # Build conditions summary for run card
                _rc_pdata = block_info['parameters'].get(
                    rdata['param_name'], {})
                _rc_display = _rc_pdata.get('display', rdata['param_name'])
                _rc_conditions = _rc_pdata.get('conditions', {})
                _rc_cond_parts = []
                for ck, cv in _rc_conditions.items():
                    if isinstance(cv, dict) and 'enumerate' in cv:
                        vals = cv['enumerate']
                    elif isinstance(cv, list):
                        vals = cv
                    else:
                        vals = [cv]
                    vals_str = ', '.join(str(v) for v in vals)
                    _rc_cond_parts.append(
                        f'<span style="color:{_ACCENT};">{ck}:</span> '
                        f'[{vals_str}]')
                _rc_cond_html = (' · '.join(_rc_cond_parts)
                                 if _rc_cond_parts else '')

                run_html = f'''
                <div style="background:{_BORDER};
                            border:1px solid {border_color};
                            border-radius:6px; padding:14px; margin:8px 0;
                            border-left:4px solid {status_color};">
                    <div style="display:flex; justify-content:space-between;
                                align-items:center;">
                        <div>
                            <b style="color:{_ACCENT}; font-size:16px;">
                                {rdata["tag"]}</b>
                            {ref_label}
                            <span style="color:{_SUBTEXT}; font-size:14px;
                                         margin-left:12px;">
                                {rdata["param_name"]}</span>
                        </div>
                        <div>
                            {_status_badge(status)}
                            <span style="color:{_TEXT}; font-size:14px;
                                         margin-left:8px;">
                                {rdata["num_sims"]} sims</span>
                        </div>
                    </div>
                    <div style="font-size:13px; color:{_SUBTEXT};
                                margin-top:6px;">
                        <b style="color:{_MAUVE};">{_rc_display}</b>
                    </div>
                    {f'<div style="font-size:12px; color:{_SUBTEXT}; margin-top:4px;">{_rc_cond_html}</div>' if _rc_cond_html else ''}
                </div>'''

                btn_ref = pn.widgets.Button(
                    name='Set as Reference' if not is_ref else 'Unset Reference',
                    button_type='success' if not is_ref else 'warning',
                    width=180, height=36)
                btn_del = pn.widgets.Button(
                    name='Delete', button_type='danger', width=110, height=36)

                # Toggle details button
                btn_toggle = pn.widgets.Toggle(
                    name='Show Details', button_type='default',
                    width=140, height=36)

                detail_area = pn.Column(sizing_mode='stretch_width', visible=False)

                def _set_ref(event, tag=rdata['tag'], bn=block_name,
                             currently_ref=is_ref):
                    r = load_refs()
                    if currently_ref:
                        r.pop(bn, None)
                    else:
                        r[bn] = tag
                    save_refs(r)
                    fresh = discover_runs()
                    _build_runs_list(cached_runs=fresh)
                    _build_analysis(cached_runs=fresh)

                def _delete_run(event, path=rdata['path'], bn=block_name):
                    try:
                        shutil.rmtree(path)
                    except Exception as e:
                        detail_area.clear()
                        detail_area.visible = True
                        detail_area.append(pn.pane.HTML(
                            f'<p style="color:{_RED}; font-size:15px;">'
                            f'Error: {e}</p>'))
                        return
                    fresh = discover_runs()
                    _build_runs_list(cached_runs=fresh)
                    _build_analysis(cached_runs=fresh)

                def _toggle_detail(event, rdata=rdata, area=detail_area,
                                   toggle=btn_toggle, specs=all_specs,
                                   _all_vars=all_vars,
                                   _block_info=block_info):
                    if event.new:  # expanded
                        toggle.name = 'Hide Details'
                        area.visible = True
                        if len(area) == 0:
                            param_path = rdata.get('param_path', '')
                            is_mc = rdata.get('is_mc', False)

                            # Get variables for this specific parameter
                            param_name = rdata.get('param_name', '')
                            param_vars = _all_vars
                            param_specs = specs
                            for pn_, pdata in _block_info['parameters'].items():
                                if pn_ == param_name:
                                    param_vars = pdata.get('variables', _all_vars)
                                    param_specs = {}
                                    for sname, sdata in pdata.get('specs', {}).items():
                                        param_specs[sname] = sdata
                                    break

                            if is_mc:
                                # ── Monte Carlo detail view ──

                                # ── Run info header (MC) ──
                                _ri_param_data = _block_info['parameters'].get(param_name, {})
                                _ri_display = _ri_param_data.get('display', param_name)
                                _ri_conditions = _ri_param_data.get('conditions', {})
                                _ri_template = _ri_param_data.get('template', '')
                                _ri_collate = _ri_param_data.get('collate', '')
                                _ri_yaml = _block_info.get('yaml_path', '')
                                _ri_pdk = _block_info.get('pdk', '')
                                _ri_dut = _block_info.get('dut_name', '')

                                _ri_cond_items = []
                                for ck, cv in _ri_conditions.items():
                                    if isinstance(cv, dict) and 'enumerate' in cv:
                                        vals = cv['enumerate']
                                    elif isinstance(cv, list):
                                        vals = cv
                                    else:
                                        vals = [cv]
                                    vals_str = ', '.join(str(v) for v in vals)
                                    _ri_cond_items.append(
                                        f'<span style="color:{_ACCENT};">{ck}:</span> '
                                        f'[{vals_str}]')
                                _ri_cond_html = ' · '.join(_ri_cond_items)
                                _ri_yaml_short = os.path.basename(_ri_yaml) if _ri_yaml else ''

                                _ri_mc_html = f'''
                                <div style="background:{_SURFACE};
                                            border-radius:6px; padding:12px; margin:8px 0;">
                                    <div style="font-size:16px; font-weight:bold;
                                                color:{_MAUVE}; margin-bottom:6px;">
                                        {_ri_display} (Monte Carlo)</div>
                                    <div style="font-size:13px; color:{_SUBTEXT};
                                                margin-bottom:6px;">
                                        DUT: {_ri_dut} · PDK: {_ri_pdk}
                                        {(" · Template: " + _ri_template) if _ri_template else ""}
                                        {(" · Collate: " + _ri_collate) if _ri_collate else ""}
                                    </div>
                                    <div style="font-size:14px; color:{_TEXT};
                                                margin-bottom:4px;">
                                        <b>Conditions:</b> {_ri_cond_html}</div>
                                    <div style="color:{_SUBTEXT}; font-size:13px;">
                                        YAML: {_ri_yaml_short}</div>
                                </div>'''
                                area.append(pn.pane.HTML(
                                    _ri_mc_html, sizing_mode='stretch_width'))

                                mc_df = _build_mc_df(
                                    Path(param_path), param_vars)

                                if mc_df is not None and not mc_df.empty:
                                    # MC summary table (μ±3σ)
                                    area.append(pn.pane.HTML(
                                        f'<h4 style="color:{_MAUVE}; font-size:16px; '
                                        f'margin:10px 0 6px;">Monte Carlo Summary</h4>'))
                                    area.append(pn.pane.HTML(
                                        _mc_summary_table_html(
                                            mc_df, param_vars, param_specs),
                                        sizing_mode='stretch_width'))

                                    # MC histograms and QQ plots
                                    area.append(pn.pane.HTML(
                                        f'<h4 style="color:{_MAUVE}; font-size:16px; '
                                        f'margin:14px 0 6px;">Distributions</h4>'))
                                    area.append(
                                        _mc_plots_panel(
                                            mc_df, param_vars, param_specs))

                                    # Results table (per-iteration)
                                    area.append(pn.pane.HTML(
                                        f'<h4 style="color:{_MAUVE}; font-size:16px; '
                                        f'margin:14px 0 6px;">Per-Iteration Results '
                                        f'({len(mc_df)} iterations)</h4>'))

                                    sort_col = pn.widgets.Select(
                                        name='Sort by',
                                        options=['—'] + list(mc_df.columns),
                                        value='—', width=140)
                                    sort_asc = pn.widgets.Toggle(
                                        name='Asc', value=True,
                                        width=50, height=36)
                                    table_pane = pn.pane.HTML(
                                        sizing_mode='stretch_width')

                                    def _update_mc_table(
                                            event=None,
                                            _df=mc_df, _specs=param_specs,
                                            _vars=param_vars,
                                            _pp=param_path,
                                            _sc=sort_col, _sa=sort_asc,
                                            _tp=table_pane):
                                        filtered = _df.copy()
                                        if (_sc.value != '—'
                                                and _sc.value in filtered.columns):
                                            filtered = filtered.sort_values(
                                                _sc.value, ascending=_sa.value)
                                        html, _ = _results_table_html(
                                            filtered, specs=_specs,
                                            param_path=_pp,
                                            variables=_vars)
                                        _tp.object = html

                                    sort_col.param.watch(
                                        _update_mc_table, 'value')
                                    sort_asc.param.watch(
                                        _update_mc_table, 'value')
                                    area.append(pn.Row(
                                        sort_col, sort_asc,
                                        sizing_mode='stretch_width'))
                                    _update_mc_table()
                                    area.append(table_pane)
                                else:
                                    area.append(pn.pane.HTML(
                                        f'<p style="color:{_SUBTEXT}; font-size:15px;">'
                                        f'No MC data found.</p>'))
                            else:
                                # ── Regular (corner sweep) detail view ──

                                # ── Run info header ──
                                _ri_param_data = _block_info['parameters'].get(param_name, {})
                                _ri_display = _ri_param_data.get('display', param_name)
                                _ri_conditions = _ri_param_data.get('conditions', {})
                                _ri_template = _ri_param_data.get('template', '')
                                _ri_yaml = _block_info.get('yaml_path', '')
                                _ri_desc = _block_info.get('description', '')
                                _ri_pdk = _block_info.get('pdk', '')
                                _ri_dut = _block_info.get('dut_name', '')

                                # Build conditions summary
                                _ri_cond_items = []
                                for ck, cv in _ri_conditions.items():
                                    if isinstance(cv, dict) and 'enumerate' in cv:
                                        vals = cv['enumerate']
                                    elif isinstance(cv, list):
                                        vals = cv
                                    else:
                                        vals = [cv]
                                    vals_str = ', '.join(str(v) for v in vals)
                                    _ri_cond_items.append(
                                        f'<span style="color:{_ACCENT};">{ck}:</span> '
                                        f'[{vals_str}]')
                                _ri_cond_html = ' · '.join(_ri_cond_items)

                                _ri_yaml_link = ''
                                if _ri_yaml:
                                    _ri_yaml_short = os.path.basename(_ri_yaml)
                                    _ri_yaml_link = (
                                        f'<span style="color:{_SUBTEXT}; font-size:13px;">'
                                        f'YAML: {_ri_yaml_short}</span>')

                                _ri_html = f'''
                                <div style="background:{_SURFACE};
                                            border-radius:6px; padding:12px; margin:8px 0;">
                                    <div style="font-size:16px; font-weight:bold;
                                                color:{_MAUVE}; margin-bottom:6px;">
                                        {_ri_display}</div>
                                    <div style="font-size:13px; color:{_SUBTEXT};
                                                margin-bottom:6px;">
                                        DUT: {_ri_dut} · PDK: {_ri_pdk}
                                        {(" · " + _ri_desc) if _ri_desc else ""}
                                        {(" · Template: " + _ri_template) if _ri_template else ""}
                                    </div>
                                    <div style="font-size:14px; color:{_TEXT};
                                                margin-bottom:4px;">
                                        <b>Conditions:</b> {_ri_cond_html}</div>
                                    <div>{_ri_yaml_link}</div>
                                </div>'''
                                area.append(pn.pane.HTML(
                                    _ri_html, sizing_mode='stretch_width'))

                                # YAML viewer toggle
                                if _ri_yaml and os.path.isfile(_ri_yaml):
                                    _yaml_toggle = pn.widgets.Toggle(
                                        name='View YAML', button_type='default',
                                        width=120, height=32)
                                    _yaml_area = pn.pane.HTML(
                                        '', sizing_mode='stretch_width',
                                        visible=False)

                                    def _toggle_yaml(event,
                                                     _ypath=_ri_yaml,
                                                     _ya=_yaml_area,
                                                     _yt=_yaml_toggle):
                                        if event.new:
                                            _yt.name = 'Hide YAML'
                                            try:
                                                _ytext = Path(_ypath).read_text()
                                                import html as _html_mod
                                                _ytext_esc = _html_mod.escape(_ytext)
                                            except Exception:
                                                _ytext_esc = 'Error reading YAML'
                                            _ya.object = (
                                                f'<pre style="color:{_TEXT}; '
                                                f'font-size:13px; background:{_SURFACE}; '
                                                f'padding:12px; border-radius:6px; '
                                                f'overflow-x:auto; max-height:500px; '
                                                f'overflow-y:auto;">{_ytext_esc}</pre>')
                                            _ya.visible = True
                                        else:
                                            _yt.name = 'View YAML'
                                            _ya.visible = False

                                    _yaml_toggle.param.watch(_toggle_yaml, 'value')
                                    area.append(pn.Row(_yaml_toggle))
                                    area.append(_yaml_area)

                                # CACE summary
                                cace_summary = rdata.get('cace_summary', [])
                                if cace_summary:
                                    area.append(pn.pane.HTML(
                                        f'<h4 style="color:{_MAUVE}; font-size:16px; '
                                        f'margin:10px 0 6px;">Spec Results</h4>'))
                                    area.append(pn.pane.HTML(
                                        _cace_summary_html(cace_summary),
                                        sizing_mode='stretch_width'))

                                # Simulation data table with filters
                                df = _load_run_data(rdata)
                                if df is not None and not df.empty:
                                    _, raw_lookup = _results_table_html(
                                        df, specs=specs,
                                        param_path=param_path,
                                        variables=_all_vars)

                                    area.append(pn.pane.HTML(
                                        f'<h4 style="color:{_MAUVE}; font-size:16px; '
                                        f'margin:14px 0 6px;">Simulation Results</h4>'))

                                    meas_set = set(_all_vars) if _all_vars else set()
                                    filterable = [c for c in df.columns
                                                  if c not in meas_set and c != 'run']
                                    filter_widgets = {}
                                    for col in filterable:
                                        unique = sorted(df[col].dropna().unique(),
                                                        key=str)
                                        opts = ['All'] + [str(v) for v in unique]
                                        filter_widgets[col] = pn.widgets.Select(
                                            name=col, options=opts, value='All',
                                            width=120)

                                    sort_col = pn.widgets.Select(
                                        name='Sort by',
                                        options=['—'] + list(df.columns),
                                        value='—', width=140)
                                    sort_asc = pn.widgets.Toggle(
                                        name='Asc', value=True,
                                        width=50, height=36)

                                    table_pane = pn.pane.HTML(
                                        sizing_mode='stretch_width')

                                    def _update_table(event=None,
                                                      _df=df, _specs=specs,
                                                      _vars=_all_vars,
                                                      _pp=param_path,
                                                      _fw=filter_widgets,
                                                      _sc=sort_col,
                                                      _sa=sort_asc,
                                                      _tp=table_pane):
                                        filtered = _df.copy()
                                        for col, w in _fw.items():
                                            if w.value != 'All':
                                                filtered = filtered[
                                                    filtered[col].astype(str) == w.value]
                                        if (_sc.value != '—'
                                                and _sc.value in filtered.columns):
                                            filtered = filtered.sort_values(
                                                _sc.value, ascending=_sa.value)
                                        html, _ = _results_table_html(
                                            filtered, specs=_specs,
                                            param_path=_pp,
                                            variables=_vars)
                                        _tp.object = html

                                    for w in filter_widgets.values():
                                        w.param.watch(_update_table, 'value')
                                    sort_col.param.watch(_update_table, 'value')
                                    sort_asc.param.watch(_update_table, 'value')

                                    controls = list(filter_widgets.values())
                                    controls.extend([sort_col, sort_asc])
                                    area.append(pn.Row(
                                        *controls,
                                        sizing_mode='stretch_width'))
                                    _update_table()
                                    area.append(table_pane)

                                    if raw_lookup:
                                        run_options = [''] + sorted(raw_lookup.keys())
                                        sel_run = pn.widgets.Select(
                                            name='Open in gawm',
                                            options=run_options,
                                            width=200, height=36)

                                        def _open_gawm(event, _rl=raw_lookup):
                                            rn = event.new
                                            if not rn:
                                                return
                                            raw_path = _rl.get(rn, '')
                                            if raw_path and os.path.isfile(raw_path):
                                                subprocess.Popen(
                                                    ['gawm', raw_path],
                                                    stdout=subprocess.DEVNULL,
                                                    stderr=subprocess.DEVNULL)

                                        sel_run.param.watch(
                                            _open_gawm, 'value')
                                        area.append(sel_run)
                                elif rdata.get('summary_text'):
                                    area.append(pn.pane.HTML(
                                        f'<pre style="color:{_TEXT}; font-size:14px; '
                                        f'overflow-x:auto; background:{_SURFACE}; '
                                        f'padding:12px; border-radius:6px;">'
                                        f'{rdata["summary_text"]}</pre>',
                                        sizing_mode='stretch_width'))
                                else:
                                    area.append(pn.pane.HTML(
                                        f'<p style="color:{_SUBTEXT}; font-size:15px;">'
                                        f'No summary data.</p>'))
                    else:  # collapsed
                        toggle.name = 'Show Details'
                        area.visible = False

                btn_ref.on_click(_set_ref)
                btn_del.on_click(_delete_run)
                btn_toggle.param.watch(_toggle_detail, 'value')

                container.append(pn.pane.HTML(run_html,
                                              sizing_mode='stretch_width'))
                container.append(pn.Row(btn_toggle, btn_ref, btn_del))
                container.append(detail_area)

        # Track whether this tab has been populated
        _tab_loaded = [False]

        def _populate_tab(cached_runs=None, _runs_content=runs_content,
                          _analysis_content=analysis_content,
                          _tab_loaded=_tab_loaded, _bname=bname,
                          _binfo=binfo):
            if _tab_loaded[0]:
                return
            _tab_loaded[0] = True
            r = cached_runs if cached_runs is not None else discover_runs()
            _build_runs_list(cached_runs=r)
            _build_analysis(cached_runs=r)

        def _on_refresh(event, bn=bname, bi=binfo, cont=runs_content,
                        acont=analysis_content, _tab_loaded=_tab_loaded):
            _tab_loaded[0] = False  # force reload
            fresh = discover_runs()
            _build_runs_list(bn, cont, bi, acont, cached_runs=fresh)
            _build_analysis(bn, bi, acont, cached_runs=fresh)
            _tab_loaded[0] = True

        btn_refresh.on_click(_on_refresh)

        block_panel = pn.Column(
            pn.pane.HTML(info_html, sizing_mode='stretch_width'),
            pn.Row(btn_open_sch, btn_refresh),
            pn.pane.HTML(f'<h3 style="color:{_MAUVE}; margin:20px 0 10px; '
                         f'font-size:20px;">Analysis</h3>',
                         sizing_mode='stretch_width'),
            analysis_content,
            pn.pane.HTML(f'<h3 style="color:{_MAUVE}; margin:20px 0 10px; '
                         f'font-size:20px;">Runs</h3>',
                         sizing_mode='stretch_width'),
            runs_content,
            sizing_mode='stretch_width',
        )
        block_tabs.append((bname, block_panel, _populate_tab))

    # ── Overview tab ───────────────────────────────────────────────
    overview_rows = ''
    for bname, binfo in blocks.items():
        ref_tag = refs.get(bname, '')
        ref_str = (_badge(ref_tag, _GREEN) if ref_tag
                   else f'<span style="color:{_SUBTEXT};">none</span>')
        n_params = len(binfo['parameters'])
        block_runs = [r for r in runs.values()
                      if r['block_name'] == bname
                      or any(r['param_name'] == p
                             for p in binfo['parameters'])]
        n_runs = len(block_runs)
        latest = (sorted(block_runs, key=lambda r: r['tag'],
                         reverse=True)[0]['tag']
                  if block_runs else '—')
        statuses = [r['status'] for r in block_runs]
        if any(s == 'fail' for s in statuses):
            overall = _status_badge('fail')
        elif all(s == 'pass' for s in statuses) and statuses:
            overall = _status_badge('pass')
        else:
            overall = _status_badge('unknown')

        overview_rows += f'''
        <tr style="border-bottom:1px solid {_SURFACE};">
            <td style="padding:10px; color:{_ACCENT}; font-weight:bold;
                       font-size:16px;">{bname}</td>
            <td style="padding:10px; color:{_TEXT}; font-size:14px;">
                {binfo["description"][:80]}</td>
            <td style="padding:10px; text-align:center; color:{_TEXT};
                       font-size:15px;">{n_params}</td>
            <td style="padding:10px; text-align:center; color:{_TEXT};
                       font-size:15px;">{n_runs}</td>
            <td style="padding:10px; text-align:center;">{overall}</td>
            <td style="padding:10px; font-size:14px; color:{_TEXT};">{latest}</td>
            <td style="padding:10px;">{ref_str}</td>
        </tr>'''

    overview_html = f'''
    <table style="width:100%; border-collapse:collapse; margin-top:10px;">
        <tr style="border-bottom:2px solid {_OVERLAY};">
            <th style="padding:10px; text-align:left; color:{_ACCENT};
                       font-size:16px;">Block</th>
            <th style="padding:10px; text-align:left; color:{_ACCENT};
                       font-size:16px;">Description</th>
            <th style="padding:10px; text-align:center; color:{_ACCENT};
                       font-size:16px;">Params</th>
            <th style="padding:10px; text-align:center; color:{_ACCENT};
                       font-size:16px;">Runs</th>
            <th style="padding:10px; text-align:center; color:{_ACCENT};
                       font-size:16px;">Status</th>
            <th style="padding:10px; text-align:left; color:{_ACCENT};
                       font-size:16px;">Latest</th>
            <th style="padding:10px; text-align:left; color:{_ACCENT};
                       font-size:16px;">Reference</th>
        </tr>
        {overview_rows}
    </table>'''

    overview_panel = pn.Column(
        pn.pane.HTML(overview_html, sizing_mode='stretch_width'),
        sizing_mode='stretch_width')

    # Separate tab panels and their lazy loaders
    tab_panels = [(name, panel) for name, panel, _ in block_tabs]
    tab_loaders = [loader for _, _, loader in block_tabs]

    tabs = pn.Tabs(
        ('Overview', overview_panel),
        *tab_panels,
        sizing_mode='stretch_width',
    )

    # Lazy tab activation: populate content on first click
    def _on_tab_change(event, _loaders=tab_loaders, _runs=runs):
        idx = event.new
        if idx > 0:  # skip Overview (index 0)
            loader_idx = idx - 1
            if loader_idx < len(_loaders):
                _loaders[loader_idx](cached_runs=_runs)

    tabs.param.watch(_on_tab_change, 'active')

    scroll_top = pn.pane.HTML(
        '<script>window.scrollTo(0, 0);</script>', height=0, width=0)

    return pn.Column(
        scroll_top,
        pn.pane.HTML(header_html, sizing_mode='stretch_width'),
        tabs,
        sizing_mode='stretch_width',
        margin=(10, 24),
    )


# ── Serve ──────────────────────────────────────────────────────────
create_dashboard().servable(title='CACE Dashboard')

if __name__ == '__main__':
    pn.serve(
        {'/': create_dashboard},
        port=5009,
        show=False,
        title='CACE Dashboard',
    )
