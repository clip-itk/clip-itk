ifndef CLIPROOT
	CLIPROOT=$(shell cd ../../../; pwd)/cliproot
endif

include $(CLIPROOT)/include/Makefile.inc
#

dirs = clip-gzip clip-bzip2 clip-crypto clip-gd clip-fcgi \
       clip-gtk2 \
       clip-mysql clip-postgres clip-oracle clip-interbase clip-odbc \
       clip-com clip-oasis clip-rtf clip-r2d2 \
       clip-xml clip-glade2 clip-ui

#clip-cti  clip-fw clip-gtk clip-gtkextra

all local user system install lib:
	for dir in $(dirs); \
	do \
		(cd $$dir ;\
		[ -x ./configure ] && ./configure ;\
		$(MAKE) $@ );\
	done

clean:
	for dir in $(dirs); \
		do (cd $$dir && $(MAKE) clean || true; rm -rf debian build-stamp $dir.spec);\
	done

distclean: clean
	for dir in $(dirs); \
		do (cd $$dir && $(MAKE) distclean || true);\
	done

deb: clean
	for dir in $(dirs); \
		do ./mkdeb $$dir; \
	done

rpm:
	for dir in $(dirs); \
		do ./mkrpm $$dir; \
	done

rpm-opt:
	for dir in $(dirs); \
		do ./mkrpm -opt $$dir; \
	done

tgz tbz:
	for dir in $(dirs); \
		do ./mktgz $$dir; \
	done


