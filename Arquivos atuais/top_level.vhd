library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top_level is
	port (	const_mux_ula		: in unsigned(15 downto 0);
			selecao_mux_ula 	: in std_logic;
			sel_operacao_ula	: in unsigned(1 downto 0);
			clock				: in std_logic;
			reset				: in std_logic;
			write_enable		: in std_logic;
			sel_reg1			: in unsigned(2 downto 0);
			sel_reg2			: in unsigned(2 downto 0);
			sel_write			: in unsigned(2 downto 0);
			saida_ula_top_level	: out unsigned(15 downto 0);
			maior_ula			: out std_logic;
			igual_ula			: out std_logic
	);
end entity;


architecture a_top_level of top_level is

	component ULA is
		port (	in_a : in unsigned(15 downto 0);
				in_b : in unsigned(15 downto 0);
				sel_op : in unsigned(1 downto 0);
				saida : out unsigned(15 downto 0);
				maior : out std_logic;
				igual : out std_logic
		);
	end component;
	
	component banco is
		port (	clk 			: in std_logic;
				rst 			: in std_logic;
				write_enable 	: in std_logic;
				sel_reg1 		: in unsigned (2 downto 0);
				sel_reg2 		: in unsigned (2 downto 0);
				sel_write 		: in unsigned (2 downto 0);
				write_data 		: in unsigned (15 downto 0);
				read_data1		: out unsigned (15 downto 0);
				read_data2 		: out unsigned (15 downto 0)
		);
	end component;
	
	signal ula_in_a, ula_in_b, ula_saida, read_data2 : unsigned(15 downto 0);
	

begin

	banco1: banco port map (
							clk => clock, 
							rst => reset, 
							write_enable => write_enable, 
							sel_reg1 => sel_reg1, 
							sel_reg2 => sel_reg2,
							sel_write => sel_write, 
							write_data => ula_saida, 
							read_data1 => ula_in_a, 
							read_data2 => read_data2
							);

	ula1: ULA port map (
						in_a => ula_in_a, 
						in_b => ula_in_b, 
						sel_op => sel_operacao_ula, 
						saida => ula_saida, 
						maior => maior_ula, 
						igual => igual_ula
						);
	
	ula_in_b <= read_data2 when selecao_mux_ula = '0' else
				const_mux_ula when selecao_mux_ula = '1' else
				X"0000";

	saida_ula_top_level <= ula_saida;

end architecture;