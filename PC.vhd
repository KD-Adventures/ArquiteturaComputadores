library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
	port (	clk			: in std_logic;
			rst 		: in std_logic;
			wr_en		: in std_logic;
			pc_jump		: in std_logic;
			pc_data_jump	: in unsigned (15 downto 0);
			pc_saida		: out unsigned (15 downto 0)
	);
end entity;

architecture a_PC of PC is

	component reg16bits is
		port(	
				clk 		: in std_logic;
				rst 		: in std_logic;
				wr_en 		: in std_logic;
				data_in 	: in unsigned (15 downto 0);
				data_out 	: out unsigned (15 downto 0)
		);
	end component;

	signal reg_in, somado, reg_out : unsigned (15 downto 0);

begin
	
	reg : reg16bits port map 	(
										clk => clk, 
										rst => rst, 
										wr_en => wr_en, 
										data_in => reg_in, 
										data_out => reg_out
									);
	somado <= reg_out + 1;
	
	reg_in <= 	somado when pc_jump = '0' else 
				pc_data_jump;

	pc_saida <= reg_out;

end architecture;