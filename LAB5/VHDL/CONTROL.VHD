-- Control Unit --
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY control IS
	PORT( 
		clock,reset	: IN 	STD_LOGIC;
		Stall		: IN 	STD_LOGIC;
		Opcode 		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
		ALUOp 		: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
		RegDst 		: OUT 	STD_LOGIC;
		ALUSrc 		: OUT 	STD_LOGIC;
		MemRead 	: OUT 	STD_LOGIC;
		MemWrite 	: OUT 	STD_LOGIC;
		Branch 		: OUT 	STD_LOGIC;
		MemtoReg 	: OUT 	STD_LOGIC;
		RegWrite 	: OUT 	STD_LOGIC
	);
END control;

ARCHITECTURE behavior OF control IS

	SIGNAL  Addi, R_format, Lw, Sw, Beq 	: STD_LOGIC;

BEGIN           
				-- Code to generate control signals using opcode bits
	-- ID:
	Branch      <=  Beq;
	
	-- EX:
	ALUOp( 1 ) 	<=  R_format;
	ALUOp( 0 ) 	<=  Beq; 
  	RegDst    	<=  R_format;
 	ALUSrc  	<=  Lw OR Sw OR Addi;
	
	-- MEM:
	MemRead 	<=  Lw;
   	MemWrite 	<=  Sw;
	
	-- WB:
	MemtoReg 	<=  Lw;
	RegWrite 	<=  R_format OR Lw OR Addi;
	
	-- OpCode Decoder
	R_format 	<=  '1'  WHEN  Opcode = "000000"  ELSE '0';
	Addi		<= 	'1'	 WHEN  Opcode = "001000"  ELSE '0';
	Lw          <=  '1'  WHEN  Opcode = "100011"  ELSE '0';
 	Sw          <=  '1'  WHEN  Opcode = "101011"  ELSE '0';
   	Beq         <=  '1'  WHEN  Opcode = "000100"  ELSE '0';
   END behavior;


