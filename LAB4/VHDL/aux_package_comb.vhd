library IEEE;
use ieee.std_logic_1164.all;
package aux_package is
---------------------------------------------------------	
	component top is
	  GENERIC (n 							:INTEGER := 8;
			   k 							:integer := 3;   -- k=log2(n)
			   m 							:integer := 4	 -- m=2^(k-1)
			   );
	  PORT (  INPUT_switch					:IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			  enaY, enaALUFN, enaX 			:IN STD_LOGIC;
			  --clk							:IN STD_LOGIC;
			  ALUout						:OUT STD_LOGIC_VECTOR(n-1 downto 0);
			  Nflag,Cflag,Zflag				:OUT STD_LOGIC;
			  Y_out1,Y_out0,X_out1,X_out0	:OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
			  ALUFN_out 					:OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
			);
	end component;
---------------------------------------------------------	
	component AluTop is 
	  GENERIC (n 					:INTEGER := 8;
			   k 					:integer := 3;  -- k=log2(n)
			   m 					:integer := 4	-- m=2^(k-1)
			   ); 
	  PORT (  Y,X					:IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			  ALUFN 				:IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			  x_add_in,y_add_in			:BUFFER STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			  x_shift_in,y_shift_in		:BUFFER STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			  x_logic_in,y_logic_in		:BUFFER STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			  ALUout				:OUT STD_LOGIC_VECTOR(n-1 downto 0);
			  Nflag,Cflag,Zflag		:OUT STD_LOGIC 							-- Zflag,Cflag,Nflag
			  ); 
	end component;
---------------------------------------------------------	
	component FA is
		PORT (xi, yi, cin	:IN std_logic;
				  s, cout	:OUT std_logic
			);
	end component;
---------------------------------------------------------	
	component Logic 
		GENERIC ( n 		:INTEGER
				);
		PORT ( X,Y			:IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			  ALU_logi		:IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			  logical_out	:OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
			  );
	end component;
---------------------------------------------------------	
	component AdderSub
		GENERIC (n 				:INTEGER
				);
		PORT (SubControl		:IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			  Y,X				:IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			  cout				:OUT STD_LOGIC;
			  output			:OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
			  );
	end component;
---------------------------------------------------------	
	component Shifter 
		GENERIC (n 		:INTEGER;
				 k 		:INTEGER
				 );
		PORT (Y			:IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			  X			:IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			  dir		:IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			  output	:OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			  cout		:OUT STD_LOGIC
			  );
	end component;
---------------------------------------------------------	
	component HexDecoder 
	PORT (  BinaryIn			:IN STD_LOGIC_VECTOR (3 DOWNTO 0); 	-- n/2
		  HexOut				:OUT STD_LOGIC_VECTOR(6 downto 0) 
		);
	end component;
---------------------------------------------------------	
end aux_package;

