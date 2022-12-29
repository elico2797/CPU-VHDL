LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;


ENTITY INTERRUPT IS

	PORT(	BTSetIFG			: IN 	STD_LOGIC;
			GIE				: IN 	STD_LOGIC;
			clock			: IN 	STD_LOGIC;
			reset 			: IN 	STD_LOGIC;
			INTA			: IN 	STD_LOGIC;
			enable			: IN STD_LOGIC;
			UART_TXD		: out STD_LOGIC;
			UART_RXD 		: IN STD_LOGIC;
			CSIFG, CSIE, CSType		: IN 	STD_LOGIC;
			MemRead			: IN 	STD_LOGIC;
			MemWrite		: IN 	STD_LOGIC;
			DataBus			: INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			KEY3			: IN STD_LOGIC;
			KEY2			: IN STD_LOGIC;
			KEY1			: IN STD_LOGIC;
			CSUCTL,CSRX,CSTX: IN STD_LOGIC;
			INTR			: BUFFER 	STD_LOGIC
	);
END INTERRUPT;

ARCHITECTURE behavior OF INTERRUPT IS
	
	COMPONENT UART
		GENERIC(CLK_FREQ	: INTEGER := 15e6;
				BAUD_RATE     : integer := 9600; -- baud rate value
				PARITY_BIT    : string := "none"				; -- type of parity: "none", "even", "odd", "mark", "space"
				USE_DEBOUNCER : boolean := True
		);
		PORT(
				-- MCU Bus I/O
				CLK         : in  std_logic; -- system clock
				RST         : in  std_logic; -- high active synchronous reset
				-- UART INTERFACE
				UART_TXD    : out std_logic; -- serial transmit data
				UART_RXD    : in  std_logic; -- serial receive data
				-- USER DATA INPUT INTERFACE
				DIN         : in  std_logic_vector(7 downto 0); -- input data to be transmitted over UART
				DIN_VLD     : in  std_logic; -- when DIN_VLD = 1, input data (DIN) are valid
				DIN_RDY     : out std_logic; -- when DIN_RDY = 1, transmitter is ready and valid input data will be accepted for transmiting
				-- USER DATA OUTPUT INTERFACE
				DOUT        : out std_logic_vector(7 downto 0); -- output data received via UART
				DOUT_VLD    : out std_logic; -- when DOUT_VLD = 1, output data (DOUT) are valid (is assert only for one clock cycle)
				FRAME_ERROR : out std_logic  -- when FRAME_ERROR = 1, stop bit was invalid (is assert only for one clock cycle)

		);
	END COMPONENT;
	SIGNAL BTIrq	: STD_LOGIC;
	SIGNAL IFGReg 	: STD_LOGIC_VECTOR(7 DOWNTO 0) := X"00";
	SIGNAL IEReg 	: STD_LOGIC_VECTOR(7 DOWNTO 0) := X"00";
	SIGNAL TYPEReg	: STD_LOGIC_VECTOR(7 DOWNTO 0) := X"00";
	SIGNAL TYPEReg_temp : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"00";
	SIGNAL irq_clr1,irq_clr2,irq_clr3,irq_clr_tx,irq_clr_rx : STD_LOGIC ;
	SIGNAL KEY1Irq,KEY2Irq,KEY3Irq : STD_LOGIC ;	
	SIGNAL KEY1_deb, KEY2_deb, KEY3_deb : STD_LOGIC;
	signal BTIFG_SIGNAL :STD_LOGIC;
	---UART__Registers
	signal UTCTLREG : STD_LOGIC_VECTOR(7 downto 0);
	signal RXBUFREG : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL TXBUFREG :	STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL DIN_VLD,DIN_RDY,FRAME_ERROR : STD_LOGIC;
	SIGNAL DIN,DOUT : STD_LOGIC_VECTOR(7 downto 0);	
	----
	SIGNAL PARITY_BIT1 : string(1 to 4) := "none" ; 
	SIGNAL RST_UART : STD_LOGIC;
	SIGNAL irq_rx, irq_tx : STD_LOGIC;
	SIGNAL DOUT_VLD : STD_LOGIC;
	constant BAUD_RATE : integer := 9600; 

	ALIAS  KEY3IFG IS IFGReg(5);
	ALIAS  KEY2IFG IS IFGReg(4);
	ALIAS  KEY1IFG IS IFGReg(3);
	ALIAS  BTIFG   IS IFGReg(2);
	ALIAS  TXIFG   IS IFGReg(1);
	ALIAS  RXIFG   IS IFGReg(0);
	
	ALIAS  KEY3IE  IS IEReg(5);
	ALIAS  KEY2IE  IS IEReg(4);
	ALIAS  KEY1IE  IS IEReg(3);
	ALIAS  BTIE    IS IEReg(2);
	ALIAS  TXIE   IS IEReg(1);
	ALIAS  RXIE   IS IEReg(0);
	-----control state machine
	TYPE 	state IS (s0, s1);
	SIGNAL 	pr_state, nx_state					:state;
	--
	TYPE 	StateOE IS (s2, s3);
	SIGNAL 	pr_state1, nx_state1 					:StateOE;
	--
	TYPE 	StateType IS (s4, s5);
	SIGNAL 	pr_state2, nx_state2 					:StateType;
	--
	TYPE 	StateKey1 IS (s6, s7);
	SIGNAL 	pr_state3, nx_state3 					:StateKey1;
	--
	TYPE 	StateKey2 IS (s8, s9);
	SIGNAL 	pr_state4, nx_state4 					:StateKey2;
	--
	TYPE 	StateKey3 IS (s10, s11);
	SIGNAL 	pr_state5, nx_state5 					:StateKey3;
	

