# Fault-SPM

32-bit serial parallel multiplier with design-for-testbability (DFT) structures, namely, scan-chain and JTAG controller.  The DFT structures are automatically inserted using [Fault](https://github.com/Cloud-V/Fault) and the design is taped-out using [OpenLANE](https://github.com/efabless/openlane).

# I/O Ports


| I/Os     | Mode      |       Function           |
|----------|-----------|--------------------------|
| clk      | input     | clock pin                |
| rst      | input     | active high reset        |
| mc       | input     | 32-bit multiplicant      |
| mp       | input     | 32-bit multiplier        |
| prod     | output    | 64-bit product           |  
| tck*     | input     | test clock               |
| tms*     | input     | test mode select; used to navigate the TAP state machine |
| tdi*     | input     | test data-in; used to shift-in test vector through the scan-chain |
| trst*    | input     | test rese; used to reset the TAP state machine to the idle state | 
| tdo*     | output    | test data-out; used to scan out the response | 
| tdo_paden_o | output | test data-out enable; used to control the tdo pad |

*NOTE:
- The five test ports **(tck, tms, tdi, trst, tdo)** are only used during testing to scan-in a test vector and scan-out the response. 
- When not in the testing mode (i.e in the functional mode), **tck, tdi, and trst** must be pulled to zero and **tms** must be pulled to one.  

# DFT

