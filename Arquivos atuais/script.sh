ghdl -a rom.vhd
ghdl -a rom_tb.vhd
ghdl -e rom_tb
ghdl -r rom_tb --stop-time=1000ns --wave=t.ghw
gtkwave t.ghw -al.gtkw