library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidade_controle is
	port ( 	clk		: in std_logic;
			rst		: in std_logic;
			wr_en	: in std_logic;
			opcode 	: out unsigned (13 downto 0)
	);
end entity;

architecture a_unidade_controle of unidade_controle is
	
	component rom is
		port(	clk 		: in std_logic;
				endereco 	: in unsigned (14 downto 0);
				dado		: out unsigned (13 downto 0)
		);
	end component;

	component program_counter is
		port (	clk		: in std_logic;
				rst 	: in std_logic;
				wr_en	: in std_logic;
				saida 	: out unsigned (14 downto 0)
		);
	end component;

	signal posicao_pc : unsigned (14 downto 0);

begin

	pc : program_counter port map (clk => clk, rst => rst, wr_en => wr_en, saida => posicao_pc);
	rom1 : rom port map (clk => clk, endereco => posicao_pc, dado => opcode);

end architecture;