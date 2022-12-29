LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
-------------------------------------
entity TB is 
	generic(Tcycle			:time := 50 ns
	);
	constant BusSize  		:integer := 16;
	constant MemAddrSize 	:integer := 6;  --- MEM_size is 2^6 = 64
	constant MemSize 		:integer := 64;  --- MEM_size is 2^6 = 64
	constant RfAddrSize 	:integer := 4;  --- RF_size is 2^4 = 16
	constant RfSize         :integer := 16;
end TB;
--------------------------------------------------
architecture TB of TB is
     ------------ MEM input ------------
	SIGNAL WmemData 	 :std_logic_vector(BusSize-1 downto 0); 
	SIGNAL WmemAddr		 :std_logic_vector(MemAddrSize-1 downto 0):= "000000";
	SIGNAL memEn 		 :std_logic := '0';
     ------------ RF input ------------
	SIGNAL TBdataWrite 	 :std_logic_vector(BusSize-1 downto 0);
	SIGNAL TBwrAddr  	 :std_logic_vector(RfAddrSize-1 downto 0):="0000";
	SIGNAL TBReAddr 	 :std_logic_vector(RfAddrSize-1 downto 0):="0000";
	SIGNAL TBwriteENA 	 :std_logic := '1';
	 ------------ RF output ------------
	SIGNAL TBdataRead 	 :std_logic_vector(BusSize-1 downto 0); 	
	 ---------- Simulation Input ----------   
	SIGNAL rst, TBactive 			 			  :std_logic := '1';
	SIGNAL ena, clk, done_program 		 		  :std_logic := '0';
	SIGNAL done_RFread, done_MEMread, done_RFwrite :boolean := false;
	---------- Simulation File Path ----------   
	CONSTANT read_RAMinit_location 				  :string(1 to 44) := 
	"C:\Users\amichais\Desktop\update\RAMinit.txt";
	CONSTANT read_RFinit_location 				  :string(1 to 43) :=
	"C:\Users\amichais\Desktop\update\RFinit.txt";
	CONSTANT write_RFcontent_location 			  :string(1 to 46) := 
	"C:\Users\amichais\Desktop\update\RFcontent.txt";
begin
	
	
	top1: top 	port map(clk => clk,rst => rst, ena => ena, TBactive => TBactive,
						TBwriteENA => TBwriteENA, memEn => memEn,
						TBdataWrite => TBdataWrite, WmemData => WmemData,
						TBReAddr => TBReAddr, TBwrAddr => TBwrAddr,
						WmemAddr => WmemAddr, TBdataRead => TBdataRead,
						done_FSM => done_program
				);
		
----------------- start simulation -----------------
SimClk: 	clk <= not clk after Tcycle;

	
Sim:process
		------------ MemRead Variable ------------
		file     MemInFile	:text open read_mode is read_RAMinit_location;
		variable MemL		:line;
		variable MemIn		:bit_vector(BusSize-1 downto 0);
		variable MemAddrVar :std_logic_vector(MemAddrSize-1 downto 0);
		------------ RfRead Variable ------------
		file RfInFile		:text open read_mode is read_RFinit_location;
		variable RfLr		:line;
		variable RfIn		:bit_vector(BusSize-1 downto 0);
		variable RfAddrVarR :std_logic_vector(RfAddrSize-1 downto 0);
		------------ RdWrite Variable ------------
		file RfOutFile 		:text open write_mode is write_RFcontent_location;
		variable RfLw 		:line;
		variable RfAddrVarW :std_logic_vector(RfAddrSize-1 downto 0);
				
		begin
			wait until (rising_edge(clk));
			
		-----------  Read Data - File To Memory -----------
			if not (done_MEMread) then
				MemAddrVar := "000000";
				memEn <= '1';
				while not endfile(MemInFile) loop
					wait until (falling_edge(clk));
					readline(MemInFile,MemL);
					hread(MemL,MemIn);
					WmemAddr <= MemAddrVar;
					WmemData <= to_stdlogicvector(MemIn);
					MemAddrVar := MemAddrVar + 1;
				end loop;
				
				file_close(MemInFile);
				report "Program is loaded to MEM" severity note;
				wait until (rising_edge(clk));
				done_MEMread <= true;
				memEn <= '0';
				if (done_RFread) then
					ena <= '1' ;
					rst <= '0';						
				end if;
					end if;
		-----------  Read Data - File To RF -----------
			if not (done_RFread) then
				TBwriteENA <= '1';
				RfAddrVarR := "0000";
				TBactive <= '1';
				while not endfile(RfInFile) loop
					wait until (falling_edge(clk));  
					readline(RfInFile,RfLr);
					hread(RfLr,RfIn);
					TBwrAddr  <= RfAddrVarR;
					TBdataWrite <= to_stdlogicvector(RfIn);
					RfAddrVarR := RfAddrVarR + 1;
				end loop;
				
				file_close(RfInFile);
				report "register initial is loaded to RF" severity note;
				wait until (rising_edge(clk));
				done_RFread <= true;			
				TBwriteENA <= '0';
				TBactive <= '0';
				if (done_MEMread) then
					ena <= '1';
					rst <= '0';
				end if;
			end if;
		-----------  Write Data - RF To File -----------	
			if (done_program = '1') and not(done_RFwrite)  then
				TBactive <= '1';
				RfAddrVarW := "0000";						
				for i in 0 to (RfSize-1) loop
					wait until (rising_edge(clk));
					hwrite(RfLw, to_bitvector(TBdataRead));
					writeline(RfOutFile,RfLw);
					RfAddrVarW := RfAddrVarW + 1;
					TBReAddr <= RfAddrVarW;
				end loop;
				
				done_RFwrite <= true;
				file_close(RfOutFile);
				report "the RF is update according the program" severity note;
				TBwriteENA <= '0';
				TBactive <= '0';
			end if;
			
	end process;
	
end architecture TB;