#

dirs = clip-gzip clip-bzip2 clip-crypto clip-gd clip-fcgi \
       clip-gtk clip-gtkextra clip-fw clip-cti \
       clip-mysql clip-postgres clip-oracle clip-interbase clip-odbc \
       clip-com clip-oasis clip-rtf \

all local user system install lib: clean
	for dir in $(dirs); \
	do \
		(cd $$dir ;\
                [ -x ./configure ] && ./configure ;\
		$(MAKE);\
		$(MAKE) $@ );\
	done

clean distclean:
	for dir in $(dirs); \
		do (cd $$dir && $(MAKE) clean distclean || true; rm -rf debian build-stamp $dir.spec);\
	done

deb: clean
	for dir in $(dirs); \
		do ./mkdeb $$dir; \
	done

rpm:
	for dir in $(dirs); \
		do ./mkrpm $$dir; \
	done

tgz tbz:
	for dir in $(dirs); \
		do ./mktgz $$dir; \
	done


