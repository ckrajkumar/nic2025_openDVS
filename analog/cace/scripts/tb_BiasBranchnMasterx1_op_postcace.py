import numpy as np
import pandas as pd
import sys
import os
import glob
import re
from spicelib import RawRead
from bokeh.plotting import figure, output_file, show, save
from bokeh.models import HoverTool, ColumnDataSource
from bokeh.palettes import Category10
from bokeh.layouts import layout,grid

run_names = []
#run_name = 'RUN_2025-10-29_20-16-25'
#run_name = 'RUN_2025-10-29_21-37-14'
run_names.append('RUN_2025-10-30_11-03-21') # SVT finediv
run_names.append('RUN_2025-10-30_11-15-53') # LVT  finediv
run_names.append('RUN_2025-10-30_12-32-17') # HVT finediv

measfile_name = 'tb_BiasBranchnMasterx1_op'
measnames_list=['coarse_code',
                'fine_code',
                'iout',
                'vdsat_masterbias_mnbias',
                'vdsat_masterbias_mnbiasdio',
                'vdsat_masterbias_mnbiascascdio',
                'vdsat_masterbias_mnbiascasc',
                'vdsat_masterbias_mpbias',
                'vdsat_masterbias_mpbiasdio',
                'vdsat_masterbias_mnmirr1',
                'vdsat_masterbias_mnmirr2',
                'vdsat_masterbias_mnmirrcasc2',
                'vdsat_masterbias_mnmirrcasc2',
                'vdsat_coarsebuf_mmirr',
                'vdsat_coarse2fine_mpdio',
                'vdsat_coarse2fine_mpmirr',
                'vdsat_buffs_mndio',
                'vdsat_buffs_mnmirr',
                'vdsat_buffs_mnmirrbuffbias',
                'vdsat_buffs_mnmirrbuff',
                'vdsat_buffs_mpdio',
                'vdsat_buffs_mpmirrbuffbias',
                'vdsat_buffs_mpmirrbuff',
                'vdsat_biasbuffer_mndio',
                'vdsat_biasbuffer_mnmirr',
                'vdsat_biasbuffer_mnpdio',
                'id_masterbias_mnbias',
                'id_masterbias_mnbiasdio',
                'id_masterbias_xmnmirr1',
                'id_masterbias_xmnmirr2',
                'id_mbdiv_cb0',
                'id_mbdiv_cb1',
                'id_mbdiv_cb2',
                'id_mbdiv_cb3',
                'id_mbdiv_cb4',
                'id_mbdiv_cb5',
                'id_mbdiv_cb6',
                'id_mbdiv_cb7',
                'id_coarsebuf_mmirr',
                'id_coarse2fine_mpdio',
                'id_coarse2fine_mpmirr',
                'id_coarse2fine_mpindio',
                'id_buffs_mndio',
                'id_buffs_mnmirr',
                'id_buffs_mnmirrbuffbias',
                'id_buffs_mnmirrbuff',
                'id_buffs_mpdio',
                'id_buffs_mpmirrbuffbias',
                'id_buffs_mpmirrbuff',
                'id_biasbuffer_mndio',
                'id_biasbuffer_mnmir']

def parse_run_folders(run_name):
    """Parse run folders and extract measurement data into a pandas DataFrame"""
    data_rows = []
    
    run_directory = '/home/rpgraca/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog/runs/' + run_name
    # Find all run folders in the sweep directory
    sweep_dir = os.path.join(run_directory, 'parameters', 'op_sweep_code')
    run_folders = glob.glob(os.path.join(sweep_dir, 'run_*'))
    
    for run_folder in sorted(run_folders):
        # Extract run number from folder name (with leading zeros)
        folder_name = os.path.basename(run_folder)
        run_match = re.match(r'run_(\d+)', folder_name)
        if not run_match:
            continue
            
        run_number_with_zeros = run_match.group(1)
        run_number = int(run_number_with_zeros)  # Remove leading zeros
        
        # Look for measurement file
        measfile_pattern = os.path.join(run_folder, f'{measfile_name}_{run_number}.data')
        
        if os.path.exists(measfile_pattern):
            try:
                # Read the data file
                with open(measfile_pattern, 'r') as f:
                    line = f.readline().strip()
                    values = [float(x) for x in line.split()]
                
                # Create a row dictionary with the measurements
                if len(values) >= len(measnames_list):
                    row = {'run_number': run_number}
                    for i, name in enumerate(measnames_list):
                        row[name] = values[i]
                    data_rows.append(row)
                else:
                    print(f"Warning: Not enough values in {measfile_pattern}")
                    
            except Exception as e:
                print(f"Error reading {measfile_pattern}: {e}")
    
    # Create DataFrame
    df = pd.DataFrame(data_rows)
    return df

