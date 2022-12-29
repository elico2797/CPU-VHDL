-- Aux Packege for MIPS Processor --
library IEEE;
use ieee.std_logic_1164.all;
package aux_package is
---------------------------------------------------------	
	COMPONENT MIPS
		GENERIC (MemWidth	 : INTEGER := 10;
				 SIM 		 : BOOLEAN := FALSE
		);
		PORT( 
			ena					: IN 	STD_LOGIC; 
			ena_INPUT			: IN 	STD_LOGIC;
			reset				: IN 	STD_LOGIC;
			clock				: IN 	STD_LOGIC; 
			BreakPoint			: OUT 	STD_LOGIC;

			--- Debug FF
			FHCNT				: BUFFER STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			STCNT				: BUFFER STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			PBADD				: IN 	 STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			CLKCNT				: BUFFER STD_LOGIC_VECTOR( 15 DOWNTO 0 )
		);
	END COMPONENT;
	
	COMPONENT Ifetch
		GENERIC (MemWidth	: INTEGER;
				 SIM 		: BOOLEAN
		);
		PORT(	
			clock, reset 	: IN 	STD_LOGIC;
			Stall 			: IN 	STD_LOGIC;
			ena				: IN 	STD_LOGIC;
			PcSrc 			: IN 	STD_LOGIC;
			Add_result 		: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			PC_plus_4_out 	: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			PC_out 			: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 ); -- only for modelsim
			Instruction 	: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 )
		);
	END COMPONENT; 

	COMPONENT Idecode
		PORT(	
			clock,reset				 	: IN 		STD_LOGIC;
			Instruction 			 	: IN 		STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Sign_extend 			 	: BUFFER 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			write_register_address_1 	: OUT 		STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			write_register_address_0 	: OUT 		STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			-- Register File Unit
			RegWrite 				 	: IN 		STD_LOGIC;
			write_register_address 	 	: IN 		STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			write_data				 	: IN 		STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_register_1_address  	: BUFFER 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			read_register_2_address  	: BUFFER 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			read_data_1				 	: BUFFER 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data_2				 	: BUFFER 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			-- Hazard
			MemRead_EX, MemRead_MEM	 	: IN 		STD_LOGIC;
			RegWrite_EX					: IN 	 	STD_LOGIC;
			write_register_address_0_EX : IN 		STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			Stall 					 	: BUFFER 	STD_LOGIC;
			-- Forwarding For Branch
			RegWrite_MEM			 	: IN 		STD_LOGIC;
			RegWrite_WB				 	: IN 		STD_LOGIC;
			write_R_add_MEM 		 	: IN 		STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			write_R_add_WB 			 	: IN 		STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			ALU_Result_MEM			 	: IN 		STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			write_data_WB			 	: IN 		STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			-- Branch
			Branch					 	: IN 		STD_LOGIC;
			PC_plus_4 				 	: IN 		STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			PcSrc					 	: OUT 		STD_LOGIC;
			Add_Result 				 	: OUT		STD_LOGIC_VECTOR( 7 DOWNTO 0 )
		);
	END COMPONENT;

	COMPONENT control
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
	END COMPONENT;

	COMPONENT  Execute
		PORT(	
			clock, reset			 : IN 	STD_LOGIC;
			ALUSrc 					 : IN 	STD_LOGIC;
			RegDst 					 : IN   STD_LOGIC;
			ALUOp 					 : IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			write_register_address_1 : IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			write_register_address_0 : IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			Read_data_1 			 : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Read_data_2 			 : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Sign_extend 			 : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			BinputForward			 : BUFFER STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			write_register_address 	 : OUT 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			ALU_Result 				 : OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALUinputA				 : OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALUinputB				 : OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			
			-- Forwarding
			RegWrite_MEM			 : IN 	STD_LOGIC;
			RegWrite_WB				 : IN 	STD_LOGIC;
			read_register_1_address  : IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			read_register_2_address  : IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			write_R_add_MEM 		 : IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			write_R_add_WB 			 : IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			ALU_Result_MEM			 : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			write_data_WB			 : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 )
		);
	END COMPONENT;


	COMPONENT dmemory
		GENERIC (MemWidth	: INTEGER;
				SIM 		: BOOLEAN
		);
		PORT(	
			clock,reset				: IN 	STD_LOGIC;
			MemRead, Memwrite 		: IN 	STD_LOGIC;
			ALU_Result_MEM 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			write_data 				: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data 				: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Address_MEM 			: OUT 	STD_LOGIC_VECTOR( MemWidth-1 DOWNTO 0 )
		);
	END COMPONENT;
	
	COMPONENT WriteBack
		PORT( 	
			MemtoReg 	:IN  STD_LOGIC;
			ALU_result 	:IN  STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data	:IN  STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			write_data	:OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 )
		);
	END COMPONENT;
---------------------------------------------------------	
end aux_package;

