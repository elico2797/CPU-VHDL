-- VHDL Entity MIPS.MIPS_tester.interface
--
-- Created:
--          by - kolaman.UNKNOWN (KOLAMAN-PC)
--          at - 09:22:44 17/02/2013
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2011.1 (Build 18)
--
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY MIPS_tester IS
	PORT( 
		reset, clock					: OUT 	STD_LOGIC; 
		ena								: OUT 	STD_LOGIC; 
		ena_INPUT						: OUT 	STD_LOGIC;
		PBADD							: OUT 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		BreakPoint						: IN 	STD_LOGIC
	);

-- Declarations

END MIPS_tester ;

--
-- VHDL Architecture MIPS.MIPS_tester.struct
--
-- Created:
--          by - kolaman.UNKNOWN (KOLAMAN-PC)
--          at - 09:22:44 17/02/2013
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2011.1 (Build 18)
--
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;


ARCHITECTURE struct OF MIPS_tester IS

   -- Architecture declarations

   -- Internal signal declarations


   -- ModuleWare signal declarations(v1.9) for instance 'U_0' of 'clk'
   SIGNAL mw_U_0clk : std_logic;
   SIGNAL mw_U_0disable_clk : boolean := FALSE;

   -- ModuleWare signal declarations(v1.9) for instance 'U_1' of 'pulse'
   SIGNAL mw_U_1pulse : std_logic :='0';


BEGIN

   -- ModuleWare code(v1.9) for instance 'U_0' of 'clk'
   u_0clk_proc: PROCESS
   BEGIN
      WHILE NOT mw_U_0disable_clk LOOP
         mw_U_0clk <= '0', '1' AFTER 50 ns;
         WAIT FOR 100 ns;
      END LOOP;
      WAIT;
   END PROCESS u_0clk_proc;
   mw_U_0disable_clk <= TRUE AFTER 100000 ns;
   clock <= mw_U_0clk;

   -- ModuleWare code(v1.9) for instance 'U_1' of 'pulse'
   reset <= not(mw_U_1pulse);
   ena <= '1';
   ena_INPUT <= '0';
   u_1pulse_proc: PROCESS
   BEGIN
      mw_U_1pulse <= '0',
         '1' AFTER 20 ns,
         '0' AFTER 120 ns;
      WAIT;
    END PROCESS u_1pulse_proc;

   -- Instance port mappings.

END struct;
