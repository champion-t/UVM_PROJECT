VLOG ?= /mnt/c/questasim64_10.7c/win64/vlog.exe
VSIM ?= /mnt/c/questasim64_10.7c/win64/vsim.exe

compile:
	$(VLOG) -f filelist.f | ccze -A
sim:
	$(VSIM) -c -do run.do | ccze -A
view:
	gtkwave dump.vcd