library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
	port( 	
			clk				: in std_logic;
			rst				: in std_logic;
			up_estado 		: out unsigned (1 downto 0);
			up_pc			: out unsigned (15 downto 0);
			up_instruction 	: out unsigned (13 downto 0);
			up_reg 			: out unsigned (15 downto 0);
			up_ula_saida	: out unsigned (15 downto 0);
			up_ula_maior	: out std_logic;
			up_ula_zero		: out std_logic;
			up_w_saida		: out unsigned (15 downto 0);
			ula_carry 		: out std_logic
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
				clk			        : in std_logic;
			    rst 		        : in std_logic;
			    wr_en		        : in std_logic;
                pc_sel              : in unsigned (1 downto 0);
                pc_data_branch      : in unsigned (8 downto 0);
			    pc_data_jump	    : in unsigned (15 downto 0);
			    pc_saida		    : out unsigned (15 downto 0)
		    );
	end component;

	component UC is
		port (	
				clk 					: in std_logic;
			    rst	 					: in std_logic;
			    uc_instruction			: in unsigned(13 downto 0);
                uc_bit_is_set 	        : in std_logic;
                uc_pc_sel               : out unsigned (1 downto 0);
			    uc_pc_update			: out std_logic;
			    uc_Ram_update 			: out std_logic;
			    uc_Acumulador_update  	: out std_logic;
			    uc_InstrReg_update  	: out std_logic;
			    uc_FSR_update 			: out std_logic;
			    uc_sel_ula_entrada_A	: out std_logic;
			    uc_ula_op				: out unsigned (2 downto 0);
				uc_estado 				: out unsigned (1 downto 0);
				uc_sel_ram_address 		: out std_logic
				
		);
	end component;

	component ULA is
		port(	
				ula_in_a 			: in unsigned (15 downto 0);
		  		ula_in_b 			: in unsigned (15 downto 0);
		  		ula_sel_op			: in unsigned (2 downto 0);
                ula_sel_bit 		: in unsigned (2 downto 0);
		  		ula_saida 			: out unsigned (15 downto 0);
		  		ula_maior   		: out std_logic;
		  		ula_zero 			: out std_logic;
                ula_bit_is_set    	: out std_logic;
                ula_carry			: out std_logic
			);
	end component;

	component RAM is
		port (
				clk 			: in std_logic;
				ram_wr_en 		: in std_logic;
				ram_address 	: in unsigned (6 downto 0);
				ram_data_in 	: in unsigned (15 downto 0);
				ram_data_out 	: out unsigned (15 downto 0)
			 );
	end component;

	component reg16bits is
		port(
				clk 		: in std_logic;
				rst 		: in std_logic;
				wr_en 		: in std_logic;
				data_in 	: in unsigned(15 downto 0);
				data_out 	: out unsigned(15 downto 0)
		);
	end component;

	component instructionReg is
		port(
				clk 		: in std_logic;
				rst 		: in std_logic;
				wr_en 		: in std_logic;
				data_in 	: in unsigned(13 downto 0);
				data_out 	: out unsigned(13 downto 0)
		);
	end component;

	component fsrReg is
		port(
				clk 		: in std_logic;
				rst 		: in std_logic;
				wr_en 		: in std_logic;
				data_in 	: in unsigned (6 downto 0);
				data_out 	: out unsigned (6 downto 0)
		);
	end component;

	signal pc_saida, ram_saida, jump_address 		: unsigned (15 downto 0);
	signal pc_write_enable           				: std_logic;
    signal pc_sel_s                                 : unsigned (1 downto 0);
	signal instruction_in, instruction_out			: unsigned (13 downto 0);
    signal data_branch                              : unsigned (8 downto 0);
	signal literal_rom 								: unsigned (15 downto 0);
    signal sel_bit                                  : unsigned (2 downto 0);
	signal instr_write_enable, status_write_enable	: std_logic;
	signal estado_s 								: unsigned (1 downto 0);
	signal sel_ram_address							: std_logic;
	signal ram_write_enable 						: std_logic;
	signal ram_address_s 							: unsigned (6 downto 0);
	signal ula_sel_op 								: unsigned (2 downto 0);
	signal sel_ula_entrada_A 						: std_logic;
	signal ula_zero_s, ula_maior_s, bit_is_set		: std_logic;
	signal ula_entrada_A, ula_entrada_B, ula_saida_s: unsigned (15 downto 0);
	signal status_in, status_out					: unsigned (1 downto 0);
	signal acc_saida 								: unsigned (15 downto 0);
	signal acc_write_enable 						: std_logic;
	signal fsr_data_out, fsr_data_in, index_ram		: unsigned (6 downto 0);
	signal fsr_wr_en_s								: std_logic;
	
	

