ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif

all:
	cd netto && $(MAKE)
	cd nanfor&& $(MAKE)
install:
	cd netto && $(MAKE) install
	cd nanfor && $(MAKE) install
clean:
	cd netto && $(MAKE) clean
	cd nanfor && $(MAKE) clean

