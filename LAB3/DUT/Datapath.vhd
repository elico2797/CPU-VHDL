library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
USE work.aux_package.all;
--------------------------------------------------------------
entity Datapath is
	generic( BusSize		:integer:=16;
			 SignExt		:integer:=8;
			 MemAddrSize	:integer:=6;
			 RfAddrSize		:integer:=4;
			 OPsize			:integer:=4);
	port(	----------- Top -> DataPath Input -----------
			rst 							 :in std_logic;
			----------- Control -> DataPath Input -----------
			Cout, Cin, Ain, wrRFen, RFout	 :in STD_LOGIC;
			IRin, PCin, imm_in				 :in STD_LOGIC;
			OPC  							 :in std_logic_vector(OPsize-1 downto 0);
			PCseL, RFaddr  					 :in std_logic_vector(1 downto 0);
			----------- DataPath -> Control Output -----------
			mov, done, nop, jnc, jc, jmp	 :out STD_LOGIC;
			add, sub, Nflag, Cflag, Zflag 	 :out STD_LOGIC;
			jz, neg						 	 :out STD_LOGIC;
			----------- DataPath <-> TB -----------
			TBactive, TBwriteENA, memEn, clk :in std_logic;
			TBdataWrite, WmemData			 :in std_logic_vector(BusSize-1 DOWNTO 0);
			WmemAddr						 :in std_logic_vector(MemAddrSize-1 DOWNTO 0);
			TBReAddr, TBwrAddr			 	 :in std_logic_vector(RfAddrSize-1 downto 0);
			TBdataRead  					 :out std_logic_vector(BusSize-1 DOWNTO 0)	
	);
end Datapath;
--------------------------------------------------------------
architecture Datapath of Datapath is

signal BusLine, ALUout				:std_logic_vector(BusSize-1 downto 0);
signal AReg, CReg, CToBus, MemToIR	:std_logic_vector(BusSize-1 DOWNTO 0);
signal immidiate					:std_logic_vector(BusSize-1 DOWNTO 0) := "0000000000000000";
signal SingExt						:std_logic_vector(7 downto 0);
signal OffsetIrToPc					:std_logic_vector(4 downto 0);
signal IRopToOpdecoder				:std_logic_vector(OPsize-1 downto 0);
signal PcToMem						:std_logic_vector(MemAddrSize-1 downto 0):="000000";
signal ReadRFData, WriteDataRF		:std_logic_vector(BusSize-1 DOWNTO 0);
signal IRaddr						:std_logic_vector(RfAddrSize-1 downto 0);
signal ReadAddrRF, WriteAddrRF		:std_logic_vector(RfAddrSize-1 downto 0) := "0000";
signal check,RFwriteENA,RfRst		:std_logic := '0';


begin	
----------------- Port Mapping -----------------	
	OP_Decoder1: OP_Decoder 	port map(OP => IRopToOpdecoder, mov => mov, done => done,
										 nop => nop, jnc => jnc, jc => jc, jmp => jmp,
										 add => add, sub => sub, jz => jz, neg => neg
								);
	IR1: IR 					port map(dataout => MemToIR ,IRin => IRin , RFaddr => RFaddr,
										 OP => IRopToOpdecoder ,ReadAddr => IRaddr,
										 offset_addr => OffsetIrToPc, SingExt => SingExt
								);
	ProgMem1: ProgMem 			port map(RmemData => MemToIR, RmemAddr => PcToMem, clk => clk,
										 memEn => memEn, WmemData => WmemData, WmemAddr => WmemAddr
								);
	PC1: PC 					port map(PCReg => PcToMem, PCseL => PCseL, PCin => PCin,
										 offset_addr => OffsetIrToPc, clk => clk
								);
	RF1: RF 					port map (WregEn => RFwriteENA, WregData => WriteDataRF,
										  RregData => ReadRFData, WregAddr => WriteAddrRF,
										  RregAddr => ReadAddrRF, clk => clk, rst => RfRst
								);
	ALU1: ALU 					port map (a => AReg, b => BusLine, s_out => ALUout ,OPC => OPC,
										  Cflag => Cflag, Zflag => Zflag, Nflag => Nflag
								);
------------------ Data Path ------------------	
Registers:  PROCESS (clk)
				BEGIN
					IF (rising_edge(clk)) THEN
						IF Ain = '1' THEN
							AReg <= BusLine;
						END IF;
						IF Cin = '1' THEN
							CReg <= ALUout;
						END IF;
					END IF;
			END PROCESS;		   
	
	
			immidiate(SignExt-1 downto 0) 		<= SingExt;
			immidiate(BusSize-1 downto SignExt) <= (others => SingExt(SignExt-1));
			TBdataRead 							<= ReadRFData;

Bus_Line:	BusLine <=  ReadRFData  when (RFout  = '1')  else  (others => 'Z');
			BusLine <=  CReg  		when (Cout   = '1')  else  (others => 'Z');
			BusLine <=  immidiate  	when (imm_in = '1')  else  (others => 'Z');

	
RfControl:	ReadAddrRF  <= IRaddr  	when (TBactive ='0') else TBReAddr;	
			WriteAddrRF <= IRaddr  	when (TBactive ='0') else TBWrAddr;
			RFwriteENA  <= wrRFen  	when (TBactive ='0') else TBwriteENA;
			WriteDataRF <= BusLine 	when (TBactive ='0') else TBdataWrite;	
			RfRst       <= rst 		when (TBactive ='0') else '0';
	
end Datapath;
