.PHONY:	all test compile wave

SRC:=$(wildcard src/*vhdl) $(wildcard tb/*vhdl)
TB:=adder_tb

V?=0
ifeq ($(V),0)
Q=@
else
Q=
endif

all:	test

compile:	.built

.built:	${SRC}
	$(Q)mkdir -p work
	@echo "[-] Analysing files... "
	@bash -c 'for i in ${SRC} ; do echo -e "\t$$i" ; done'
	$(Q)ghdl -a --workdir=work ${SRC}
	@echo "[-] Elaborating test bench..."
	$(Q)ghdl -e --workdir=work ${TB}
	@touch $@

test:	compile
	@echo "[-] Running ${TB} unit..."
	$(Q)ghdl -r --workdir=work ${TB} || { \
	    echo "[x] Failure. Aborting..." ; \
	    exit 1 ; \
	}
	$(Q)echo "[-] All tests passed."
	$(Q)echo "[-] To do GTKWAVE plotting, \"make waves\""

waves:	compile
	$(Q)mkdir -p simulation
	$(Q)ghdl -r --workdir=work ${TB} --vcdgz=simulation/adder.vcd.gz || { echo "[x] Failure. Aborting..." ; exit 1 ; }
	$(Q)zcat simulation/adder.vcd.gz | gtkwave --vcd

clean:
	$(Q)rm -rf work-obj93.cf work/ *.o ${TB} simulation/ .built
