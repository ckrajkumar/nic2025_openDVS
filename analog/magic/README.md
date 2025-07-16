# OpenDVS layout  

## Files
* [extfiles](./extfiles/) directory for extraction files  
* [pixel.mag](./pixel.mag) test file for pixel layout  
* [pixel.spice](./pixel.spice) extracted SPICE netlist from [pixel.mag](./pixel.mag)  
* [pixeltransistors.mag](./pixeltransistors.mag) transistors used in pixel  
    * [nmos_triplet.mag](./nmos_tiplet.mag) array of 3 transistors of the same size  
    * [select_nmos.mag](./select_nmos.mag) array of 2 transistors of the same size  
* [mimcaps.mag](./mimcaps.mag) 1:8 scaled MIMCAP pair, for size estimate  
* [mimcaps.spice](./mimcaps.spice) SPICE netlist extracted from [mimcaps](./mimcaps.mag) layout  
* [wires.mag](./wires.mag) interconnect wires for pixel

## Notes    
  
### Pixel layout  
The design of the pixel is layout driven  

* by available space for a pixel  
* by the row and column wires connecting the pixels  
* by making sure the photosensor is  
    * shielded by the sides  
    * not getting covered by fill metal  

### MIMCAP  
The [minimum MIMCAP feature size](https://skywater-pdk.readthedocs.io/en/main/rules/assumptions.html#minimum-critical-dimensions) of 2&mu;m without contacts prevents a matched MIMCAP array, but [two MIMCAPs with appropriate size ratio](./mimcaps.mag) will fit.  

### Wires  
The position, layer, width, and spacing of the wires connecting the pixel is an important design constraint that needs to be coordinated with the periphery of the pixel array.    
  
Tentatively, a first stab at [wires.mag](./wires.mag) uses minimum width and spacing metal1 and metal2 wires. This is probably **not** a good idea, but a first basis of discussion.  
  
### Transistors  
The [transistors used in the pixel](./pixeltransistors.mag) can be grouped 
into identical transistors with shared contacts  
