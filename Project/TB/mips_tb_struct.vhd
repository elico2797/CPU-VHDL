
ENTITY MCU_tb IS

END MCU_tb ;

--
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

LIBRARY work;

ARCHITECTURE struct OF MCU_tb IS

   -- Architecture declarations
	CONSTANT MemWidth	: INTEGER := 8;
	CONSTANT SIM 		: BOOLEAN := TRUE;
   -- Internal signal declarations
   SIGNAL clock           : STD_LOGIC;
   SIGNAL reset           : STD_LOGIC;
   signal Switches 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 ):= X"AA";
   signal AddressBus 		: STD_LOGIC_VECTOR( 11 DOWNTO 0 );
   signal dataBus 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
   signal LED_G 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
   signal LED_R 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
   signal HEX0 		: STD_LOGIC_VECTOR( 6 DOWNTO 0 );
   signal HEX1 		: STD_LOGIC_VECTOR( 6 DOWNTO 0 );
   signal HEX2 		: STD_LOGIC_VECTOR( 6 DOWNTO 0 );
   signal HEX3 		: STD_LOGIC_VECTOR( 6 DOWNTO 0 );
   signal key0,key1,key2,key3 :STD_LOGIC;
   SIGNAL enable				: STD_LOGIC;
   SIGNAL UART_RXD,UART_TXD 	: STD_LOGIC;
   

   -- Component Declarations
   COMPONENT MCU
   	GENERIC(MemWidth	: INTEGER := 8;
			SIM 		: BOOLEAN := TRUE
	);
   PORT (
			--reset					: IN		STD_LOGIC;
			clock					: IN		STD_LOGIC;
			Switches            	: IN   		STD_LOGIC_VECTOR(7 DOWNTO 0):= X"AA";
			LED_G,LED_R 			: OUT   	STD_LOGIC_VECTOR(7 DOWNTO 0);
			HEX0,HEX1,HEX2,HEX3 	: OUT   	STD_LOGIC_VECTOR(6 DOWNTO 0);
			KEY3, KEY2				: IN STD_LOGIC;
			KEY1					: IN STD_LOGIC;
			enable					: IN STD_LOGIC;
			UART_TXD				: OUT STD_LOGIC;
			UART_RXD 				: IN STD_LOGIC;
			reset					: IN STD_LOGIC
   );
   END COMPONENT;
   
   COMPONENT mcu_tester
   PORT (

			Switches            	: OUT   		STD_LOGIC_VECTOR(7 DOWNTO 0):= X"AA";
			LED_G,LED_R 			: IN   	STD_LOGIC_VECTOR(7 DOWNTO 0);
			HEX0,HEX1,HEX2,HEX3 	: IN   	STD_LOGIC_VECTOR(6 DOWNTO 0);
			clock					: out	STD_LOGIC;
			reset           		: OUT    STD_LOGIC ;
			KEY3, KEY2				: OUT STD_LOGIC;
			enable					: OUT STD_LOGIC;
			KEY1					: OUT STD_LOGIC
   );
   END COMPONENT;


   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : MCU USE ENTITY work.mcu;
   FOR ALL : mcu_tester USE ENTITY work.mcu_tester;
   -- pragma synthesis_on

BEGIN
		UART_RXD <= '0';
		UART_TXD <= UART_TXD;
		
		Switches <= X"AA";
   -- Instance port mappings.
   U_0 : MCU
	 GENERIC MAP (MemWidth 	=> MemWidth,
				  SIM 		=> SIM
	  )
      PORT MAP (
         --reset           => reset,
         clock		    => clock,
		 Switches		=> Switches,
		 LED_G			=> LED_G,
		 LED_R			=> LED_R,
		 HEX0			=> HEX0,
		 HEX1			=> HEX1,
		 HEX2			=> HEX2,
		 HEX3			=> HEX3,
		 reset			=> reset,
		 KEY1			=> KEY1,
		 KEY2			=> KEY2,
		 enable			=> enable,
		 KEY3			=> KEY3,
		 UART_RXD       => UART_RXD,
		 UART_TXD		=> UART_TXD
      );
	  
   U_1 : mcu_tester
      PORT MAP (
         --reset           => reset,
		 Switches		=> Switches,
		 LED_G			=> LED_G,
		 enable			=> enable,
		 LED_R			=> LED_R,
		 HEX0			=> HEX0,
		 Clock			=> Clock,	
		 HEX1			=> HEX1,
		 HEX2			=> HEX2,
		 HEX3			=> HEX3,
		 reset			=> reset,
		 KEY1			=> KEY1,
		 KEY2			=> KEY2,
		 KEY3			=> KEY3
      );


END struct;
