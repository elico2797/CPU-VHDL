library IEEE;
use ieee.std_logic_1164.all;
package aux_package is
--------------------------------------------------------
	component top is
	GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
	PORT (Y,X: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		  ALUout: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag,Cflag,Zflag: OUT STD_LOGIC ); -- Zflag,Cflag,Nflag
	end component;
---------------------------------------------------------  
	component FA is
	PORT (xi, yi, cin: IN std_logic;
			      s, cout: OUT std_logic);
	end component;
	component Logic GENERIC(n : INTEGER := 8); 
					port(x,y: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	      				 ALU_logi: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
          				 logical_out: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
	end component;
	---------
	component AdderSub GENERIC(n : INTEGER := 8);
						port(SubControl: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		 					x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  					cout: OUT STD_LOGIC;
	   	  					output: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
	end component;
	---------
	component Shifter GENERIC (n : INTEGER := 8; k : INTEGER := 3);	
					port(x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  				   dir: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		  				   output: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		  				   cout: OUT STD_LOGIC);
	end component;
	---------
---------------------------------------------------------	
end aux_package;

