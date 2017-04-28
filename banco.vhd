library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity banco is
 	port (
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
end entity ; -- banco


architecture a_banco of banco is
		component demux8 is
		port(	
				sel 	: in unsigned (2 downto 0);
				saida0 	: out std_logic;
				saida1 	: out std_logic;
				saida2 	: out std_logic;
				saida3 	: out std_logic;
				saida4 	: out std_logic;
				saida5 	: out std_logic;
				saida6 	: out std_logic;
				saida7 	: out std_logic;
				entrada	: in std_logic
		);
	end component;
	
	component reg16bits is
		port(	
				clk 		: in std_logic;
				rst 		: in std_logic;
				wr_en 		: in std_logic;
				data_in 	: in unsigned (15 downto 0);
				data_out 	: out unsigned (15 downto 0)
		);
	end component;

	component mux8 is
		port (	
				sel 	: in unsigned (2 downto 0);
				entr0 	: in unsigned (15 downto 0);
				entr1 	: in unsigned (15 downto 0);
				entr2 	: in unsigned (15 downto 0);
				entr3 	: in unsigned (15 downto 0);
				entr4 	: in unsigned (15 downto 0);
				entr5 	: in unsigned (15 downto 0);
				entr6 	: in unsigned (15 downto 0);
				entr7 	: in unsigned (15 downto 0);
				saida 	: out unsigned (15 downto 0)
		);

	end component;


	signal  demux_saida0_reg0_wr_en, demux_saida1_reg1_wr_en, demux_saida2_reg2_wr_en, demux_saida3_reg3_wr_en, demux_saida4_reg4_wr_en, 
			demux_saida5_reg5_wr_en, demux_saida6_reg6_wr_en, demux_saida7_reg7_wr_en : std_logic;
	signal 	data_out_1, data_out_2, data_out_3, data_out_4, data_out_5, data_out_6, data_out_7 : unsigned (15 downto 0);
	signal 	data_out_0 : unsigned (15 downto 0) := x"0000";

begin

	demux: demux8 port map(	sel 	=> sel_write,
							saida0 	=> demux_saida0_reg0_wr_en, 
							saida1 	=> demux_saida1_reg1_wr_en, 
							saida2 	=> demux_saida2_reg2_wr_en,
							saida3 	=> demux_saida3_reg3_wr_en, 
							saida4 	=> demux_saida4_reg4_wr_en, 
							saida5 	=> demux_saida5_reg5_wr_en, 
							saida6 	=> demux_saida6_reg6_wr_en, 
							saida7 	=> demux_saida7_reg7_wr_en, 							
							entrada => write_enable
							);
	
	reg0: reg16bits port map(	clk 		=> clk, 
								rst 		=> rst, 
								wr_en 		=> demux_saida0_reg0_wr_en, 
								data_in 	=> x"0000", 
								data_out 	=> data_out_0 
							);

	reg1: reg16bits port map(	clk 		=> clk, 
								rst 		=> rst, 
								wr_en 		=> demux_saida1_reg1_wr_en, 
								data_in 	=> write_data, 
								data_out 	=> data_out_1
							);
	
	reg2: reg16bits port map(	clk 		=> clk, 
								rst 		=> rst, 
								wr_en 		=> demux_saida2_reg2_wr_en, 
								data_in 	=> write_data, 
								data_out 	=> data_out_2
							);

	reg3: reg16bits port map(	clk 		=> clk, 
								rst 		=> rst, 
								wr_en 		=> demux_saida3_reg3_wr_en, 
								data_in 	=> write_data, 
								data_out 	=> data_out_3
							);

	reg4: reg16bits port map(	clk 		=> clk, 
								rst 		=> rst, 
								wr_en 		=> demux_saida4_reg4_wr_en, 
								data_in 	=> write_data, 
								data_out 	=> data_out_4
							);

	reg5: reg16bits port map(	clk 		=> clk, 
								rst 		=> rst, 
								wr_en 		=> demux_saida5_reg5_wr_en, 
								data_in 	=> write_data, 
								data_out 	=> data_out_5
							);
	
	reg6: reg16bits port map(	clk 		=> clk, 
								rst 		=> rst, 
								wr_en 		=> demux_saida6_reg6_wr_en, 
								data_in 	=> write_data, 
								data_out 	=> data_out_6
							);
	
	reg7: reg16bits port map(	clk 		=> clk, 
								rst 		=> rst, 
								wr_en 		=> demux_saida7_reg7_wr_en, 
								data_in 	=> write_data, 
								data_out 	=> data_out_7
							);

	mux1: mux8 port map(	sel 	=> sel_reg1, 
							entr0 	=> data_out_0, 
							entr1 	=> data_out_1, 
							entr2 	=> data_out_2,
							entr3 	=> data_out_3, 
							entr4 	=> data_out_4, 
							entr5 	=> data_out_5,
							entr6 	=> data_out_6, 
							entr7 	=> data_out_7, 
							saida 	=> read_data1
						);

	mux2: mux8 port map(	sel 	=> sel_reg2,
							entr0 	=> data_out_0, 
							entr1 	=> data_out_1, 
							entr2 	=> data_out_2,
							entr3 	=> data_out_3, 
							entr4 	=> data_out_4, 
							entr5 	=> data_out_5,
							entr6 	=> data_out_6, 
							entr7 	=> data_out_7, 
							saida 	=> read_data2
						);


end architecture ; -- a_banco