library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_tb is
end entity;

architecture a_top_level_b of top_level_tb is
	
	component top_level
		port (	
			cte_mux_reg_ula	: in unsigned(15 downto 0);
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
	end component;

	signal cte_mux_reg_ula, saida_ula	: unsigned(15 downto 0);
	signal sel_op_ula :unsigned(1 downto 0);
	signal sel_mux_reg_ula, clock,	reset, write_enable, maior_ula, igual_ula : std_logic;
	signal sel_reg1, sel_reg2, sel_write : unsigned(2 downto 0);


	begin

	uut: top_level port map(
								cte_mux_reg_ula => cte_mux_reg_ula, 
								saida_ula => saida_ula, 
								sel_op_ula => sel_op_ula, 
								sel_mux_reg_ula => sel_mux_reg_ula,
								clock => clock, 
								reset => reset, 
								write_enable => write_enable, 
								maior_ula => maior_ula, 
								igual_ula => igual_ula, 
								sel_reg1 => sel_reg1, 
								sel_reg2 => sel_reg2, 
								sel_write => sel_write
							);

	process
	begin
		clock <= '0';
		wait for 50 ns;
		clock <= '1';
		wait for 50 ns;
	end process;

	process
	begin
		reset <= '1';
		wait for 100 ns;
		reset <= '0';
		wait;
	end process;

	process
	begin
	-- Escreve no banco de registradores

		-- Escreve 0x1111 no reg 001
		sel_reg1 <= "000"; 		--Seleciona reg 000
		sel_reg2 <= "000"; 
		write_enable <= '1';

		sel_mux_reg_ula <= '1';	--Mux seleciona a constante
		cte_mux_reg_ula <= X"1111";		
		sel_op_ula <= "00";		--Soma constante com reg 000

		sel_write <= "001";		--Salva no reg 001
		wait for 200 ns;

		-- Escreve 0xAAAA no registrador 010	
		cte_mux_reg_ula <= X"AAAA";

		sel_write <= "010";
		wait for 100 ns;


		-- Escreve a soma do reg 001 com o reg 010 no reg 011
		sel_mux_reg_ula <= '0';

		sel_reg1 <= "001";
		sel_reg2 <= "010";
		
		sel_write <= "011";
		wait for 100 ns;

		-- Soma 0xCCCC com o valor do reg 001 e salva no reg 100
		sel_mux_reg_ula <= '1';
		cte_mux_reg_ula <= X"CCCC";
		
		sel_reg1 <= "001";
		
		sel_write <= "100";
		wait for 200 ns;


	-- Verfica valores do banco de registradores

		-- Verifica se foi salvo o valor 0x1111 no reg 001
		write_enable <= '0';
		sel_mux_reg_ula <= '0';

		sel_reg1 <= "000";
		sel_reg2 <= "001";
		wait for 100 ns;

		-- Verifica se foi salvo o valor 0xAAAA no reg 010
		sel_reg1 <= "000";
		sel_reg2 <= "010";
		wait for 100 ns;


		-- Verifica se foi salvo o valor 0xBBBB no reg 011
		write_enable <= '0';

		sel_reg1 <= "000";
		sel_reg2 <= "011";
		wait for 100 ns;

		-- Verifica se foi salvo o valor 0xDDDD no reg 100
		write_enable <= '0';

		sel_reg1 <= "000";
		sel_reg2 <= "100";
		wait for 100 ns;


		-- Verificando que o reg 000 tem 0x0000
		sel_mux_reg_ula <= '1';
		cte_mux_reg_ula <= x"0000";
		
		sel_reg1 <= "000";
		wait for 100 ns;


		-- Tentando escrever 0xBBBB no reg 000
		write_enable <= '1';
		sel_mux_reg_ula <= '0';

		sel_reg1 <= "001";
		sel_reg2 <= "010";

		sel_write <= "000";
		wait for 100 ns;

		-- Verificando o valor de reg 000
		write_enable <= '0';
		sel_mux_reg_ula <= '1';
		cte_mux_reg_ula <= X"0000";

		sel_reg1 <= "000";
		wait;


	end process;

end architecture;
