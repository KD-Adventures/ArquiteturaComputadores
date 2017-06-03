library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end entity;

architecture a_processador_tb of processador_tb is
	
	component processador
		port (	
				clk				: in std_logic;
			    rst				: in std_logic;
			    up_estado 		: out unsigned (1 downto 0);
			    up_pc			: out unsigned (15 downto 0);
			    up_instruction 	: out unsigned (13 downto 0);
			    up_reg 			: out unsigned (15 downto 0);
			    up_ula_saida	: out unsigned (15 downto 0);
			    up_ula_maior	: out std_logic;
			    up_ula_zero		: out std_logic;
			    up_w_saida		: out unsigned (15 downto 0);
			    ula_carry 		: out std_logic
			);	
	end component;

	signal clk, rst, ula_zero, ula_maior, ula_carry : std_logic;
	signal PC, reg, ula_saida, w_saida : unsigned (15 downto 0);
	signal estado : unsigned (1 downto 0);
	signal instruction : unsigned (13 downto 0);

	begin

	uut: processador port map	(
								clk 			=> clk,
								rst 			=> rst,
								up_estado 		=> estado,
								up_pc 			=> PC,
								up_instruction 	=> instruction,
								up_reg 			=> reg,
								up_ula_saida 	=> ula_saida,
								up_ula_maior	=> ula_maior,
								up_ula_zero 	=> ula_zero,
								up_w_saida 		=> w_saida,
								ula_carry 		=> ula_carry
							);

	process
	begin
		clk <= '0';		
		wait for 5 ns;
		clk <= '1';
		wait for 5 ns;
	end process;

	process
	begin
		rst <= '1';
		wait for 10 ns;
		rst <= '0';
		wait;
	end process;

end architecture;