---Uart aliases
	ALIAS BUSY IS UTCTLREG(7);
	ALIAS OE IS UTCTLREG(6);
	ALIAS PE IS UTCTLREG(5);
	ALIAS FE IS UTCTLREG(4);
	ALIAS BAUDRATE IS UTCTLREG(3);
	ALIAS PEV IS UTCTLREG(2);
	ALIAS PENA IS UTCTLREG(1);
	ALIAS SWRST IS UTCTLREG(0);
BEGIN
		
	-- Interrupt Request To Cpu
	INTR 	<=     --NOT (Irq_reset) OR
					(((KEY3IFG AND KEY3IE) OR
					 (KEY2IFG AND KEY2IE) OR
					 (KEY1IFG AND KEY1IE) OR
					 (TXIFG AND TXIE) OR
					 (RXIFG AND RXIE) OR
					 (BTIFG AND BTIE)) AND
					GIE) AND enable;
					
	irq_clr1 <= '1' when KEY1IFG = '1' else '0';
	irq_clr2 <= '1' when KEY2IFG = '1' else '0';
	irq_clr3 <= '1' when KEY3IFG = '1' else '0';
	irq_clr_tx <= '1' when (CSTX = '1' AND MemWrite = '1') else '0';
	irq_clr_rx <= '1' when (RXIFG = '1' and TYPEReg =  X"08")  or  (CSRX = '1' AND MemRead = '1') else '0';
	
	
	-----------------------
	--Interrupt Ack Handling
	DataBus	<= X"000000" & TYPEReg WHEN ((CSType = '1' AND MemRead = '1') OR INTA = '1') ELSE
				X"000000" & IFGReg when (CSIFG = '1' AND MemRead = '1') ELSE
				X"000000" & IEReg when (CSIE = '1' AND MemRead = '1') ELSE
				X"000000" & UTCTLREG when (CSUCTL = '1' AND MemRead = '1') ELSE
				X"000000" & RXBUFREG when (CSRX = '1' AND MemRead = '1') ELSE
				X"000000" & TXBUFREG when (CSTX = '1' AND MemRead = '1') ELSE
				(OTHERS => 'Z');
		
	TYPEReg_temp <=	X"08" when (RXIFG = '1' and RXIE = '1') else
					X"0C" when (TXIFG = '1' and TXIE = '1') else
					X"10" when (BTIFG = '1' and BTIE = '1') else
					X"14" when (KEY1IFG = '1' and KEY1IE = '1') else
					X"18" when (KEY2IFG = '1' and KEY2IE = '1') else
					X"1C" when (KEY3IFG = '1' and KEY3IE = '1') else TYPEReg_temp;

								
	FE <= FRAME_ERROR;
	BUSY <= not (DIN_RDY); 
	RST_UART <= not (enable) and not (SWRST);-- or not (SWRST); -- to check the reset
	

	process (INTR, clock, reset)  --- state machine for the type register !
	begin 
		if (reset = '0') then 
			pr_state2 	<= S4;
		elsif (clock'EVENT and clock = '1') then  -- just for half cycle
			pr_state2 	<= nx_state2;
		end if ;
		Case pr_state2 is
			when s4 => 
				if (INTR = '1') then 
					nx_state2 <= s5;
					TYPEReg <= TYPEReg_temp;
				else 
					nx_state2 <= s4;
				end if ;
			when s5 =>
				nx_state2 <= s4;
		end case;
	end process;
	
	process(clock, reset ,BTSetIFG , TYPEReg) -- -- need to be adapted to priority list of bonus צריך לסדר שלא יתכבה כל עוד לא פסקתי מהטיימר!
	begin 
		
		if (reset = '0') then 
			pr_state 	<= S0;
			--BTIFG		<= '0';
		elsif (clock'EVENT and clock = '1') then  -- just for half cycle
			pr_state 	<= nx_state;
		elsif (falling_edge(clock)) then
			IF (CSIFG = '1' AND MemWrite = '1') then 
				BTIFG <= DataBus(2);
			end if ;
		end if;	
		
		Case pr_state is 
			when s0 =>  -- falling edge 0
				if (BTSetIFG = '1') then 
					nx_state <= S1;
					BTIFG	<= '1';
				elsif (	BTSetIFG = '0') then
					nx_state <= S0 ;
					BTIFG	<= '0';
				end if;
			when s1 => 
				IF BTSetIFG = '1' then  --- need to be changed to be adapded with the uart
					IF (TYPEReg =  X"10") then
						nx_state <= S1;
						BTIFG <= '0';
					end if ;
				ELSIF BTSetIFG = '0' then 
					nx_state <=s0;
					BTIFG <= '0';
				END IF ;
				 			
		end case ; 
	end process;
	
	process(clock,KEY1Irq,KEY2Irq,KEY3Irq) --,BTSetIFG,INTA)
	begin 
		if falling_edge(clock) then --'event AND clock = '0') THEN
			IF (CSIFG = '1' AND MemWrite = '1') then 
				IFGReg(5 downto 3) <= DataBus(5 downto 3); -- need to be with the timer also bit 2 !!!!!!!!!!!
			ELSE
				if (irq_clr3 = '1') then
					KEY3IFG <= '0';
				elsif (KEY3Irq = '1' AND KEY3IE = '1') then 
					KEY3IFG <= '1';
				end if;
				if (irq_clr2 = '1') then
					KEY2IFG <= '0';
				elsif (KEY2Irq = '1' AND KEY2IE = '1') then
					KEY2IFG <= '1';
				end if;
				if (irq_clr1 = '1') then
					KEY1IFG <= '0';
				elsif (KEY1Irq = '1' AND KEY1IE = '1') then 
					KEY1IFG <= '1';
				end if;
			END IF;
		END IF;
	end process;
	
	process(clock,DOUT_VLD,reset,DIN_RDY) 
	begin 
		--TXIFG <= '0';
		if (reset = '0') then	
			TXIFG <= '0';
			RXIFG <= '0';
		elsif (falling_edge(clock) and enable = '1') then --'event AND clock = '0') THEN
			if (CSTX = '1' AND MemWrite = '1') then 
				TXBUFREG	<= DataBus(7 DOWNTO 0);
			end if ;
			IF (CSIFG = '1' AND MemWrite = '1') then 
				IFGReg(0) <= DataBus(0);
			ELSIF DOUT_VLD = '1' then 
				RXIFG <= '1' ;
				RXBUFREG <= DOUT;
			ELSIF irq_clr_rx = '1' then 
				RXIFG <= '0';
			END IF;
			IF  (CSIFG = '1' AND MemWrite = '1') then 
				IFGReg(1) <= DataBus(1);
			ELSIF DIN_RDY = '1' and TXIE = '1' then 
				TXIFG <= '1';
				DIN_VLD <= '1';
				DIN <= TXBUFREG;
			ELSIF (irq_clr_tx = '1') THEN
				TXIFG <= '0';	
				DIN_VLD <= '0';
			ELSIF TXIE = '0' then 
				DIN_VLD <= '0';
			END IF;	
				
		END IF;

		if reset = '0' then    -- state machine for OE flag
				pr_state1 	<= S2;
		elsif (rising_edge(clock) and enable = '1')	then 
				pr_state1 <=  nx_state1;
		end if ;
		Case pr_state1 is 
				when s2 => 
						if irq_rx = '1' then 
							nx_state1 <= s3;
							OE <= '1';
						else 
							nx_state1 <= s2;
							OE <= '0';
						end if ; 
				when s3 =>
						if  (CSRX = '1' AND MemRead = '1') then 
							OE <= '0';
							nx_state1 <= s2; 
						else 
							nx_state1 <= s3;
						end if ; 
		end case;
	end process;

	-- Writing to the IE register
	PROCESS(clock,reset)-- Writing to the IE register
    BEGIN
		IF (clock'event AND clock = '0') THEN
			if (CSIE = '1' AND MemWrite = '1') then 
				IEReg	<= DataBus(7 DOWNTO 0);
			end if;
		END IF;
    END PROCESS;
	
	-- UCTLREGISTER-- UCTLREGISTER
	PROCESS(clock,reset)-- UCTLREGISTER
	BEGIN
		IF (clock'event AND clock = '0') THEN
			if (CSUCTL = '1' AND MemWrite = '1') then 
				UTCTLREG(3 downto 0)	<= DataBus(3 DOWNTO 0);
			end if;			
		END IF;
    END PROCESS;

	PROCESS(reset ,KEY1_deb, KEY2_deb, KEY3_deb, INTA) -- keys interupt 
	BEGIN	
		IF (reset = '0') then
			KEY1Irq <= '0';	
			KEY2Irq <= '0';
			KEY3Irq <= '0';
		else
			IF (INTA = '1' AND TYPEReg = X"14") THEN
				KEY1Irq <= '0';			
			ELSIF (KEY1_deb = '0') THEN
				KEY1Irq <= '1';
			END IF;
			
			IF (INTA = '1' AND TYPEReg = X"18") THEN
				KEY2Irq <= '0';
			ELSIF (KEY2_deb = '0') THEN
				KEY2Irq <= '1';
			END IF;	
			
			IF (INTA = '1' AND TYPEReg = X"1C") THEN
				KEY3Irq <= '0';
			ELSIF (KEY3_deb = '0') THEN
				KEY3Irq <= '1';
			END IF;
		END IF ;
	END PROCESS;
	
	process (clock, reset, KEY1)  --- state machine for the Key1
	begin 
		if (reset = '0') then 
			pr_state3 	<= S6;
			KEY1_deb <= '1';
		elsif (clock'EVENT and clock = '1') then  -- just for half cycle
			pr_state3 	<= nx_state3;
		end if ;
		Case pr_state3 is
			when s6 => 
				if (KEY1 = '0') then 
					nx_state3 <= s7;
					KEY1_deb <= '0';
				else 
					nx_state3 <= s6;
					KEY1_deb <= '1';
				end if ;
			when s7 =>
				KEY1_deb <= '1';
				if KEY1 = '0' then
					nx_state3 <= s7;
				elsif KEY1 = '1' then 
					nx_state3 <= s6;
				end if;
		end case;
	end process;
	
	process (clock, reset, KEY2)  --- state machine for the Key2
	begin 
		if (reset = '0') then 
			pr_state4 	<= S8;
			KEY2_deb <= '1';
		elsif (clock'EVENT and clock = '1') then  -- just for half cycle
			pr_state4 	<= nx_state4;
		end if ;
		Case pr_state4 is
			when s8 => 
				if (KEY2 = '0') then 
					nx_state4 <= s9;
					KEY2_deb <= '0';
				else 
					nx_state4 <= s8;
					KEY2_deb <= '1';
				end if ;
			when s9 =>
				KEY2_deb <= '1';
				if KEY2 = '0' then
					nx_state4 <= s9;
				elsif KEY2 = '1' then 
					nx_state4 <= s8;
				end if;
		end case;
	end process;
	
	process (clock, reset, KEY3)  --- state machine for the Key3
	begin 
		if (reset = '0') then 
			pr_state5 	<= S10;
			KEY3_deb <= '1';
		elsif (clock'EVENT and clock = '1') then  -- just for half cycle
			pr_state5 	<= nx_state5;
		end if ;
		Case pr_state5 is
			when s10 => 
				if (KEY3 = '0') then 
					nx_state5 <= s11;
					KEY3_deb <= '0';
				else 
					nx_state5 <= s10;
					KEY3_deb <= '1';
				end if ;
			when s11 =>
				KEY3_deb <= '1';
				if KEY3 = '0' then
					nx_state5 <= s11;
				elsif KEY3 = '1' then 
					nx_state5 <= s10;
				end if;
		end case;
	end process;
	
		
	UART1: UART	--- port maping for uart
	GENERIC MAP (BAUD_RATE 		=> BAUD_RATE)
	PORT MAP(	
				RST				=> RST_UART,
				CLK				=> clock,
				UART_TXD		=> UART_TXD,
				UART_RXD		=> UART_RXD,
				DIN				=> DIN,
				DIN_VLD			=> DIN_VLD,
				DIN_RDY 		=> DIN_RDY,
				DOUT	        => DOUT,
				DOUT_VLD 		=> DOUT_VLD,
				FRAME_ERROR     => FRAME_ERROR);	
	END behavior;


-- decounce for the keys