library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------test bench for the system - 32 bits 
entity tb is
	constant n : integer := 8;
	constant k : integer := 3;   -- k=log2(n)
	constant m : integer := 4;   -- m=2^(k-1)
	constant ROWmax : integer := 11; 
end tb;
------------------------------------------------------------------------------
architecture rtb of tb is
	type mem is 						array (0 to ROWmax) of STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL INPUT_switch					:STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	SIGNAL enaY, enaALUFN, enaX 		:STD_LOGIC := '1';
	SIGNAL Y_out1,Y_out0,X_out1,X_out0	:STD_LOGIC_VECTOR (6 DOWNTO 0);	
	SIGNAL ALUFN_out 					:STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL ALUout						:STD_LOGIC_VECTOR(n-1 DOWNTO 0); 	-- ALUout[n-1:0]&Cflag
	SIGNAL Nflag,Cflag,Zflag			:STD_LOGIC; 						-- Zflag,Cflag,Nflag
	SIGNAL Xin							:std_logic_vector (n-1 DOWNTO 0) := "00000000";
	SIGNAL Yin							:std_logic_vector (n-1 DOWNTO 0) := "00000000";
	SIGNAL Icache : mem := ("00001000","00001001","00001010","00010000","00010001","00011000","00011001","00011010","00011011","00011100","00011101","00011101");
begin

	L0 : top generic map (n,k,m) 
			 port map(INPUT_switch => INPUT_switch, enaY => enaY, enaX => enaX, enaALUFN => enaALUFN,
						 Y_out1 => Y_out1, Y_out0 => Y_out0, X_out1 => X_out1, X_out0 => X_out0,
						 ALUFN_out => ALUFN_out, ALUout => ALUout, Nflag => Nflag, Cflag => Cflag, Zflag => Zflag
					);
    
	--------- start of stimulus section ---------------------------------------		
tb_input: process
		
	--variable Xin: std_logic_vector (n-1 DOWNTO 0) := "00000000";
	--variable Yin: std_logic_vector (n-1 DOWNTO 0) := "00000000";

	begin
		
		INPUT_switch	<= "00000000";
		Xin				<= "00000000";
		Yin				<= "00000000";
		enaY			<= '0';
		wait for 50 ns;
		enaY			<= '1';
		enaX			<= '0'; 
		wait for 50 ns;
		enaX			<= '1';
		wait for 50 ns;
		
		for i in 0 to ROWmax loop
			INPUT_switch <= Icache(i);
			enaALUFN		<= '0';
			wait for 50 ns;
			enaALUFN		<= '1';
			for i in 0 to 150 loop
				enaY			<= '1';
				INPUT_switch	<= Xin;
				enaX			<= '0';
				Yin <= Yin + 1;
				wait for 50 ns;
				enaX			<= '1';
				INPUT_switch	<= Yin;
				enaY			<= '0';
				Xin <= Xin - 2;
				wait for 50 ns;
			end loop;
		end loop;
		wait;
	end process;
  
end architecture rtb;
