List of modules + description:
-----------------------------------------------
MCU.vhd - mcu top, input\output of the system, connect all signal together and mips with GPIO and Interrupt. 
MIPS.vhd - Mips core top, contain the pipeline Register and Debug Register, and connect between the modules to the Registers.
IFetch.vhd - contain the Instruction Memory and the PC Register, and execute the Fetch phase of the pipeline.
IDecode.vhd - contain the Hazard and ID_Forwarding Units, The Register file and The Branch Control unit (Decide If a branch command is taken or not).
Control.vhd - Receive the instruction from IF/ID Register and move Control signal To the Relevant Units through the pipeline Registers.
Execute.vhd - The calculation phase, contain ALU unit and Forwarding Unit.
DMemory.vhd - Contain the DATA Memory for load/store data.
Btimer.vhd - Timer file for the couner, registers and configuration.
GPIO.vhd - gerenal purpose register, Leds and 7segment display.
Interrupt.vhd - Interrput controller, for the Btimer, Keys and Uart
pll. vhd - pll file for the clock of the system
uart.vhd - uart conroller for tx and rx (given by Hanan)
uart_debouncer - uart debouncer for the line and the signals.
uart parity - parity check of the uart.
uart_rx - receive controller
uart_tx - transmit controller
-----------------------------------------------
* for more explanation see pdf file
