#!/bin/bash

# get badge tools
MCH2022_TOOLS_URL=https://raw.githubusercontent.com/badgeteam/mch2022-tools/master/
OPT=-nc
wget $OPT $MCH2022_TOOLS_URL/webusb.py
wget $OPT $MCH2022_TOOLS_URL/filesystem_create_directory.py
wget $OPT $MCH2022_TOOLS_URL/filesystem_push.py
wget $OPT $MCH2022_TOOLS_URL/filesystem_list.py
wget $OPT $MCH2022_TOOLS_URL/filesystem_remove.py
chmod +x webusb.py
chmod +x filesystem_create_directory.py
chmod +x filesystem_push.py
chmod +x filesystem_list.py
chmod +x filesystem_remove.py
# ensure paths are not converted under MSYS/MinGW
export MSYS2_ARG_CONV_EXCL="$MSYS2_ARG_CONV_EXCL;/sd/"
# Another world directory on mch2022 SD card
AW=/sd/apps/python/another_world
# remove bitstreams
./filesystem_remove.py $AW/write_spi.bin
./filesystem_remove.py $AW/bitstream.bit
# remove MicroPython another world FPGA driver
./filesystem_remove.py $AW/__init__.py
for i in {1..7}
do
	./filesystem_remove.py $AW/$i.raw
done
# list files
./filesystem_list.py $AW
./filesystem_remove.py $AW
