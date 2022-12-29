		-- control module (implements MIPS control unit)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY control IS
	PORT( 	Opcode 		: IN 	STD_LOGIC_VECTOR(5 DOWNTO 0);
			Funct		: IN 	STD_LOGIC_VECTOR(5 DOWNTO 0);
			ALUop 		: OUT 	STD_LOGIC_VECTOR(3 DOWNTO 0);
			Branch 		: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
			RegDst 		: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0);
			ALUSrc 		: OUT 	STD_LOGIC;
			MemtoReg 	: OUT 	STD_LOGIC_VECTOR(2 DOWNTO 0);
			RegWrite 	: OUT 	STD_LOGIC := '0';
			MemRead 	: OUT 	STD_LOGIC;
			MemWrite 	: OUT 	STD_LOGIC := '0';
			jump 		: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
			INTR		: IN 	STD_LOGIC;
			INTA_OUT	: OUT 	STD_LOGIC;	
			IVCall_OUT	: OUT	STD_LOGIC;
			PCHold      : OUT    STD_LOGIC;
			clock,reset	: IN 	STD_LOGIC 
	);

END control;

ARCHITECTURE behavior OF control IS

	SIGNAL  R_format, I_format, J_format 		: STD_LOGIC;
	SIGNAL  Lw, Sw, Beq, bne, J, Jal, Jr, mul	: STD_LOGIC;
	SIGNAL  andi, ori, xori, slti, Lui, addi 	: STD_LOGIC;
	SIGNAL  IVCall_signal,IVCall, INTA			: STD_LOGIC;
	SIGNAL 	INTA_signal, PChold_signal          : STD_LOGIC;
	TYPE 	state IS (s0, s1, s2);
	SIGNAL 	pr_state, nx_state					:state;
	
BEGIN           
	
	IVCall_OUT 	<= IVCall;
	INTA_OUT 	<= INTA;	

	PROCESS (reset, clock) 
	BEGIN 
		if (reset = '0') then 
			pr_state 	<= S0;
			IVCall		<= '0';
			INTA		<= '0';
			--PChold 		<= '0';
		elsif (clock'EVENT and clock = '1') then  -- just for half cycle
			pr_state 	<= nx_state; 
			INTA		<= INTA_signal;
			IVCall		<= IVCall_signal;
			-- PChold 		<= PChold_signal;
		--elsif (clock'EVENT and clock = '1') then
		end if;
	end process;
	
	process(pr_state, INTR) -- maybe need addiotion to the sensetivity list
	begin 
		Case pr_state is 
			when s0 =>  -- falling edge 0
				if (INTR = '1') then 
					nx_state <= S1;
					--INTR <= '0' ; -- need to be zeroize in this section but should be done from the GIE or directly change the flage (user responsebility)
					PChold			<= '1';
					INTA_signal 	<= '1' ;
					IVCall_signal 	<= '0';
				else	
					nx_state <= S0 ;
					INTA_signal         <= '0'; 
					IVCall_signal		<= '0'; 
					--PChold_signal      	<= '0';
					PChold			<= '0';
				end if;
				
			when s1 => -- rising edge 1
				nx_state 		<= S2;
				INTA_signal 	<= '1' ; 
				IVCall_signal 	<= '1';
				-- PChold_signal	<= '1'; 
				
			when s2 => -- falling edge 1
				nx_state <= s0;
				INTA_signal 	<= '0' ; 
				IVCall_signal 	<= '0' ;
				PChold			<= '0';

				--PChold_signal	<= '0'; 
			--when s3 =>  -- rising edge 2
			--	nx_state <= s0;
			--	IVCall_signal <= '0' ;
			--	PChold_signal <= '0';
		end case ; 
	end process;
	
	
	-- Code to generate control signals using opcode bits
	R_format 	<=  '1'  WHEN  Opcode = "000000"  ELSE '0';
	I_format	<= 	'1'  WHEN  Opcode(5 DOWNTO 3) = "001"  ELSE '0';
	mul			<=	'1'  WHEN  Opcode = "011100" ELSE '0';
	addi        <=  '1'  WHEN  Opcode = "001000" ELSE '0';
	andi        <=  '1'  WHEN  Opcode = "001100" ELSE '0';
	xori        <=  '1'  WHEN  Opcode = "001110" ELSE '0';
	ori         <=  '1'  WHEN  Opcode = "001101" ELSE '0';
	slti        <=  '1'  WHEN  Opcode = "001010" ELSE '0';
	Lw          <=  '1'  WHEN  Opcode = "100011" ELSE '0';
	Lui			<=  '1'  WHEN  Opcode = "001111" ELSE '0';
 	Sw          <=  '1'  WHEN  Opcode = "101011" ELSE '0';
   	Beq         <=  '1'  WHEN  Opcode = "000100" ELSE '0';
	Bne         <=  '1'  WHEN  Opcode = "000101" ELSE '0';
	J_format	<= 	'1'  WHEN  Opcode(5 DOWNTO 1) = "00001"  ELSE '0';
	J 			<=	'1'  WHEN  Opcode = "000010" ELSE '0';
	Jal 		<=	'1'  WHEN  Opcode = "000011" ELSE '0';
	Jr			<=  '1'  WHEN  (Opcode = "000000" AND Funct = "001000")  ELSE '0';
	
	-- Control bits
  	RegDst(0)   <=  R_format OR mul OR INTA;-- OR INTA_signal;
	RegDst(1)   <=  Jal OR INTA;-- OR INTA_signal;
	
 	ALUSrc  	<=  Lw OR Sw OR Lui OR I_format;
  	RegWrite 	<=  R_format OR I_format OR Lw OR Lui OR mul OR Jal OR INTA;-- OR INTA_signal;
  	MemRead 	<=  Lw OR INTA;
   	MemWrite 	<=  Sw AND NOT(INTA);
	
	jump(0)		<=  Jr;
	jump(1)		<= 	J_format OR Jr OR IVCall;-- OR INTA_signal ;
	
	MemtoReg(0) <=  Lw OR Lui;
	MemtoReg(1) <=  Lui OR (INTA and NOT IVCall);-- OR INTA_signal;
	MemtoReg(2)	<= 	Jal;
	
 	Branch(1)   <=  Beq OR Bne;
	Branch(0)   <=  Bne;
	
	ALUOp(3)	<= 	R_format;
	ALUOp(2) 	<=  I_format AND (ori OR andi OR xori OR slti); 
	ALUOp(1) 	<=  andi OR mul OR slti;
	ALUOp(0) 	<=  Beq OR Bne OR (I_format AND (slti OR xori));
	
END behavior;
					