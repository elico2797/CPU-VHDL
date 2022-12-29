onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mcu_tb/clock
add wave -noupdate /mcu_tb/U_0/CPU/CTL/INTR
add wave -noupdate /mcu_tb/U_0/CPU/CTL/INTA
add wave -noupdate /mcu_tb/U_0/CPU/CTL/IVCall
add wave -noupdate -expand -group {Fetch
} /mcu_tb/U_0/CPU/IFE/MemWidth
add wave -noupdate -expand -group {Fetch
} /mcu_tb/U_0/CPU/IFE/SIM
add wave -noupdate -expand -group {Fetch
} -radix hexadecimal /mcu_tb/U_0/CPU/IFE/Instruction
add wave -noupdate -expand -group {Fetch
} -radix hexadecimal /mcu_tb/U_0/CPU/IFE/PC_out
add wave -noupdate -expand -group {Fetch
} -radix hexadecimal /mcu_tb/U_0/CPU/IFE/Ret_Add
add wave -noupdate -expand -group {Fetch
} -radix hexadecimal /mcu_tb/U_0/CPU/IFE/Sign_extend
add wave -noupdate -expand -group {Fetch
} -radix hexadecimal /mcu_tb/U_0/CPU/IFE/Branch
add wave -noupdate -expand -group {Fetch
} -radix binary /mcu_tb/U_0/CPU/IFE/jump
add wave -noupdate -expand -group {Fetch
} -radix hexadecimal /mcu_tb/U_0/CPU/IFE/Zero
add wave -noupdate -expand -group {Fetch
} -radix hexadecimal /mcu_tb/U_0/CPU/IFE/clock
add wave -noupdate -expand -group {Fetch
} -radix hexadecimal /mcu_tb/U_0/CPU/IFE/reset
add wave -noupdate -expand -group {Fetch
} -radix hexadecimal -childformat {{/mcu_tb/U_0/CPU/IFE/IV_Add(11) -radix hexadecimal} {/mcu_tb/U_0/CPU/IFE/IV_Add(10) -radix hexadecimal} {/mcu_tb/U_0/CPU/IFE/IV_Add(9) -radix hexadecimal} {/mcu_tb/U_0/CPU/IFE/IV_Add(8) -radix hexadecimal} {/mcu_tb/U_0/CPU/IFE/IV_Add(7) -radix hexadecimal} {/mcu_tb/U_0/CPU/IFE/IV_Add(6) -radix hexadecimal} {/mcu_tb/U_0/CPU/IFE/IV_Add(5) -radix hexadecimal} {/mcu_tb/U_0/CPU/IFE/IV_Add(4) -radix hexadecimal} {/mcu_tb/U_0/CPU/IFE/IV_Add(3) -radix hexadecimal} {/mcu_tb/U_0/CPU/IFE/IV_Add(2) -radix hexadecimal} {/mcu_tb/U_0/CPU/IFE/IV_Add(1) -radix hexadecimal} {/mcu_tb/U_0/CPU/IFE/IV_Add(0) -radix hexadecimal}} -subitemconfig {/mcu_tb/U_0/CPU/IFE/IV_Add(11) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/IFE/IV_Add(10) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/IFE/IV_Add(9) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/IFE/IV_Add(8) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/IFE/IV_Add(7) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/IFE/IV_Add(6) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/IFE/IV_Add(5) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/IFE/IV_Add(4) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/IFE/IV_Add(3) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/IFE/IV_Add(2) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/IFE/IV_Add(1) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/IFE/IV_Add(0) {-height 15 -radix hexadecimal}} /mcu_tb/U_0/CPU/IFE/IV_Add
add wave -noupdate -expand -group {Fetch
} -radix hexadecimal /mcu_tb/U_0/CPU/IFE/IVCall
add wave -noupdate -expand -group {Fetch
} -radix hexadecimal /mcu_tb/U_0/CPU/IFE/PCHold
add wave -noupdate -expand -group {Fetch
} -radix binary /mcu_tb/U_0/CPU/IFE/PCsrc
add wave -noupdate -expand -group {Fetch
} -radix hexadecimal /mcu_tb/U_0/CPU/IFE/next_PC
add wave -noupdate -expand -group {Fetch
} -radix hexadecimal /mcu_tb/U_0/CPU/IFE/Branch_Add
add wave -noupdate -expand -group {Fetch
} -radix hexadecimal /mcu_tb/U_0/CPU/IFE/Jump_Add
add wave -noupdate -expand -group {Fetch
} -radix hexadecimal /mcu_tb/U_0/CPU/IFE/PC
add wave -noupdate -expand -group {Fetch
} -radix hexadecimal /mcu_tb/U_0/CPU/IFE/PC_plus_4
add wave -noupdate -expand -group {Fetch
} -radix hexadecimal /mcu_tb/U_0/CPU/IFE/Mem_Addr
add wave -noupdate -group {Decode
} -radix hexadecimal /mcu_tb/U_0/CPU/ID/read_data_1
add wave -noupdate -group {Decode
} -radix hexadecimal /mcu_tb/U_0/CPU/ID/read_data_2
add wave -noupdate -group {Decode
} -radix hexadecimal /mcu_tb/U_0/CPU/ID/Sign_extend
add wave -noupdate -group {Decode
} /mcu_tb/U_0/CPU/ID/Shamt
add wave -noupdate -group {Decode
} -radix hexadecimal /mcu_tb/U_0/CPU/ID/Instruction
add wave -noupdate -group {Decode
} -radix hexadecimal /mcu_tb/U_0/CPU/ID/ALU_result
add wave -noupdate -group {Decode
} /mcu_tb/U_0/CPU/ID/RegWrite
add wave -noupdate -group {Decode
} -radix hexadecimal /mcu_tb/U_0/CPU/ID/DataBusToReg
add wave -noupdate -group {Decode
} /mcu_tb/U_0/CPU/ID/MemtoReg
add wave -noupdate -group {Decode
} /mcu_tb/U_0/CPU/ID/RegDst
add wave -noupdate -group {Decode
} -radix hexadecimal -childformat {{/mcu_tb/U_0/CPU/ID/register_array(0) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(1) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(2) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(3) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(4) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(5) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(6) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(7) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(8) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(9) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(10) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(11) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(12) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(13) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(14) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(15) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(16) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(17) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(18) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(19) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(20) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(21) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(22) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(23) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(24) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(25) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(26) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(27) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(28) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(29) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(30) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/register_array(31) -radix hexadecimal}} -subitemconfig {/mcu_tb/U_0/CPU/ID/register_array(0) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(1) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(2) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(3) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(4) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(5) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(6) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(7) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(8) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(9) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(10) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(11) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(12) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(13) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(14) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(15) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(16) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(17) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(18) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(19) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(20) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(21) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(22) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(23) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(24) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(25) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(26) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(27) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(28) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(29) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(30) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/register_array(31) {-height 15 -radix hexadecimal}} /mcu_tb/U_0/CPU/ID/register_array
add wave -noupdate -group {Decode
} -radix unsigned -childformat {{/mcu_tb/U_0/CPU/ID/write_register_address(4) -radix decimal} {/mcu_tb/U_0/CPU/ID/write_register_address(3) -radix decimal} {/mcu_tb/U_0/CPU/ID/write_register_address(2) -radix decimal} {/mcu_tb/U_0/CPU/ID/write_register_address(1) -radix decimal} {/mcu_tb/U_0/CPU/ID/write_register_address(0) -radix decimal}} -subitemconfig {/mcu_tb/U_0/CPU/ID/write_register_address(4) {-height 15 -radix decimal} /mcu_tb/U_0/CPU/ID/write_register_address(3) {-height 15 -radix decimal} /mcu_tb/U_0/CPU/ID/write_register_address(2) {-height 15 -radix decimal} /mcu_tb/U_0/CPU/ID/write_register_address(1) {-height 15 -radix decimal} /mcu_tb/U_0/CPU/ID/write_register_address(0) {-height 15 -radix decimal}} /mcu_tb/U_0/CPU/ID/write_register_address
add wave -noupdate -group {Decode
} -radix hexadecimal -childformat {{/mcu_tb/U_0/CPU/ID/write_data(31) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(30) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(29) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(28) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(27) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(26) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(25) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(24) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(23) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(22) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(21) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(20) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(19) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(18) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(17) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(16) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(15) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(14) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(13) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(12) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(11) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(10) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(9) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(8) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(7) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(6) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(5) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(4) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(3) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(2) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(1) -radix hexadecimal} {/mcu_tb/U_0/CPU/ID/write_data(0) -radix hexadecimal}} -subitemconfig {/mcu_tb/U_0/CPU/ID/write_data(31) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(30) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(29) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(28) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(27) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(26) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(25) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(24) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(23) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(22) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(21) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(20) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(19) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(18) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(17) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(16) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(15) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(14) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(13) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(12) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(11) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(10) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(9) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(8) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(7) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(6) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(5) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(4) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(3) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(2) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(1) {-height 15 -radix hexadecimal} /mcu_tb/U_0/CPU/ID/write_data(0) {-height 15 -radix hexadecimal}} /mcu_tb/U_0/CPU/ID/write_data
add wave -noupdate -group {Decode
} -radix unsigned /mcu_tb/U_0/CPU/ID/read_register_1_address
add wave -noupdate -group {Decode
} -radix decimal -childformat {{/mcu_tb/U_0/CPU/ID/read_register_2_address(4) -radix decimal} {/mcu_tb/U_0/CPU/ID/read_register_2_address(3) -radix decimal} {/mcu_tb/U_0/CPU/ID/read_register_2_address(2) -radix decimal} {/mcu_tb/U_0/CPU/ID/read_register_2_address(1) -radix decimal} {/mcu_tb/U_0/CPU/ID/read_register_2_address(0) -radix decimal}} -subitemconfig {/mcu_tb/U_0/CPU/ID/read_register_2_address(4) {-height 15 -radix decimal} /mcu_tb/U_0/CPU/ID/read_register_2_address(3) {-height 15 -radix decimal} /mcu_tb/U_0/CPU/ID/read_register_2_address(2) {-height 15 -radix decimal} /mcu_tb/U_0/CPU/ID/read_register_2_address(1) {-height 15 -radix decimal} /mcu_tb/U_0/CPU/ID/read_register_2_address(0) {-height 15 -radix decimal}} /mcu_tb/U_0/CPU/ID/read_register_2_address
add wave -noupdate -group {Decode
} -radix decimal /mcu_tb/U_0/CPU/ID/write_register_address_1
add wave -noupdate -group {Decode
} -radix decimal /mcu_tb/U_0/CPU/ID/write_register_address_0
add wave -noupdate -group {Decode
} -radix hexadecimal /mcu_tb/U_0/CPU/ID/Instruction_immediate_value
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/Opcode
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/Funct
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/ALUop
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/Branch
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/RegDst
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/ALUSrc
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/MemtoReg
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/RegWrite
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/MemRead
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/MemWrite
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/jump
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/PCHold
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/clock
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/reset
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/R_format
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/I_format
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/J_format
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/Lw
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/Sw
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/Beq
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/bne
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/J
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/Jal
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/Jr
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/mul
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/andi
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/ori
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/xori
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/slti
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/Lui
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/addi
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/IVCall_signal
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/INTA_signal
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/pr_state
add wave -noupdate -group {Control
} /mcu_tb/U_0/CPU/CTL/nx_state
add wave -noupdate -group {Execute
} /mcu_tb/U_0/CPU/EXE/ALUSrc
add wave -noupdate -group {Execute
} /mcu_tb/U_0/CPU/EXE/ALUOp
add wave -noupdate -group {Execute
} /mcu_tb/U_0/CPU/EXE/Func_op
add wave -noupdate -group {Execute
} -radix hexadecimal /mcu_tb/U_0/CPU/EXE/Read_data_1
add wave -noupdate -group {Execute
} -radix hexadecimal /mcu_tb/U_0/CPU/EXE/Read_data_2
add wave -noupdate -group {Execute
} -radix hexadecimal /mcu_tb/U_0/CPU/EXE/Sign_extend
add wave -noupdate -group {Execute
} -radix hexadecimal /mcu_tb/U_0/CPU/EXE/Shamt
add wave -noupdate -group {Execute
} -radix hexadecimal /mcu_tb/U_0/CPU/EXE/Zero
add wave -noupdate -group {Execute
} -radix hexadecimal /mcu_tb/U_0/CPU/EXE/Add_result
add wave -noupdate -group {Execute
} -radix hexadecimal /mcu_tb/U_0/CPU/EXE/ALU_Result
add wave -noupdate -group {Execute
} -radix hexadecimal /mcu_tb/U_0/CPU/EXE/ALU_Mul
add wave -noupdate -group {Execute
} -radix hexadecimal /mcu_tb/U_0/CPU/EXE/Ainput
add wave -noupdate -group {Execute
} -radix hexadecimal /mcu_tb/U_0/CPU/EXE/Binput
add wave -noupdate -group {Execute
} -radix hexadecimal /mcu_tb/U_0/CPU/EXE/ALU_output_mux
add wave -noupdate -group {Execute
} /mcu_tb/U_0/CPU/EXE/ALU_ctl
add wave -noupdate -group {Memory
} /mcu_tb/U_0/CPU/MEM/Memwrite
add wave -noupdate -group {Memory
} /mcu_tb/U_0/CPU/MEM/MemRead
add wave -noupdate -group {Memory
} -radix hexadecimal /mcu_tb/U_0/CPU/MEM/write_data
add wave -noupdate -group {Memory
} -radix hexadecimal /mcu_tb/U_0/CPU/MEM/read_data
add wave -noupdate -group {Memory
} /mcu_tb/U_0/CPU/MEM/write_clock
add wave -noupdate -group {Memory
} /mcu_tb/U_0/CPU/MEM/write_ena
add wave -noupdate -group {Memory
} -radix hexadecimal /mcu_tb/U_0/CPU/MEM/Address
add wave -noupdate -group {CS_decoder
} /mcu_tb/U_0/CSIFG
add wave -noupdate -group {CS_decoder
} /mcu_tb/U_0/CSIE
add wave -noupdate -group {CS_decoder
} /mcu_tb/U_0/CSBTCNT
add wave -noupdate -group {CS_decoder
} /mcu_tb/U_0/CSBTCTL
add wave -noupdate -group {CS_decoder
} /mcu_tb/U_0/CSKEY
add wave -noupdate -group {CS_decoder
} /mcu_tb/U_0/CSSW
add wave -noupdate -group {CS_decoder
} /mcu_tb/U_0/CSHEX3
add wave -noupdate -group {CS_decoder
} /mcu_tb/U_0/CSHEX2
add wave -noupdate -group {CS_decoder
} /mcu_tb/U_0/CSHEX1
add wave -noupdate -group {CS_decoder
} /mcu_tb/U_0/CSHEX0
add wave -noupdate -group {CS_decoder
} /mcu_tb/U_0/CSLEDR
add wave -noupdate -group {CS_decoder
} /mcu_tb/U_0/CSLEDG
add wave -noupdate -group {IO
} /mcu_tb/U_0/IO/MemRead
add wave -noupdate -group {IO
} /mcu_tb/U_0/IO/MemWrite
add wave -noupdate -group {IO
} -group {Output_Leds_and_7seg
} /mcu_tb/U_0/IO/LED_G
add wave -noupdate -group {IO
} -group {Output_Leds_and_7seg
} /mcu_tb/U_0/IO/LED_R
add wave -noupdate -group {IO
} -group {Output_Leds_and_7seg
} /mcu_tb/U_0/IO/HEX0
add wave -noupdate -group {IO
} -group {Output_Leds_and_7seg
} /mcu_tb/U_0/IO/HEX1
add wave -noupdate -group {IO
} -group {Output_Leds_and_7seg
} /mcu_tb/U_0/IO/HEX2
add wave -noupdate -group {IO
} -group {Output_Leds_and_7seg
} /mcu_tb/U_0/IO/HEX3
add wave -noupdate -group {IO
} -group {Output_Leds_and_7seg
} /mcu_tb/U_0/IO/LED_G_PORT
add wave -noupdate -group {IO
} -group {Output_Leds_and_7seg
} /mcu_tb/U_0/IO/LED_R_PORT
add wave -noupdate -group {IO
} -group {Output_Leds_and_7seg
} /mcu_tb/U_0/IO/HEX0_PORT
add wave -noupdate -group {IO
} -group {Output_Leds_and_7seg
} /mcu_tb/U_0/IO/HEX1_PORT
add wave -noupdate -group {IO
} -group {Output_Leds_and_7seg
} /mcu_tb/U_0/IO/HEX2_PORT
add wave -noupdate -group {IO
} -group {Output_Leds_and_7seg
} /mcu_tb/U_0/IO/HEX3_PORT
add wave -noupdate -group {IO
} -group {Input
} /mcu_tb/U_0/IO/Switches
add wave -noupdate -group {IO
} -group {Input
} /mcu_tb/U_0/IO/SW_PORT
add wave -noupdate -group {MIPS
} /mcu_tb/U_0/CPU/MemReadBus
add wave -noupdate -group {MIPS
} /mcu_tb/U_0/CPU/MemWriteBus
add wave -noupdate -group {MIPS
} -radix hexadecimal /mcu_tb/U_0/CPU/read_data_1
add wave -noupdate -group {MIPS
} -radix hexadecimal /mcu_tb/U_0/CPU/read_data_2
add wave -noupdate -group {MIPS
} -radix hexadecimal /mcu_tb/U_0/CPU/read_data
add wave -noupdate -group {MIPS
} -radix hexadecimal /mcu_tb/U_0/CPU/Add_result
add wave -noupdate -group {MIPS
} /mcu_tb/U_0/CPU/MemWrite
add wave -noupdate -group {MIPS
} /mcu_tb/U_0/CPU/MemRead
add wave -noupdate -group {MIPS
} /mcu_tb/U_0/AddressBus
add wave -noupdate -group {MIPS
} /mcu_tb/U_0/CPU/INTA_signal
add wave -noupdate -group {MIPS
} -radix hexadecimal /mcu_tb/U_0/dataBus
add wave -noupdate -group {MIPS
} -radix hexadecimal /mcu_tb/U_0/CPU/Address
add wave -noupdate -group {MIPS
} -radix hexadecimal /mcu_tb/U_0/CPU/AddressBus
add wave -noupdate -group {MCU
} /mcu_tb/U_0/Switches
add wave -noupdate -group {MCU
} /mcu_tb/U_0/LED_G
add wave -noupdate -group {MCU
} /mcu_tb/U_0/LED_R
add wave -noupdate -group {MCU
} /mcu_tb/U_0/HEX0
add wave -noupdate -group {MCU
} /mcu_tb/U_0/HEX1
add wave -noupdate -group {MCU
} /mcu_tb/U_0/HEX2
add wave -noupdate -group {MCU
} /mcu_tb/U_0/HEX3
add wave -noupdate -group {MCU
} /mcu_tb/U_0/LED_G_temp
add wave -noupdate -group {MCU
} /mcu_tb/U_0/LED_R_temp
add wave -noupdate -group {MCU
} /mcu_tb/U_0/HEX0_temp
add wave -noupdate -group {MCU
} /mcu_tb/U_0/HEX1_temp
add wave -noupdate -group {MCU
} /mcu_tb/U_0/HEX2_temp
add wave -noupdate -group {MCU
} /mcu_tb/U_0/HEX3_temp
add wave -noupdate -expand -group {Basic Timer} /mcu_tb/U_0/BT/clock
add wave -noupdate -expand -group {Basic Timer} /mcu_tb/U_0/BT/clock_div
add wave -noupdate -expand -group {Basic Timer} /mcu_tb/U_0/BT/Reset
add wave -noupdate -expand -group {Basic Timer} /mcu_tb/U_0/BT/MemWrite
add wave -noupdate -expand -group {Basic Timer} /mcu_tb/U_0/BT/CSBTCTL
add wave -noupdate -expand -group {Basic Timer} /mcu_tb/U_0/BT/CSBTCNT
add wave -noupdate -expand -group {Basic Timer} /mcu_tb/U_0/BT/MemRead
add wave -noupdate -expand -group {Basic Timer} -radix hexadecimal /mcu_tb/U_0/BT/DataBus
add wave -noupdate -expand -group {Basic Timer} -radix hexadecimal /mcu_tb/U_0/BT/BTSetIFG
add wave -noupdate -expand -group {Basic Timer} -radix hexadecimal /mcu_tb/U_0/BT/BTCTL
add wave -noupdate -expand -group {Basic Timer} -radix hexadecimal -childformat {{/mcu_tb/U_0/BT/BTCNT(31) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(30) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(29) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(28) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(27) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(26) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(25) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(24) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(23) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(22) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(21) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(20) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(19) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(18) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(17) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(16) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(15) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(14) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(13) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(12) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(11) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(10) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(9) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(8) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(7) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(6) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(5) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(4) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(3) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(2) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(1) -radix hexadecimal} {/mcu_tb/U_0/BT/BTCNT(0) -radix hexadecimal}} -expand -subitemconfig {/mcu_tb/U_0/BT/BTCNT(31) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(30) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(29) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(28) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(27) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(26) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(25) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(24) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(23) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(22) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(21) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(20) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(19) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(18) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(17) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(16) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(15) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(14) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(13) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(12) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(11) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(10) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(9) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(8) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(7) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(6) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(5) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(4) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(3) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(2) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(1) {-height 15 -radix hexadecimal} /mcu_tb/U_0/BT/BTCNT(0) {-height 15 -radix hexadecimal}} /mcu_tb/U_0/BT/BTCNT
add wave -noupdate -expand -group {Basic Timer} /mcu_tb/U_0/BT/BTIP
add wave -noupdate -expand -group {Basic Timer} /mcu_tb/U_0/BT/BTSSEL
add wave -noupdate -expand -group {Basic Timer} /mcu_tb/U_0/BT/BTHOLD
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/INT/INTA
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/INT/INTR
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/INT/KEY3
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/INT/KEY2
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/INT/KEY1
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/INT/BTSetIFG
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/INT/GIE
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/INT/CSIFG
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/INT/CSIE
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/INT/MemWrite
add wave -noupdate -expand -group Interupt -radix hexadecimal /mcu_tb/U_0/INT/DataBus
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/INT/reset
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/INT/KEY3Irq
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/INT/KEY2Irq
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/INT/KEY1Irq
add wave -noupdate -expand -group Interupt -radix hexadecimal -childformat {{/mcu_tb/U_0/INT/IFGReg(7) -radix hexadecimal} {/mcu_tb/U_0/INT/IFGReg(6) -radix hexadecimal} {/mcu_tb/U_0/INT/IFGReg(5) -radix hexadecimal} {/mcu_tb/U_0/INT/IFGReg(4) -radix hexadecimal} {/mcu_tb/U_0/INT/IFGReg(3) -radix hexadecimal} {/mcu_tb/U_0/INT/IFGReg(2) -radix hexadecimal} {/mcu_tb/U_0/INT/IFGReg(1) -radix hexadecimal} {/mcu_tb/U_0/INT/IFGReg(0) -radix hexadecimal}} -subitemconfig {/mcu_tb/U_0/INT/IFGReg(7) {-height 15 -radix hexadecimal} /mcu_tb/U_0/INT/IFGReg(6) {-height 15 -radix hexadecimal} /mcu_tb/U_0/INT/IFGReg(5) {-height 15 -radix hexadecimal} /mcu_tb/U_0/INT/IFGReg(4) {-height 15 -radix hexadecimal} /mcu_tb/U_0/INT/IFGReg(3) {-height 15 -radix hexadecimal} /mcu_tb/U_0/INT/IFGReg(2) {-height 15 -radix hexadecimal} /mcu_tb/U_0/INT/IFGReg(1) {-height 15 -radix hexadecimal} /mcu_tb/U_0/INT/IFGReg(0) {-height 15 -radix hexadecimal}} /mcu_tb/U_0/INT/IFGReg
add wave -noupdate -expand -group Interupt -radix hexadecimal -childformat {{/mcu_tb/U_0/INT/IEReg(7) -radix hexadecimal} {/mcu_tb/U_0/INT/IEReg(6) -radix hexadecimal} {/mcu_tb/U_0/INT/IEReg(5) -radix hexadecimal} {/mcu_tb/U_0/INT/IEReg(4) -radix hexadecimal} {/mcu_tb/U_0/INT/IEReg(3) -radix hexadecimal} {/mcu_tb/U_0/INT/IEReg(2) -radix hexadecimal} {/mcu_tb/U_0/INT/IEReg(1) -radix hexadecimal} {/mcu_tb/U_0/INT/IEReg(0) -radix hexadecimal}} -subitemconfig {/mcu_tb/U_0/INT/IEReg(7) {-height 15 -radix hexadecimal} /mcu_tb/U_0/INT/IEReg(6) {-height 15 -radix hexadecimal} /mcu_tb/U_0/INT/IEReg(5) {-height 15 -radix hexadecimal} /mcu_tb/U_0/INT/IEReg(4) {-height 15 -radix hexadecimal} /mcu_tb/U_0/INT/IEReg(3) {-height 15 -radix hexadecimal} /mcu_tb/U_0/INT/IEReg(2) {-height 15 -radix hexadecimal} /mcu_tb/U_0/INT/IEReg(1) {-height 15 -radix hexadecimal} /mcu_tb/U_0/INT/IEReg(0) {-height 15 -radix hexadecimal}} /mcu_tb/U_0/INT/IEReg
add wave -noupdate -expand -group Interupt -radix hexadecimal /mcu_tb/U_0/INT/TYPEReg
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/INT/BTIE
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/INT/KEY1IE
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/INT/KEY2IE
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/INT/KEY3IE
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/INT/KEY1IFG
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/INT/KEY2IFG
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/INT/KEY3IFG
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/BT/BTSetIFG
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/INT/BTIFG
add wave -noupdate -expand -group Interupt /mcu_tb/U_0/a_clock
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14050000 ps} 0} {{Cursor 2} {15725806452 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 423
configure wave -valuecolwidth 135
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {10768750 ps} {17331250 ps}
