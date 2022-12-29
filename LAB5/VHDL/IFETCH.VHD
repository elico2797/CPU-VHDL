-- Instruction Fetch Stage --
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY Ifetch IS
	GENERIC (MemWidth	: INTEGER;
			 SIM 		: BOOLEAN);
	PORT(	
		clock, reset 	: IN 	STD_LOGIC;
		Stall 			: IN 	STD_LOGIC;
		ena				: IN 	STD_LOGIC;
       	PcSrc 			: IN 	STD_LOGIC;
		Add_result 		: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		PC_plus_4_out 	: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		PC_out 			: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		Instruction 	: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 )
	);
        	
END Ifetch;

ARCHITECTURE behavior OF Ifetch IS

	SIGNAL MEM_clock		 : STD_LOGIC;	
	SIGNAL Mem_Addr		 	 : STD_LOGIC_VECTOR( MemWidth-1 DOWNTO 0 );
	SIGNAL next_PC			 : STD_LOGIC_VECTOR( 7 DOWNTO 0 ); 
	SIGNAL PC, PC_plus_4 	 : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	
BEGIN

	-- Instructions always start on word address - not byte
	PC(1 DOWNTO 0) <= "00";
	
	-- copy output signals - allows read inside module
	PC_out 			<= PC;
	PC_plus_4_out 	<= PC_plus_4;
	
	-- send address to inst. memory address register
	G1: IF (SIM = TRUE) GENERATE
			Mem_Addr <= PC( 9 DOWNTO 2);
	END GENERATE G1;
	G2: IF (SIM = FALSE) GENERATE
			Mem_Addr <= PC;
	END GENERATE G2;
	
	-- Adder to increment PC by 4        
	PC_plus_4( 9 DOWNTO 2 )  <= PC( 9 DOWNTO 2 ) + 1;
	PC_plus_4( 1 DOWNTO 0 )  <= "00";
	
	-- Mux to select Branch Address or PC + 4        
	-- Next_PC  <= X"00" WHEN Reset = '0' ELSE
	Next_PC  <= Add_result   WHEN (PcSrc = '1')
		ELSE PC_plus_4( 9 DOWNTO 2 );
			
	-- PC Reg (With Stall):
	PROCESS(clock, reset)
		BEGIN
			IF (reset = '0') THEN
				PC( 9 DOWNTO 2) <= "00000000" ;
			ELSIF (rising_edge(clock)) THEN	
				IF (Stall = '0' and ena = '1') THEN 
					PC( 9 DOWNTO 2 ) <= next_PC;
				END IF;
			END IF;
	END PROCESS;

	-- 	Connect To Instruction Memory (ROM)
	inst_memory: altsyncram	
	GENERIC MAP (
		operation_mode => "ROM",
		width_a => 32,
		widthad_a => MemWidth,
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "program.hex",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		clock0     	=> MEM_clock,
		address_a 	=> Mem_Addr, 
		q_a 		=> Instruction 
	); 
	
	-- Load memory address register with write clock
	MEM_clock <= NOT clock;
	
END behavior;


