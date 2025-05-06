# SPDX-License-Identifier: GPL-2.0
# Makefile for building AD5413 out-of-tree module

obj-m := ad5413.o

KDIR := /lib/modules/$(shell uname -r)/build
PWD  := $(shell pwd)

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
