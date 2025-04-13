vsim -voptargs="+acc" work.adder_tb
vcd file dump.vcd
vcd add -r /adder_tb/tif/*
run -all