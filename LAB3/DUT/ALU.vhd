LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
-------------------------------------
ENTITY ALU IS
	GENERIC (BusSize 		:INTEGER := 16;
			OPsize			:INTEGER:=4
	);
	PORT(a, b				:IN  STD_LOGIC_VECTOR(BusSize-1 DOWNTO 0);
		OPC					:IN  STD_LOGIC_VECTOR(OPsize-1 DOWNTO 0);
        s_out 				:OUT STD_LOGIC_VECTOR(BusSize-1 DOWNTO 0);
        Cflag, Zflag, Nflag	:OUT STD_LOGIC
	);
END ALU;
------------------------------------------------
ARCHITECTURE ALU OF ALU IS
	SIGNAL Creg, s, Zvec, new_b :STD_LOGIC_VECTOR(BusSize-1 DOWNTO 0);

BEGIN

NegB: 	FOR j IN 0 TO BusSize-1 GENERATE
			new_b(j) <= (b(j) XOR '1') when (OPC = "0001" or OPC = "0011") else
						 b(j);
		END GENERATE;
	
FirstFA: 	FA PORT MAP(
				ai   => a(0),
				bi   => new_b(0),
				cin  => OPC(0),
				s    => s(0),
				cout => Creg(0));
			
ChainFA: 	FOR i IN 1 TO BusSize-1 GENERATE
				Chain: FA PORT MAP(
					ai 	 => a(i),
					bi 	 => new_b(i),
					cin  => Creg(i-1),
					cout => Creg(i),
					s 	 => s(i));
			END GENERATE;
	
	

		Zvec(0) <= s(0);
		Zcheck: FOR i IN 1 TO BusSize-1 GENERATE
			Zvec(i) <= s(i) or Zvec(i-1);
		END GENERATE;
		
		Zflag <= not(Zvec(BusSize-1));
		Cflag <= Creg(BusSize-1);
		Nflag <= s(BusSize-1);
		
ALURes:	s_out <= s;
	
END ALU;