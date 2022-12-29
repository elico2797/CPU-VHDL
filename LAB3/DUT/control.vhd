LIBRARY ieee;
USE ieee.std_logic_1164.all;
---------------------------------------------------------------
ENTITY CU IS
	GENERIC(OPsize		:integer:=4
	);
	PORT(rst, ena, clk					:IN STD_LOGIC;
		mov, done, nop, jnc, jc, jmp	:IN STD_LOGIC;
		add, sub, Nflag, Cflag, Zflag	:IN STD_LOGIC;
		jz, neg							:IN STD_LOGIC;
		OPC								:OUT STD_LOGIC_VECTOR(OPsize-1 downto 0);
		PCseL, RFaddr					:OUT STD_LOGIC_VECTOR(1 downto 0);
		Cout, Cin, Ain, wrRFen, RFout	:OUT STD_LOGIC := '0';
		IRin, PCin, imm_in, done_FSM	:OUT STD_LOGIC := '0'
	);
END CU;
---------------------------------------------------------------
ARCHITECTURE control_unit OF CU IS
	TYPE 	state IS (reset, fetch, cyc1, cyc2, cyc3);
	SIGNAL 	pr_state, nx_state							:state;
	SIGNAL 	OPC_t										:STD_LOGIC_VECTOR(OPsize-1 downto 0);
	SIGNAL 	PCseL_t, RFadder_t							:STD_LOGIC_VECTOR(1 downto 0) :="00";
	SIGNAL 	Cout_t, Cin_t, Ain_t, wrRFen_t, RFout_t		:STD_LOGIC :='0';
	SIGNAL	IRin_t, PCin_t, imm_in_t, done_FSM_t		:STD_LOGIC :='0';
	SIGNAL 	Cstat, Nstat, Zstat   						:STD_LOGIC :='0';  
	
BEGIN
-------------- Lower section: --------------
	PROCESS (rst,clk)
		BEGIN
		
UpdateState:
		IF (rst='1') THEN
			pr_state 	<= reset;
			OPC 		<= "0000";
			PCseL 		<= "11";
			RFaddr		<= "00";
			PCin 		<= '1';
			Cout 		<= '0';
			Cin 		<= '0';
			Ain 		<= '0';
			wrRFen 		<= '0';
			RFout 		<= '0';
			IRin 		<= '0';
			imm_in 		<= '0';
			done_FSM 	<= '0';
				
		ELSIF (rising_edge(clk) and ena='1') THEN
			pr_state 	<= nx_state;
			IRin 		<= IRin_t;
			Cout 		<= Cout_t;
			Cin 		<= Cin_t;
			OPC 		<= OPC_t;
			Ain 		<= Ain_t;
			wrRFen 		<= wrRFen_t;
			RFout 		<= RFout_t;
			RFaddr 		<= RFadder_t;
			PCin 		<= PCin_t;
			PCseL 		<= PCseL_t;
			imm_in		<= imm_in_t;
			done_FSM 	<= done_FSM_t;
		end IF;
	end PROCESS;

