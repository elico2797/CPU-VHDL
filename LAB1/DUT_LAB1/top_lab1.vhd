LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY top IS
  GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  PORT (  Y,X: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		  ALUout: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag,Cflag,Zflag: OUT STD_LOGIC ); -- Zflag,Cflag,Nflag
END top;
------------- complete the top Architecture code --------------
ARCHITECTURE struct OF top IS 

	signal x_add_in,y_add_in,x_shift_in,y_shift_in,x_logic_in,y_logic_in: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	signal addersub_out,shiter_out,logic_out: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	signal c_addersub_out, c_shifter_out: STD_LOGIC;
	signal z_check, ALU_OUT_1: STD_LOGIC_VECTOR(n-1 DOWNTO 0);

BEGIN
	
	x_add_in <= X when ALUFN(4 downto 3) = "01" else unaffected;
	y_add_in <= Y when ALUFN(4 downto 3) = "01" else unaffected;
	
	x_shift_in <= X when ALUFN(4 downto 3) = "10" else unaffected;
	y_shift_in <= Y when ALUFN(4 downto 3) = "10" else unaffected;
	
	x_logic_in <= X when ALUFN(4 downto 3) = "11" else unaffected;
	y_logic_in <= Y when ALUFN(4 downto 3) = "11" else unaffected;
	
	ALU_addsub :AdderSub generic map(n) port map(x => x_add_in, y => y_add_in, SubControl => ALUFN(1 downto 0),
												  output => addersub_out, cout => c_addersub_out);
												  
	ALU_shifter :Shifter generic map(n,k) port map(x => x_shift_in, y => y_shift_in, dir => ALUFN(1 downto 0),
												    output => shiter_out, cout => c_shifter_out);
												    
	ALU_logic : Logic generic map(n) port map(x => x_logic_in, y => y_logic_in, ALU_logi => ALUFN(2 downto 0),
												  logical_out => logic_out);
	
	
	with ALUFN(4 downto 3) select
		ALU_OUT_1 <= addersub_out when "01",
				  shiter_out when "10",
				  logic_out when "11",
				  unaffected when others;
				  
	with ALUFN(4 downto 3) select
		Cflag <= c_addersub_out when "01",
				 c_shifter_out when "10",
				 '0' when "11",
				 unaffected when others;
				 
	Nflag <= ALU_OUT_1(n-1);
	
	z_check(0) <= ALU_OUT_1(0);
	G_z: for i in 1 to n-1 generate
		z_check(i) <= ALU_OUT_1(i) or z_check(i-1);
	end generate;
	
	Zflag <= not(z_check(n-1));
	ALUout <= ALU_OUT_1;
		
			 
END struct;

