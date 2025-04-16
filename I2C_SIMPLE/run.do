vsim -voptargs="+acc" work.i2c_tb
vcd file "dump.vcd"
vcd add -r /*
run -all