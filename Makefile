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
	cd BUILD; ./raw --extract=$* --datapath=../GAMEDATA
	cp BUILD/data.raw ROMs/$*.raw
	cp BUILD/data.si  ROMs/$*.si

BITSTREAMs/$(BOARD)/%.bit: # ROMs/%.raw hardware/a5k.si hardware/vm.si
	cp ROMs/$*.raw hardware/data.raw
	cp ROMs/$*.si  hardware/data.si
	make -C hardware $(BOARD) ARGS="--no_program"
	mkdir -p BITSTREAMs
	mkdir -p BITSTREAMs/$(BOARD)/
	cp hardware/BUILD_$(BOARD)/build.bi? BITSTREAMs/$(BOARD)/$*.bit

part%: ROMs/%.raw BITSTREAMs/$(BOARD)/%.bit
	@echo "-> build done for part $*."

play%: ROMs/%.raw BITSTREAMs/$(BOARD)/%.bit mch2022prog
ifeq ($(BOARD),icebreaker)
	iceprog -o 2M ROMs/$*.raw
	iceprog BITSTREAMs/$(BOARD)/$*.bit
else
ifeq ($(BOARD),mch2022)
	./build/fpga.py build/write.bin
	sleep 0.5
	python ./build/send.py $(SERIAL_PORT) 2097152 ROMs/$*.raw
	./hardware/build/fpga.py BITSTREAMs/$(BOARD)/$*.bit
else
ifeq ($(BOARD),ulx3s)
	openFPGALoader -b ulx3s -f -o 2097152 ROMs/$*.raw
	openFPGALoader -b ulx3s BITSTREAMs/$(BOARD)/$*.bit
else
	echo "supports only icebreaker and mch2022 for now"
endif
endif
endif

simul%: ROMs/%.raw
	cp ROMs/$*.raw hardware/data.raw
	cp ROMs/$*.si hardware/data.si
	make -C hardware verilator

mch2022prog:
	mkdir -p build
	-wget -nc https://raw.githubusercontent.com/badgeteam/mch2022-tools/master/fpga.py -O build/fpga.py
	chmod 755 build/fpga.py
	-wget -nc https://github.com/sylefeb/mch2022-silice/raw/main/qpsram_loader/bitstreams/write.bin -O build/write.bin
	-wget -nc https://github.com/sylefeb/mch2022-silice/raw/main/qpsram_loader/send.py -O build/send.py
