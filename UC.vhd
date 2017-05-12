library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
	port (	
			clk 					: in std_logic;
			rst	 					: in std_logic;
			uc_instruction			: in unsigned(13 downto 0);
			uc_jump_address			: out unsigned(15 downto 0);
			uc_jump 				: out std_logic;
			uc_pc_update			: out std_logic;
			uc_Banco_update 		: out std_logic;
			uc_Acumulador_update  	: out std_logic;
			uc_reg_wr_en			: out std_logic;
			uc_w_write				: out std_logic;
			uc_sel_reg 				: out std_logic;
			uc_sel_rom				: out unsigned (1 downto 0);
			uc_ula_op 				: out unsigned (1 downto 0);
			uc_estado 				: out unsigned (1 downto 0)

	);
end entity;

architecture a_UC of UC is

	component maquina_estados is
		port (	
				clk 	: in std_logic;
				rst 	: in std_logic;
				estado 	: out unsigned (1 downto 0)
		);
	end component;

	signal opcode_1 : unsigned(1 downto 0);
	signal opcode_2 : unsigned(3 downto 0);
	signal estado_s : unsigned (1 downto 0);
	signal campo_d 	: std_logic;
	signal campo 	: std_logic;

begin

	maquina : maquina_estados port map 	(
											clk => clk, 
											rst => rst, 
											estado => estado_s
										);


	
-- Instruções para implementar
	--MOVLW	k		11 0000 kkkk kkkk
	--MOVWF f 		00 0000	1fff ffff 
	--MOVF f,d 		00 1000 dfff ffff 
	--ADDWF f,d 	00 0111 dfff ffff
	--SUBLW k 		11 1100 kkkk kkkk 
	--GOTO k 		10 1kkk kkkk kkkk
	--NOP			00 0000 0000 0000


-- Sinais utilizados por cada instrução
	-- MOVLW k
		-- seleciona a rom em uc_sel_rom para pegar a constante da instrução
		-- seleciona o valor 0 do registrador em uc_sel_reg 
		-- Soma a contante k, da instrução, com o 0 do registrador, uc_ula_op
		-- Habilita a escrita no Acumulador, uc_w_read

	-- MOVWF f
		-- seleciona o 0 do banco em uc_sel_reg
		-- soma 0 com o valor do acumulador
		-- habilita a escrita do bando em uc_reg_wr_en

	--MOVF f,d
		-- Seleciona f do Banco em uc_sel_reg
		-- Seleciona o 0 do Banco em uc_sel_rom
		-- Soma f com 0 em uc_ula_op
		-- Quando d = 0
			-- habilita a escrita no Acumulador, uc_w_write
		-- QUando d = 1
			-- habilita a escrita no Banco, uc_reg_wr_en

	--ADDWF f,d
		-- Soma o valor de f com o Acumulador, uc_ula_op
		-- Quando d = 0
			-- habilita a escrita no Acumulador, uc_w_write
		-- Quando d = 1
			-- habilita a escrita no Banco, uc_reg_wr_en

	--SUBLW k
		-- Subtrai o valor k com o valor do Acumulador (k - A), uc_ula_op
		-- habilita a escrita no Acumulador, uc_w_write

	--GOTO k 
		-- habilita o pc a saltar, uc_jump, para o endereço uc_jump_address

	-- NOP
		-- Não faz nada

-- nomenclaturas
--	uc_reg_wr_en : 	habilita a escrita no registrador
--	uc_w_write : 		habilita que o acumulador realize a leitura do dado na entrada
--	uc_sel_rom :  		seletor para o mux de uma das entradas da Ula, 0 seleciona o acumulador e 1 seleciona o dado da rom 
--	uc_ula_op : 		seleciona a operação da ULA
-- 	uc_sel_reg : 		seleciona qual das saidas do banco de registradores vai para a Ula
--	uc_jump :  		indica se a instrução é de salto e indica para o pc
--	uc_jump_address: 	indica para qual endereço vai o pc


	opcode_1 	<= uc_instruction(13 downto 12);
	opcode_2 	<= uc_instruction(11 downto 8);
	campo_d 	<= uc_instruction(7);
	campo 		<= uc_instruction(11);

	-- caso seja MOVF com d=1, MOVWF, ADDWF com d=1
	uc_reg_wr_en <=	'1' when opcode_1 = "00" AND opcode_2 = "1000" AND campo = '1' else
					'1' when opcode_1 = "00" AND opcode_2 = "0000" else
					'1' when opcode_1 = "00" AND opcode_2 = "0111" AND campo = '1' else
					'0';
	

	-- caso seja MOVLW, MOVF com d=0, ADDWF com d=0, SUBLW
	uc_w_write	<= 	'1' when opcode_1 = "11" AND opcode_2 = "0000" else
					'1' when opcode_1 = "00" AND opcode_2 = "1000" AND campo = '0' else
					'1' when opcode_1 = "00" AND opcode_2 = "0111" AND campo = '0' else
					'1' when opcode_1 = "11" AND opcode_2 = "1100" else
					'0';
	
	-- vai para o mux que seleciona entre o valor 0, o valor da rom e o do acumulador, MOVLW, GOTO			
	uc_sel_rom	<=	"01" when opcode_1 = "11" AND opcode_2 = "0000" else
					"00" when opcode_1 = "00" AND opcode_2 = "1000" AND campo = '1' else
					"01" when opcode_1 = "10" AND campo = '1' else
					"10";


-- Para essa soma com 0 estava pensando
--	Como o PIC tem acumulador e so usa uma das saidas do registradro, da para deixar
--	O reg 0, que tem valor 0, em um mux com a outra saida.

	-- Seleciona a operação da ula. Sequencia: MOVLW, MOVWF, MOVF, ADDWF, SUBLW, GOTO
	uc_ula_op	<=	"00" when opcode_1 = "11" AND opcode_2 = "0000" else
					"00" when opcode_1 = "00" AND opcode_2 = "0000" else
					"00" when opcode_1 = "00" AND opcode_2 = "1000" else
					"00" when opcode_1 = "00" AND opcode_2 = "0111" else
					"01" when opcode_1 = "11" AND opcode_2 = "1100" else
					"00" when opcode_1 = "10" AND campo = '1' else
					"00";

	-- Seleciona o registrador com valor 0 para MOVLW, MOVWF, MOVF, GOTO					
	uc_sel_reg	<=	'1' when opcode_1 = "11" AND opcode_2 = "0000" else
					'1' when opcode_1 = "00" AND opcode_2 = "0000" else
					'1' when opcode_1 = "00" AND opcode_2 = "1000" else
					'1' when opcode_1 = "10" AND campo = '1' else
					'0';

	-- Quando GOTO
	uc_jump <=	'1' when opcode_1 = "10" AND campo = '1' else
				'0';

-- mudar isso depois para um mux externo

	uc_jump_address <=	"00000" & uc_instruction(10 downto 0);

	

	-- Fetch
	uc_pc_update <= '1' when estado_s = "00" else
				 	'0';

	-- Decode
	uc_Banco_update <= 	'1' when estado_s = "01" else
						'0';

	-- Execute
	uc_Acumulador_update <= '1' when estado_s = "10" else
							'0';
				 
end architecture;
