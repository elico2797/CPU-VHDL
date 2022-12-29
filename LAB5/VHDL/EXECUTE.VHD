--  Execute Stage --

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY  Execute IS
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
		
		-- Forwarding For ALU
		RegWrite_MEM			 : IN 	STD_LOGIC;
		RegWrite_WB				 : IN 	STD_LOGIC;
		read_register_1_address  : IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		read_register_2_address  : IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		write_R_add_MEM 		 : IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		write_R_add_WB 			 : IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		ALU_Result_MEM			 : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		write_data_WB			 : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 )
	);
END Execute;

ARCHITECTURE behavior OF Execute IS

	SIGNAL Ainput, Binput 				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALU_output_mux				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALU_ctl						: STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL Function_opcode 				: STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	SIGNAL ForwardA						: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL ForwardB						: STD_LOGIC_VECTOR( 1 DOWNTO 0 );

BEGIN
	
	Function_opcode <= Sign_extend(5 DOWNTO 0 );
	
	-- Mux for Register Write Address (destanetion Register - Rd)
	write_register_address <= write_register_address_1 
			WHEN RegDst = '1' ELSE write_register_address_0;
	
	-- ALU A input MUX (With Forwarding)
	Ainput <= ALU_Result_MEM WHEN (ForwardA = "10")
			ELSE write_data_WB WHEN (ForwardA = "01")
			ELSE Read_data_1;
	ALUinputA <= Ainput;
	
	-- ALU B input MUX (With Forwarding)
	BinputForward <= ALU_Result_MEM WHEN (ForwardB = "10")
				ELSE write_data_WB WHEN (ForwardB = "01")
				ELSE Read_data_2;
	
	Binput <= BinputForward WHEN ( ALUSrc = '0' ) 
			ELSE  Sign_extend( 31 DOWNTO 0 );
	ALUinputB <= Binput;
	
	-- Generate ALU control bits
	ALU_ctl( 0 ) <= ( Function_opcode( 0 ) OR Function_opcode( 3 ) ) AND ALUOp(1 );
	ALU_ctl( 1 ) <= ( NOT Function_opcode( 2 ) ) OR (NOT ALUOp( 1 ) );
	ALU_ctl( 2 ) <= ( Function_opcode( 1 ) AND ALUOp( 1 )) OR ALUOp( 0 );  
	
	-- ALU output MUX for slt/slti OPERATION       
	ALU_result <= X"0000000" & B"000"  & ALU_output_mux( 31 )
			WHEN  ALU_ctl = "111" 
			ELSE  	ALU_output_mux( 31 DOWNTO 0 );

	--- ALU Unit --
	PROCESS ( ALU_ctl, Ainput, Binput )
		BEGIN
						-- Select ALU operation
		CASE ALU_ctl IS
							-- ALU performs ALUresult = A_input AND B_input
			WHEN "000" 	=>	ALU_output_mux 	<= Ainput AND Binput; 
							-- ALU performs ALUresult = A_input OR B_input
			WHEN "001" 	=>	ALU_output_mux 	<= Ainput OR Binput;
							-- ALU performs ALUresult = A_input + B_input
			WHEN "010" 	=>	ALU_output_mux 	<= Ainput + Binput;
							-- ALU performs ?
			WHEN "011" 	=>	ALU_output_mux <= X"00000000";
							-- ALU performs ?
			WHEN "100" 	=>	ALU_output_mux 	<= X"00000000";
							-- ALU performs ?
			WHEN "101" 	=>	ALU_output_mux 	<= X"00000000";
							-- ALU performs ALUresult = A_input -B_input
			WHEN "110" 	=>	ALU_output_mux 	<= Ainput - Binput;
							-- ALU performs SLT
			WHEN "111" 	=>	ALU_output_mux 	<= Ainput - Binput ;
			WHEN OTHERS	=>	ALU_output_mux 	<= X"00000000" ;
		END CASE;
	END PROCESS;

	-- Forwarding For ALU Unit
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

