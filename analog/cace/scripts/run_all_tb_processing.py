#!/usr/bin/env python3
"""
Script to run tb_biasBranchnMasterx1_op.py for each run folder.
This script processes all run_[RUN_NUMBER] folders and executes the processing script
for each one, handling leading zeros correctly.
"""

import os
import glob
import re
import subprocess
import sys

# Configuration
run_name = 'RUN_2025-10-29_20-16-25'
run_directory = '/home/rpgraca/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog/runs/' + run_name

def get_analog_path():
    """Get the ANALOG environment variable or use default path"""
    analog_path = os.environ.get('ANALOG')
    if not analog_path:
        # Default to the analog directory in the project
        analog_path = '/home/rpgraca/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog'
        print(f"ANALOG environment variable not set, using default: {analog_path}")
    return analog_path

def find_run_folders():
    """Find all run folders and return them sorted"""
    sweep_dir = os.path.join(run_directory, 'parameters', 'op_sweep_code')
    
    if not os.path.exists(sweep_dir):
        print(f"Error: Sweep directory not found: {sweep_dir}")
        return []
    
    run_folders = glob.glob(os.path.join(sweep_dir, 'run_*'))
    return sorted(run_folders)

def extract_run_number(run_folder):
    """Extract run number from folder name, handling leading zeros"""
    folder_name = os.path.basename(run_folder)
    run_match = re.match(r'run_(\d+)', folder_name)
    if not run_match:
        return None, None
    
    run_number_with_zeros = run_match.group(1)  # e.g., "0000", "0001"
    run_number = int(run_number_with_zeros)     # e.g., 0, 1
    
    return run_number_with_zeros, run_number

def run_processing_script(analog_path, run_folder, run_number):
    """Run the processing script for a specific run"""
    script_path = os.path.join(analog_path, 'cace', 'scripts', 'tb_BiasBranchnMasterx1_op.py')
    
    if not os.path.exists(script_path):
        print(f"Error: Processing script not found: {script_path}")
        return False
    
    # Build the command
    # python $ANALOG/cace/scripts/tb_biasBranchnMasterx1_op.py *right_folder*/run_[RUN_NUMBER] [RUN_NUMBER]
    cmd = [
        'python', 
        script_path,
        run_folder,
        'tb_BiasBranchnMasterx1_op',
        str(run_number)
    ]
    
    print(f"Running: {' '.join(cmd)}")
    
    try:
        # Run the command
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        print(f"✓ Successfully processed run {run_number}")
        if result.stdout:
            print(f"  Output: {result.stdout.strip()}")
        return True
        
    except subprocess.CalledProcessError as e:
        print(f"✗ Error processing run {run_number}:")
        print(f"  Exit code: {e.returncode}")
        if e.stdout:
            print(f"  Stdout: {e.stdout.strip()}")
        if e.stderr:
            print(f"  Stderr: {e.stderr.strip()}")
        return False
    
    except Exception as e:
        print(f"✗ Unexpected error processing run {run_number}: {e}")
        return False

def main():
    """Main execution function"""
    print("=== TB Processing Script Runner ===")
    print(f"Run directory: {run_directory}")
    
    # Get ANALOG path
    analog_path = get_analog_path()
    
    # Find all run folders
    run_folders = find_run_folders()
    
    if not run_folders:
        print("No run folders found!")
        sys.exit(1)
    
    print(f"Found {len(run_folders)} run folders")
    
    # Process each run folder
    successful_runs = 0
    failed_runs = 0
    
    for run_folder in run_folders:
        run_number_with_zeros, run_number = extract_run_number(run_folder)
        
        if run_number is None:
            print(f"Warning: Could not extract run number from {run_folder}")
            failed_runs += 1
            continue
        
        print(f"\n--- Processing run_{run_number_with_zeros} (run number: {run_number}) ---")
        
        success = run_processing_script(analog_path, run_folder, run_number)
        
        if success:
            successful_runs += 1
        else:
            failed_runs += 1
    
    # Summary
    print(f"\n=== Summary ===")
    print(f"Total runs processed: {len(run_folders)}")
    print(f"Successful: {successful_runs}")
    print(f"Failed: {failed_runs}")
    
    if failed_runs > 0:
        print(f"\nWarning: {failed_runs} runs failed to process")
        sys.exit(1)
    else:
        print("\nAll runs processed successfully!")

if __name__ == "__main__":
    main()
