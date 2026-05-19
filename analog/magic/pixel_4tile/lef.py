import math

# ========================================================================
# 1. MACRO DIMENSIONS & CORE PARAMETERS
# ========================================================================
macro_name = "Imager_Top_no_m5"
filename = f"{macro_name}.lef"
pixel_array_size = 1536.0     # The central active area (128 pixels * 12um)
periphery_y = 25.0            # Top/Bottom margins for column periphery
macro_width = 1536.0 + 10     # added space for power rails on edge
macro_height = pixel_array_size + (2 * periphery_y) + 10 # Total: 1586.0 + 10.0, power rails

# pin_width   = 0.6
pin_width   = 0.3
pin_length  = 25.0

# ========================================================================
# 2. SPACING RULES (12um PIXEL PITCH)
# ========================================================================
pixel_pitch = 12.0
offset_1 = 3.0  # 3um inside the pixel boundary
offset_2 = 9.0  # 3um from the other pixel boundary

# Right Edge (DACs)
intra_dac_spacing = 4.0  # Spacing between bits [0:10] inside a single DAC bus
# Auto-calculate inter-spacing to evenly distribute the 10 DACs in the 1536um active area
total_dac_height = (10 * (11 * intra_dac_spacing)) 
inter_dac_spacing = (pixel_array_size - total_dac_height) / 10.0 

# ========================================================================
# 3. ROUTING TRACK SNAPPING ENGINE
# ========================================================================
# Snaps the ideal coordinates to the nearest valid SKY130 routing track.

# met4 is Vertical (Tracks run North/South, so they are spaced along the X-axis)
TRACK_X_PITCH, TRACK_X_OFFSET = 0.92, 0.46 

# met3 is Horizontal (Tracks run East/West, so they are spaced along the Y-axis)
TRACK_Y_PITCH, TRACK_Y_OFFSET = 0.68, 0.34 

def snap_x(val):
    n = round((val - TRACK_X_OFFSET) / TRACK_X_PITCH)
    return (n * TRACK_X_PITCH) + TRACK_X_OFFSET

def snap_y(val):
    n = round((val - TRACK_Y_OFFSET) / TRACK_Y_PITCH)
    return (n * TRACK_Y_PITCH) + TRACK_Y_OFFSET

def write_pin(f, pin_name, edge, ideal_pos, direction, layer):
    """Generates the physical rectangle for a pin snapped to the manufacturing grid."""
    if edge in ["left", "right"]:
        # Left/Right pins use met3 (horizontal approach). Must snap to Y grid.
        center = snap_y(ideal_pos)
        y1, y2 = center - (pin_width / 2), center + (pin_width / 2)
        x1, x2 = (0.0, pin_length) if edge == "left" else (macro_width - pin_length, macro_width)
    else: 
        # Top/Bottom pins use met4 (vertical approach). Must snap to X grid.
        center = snap_x(ideal_pos)
        x1, x2 = center - (pin_width / 2), center + (pin_width / 2)
        y1, y2 = (0.0, pin_length) if edge == "bottom" else (macro_height - pin_length, macro_height)
        
    f.write(f"\tPIN {pin_name}\n\t\tDIRECTION {direction} ;\n\t\tUSE SIGNAL ;\n\t\tPORT\n")
    f.write(f"\t\t\tLAYER {layer} ;\n\t\t\t\tRECT {x1:.3f} {y1:.3f} {x2:.3f} {y2:.3f} ;\n")
    f.write(f"\t\tEND\n\tEND {pin_name}\n")

