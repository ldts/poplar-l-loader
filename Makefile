#
# (C) Copyright 2017 Linaro Limited
#
# Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
#
# Configuration for Poplar 96boards EE. Parts were derived from other ARM
# configurations.
#
# SPDX-License-Identifier:	GPL-2.0+
#

CROSS_COMPILE ?= arm-linux-gnueabihf-
CC=$(CROSS_COMPILE)gcc
LD=$(CROSS_COMPILE)ld
OBJCOPY=$(CROSS_COMPILE)objcopy

TEXT_BASE=0x1000
LLOADER_LEN=960K

all: l-loader.bin
l-loader.bin: start.S debug.S
	$(CC) -c -o start.o start.S -DTEXT_BASE=${TEXT_BASE}
	$(CC) -c -o debug.o debug.S
	$(LD) -Bstatic -Tl-loader.lds -Ttext ${TEXT_BASE} start.o debug.o -o l-loader
	$(OBJCOPY) -O binary l-loader temp.bin
	dd if=temp.bin of=l-loader.bin bs=${LLOADER_LEN} count=1 conv=sync

clean:
	rm -f *.o l-loader l-loader.bin temp.bin temp
