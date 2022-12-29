LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------------------------------
entity top is
	generic (
		n : positive := 8 ;
		m : positive := 7 ;
		k : positive := 3
	); -- where k=log2(m+1)
	port(
		rst,ena,clk : in std_logic;
		x : in std_logic_vector(n-1 downto 0);
		DetectionCode : in integer range 0 to 3;
		detector : out std_logic
	);
end top;

architecture arc_sys of top is
	signal a,b,s,x1,x2: std_logic_vector(n-1 downto 0);
	signal valid: std_logic;	
	signal counter_signal: integer range 0 to m; 	

begin
	process1 : process (clk,rst) 
	begin	
		if(rst='1') then
			x1 <= (others=>'0');
			x2 <= (others=>'0');
		elsif (rising_edge(clk)) then 
			if (ena='1') then
				x2 <= x1;
				x1 <= x;
			end if;
		end if;
	end process process1;
	
	b <= not(x2);
	a <= x1;

	Adder_sub :Adder generic map(n) port map(a => a, b => b, cin => '1',s => s);
	
	
	process2 : process (s,DetectionCode)
		variable diff : std_logic_vector(n-1 downto 0);
		begin
			valid <= '0';
			case DetectionCode is
				when 0 => diff := (0=>'1',others =>'0');
				when 1 => diff := (1=>'1',others =>'0');
				when 2 => diff := (0=>'1',1=>'1',others =>'0');
				when 3 => diff := (2=>'1',others =>'0');
			end case;
			if (diff = s) then
				valid <= '1';
			end if;
	end process process2;
	
	
	process3 : process (clk,rst)
		begin
			if(rst='1') then
				counter_signal <= 0;
			elsif (rising_edge(clk)) then 
				if (ena = '1' and valid ='1') then
					if (counter_signal /= m) then 
						counter_signal <= counter_signal + 1;
					end if;
				elsif (ena = '1' and valid ='0') then 
					counter_signal <= 0;
				end if;
			end if; 
	end process process3;
		
	detector <= '1' when counter_signal = m else
				'0' when counter_signal /= m ;

end arc_sys;






