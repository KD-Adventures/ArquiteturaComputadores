library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_counter is
	port (	clk		: in std_logic;
			rst 	: in std_logic;
			wr_en	: in std_logic;
			saida 	: out unsigned (14 downto 0)
	);
end entity;

architecture a_program_counter of program_counter is

	component registrador_pc is
		port(	clk : in std_logic;
				rst : in std_logic;
				wr_en : in std_logic;
				data_in : in unsigned (14 downto 0);
				data_out : out unsigned (14 downto 0)
		);
	end component;

	signal reg_in, reg_out : unsigned (14 downto 0);

begin
	
	reg : registrador_pc port map (clk => clk, rst => rst, wr_en => wr_en, data_in => reg_in, data_out => reg_out);

	reg_in <= reg_out + 1;
	saida <= reg_out;

end architecture;