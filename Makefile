#
# use make local NODBU=no to override this
#
NODBU=yes
export NODBU

all:
	cat Readme_src | more
	@echo
	@echo
	@echo "choose target: local system deb rpm tgz tbz src"
	exit 1

install: all

clean:
	./clean.sh

cleanroot: clean
	[ -z "$CLIPROOT" ] || CLIPROOT=../cliproot; rm -rf $$CLIPROOT/*

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

tgz: clean
	./mktgz

tbz tbz2 tar.bz2: clean
	./mktgz -bzip2

src: clean
	./mksrc

src_p: clean
	./mksrc_p

ucommit:
	./cvs_ucommit

commit:
	./cvs_commit

update:
	./cvs_update

.PHONY: deb rpm

