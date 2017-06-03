library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
	port (	clk			        : in std_logic;
			rst 		        : in std_logic;
			wr_en		        : in std_logic;
            pc_sel              : in unsigned (1 downto 0);
            pc_data_branch      : in unsigned (8 downto 0);
			pc_data_jump	    : in unsigned (15 downto 0);
			pc_saida		    : out unsigned (15 downto 0)
	);
end entity;

architecture a_PC of PC is

	component reg16bits is
		port(	
				clk 		: in std_logic;
				rst 		: in std_logic;
				wr_en 		: in std_logic;
				data_in 	: in unsigned (15 downto 0);
				data_out 	: out unsigned (15 downto 0)
		);
	end component;

	signal reg_in, somado, constante_branch, reg_out : unsigned (15 downto 0);

begin
	
	reg : reg16bits port map 	(
									clk => clk, 
									rst => rst, 
									wr_en => wr_en, 
									data_in => reg_in, 
									data_out => reg_out
								);
    
    -- Extensão de sinal
    constante_branch (8 downto 0) <= pc_data_branch;
    constante_branch (15 downto 9) <= (others => pc_data_branch(8));   -- copia o valor do MSB
    

--    constante_branch <= (others => pc_data_branch(8)) &  pc_data_branch; -- copia o valor do MSB

	somado <= reg_out + 1;
	
	reg_in <= 	somado                      when pc_sel = "00" else 
                somado + constante_branch   when pc_sel = "01" else
				pc_data_jump                when pc_sel = "10" else
                (others => '0');

	pc_saida <= reg_out;

end architecture;