def plot_iout_vs_fine_code(df,run_name):
    """Create bokeh plot of iout vs fine_code, grouped by coarse_code"""
    
    # Create figure
    p_list = []
    hover_list = []
    
    # Get unique coarse codes
    unique_coarse = sorted(df['coarse_code'].unique())
    colors = Category10[max(3, min(10, len(unique_coarse)))]
    
    # Plot each coarse code group
    for i, coarse_val in enumerate(unique_coarse):
        p_list.append(figure(title=f"Iout vs Fine Code for Coarse Code {coarse_val} {run_name}",
                   x_axis_label="Fine Code", 
                   y_axis_label="Iout (A)",
                   width=400, height=400))
        subset = df[df['coarse_code'] == coarse_val]
        color = colors[i % len(colors)]
        
        # Sort by fine_code for proper line plotting
        subset = subset.sort_values('fine_code')
        
        source=ColumnDataSource(subset)
        # Add line and circle markers
        p_list[-1].line('fine_code', 'iout', 
                        #legend_label=f"Coarse Code {coarse_val}", 
                        line_color=color, line_width=2,
                        source=source)
        p_list[-1].circle('fine_code', 'iout', 
                          color=color, size=6, alpha=0.7,
                          source=source)
    
        # Add hover tool
        hover_list.append(HoverTool(tooltips=[
            ("Fine Code", "@fine_code"),
            ("Iout", "@iout"),
            ("Run", "@run_number")
           ]))
        p_list[-1].add_tools(hover_list[-1])
    
    # Customize legend
    #p_list[-1].legend.location = "top_left"
    #p_list[-1].legend.click_policy = "hide"
    
    # Save plot
    run_directory = '/home/rpgraca/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog/runs/' + run_name
    sweep_dir = os.path.join(run_directory, 'parameters', 'op_sweep_code')
    outfile_name = f"{sweep_dir}/iout_vs_fine_code.html"
    output_file(outfile_name)
    show(grid(p_list,ncols=4))
    print(f"Plot saved as {outfile_name}")

def plot_vdsat_vs_fine_code(df, vdsat_var,run_name):
    """Create bokeh plot of vdsat vs fine_code, with one plot per coarse_code"""
    
    # Create figure list
    p_list = []
    hover_list = []
    
    # Get unique coarse codes
    unique_coarse = sorted(df['coarse_code'].unique())
    colors = Category10[max(3, min(10, len(unique_coarse)))]
    
    # Plot each coarse code group
    for i, coarse_val in enumerate(unique_coarse):
        p_list.append(figure(title=f"{vdsat_var} vs Fine Code for Coarse Code {coarse_val} {run_name}",
                   x_axis_label="Fine Code", 
                   y_axis_label=f"{vdsat_var} (V)",
                   width=400, height=400))
        subset = df[df['coarse_code'] == coarse_val]
        color = colors[i % len(colors)]
        
        # Sort by fine_code for proper line plotting
        subset = subset.sort_values('fine_code')
        
        source = ColumnDataSource(subset)
        # Add line and circle markers
        p_list[-1].line('fine_code', vdsat_var, 
                        line_color=color, line_width=2,
                        source=source)
        p_list[-1].circle('fine_code', vdsat_var, 
                          color=color, size=6, alpha=0.7,
                          source=source)
    
        # Add hover tool
        hover_list.append(HoverTool(tooltips=[
            ("Fine Code", "@fine_code"),
            (f"{vdsat_var}", f"@{vdsat_var}"),
            ("Run", "@run_number")
           ]))
        p_list[-1].add_tools(hover_list[-1])
    
    # Save plot
    run_directory = '/home/rpgraca/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog/runs/' + run_name
    sweep_dir = os.path.join(run_directory, 'parameters', 'op_sweep_code')
    outfile_name = f"{sweep_dir}/{vdsat_var}_vs_fine_code.html"
    output_file(outfile_name)
    save(grid(p_list, ncols=4))
    print(f"Plot saved as {outfile_name}")

def plot_all_vdsat_variables(df,run_name):
    """Create plots for all vdsat variables"""
    vdsat_vars = [name for name in measnames_list if name.startswith('vdsat_')]
    
    for vdsat_var in vdsat_vars:
        print(f"Creating plot for {vdsat_var}")
        plot_vdsat_vs_fine_code(df, vdsat_var, run_name)

if __name__ == "__main__":
    # Parse data and create DataFrame
    for run_name in run_names:
        df = parse_run_folders(run_name)
        
        if not df.empty:
            print(f"{run_name}: Successfully loaded {len(df)} measurement points")
            print(f"{run_name}: Columns: {list(df.columns)}")
            print(f"{run_name}: Coarse codes: {sorted(df['coarse_code'].unique())}")
            print(f"{run_name}: Fine code range: {df['fine_code'].min()} to {df['fine_code'].max()}")
            
            # Save DataFrame to CSV for inspection
            #df.to_csv('measurement_data.csv', index=False)
            #print("Data saved to measurement_data.csv")
            
            # Create plots
            plot_iout_vs_fine_code(df,run_name)
            plot_all_vdsat_variables(df,run_name)
        else:
            print("No measurement data found")
