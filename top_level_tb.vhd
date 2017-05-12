library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_tb is
end entity;

architecture a_top_level_tb of top_level_tb is
	
	component top_level
		port (	
				clk			: in std_logic;
				rst			: in std_logic;
				estado 		: out unsigned (1 downto 0);
				PC_o		: out unsigned (15 downto 0);
				instruction : out unsigned (13 downto 0);
				reg1 		: out unsigned (15 downto 0);
				reg2 		: out unsigned (15 downto 0);
				ula_saida_o	: out unsigned (15 downto 0);
				ula_maior	: out std_logic;
				ula_igual	: out std_logic
			);	
	end component;

	signal clk, rst, ula_maior, ula_igual : std_logic;
	signal PC, reg1, reg2, ula_saida : unsigned (15 downto 0);
	signal estado : unsigned (1 downto 0);
	signal instruction : unsigned (13 downto 0);

	begin

	uut: top_level port map	(
								clk => clk,
								rst => rst,
								estado => estado,
								PC_o => PC,
								instruction => instruction,
								reg1 => reg1,
								reg2 => reg2,
								ula_saida_o => ula_saida,
								ula_maior => ula_maior,
								ula_igual => ula_igual
							);

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
