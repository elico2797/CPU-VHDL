-- Top Level Structural Model for MIPS Processor Core with pipeline --
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.all;

ENTITY MIPS IS
	GENERIC (MemWidth	: INTEGER := 10;
			 SIM 		: BOOLEAN := FALSE
	);
	PORT( 
		ena					: IN 	STD_LOGIC; 
		ena_INPUT			: IN 	STD_LOGIC;
		reset				: IN 	STD_LOGIC;
		clock				: IN 	STD_LOGIC; 
		BreakPoint			: OUT 	STD_LOGIC;

		--- Debug FF
		PBADD				: IN 	 STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		FHCNT				: BUFFER STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		STCNT				: BUFFER STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		CLKCNT				: BUFFER STD_LOGIC_VECTOR( 15 DOWNTO 0 )
	);
END 	MIPS;

ARCHITECTURE structure OF MIPS IS
	
	-- DEBUG Registers
	SIGNAL STCNT_Reg		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL FHCNT_Reg		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL PBADD_Reg		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL CLKCNT_Reg		: STD_LOGIC_VECTOR( 15 DOWNTO 0 );
	
	-- IF
	SIGNAL PC				: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL PcSrc			: STD_LOGIC;
	SIGNAL Add_Result_ID 	: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL PC_plus_4_IF 	: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL Instruction_IF	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
	-- ID
	SIGNAL Stall 						: STD_LOGIC;
	SIGNAL Branch_ID 					: STD_LOGIC;
	SIGNAL ALUOp_ID						: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL ALUSrc_ID, RegDst_ID			: STD_LOGIC;
	SIGNAL MemRead_ID, MemWrite_ID 		: STD_LOGIC;
	SIGNAL MemtoReg_ID, RegWrite_ID		: STD_LOGIC;
	SIGNAL read_register_1_address_ID  	: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL read_register_2_address_ID  	: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_register_address_0_ID 	: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_register_address_1_ID 	: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL PC_plus_4_ID 				: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL read_data_1_ID 				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2_ID 				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_extend_ID 				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Instruction_ID				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
	-- EX
	SIGNAL ALUSrc						: STD_LOGIC;
	SIGNAL ALUOp_EX						: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL ALUSrc_EX, RegDst_EX			: STD_LOGIC;
	SIGNAL MemRead_EX, MemWrite_EX 		: STD_LOGIC;
	SIGNAL MemtoReg_EX, RegWrite_EX 	: STD_LOGIC;
	SIGNAL ALUOp						: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL write_register_address_0_EX 	: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_register_address_1_EX 	: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL read_register_1_address_EX 	: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL read_register_2_address_EX 	: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_register_address_EX 	: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL BinputForward_EX				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_1_EX 				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2_EX 				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_extend_EX 				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALU_result_EX 				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALUinputA_EX 				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALUinputB_EX 				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Instruction_EX				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
	-- MEM
	SIGNAL MemRead_MEM, MemWrite_MEM 	: STD_LOGIC;
	SIGNAL MemtoReg_MEM, RegWrite_MEM 	: STD_LOGIC;
	SIGNAL write_register_address_MEM 	: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_data_MEM				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Address_MEM 					: STD_LOGIC_VECTOR( MemWidth-1 DOWNTO 0 );
	SIGNAL read_data_MEM				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALU_result_MEM 				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Instruction_MEM				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
	
	-- WB
	SIGNAL MemtoReg_WB,RegWrite_WB 		: STD_LOGIC;
	SIGNAL write_register_address_WB 	: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL read_data_WB					: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL write_data_WB				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALU_result_WB 				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Instruction_WB				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
