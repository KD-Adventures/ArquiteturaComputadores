library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity demux8 is
  port (
		sel 	: in unsigned(2 downto 0);
		entrada	: in std_logic;
		saida0 	: out std_logic;
		saida1 	: out std_logic;
		saida2 	: out std_logic;
		saida3 	: out std_logic;
		saida4 	: out std_logic;
		saida5 	: out std_logic;
		saida6 	: out std_logic;
		saida7 	: out std_logic
  ) ;
end entity ; -- demux8

architecture a_demux8 of demux8 is
begin

	saida0 <= 	entrada when sel="000" else
				'0';
	saida1 <= 	entrada when sel="001" else
				'0';
	saida2 <= 	entrada when sel="010" else
				'0';
	saida3 <= 	entrada when sel="011" else
				'0';
	saida4 <= 	entrada when sel="100" else
				'0';
	saida5 <= 	entrada when sel="101" else
				'0';
	saida6 <= 	entrada when sel="110" else
				'0';
	saida7 <= 	entrada when sel="111" else
				'0';

end architecture ; -- a_demux8