# ========================================================================
# 4. LEF GENERATION
# ========================================================================
with open(filename, "w") as f:
    f.write(f"VERSION 5.8 ;\nBUSBITCHARS \"[]\" ;\nDIVIDERCHAR \"/\" ;\n\n")
    f.write(f"MACRO {macro_name}\n\tCLASS BLOCK ;\n\tORIGIN 0 0 ;\n")
    f.write(f"\tSIZE {macro_width:.3f} BY {macro_height:.3f} ;\n\tSYMMETRY X Y ;\n\n")

    # ---------------------------------------------------------
    # LEFT EDGE (WEST) - Rows at 3um and 9um within each pixel
    # ---------------------------------------------------------
    for i in range(128):
        # Pixel boundary starts after the 25um bottom periphery
        pixel_base_y = periphery_y + (i * pixel_pitch) 
        
        # 0-63 is Bottom, 64-127 is Top (with reversed indexing to match previous routing)
        suffix = "bot" if i < 64 else "top"
        idx = (63 - i) if i < 64 else (127 - i)
            
        write_pin(f, f"row_on_detect_{suffix}[{idx}]", "left", pixel_base_y + offset_1, "INPUT", "met3")
        write_pin(f, f"row_off_detect_{suffix}[{idx}]", "left", pixel_base_y + offset_2, "INPUT", "met3")

    # ---------------------------------------------------------
    # TOP & BOTTOM EDGES (NORTH/SOUTH) - Columns at 3um and 9um
    # ---------------------------------------------------------
    for i in range(128):
        pixel_base_x = i * pixel_pitch # X-axis has no periphery buffers
        
        # 0-63 is Left, 64-127 is Right
        suffix = "left" if i < 64 else "right"
        idx = i if i < 64 else (i - 64)
            
        # Bottom Edge (Y=0)
        write_pin(f, f"array_col_bot_{suffix}[{idx}]", "bottom", pixel_base_x + offset_1, "OUTPUT", "met4")
        write_pin(f, f"col_event_rst_bot_{suffix}[{idx}]", "bottom", pixel_base_x + offset_2, "INPUT", "met4")
        
        # Top Edge (Y=1586)
        write_pin(f, f"array_col_top_{suffix}[{idx}]", "top", pixel_base_x + offset_1, "OUTPUT", "met4")
        write_pin(f, f"col_event_rst_top_{suffix}[{idx}]", "top", pixel_base_x + offset_2, "INPUT", "met4")

    # ---------------------------------------------------------
    # RIGHT EDGE (EAST) - Modular DAC Configs
    # ---------------------------------------------------------
    # Starts at Y=25, leaving the bottom 25um zone empty
    current_y = periphery_y + (inter_dac_spacing / 2.0)
    for d in range(10): 
        for bit in range(11):
            write_pin(f, f"dac_config_{d}[{bit}]", "right", current_y, "INPUT", "met3")
            current_y += intra_dac_spacing
        current_y += inter_dac_spacing # Add the large gap before the next DAC bus starts

    # ---------------------------------------------------------
    # CORNER GLOBAL PINS (Safely within the 25um Peripheries)
    # ---------------------------------------------------------
    globals_list = ["pre_charge_global", "detect_pulse_global", "pix_rst_global"]
    
    # Y-offsets squeezed into the vertical center of the 25um zone.
    # Bottom zone center is ~12.5. Pins at 9.5, 12.5, 15.5.
    # This gives >5um clearance from the bottom vertical pins and the active array.
    bot_y_offsets = [9.5, 12.5, 15.5]
    
    # Top zone center is ~1573.5. Pins at 1570.5, 1573.5, 1576.5.
    top_y_offsets = [(macro_height - periphery_y) + 9.5, 
                     (macro_height - periphery_y) + 12.5, 
                     (macro_height - periphery_y) + 15.5]

    for i, sig in enumerate(globals_list):
        # LEFT SIDE (West)
        write_pin(f, f"{sig}_bot_left", "left", bot_y_offsets[i], "INPUT", "met3")
        write_pin(f, f"{sig}_top_left", "left", top_y_offsets[i], "INPUT", "met3")
        
        # RIGHT SIDE (East)
        write_pin(f, f"{sig}_bot_right", "right", bot_y_offsets[i], "INPUT", "met3")
        write_pin(f, f"{sig}_top_right", "right", top_y_offsets[i], "INPUT", "met3")

    # ---------------------------------------------------------
    # FULL POWER RINGS (vdda1 & vssa1)
    # ---------------------------------------------------------
    f.write("\n\tPIN vdda1\n\t\tDIRECTION INOUT ;\n\t\tUSE POWER ;\n\t\tPORT\n")
    f.write(f"\t\t\tLAYER met4 ;\n")
    # Left Vertical
    f.write(f"\t\t\t\tRECT 11.525 0.000 12.945 {macro_height:.3f} ;\n")
    
    # === NEW RIGHT VERTICAL VDDA1 ===
    # Safely past the 1536um array boundary
    f.write(f"\t\t\t\tRECT 1537.525 0.000 1538.945 {macro_height:.3f} ;\n")
    
    f.write("\t\tEND\n\tEND vdda1\n")

    f.write("\n\tPIN vssa1\n\t\tDIRECTION INOUT ;\n\t\tUSE GROUND ;\n\t\tPORT\n")
    f.write(f"\t\t\tLAYER met4 ;\n")
    # Left Vertical
    f.write(f"\t\t\t\tRECT 5.400 0.000 6.820 {macro_height:.3f} ;\n")
    
    # === NEW RIGHT VERTICAL VSSA1 ===
    f.write(f"\t\t\t\tRECT 1541.400 0.000 1542.820 {macro_height:.3f} ;\n")
    
    f.write("\t\tEND\n\tEND vssa1\n")

    # ---------------------------------------------------------
    # ACTIVE AREA OBSTRUCTION (OBS)
    # ---------------------------------------------------------
    f.write(f"\n\tOBS\n")
    
    # 1. Full Blockage for Placement & Base Layers 
    # (Keeps standard cells and local routing completely OUT of the macro)
    for layer in ["li1", "met1", "met2"]:
        f.write(f"\t\tLAYER {layer} ;\n")
        f.write(f"\t\t\tRECT 0.000 0.000 {macro_width:.3f} {macro_height:.3f} ;\n")

    # 2. Margin Blockage for Upper Routing Layers
    # (Protects the inner area from the router, leaving exactly a 30um margin)
    obs_margin = 30.0 
    for layer in ["met3", "met4", "met5"]:
        f.write(f"\t\tLAYER {layer} ;\n")
        f.write(f"\t\t\tRECT {obs_margin:.3f} {obs_margin:.3f} {macro_width-obs_margin:.3f} {macro_height-obs_margin:.3f} ;\n")
        
    f.write(f"\tEND\n")

    f.write(f"END {macro_name}\n\nEND LIBRARY\n")

print(f"Successfully generated {filename} with mirrored power rings!")

'''
# TODO: call these commands to go from LEF --> GDS in Magic

# 0. Open Magic in edit mode initialize the X11 display, and point to the PDK tech file

magic -T $PDK_ROOT/sky130A/libs.tech/magic/sky130A.tech -dXR 

# 1. Disable the safety lock that prevents overwriting foundry files

gds readonly false

# 2. Read your newly generated, grid-snapped LEF
lef read Imager_Top_no_m5.lef

# 3. Load the macro cell into the active window
load Imager_Top_no_m5

# 4. Strip the hidden "abstract view" safety tag
property LEFview ""

# 5. Export the physical GDS geometry
gds write Imager_Top_no_m5.gds
'''