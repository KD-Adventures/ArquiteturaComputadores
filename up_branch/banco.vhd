library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity banco is
 	port (
			clk 			: in std_logic;
			rst 			: in std_logic;
			bc_write_enable : in std_logic;
			bc_sel_reg 		: in unsigned (2 downto 0);
			bc_sel_write 	: in unsigned (2 downto 0);
			bc_write_data 	: in unsigned (15 downto 0);
			bc_read_data	: out unsigned (15 downto 0)
	);	
end entity ; -- banco


architecture a_banco of banco is
			
	component reg16bits is
		port(	
				clk 		: in std_logic;
				rst 		: in std_logic;
				wr_en 		: in std_logic;
				data_in 	: in unsigned (15 downto 0);
				data_out 	: out unsigned (15 downto 0)
		);
	end component;

	signal  demux_saida0_reg0_wr_en, demux_saida1_reg1_wr_en, demux_saida2_reg2_wr_en, demux_saida3_reg3_wr_en, demux_saida4_reg4_wr_en, 
			demux_saida5_reg5_wr_en, demux_saida6_reg6_wr_en, demux_saida7_reg7_wr_en : std_logic;
	signal 	data_out_1, data_out_2, data_out_3, data_out_4, data_out_5, data_out_6, data_out_7 : unsigned (15 downto 0);
	signal 	data_out_0 : unsigned (15 downto 0) := x"0000";

begin

	demux_saida0_reg0_wr_en <=  '0';
	demux_saida1_reg1_wr_en <=	bc_write_enable when bc_sel_write = "001" else '0';
	demux_saida2_reg2_wr_en <=	bc_write_enable when bc_sel_write = "010" else '0';
	demux_saida3_reg3_wr_en <=	bc_write_enable when bc_sel_write = "011" else '0';
	demux_saida4_reg4_wr_en <=	bc_write_enable when bc_sel_write = "100" else '0';
	demux_saida5_reg5_wr_en <=	bc_write_enable when bc_sel_write = "101" else '0';
	demux_saida6_reg6_wr_en <=	bc_write_enable when bc_sel_write = "110" else '0';
	demux_saida7_reg7_wr_en <=	bc_write_enable when bc_sel_write = "111" else '0';

	reg0: reg16bits port map(	clk 		=> clk, 
								rst 		=> rst, 
								wr_en 		=> demux_saida0_reg0_wr_en, 
								data_in 	=> x"0000", 
								data_out 	=> data_out_0 
							);

	reg1: reg16bits port map(	clk 		=> clk, 
								rst 		=> rst, 
								wr_en 		=> demux_saida1_reg1_wr_en, 
								data_in 	=> bc_write_data, 
								data_out 	=> data_out_1
							);
	
	reg2: reg16bits port map(	clk 		=> clk, 
								rst 		=> rst, 
								wr_en 		=> demux_saida2_reg2_wr_en, 
								data_in 	=> bc_write_data, 
								data_out 	=> data_out_2
							);

	reg3: reg16bits port map(	clk 		=> clk, 
								rst 		=> rst, 
								wr_en 		=> demux_saida3_reg3_wr_en, 
								data_in 	=> bc_write_data, 
								data_out 	=> data_out_3
							);

	reg4: reg16bits port map(	clk 		=> clk, 
								rst 		=> rst, 
								wr_en 		=> demux_saida4_reg4_wr_en, 
								data_in 	=> bc_write_data, 
								data_out 	=> data_out_4
							);

	reg5: reg16bits port map(	clk 		=> clk, 
								rst 		=> rst, 
								wr_en 		=> demux_saida5_reg5_wr_en, 
								data_in 	=> bc_write_data, 
								data_out 	=> data_out_5
							);
	
	reg6: reg16bits port map(	clk 		=> clk, 
								rst 		=> rst, 
								wr_en 		=> demux_saida6_reg6_wr_en, 
								data_in 	=> bc_write_data, 
								data_out 	=> data_out_6
							);
	
	reg7: reg16bits port map(	clk 		=> clk, 
								rst 		=> rst, 
								wr_en 		=> demux_saida7_reg7_wr_en, 
								data_in 	=> bc_write_data, 
								data_out 	=> data_out_7
							);

	bc_read_data <= 	data_out_0 when bc_sel_reg = "000" else
						data_out_1 when bc_sel_reg = "001" else
						data_out_2 when bc_sel_reg = "010" else
						data_out_3 when bc_sel_reg = "011" else
						data_out_4 when bc_sel_reg = "100" else
						data_out_5 when bc_sel_reg = "101" else
						data_out_6 when bc_sel_reg = "110" else
						data_out_7 when bc_sel_reg = "111" else
						x"0000";


end architecture ; -- a_banco