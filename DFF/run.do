vsim -voptargs="+acc" work.dff_tb
vcd file dump.vcd
vcd add -r /*
run -all