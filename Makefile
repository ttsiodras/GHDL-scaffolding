.PHONY:	all test test-compile wave

COLORON="\e[1m\e[32m"
COLORONB="\e[1m\e[31m"
COLOROFF="\e[0m"
INFO="${COLORON}[INFO]${COLOROFF} "
ERROR="${COLORONB}[ERROR]${COLOROFF} "

all:	inform test

inform:
ifneq (${GHDL_BACKEND},gcc)
	@echo "${INFO}Note that you can run much faster via:"
	@echo "${INFO}"
	@echo "${INFO}    GHDL_BACKEND=gcc make ..."
	@echo "${INFO}"
endif

test-compile:
	@ghdl -a adder.vhdl
	@ghdl -a adder_tb.vhdl

test:	test-compile
	@ghdl -e adder_tb
	@ghdl -r adder_tb || { echo "${ERROR}Failure... Aborting" ; exit 1 ; }
	@echo "${INFO}To do GTKWAVE plotting, \"make wave\""

wave:	test-compile
	@ghdl -r adder_tb --vcd=adder.vcd
	@gtkwave adder.vcd

clean:
	rm -f work-obj93.cf *.o adder_tb simulation/
