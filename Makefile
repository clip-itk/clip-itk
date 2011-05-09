#
# use make local NODBU=no to override this
#
NODBU=yes
export NODBU MAKE

all:
	cat Readme_src | more
	@echo
	@echo
	@echo "choose target: local system deb rpm rpm-opt tgz tbz src"
	exit 1

install: all

clean:
	./clean.sh

distclean:
	./distclean.sh

cleanroot: clean
	rm -rf ../cliproot/*

user local: clean
	./mklocal

system: clean
	./mklocal -release

packages: clean src tgz rpm deb

lp: NODBU=no
lp: src cleanroot local deb tgz rpm

deb: clean
	./mkdeb

rpm: clean
	./mkrpm

rpm-opt: clean
	./mkrpm -opt

tgz: clean
	./mktgz

tbz tbz2 tar.bz2: clean
	./mktgz -bzip2

src: clean
	./mksrc

doc: clean
	./mkdoc

src_p: clean
	./mksrc_p

#doc:
#	cd tdoc && $(MAKE)

.PHONY: deb rpm

