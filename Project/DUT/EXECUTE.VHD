--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY  Execute IS
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
END Execute;

ARCHITECTURE behavior OF Execute IS
	
	--SIGNAL ALU_Mul				: STD_LOGIC_VECTOR(63 DOWNTO 0);
	SIGNAL ALU_Mul				: STD_LOGIC_VECTOR(63 DOWNTO 0);

	SIGNAL Ainput, Binput 		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ALU_output_mux		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ALU_ctl				: STD_LOGIC_VECTOR(3 DOWNTO 0);
	
BEGIN

	-- ALU input mux
	Ainput <= Read_data_1;
	Binput <= Read_data_2 WHEN (ALUSrc = '0') ELSE
			  Sign_extend(31 DOWNTO 0);
		

	ALU_ctl(0)	 <= (ALUOp(3) AND Func_op(1)) OR (NOT(ALUOp(3)) AND ALUOp(0));
	ALU_ctl(1)	 <= (ALUOp(3) AND ((Func_op(5) AND (NOT(Func_op(2)))) OR (Func_op(2) AND NOT(Func_op(0)) AND NOT(Func_op(1))))) OR (NOT(ALUOp(3)) AND NOT(ALUOp(2) XOR ALUOp(1)));
	ALU_ctl(2)	 <= (ALUOp(3) AND (Func_op(3) or Func_op(2))) OR (NOT(ALUOp(3)) AND ALUOp(2));
	ALU_ctl(3)	 <= (ALUOp(3) AND (NOT(Func_op(5))));

	
	
	-- Generate Zero Flag
	Zero <= '1' WHEN (ALU_output_mux(31 DOWNTO 0) = X"00000000") ELSE
			'0';   
				
	-- Select ALU output        
	ALU_result <= X"0000000" & B"000"  & ALU_output_mux(31) WHEN  (ALU_ctl = "0111")  -- For STL
					ELSE ALU_output_mux(31 DOWNTO 0);
					
	-- ALU output For Memory Access
	Add_result <= ALU_output_mux(11 DOWNTO 0);
					
	--ALU_Mul	<= Ainput * Binput;
	ALU_Mul	<= Ainput * Binput;
	
PROCESS ( ALU_ctl, Ainput, Binput, ALU_Mul)
	BEGIN
	-- Select ALU operation
 	CASE ALU_ctl IS
		WHEN "0000" 	=>	ALU_output_mux 	<= ALU_Mul(31 DOWNTO 0);
						-- ALUresult = A_input * B_input
		WHEN "0010" 	=>	ALU_output_mux 	<= Ainput + Binput; 
						-- ALUresult = A_input - B_input
     	WHEN "0011" 	=>	ALU_output_mux 	<= Ainput - Binput;
						-- ALUresult = A_input OR B_input
	 	WHEN "0100" 	=>	ALU_output_mux 	<= Ainput OR Binput;
						-- ALUresult = A_input XOR B_input
 	 	WHEN "0101" 	=>	ALU_output_mux <= Ainput XOR Binput;
						-- ALUresult = A_input AND B_input
 	 	WHEN "0110" 	=>	ALU_output_mux 	<= Ainput AND Binput;
						-- SLT
 	 	WHEN "0111" 	=>	ALU_output_mux 	<= Ainput - Binput;
						-- SLL
 	 	WHEN "1000" 	=>	ALU_output_mux 	<= std_logic_vector((unsigned(Binput) sll to_integer(unsigned(Shamt))));
		---std_logic_vector(shift_left(unsigned(Ainput) to_integer(unsigned(Binput(10 DOWNTO 6)))));
						-- SRL
  	 	WHEN "1001" 	=>	ALU_output_mux 	<= std_logic_vector((unsigned(Binput) srl to_integer(unsigned(Shamt))));
						-- ALUresult = A_input * B_input
		--WHEN "1010" 	=>	ALU_output_mux 	<= std_logic_vector(unsigned(Ainput) * unsigned(Binput)) ;
 	 	WHEN OTHERS	=>	ALU_output_mux 	<= X"00000000" ;
  	END CASE;
END PROCESS;
  
END behavior;