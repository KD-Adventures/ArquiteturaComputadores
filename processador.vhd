library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
	port ( 	clk			: in std_logic;
			rst			: in std_logic;
			estado 		: out unsigned (1 downto 0);
			PC_o		: out unsigned (15 downto 0);
			instruction : out unsigned (13 downto 0);
			reg1 		: out unsigned (15 downto 0);
			reg2 		: out unsigned (15 downto 0);
			ula_saida_o	: out unsigned (15 downto 0);
			ula_maior	: out std_logic;
			ula_igual	: out std_logic;
			w_saida		: out unsigned (15 downto 0)
	);
end entity;

architecture a_processador of processador is
	
	component ROM is
		port(	
				rom_endereco: in unsigned (15 downto 0);
				rom_dado	: out unsigned (13 downto 0)
		);
	end component;

	component PC is
		port (	
				clk			: in std_logic;
				rst 		: in std_logic;
				wr_en		: in std_logic;
				pc_jump		: in std_logic;
				pc_data_jump: in unsigned (15 downto 0);
				pc_saida	: out unsigned (15 downto 0)
		);
	end component;

	component UC is
		port (	
				clk 					: in std_logic;
				rst	 					: in std_logic;
				uc_instruction			: in unsigned(13 downto 0);
				uc_jump 				: out std_logic;
				uc_pc_update			: out std_logic;
				uc_Banco_update 		: out std_logic;
				uc_Acumulador_update  	: out std_logic;
				uc_sel_ula_entrada_A	: out unsigned (1 downto 0);
				uc_sel_ula_entrada_B	: out unsigned (1 downto 0);
				uc_ula_op 				: out unsigned (1 downto 0);
				uc_estado 				: out unsigned (1 downto 0)
		);
	end component;

	component ULA is
		port (	
				in_a : in unsigned(15 downto 0);
		  		in_b : in unsigned(15 downto 0);
		  		sel_op : in unsigned(1 downto 0);
		  		saida : out unsigned(15 downto 0);
		  		maior : out std_logic;
		  		igual : out std_logic
		);
	end component;

	component banco is
		port(
				clk 			: in std_logic;
				rst 			: in std_logic;
				write_enable 	: in std_logic;
				sel_regs_1 		: in unsigned (2 downto 0);
				sel_regs_2 		: in unsigned (2 downto 0);
				sel_write 		: in unsigned (2 downto 0);
				write_data 		: in unsigned (15 downto 0);
				read_data1		: out unsigned (15 downto 0);
				read_data2 		: out unsigned (15 downto 0)
		);	
	end component;

	component reg16bits is
		port(
				clk : in std_logic;
				rst : in std_logic;
				wr_en : in std_logic;
				data_in : in unsigned(15 downto 0);
				data_out : out unsigned(15 downto 0)
		);
	end component;

	signal pc_saida, zero, reg_saida, jump_address : unsigned (15 downto 0);
	signal jump : std_logic;
	signal estado_s : unsigned (1 downto 0);
	signal sel_regs_2_s : unsigned (2 downto 0);
	signal acc_write_enable, pc_write_enable, reg_write_enable : std_logic;
	signal ula_sel_op : unsigned (1 downto 0);
	signal ula_entrada_A, ula_entrada_B, ula_saida, acc_saida : unsigned (15 downto 0);
	signal sel_ula_entrada_A, sel_ula_entrada_B : unsigned (1 downto 0);
	signal literal_rom : unsigned (15 downto 0);
	signal instruction_s : unsigned (13 downto 0);

begin
	
	literal_rom <= "00000000" & instruction_s(7 downto 0);

	sel_regs_2_s <= instruction_s(2 downto 0);

	jump_address <=	"00000" & instruction_s(10 downto 0);

	ula_entrada_A <= 	zero when sel_ula_entrada_A = "00" else
						reg_saida when sel_ula_entrada_A = "01" else
						literal_rom;

	ula_entrada_B <= 	reg_saida when sel_ula_entrada_B = "00" else
						literal_rom when sel_ula_entrada_B = "01" else
						acc_saida;

	rom1 : ROM port map (	 
							rom_endereco 	=> pc_saida, 
							rom_dado 		=> instruction_s
						);

	pc0 : PC port map 	(
							clk 			=> clk, 
							rst 			=> rst, 
							wr_en 			=> pc_write_enable, 
							pc_jump 		=> jump, 
							pc_data_jump 	=> jump_address,
							pc_saida 		=> pc_saida
						);

	uc0 : UC port map 	(
							clk 					=> clk,
							rst						=> rst,
							uc_instruction 			=> instruction_s,
							uc_jump 				=> jump,
							uc_pc_update 			=> pc_write_enable,
							uc_Banco_update 		=> reg_write_enable,
							uc_Acumulador_update 	=> acc_write_enable,
							uc_sel_ula_entrada_B 	=> sel_ula_entrada_B,
							uc_ula_op 				=> ula_sel_op,
							uc_sel_ula_entrada_A 	=> sel_ula_entrada_A,
							uc_estado 				=> estado_s
						);

	ula0 : ULA port map	(
							in_a 	=> ula_entrada_A,
					  		in_b 	=> ula_entrada_B,
					  		sel_op 	=> ula_sel_op,
					  		saida 	=> ula_saida,
					  		maior 	=> ula_maior,
					  		igual 	=> ula_igual
						);

	banco1 : banco port map (
								clk 			=> clk,
								rst 			=> rst, 
								write_enable 	=> reg_write_enable,
								sel_regs_1 		=> "000",
								sel_regs_2 		=> sel_regs_2_s,
								sel_write 		=> sel_regs_2_s,
								write_data 		=> ula_saida,
								read_data1 		=> zero,
								read_data2 		=> reg_saida
							);

	acumulador : reg16bits port map (
										clk 		=> clk,
										rst 		=> rst,
										wr_en 		=> acc_write_enable,
										data_in 	=> ula_saida,
										data_out 	=> acc_saida
									);

	estado <= estado_s;
	PC_o <= pc_saida;
	instruction <= instruction_s;
	reg1 <= zero;
	reg2 <= reg_saida;
	ula_saida_o <= ula_saida;
	w_saida <= acc_saida;

end architecture;