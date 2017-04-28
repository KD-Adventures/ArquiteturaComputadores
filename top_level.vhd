library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top_level is
	port (	cte_mux_reg_ula	: in unsigned(15 downto 0);
			sel_mux_reg_ula : in std_logic;
			sel_op_ula		: in unsigned(1 downto 0);
			clock			: in std_logic;
			reset			: in std_logic;
			write_enable	: in std_logic;
			sel_reg1		: in unsigned(2 downto 0);
			sel_reg2		: in unsigned(2 downto 0);
			sel_write		: in unsigned(2 downto 0);
			saida_ula 		: out unsigned(15 downto 0);
			maior_ula		: out std_logic;
			igual_ula		: out std_logic
	);
end entity;


architecture a_top_level of top_level is

	component mux2 is
		port (
			sel 	: in std_logic;
			entr0 	: in unsigned(15 downto 0);
			entr1 	: in unsigned(15 downto 0);
			saida 	: out unsigned(15 downto 0)
		);
	end component;

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
	
	signal ula_a, ula_b, ula_saida, mux_in : unsigned(15 downto 0);
	

begin

	banco1: banco port map (
							clk => clock, 
							rst => reset, 
							write_enable => write_enable, 
							sel_reg1 => sel_reg1, 
							sel_reg2 => sel_reg2,
							sel_write => sel_write, 
							write_data => ula_saida, 
							read_data1 => ula_a, 
							read_data2 => mux_in
							);

	mux: mux2 port map (
						sel => sel_mux_reg_ula, 
						entr0 => mux_in, 
						entr1 => cte_mux_reg_ula, 
						saida => ula_b
						);
	
	ula1: ULA port map (
						in_a => ula_a, 
						in_b => ula_b, 
						sel_op => sel_op_ula, 
						saida => ula_saida, 
						maior => maior_ula, 
						igual => igual_ula
						);
	
	saida_ula <= ula_saida;

end architecture;