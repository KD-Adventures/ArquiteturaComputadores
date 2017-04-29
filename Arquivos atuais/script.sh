ghdl -a registrador_pc.vhd
ghdl -a program_counter.vhd
ghdl -a rom.vhd
ghdl -a unidade_controle.vhd
ghdl -a unidade_controle_tb.vhd
ghdl -e unidade_controle_tb
ghdl -r unidade_controle_tb --stop-time=1500ns --wave=t.ghw
gtkwave t.ghw -al.gtkw