-- Instruction Decode Stage --
LIBRARY IEEE; 			
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Idecode IS
	PORT(	
		clock,reset				 	: IN 	 STD_LOGIC;
		Instruction 			 	: IN 	 STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Sign_extend 			 	: BUFFER STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		write_register_address_1 	: OUT 	 STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		write_register_address_0 	: OUT 	 STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		-- Register File Unit
		RegWrite 				 	: IN 	 STD_LOGIC;
		write_register_address 	 	: IN 	 STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		write_data				 	: IN 	 STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		read_register_1_address  	: BUFFER STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		read_register_2_address  	: BUFFER STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		read_data_1				 	: BUFFER STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		read_data_2				 	: BUFFER STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		-- Hazard
		MemRead_EX, MemRead_MEM	 	: IN 	 STD_LOGIC;
		RegWrite_EX					: IN 	 STD_LOGIC;
		write_register_address_0_EX : IN 	 STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		Stall 					 	: BUFFER STD_LOGIC;
		-- Forwarding For Branch
		RegWrite_MEM			 	: IN 	 STD_LOGIC;
		RegWrite_WB				 	: IN 	 STD_LOGIC;
		write_R_add_MEM 		 	: IN 	 STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		write_R_add_WB 			 	: IN 	 STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		ALU_Result_MEM			 	: IN 	 STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		write_data_WB			 	: IN 	 STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		-- Branch
		Branch					 	: IN 	 STD_LOGIC;
		PC_plus_4 				 	: IN  	 STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		PcSrc					 	: OUT 	 STD_LOGIC;
		Add_Result 				 	: OUT	 STD_LOGIC_VECTOR( 7 DOWNTO 0 )
	);
END Idecode;


ARCHITECTURE behavior OF Idecode IS
TYPE register_file IS ARRAY ( 0 TO 31 ) OF STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	SIGNAL register_array				: register_file;
	SIGNAL A_Branch, B_Branch 			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Instruction_immediate_value	: STD_LOGIC_VECTOR( 15 DOWNTO 0 );
	SIGNAL Branch_Add 					: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL ForwardA						: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL ForwardB						: STD_LOGIC_VECTOR( 1 DOWNTO 0 );

BEGIN
	read_register_1_address 	<= Instruction( 25 DOWNTO 21 ); -- rs
   	read_register_2_address 	<= Instruction( 20 DOWNTO 16 ); -- rt
	
   	write_register_address_1	<= Instruction( 15 DOWNTO 11 ); -- rd
   	write_register_address_0 	<= Instruction( 20 DOWNTO 16 ); -- rt
	
   	Instruction_immediate_value <= Instruction( 15 DOWNTO 0 );
	
	-- Read Register From RF
	read_data_1 <= register_array( 
			      CONV_INTEGER( read_register_1_address ) );
	read_data_2 <= register_array( 
			      CONV_INTEGER( read_register_2_address ) );
	
	-- Sign Extend 16-bits to 32-bits
    Sign_extend <= X"0000" & Instruction_immediate_value
					WHEN Instruction_immediate_value(15) = '0'
					ELSE	X"FFFF" & Instruction_immediate_value;

	-- Write Register From RF
	PROCESS
	BEGIN
		WAIT UNTIL clock'EVENT AND clock = '0';
		IF reset = '0' THEN
					-- Initial register values on reset are register = reg#
					-- use loop to automatically generate reset logic 
					-- for all registers
			FOR i IN 0 TO 31 LOOP
				register_array(i) <= CONV_STD_LOGIC_VECTOR( i, 32 );
 			END LOOP;
					-- Write back to register - don't write to register 0
  		ELSIF (RegWrite = '1' AND write_register_address /= 0) THEN
		      register_array( CONV_INTEGER( write_register_address)) <= write_data;
		END IF;
	END PROCESS;
	
	--- Adder to compute Branch Address
	Branch_Add	<= PC_plus_4( 9 DOWNTO 2 ) +  Sign_extend( 7 DOWNTO 0 ) ;
	Add_result 	<= Branch_Add( 7 DOWNTO 0 );
	
	-- Branch Control Input's MUX (from forwarding)
	A_Branch <= ALU_Result_MEM WHEN (ForwardA = "10")
			ELSE write_data_WB WHEN (ForwardA = "01")
			ELSE Read_data_1;
			
	B_Branch <= ALU_Result_MEM WHEN (ForwardB = "10")
			ELSE write_data_WB WHEN (ForwardB = "01")
			ELSE Read_data_2;

	-- Branch Control Input (if equal)
	PcSrc <= '1' WHEN (A_Branch = B_Branch) and
					  (Branch = '1') and (Stall = '0')
				 ELSE '0';
	
	-- Hazard Unit
	Stall <= '1' WHEN ((MemRead_EX = '1' or (RegWrite_EX = '1' and Branch = '1')) and
					  (write_register_address_0_EX /= "00000") and
					  ((write_register_address_0_EX = read_register_1_address) or
					  (write_register_address_0_EX = read_register_2_address))) or
					  ((MemRead_Mem = '1' and Branch = '1') and
					  (write_R_add_MEM /= "00000") and
					  ((write_R_add_MEM = read_register_1_address) or
					  (write_R_add_MEM = read_register_2_address)))
					  --((MemRead_MEM = '1') and
					  --((write_register_address_0_EX = read_register_1_address) or
					  --(write_register_address_0_EX = read_register_2_address)))
			ELSE '0';

	-- Forwarding For Branch Unit
	ForwardA <= "10" WHEN (RegWrite_MEM = '1') and
						  (write_R_add_MEM /= "00000") and
						  (write_R_add_MEM = read_register_1_address)
		   ELSE "01" WHEN (RegWrite_WB = '1') and
						  (write_R_add_WB /= "00000") and
						  (write_R_add_WB = read_register_1_address) and
						  not((RegWrite_MEM = '0') and
							 (write_R_add_MEM /= "00000") and
							 (write_R_add_MEM = read_register_1_address)) 
		   ELSE "00";
			
	ForwardB <= "10" WHEN (RegWrite_MEM = '1') and
						  (write_R_add_MEM /= "00000") and
						  (write_R_add_MEM = read_register_2_address)
		   ELSE "01" WHEN (RegWrite_WB = '1') and
						  (write_R_add_WB /= "00000") and
						  (write_R_add_WB = read_register_2_address) and
						  not((RegWrite_MEM = '1') and
							 (write_R_add_MEM /= "00000") and
							 (write_R_add_MEM = read_register_2_address)) 
		   ELSE "00";
END behavior;
