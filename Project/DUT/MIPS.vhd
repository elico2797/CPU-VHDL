				-- Top Level Structural Model for MIPS Processor Core
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY MIPS IS
	
	GENERIC(MemWidth	: INTEGER := 10;
			SIM 		: BOOLEAN := FALSE
	);
	PORT( 	reset 				: IN 	STD_LOGIC; 
			clock				: IN 	STD_LOGIC;
			-- MCU Bus I/O
			MemReadBus 	    		: OUT		STD_LOGIC; 
        	MemWriteBus 	        : OUT		STD_LOGIC;
        	AddressBus 	        	: OUT 		STD_LOGIC_VECTOR(11 DOWNTO 0);
			--DataIN_MIPS     		: IN 		STD_LOGIC_VECTOR(31 DOWNTO 0);
			DataBus					: INOUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);		
			INTA					: OUT 		STD_LOGIC;
			GIE						: OUT       STD_LOGIC;
			enable 					: IN 		STD_LOGIC;
			INTR					: IN 		STD_LOGIC
			--DataOUT_MIPS     		: OUT 		STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
	
END 	MIPS;

ARCHITECTURE structure OF MIPS IS

	COMPONENT Ifetch
		GENERIC(MemWidth	: INTEGER;
				SIM 		: BOOLEAN
		);
		PORT(	Instruction 	: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
				NextPc_Out		: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
				PC_plus_4_OUT 	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
				PC_out 			: OUT	STD_LOGIC_VECTOR(9 DOWNTO 0);
				Ret_Add 		: IN	STD_LOGIC_VECTOR(9 DOWNTO 0);
				Sign_extend 	: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
				Zero  			: IN 	STD_LOGIC;
				Branch 			: IN	STD_LOGIC_VECTOR(1 DOWNTO 0);
				jump 			: IN 	STD_LOGIC_VECTOR(1 DOWNTO 0);
				clock, reset 	: IN 	STD_LOGIC;
				IV_Add			: IN	STD_LOGIC_VECTOR(11 DOWNTO 0); -- ADDRESS BUS
				IVCall			: IN 	STD_LOGIC;
				enable 			: IN	STD_LOGIC;
				INTA			: IN 	STD_LOGIC;
				PCHold			: IN 	STD_LOGIC
		);
	END COMPONENT; 

	COMPONENT Idecode
		PORT(	read_data_1	: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
				read_data_2	: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
				Sign_extend : OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
				IVCall		: IN 	STD_LOGIC;
				PC_plus_4_OUT 	: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
				Shamt		: OUT 	STD_LOGIC_VECTOR(4 DOWNTO 0);
				Instruction : IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
				DataBusToReg : IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
				ALU_result	: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
				NextPc	 	: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
				RegWrite 	: IN 	STD_LOGIC;
				MemtoReg 	: IN 	STD_LOGIC_VECTOR(2 DOWNTO 0);
				RegDst 		: IN 	STD_LOGIC_VECTOR(1 DOWNTO 0);
				clock,reset	: IN 	STD_LOGIC;
				Jump		: IN 	STD_LOGIC_VECTOR(1 downto 0);
				INTR		: IN 	STD_LOGIC;
				GIE			: OUT 	STD_LOGIC
		);
	END COMPONENT;

	COMPONENT control
		PORT( 	Opcode 		: IN 	STD_LOGIC_VECTOR(5 DOWNTO 0);
				Funct		: IN 	STD_LOGIC_VECTOR(5 DOWNTO 0);
				ALUop 		: OUT 	STD_LOGIC_VECTOR(3 DOWNTO 0);
				Branch 		: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0);
				RegDst 		: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0);
				ALUSrc 		: OUT 	STD_LOGIC;
				MemtoReg 	: OUT 	STD_LOGIC_VECTOR(2 DOWNTO 0);
				RegWrite 	: OUT 	STD_LOGIC;
				MemRead 	: OUT 	STD_LOGIC;
				MemWrite 	: OUT 	STD_LOGIC;
				jump 		: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0);	
				clock,reset	: IN 	STD_LOGIC;
				INTA_OUT		: OUT   STD_LOGIC;
				INTR        : IN 	STD_LOGIC;
				IVCall_OUT		: OUT   STD_LOGIC;
				PCHold      : OUT   STD_LOGIC
		);
	END COMPONENT;

	COMPONENT  Execute
		PORT(	--clock, reset	: IN 	STD_LOGIC
				ALUSrc 			: IN 	STD_LOGIC;
				ALUOp 			: IN 	STD_LOGIC_VECTOR(3 DOWNTO 0);
				Func_op 		: IN 	STD_LOGIC_VECTOR(5 DOWNTO 0);
				Read_data_1 	: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
				Read_data_2 	: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
				Sign_extend 	: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
				Shamt			: IN 	STD_LOGIC_VECTOR(4 DOWNTO 0);
				Zero 			: OUT	STD_LOGIC;
				Add_result		: OUT	STD_LOGIC_VECTOR(11 DOWNTO 0);
				ALU_Result 		: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
				
		);
	END COMPONENT;

	COMPONENT dmemory
		GENERIC(MemWidth	: INTEGER;
				SIM 		: BOOLEAN
		);
		PORT(	clock,reset			: IN 	STD_LOGIC;
				Memwrite 			: IN 	STD_LOGIC;
				MemRead			 	: IN 	STD_LOGIC; -- DO NOTHING!!
				Address 			: IN 	STD_LOGIC_VECTOR(11 DOWNTO 0);
				write_data 			: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
				read_data 			: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL NextPc 			: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL read_data_1 		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL read_data_2 		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Sign_Extend 		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Add_result 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL ALU_result 		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL read_data 		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL DataBusToReg 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ALUSrc 			: STD_LOGIC;
	SIGNAL Bne 				: STD_LOGIC;
	SIGNAL Shamt 			: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL Beq 				: STD_LOGIC;
	SIGNAL jump 			: STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL J_format 		: STD_LOGIC;
	SIGNAL Branch 			: STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL RegDst 			: STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL Regwrite 		: STD_LOGIC;
	SIGNAL Zero 			: STD_LOGIC;
	SIGNAL MemWrite 		: STD_LOGIC;
	SIGNAL MemtoReg 		: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL MemRead 			: STD_LOGIC;
	SIGNAL ALUop 			: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Instruction		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Address			: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL INTA_signal		:  STD_LOGIC;
	--SIGNAL INTR_signal		:  STD_LOGIC;
	SIGNAL IVCall			: STD_LOGIC;
	SIGNAL GIE_signal				: STD_LOGIC;
	SIGNAL PCHold            : STD_LOGIC;
	SIGNAL PC_plus_4_OUT    : STD_LOGIC_VECTOR(7 downto 0);
	

BEGIN

	-- MCU Bus
	MemReadBus	<= MemRead;
	MemWriteBus	<= MemWrite;
	GIE	<= GIE_signal;
	INTA <= INTA_signal;
	AddressBus	<= Address WHEN (INTA_signal = '0') ELSE X"82E";  --WHEN (MemRead = '1' OR MemWrite = '1') ELSE (OTHERS => 'Z');
	DataBusToReg   <= DataBus WHEN (Add_result(11) = '1') ELSE read_data;
	DataBus 	   <= read_data_2 WHEN (Add_result(11) = '1' and MemWrite ='1') ElSE (OTHERS => 'Z');
	Address        <= Add_result WHEN (INTA_signal = '0') ELSE DataBus(11 DOWNTO 0) ; -- change from INTA_signal --- maybe work....
   
					-- connect the 5 MIPS components   
  IFE : Ifetch
	GENERIC MAP(MemWidth 		=> MemWidth,
				SIM 			=> SIM )
	PORT MAP (	Instruction 	=> Instruction,
    	    	NextPc_out 		=> NextPc,
				Sign_extend 	=> Sign_extend,
				Branch			=> Branch,
				PC_plus_4_OUT	=> PC_plus_4_OUT,
				Zero 			=> Zero,
				jump			=> jump,
				clock 			=> clock,
				IV_Add			=> read_data(11 downto 0),
				PCHold			=> PCHold,
				enable  		=> enable,
				Ret_Add 		=>	read_data_1(9 downto 0),
				IVCall			=>	IVCall,
				INTA			=>  INTA_signal,
				reset 			=> 	reset );

   ID : Idecode
   	PORT MAP (	read_data_1 	=> read_data_1,
        		read_data_2 	=> read_data_2,
        		Instruction 	=> Instruction,
				IVCall			=>	IVCall,
				Shamt			=> Shamt,
        		DataBusToReg 	=> DataBusToReg,
				PC_plus_4_OUT	=> PC_plus_4_OUT,
				NextPc			=> NextPc,
				ALU_result 		=> ALU_result,
				RegWrite 		=> RegWrite,
				Jump			=> Jump,
				MemtoReg 		=> MemtoReg,
				RegDst 			=> RegDst,
				Sign_extend 	=> Sign_extend,
        		clock 			=> clock,  
				INTR			=> INTR,
				GIE				=> GIE_signal,
				reset 			=> reset );


   CTL:   control
	PORT MAP ( 	Opcode 			=> Instruction(31 DOWNTO 26),
				Funct 			=> Instruction(5 DOWNTO 0),
				RegDst 			=> RegDst,
				ALUSrc 			=> ALUSrc,
				MemtoReg 		=> MemtoReg,
				RegWrite 		=> RegWrite,
				MemRead 		=> MemRead,
				MemWrite 		=> MemWrite,
				Branch 			=> Branch,
				jump			=> jump,
				ALUop 			=> ALUop,
                clock 			=> clock,
				INTA_OUT			=> INTA_signal,
				INTR			=> INTR,
				IVCall_OUT			=> IVCall,
				PCHold      	=> PCHold,
				reset 			=> reset );

   EXE:  Execute
   	PORT MAP (	Read_data_1 	=> read_data_1,
             	Read_data_2 	=> read_data_2,
				Sign_extend 	=> Sign_extend,
				Shamt			=> Shamt,
                Func_op			=> Instruction(5 DOWNTO 0),
				ALUOp 			=> ALUop,
				ALUSrc 			=> ALUSrc,
				Zero 			=> Zero,
				Add_result		=> Add_result,
                ALU_Result		=> ALU_Result );
 

   MEM:  dmemory
	GENERIC MAP(MemWidth 	=> MemWidth,
				SIM 		=> SIM )
	PORT MAP (	read_data 		=> read_data,
				Address 		=> Address,
				write_data 		=> read_data_2,
				MemRead 		=> MemRead, 
				Memwrite 		=> MemWrite, 
                clock 			=> clock,  
				reset 			=> reset );
END structure;

