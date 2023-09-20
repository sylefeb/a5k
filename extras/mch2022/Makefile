all : bitstreams/write_spi.bin

bitstreams/write_spi.bin: write_spi.si prepare
	silice-make.py -s write_spi.si -b mch2022 -p basic,uart,psram,espspi -o BUILD_mch2022
	mkdir -p bitstreams
	cp BUILD_mch2022/build.bin bitstreams/write_spi.bin

prepare:
	cd ../../hardware/common ; ./download_all.sh ; cd -
