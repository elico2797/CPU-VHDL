LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
----------------------------------------
entity	IR is 
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
end IR;
-----------------------------------------
ARCHITECTURE IR OF IR IS
	signal IRlatch	:std_logic_vector(BusSize-1 downto 0);
	
begin

 IrReg: IRlatch <= dataout when (IRin = '1');
		
IrOutWire:	OP 			<= 	IRlatch(15 downto 12);
			SingExt 	<= 	IRlatch(7 downto 0);
			offset_addr <= 	IRlatch(4 downto 0);

	
RegAddrMux:	with RFaddr select
				ReadAddr <= IRlatch(11 downto 8) when "00", 	-- R[ra]
							IRlatch(7 downto 4)  when "01", 	-- R[rb]
							IRlatch(3 downto 0)	 when "10",      -- R[rc]
							"0000" 				 when others; 	-- R[0]
end IR;
