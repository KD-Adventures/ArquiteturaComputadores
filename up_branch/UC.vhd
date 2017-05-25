library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
	port (	
			clk 					: in std_logic;
			rst	 					: in std_logic;
			uc_instruction			: in unsigned(13 downto 0);
            uc_bit_is_clear         : in std_logic;
            uc_pc_sel               : out unsigned (1 downto 0);
			uc_pc_update			: out std_logic;
			uc_Banco_update 		: out std_logic;
			uc_Acumulador_update  	: out std_logic;
			uc_InstrReg_update  	: out std_logic;
			uc_sel_ula_entrada_A	: out std_logic;
			uc_ula_op				: out unsigned (2 downto 0);
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

    type INSTRUCTION_LIST is
        (MOVLW, MOVWF, MOVF, ADDWF, SUBLW, GOTO, BRA, BTFSS, BTFSC, NOP);

    signal opcode_1 		: unsigned (1 downto 0);
	signal opcode_2 		: unsigned (3 downto 0);
	signal estado_s 		: unsigned (1 downto 0);
	signal campo 			: std_logic;
	signal uc_reg_wr_en 	: std_logic;
	signal w_write 	 		: std_logic;
	signal field_d			: std_logic;
	signal Z_affected	 	: std_logic;
	signal C_affected		: std_logic;
    signal instruction      : INSTRUCTION_LIST;
    signal skip_this_instr  : std_logic;
    signal skip_next_instr  : std_logic;

begin

	maquina : maquina_estados port map 	(
											clk => clk, 
											rst => rst, 
											estado => estado_s
										);


	
-- Instruções 
	--MOVLW	k		11 0000 kkkk kkkk
	--MOVWF f 		00 0000	1fff ffff 
	--MOVF f,d 		00 1000 dfff ffff 
	--ADDWF f,d 	00 0111 dfff ffff
	--SUBLW k 		11 1100 kkkk kkkk 
	--GOTO k 		10 1kkk kkkk kkkk
	--NOP			00 0000 0000 0000

--Não implementadas
	--BRA k 		11 001k kkkk kkkk
	--BRW 			00 0000 0000 1011
	--BCF f,b 		01 00bb bfff ffff
	--BSF f,b 		01 01bb bfff ffff
	--BTFSC f,b 	01 10bb bfff ffff
	--BTFSS f,b  	01 11bb bfff ffff
	
--	

-- Sinais utilizados por cada instrução
	-- MOVLW k
		-- seleciona a rom em uc_sel_ula_entrada_A para pegar a constante da instrução
		-- Seleciona a opção passa A da ULA em uc_ula_op, 000
		-- Habilita a escrita no Acumulador, uc_w_write

	-- MOVWF f
		-- Seleciona a opção passa B da ULA, 001, em uc_ula_op
		-- habilita a escrita do banco em uc_reg_wr_en

	--MOVF f,d
		-- Seleciona a opção passa A da ULA, 000, em uc_ula_op
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
--

-- nomenclaturas
	--	uc_reg_wr_en 		: habilita a escrita no registrador
	--	w_write 	 		: habilita que o acumulador realize a leitura do dado na entrada
	--	uc_sel_ula_entrada_B: seletor para o mux de uma das entradas da Ula, 0 seleciona o acumulador e 1 seleciona o dado da rom 
	--	uc_ula_op 			: seleciona a operação da ULA
	-- 	uc_sel_ula_entrada_A: seleciona qual das saidas do banco de registradores vai para a Ula
	--	uc_jump 			: indica se a instrução é de salto e indica para o pc
	--	uc_jump_address		: indica para qual endereço vai o pc
--

	opcode_1 	<= uc_instruction(13 downto 12);
	opcode_2 	<= uc_instruction(11 downto 8);
	field_d		<= uc_instruction(7);

-- Determina a instrução

    instruction     <=  NOP     when skip_this_instr = '1' else
    					MOVLW   when opcode_1 = "11" AND opcode_2 = "0000"                              else
						MOVWF   when opcode_1 = "00" AND opcode_2 = "0000" and uc_instruction(7) = '1'  else  
						MOVF    when opcode_1 = "00" AND opcode_2 = "1000"                              else
						ADDWF   when opcode_1 = "00" AND opcode_2 = "0111"                              else
						SUBLW   when opcode_1 = "11" AND opcode_2 = "1100"                              else
						GOTO    when opcode_1 = "10" AND uc_instruction(11) = '1'                       else
						BRA     when opcode_1 = "11" AND uc_instruction(11 downto 9) = "001"            else
						BTFSS 	when opcode_1 = "01" AND uc_instruction(11 downto 10) = "11"			else
						BTFSC 	when opcode_1 = "01" AND uc_instruction(11 downto 10) = "10"			else
						NOP;

-- Faz as paradas


	

-- Estados

--	process(clk, rst)
--	begin
--		if rst = '1' then
--			uc_pc_update 			<= '0';
--			uc_InstrReg_update 		<= '0';
--			uc_Banco_update 		<= '0';
--			uc_Acumulador_update 	<= '0';
--			--uc_estado <= estado_s;
--
--		elsif rst = '0' then
	process(estado_s, instruction)
		begin
			case estado_s is
				when "00" =>
					uc_pc_update 			<= '1';
					uc_InstrReg_update 		<= '1';
					uc_Banco_update 		<= '0';
					uc_Acumulador_update 	<= '0';
					--uc_estado <= estado_s;
					--skip_next_instr 		<= '0';
				when "01" =>

					case instruction is
						when MOVLW =>
							uc_reg_wr_en            <= '0';
							w_write                 <= '1';
							uc_ula_op               <= "000";
							uc_sel_ula_entrada_A    <= '1';
							uc_pc_sel               <= "00";
							skip_next_instr         <= '0';
						when MOVWF =>
							uc_reg_wr_en            <= '1';
							w_write                 <= '0';
							uc_ula_op               <= "001";
							uc_sel_ula_entrada_A    <= '0';
							uc_pc_sel               <= "00";           
							skip_next_instr         <= '0';
						when MOVF =>
							uc_reg_wr_en            <= '1';
							w_write                 <= '1';
							uc_ula_op               <= "000";
							uc_sel_ula_entrada_A    <= '0';
							uc_pc_sel               <= "00";
							skip_next_instr         <= '0';
						when ADDWF =>
							uc_reg_wr_en            <= '1';
							w_write                 <= '1';
							uc_ula_op               <= "010";
							uc_sel_ula_entrada_A    <= '0';
							uc_pc_sel               <= "00";
							skip_next_instr         <= '0';
						when SUBLW =>
							uc_reg_wr_en            <= '0';
							w_write                 <= '1';
							uc_ula_op               <= "011";
							uc_sel_ula_entrada_A    <= '1';
							uc_pc_sel               <= "00";
							skip_next_instr         <= '0';
						when GOTO =>
							uc_reg_wr_en            <= '0';
							w_write                 <= '0';
							uc_ula_op               <= "000";
							uc_sel_ula_entrada_A    <= '0';
							uc_pc_sel               <= "10";
							skip_next_instr         <= '0';
						when BRA =>
							uc_reg_wr_en            <= '0';
							w_write                 <= '0';
							uc_ula_op               <= "000";
							uc_sel_ula_entrada_A    <= '0';
							uc_pc_sel               <= "01";
							skip_next_instr         <= '0';
						when BTFSS	 =>
							uc_reg_wr_en            <= '0';
							w_write                 <= '0';
							uc_ula_op               <= "000";
							uc_sel_ula_entrada_A    <= '0';
							uc_pc_sel               <= "00";
							skip_next_instr         <= not uc_bit_is_clear; 
						when BTFSC =>
							uc_reg_wr_en            <= '0';
							w_write                 <= '0';
							uc_ula_op               <= "000";
							uc_sel_ula_entrada_A    <= '0';
							uc_pc_sel               <= "00";
							skip_next_instr         <= uc_bit_is_clear;
						when NOP =>
							uc_reg_wr_en            <= '0';
							w_write                 <= '0';
							uc_ula_op               <= "000";
							uc_sel_ula_entrada_A    <= '0';
							uc_pc_sel               <= "00";
							skip_next_instr         <= '0';
						when others =>
							uc_reg_wr_en            <= '0';
							w_write                 <= '0';
							uc_ula_op               <= "000";
							uc_sel_ula_entrada_A    <= '0';
							uc_pc_sel               <= "00";
							skip_next_instr         <= '0';
					end case; 

					uc_pc_update 			<= '0';
					uc_InstrReg_update 		<= '0';
					uc_Banco_update 		<= '0';
					uc_Acumulador_update 	<= '0';
					--uc_estado <= estado_s;
					skip_this_instr 		<= skip_next_instr;
				when "10" =>
					uc_pc_update 			<= '0';
					uc_InstrReg_update 		<= '0';
					uc_Banco_update 		<= uc_reg_wr_en;
					uc_Acumulador_update 	<= w_write;
					--uc_estado 				<= estado_s;
                    --skip_this_instr 		<= skip_next_instr;
                    --skip_next_instr 		<= '0';
				when others =>
					uc_pc_update 			<= '0';
					uc_InstrReg_update 		<= '0';
					uc_Banco_update 		<= '0';
					uc_Acumulador_update 	<= '0';
					--uc_estado <= estado_s;
			end case;
	end process;
--
uc_estado <= estado_s;
-- 	--Fetch
	--	uc_pc_update <= '1' when estado_s = "00" else '0';
	--	uc_InstrReg_update <= '1' when estado_s = "00" else '0';
	--
	--
	--	-- Decode
	--	uc_Banco_update <= 	uc_reg_wr_en when estado_s = "01" else '0';
	--		
	--
	--	-- Execute
	--	uc_Acumulador_update <= w_write  when estado_s = "10" else '0';
	--	uc_Z_Status_update <= '1' when estado_s = "10" else '0';
	--
	--	uc_estado <= estado_s;
	--	
--

end architecture;
