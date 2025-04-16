vsim -voptargs="+acc" work.spi_tb
vcd file "dump.vcd"
vcd add -r /*
run -all