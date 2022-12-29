LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY BTIMER IS

	PORT(	clock, Reset		: IN STD_LOGIC;
			MemWrite, CSBTCTL 	: IN STD_LOGIC;
			CSBTCNT, MemRead	: IN STD_LOGIC;
			DataBus				: INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			BTSetIFG 			: OUT STD_LOGIC
	); 
END 	BTIMER;

ARCHITECTURE behavior OF BTIMER IS
	
	SIGNAL BTCTL		: STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL BTCNT 		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL clock_div	: STD_LOGIC := '0';
	SIGNAL BTSetIFG_sig		:STD_LOGIC;
	signal test 		: STD_LOGIC;  
	
	ALIAS BTHOLD IS BTCTL(5);
	ALIAS BTSSEL IS BTCTL(4 DOWNTO 3);
	ALIAS BTIP 	 IS BTCTL(2 DOWNTO 0);
	
BEGIN

	DataBus	<= 	X"000000" & BTCTL WHEN (CSBTCTL = '1' AND MemRead = '1') ELSE
							BTCNT WHEN (CSBTCNT = '1' AND MemRead = '1') ELSE
							(OTHERS => 'Z');
    PROCESS(clock,Reset)
    BEGIN
		IF (clock'event AND clock = '0') THEN
			IF (CSBTCTL = '1' AND MemWrite = '1') then 
				BTCTL	<= DataBus(7 downto 0 );
			END IF;
		END IF;
    END PROCESS;
	
	-- BASIC TIMER
	PROCESS(clock,Reset)
	variable count : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    BEGIN			
		IF (clock'event AND clock = '1') THEN
		count := count + 1;
			IF (CSBTCNT = '1' AND MemWrite = '1') then 
				BTCNT	<= DataBus;
			ELSIF BTHOLD = '0' THEN
				--clock_div	<= count(0);
				IF (BTSSEL = "00") THEN
				BTCNT <= BTCNT + 1;
				ELSIF (BTSSEL = "01" AND (count = "111" OR count = "011" OR count = "101" OR count = "001")) THEN
					BTCNT <= BTCNT + 1;
				ELSIF (BTSSEL = "10" AND (count = "111" OR count = "011")) THEN
					BTCNT <= BTCNT + 1;
				ELSIF (BTSSEL = "11" AND (count = "111")) THEN
					BTCNT <= BTCNT + 1;
				END IF;
			END IF;
		END IF;
    END PROCESS;
	
	with BTIP select BTSetIFG <=
            BTCNT(0)    when "000",
            BTCNT(3)    when "001",
            BTCNT(7)    when "010",
            BTCNT(11)   when "011",
            BTCNT(15)   when "100",
            BTCNT(19)   when "101",
            BTCNT(23)   when "110",
            BTCNT(25)   when "111",
            'X'         when others;

	
END behavior;


