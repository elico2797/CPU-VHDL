-- Write Back Unit --
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY WriteBack IS
	PORT( 	
		MemtoReg 	:IN  STD_LOGIC;
		ALU_result 	:IN  STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		read_data	:IN  STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		write_data	:OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 )
	);
END WriteBack;

ARCHITECTURE behavior OF WriteBack IS

BEGIN           
	
	write_data <= ALU_result( 31 DOWNTO 0 ) 
		WHEN ( MemtoReg = '0' ) ELSE read_data;
   END behavior;


