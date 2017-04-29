library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maquina_estados_tb is
end entity;

architecture a_maquina_estados_tb of maquina_estados_tb is

	component maquina_estados
		port (	clk 	: in std_logic;
				rst 	: in std_logic;
				estado 	: out std_logic
		);
	end component;

	signal clk, rst, estado : std_logic;

begin
	
	uut : maquina_estados port map (clk => clk, rst => rst, estado => estado);

	process
	begin
		rst <= '1';
		wait for 100 ns;
		rst <= '0';
		wait;
	end process;

	process
	begin
		clk <= '1';
		wait for 50 ns;
		clk <= '0';
		wait for 50 ns;
	end process;

end architecture;