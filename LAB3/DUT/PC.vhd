LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
----------------------------------------
entity PC is 
	generic(MemAddrSize: integer:=6;
			OffsetSize 	:integer:=5
	);
	port(clk		:in  std_logic;
		offset_addr	:in  std_logic_vector(OffsetSize-1 downto 0);
		PCseL 		:in  std_logic_vector(1 downto 0);
		PCin 		:in	 std_logic ;
		PCReg	 	:out std_logic_vector(MemAddrSize-1 downto 0) := "000000"
	);
end PC;
-----------------------------------------
ARCHITECTURE PC OF PC IS
	signal Next_PC, Present_PC	:std_logic_vector(MemAddrSize-1 downto 0) := (others =>'0'); 
	signal ExtOffset            :std_logic_vector(MemAddrSize-1 downto 0); 
begin 

PCReg <= Present_PC;

ExtOffset(OffsetSize-1 downto 0)<= offset_addr;
ExtOffset(MemAddrSize-1) 		<= offset_addr(OffsetSize-1);

PcRegister: process(clk)
			begin
				if (rising_edge(clk)) then
					if (PCin='1') then 
						Present_PC <= Next_PC;
					end if;
				end if;
			end process;

PcInc:	with PCseL select 
			Next_PC <= 	Present_PC + 1 				when "01",
						Present_PC + ExtOffset + 1 	when "10",
						(others =>'0') 				when others;


end PC;
