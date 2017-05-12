ghdl -a reg16bits.vhd
ghdl -a PC.vhd
ghdl -a banco.vhd
ghdl -a ULA.vhd
ghdl -a ROM.vhd
ghdl -a maquina_estados.vhd
ghdl -a UC.vhd
ghdl -a top_level.vhd
ghdl -a top_level_tb.vhd
ghdl -e top_level_tb
ghdl -r top_level_tb --stop-time=1500ns --wave=t.ghw
gtkwave t.ghw -al.gtkw