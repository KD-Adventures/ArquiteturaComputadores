library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Codificação seleção
-- 00 - soma
-- 01 - subtração
-- 10 - AND
-- 11 -	A maior que B


entity ULA is
  port (in_a : in unsigned(15 downto 0);
  		in_b : in unsigned(15 downto 0);
  		sel_op : in unsigned(1 downto 0);
  		saida : out unsigned(15 downto 0);
  		maior : out std_logic;
  		igual : out std_logic
  ) ;
end entity ; -- ULA


architecture a_ULA of ULA is
begin
	saida <= in_a + in_b when sel_op = "00" else
			 in_a - in_b when sel_op = "01" else
			 in_a AND in_b when sel_op = "10" else
			 in_a OR in_b when sel_op = "11" else 
			 "0000000000000000";

	maior <= '1' when in_a(15) = in_b(15) AND in_a(14 downto 0) > in_b(14 downto 0) else
			'1' when in_a(15) = '0' AND in_b(15) = '1' else
			 '0';
	
	igual <= '1' when in_a = in_b else
			 '0';

end architecture ; -- a_ULA