						--  Idecode module (implements the register file for
LIBRARY IEEE; 			-- the MIPS computer)
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Idecode IS
	PORT(	read_data_1	: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
			read_data_2	: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
			Sign_extend : OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
			Shamt		: OUT 	STD_LOGIC_VECTOR(4 DOWNTO 0);
			Instruction : IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
			DataBusToReg: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
			ALU_result	: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
			NextPc 		: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
			PC_plus_4_OUT : IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
			RegWrite 	: IN 	STD_LOGIC;
			MemtoReg 	: IN 	STD_LOGIC_VECTOR(2 DOWNTO 0);
			RegDst 		: IN 	STD_LOGIC_VECTOR(1 DOWNTO 0);
			clock,reset	: IN 	STD_LOGIC; 
			jump		: IN 	STD_LOGIC_VECTOR(1 downto 0);
			INTR		: IN 	STD_LOGIC;
			IVCall		: IN 	STD_LOGIC;
			GIE			: OUT 	STD_LOGIC

	);
END Idecode;


ARCHITECTURE behavior OF Idecode IS
TYPE register_file IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

	SIGNAL register_array				: register_file;
	SIGNAL write_register_address 		: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL write_data					: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL read_register_1_address		: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL read_register_2_address		: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL write_register_address_1		: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL write_register_address_0		: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL Instruction_immediate_value	: STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

	-- Instruction Register Decode
	read_register_1_address 	<= Instruction(25 DOWNTO 21);
   	read_register_2_address 	<= Instruction(20 DOWNTO 16);
   	write_register_address_1	<= Instruction(15 DOWNTO 11);
   	write_register_address_0 	<= Instruction(20 DOWNTO 16);
   	Instruction_immediate_value <= Instruction(15 DOWNTO 0);
	Shamt						<= Instruction(10 DOWNTO 6);
	
	-- Read Register Operations
	read_data_1 <= register_array( 
			      CONV_INTEGER(read_register_1_address));			  
	read_data_2 <= register_array( 
			      CONV_INTEGER(read_register_2_address));
	
	-- Mux to bypass data memory for Rformat instructions (MemToReg)
	write_data <= ALU_result(31 DOWNTO 0) 				WHEN (MemtoReg = "000") ELSE
				  DataBusToReg 			  				WHEN (MemtoReg = "001") ELSE
				  X"000000" & NextPc(7 DOWNTO 0)		WHEN (MemtoReg = "010") ELSE
				  Instruction_immediate_value & X"0000" WHEN (MemToReg = "011") ELSE
				  X"000000" & PC_plus_4_OUT(7 DOWNTO 0) WHEN (MemToReg = "100") ELSE
				  unaffected;
				  
				  
	-- Mux for Register Write Address
    write_register_address <= write_register_address_1 WHEN RegDst = "01" ELSE
							  write_register_address_0 WHEN RegDst = "00" ELSE
							  "11111" 				   WHEN RegDst = "10" ELSE  -- for return register 31 ra 
							  "11011";  -- $K1 WHEN RegDst = "11" ELSE -- for save the PC in register 27
			
	-- Sign Extend 16-bits to 32-bits
    Sign_extend <= X"0000" & Instruction_immediate_value 
						WHEN Instruction_immediate_value(15) = '0' ELSE
				   X"FFFF" & Instruction_immediate_value;

-- Register File
PROCESS
	BEGIN
		WAIT UNTIL (clock'EVENT AND clock = '1');
		IF reset = '0' THEN
			FOR i IN 0 TO 31 LOOP
				register_array(i) <= CONV_STD_LOGIC_VECTOR( i, 32 );
 			END LOOP;
					-- Write back to register - don't write to register 0
  		ELSIF (RegWrite = '1' AND IVCall = '0' And write_register_address /= 0) THEN
		      register_array(CONV_INTEGER(write_register_address)) <= write_data;
		ELSIF (read_register_1_address = "11011" AND jump(0) = '1') THEN 
			register_array(26)(0) <= '1';
		END IF;
		IF (INTR = '1') THEN
			register_array(26)(0) <= '0';  -- shut off the gie bit 
		END IF;
	END PROCESS;
	
	GIE	<= register_array(26)(0); -- $K0
	
END behavior;



