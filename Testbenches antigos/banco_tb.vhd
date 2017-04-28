library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_tb is
end entity;

architecture a_banco_tb of banco_tb is
	component banco is
		port(
				clk 			: in std_logic;
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
	signal sel_reg1, sel_reg2, sel_write : unsigned (2 downto 0);
	signal clk, rst, write_enable : std_logic;
	signal write_data, read_data2, read_data1 : unsigned (15 downto 0);

begin
	uut: banco port map(clk => clk, rst => rst, write_data => write_data, sel_reg1 => sel_reg1, sel_reg2 => sel_reg2, 
						sel_write => sel_write, write_enable => write_enable, read_data1 => read_data1, read_data2 => read_data2);


	process
	begin
		clk <= '0';
		wait for 50 ns;
		clk <= '1';
		wait for 50 ns;
	end process;

	process
	begin
		rst <= '1';
		wait for 100 ns;
		rst <= '0';
		wait;
	end process ; 

	process
	begin 
		write_enable <= '0';
		wait for 100 ns;
		write_enable <= '1';
		wait for 100 ns;
		write_enable <= '0';
		wait for 200 ns;
		write_enable <= '1';
		wait for 100 ns;
		write_enable <= '0';
		wait;
	end process;

	process
	begin
		sel_reg1 <= "000";
		sel_reg2 <= "001";
		write_data <= x"AAAA";
		sel_write <= "000";
		wait for 175 ns;
		write_data <= x"BBBB";
		sel_write <= "001";
		wait for 100 ns;
		sel_reg1 <= "010";
		sel_reg2 <= "011";
		write_data <= x"CCCC";
		sel_write <= "010";
		wait for 100 ns;
		write_data <= x"DDDD";
		sel_write <= "011";
		wait;
	end process;

end architecture;