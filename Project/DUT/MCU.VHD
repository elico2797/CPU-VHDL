LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY MCU IS
	
	GENERIC(MemWidth	: INTEGER := 10;
			SIM 		: BOOLEAN := FALSE
	);
	PORT( 	reset					: IN		STD_LOGIC;
			clock					: IN		STD_LOGIC;
			Switches            	: IN   		STD_LOGIC_VECTOR(7 DOWNTO 0) := X"AA";
			LED_G,LED_R 			: OUT   	STD_LOGIC_VECTOR(7 DOWNTO 0);
			HEX0,HEX1,HEX2,HEX3 	: OUT   	STD_LOGIC_VECTOR(6 DOWNTO 0);
			KEY3, KEY2				: IN STD_LOGIC;
			KEY1 					: IN STD_LOGIC;
			enable 					: IN STD_LOGIC;
			UART_TXD				: OUT STD_LOGIC;
			UART_RXD 				: IN STD_LOGIC
	);
	
END 	MCU;

ARCHITECTURE structure OF MCU IS

	COMPONENT MIPS
		GENERIC(MemWidth	: INTEGER := 10;
				SIM 		: BOOLEAN := FALSE
		);
		PORT( 	reset 				: IN 	STD_LOGIC; 
				clock				: IN 	STD_LOGIC;
				-- MCU Bus I/O
				INTA					: OUT 		STD_LOGIC;
				INTR					: IN STD_LOGIC;
				MemReadBus 	    		: OUT		STD_LOGIC; 
				MemWriteBus 	        : OUT		STD_LOGIC;
				AddressBus 	        	: OUT 		STD_LOGIC_VECTOR(11 DOWNTO 0);
				DataBus					:INOUT   	STD_LOGIC_VECTOR(31 DOWNTO 0);
				GIE						: OUT       STD_LOGIC;
				enable 					: IN STD_LOGIC

		);
	END COMPONENT;
	
	COMPONENT GPIO
		PORT(	MemRead 	    		: IN		STD_LOGIC; 
				MemWrite 	        	: IN		STD_LOGIC;
				DataBus					:INOUT   	STD_LOGIC_VECTOR(31 DOWNTO 0);
				CSLEDR, CSLEDG			: IN		STD_LOGIC;
				CSHEX0, CSHEX1			: IN		STD_LOGIC;
				CSHEX2, CSHEX3			: IN		STD_LOGIC;
				CSSW					: IN		STD_LOGIC;
				reset,clock				: IN		STD_LOGIC;
				Switches            	: IN   		STD_LOGIC_VECTOR(7 DOWNTO 0):= X"AA";
				LED_G,LED_R 			: OUT   	STD_LOGIC_VECTOR(7 DOWNTO 0);
				HEX0,HEX1,HEX2,HEX3 	: OUT   	STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT BTIMER
		PORT(	Clock,Reset			: IN STD_LOGIC;
				MemWrite, CSBTCTL 	: IN STD_LOGIC;
				CSBTCNT, MemRead	: IN STD_LOGIC;
				DataBus				: INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				BTSetIFG 			: OUT STD_LOGIC
		); 
	END COMPONENT;

	COMPONENT INTERRUPT
		PORT(	KEY3, KEY2		: IN STD_LOGIC;
				UART_TXD		:OUT STD_LOGIC;
				UART_RXD 		: IN STD_LOGIC;
				KEY1			: IN STD_LOGIC;
				BTSetIFG		: IN STD_LOGIC;
				GIE				: IN STD_LOGIC;
				INTA			: IN STD_LOGIC;
				enable			: IN STD_LOGIC;
				clock			: IN 	STD_LOGIC;
				CSIFG, CSIE,CSType		: IN STD_LOGIC;
				CSUCTL,CSRX,CSTX: IN STD_LOGIC;
				MemWrite, MemRead		: IN STD_LOGIC;
				DataBus			: INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				Reset			: IN STD_LOGIC;
				INTR			: BUFFER STD_LOGIC
		);
	END COMPONENT;
	
	
	component PLL port(
	      areset		: IN STD_LOGIC  := '0';
		   inclk0		: IN STD_LOGIC  := '0';
		       c0		: OUT STD_LOGIC ;
		    locked		: OUT STD_LOGIC );
    end component;

	-- MCU BUS And Signal
	SIGNAL CSIFG, CSIE	: STD_LOGIC;
	SIGNAL CSBTCNT, CSBTCTL		: STD_LOGIC;
	SIGNAL CSKEY, 	CSSW		: STD_LOGIC;
	SIGNAL CSHEX3, 	CSHEX2		: STD_LOGIC;
	SIGNAL CSHEX1, 	CSHEX0		: STD_LOGIC;
	SIGNAL CSLEDR, 	CSLEDG,CSType		: STD_LOGIC;
	signal PLLOut : std_logic ;
	---CS bounos
	SIGNAL CSUCTL,CSRX,CSTX : std_logic;
	-- Mips CPU
	SIGNAL MemRead 	    : STD_LOGIC; 
    SIGNAL MemWrite 	: STD_LOGIC;
	SIGNAL 	dataBus      : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL	MemReadBus 	: STD_LOGIC; 
    SIGNAL 	MemWriteBus : STD_LOGIC;
    SIGNAL  AddressBus 	: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL  LED_G_temp,LED_R_temp	: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL 	HEX0_temp,HEX1_temp,HEX2_temp,HEX3_temp : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL	GIE : STD_LOGIC;
	SIGNAL  INTR_signal : STD_LOGIC;
	SIGNAL	BTSetIFG  : STD_LOGIC;
	SIGNAL 	INTA : STD_LOGIC;
	SIGNAL 	sys_clk :STD_LOGIC;


	

BEGIN

	MemReadBus	<=	MemRead;
	MemWriteBus	<=	MemWrite;
	LED_G <= LED_G_temp;
	LED_R <= LED_R_temp;
	HEX0 <= HEX0_temp;
	HEX1 <= HEX1_temp;
	HEX2 <= HEX2_temp;
	HEX3 <= HEX3_temp;

	
	G1: IF (SIM = TRUE) GENERATE
			sys_clk <= clock;
	END GENERATE G1;
	G2: IF (SIM = FALSE) GENERATE
			sys_clk <=  PLLOut;
	END GENERATE G2;
	
	
	-- Optimal Address Decoder
	CSType	<= 	'1' WHEN AddressBus = X"82E" ELSE '0';	
	CSIFG	<= 	'1' WHEN AddressBus = X"82D" ELSE '0'; --writing to the interupt register
	CSIE	<= 	'1' WHEN AddressBus = X"82C" ELSE '0';
	CSBTCNT	<=	'1' WHEN AddressBus = X"828" ELSE '0';
	CSBTCTL	<=	'1' WHEN AddressBus = X"824" ELSE '0';
	--bonus--
	CSUCTL  <=	'1' WHEN AddressBus = X"820" ELSE '0';
	CSRX    <=	'1' WHEN AddressBus = X"821" ELSE '0';
	CSTX    <=	'1' WHEN AddressBus = X"822" ELSE '0';
	---
	CSKEY	<=	'1' WHEN AddressBus = X"81C" ELSE '0';
	CSSW	<=	'1' WHEN AddressBus = X"818" ELSE '0';
	CSHEX3	<=	'1' WHEN AddressBus = X"814" ELSE '0';
	CSHEX2	<=	'1' WHEN AddressBus = X"810" ELSE '0';
	CSHEX1	<=	'1' WHEN AddressBus = X"80C" ELSE '0';
	CSHEX0	<=	'1' WHEN AddressBus = X"808" ELSE '0';
	CSLEDR	<=	'1' WHEN AddressBus = X"804" ELSE '0';
	CSLEDG	<=	'1' WHEN AddressBus = X"800" ELSE '0';

	-- PORT MAPING
   CPU: MIPS
	GENERIC MAP(MemWidth		=> MemWidth,
				SIM				=> SIM )
	PORT MAP(	reset			=> reset,
				clock			=> sys_clk,
				MemReadBus		=> MemRead,
				MemWriteBus		=> MemWrite,
				AddressBus		=> AddressBus,
				GIE				=> GIE,
				INTA 			=> INTA,
				DataBus         => DataBus,
				enable 			=> enable,
				INTR            => INTR_signal);
			
	
   IO: GPIO
	PORT MAP(	MemRead		=> MemReadBus,
				MemWrite	=> MemWriteBus,
				DataBus		=> DataBus,
				reset 		=> reset,
				clock 		=> sys_clk,
				Switches	=> Switches,
				CSLEDR	=> CSLEDR, CSLEDG  => CSLEDG,
				CSHEX0	=> CSHEX0, CSHEX1  => CSHEX1,
				CSHEX2	=> CSHEX2, CSHEX3  => CSHEX3,
				CSSW	=> CSSW,
				LED_G	=> LED_G_temp, LED_R => LED_R_temp,
				HEX0	=> HEX0_temp,  HEX1	=> HEX1_temp,
				HEX2	=> HEX2_temp,  HEX3	=> HEX3_temp );
   BT: BTIMER
    PORT MAP(	Clock	=> sys_clk,
				reset => Reset,
				MemWrite => MemWriteBus,
				CSBTCNT	=> CSBTCNT,
				CSBTCTL => CSBTCTL,
				MemRead		=> MemReadBus,
				DataBus =>	DataBus,
				BTSetIFG => BTSetIFG ); 
	
   INT: INTERRUPT
    PORT MAP(	KEY3 	=> KEY3, KEY2 	=> KEY2,
				KEY1 	=> KEY1,
				UART_RXD => UART_RXD,
				UART_TXD => UART_TXD,
				CSIFG 	=> CSIFG, CSIE 	=> CSIE,
				CSType	=> CSType,
				CSRX	=> CSRX,
				CSTX	=> CSTX,
				CSUCTL	=> CSUCTL,
				enable 			=> enable,
				BTSetIFG 	=> BTSetIFG,
				reset       => reset,
				clock		=> sys_clk,
				GIE 		=> GIE,
				INTA 		=> INTA,
				MemRead		=> MemReadBus,
				MemWrite	=> MemWriteBus,
				DataBus		=> DataBus,
				INTR		=> INTR_signal );	

	m1: PLL port map(
	    inclk0 => clock,
		 c0 => PLLOut
	   );
				
	
END structure;


