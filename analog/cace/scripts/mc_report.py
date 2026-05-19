#!/usr/bin/env python3
"""
General-purpose Monte Carlo report generator for CACE simulation results.

Usage:
    python3 mc_report.py <yaml_file> <parameter_name> [run_tag]

Generates:
  - Histograms with 1σ–4σ markers for each measurement
  - Q-Q plots for each measurement
  - Summary table with mean ± 3σ
  - Saves all plots and table to the run directory
"""

import sys
import os
import glob
import yaml
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from scipy import stats

# SI unit prefixes for display
_UNIT_SI_FACTOR = {
    'fA': 1e-15, 'pA': 1e-12, 'nA': 1e-9, 'uA': 1e-6, 'mA': 1e-3,
    'fV': 1e-15, 'mV': 1e-3, 'V': 1, 'kV': 1e3,
    'fs': 1e-15, 'ps': 1e-12, 'ns': 1e-9, 'us': 1e-6, 'ms': 1e-3, 's': 1,
    'Hz': 1, 'kHz': 1e3, 'MHz': 1e6, 'GHz': 1e9,
    'pF': 1e-12, 'fF': 1e-15,
}


def load_yaml(yaml_path):
    with open(yaml_path, 'r') as f:
        return yaml.safe_load(f)


def find_latest_run(runs_dir, param_name):
    """Find the latest run directory that contains the given parameter."""
    run_dirs = sorted(glob.glob(os.path.join(runs_dir, 'RUN_*')))
    for rd in reversed(run_dirs):
        param_dir = os.path.join(rd, 'parameters', param_name)
        if os.path.isdir(param_dir):
            return rd
    return None


def collect_data(param_dir, variables):
    """Read all .data files and return a dict of arrays."""
    data = {v: [] for v in variables}

    # Find all .data files recursively
    data_files = sorted(glob.glob(os.path.join(param_dir, '**', '*.data'), recursive=True))

    for df in data_files:
        with open(df, 'r') as f:
            vals = f.read().strip().split()
        if len(vals) != len(variables):
            continue
        for i, v in enumerate(variables):
            try:
                data[v].append(float(vals[i]))
            except ValueError:
                pass

    for v in variables:
        data[v] = np.array(data[v])

    return data


