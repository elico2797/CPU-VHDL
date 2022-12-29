LIBRARY ieee;
USE ieee.std_logic_1164.all;
-------------------------------------
ENTITY Logic IS
	GENERIC ( n 		:INTEGER
			);
    PORT ( X,Y			:IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	      ALU_logi		:IN STD_LOGIC_VECTOR(2 DOWNTO 0);
          logical_out	:OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
		  );
END Logic;
-------------------------------------
ARCHITECTURE Logic OF Logic IS	  
	
	SIGNAL s_output		:STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	
BEGIN

	--  return logical output according to ALU control
	with ALU_logi select
		s_output <= (NOT Y) 		WHEN "000", 
	            	(X OR Y) 		WHEN "001",   
					(X AND Y) 		WHEN "010", 
					(X XOR Y) 		WHEN "011", 
					NOT(X OR Y)	 	WHEN "100", 
					NOT(X AND Y)	WHEN others;
	
	-- send local_signal to output
	logical_out <= s_output;		  
				
END logic;
