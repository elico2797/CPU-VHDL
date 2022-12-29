List of modules + description:
-----------------------------------------------
MIPS.vhd - Mips core top, contain the pipeline Register and Debug Register, and connect between the modules to the Registers.
IFetch.vhd - contain the Instruction Memory and the PC Register, and execute the Fetch phase of the pipeline.
IDecode.vhd - contain the Hazard and ID_Forwarding Units, The Register file and The Branch Control unit (Decide If a branch command is taken or not).
Control.vhd - Receive the instruction from IF/ID Register and move Control signal To the Relevant Units through the pipeline Registers.
Execute.vhd - The calculation phase, contain ALU unit and Forwarding Unit.
Memory.vhd - Contain the DATA Memory for load/store data.
WriteBack.vhd - the phase that Write back the relevant Data to the register file.
aux_package_comd.vhd - package that contains all the different components + constants
-----------------------------------------------
* for more explanation see pdf file
