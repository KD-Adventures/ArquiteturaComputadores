ghdl -a reg16bits.vhd
ghdl -a banco.vhd
ghdl -a maquina_estados.vhd
ghdl -a ULA.vhd
ghdl -a PC.vhd
ghdl -a ROM.vhd
ghdl -a UC.vhd
ghdl -a processador.vhd
ghdl -a processador_tb.vhd
ghdl -e processador_tb
ghdl -r processador_tb --wave=processador.ghw --stop-time=1000ns
gtkwave processador.ghw -ajoaquim.gtkw