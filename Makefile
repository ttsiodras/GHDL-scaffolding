.PHONY:	all test test-compile wave

COLORON="\e[1m\e[32m"
COLORONB="\e[1m\e[31m"
COLOROFF="\e[0m"
INFO="${COLORON}[INFO]${COLOROFF} "
ERROR="${COLORONB}[ERROR]${COLOROFF} "

V?=0
ifeq ($(V),0)
Q=@
else
Q=
endif

all:	inform test

inform:
ifneq (${GHDL_BACKEND},gcc)
	@echo -e "${INFO}Note that you can run much faster via:"
	@echo -e "${INFO}"
	@echo -e "${INFO}    GHDL_BACKEND=gcc make ..."
	@echo -e "${INFO}"
endif

test-compile:
	$(Q)mkdir -p work
	$(Q)ghdl -a --workdir=work src/adder.vhdl
	$(Q)ghdl -a --workdir=work tb/adder_tb.vhdl
	$(Q)ghdl -e --workdir=work adder_tb

test:	test-compile
	$(Q)ghdl -r --workdir=work adder_tb || { echo -e "${ERROR}Failure... Aborting" ; exit 1 ; }
	$(Q)echo -e "${INFO}All tests passed."
	$(Q)echo -e "${INFO}To do GTKWAVE plotting, \"make wave\""

wave:	test-compile
	$(Q)mkdir -p simulation
	$(Q)ghdl -r --workdir=work adder_tb --vcdgz=simulation/adder.vcd.gz || { echo  -e "${ERROR}Failure... Aborting" ; exit 1 ; }
	$(Q)zcat simulation/adder.vcd.gz | gtkwave --vcd

clean:
	$(Q)rm -rf work-obj93.cf work/ *.o adder_tb simulation/
