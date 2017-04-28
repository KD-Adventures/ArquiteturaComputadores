
ghdl -a mux2.vhd
ghdl -a mux8.vhd
ghdl -a demux8.vhd
ghdl -a reg16bits.vhd
ghdl -a ULA.vhd
ghdl -a banco.vhd
ghdl -a top_level.vhd
ghdl -a top_level_tb.vhd
ghdl -e top_level_tb
ghdl -r top_level_tb --stop-time=1500ns --wave=t.ghw
gtkwave t.ghw -al.gtkw