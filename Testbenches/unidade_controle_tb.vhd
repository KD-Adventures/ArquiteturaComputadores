library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidade_controle_tb is
end entity;

architecture a_unidade_controle_tb of unidade_controle_tb is
	
	component unidade_controle is
		port ( 	clk		: in std_logic;
				rst		: in std_logic;
				wr_en	: in std_logic;
				opcode 	: out unsigned (13 downto 0)
		);
	end component;

	signal clk, rst, wr_en : std_logic;
	signal opcode : unsigned (13 downto 0);

begin
	
	uut : unidade_controle port map (clk => clk, rst => rst, wr_en => wr_en, opcode => opcode);

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