BEGIN					

	-------------- DEBUG FF --------------
	Break: PROCESS(reset,ena_INPUT)
		BEGIN
			IF (reset = '0') THEN
				PBADD_Reg <= X"00" & B"00";
			ELSIF (ena_INPUT = '0') THEN -- need to back
				PBADD_Reg(9 DOWNTO 2) <= PBADD;
				PBADD_Reg(1 DOWNTO 0) <= "00";
			END IF;
	END PROCESS Break;
	
	DEBUG: PROCESS(clock, reset)
		BEGIN
			IF (reset = '0') THEN
				STCNT_Reg	<= X"00";
				FHCNT_Reg 	<= X"00";
				CLKCNT_Reg 	<= X"0000";
				BreakPoint 	<= '0';
			ELSIF (rising_edge(clock)) THEN
				IF (ena = '1') THEN
					CLKCNT_Reg <= CLKCNT_Reg + 1;
					IF (PcSrc = '1') THEN
						FHCNT_Reg 	<= FHCNT_Reg + 1;
					END IF;
					IF (stall = '1') THEN
						STCNT_Reg 	<= STCNT_Reg + 1;
					END IF;
					IF (PBADD_Reg = PC and PBADD_Reg /= (X"00" & B"00")) THEN
						BreakPoint <= '1';
					ELSE
						BreakPoint <= '0';
					END IF;
				END IF;
			END IF;
			STCNT  <= STCNT_Reg;
			FHCNT  <= FHCNT_Reg;
			CLKCNT <= CLKCNT_Reg;
	END PROCESS DEBUG;
	
					
	-------------- Pipeline FF (With Stall) --------------
	
	----- IF/ID (With Stall&Flush):
	IF_ID: PROCESS(clock)
		BEGIN
			IF (rising_edge(clock)) THEN
				IF (ena = '1') THEN
					IF (PcSrc = '1') THEN      -- Flush!!
						Instruction_ID 	<= X"00000000";
						PC_plus_4_ID 	<= "0000000000";
					ELSIF (stall = '0') THEN
						Instruction_ID 	<= Instruction_IF;
						PC_plus_4_ID 	<= PC_plus_4_IF;
					END IF;
				END IF;
			END IF;
	END PROCESS IF_ID;
	
	---- ID/EX (With Stall):
	ID_EX: PROCESS(clock)
		BEGIN
			IF (rising_edge(clock)) THEN
				IF (ena = '1') THEN
					Instruction_EX				<= Instruction_ID;
					write_register_address_0_EX <= write_register_address_0_ID;
					write_register_address_1_EX <= write_register_address_1_ID;
					Sign_extend_EX 				<= Sign_extend_ID;
					read_data_1_EX 				<= read_data_1_ID;
					read_data_2_EX 				<= read_data_2_ID;
					
					--Forwarding Unit
					read_register_1_address_EX 	<= read_register_1_address_ID;
					read_register_2_address_EX 	<= read_register_2_address_ID;
					IF (Stall = '0') THEN
						-- Control WB
						MemtoReg_EX <= MemtoReg_ID;
						RegWrite_EX <= RegWrite_ID;
						-- Control MEM
						MemRead_EX 	<= MemRead_ID;
						MemWrite_EX <= MemWrite_ID;
						-- Control EX
						RegDst_EX 	<= RegDst_ID;
						ALUSrc_EX 	<= ALUSrc_ID;
						ALUOp_EX 	<= ALUOp_ID;
					ELSIF (Stall = '1') THEN
						-- Control WB
						MemtoReg_EX <= '0';
						RegWrite_EX <= '0';
						-- Control MEM
						MemRead_EX 	<= '0';
						MemWrite_EX <= '0';
						-- Control EX
						RegDst_EX 	<= '0';
						ALUSrc_EX 	<= '0';
						ALUOp_EX 	<= "00";
					END IF;
				END IF;
			END IF;
	END PROCESS ID_EX;	
	
	---- EX/MEM:
	EX_MEM: PROCESS(clock)
		BEGIN
			IF (rising_edge(clock)) THEN
				IF (ena = '1') THEN
					Instruction_MEM				<= Instruction_EX;
					ALU_Result_MEM 				<= ALU_Result_EX;
					write_data_MEM 				<= BinputForward_EX;
					write_register_address_MEM 	<= write_register_address_EX;
					
					-- Control WB
					RegWrite_MEM 	<= RegWrite_EX;
					MemtoReg_MEM 	<= MemtoReg_EX;
					-- Control MEM
					MemWrite_MEM 	<= MemWrite_EX;
					MemRead_MEM 	<= MemRead_EX;
				END IF;
			END IF;
	END PROCESS EX_MEM;	
	
	---- MEM/WB:
	MEM_WB: PROCESS(clock)
		BEGIN
			IF (rising_edge(clock)) THEN
				IF (ena = '1') THEN
					Instruction_WB				<= Instruction_MEM;
					ALU_Result_WB 				<= ALU_Result_MEM;
					write_register_address_WB 	<= write_register_address_MEM;
					read_data_WB 				<= read_data_MEM;
					
					-- Control WB
					RegWrite_WB 	<= RegWrite_MEM;
					MemtoReg_WB 	<= MemtoReg_MEM;
				END IF;
			END IF;
	END PROCESS MEM_WB;
	
	
	------------------ PORT MAP -----------------
  IFE : Ifetch
	GENERIC MAP (MemWidth 	=> MemWidth,
				SIM 		=> SIM )
	PORT MAP (	Instruction 	=> Instruction_IF,
    	    	PC_plus_4_out 	=> PC_plus_4_IF,
				Add_result 		=> Add_Result_ID,
				PcSrc 			=> PcSrc,
				PC_out 			=> PC,
				ena				=> ena,		
				Stall			=> Stall,					
				clock 			=> clock,  
				reset 			=> reset );

   ID : Idecode
   	PORT MAP (	read_data_1 				=> read_data_1_ID,
        		read_data_2 				=> read_data_2_ID,
        		Instruction 				=> Instruction_ID,
				RegWrite 					=> RegWrite_WB,
				Sign_extend 				=> Sign_extend_ID,
        		clock 						=> clock,  
				reset 						=> reset,
				write_data					=> write_data_WB,
				write_register_address 		=> write_register_address_WB,
				write_register_address_0 	=> write_register_address_0_ID,
				write_register_address_1 	=> write_register_address_1_ID,
				read_register_1_address		=> read_register_1_address_ID,
				read_register_2_address 	=> read_register_2_address_ID,
				
				-- Hazard
				MemRead_EX 					=> MemRead_EX,
				MemRead_MEM					=> MemRead_MEM,
				RegWrite_EX					=> RegWrite_EX,
				write_register_address_0_EX => write_register_address_0_EX,
				Stall 						=> Stall,
				-- Forwarding For Branch
				ALU_Result_MEM 				=> ALU_Result_MEM,
				write_data_WB 				=> write_data_WB,
				write_R_add_MEM 			=> write_register_address_MEM,
				write_R_add_WB 				=> write_register_address_WB,
				RegWrite_MEM 				=> RegWrite_MEM,
				RegWrite_WB 				=> RegWrite_WB,
				-- Branch
				PC_plus_4 					=> PC_plus_4_ID,
				Add_Result 					=> Add_Result_ID,
				PcSrc 						=> PcSrc,
				Branch 						=> Branch_ID
			);

   CTL:   control
	PORT MAP ( 	Opcode 			=> Instruction_ID( 31 DOWNTO 26 ),
				RegDst 			=> RegDst_ID,
				ALUSrc 			=> ALUSrc_ID,
				MemtoReg 		=> MemtoReg_ID,
				RegWrite 		=> RegWrite_ID,
				MemRead 		=> MemRead_ID,
				MemWrite 		=> MemWrite_ID,
				Branch 			=> Branch_ID,
				ALUOp 			=> ALUOp_ID,
				Stall 			=> Stall,
                clock 			=> clock,
				reset 			=> reset 
			);

   EX:  Execute
   	PORT MAP (	Read_data_1 				=> read_data_1_EX,
             	Read_data_2 				=> read_data_2_EX,
				BinputForward				=> BinputForward_EX,
				Sign_extend 				=> Sign_extend_EX,
				ALUOp 						=> ALUOp_EX,
				ALUSrc 						=> ALUSrc_EX,
                ALU_Result					=> ALU_Result_EX,
				ALUinputA					=> ALUinputA_EX,
				ALUinputB					=> ALUinputB_EX,
				write_register_address_0 	=> write_register_address_0_EX,
				write_register_address_1 	=> write_register_address_1_EX,
				write_register_address 		=> write_register_address_EX,
				RegDst 						=> RegDst_EX,
                Clock						=> clock,
				Reset						=> reset,
				
				-- Forwarding For ALU
				ALU_Result_MEM 				=> ALU_Result_MEM,
				write_data_WB 				=> write_data_WB,
				read_register_1_address 	=> read_register_1_address_EX,
				read_register_2_address 	=> read_register_2_address_EX,
				write_R_add_MEM 			=> write_register_address_MEM,
				write_R_add_WB 				=> write_register_address_WB,
				RegWrite_MEM 				=> RegWrite_MEM,
				RegWrite_WB 				=> RegWrite_WB
			);
				
   MEM:  dmemory
   	GENERIC MAP (MemWidth 	=> MemWidth,
				SIM 		=> SIM )
	PORT MAP (	read_data 		=> read_data_MEM,
				Address_MEM		=> Address_MEM,
				ALU_Result_MEM	=> ALU_Result_MEM,
				write_data 		=> write_data_MEM,
				MemRead 		=> MemRead_MEM, 
				Memwrite 		=> MemWrite_MEM,
                clock 			=> clock,  
				reset 			=> reset
			);

   WB: WriteBack
	PORT MAP (	ALU_result	=>	ALU_result_WB,
				read_data	=>	read_data_WB,
				MemtoReg	=>	MemtoReg_WB,
				write_data	=>	write_data_WB 
			);
END structure;

