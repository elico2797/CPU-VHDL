--  Dmemory module (implements the data memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY dmemory IS
	GENERIC (MemWidth	: INTEGER;
			 SIM 		: BOOLEAN
	);
	PORT(	clock,reset			: IN 	STD_LOGIC;
			Memwrite 			: IN 	STD_LOGIC;
			MemRead			 	: IN 	STD_LOGIC; 
			Address				: IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
        	write_data 			: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
			read_data 			: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END dmemory;

ARCHITECTURE behavior OF dmemory IS

	SIGNAL write_clock 	: STD_LOGIC;
	SIGNAL write_ena 	: STD_LOGIC;
	SIGNAL MEM_Address 	: STD_LOGIC_VECTOR(MemWidth-1 DOWNTO 0);
	
BEGIN	
		
	-- Generate Ena Signal For MEM Write
	write_ena	<= '1' WHEN (Address(11) = '0' AND Memwrite = '1') ELSE '0';
	
	--Write Address Generate
	G1: IF (SIM = TRUE) GENERATE
			MEM_Address <= Address(9 DOWNTO 2);
	END GENERATE G1;
	G2: IF (SIM = FALSE) GENERATE
			MEM_Address <= Address(9 DOWNTO 2) & "00";
	END GENERATE G2;

	-- Data Chache Memory 
	data_memory : altsyncram
	GENERIC MAP  (
		operation_mode		 	=> "SINGLE_PORT",
		width_a 				=> 32,
		widthad_a 				=> MemWidth,
		lpm_type 				=> "altsyncram",
		outdata_reg_a 			=> "UNREGISTERED",
		init_file 				=> "dmemory.hex",
		intended_device_family 	=> "Cyclone"
	)
	PORT MAP (
		wren_a 		=> write_ena,
		clock0 		=> write_clock,
		address_a 	=> MEM_Address,
		data_a 	 	=> write_data,
		q_a 		=> read_data	
	);
		
-- Load memory address register with write clock
	write_clock <= NOT clock;
	
END behavior;
