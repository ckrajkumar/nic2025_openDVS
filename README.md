# openDVS
Telluride Neuromorphic Workshop project to design open-source DVS camera at the NIC group (2025-present)

Commit access to project members ONLY. Please upload your VERIFIED FINAL designs ONLY.

## Repository organization  
* [analog](./analog) for analog files  
    * [xschem](./analog/xschem) for `xschem` schematic files  
    * [magic](./analog/magic) for `magic` layout files

Files to be uploaded (Tentative; keep checking for updates)

1. Analog Design: Xschem (.sch) files including Ngspice/Xyce simulation setup with output data (.raw) files

2. Digital Design: ACT (.act, .src) files including Xyce setup with output netlist (.prn) or waveform (.vcd) files 

## Architecture details  
1. 128x128 array as 4 tiles of 64x64 pixels (that can be tiled for scaling up resolution)  
    1. pixel size = 12um x 12um
    2.  Nwell-psub photodiode  
2. Modified DVS pixel with Source Follower and MIM Caps for preamplification  
3. Column Sense Amplifier with precharge and Comparator are optimized for better performance (settling time, power etc)
4. Two top tiles will use synchronous interface logic
5. Two bottom tiles will use Asynchronous interface logic that takes the EVENT bit (comparator output) to generate ROW_SEL (for row wise select), DETECT (for comparator), RESET (for column wise pixel reset).  
7. Four 1x64 row vectors to be readout parallelly for each ROW_SEL. Alternate sparse readout mode available to read column indices of pixels with events (pixels with no events are ignored). Readout mode can be dynamically set by the user based on activity in the scene.
8. Vectors will be stored in internal FIFO buffer (upto 16 frames) before send out through Quad-SPI

## Target Specs 
Supply: 1.8V 
Latency: 64µs to 200µs (64 rows x 1-3µs per row), depends on analog settling time  
Power: 30µW (200nA*1.8V static + dynamic = 400nW per column X 64), depends on analog settling time  
Contrast Sensitivity: 10-15% 
Dynamic Range: ~100dB (100fA – 10nA photocurrent) needs special care of photodetector design  

(OLD pixel: i.e. detect VPH changes of 4-6mV assuming 9:1 cap ratio in DDS stage, VREF needs to swing 10x i.e. 40-60mV) 

