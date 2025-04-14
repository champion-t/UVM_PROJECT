vsim -voptargs="+acc" work.uart_tb
vcd file dump.vcd
vcd add -r /*
run -all