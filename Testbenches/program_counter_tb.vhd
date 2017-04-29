library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_counter_tb is
end entity;

architecture a_program_counter_tb of program_counter_tb is

	component program_counter is
		port (	clk		: in std_logic;
				rst 	: in std_logic;
				wr_en	: in std_logic;
				saida 	: out unsigned (14 downto 0)
			);
	end component;

	signal clk, rst, wr_en : std_logic;
	signal saida : unsigned (14 downto 0);

begin
	
	pc : program_counter port map (clk => clk, rst => rst, wr_en => wr_en, saida => saida);

	process
	begin
		wr_en <= '1';
		wait;
	end process;

	process
	begin
		clk <= '0';
		wait for 50 ns;
		clk <= '1';
		wait for 50 ns;
	end process;

	process
	begin
		rst <= '1';
		wait for 100 ns;
		rst <= '0';
		wait;
	end process;

end architecture;