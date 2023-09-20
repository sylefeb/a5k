#!/bin/bash

# ensure paths are not converted under MSYS/MinGW
export MSYS2_ARG_CONV_EXCL="$MSYS2_ARG_CONV_EXCL;/sd/"
# Another world directory on mch2022 SD card
AW=/sd/apps/python/another_world
filesystem_create_directory.py $AW
# from https://github.com/hfmanson/mch2022-silice/blob/write_spi/qpsram_loader/write_spi.si
# loads data from ESP32 SPI to PSRAM
filesystem_push.py write_spi.bin $AW/write_spi.bin
# MicroPython another world FPGA driver
filesystem_push.py __init__.py $AW/__init__.py
# copy another world bitstreams and levels
for i in {1..7}
do
	filesystem_push.py ../ROMs/$i.raw $AW/$i.raw
	filesystem_push.py ../BITSTREAMs/mch2022/$i.bit $AW/$i.bit
done
# list files just pushed
filesystem_list.py $AW
