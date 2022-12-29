LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY FA IS
	PORT (ai, bi, cin	:IN  std_logic;
		  s, cout		:OUT std_logic
	);
END FA;
--------------------------------------------------------
ARCHITECTURE dataflow OF FA IS
BEGIN
	s 	 <=  ai XOR bi XOR cin;
	cout <= (ai AND bi) OR (ai AND cin) OR (bi AND cin);
END dataflow;

