ifndef CLIPROOT
	CLIPROOT=$(shell cd ../../../; pwd)/cliproot
endif

include $(CLIPROOT)/include/Makefile.inc

export CLIPROOT

all:
	cd netto && $(MAKE)
	cd nanfor&& $(MAKE)
install:
	cd netto && $(MAKE) install
	cd nanfor && $(MAKE) install
clean:
	cd netto && $(MAKE) clean
	cd nanfor && $(MAKE) clean

