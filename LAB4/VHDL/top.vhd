LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY top IS
  GENERIC (n 							:INTEGER := 8;
		   k 							:integer := 3;   -- k=log2(n)
		   m 							:integer := 4	 -- m=2^(k-1)
		   );
  PORT (
		  --clk 							:IN std_logic; -- just for Signal tap
		  INPUT_switch					:IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  enaY, enaALUFN, enaX 			:IN STD_LOGIC;
		  ALUout						:OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag,Cflag,Zflag				:OUT STD_LOGIC;
		  Y_out1,Y_out0,X_out1,X_out0	:OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		  ALUFN_out 					:OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
		  Y,X							:buffer STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN			 				:buffer STD_LOGIC_VECTOR (4 DOWNTO 0)
		);
END top;
------------- complete the top Architecture code --------------
ARCHITECTURE struct OF top IS 
	
	--signal Y,X																:STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	--signal ALUFN			 												:STD_LOGIC_VECTOR (4 DOWNTO 0);
	signal ALUout_Sig														:STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	signal Cflag_Sig, Zflag_Sig, Nflag_Sig 									:STD_LOGIC;


BEGIN
	

	X 		<= 	INPUT_switch 				when (enaX = '0')		else X;
	Y 		<= 	INPUT_switch 				when (enaY = '0') 		else Y;
	ALUFN 	<= 	INPUT_switch (4 DOWNTO 0) 	when (enaALUFN = '0') 	else ALUFN;

	ALUFN_out 	<= ALUFN;
	ALUout 		<= ALUout_Sig;
	Zflag 		<= Zflag_Sig;
	Cflag 		<= Cflag_Sig;
	Nflag 		<= Nflag_Sig;
	
	labelX_out0: 	HexDecoder port map (HexOut => x_out0, 	BinaryIn => X(3 downto 0));
	labelX_out1: 	HexDecoder port map (HexOut => x_out1,	BinaryIn => X(7 downto 4));
	labelY_out0: 	HexDecoder port map (HexOut => y_out0,	BinaryIn => Y(3 downto 0));
	labelY_out1: 	HexDecoder port map (HexOut => y_out1,	BinaryIn => Y(7 downto 4));
	
	top: 			AluTop port map (X => X, Y => Y, ALUFN => ALUFN, ALUout => ALUout_Sig,
										Cflag => Cflag_Sig, Zflag => Zflag_Sig, Nflag => Nflag_Sig
									);
			 
END struct;

