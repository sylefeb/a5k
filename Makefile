BOARD ?= icebreaker
SERIAL_PORT ?= COM6

.SECONDARY:

all: part1 part2 part3 part4 part5 part6 part7

BUILD/raw:
	git clone -b a5k https://github.com/sylefeb/Another-World-Bytecode-Interpreter.git
	mkdir -p BUILD
	cd BUILD; cmake ../Another-World-Bytecode-Interpreter/ -G "Unix Makefiles" ; make
	mkdir -p ROMs

ROMs/%.raw: BUILD/raw
	cd BUILD; ./raw --extract=$* --datapath=../GAMEDATA --data-offsets
	cp BUILD/data.raw ROMs/$*.raw

BITSTREAMs/$(BOARD)/bitstream.bit:
	make -C hardware $(BOARD) ARGS="--no_program"
	mkdir -p BITSTREAMs
	mkdir -p BITSTREAMs/$(BOARD)/
	cp hardware/BUILD_$(BOARD)/build.bi? BITSTREAMs/$(BOARD)/bitstream.bit

part%: ROMs/%.raw BITSTREAMs/$(BOARD)/bitstream.bit
	@echo "-> build done for part $*."

play%: ROMs/%.raw BITSTREAMs/$(BOARD)/bitstream.bit mch2022prog
ifeq ($(BOARD),icebreaker)
	iceprog -o 2M ROMs/$*.raw
	iceprog BITSTREAMs/$(BOARD)/bitstream.bit
else
ifeq ($(BOARD),mch2022)
	./build/fpga.py build/write.bin
	sleep 0.5
	python3 ./build/send.py $(SERIAL_PORT) 2097152 ROMs/$*.raw
	./build/fpga.py BITSTREAMs/$(BOARD)/bitstream.bit
else
ifeq ($(BOARD),ulx3s)
	openFPGALoader -b ulx3s -f -o 2097152 ROMs/$*.raw
	openFPGALoader -b ulx3s BITSTREAMs/$(BOARD)/bitstream.bit
else
	echo "supports only icebreaker and mch2022 for now"
endif
endif
endif

simul%: ROMs/%.raw
	cp ROMs/$*.raw hardware/data.raw
	make -C hardware verilator

build:
	mkdir -p $@

build/fpga.py: build
	-wget https://raw.githubusercontent.com/badgeteam/mch2022-tools/master/fpga.py -O $@
	chmod 755 $@

build/write.bin: build
	-wget https://github.com/sylefeb/mch2022-silice/raw/main/qpsram_loader/bitstreams/write.bin -O $@

build/send.py: build
	-wget https://github.com/sylefeb/mch2022-silice/raw/main/qpsram_loader/send.py -O $@
	chmod 755 $@

mch2022prog: build/fpga.py build/write.bin build/send.py

.PHONY: mch2022prog
