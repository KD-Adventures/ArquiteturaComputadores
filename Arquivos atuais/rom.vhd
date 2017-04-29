library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--------------ESPECIFICACOES PIC16F1618---------------------
--- O PC tem 15 bits, entao existem 32k endereços na ROM.
--- Os opcodes do PIC sao de 14 bits, entao esse e o tamanho
---		do dado da ROM.										 

entity rom is
	port(	clk 		: in std_logic;
			endereco 	: in unsigned (14 downto 0);
			dado		: out unsigned (13 downto 0)
	);
end entity;

architecture a_rom of rom is
	
	type mem is array (0 to 127) of unsigned(13 downto 0);

	constant conteudo_rom : mem := (
		-- caso endereco => conteudo
		0 => "00001000100010",
		1 => "00001100110011",
		2 => "00010101010101",
		3 => "11111111111111",
		others => (others=>'0')
	);

begin
	
	process(clk)
	begin
		if(rising_edge(clk)) then
			dado <= conteudo_rom(to_integer(endereco));
		end if;
	end process;

end architecture;
