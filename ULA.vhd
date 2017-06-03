library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Codificação seleção
-- 000 - passa A		(A)
-- 001 - passa B 		(B)
-- 010 - soma 			(A + B)
-- 011 - subtracao 		(A - B)
-- 100 - ou inclusivo	(A OR B)

-- O bit ula_maior fica 1 quando A >= B, e só na operação de subtração !!!
-- Sim, devia se chamar "ula_maior_ou_igual", mas aí vai ter que mudar tudo


entity ULA is
  port (
	  		ula_in_a            : in unsigned(15 downto 0);
      		ula_in_b            : in unsigned(15 downto 0);
	  		ula_sel_op          : in unsigned(2 downto 0);
            ula_sel_bit         : in unsigned(2 downto 0);
	  		ula_saida           : out unsigned(15 downto 0);
	  		ula_maior           : out std_logic;
	  		ula_zero            : out std_logic;
            ula_bit_is_set	    : out std_logic;
            ula_carry			: out std_logic
  		);
end entity; -- ULA


architecture a_ULA of ULA is
	

	signal ula_in_a_17, ula_in_b_17, ula_soma_17 : unsigned (16 downto 0);


begin
	

	ula_in_a_17 <= '0' & ula_in_a;
	ula_in_b_17 <= '0' & ula_in_b;
	ula_soma_17 <= ula_in_a_17 + ula_in_b_17;
	ula_carry 	<= ula_soma_17 (16);

	ula_saida <= 	ula_in_a 					when ula_sel_op = "000" else
					ula_in_b 					when ula_sel_op = "001" else
					ula_soma_17 (15 downto 0) 	when ula_sel_op = "010" else
					ula_in_a - ula_in_b 		when ula_sel_op = "011" else
					ula_in_a OR ula_in_b 		when ula_sel_op = "100" else
					"0000000000000000";
	
	ula_zero <= '1' when ula_in_a = ula_in_b else
			 '0';

	ula_maior <= 	'1' when ula_in_a(15) = ula_in_b(15) AND ula_in_a(14 downto 0) > ula_in_b(14 downto 0) AND ula_sel_op = "11" else
					'1' when ula_in_a(15) = '0' AND ula_in_b(15) = '1' AND ula_sel_op = "11" else
					'1' when ula_in_a = ula_in_b else
			 		'0';

    ula_bit_is_set <= '1' when ula_in_a(to_integer(ula_sel_bit)) = '1' else '0';


end architecture ; -- a_ULA
