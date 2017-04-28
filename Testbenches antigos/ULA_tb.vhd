library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA_tb is
end entity;

architecture a_ULA_tb of ULA_tb is
	component ULA
		port (	in_a : in unsigned(15 downto 0);
		  		in_b : in unsigned(15 downto 0);
		  		sel_op : in unsigned(1 downto 0);
		  		saida : out unsigned(15 downto 0);
		  		maior : out std_logic;
		  		igual : out std_logic
		  );
	end component;
	
	signal sel : unsigned(1 downto 0);
	signal a, b, saida : unsigned(15 downto 0);
	signal maior, igual : std_logic;
----------------------------------------
	begin
	uut : ULA port map (in_a => a, in_b => b, sel_op => sel, saida => saida, maior => maior, igual => igual);

	process
	begin
		a <= "0011001100110011";
		b <= "0010001000100010";
		wait for 200 ns;
		a <= "0000000000000011";
		b <= "1000000000001000";
		wait for 200 ns;
		a <= "1010101101100010";
		b <= "1010101101100010";
		wait for 200 ns;
		a <= "1010101101100010";
		b <= "0010101101100010";
		wait for 200 ns;
		wait;
	end process;

	process
	begin
		sel <= "00";
		wait for 50 ns;
		sel <= "01";
		wait for 50 ns;
		sel <= "10";
		wait for 50 ns;
		sel <= "11";
		wait for 50 ns;

		sel <= "00";
		wait for 50 ns;
		sel <= "01";
		wait for 50 ns;
		sel <= "10";
		wait for 50 ns;
		sel <= "11";
		wait for 50 ns;

		sel <= "00";
		wait for 50 ns;
		sel <= "01";
		wait for 50 ns;
		sel <= "10";
		wait for 50 ns;
		sel <= "11";
		wait for 50 ns;
		
		wait;
	end process;

end architecture;	