library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
--------------------------------------------------------------
entity top is
	generic( BusSize		:integer:=16;
			 SignExt		:integer:=8;
			 MemAddrSize	:integer:=6;
			 RfAddrSize		:integer:=4;
			 OPsize			:integer:=4
	);
	port(	clk, rst, ena				:in std_logic;
			TBactive, TBwriteENA, memEn	:in std_logic;
			TBdataWrite, WmemData		:in std_logic_vector(BusSize-1 downto 0);
			TBReAddr, TBwrAddr			:in std_logic_vector(RfAddrSize-1 downto 0) := "0000";
			WmemAddr					:in std_logic_vector(MemAddrSize-1 downto 0) := "000000";
			TBdataRead					:out std_logic_vector(BusSize-1 downto 0);
			done_FSM					:out std_logic:= '0'			
	);
end top;
--------------------------------------------------------------
architecture top of top is
	signal	OPC								:std_logic_vector(OPsize-1 downto 0);
	signal	PCseL, RFaddr					:std_logic_vector(1 downto 0);
	signal 	mov, done, nop, jnc, jc, jmp	:STD_LOGIC;
	signal 	add, sub, Nflag, Cflag, Zflag	:STD_LOGIC;
	signal 	jz, neg							:STD_LOGIC;
	signal 	Cout, Cin, Ain, wrRFen, RFout	:STD_LOGIC;
	signal	IRin, PCin, imm_in				:STD_LOGIC;

begin
	
	CU1: CU port map(
			rst => rst, ena => ena, clk => clk, Cout => Cout,
			Cin => Cin, Ain => Ain, wrRFen => wrRFen, RFout => RFout,
			IRin => IRin, PCin => PCin, imm_in => imm_in, OPC => OPC,
			PCseL => PCseL, RFaddr => RFaddr, mov => mov, done => done,
			nop => nop, jnc => jnc, jc => jc, jmp => jmp, add => add,
			sub => sub, Nflag => Nflag, Cflag => Cflag, Zflag => Zflag,
			done_FSM => done_FSM, jz => jz, neg => neg
	);
	

	Datapath1: Datapath port map(
			Cout => Cout, Cin => Cin, Ain => Ain, wrRFen => wrRFen,
			RFout => RFout, IRin => IRin, PCin => PCin, imm_in => imm_in,
			OPC => OPC, PCseL => PCseL ,RFaddr => RFaddr, mov => mov,
			done => done, nop => nop, jnc => jnc, jc => jc, jmp => jmp,
			add => add, sub=> sub, Nflag => Nflag, Cflag => Cflag, 
			Zflag => Zflag, TBactive => TBactive, TBwriteENA => TBwriteENA,
			memEn => memEn,clk => clk, TBdataWrite => TBdataWrite, 
			WmemData => WmemData, WmemAddr => WmemAddr, TBdataRead => TBdataRead,
			TBReAddr => TBReAddr, TBwrAddr => TBwrAddr, rst => rst, jz => jz, neg => neg
	);


end top;