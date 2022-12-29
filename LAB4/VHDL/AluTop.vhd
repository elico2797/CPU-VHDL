LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY AluTop IS
  GENERIC (n 					:INTEGER := 8;
		   k 					:integer := 3;  -- k=log2(n)
		   m 					:integer := 4	-- m=2^(k-1)
		   ); 
  PORT (  Y,X						:IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN 					:IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		  x_add_in,y_add_in			:BUFFER STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		  x_shift_in,y_shift_in		:BUFFER STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		  x_logic_in,y_logic_in		:BUFFER STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		  ALUout					:OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag,Cflag,Zflag			:OUT STD_LOGIC 							-- Zflag,Cflag,Nflag
		  ); 
END AluTop;
------------- complete the top Architecture code --------------
ARCHITECTURE struct OF AluTop IS 

	signal addersub_out,shiter_out,logic_out	:STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	signal c_addersub_out,c_shifter_out			:STD_LOGIC;
	signal ALUout_Sig							:STD_LOGIC_VECTOR(n-1 DOWNTO 0);

BEGIN
	
	x_add_in 	<= X when ALUFN(4 downto 3) = "01" else x_add_in;
	y_add_in 	<= Y when ALUFN(4 downto 3) = "01" else y_add_in;
	
	x_shift_in 	<= X when ALUFN(4 downto 3) = "10" else x_shift_in;
	y_shift_in 	<= Y when ALUFN(4 downto 3) = "10" else y_shift_in;
	
	x_logic_in	<= X when ALUFN(4 downto 3) = "11" else x_logic_in;
	y_logic_in 	<= Y when ALUFN(4 downto 3) = "11" else y_logic_in;
	
	ALU_addsub :AdderSub generic map(n) port map(x => x_add_in, y => y_add_in, SubControl => ALUFN(1 downto 0),
												  output => addersub_out, cout => c_addersub_out);
												  
	ALU_shifter :Shifter generic map(n,k) port map(x => x_shift_in, y => y_shift_in, dir => ALUFN(1 downto 0),
												    output => shiter_out, cout => c_shifter_out);
												    
	ALU_logic : Logic generic map(n) port map(x => x_logic_in, y => y_logic_in, ALU_logi => ALUFN(2 downto 0),
												  logical_out => logic_out);
	
	ALUout_Sig 	<= 	addersub_out 	when ALUFN(4 downto 3) = "01" else
					shiter_out 		when ALUFN(4 downto 3) = "10" else
					logic_out;
				  

	Cflag 	<= 	c_addersub_out	when ALUFN(4 downto 3) = "01" else
				c_shifter_out 	when ALUFN(4 downto 3) = "10" else
				'0';
				 
	Nflag 	<= 	ALUout_Sig(n-1);
	
	Zflag	<= not(ALUout_Sig(0) or ALUout_Sig(1) or ALUout_Sig(2) or ALUout_Sig(3) or
				   ALUout_Sig(4) or ALUout_Sig(5) or ALUout_Sig(6) or ALUout_Sig(7)); 
	
	ALUout <= ALUout_Sig;

---- z check optio 2: ------
	-- Zflag	<=	'1' when ALUout_Sig = "00000000" else
	-- 			'0';
	
---- z check optio 1: ------
	-- z_check(0) <= ALU_OUT_1(0);
	-- G_z: for i in 1 to n-1 generate
	-- 	z_check(i) <= ALU_OUT_1(i) or z_check(i-1);
	-- end generate;
	
	-- Zflag <= not(z_check(n-1));

			 
END struct;

