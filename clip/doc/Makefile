all: install

html:
	-cd tdoc && $(MAKE) html

install:
	mkdir -p $(DOCDIR)
	cp -R rus Readme.* cygwin.reg clip_bug.msg $(DOCDIR)
	-cd tdoc && $(MAKE) install

clean:
	-cd tdoc && $(MAKE) clean

distclean:
	-cd tdoc && $(MAKE) distclean