-------------- Upper section: --------------
	PROCESS (pr_state,add,sub,nop,jmp,jc,jnc,mov,jz,neg,done)
	BEGIN
		CASE pr_state IS
	---------------- Reset To Next State ----------------
			WHEN reset =>
				if (done_FSM_t = '0') then
					nx_state 	<= fetch;
					OPC_t 		<= "0000";
					RFadder_t 	<= "00";
					PCseL_t	 	<= "11";
					PCin_t 		<= '1';
					IRin_t 		<= '1';	
					Cout_t 		<= '0';
					Cin_t 		<= '0';
					Ain_t 		<= '0';
					wrRFen_t 	<= '0';
					RFout_t 	<= '0';
					imm_in_t 	<= '0';
					done_FSM_t 	<= '0';
					Cstat		<= '0';
					Nstat		<= '0';
					Zstat       <= '0';
				end if;
	---------------- Fetch To Next State ----------------
			WHEN fetch =>
				nx_state 	<= cyc1;
				IRin_t <= '0';
				PCin_t <= '1';
			    if(add ='1' or sub ='1' or nop ='1' or neg = '1') then -- R type command
					PCseL_t 	<= "01";
					RFout_t 	<= '1';
					Ain_t 		<= '1';
					imm_in_t 	<= '0';
					Cout_t 		<= '0';
					Cin_t 		<= '0';
					wrRFen_t 	<= '0';
					if (neg = '1') then
						RFadder_t 	<= "11";
					else
						RFadder_t 	<= "01";
					end if;
					
				elsif (jmp ='1' or jc ='1' or jnc ='1' or jz = '1') then -- j Type command
					RFout_t 	<= '0';
					Ain_t 		<= '0';
					imm_in_t 	<= '0';
					Cout_t 		<= '0';
					Cin_t 		<= '0';
					wrRFen_t 	<= '0';
					if (jmp ='1' or (jc ='1' and Cstat ='1') or (jnc ='1' and Cstat ='0') or (jz = '1' and Zstat = '1')) then
						PCseL_t <= "10";
					else
						PCseL_t <= "01";
					end if;
				
				elsif (mov = '1' or done = '1') then --I type command 
					Ain_t 		<= '0';
					Cout_t 		<= '0';
					Cin_t 		<= '0';
					RFout_t 	<= '0';
					if (mov ='1') then
						PCseL_t 	<= "01";
						RFadder_t 	<= "00";
						imm_in_t 	<= '1'; 
						wrRFen_t 	<= '1';
					elsif (done = '1') then
						PCseL_t 	<= "01";
						imm_in_t 	<= '0'; 
						wrRFen_t 	<= '0';
						if (done_FSM_t = '0') then
							done_FSM_t 	<= '1';
						end if;
					end if;
				end if;
	---------------- Cyc1 To Next State ----------------
			WHEN cyc1 =>
				PCseL_t 	<= "01";
				PCin_t 		<= '0'; 
				imm_in_t 	<= '0';
				wrRFen_t 	<= '0';
				Cout_t 		<= '0';
				Ain_t 		<= '0';
				if (add ='1' or nop ='1' or sub ='1' or neg = '1') then  -- R type command
					nx_state	<= cyc2;
					OPC_t 		<= "0000";
					Cin_t 		<= '1';	
					RFout_t 	<= '1'; 
					IRin_t 		<= '0';
					if (add ='1' or nop ='1') then
						OPC_t 		<= "0000";
						RFadder_t 	<= "10";
					elsif (sub ='1') then
						OPC_t 		<= "0001";
						RFadder_t 	<= "10";
					elsif (neg = '1') then
						OPC_t 		<= "0011";
						RFadder_t 	<= "01";
					end if;
									
				else                                 -- I/J type command
					nx_state 	<= fetch;		
					IRin_t 		<= '1';
					Cin_t 		<= '0';	
					RFout_t 	<= '0';
				end if;	
	---------------- Cyc2 To Next State ----------------
			WHEN cyc2 =>
				nx_state 	<= cyc3;
				RFadder_t 	<= "00";				
				wrRFen_t 	<= '1';
				Cout_t 		<= '1';
				PCin_t 		<= '0';
				RFout_t 	<= '0'; 
				Cin_t 		<= '0';
				IRin_t 		<= '0';
				imm_in_t 	<= '0';
				Ain_t 		<= '0';
		---------------- Cyc3 To Next State ----------------
			WHEN cyc3 =>
				nx_state 	<= fetch;
				Cstat		<= Cflag;
				Nstat		<= Nflag;
				Zstat       <= Zflag;
				IRin_t 		<= '1';	
				wrRFen_t 	<= '0';
				Cout_t 		<= '0';	
				Ain_t 		<= '0';
				RFout_t 	<= '0'; 
				Cin_t 		<= '0';
				imm_in_t 	<= '0';
				PCin_t 		<= '0';	
				
		end CASE;
	end PROCESS;
end control_unit;	