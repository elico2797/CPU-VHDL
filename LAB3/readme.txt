List of modules + description:
-----------------------------------------------
top.vhd - top module which combine all the components and puts them in one single "system"
TB.vhd - Test bench that generate clock and TB_active. sign when its time to read and write from the memory or from the datapath.
Datapath.vhd - This is the main functional file that connect between the FSM and between the logical component.  
Control.vhd (FSM) - this is the final state machine. take all the state and the possibole input and control bits and decide about the output and the next state.  
FA.vhd -  1 bit adder (with carry) - given by Hanan.
ALU - Model that make logical intsruction, Add or Sub by the compatible opcode.
IR - Instuction register - loaded from the memory, by the bit IRin. depend in the RFaddr for the register to be choosen. also, output the 4 M.S.B to the opc decoder.
PC - program counter - module that incharge for determine the next command to be used, by the flag PCin and correspond the PCsel mux. 
OPC_decoder - get the 4 M.S.B from the IR and turn on the control bits of the FSM. 
RF - Register file - module that work with the TB or with the Bus in the datapath correspond the status of the TBactive. also, read and write done from the RF. 
ProgMem - this is the main memory, that contain the program that we would like to execute. 
aux_package.vhd - package that contains all the different components + constants
-----------------------------------------------
* for more explanation see pdf file, pre3 and designGraph.
