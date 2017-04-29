library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end entity;

architecture a_rom_tb of rom_tb is

	component rom is
			port(	clk 		: in std_logic;
					endereco 	: in unsigned (14 downto 0);
					dado		: out unsigned (13 downto 0)
			);
	end component;

	signal clk : std_logic;
	signal dado : unsigned (13 downto 0);
	signal endereco : unsigned (14 downto 0) := "000000000000000";

begin
	
	uut : rom port map (clk => clk, endereco => endereco, dado => dado);

	process
	begin
		clk <= '0';
		wait for 50 ns;
		clk <= '1';
		wait for 50 ns;
	end process;

	process
	begin
		wait for 100 ns;
		endereco <= endereco + 1;
	end process;

end architecture;