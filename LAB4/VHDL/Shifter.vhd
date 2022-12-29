---------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
-------------------------------------
ENTITY Shifter IS
	GENERIC (n 		:INTEGER;
             k 		:INTEGER
			 );
    PORT (Y			:IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  X			:IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  dir		:IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		  output	:OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		  cout		:OUT STD_LOGIC
		  );
END Shifter;
-------------------------------------

architecture shifter of shifter is
	--zeros is std_logic_vector (n-1 to 0);
	signal	 c_vec 		:std_logic_vector (k downto 0);
	subtype vector is 	std_logic_vector (n-1 downto 0);
	type 	matrix is 	array (k downto 0) of vector;
	signal 	matrix_G	:matrix;
	
BEGIN
	--zeros <= (others => 0);
	
	G_dir1: for i in 0 to n-1 generate
		matrix_G(0)(i) <= Y(n-1-i) 		when dir(0) = '1' else
						  Y(i); 	-- when (dir = "01")
	end generate;
	
	G_Bshifter: for lvl in 0 to k-1 generate
		matrix_G(lvl+1)(n-1 downto 2**lvl) <= matrix_G(lvl)(n-1-2**lvl downto 0)		when x(lvl) = '1' else
											  matrix_G(lvl)(n-1 downto 2**lvl); 	-- when (x(lvl) = '0');
											  
		matrix_G(lvl+1)(2**lvl-1 downto 0) <= (others => '0') 					 		when x(lvl) = '1' else
											  matrix_G(lvl)(2**lvl-1 downto 0);		-- when (x(lvl) = '0');
	end generate;
	
	G_dir2: for i in 0 to n-1 generate
		output(i) <= matrix_G(k)(n-1-i)  	when dir(0) = '1' else
					 matrix_G(k)(i); 	-- when (dir = "01") else
	end generate;
	
	
	c_vec(0) <= '0';
	C_G: for i in 0 to k-1 generate
		c_vec(i+1) <= matrix_G(i)(n-2**i) 	when x(i) = '1' else
					  c_vec(i); 			-- when (x(i) = '0'); 
	end generate;
	
	cout <= c_vec(k);
	
	end shifter;
	




