-- Memory Acces Stage --
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY dmemory IS
	GENERIC (MemWidth	: INTEGER;
			 SIM 		: BOOLEAN);
	PORT(	
		clock,reset				: IN 	STD_LOGIC;
		MemRead, Memwrite 		: IN 	STD_LOGIC;
		ALU_Result_MEM 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        write_data 				: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		read_data 				: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Address_MEM 			: OUT 	STD_LOGIC_VECTOR( MemWidth-1 DOWNTO 0 )
	);
END dmemory;

ARCHITECTURE behavior OF dmemory IS

	SIGNAL write_clock  : STD_LOGIC;
	SIGNAL Address 		: STD_LOGIC_VECTOR( MemWidth-1 DOWNTO 0 );
	
BEGIN
	
	-- Write Address Generate
	G1: IF (SIM = TRUE) GENERATE
			Address <= ALU_Result_MEM(9 DOWNTO 2);
	END GENERATE G1;
	G2: IF (SIM = FALSE) GENERATE
			Address <= ALU_Result_MEM(9 DOWNTO 2) & "00";
	END GENERATE G2;
	Address_MEM <= Address;
	
	-- Memory UNIT
	data_memory : altsyncram
	GENERIC MAP  (
		operation_mode => "SINGLE_PORT",
		width_a => 32,
		widthad_a => MemWidth,
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "dmemory.hex",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		wren_a => memwrite,
		clock0 => write_clock,
		address_a => Address,
		data_a => write_data,
		q_a => read_data	
	);
		
		
	-- Load memory Address register with write clock
	write_clock <= NOT clock;
	
END behavior;

