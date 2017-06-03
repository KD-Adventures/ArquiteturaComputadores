library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity	RAM is
	port (
			clk 			: in std_logic;
			ram_wr_en 		: in std_logic;
			ram_address 	: in unsigned (6 downto 0);
			ram_data_in 	: in unsigned (15 downto 0);
			ram_data_out 	: out unsigned (15 downto 0)
		 );
end entity;

architecture a_RAM of RAM is
	type mem is array (0 to 127) of unsigned (15 downto 0);
	signal ram_data : mem;

begin

	process(clk, ram_wr_en)
	begin
		if rising_edge(clk) then
			if ram_wr_en = '1' then
				ram_data(to_integer(ram_address)) <= ram_data_in;
			end if;
		end if;
	end process ; -- 

	ram_data_out <= ram_data(to_integer(ram_address));

end architecture ; -- a_ram