def plot_histogram(values, name, unit, spec, outpath):
    """Plot histogram with σ markers."""
    fig, ax = plt.subplots(figsize=(8, 5))

    mu = np.mean(values)
    sigma = np.std(values)

    # Convert to display units
    factor = _UNIT_SI_FACTOR.get(unit, 1)
    disp_vals = values / factor if factor else values
    disp_mu = mu / factor if factor else mu
    disp_sigma = sigma / factor if factor else sigma

    # Histogram
    n_bins = min(50, max(15, len(disp_vals) // 10))
    ax.hist(disp_vals, bins=n_bins, color='#4C72B0', edgecolor='white',
            alpha=0.85, density=True, zorder=2)

    # Overlay normal PDF
    x_range = np.linspace(disp_vals.min() - disp_sigma, disp_vals.max() + disp_sigma, 200)
    if disp_sigma > 0:
        pdf = stats.norm.pdf(x_range, disp_mu, disp_sigma)
        ax.plot(x_range, pdf, 'k-', linewidth=1.5, alpha=0.7, zorder=3)

    # σ markers
    colors = ['#2ca02c', '#ff7f0e', '#d62728', '#9467bd']
    labels = ['1σ', '2σ', '3σ', '4σ']
    for i, (c, lbl) in enumerate(zip(colors, labels)):
        n = i + 1
        lo = disp_mu - n * disp_sigma
        hi = disp_mu + n * disp_sigma
        ax.axvline(lo, color=c, linestyle='--', linewidth=1.2, alpha=0.8, zorder=4)
        ax.axvline(hi, color=c, linestyle='--', linewidth=1.2, alpha=0.8,
                   label=f'±{lbl} ({lo:.4g}, {hi:.4g})', zorder=4)

    # Mean line
    ax.axvline(disp_mu, color='red', linestyle='-', linewidth=2, alpha=0.9,
               label=f'μ = {disp_mu:.4g}', zorder=5)

    # Spec limits
    if spec:
        if 'minimum' in spec and spec['minimum'].get('value') not in (None, 'any'):
            spec_min = float(spec['minimum']['value'])
            ax.axvline(spec_min, color='black', linestyle='-', linewidth=2.5,
                       label=f'Spec min = {spec_min}', zorder=5)
        if 'maximum' in spec and spec['maximum'].get('value') not in (None, 'any'):
            spec_max = float(spec['maximum']['value'])
            ax.axvline(spec_max, color='black', linestyle='-', linewidth=2.5,
                       label=f'Spec max = {spec_max}', zorder=5)

    unit_str = f' [{unit}]' if unit else ''
    ax.set_xlabel(f'{name}{unit_str}', fontsize=12)
    ax.set_ylabel('Density', fontsize=12)
    ax.set_title(f'{name} — N={len(values)}, μ={disp_mu:.4g}, σ={disp_sigma:.4g}{unit_str}',
                 fontsize=13)
    ax.legend(fontsize=9, loc='upper right')
    ax.grid(True, alpha=0.3, zorder=1)

    fig.tight_layout()
    fig.savefig(outpath, dpi=150)
    plt.close(fig)


def plot_qq(values, name, unit, outpath):
    """Q-Q plot against normal distribution."""
    fig, ax = plt.subplots(figsize=(6, 6))

    factor = _UNIT_SI_FACTOR.get(unit, 1)
    disp_vals = values / factor if factor else values

    (osm, osr), (slope, intercept, r) = stats.probplot(disp_vals, dist='norm')
    ax.plot(osm, osr, 'o', markersize=3, color='#4C72B0', alpha=0.6)

    # Reference line
    x_line = np.array([osm.min(), osm.max()])
    ax.plot(x_line, slope * x_line + intercept, 'r-', linewidth=1.5,
            label=f'R² = {r**2:.4f}')

    unit_str = f' [{unit}]' if unit else ''
    ax.set_xlabel('Theoretical Quantiles (σ)', fontsize=12)
    ax.set_ylabel(f'Sample Quantiles{unit_str}', fontsize=12)
    ax.set_title(f'Q-Q Plot: {name}', fontsize=13)
    ax.legend(fontsize=10)
    ax.grid(True, alpha=0.3)

    fig.tight_layout()
    fig.savefig(outpath, dpi=150)
    plt.close(fig)


def generate_report(yaml_path, param_name, run_tag=None):
    ds = load_yaml(yaml_path)

    # Resolve paths
    yaml_dir = os.path.dirname(os.path.abspath(yaml_path))
    root = os.path.normpath(os.path.join(yaml_dir, ds['paths'].get('root', '.')))
    runs_dir = os.path.join(root, ds['paths'].get('runs', 'runs'))

    # Find parameter config
    if param_name not in ds['parameters']:
        print(f"Error: parameter '{param_name}' not found in {yaml_path}")
        sys.exit(1)

    param = ds['parameters'][param_name]
    tool_cfg = param['tool']['ngspice']
    variables = tool_cfg['variables']
    specs = param.get('spec', {})

    # Find run directory
    if run_tag:
        run_dir = os.path.join(runs_dir, run_tag)
    else:
        run_dir = find_latest_run(runs_dir, param_name)

    if not run_dir or not os.path.isdir(run_dir):
        print(f"Error: no run directory found for {param_name}")
        sys.exit(1)

    param_dir = os.path.join(run_dir, 'parameters', param_name)
    print(f"Reading data from: {param_dir}")

    # Collect data
    data = collect_data(param_dir, variables)
    n_samples = len(next(iter(data.values())))
    print(f"Collected {n_samples} samples")

    # Output directory
    report_dir = os.path.join(param_dir, 'mc_report')
    os.makedirs(report_dir, exist_ok=True)

    # Generate plots and build summary table
    table_rows = []

    for var in variables:
        vals = data[var]
        if len(vals) == 0:
            continue

        spec = specs.get(var, {})
        unit = spec.get('unit', '')
        display = spec.get('display', var)

        mu = np.mean(vals)
        sigma = np.std(vals)
        factor = _UNIT_SI_FACTOR.get(unit, 1)

        # Convert for display
        d_mu = mu / factor if factor else mu
        d_sigma = sigma / factor if factor else sigma
        d_min = np.min(vals) / factor if factor else np.min(vals)
        d_max = np.max(vals) / factor if factor else np.max(vals)

        table_rows.append({
            'name': display,
            'unit': unit,
            'mean': d_mu,
            'sigma': d_sigma,
            'min': d_min,
            'max': d_max,
            'minus_3s': d_mu - 3 * d_sigma,
            'plus_3s': d_mu + 3 * d_sigma,
        })

        # Histogram
        hist_path = os.path.join(report_dir, f'hist_{var}.png')
        plot_histogram(vals, display, unit, spec, hist_path)

        # Q-Q plot
        qq_path = os.path.join(report_dir, f'qq_{var}.png')
        plot_qq(vals, display, unit, qq_path)

        print(f"  {display}: μ={d_mu:.4g} σ={d_sigma:.4g} [{unit}]")

    # Write summary table as markdown
    table_path = os.path.join(report_dir, 'mc_summary.md')
    with open(table_path, 'w') as f:
        f.write(f'# Monte Carlo Summary — {param.get("display", param_name)}\n\n')
        f.write(f'N = {n_samples} samples\n\n')
        f.write('| Parameter | Unit | Mean | σ | Min | Max | μ - 3σ | μ + 3σ |\n')
        f.write('|---|---|---|---|---|---|---|---|\n')
        for row in table_rows:
            f.write('| {} | {} | {:.4g} | {:.4g} | {:.4g} | {:.4g} | {:.4g} | {:.4g} |\n'.format(
                row['name'], row['unit'], row['mean'], row['sigma'],
                row['min'], row['max'], row['minus_3s'], row['plus_3s']))

    # Also write as CSV
    csv_path = os.path.join(report_dir, 'mc_summary.csv')
    with open(csv_path, 'w') as f:
        f.write('parameter,unit,mean,sigma,min,max,mu_minus_3sigma,mu_plus_3sigma\n')
        for row in table_rows:
            f.write('{},{},{},{},{},{},{},{}\n'.format(
                row['name'], row['unit'], row['mean'], row['sigma'],
                row['min'], row['max'], row['minus_3s'], row['plus_3s']))

    # Generate combined figure with all histograms
    n_vars = len(variables)
    n_cols = 3
    n_rows = (n_vars + n_cols - 1) // n_cols
    fig, axes = plt.subplots(n_rows, n_cols, figsize=(6 * n_cols, 4.5 * n_rows))
    axes = np.atleast_2d(axes)

    for idx, var in enumerate(variables):
        row, col = divmod(idx, n_cols)
        ax = axes[row, col]

        vals = data[var]
        spec = specs.get(var, {})
        unit = spec.get('unit', '')
        display = spec.get('display', var)

        factor = _UNIT_SI_FACTOR.get(unit, 1)
        dv = vals / factor if factor else vals
        mu = np.mean(dv)
        sigma = np.std(dv)

        n_bins = min(40, max(12, len(dv) // 12))
        ax.hist(dv, bins=n_bins, color='#4C72B0', edgecolor='white', alpha=0.85, density=True)

        if sigma > 0:
            x_r = np.linspace(dv.min() - sigma, dv.max() + sigma, 200)
            ax.plot(x_r, stats.norm.pdf(x_r, mu, sigma), 'k-', linewidth=1, alpha=0.6)

        colors = ['#2ca02c', '#ff7f0e', '#d62728', '#9467bd']
        for i, c in enumerate(colors):
            n = i + 1
            ax.axvline(mu - n * sigma, color=c, linestyle='--', linewidth=0.8, alpha=0.7)
            ax.axvline(mu + n * sigma, color=c, linestyle='--', linewidth=0.8, alpha=0.7)

        ax.axvline(mu, color='red', linestyle='-', linewidth=1.5, alpha=0.8)

        unit_str = f' [{unit}]' if unit else ''
        ax.set_title(f'{display}\nμ={mu:.4g} σ={sigma:.4g}{unit_str}', fontsize=10)
        ax.grid(True, alpha=0.2)

    # Hide unused axes
    for idx in range(n_vars, n_rows * n_cols):
        row, col = divmod(idx, n_cols)
        axes[row, col].set_visible(False)

    fig.suptitle(f'Monte Carlo Histograms — N={n_samples}', fontsize=14, y=1.01)
    fig.tight_layout()
    fig.savefig(os.path.join(report_dir, 'all_histograms.png'), dpi=150, bbox_inches='tight')
    plt.close(fig)

    # Combined Q-Q plots
    fig, axes = plt.subplots(n_rows, n_cols, figsize=(5 * n_cols, 5 * n_rows))
    axes = np.atleast_2d(axes)

    for idx, var in enumerate(variables):
        row, col = divmod(idx, n_cols)
        ax = axes[row, col]

        vals = data[var]
        spec = specs.get(var, {})
        unit = spec.get('unit', '')
        display = spec.get('display', var)

        factor = _UNIT_SI_FACTOR.get(unit, 1)
        dv = vals / factor if factor else vals

        (osm, osr), (slope, intercept, r) = stats.probplot(dv, dist='norm')
        ax.plot(osm, osr, 'o', markersize=2, color='#4C72B0', alpha=0.5)
        x_line = np.array([osm.min(), osm.max()])
        ax.plot(x_line, slope * x_line + intercept, 'r-', linewidth=1.2)

        unit_str = f' [{unit}]' if unit else ''
        ax.set_title(f'{display} (R²={r**2:.4f})', fontsize=10)
        ax.set_xlabel('Theoretical Quantiles')
        ax.set_ylabel(f'Sample{unit_str}')
        ax.grid(True, alpha=0.2)

    for idx in range(n_vars, n_rows * n_cols):
        row, col = divmod(idx, n_cols)
        axes[row, col].set_visible(False)

    fig.suptitle(f'Q-Q Plots — N={n_samples}', fontsize=14, y=1.01)
    fig.tight_layout()
    fig.savefig(os.path.join(report_dir, 'all_qq_plots.png'), dpi=150, bbox_inches='tight')
    plt.close(fig)

    print(f"\nReport saved to: {report_dir}")
    print(f"  - Individual histograms: hist_<var>.png")
    print(f"  - Individual Q-Q plots: qq_<var>.png")
    print(f"  - Combined histograms: all_histograms.png")
    print(f"  - Combined Q-Q plots: all_qq_plots.png")
    print(f"  - Summary table: mc_summary.md / mc_summary.csv")


if __name__ == '__main__':
    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} <yaml_file> <parameter_name> [run_tag]")
        sys.exit(1)

    yaml_file = sys.argv[1]
    param = sys.argv[2]
    run_tag = sys.argv[3] if len(sys.argv) > 3 else None

    generate_report(yaml_file, param, run_tag)
