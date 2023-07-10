SERIAL_PORT ?= COM6

.DEFAULT: a5k.si
		cd common ; ./download_all.sh ; cd ..
		silice-make.py -s a5k.si -b $@ -p basic,vga,qspiflash,buttons -o BUILD_$(subst :,_,$@) $(ARGS)
		# silice-make.py -s a5k.si -b $@ -p basic,vga,qspiflash,buttons,extras -o BUILD_$(subst :,_,$@) $(ARGS)

ulx3s: a5k.si
		cd common ; ./download_all.sh ; cd ..
		silice-make.py -s a5k.si -b $@ -p basic,hdmi,qspiflash,buttons -o BUILD_$(subst :,_,$@) $(ARGS)

verilator: a5k.si
		cd common ; ./download_all.sh ; cd ..
		silice-make.py -s a5k.si -b $@ -p basic,vga -o BUILD_$(subst :,_,$@) $(ARGS)

mch2022: a5k.si mch2022prog
		cd common ; ./download_all.sh ; cd ..
		silice-make.py -s a5k.si -b $@ -p basic,psram,lcd,espspi -o BUILD_$(subst :,_,$@) $(ARGS)
		# ./build/fpga.py BUILD_mch2022/build.bin

mch2022_data: mch2022prog
		./build/fpga.py build/write.bin
		sleep 0.5
		python ./build/send.py $(SERIAL_PORT) 2097152 data.raw

clean:
	rm -rf BUILD_*

mch2022prog:
	mkdir -p build
	-wget -nc https://raw.githubusercontent.com/badgeteam/mch2022-tools/master/fpga.py -O build/fpga.py
	chmod 755 build/fpga.py
	-wget -nc https://github.com/sylefeb/mch2022-silice/raw/main/qpsram_loader/bitstreams/write.bin -O build/write.bin
	-wget -nc https://github.com/sylefeb/mch2022-silice/raw/main/qpsram_loader/send.py -O build/send.py
