.PHONY:	all test test-compile wave

all:	test

test-compile:
	ghdl -a adder.vhdl
	ghdl -a adder_tb.vhdl

test:	test-compile
	ghdl -r adder_tb
	@echo 'To do GTKWAVE plotting, "make wave"'

wave:	test-compile
	ghdl -r adder_tb --vcd=adder.vcd
	gtkwave adder.vcd

clean:
	rm -f work-obj93.cf