begin
	
	literal_rom <= B"0000_0000" & instruction_out (7 downto 0);

	sel_bit <= instruction_out (9 downto 7);

	index_ram (4 downto 0) <= instruction_out (4 downto 0);
	index_ram (6 downto 5) <= (others => index_ram(4));

	ram_address_s <=	instruction_out(6 downto 0) when sel_ram_address = '0' 	else 
						fsr_data_out + index_ram 	when index_ram (6) 	 = '0' 	else
						fsr_data_out - index_ram 	when index_ram (6)   = '1' 	else
						B"000_0000";

    data_branch <= instruction_out (8 downto 0);

	jump_address <=	"00000" & instruction_out (10 downto 0);

	ula_entrada_A <= 	ram_saida when sel_ula_entrada_A = '0' else
						literal_rom;

	status_in <= '0' & ula_zero_s;

	fsr_data_in <= ula_saida_s (6 downto 0);

	pc0 : PC port map 	(
							clk 			=> clk, 
							rst 			=> rst, 
							wr_en 			=> pc_write_enable, 
							pc_sel   		=> pc_sel_s,
                            pc_data_branch  => data_branch, 
							pc_data_jump 	=> jump_address,
							pc_saida 		=> pc_saida
						);

	rom1 : ROM port map (	 
							rom_endereco 	=> pc_saida, 
							rom_dado 		=> instruction_in
						);

	-- Instruction register
	instrReg : instructionReg port map (
										clk 		=> clk,
										rst 		=> rst,
										wr_en 		=> instr_write_enable,
										data_in 	=> instruction_in,
										data_out 	=> instruction_out
									);

	ram1 : RAM port map (
							clk 				=> clk,
							ram_wr_en 			=> ram_write_enable,
							ram_address 		=> ram_address_s,
							ram_data_in 		=> ula_saida_s,
							ram_data_out 		=> ram_saida
						);

	uc0 : UC port map 	(
							clk 					=> clk,
							rst						=> rst,
							uc_instruction 			=> instruction_out,
                            uc_bit_is_set         	=> bit_is_set,
							uc_pc_sel 				=> pc_sel_s,
							uc_pc_update 			=> pc_write_enable,
							uc_Ram_update 			=> ram_write_enable,
							uc_Acumulador_update 	=> acc_write_enable,
							uc_InstrReg_update		=> instr_write_enable,
							uc_FSR_update 			=> fsr_wr_en_s,
							uc_ula_op 				=> ula_sel_op,
							uc_sel_ula_entrada_A 	=> sel_ula_entrada_A,
							uc_estado 				=> estado_s,
							uc_sel_ram_address 		=> sel_ram_address
						);

	ula0 : ULA port map	(
							ula_in_a 			=> ula_entrada_A,
					  		ula_in_b 			=> acc_saida,
					  		ula_sel_op 			=> ula_sel_op,
                            ula_sel_bit 		=> sel_bit,
					  		ula_saida 			=> ula_saida_s,
					  		ula_maior	    	=> ula_maior_s,
					  		ula_zero 	    	=> ula_zero_s,
                            ula_bit_is_set		=> bit_is_set,
                            ula_carry 			=> ula_carry
						);

	acumulador : reg16bits port map (
										clk 		=> clk,
										rst 		=> rst,
										wr_en 		=> acc_write_enable,
										data_in 	=> ula_saida_s,
										data_out 	=> acc_saida
									);

	fsr : fsrReg port map 	(
								clk 		=> clk,
								rst 		=> rst,
								wr_en 		=> fsr_wr_en_s,
								data_in 	=> fsr_data_in,
								data_out 	=> fsr_data_out
								
							);

	up_estado 		<= estado_s;
	up_pc	 		<= pc_saida;
	up_instruction 	<= instruction_out;
	up_reg	 		<= ram_saida;
	up_ula_saida 	<= ula_saida_s;
	up_ula_maior	<= ula_maior_s;
	up_ula_zero 	<= ula_zero_s;
	up_w_saida 		<= acc_saida;

end architecture;
