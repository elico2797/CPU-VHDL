List of modules + description:
-----------------------------------------------
top.vhd - top, test file that wrap up all the files in the project. in this section we define the I\O to the FPGA. we configures the portmaps to the FPGA 7-seg and we define the D-latches in the input.
ALUtop.vhd - top module which combine all the components and puts them in one single "system"
in this module we check the 2 M.S.B of the ALUFN and decide which submodule has to calculate the output.
Shifter.vhd - shifting an input number Y left/right correspond by the value of the K L.S.B bits  of X
AdderSubtractor - add/subtract between two inputs or make negative of input number.
Logical.vhd - logical operations between two inputs
FA.vhd -  1 bit adder (with carry) - given by Hanan.
aux_package_comd.vhd - package that contains all the different components + constants
-----------------------------------------------
* for more explanation see pdf file
