#!/bin/bash

# get badge tools
MCH2022_TOOLS_URL=https://raw.githubusercontent.com/badgeteam/mch2022-tools/master/
OPT=-nc
wget $OPT $MCH2022_TOOLS_URL/webusb.py
wget $OPT $MCH2022_TOOLS_URL/filesystem_create_directory.py
wget $OPT $MCH2022_TOOLS_URL/filesystem_push.py
wget $OPT $MCH2022_TOOLS_URL/filesystem_list.py
wget $OPT $MCH2022_TOOLS_URL/filesystem_remove.py
# ensure paths are not converted under MSYS/MinGW
export MSYS2_ARG_CONV_EXCL="$MSYS2_ARG_CONV_EXCL;/sd/"
# Another world directory on mch2022 SD card
AW=/sd/apps/python/another_world
./filesystem_create_directory.py $AW
# from https://github.com/hfmanson/mch2022-silice/blob/write_spi/qpsram_loader/write_spi.si
# loads data from ESP32 SPI to PSRAM
./filesystem_push.py ./bitstreams/write_spi.bin $AW/write_spi.bin
# MicroPython another world FPGA driver
./filesystem_push.py __init__.py $AW/__init__.py
# copy another world bitstream and levels
./filesystem_push.py ../../BITSTREAMs/mch2022/bitstream.bit $AW/bitstream.bit
for i in {1..7}
do
	./filesystem_push.py ../../ROMs/$i.raw $AW/$i.raw
done
# list files just pushed
./filesystem_list.py $AW
