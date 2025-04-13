vsim -voptargs="+acc" work.alu_tb
vcd file dump.vcd
vcd add -r /*
run -all