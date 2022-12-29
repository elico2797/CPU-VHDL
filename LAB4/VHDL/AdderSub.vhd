LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
-------------------------------------
ENTITY AdderSub IS
	GENERIC (n 				:INTEGER
			);
	PORT (SubControl		:IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		  Y,X				:IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  cout				:OUT STD_LOGIC;
	   	  output			:OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
		  );
END AdderSub;
-------------------------------------
ARCHITECTURE add_sub OF AdderSub IS

	COMPONENT FA IS
		PORT (xi,yi,cin		:IN STD_LOGIC;
			  s,cout		:OUT STD_LOGIC
			  );
	END COMPONENT;
	
	SIGNAL reg,new_x,new_y	:STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	SIGNAL control			:STD_LOGIC;
  
BEGIN

	control	<=	SubControl(0) or SubControl(1);
	
	-- xor x with subcontrol for subtraction
	G_sub: FOR j IN 0 TO n-1 GENERATE
			new_x(j) <= x(j) XOR control ;
	END GENERATE;
	
	G_neg: FOR j IN 0 TO n-1 GENERATE
			new_y(j) <= y(j) AND not(SubControl(1));
	END GENERATE;
	
	--new_y <= "00000000"  when SubControl = "10" else
	-- 		  y; 						-- when (SubControl = "00" or SubControl = "01") else
			  
-- connect first FA to the AdderSubtractor
	first : FA PORT MAP(
				xi 	 => new_x(0),
				yi 	 => new_y(0),
				cin  => control,
				s 	 => output(0),
				cout => reg(0)
	        );
	
	-- connect rest of FA to the AdderSubtractor
	rest : FOR i IN 1 TO n-1 GENERATE
			chain : FA PORT MAP(
				xi	 => new_x(i),
				yi 	 => new_y(i),
				cin  => reg(i-1),
				cout => reg(i),
				s 	 => output(i)
		    );
	END GENERATE;

	-- return flags need to be checked the case of substruct about the carry
	cout <= reg(n-1);
 
	
END add_sub;