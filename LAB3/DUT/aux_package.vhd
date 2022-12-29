LIBRARY ieee;
USE ieee.std_logic_1164.all;

package aux_package is
------------------------------ Top ------------------------------
	component top is 
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
	end component;
------------------------------ Control Unit ------------------------------
	component CU is 
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
	end component;
------------------------------ Data Path ------------------------------
	component Datapath is 
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
	end component;	
------------------------------ IR ------------------------------
	component IR is 
		generic( BusSize		:integer:=16;
				 SignExt		:integer:=8;
				 MemAddrSize	:integer:=6;
				 RfAddrSize		:integer:=4;
				 OPsize			:integer:=4;
				 OffsetSize 	:integer:=5
		);
		port(
			dataout 		:IN std_logic_vector(BusSize-1 downto 0);
			RFaddr			:IN std_logic_vector(1 downto 0);
			IRin 			:IN std_logic; 
			SingExt 		:OUT std_logic_vector(SignExt-1 downto 0);
			offset_addr 	:OUT std_logic_vector(OffsetSize-1 downto 0);
			OP, ReadAddr	:OUT std_logic_vector(OPsize-1 downto 0)
			);
	end component;
------------------------------ PC ------------------------------
	component PC is 
		generic(MemAddrSize: integer:=6;
				OffsetSize 	:integer:=5
		);
		port(clk		:in  std_logic;
			offset_addr	:in  std_logic_vector(OffsetSize-1 downto 0);
			PCseL 		:in  std_logic_vector(1 downto 0);
			PCin 		:in	 std_logic ;
			PCReg	 	:out std_logic_vector(MemAddrSize-1 downto 0) := "000000"
		);
	end component;
------------------------------ OP Code Decoder ------------------------------
	component OP_Decoder is 
		GENERIC(OPsize		:integer:=4
		);
		port(OP					:IN  STD_LOGIC_VECTOR(OPsize-1 downto 0); 
			mov, done, jnc, jc	:OUT STD_LOGIC;
			jmp, add, sub, nop	:OUT STD_LOGIC;
			jz, neg				:OUT STD_LOGIC
		);
	end component;
------------------------------ ALU ------------------------------
	component ALU is 
		GENERIC (BusSize 		:INTEGER := 16;
				OPsize			:INTEGER:=4
		);
		PORT(a, b				:IN  STD_LOGIC_VECTOR(BusSize-1 DOWNTO 0);
			OPC					:IN  STD_LOGIC_VECTOR(OPsize-1 DOWNTO 0);
			s_out 				:OUT STD_LOGIC_VECTOR(BusSize-1 DOWNTO 0);
			Cflag, Zflag, Nflag	:OUT STD_LOGIC
		);
	end component;
------------------------------ FA ------------------------------
	component FA is
		PORT (ai, bi, cin	:IN  std_logic;
			  s, cout		:OUT std_logic
		);
	end component;
------------------------------ RF ------------------------------
	component RF is 
		generic(Dwidth	:integer:=16;
				Awidth	:integer:=4
		);
		port(clk,rst,WregEn		:in std_logic;	
			WregData			:in std_logic_vector(Dwidth-1 downto 0);
			WregAddr,RregAddr	:in std_logic_vector(Awidth-1 downto 0):= "0000";
			RregData			:out std_logic_vector(Dwidth-1 downto 0)
		);
	end component;
	
------------------------------ RAM Memory ------------------------------
	component ProgMem is 
		generic(Dwidth 	:integer:=16;
				Awidth 	:integer:=6;
				dept   	:integer:=64
		);
		port(clk,memEn			:in std_logic;	
			WmemData			:in std_logic_vector(Dwidth-1 downto 0);
			WmemAddr,RmemAddr	:in std_logic_vector(Awidth-1 downto 0) := "000000";
			RmemData			:out std_logic_vector(Dwidth-1 downto 0)
		);
	end component;
	
end aux_package;