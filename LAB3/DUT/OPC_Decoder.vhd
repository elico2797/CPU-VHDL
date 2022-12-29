LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
---------------------------------------------------------------

ENTITY OP_Decoder IS
	GENERIC(OPsize		:integer:=4
	);
	port(OP					:IN  STD_LOGIC_VECTOR(3 downto 0); 
		mov, done, jnc, jc	:OUT STD_LOGIC;
		jmp, add, sub, nop	:OUT STD_LOGIC;
		jz, neg				:OUT STD_LOGIC
	);
END OP_Decoder;
---------------------------------------------------------------
ARCHITECTURE OP_Decoder1 OF OP_Decoder IS
BEGIN
	WITH OP SELECT
		add <= 	'1' when "0000",
				'0' when others;
	WITH OP SELECT
		sub <= 	'1' when "0001",
				'0' when others;
	WITH OP SELECT
		nop <= 	'1' when "0010",
				'0' when others;
	WITH OP SELECT
		jmp <= 	'1' when "0100",
				'0' when others;
	WITH OP SELECT
		jc <= 	'1' when "0101",
				'0' when others;
	WITH OP SELECT
		jnc <= 	'1' when "0110",
				'0' when others;
	WITH OP SELECT
		mov <= 	'1' when "1000",
				'0' when others;
	WITH OP SELECT
		done <= '1' when "1001",
				'0' when others;
	WITH OP SELECT
		jz <= '1' when "0111",
				'0' when others;
	WITH OP SELECT
		neg <= '1' when "0011",
				'0' when others;
end OP_Decoder1;
		