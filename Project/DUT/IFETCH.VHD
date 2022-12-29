-- Ifetch module (provides the PC and instruction 
--memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY Ifetch IS
	GENERIC(MemWidth	: INTEGER;
			SIM 		: BOOLEAN
	);
	PORT(	Instruction 	: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
        	NextPC_out 		: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
			PC_out 			: OUT	STD_LOGIC_VECTOR(9 DOWNTO 0);
			PC_plus_4_OUT	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);	
			Ret_Add 		: IN	STD_LOGIC_VECTOR(9 DOWNTO 0);
			Sign_extend 	: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
			Branch 			: IN	STD_LOGIC_VECTOR(1 DOWNTO 0);
			jump 			: IN 	STD_LOGIC_VECTOR(1 DOWNTO 0);
        	Zero  			: IN 	STD_LOGIC;
        	clock, reset 	: IN 	STD_LOGIC;
			IV_Add			: IN	STD_LOGIC_VECTOR(11 DOWNTO 0); -- ADDRESS BUS
			IVCall			: IN 	STD_LOGIC;
			INTA 			: IN 	STD_LOGIC;
			enable			: IN 	STD_LOGIC;
			PCHold          : IN    STD_LOGIC
			
	);
END Ifetch;

ARCHITECTURE behavior OF Ifetch IS

	--SIGNAL PCHold			: STD_LOGIC := '0';
	SIGNAL Instruction_t    : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL PCsrc			: STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL Halt				: STD_LOGIC;
	SIGNAL next_PC			: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Branch_Add 		: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Jump_Add 		: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL PC, PC_plus_4 	: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL Mem_Addr,Mem_Address 	: STD_LOGIC_VECTOR(MemWidth-1 DOWNTO 0);
	SIGNAL pc_rst			: STD_LOGIC;
	
BEGIN

	-- PCsrc - check Branch condition
	PCsrc(0) <= '1' WHEN (((Branch = "10" AND Zero = '1') OR (Branch = "11" AND Zero = '0') OR (jump(0) = '1')) and pc_rst = '0')
				ELSE '0';
	PCsrc(1) <= '1' when (jump(1) = '1' and pc_rst = '0') else '0';

	-- Instructions always start on word address - not byte
	PC(1 DOWNTO 0) <= "00";
	
	-- copy output signals - For Debug Reading
	PC_out 			<= PC;
	NextPC_out 	<= Next_PC;
	PC_plus_4_OUT <= PC_plus_4(9 downto 2); 
	
	-- Adder to compute Branch Address
	Branch_Add	<= 	PC_plus_4(9 DOWNTO 2) + Sign_extend(7 DOWNTO 0) ;
	Jump_Add	<=  Sign_extend(7 DOWNTO 0) WHEN (IVCall = '0') ELSE
					IV_Add(9 DOWNTO 2); -- this is the address of the psika 9 DOWN TO 2
	
	
	Halt <= '1' WHEN (enable = '0' or PCHold = '1') else '0';
	
	-- Adder to increment PC by 4        
    PC_plus_4(9 DOWNTO 2)  <= PC(9 DOWNTO 2) + 1;
    PC_plus_4(1 DOWNTO 0)  <= "00";
	
	-- Mux to select Branch/Jump Address or PC + 4        
	Next_PC  <= Next_PC     WHEN (INTA = '1' and IVCall = '0') ELSE 
				Branch_Add  WHEN (PCsrc = "01") ELSE
				PC_plus_4(9 DOWNTO 2) WHEN (PCsrc = "00") ELSE
				Jump_Add WHEN (PCsrc = "10") ELSE
				Ret_Add(7 downto 0); -- was 7 down to 0
	
	-- PC Register
	PROCESS
		BEGIN
			WAIT UNTIL (clock'EVENT AND clock = '1');
			IF reset = '0' THEN
					PC(9 DOWNTO 2) <= "00000000" ;
					pc_rst <= '1';
			ELSIF (Halt = '0') THEN
					PC(9 DOWNTO 2) <= Next_PC;
					pc_rst <= '0';
			END IF;
	END PROCESS;
	
	
	-- send address to inst. memory address register
	G1: IF (SIM = TRUE) GENERATE
			Mem_Addr <= Next_PC;
	END GENERATE G1;
	G2: IF (SIM = FALSE) GENERATE
			Mem_Addr <= Next_PC & "00";
	END GENERATE G2;
	--Mem_Addr <= PC(9 DOWNTO 2);
	
	Instruction <= Instruction_t when INTA = '0' else X"00000000"; --- for psika
	
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
		clock0     	=> clock,
		address_a 	=> Mem_Addr, 
		q_a 		=> Instruction_t 
	);
		
END behavior;
