LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
-- USE IEEE.STD_LOGIC_UNPORTNED.ALL;

ENTITY GPIO IS
	PORT(	MemRead 	    		: IN		STD_LOGIC; 
        	MemWrite 	        	: IN		STD_LOGIC;
			DataBus					: INOUT      STD_LOGIC_VECTOR(31 DOWNTO 0);
			CSLEDR, CSLEDG			: IN		STD_LOGIC;
			CSHEX0, CSHEX1			: IN		STD_LOGIC;
			CSHEX2, CSHEX3			: IN		STD_LOGIC;
			CSSW					: IN		STD_LOGIC;
			reset,clock				: IN 		STD_LOGIC;
			Switches            	: IN   		STD_LOGIC_VECTOR(7 DOWNTO 0);
			LED_G,LED_R 			: OUT   	STD_LOGIC_VECTOR(7 DOWNTO 0);
			HEX0,HEX1,HEX2,HEX3 	: OUT   	STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END GPIO;

ARCHITECTURE behavior OF GPIO IS
		SIGNAL SW_PORT            		: STD_LOGIC_VECTOR(7 DOWNTO 0);
		SIGNAL LED_G_PORT, LED_R_PORT   : STD_LOGIC_VECTOR(7 DOWNTO 0);
		SIGNAL HEX0_PORT, HEX1_PORT     : STD_LOGIC_VECTOR(3 DOWNTO 0);
		SIGNAL HEX2_PORT, HEX3_PORT     : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN
	
	-- Input Mode (SW)
	SW_PORT	<= Switches;
	DataBus 	<= 	X"000000"& SW_PORT WHEN (MemRead = '1' AND CSSW = '1') ELSE (OTHERS => 'Z');  --- reading from the switches
	--DataBus(7 DOWNTO 0)		<=  SW_PORT   WHEN (MemRead = '1' AND CSSW = '1') ELSE (OTHERS => 'Z');
	
	
	-- Output Mode (LEDs + 7-Segment)
	PROCESS (reset,DataBus,clock)	
	begin 
			--LED_R_PORT <= (OTHERS => '0');
			--LED_G_PORT <= (OTHERS => '0');
		if(falling_edge(clock)) then
			if (CSLEDR = '1' AND MemWrite = '1') then  
				LED_R_PORT	<= DataBus(7 DOWNTO 0);
			else 
				LED_R_PORT <= LED_R_PORT;
			end if;
			if (CSLEDG = '1' AND MemWrite = '1') then 
				LED_G_PORT	<= DataBus(7 DOWNTO 0);
			else 
				LED_G_PORT <= LED_G_PORT;
			end if; 
			if (CSHEX0 = '1' AND MemWrite = '1') then 
				HEX0_PORT	<= DataBus(3 DOWNTO 0);
			else 
				HEX0_PORT <= HEX0_PORT;
			end if; 
			if (CSHEX1 = '1' AND MemWrite = '1') then 
				HEX1_PORT	<= DataBus(3 DOWNTO 0);
			else 
				HEX1_PORT <= HEX1_PORT;
			end if; 
			if (CSHEX2 = '1' AND MemWrite = '1') then 
				HEX2_PORT	<= DataBus(3 DOWNTO 0);
			else 
				HEX2_PORT <= HEX2_PORT;
			end if; 			
			if (CSHEX3 = '1' AND MemWrite = '1') then 
				HEX3_PORT	<= DataBus(3 DOWNTO 0);
			else 
				HEX3_PORT <= HEX3_PORT;
			end if;
		end if; 
	end process;
			
		
	LED_R	<= LED_R_PORT;
	LED_G	<= LED_G_PORT;

	HEX0 <= "1000000" when HEX0_PORT = "0000" else -- '0'
		"1111001" when HEX0_PORT = "0001" else -- '1'
		"0100100" when HEX0_PORT = "0010" else -- '2'
		"0110000" when HEX0_PORT = "0011" else -- '3'
		"0011001" when HEX0_PORT = "0100" else -- '4'
		"0010010" when HEX0_PORT = "0101" else -- '5'
		"0000010" when HEX0_PORT = "0110" else -- '6'
		"1111000" when HEX0_PORT = "0111" else -- '7'
		"0000000" when HEX0_PORT = "1000" else -- '8'
		"0011000" when HEX0_PORT = "1001" else -- '9'
		"0001000" when HEX0_PORT = "1010" else -- 'A'
		"0000011" when HEX0_PORT = "1011" else -- 'B'
		"1000110" when HEX0_PORT = "1100" else -- 'C'
		"0100001" when HEX0_PORT = "1101" else -- 'D'
		"0000110" when HEX0_PORT = "1110" else -- 'E'
		"0001110" when HEX0_PORT = "1111" else -- 'F'
		"1111111"; -- screen char off
	  
	  
	HEX1 <= "1000000" when HEX1_PORT = "0000" else -- '0'
		"1111001" when HEX1_PORT = "0001" else -- '1'
		"0100100" when HEX1_PORT = "0010" else -- '2'
		"0110000" when HEX1_PORT = "0011" else -- '3'
		"0011001" when HEX1_PORT = "0100" else -- '4'
		"0010010" when HEX1_PORT = "0101" else -- '5'
		"0000010" when HEX1_PORT = "0110" else -- '6'
		"1111000" when HEX1_PORT = "0111" else -- '7'
		"0000000" when HEX1_PORT = "1000" else -- '8'
		"0011000" when HEX1_PORT = "1001" else -- '9'
		"0001000" when HEX1_PORT = "1010" else -- 'A'
		"0000011" when HEX1_PORT = "1011" else -- 'B'
		"1000110" when HEX1_PORT = "1100" else -- 'C'
		"0100001" when HEX1_PORT = "1101" else -- 'D'
		"0000110" when HEX1_PORT = "1110" else -- 'E'
		"0001110" when HEX1_PORT = "1111" else -- 'F'
		"1111111"; -- screen char off
	  
	HEX2 <= "1000000" when HEX2_PORT = "0000" else -- '0'
		"1111001" when HEX2_PORT = "0001" else -- '1'
		"0100100" when HEX2_PORT = "0010" else -- '2'
		"0110000" when HEX2_PORT = "0011" else -- '3'
		"0011001" when HEX2_PORT = "0100" else -- '4'
		"0010010" when HEX2_PORT = "0101" else -- '5'
		"0000010" when HEX2_PORT = "0110" else -- '6'
		"1111000" when HEX2_PORT = "0111" else -- '7'
		"0000000" when HEX2_PORT = "1000" else -- '8'
		"0011000" when HEX2_PORT = "1001" else -- '9'
		"0001000" when HEX2_PORT = "1010" else -- 'A'
		"0000011" when HEX2_PORT = "1011" else -- 'B'
		"1000110" when HEX2_PORT = "1100" else -- 'C'
		"0100001" when HEX2_PORT = "1101" else -- 'D'
		"0000110" when HEX2_PORT = "1110" else -- 'E'
		"0001110" when HEX2_PORT = "1111" else -- 'F'
		"1111111"; -- screen char off
	  
	HEX3 <= "1000000" when HEX3_PORT = "0000" else -- '0'
		"1111001" when HEX3_PORT = "0001" else -- '1'
		"0100100" when HEX3_PORT = "0010" else -- '2'
		"0110000" when HEX3_PORT = "0011" else -- '3'
		"0011001" when HEX3_PORT = "0100" else -- '4'
		"0010010" when HEX3_PORT = "0101" else -- '5'
		"0000010" when HEX3_PORT = "0110" else -- '6'
		"1111000" when HEX3_PORT = "0111" else -- '7'
		"0000000" when HEX3_PORT = "1000" else -- '8'
		"0011000" when HEX3_PORT = "1001" else -- '9'
		"0001000" when HEX3_PORT = "1010" else -- 'A'
		"0000011" when HEX3_PORT = "1011" else -- 'B'
		"1000110" when HEX3_PORT = "1100" else -- 'C'
		"0100001" when HEX3_PORT = "1101" else -- 'D'
		"0000110" when HEX3_PORT = "1110" else -- 'E'
		"0001110" when HEX3_PORT = "1111" else -- 'F'
		"1111111"; -- screen char off
	
END behavior;


