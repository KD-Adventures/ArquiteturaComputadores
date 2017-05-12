library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--------------ESPECIFICACOES PIC16F1618---------------------
--- O PC tem 15 bits, entao existem 32k endereços na ROM.
--- Os opcodes do PIC sao de 14 bits, entao esse e o tamanho
---		do dado da ROM.										 

entity ROM is
	port(	
			clk 		: in std_logic;
			rom_endereco: in unsigned (15 downto 0);
			rom_dado	: out unsigned (13 downto 0)
	);
end entity;

architecture a_ROM of ROM is
	
	type mem is array (0 to 2**16-1) of unsigned(13 downto 0);

	constant conteudo_rom : mem := (
		-- caso endereco => conteudo
		0 => "11000000000101",
		1 => "11000000000101",
		2 => "11000000001000",
		3 => "00000010000100",
		4 => "00100000000011",
		5 => "00011100000100",
		6 => "00000010000101",
		7 => "00100000000101",
		9 => "11110000000001",
		10 => "00000010000101",
		11 => "10100000010100",
		20 => "00100000000101",
		21 => "00000010000011",
		22 => "10100000000011",
		others => (others=>'0')
	);

begin
	
	process(clk)
	begin
		if(rising_edge(clk)) then
			rom_dado <= conteudo_rom(to_integer(unsigned(rom_endereco)));	
		end if;
	end process;

end architecture;