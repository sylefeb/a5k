#!/bin/bash
SILICE_URL=https://raw.githubusercontent.com/sylefeb/Silice/draft/
TINYGPU_URL=https://raw.githubusercontent.com/sylefeb/tinygpus/main/
MCH2022_SILICE_URL=https://raw.githubusercontent.com/sylefeb/mch2022-silice/main/
MCH2022_ICE40_URL=https://raw.githubusercontent.com/badgeteam/mch2022-firmware-ice40/master/
OPT=-nc
wget $OPT $SILICE_URL/projects/common/plls/icebrkr_25.v
wget $OPT $SILICE_URL/projects/common/plls/icebrkr_50.v
wget $OPT $SILICE_URL/projects/common/plls/icebrkr_60.v
wget $OPT $SILICE_URL/projects/common/plls/icebrkr_66.v
wget $OPT $SILICE_URL/projects/common/plls/icebrkr_70.v
wget $OPT $SILICE_URL/projects/common/plls/icebrkr_100.v
wget $OPT $SILICE_URL/projects/common/plls/ulx3s_50_25.v
wget $OPT $SILICE_URL/projects/common/ice40_sb_io.v
wget $OPT $SILICE_URL/projects/common/ice40_sb_io_ddr.v
wget $OPT $SILICE_URL/projects/common/ice40_sb_io_inout.v
wget $OPT $SILICE_URL/projects/common/ecp5_inout.v
wget $OPT $SILICE_URL/projects/common/ecp5_out.v
wget $OPT $SILICE_URL/projects/common/ddr.v
wget $OPT $SILICE_URL/projects/common/passthrough.v
wget $OPT $SILICE_URL/projects/common/ice40_spram.v
wget $OPT $SILICE_URL/projects/common/simulation_spram.si
wget $OPT $SILICE_URL/projects/common/clean_reset.si
wget $OPT $SILICE_URL/projects/common/ice40_half_quarter_clock.v
wget $OPT $SILICE_URL/projects/common/ice40_half_clock.v
wget $OPT $SILICE_URL/projects/common/divint_std.si
wget $OPT $SILICE_URL/projects/common/uart.si
wget $OPT $SILICE_URL/projects/common/verilator_data.v
wget $OPT $SILICE_URL/projects/common/vga.si
wget $OPT $SILICE_URL/projects/common/hdmi.si
wget $OPT $SILICE_URL/projects/common/hdmi_clock.v
wget $OPT $SILICE_URL/projects/common/hdmi_ddr_crgb.v
wget $OPT $SILICE_URL/projects/spiflash/spiflash2x.si
wget $OPT $SILICE_URL/projects/common/ddr_clock.v
wget $OPT $MCH2022_SILICE_URL/common/qpsram2x.si
wget $OPT $MCH2022_SILICE_URL/common/spi_buttons.v
wget $OPT $MCH2022_SILICE_URL/common/spi_file.v
wget $OPT $TINYGPU_URL/hardware/GPUs/dmc-1/parallel_screen.si
# for spi com with ESP32 on the mch2022 badge
wget $OPT $MCH2022_ICE40_URL/cores/spi_slave/rtl/spi_dev_core.v
wget $OPT $MCH2022_ICE40_URL/cores/spi_slave/rtl/spi_dev_proto.v
wget $OPT $MCH2022_ICE40_URL/cores/spi_slave/rtl/spi_dev_fread.v
wget $OPT https://raw.githubusercontent.com/no2fpga/no2misc/59350da954e78424117ed01c55b5c7a12e524397/rtl/ram_sdp.v
