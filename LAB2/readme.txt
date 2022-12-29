List of modules + description:
-----------------------------------------------
top.vhd - top module which have three procceses as explanied. 
first process is active by falling edge of the clock, and save x to x[j-1] and x[j-1] to x[j-2] as a variables. 
second process is check the result of substruct between x[j-1] to x[j-2] and if the result is equal to the DetectionCode (inserted as a input) then diff = 1, else diff =0
third process is count the valid diff bits from the second process. if the valid bits is sufficient, mean its greater or equal to m, than the detector will be 1 as a output. 
else, we count the valid bit, until m. 
put res flag into 1 will zeroize all flags (diff, valid, detector)
ena flag its a pre condition for the system, as explained. it's mean that if the ana is zero the last state has to be preserved. 
Adder.vhd - Adder componenet that responsible for subtracrt between x[j-1] to x[j-2]
aux_package.vhd - package that contains all the different components + constants
-----------------------------------------------
* for more explanation see pdf file
