%define rel 0

%define _unpackaged_files_terminate_build  1

%define with_bzip2      1
%define with_cobra      1
%define with_codb       1
%define with_com        1
%define with_crypto     1
%define with_cti        0
%define with_fw         0
%define with_gtk        0
%define with_gd         1
%define with_gtk2       1
%define with_gzip       1
%define with_ui         0
%define with_kamache    1
%define with_mysql      1
%define with_oasis      1
%define with_odbc       1
%define with_postgres   1
%define with_postscript 1
%define with_rtf        1
%define with_r2d2       1
%define with_xml        0


Summary:	XBASE/Clipper compatible program compiler
Name:		clip
Version:	1.2.0
Release:	%{rel}cis
Vendor:		CISLinux
Packager:	Serge Dudko <serge@cis.by>
URL:		http://www.itk.ru
Group:		Development
License:        GPL
Requires: 	clip-lib = %{version}-%{release}
Requires:	gcc, make, binutils, readline, flex, gettext
BuildRoot:	/tmp/%{name}-%{version}
BuildRequires:  gcc, make, binutils, bison, flex, gettext, libpng-devel, libjpeg-devel, gd-devel, gtk2-devel
BuildRequires:  openssl-devel, readline-devel, pth-devel, ncurses-devel, unixODBC-devel, mysql-devel
Source0:         %{name}-prg-%{version}-0.tgz
BuildRoot: 	%{_tmppath}/%{name}-root


%define clipdir /usr/clip/%{version}-%{rel}

%description
This package includes the clip compiler 

%package utils
Summary: Runtime library for clip.
License: GPL
Group: System Environment/Libraries
Requires: %{name} = %{version}-%{release}
Requires: %{name}-oasis = %{version}-%{release}

%description utils
This package provides runtime shared libraries for CLIP package


%package lib
Summary: Runtime library for clip.
License: GPL
Group: System Environment/Libraries
Prereq: /sbin/ldconfig
Requires: gpm

%description lib
This package provides runtime shared libraries for CLIP package


%if "%{with_cobra}" != "0"
%package cobra
Summary: COBRA development for clip.
License: GPL
Group: System Environment/Libraries
Requires: clip-lib = %{version}-%{release}
Requires: %{name}-oasis = %{version}-%{release}

%description cobra
This package provides COBRA development for CLIP package
%endif


%if "%{with_codb}" != "0"
%package codb
Summary: CLIP object data base
License: GPL
Group: System Environment/Libraries
Requires: clip-lib = %{version}-%{release}
Requires: %{name}-oasis = %{version}-%{release}

%description codb
This package provides CLIP object data base
%endif

%if "%{with_bzip2}" != "0"
%package bzip2
Summary: CLIP bzip2 binding
License: GPL
Group: System Environment/Libraries
Requires: bzip2-libs clip-lib = %{version}-%{release}
BuildRequires: bzip2-devel

%description bzip2
This package provides bzip2 binding for CLIP
%endif

%if "%{with_com}" != "0"
%package com
Summary: COM-port binding for CLIP
License: GPL
Group: System Environment/Libraries
Requires: clip-lib = %{version}-%{release}

%description com
This package provides COM-port binding for CLIP
%endif

%if "%{with_crypto}" != "0"
%package crypto
Summary: CLIP cryptographic binding
License: GPL
Group: System Environment/Libraries
Requires: openssl, clip-lib = %{version}-%{release}
BuildRequires: openssl-devel

%description crypto
This package provides cryptographic binding for CLIP
%endif

%if "%{with_cti}" != "0"
%package cti
Summary: CLIP cti binding
License: GPL
Group: System Environment/Libraries
Requires: clip-lib = %{version}-%{release}

%description cti
This package provides cti binding for CLIP
%endif

%if "%{with_gd}" != "0"
%package gd
Summary: CLIP ODBC binding
License: GPL
Group: System Environment/Libraries
Requires: gd, clip-lib = %{version}-%{release}
BuildRequires: gd-devel

%description gd
This package provides gd binding for CLIP
%endif

%if "%{with_gtk}" != "0"
%package gtk
Summary: CLIP gtk+ binding
License: GPL
Group: System Environment/Libraries
Requires: gtk+, clip-lib = %{version}-%{release}
BuildRequires: gtk+-devel

%description gtk
This package provides gtk+ binding for CLIP
%endif

%if "%{with_gtk2}" != "0"
%package gtk2
Summary: CLIP gtk2 binding
License: GPL
Group: System Environment/Libraries
Requires: gtk2, clip-lib = %{version}-%{release}
BuildRequires: gtk2-devel

%description gtk2
This package provides gtk2 binding for CLIP
%endif

%if "%{with_gzip}" != "0"
%package gzip
Summary: CLIP gzip binding
License: GPL
Group: System Environment/Libraries
Requires: zlib, clip-lib = %{version}-%{release}
BuildRequires: zlib-devel

%description gzip
This package provides gzip binding for CLIP
%endif

%if "%{with_fw}" != "0"
%package fw
Summary: CLIP fw binding
License: GPL
Group: System Environment/Libraries
Requires: clip-lib = %{version}-%{release}
%description fw
This package provides fw binding for CLIP
%endif

%if "%{with_kamache}" != "0"
%package kamache
Summary: CLIP kamache binding
License: GPL
Group: System Environment/Libraries
Requires: clip-lib = %{version}-%{release}

%description kamache
This package provides kamache for CLIP
%endif

%if "%{with_mysql}" != "0"
%package mysql
Summary: CLIP mySQL binding
License: GPL
Group: System Environment/Libraries
Requires: mysql, clip-lib = %{version}-%{release}
BuildRequires: mysql-devel

%description mysql
This package provides mySQL binding for CLIP
%endif

%if "%{with_oasis}" != "0"
%package oasis
Summary: CLIP oasis binding
License: GPL
Group: System Environment/Libraries
Requires: clip-lib = %{version}-%{release}

%description oasis
This package provides oasis binding for CLIP
%endif

%if "%{with_odbc}" != "0"
%package odbc
Summary: CLIP ODBC binding
License: GPL
Group: System Environment/Libraries
Requires: unixODBC, clip-lib = %{version}-%{release}
BuildRequires: unixODBC-devel

%description odbc
This package provides odbc binding for CLIP
%endif

%if "%{with_postgres}" != "0"
%package postgres
Summary: CLIP PostgreSQL binding
License: GPL
Group: System Environment/Libraries
Requires: postgresql-libs, clip-lib = %{version}-%{release}
BuildRequires: postgresql-devel

%description postgres
This package provides PostgreSQL binding for CLIP
%endif

%if "%{with_postscript}" != "0"
%package postscript
Summary: CLIP Postscript binding
License: GPL
Group: System Environment/Libraries
Requires: clip-lib = %{version}-%{release}

%description postscript
This package provides Postscript binding for CLIP
%endif

%if "%{with_rtf}" != "0"
%package rtf
Summary: CLIP RTF binding
License: GPL
Group: System Environment/Libraries
Requires: clip-lib = %{version}-%{release}

%description rtf
This package provides RTF binding for CLIP
%endif

%if "%{with_r2d2}" != "0"
%package r2d2
Summary: CLIP r2d2 binding
License: GPL
Group: System Environment/Libraries
Requires: clip-lib = %{version}-%{release}

%description r2d2
This package provides r2d2 binding for CLIP
%endif


%if "%{with_ui}" != "0"
%package ui
Summary: CLIP ui binding
License: GPL
Group: System Environment/Libraries
Requires: clip-lib = %{version}-%{release}

%description ui
This package provides libclip-ui
%endif

%if "%{with_xml}" != "0"
%package xml
Summary: CLIP XML support
License: GPL
Group: System Environment/Libraries
Requires: clip-lib = %{version}-%{release}

%description xml
This package provides XML for CLIP
%endif

%prep
tar -xzf %{SOURCE0}
cd %{name}-prg-%{version}-0


#tar -xzf %{SOURCE1}
#cp -f -R clip-prg/* ./
#rm -f -R clip-prg

#pushd cliplibs/clip-gtk2
#%patch0 -p 0 -b .slavaz
#popd

%build
if [ -d %{clipdir} ]; then
    echo "Installed CLIP detected!!!"
    echo
    echo "HINT: you can change release number and rebuild again"
    exit 1
fi

mkdir -p %{clipdir}
export CLIPROOT=%{clipdir}
cd %{name}-prg-%{version}-0
make local

%install
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT

mkdir -p $RPM_BUILD_ROOT/usr/clip
mv -f %{clipdir} $RPM_BUILD_ROOT/usr/clip



%clean
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT


%files
%defattr(-,root,root)
%{clipdir}/bin/add_meta_tag
%{clipdir}/bin/cleanxmo.sh
%{clipdir}/bin/clip
%{clipdir}/bin/clip_bug
%{clipdir}/bin/clip_conv
%{clipdir}/bin/clip_cp
%{clipdir}/bin/clip_dbg
%{clipdir}/bin/clip_hashextract
%{clipdir}/bin/clip_makelib
%{clipdir}/bin/clip_makeslib
%{clipdir}/bin/clip_msgfmt
%{clipdir}/bin/clip_msgmerge
%{clipdir}/bin/clip_trans
%{clipdir}/bin/clipar
%{clipdir}/bin/cliphash
%{clipdir}/bin/gen_tbl
%{clipdir}/bin/joinlib.sh
%{clipdir}/bin/lowname
%{clipdir}/bin/ocmng
%{clipdir}/bin/po_compat
%{clipdir}/bin/po_extr
%{clipdir}/bin/po_subst
%{clipdir}/bin/tconv
#%{clipdir}/bin/xclip
%{clipdir}/bin/xml2xmo
%{clipdir}/cliprc/.notrm
%{clipdir}/cliprc/clipflags
%{clipdir}/doc/example/Makefile
%{clipdir}/doc/example/*.ch
%{clipdir}/doc/example/*.prg
%{clipdir}/doc/example/test.dbf.orig
%{clipdir}/include/Makefile.inc
%{clipdir}/include/Makefile.tdoc
%{clipdir}/include/tcp.ch
%{clipdir}/include/_win32.h
%{clipdir}/include/achoice.ch
%{clipdir}/include/aof.ch
%{clipdir}/include/assert.ch
%{clipdir}/include/blob.ch
%{clipdir}/include/box.ch
%{clipdir}/include/browsys.ch
%{clipdir}/include/btree.h
%{clipdir}/include/screen/charset.h
%{clipdir}/include/button.ch
%{clipdir}/include/cl_cfg.h
%{clipdir}/include/clip.ch
%{clipdir}/include/clip.h
%{clipdir}/include/clipbrd.ch
%{clipdir}/include/clipcfg.h
%{clipdir}/include/clipcfg.sh
%{clipdir}/include/clr_html.ch
%{clipdir}/include/color.ch
%{clipdir}/include/common.ch
%{clipdir}/include/config.ch
%{clipdir}/include/ct.ch
%{clipdir}/include/cobra.ch 
%{clipdir}/include/ctdisk.ch
%{clipdir}/include/ctdrv.ch
%{clipdir}/include/ctkbd.ch
%{clipdir}/include/ctmisc.ch
%{clipdir}/include/ctnnet.ch
%{clipdir}/include/ctppc.ch
%{clipdir}/include/ctprint.ch
%{clipdir}/include/ctps.ch
%{clipdir}/include/ctscan.ch
%{clipdir}/include/ctsys.ch
%{clipdir}/include/ctvideo.ch
%{clipdir}/include/ctwin.ch
%{clipdir}/include/date.ch
%{clipdir}/include/dbedit.ch
%{clipdir}/include/dbfsql.h
%{clipdir}/include/dbinames.ch
%{clipdir}/include/dbinfo.ch
%{clipdir}/include/dbms.ch
%{clipdir}/include/dbstruct.ch
%{clipdir}/include/debug.ch
%{clipdir}/include/directry.ch
%{clipdir}/include/edit.ch
%{clipdir}/include/error.ch
%{clipdir}/include/fileio.ch
%{clipdir}/include/form.ch
%{clipdir}/include/fox.ch
%{clipdir}/include/foxsql.ch
%{clipdir}/include/frmdef.ch
%{clipdir}/include/func_ref.ch
%{clipdir}/include/getexit.ch
%{clipdir}/include/hash.h
%{clipdir}/include/html.ch
%{clipdir}/include/imenu.ch
%{clipdir}/include/inkey.ch
%{clipdir}/include/key_name.ch
%{clipdir}/include/lang.ch
%{clipdir}/include/lbldef.ch
%{clipdir}/include/llibg.ch
%{clipdir}/include/memdebug
%{clipdir}/include/memoedit.ch
%{clipdir}/include/mset.ch
%{clipdir}/include/http.ch
%{clipdir}/include/ord.ch
%{clipdir}/include/ordinfo.ch
%{clipdir}/include/pgch.ch
%{clipdir}/include/rdd.ch
%{clipdir}/include/rddsys.ch
%{clipdir}/include/reserved.ch
%{clipdir}/include/set.ch
%{clipdir}/include/setcurs.ch
%{clipdir}/include/setnames.ch
%{clipdir}/include/simpleio.ch
%{clipdir}/include/six.ch
%{clipdir}/include/six2clip.ch
%{clipdir}/include/std.ch
%{clipdir}/include/std50.ch
%{clipdir}/include/std53.ch
%{clipdir}/include/task.h
%{clipdir}/include/task2.h
#%{clipdir}/include/taskcfg.h
%{clipdir}/include/tbrowse.ch
%{clipdir}/include/ulimit.ch
%{clipdir}/lib/libclip.a
%{clipdir}/lib/libclip.ex
%{clipdir}/lib/libclip.nm
%{clipdir}/include/pp_harb.ch
%{clipdir}/include/ppclass.ch
%{clipdir}/include/rp_dot.ch
%{clipdir}/include/rp_run.ch
%{clipdir}/include/bggraph.ch

%{clipdir}/locale.mo/*/clip.mo
%{clipdir}/locale.mo/*/cliprt.mo
%{clipdir}/locale.po/*/clip.po
%{clipdir}/locale.po/*/cliprt.po

%{clipdir}/locale.mo/*/sys.mo
%{clipdir}/locale.po/*/sys.po
%{clipdir}/locale.pot/sys/*

%{clipdir}/locale.mo/*/debug.mo
%{clipdir}/locale.po/*/debug.po
#%{clipdir}/locale.pot/debug/*

%{clipdir}/locale.po/*/brow.po
%{clipdir}/locale.mo/*/brow.mo
%{clipdir}/locale.po/*/ca_dbu.po
%{clipdir}/locale.mo/*/ca_dbu.mo

%{clipdir}/locale.po/*/pp.po
%{clipdir}/locale.mo/*/pp.mo

%{clipdir}/locale.po/*/udb.po
%{clipdir}/locale.mo/*/udb.mo
#%{clipdir}/locale.pot/udb/*

#%{clipdir}/locale.pot/udbx/*.pot
%{clipdir}/locale.po/*/udbx.po
%{clipdir}/locale.mo/*/udbx.mo

#%{clipdir}/locale.mo/es_ES*/mod-ini.mo
#%{clipdir}/locale.mo/ru_RU*/mod-ini.mo
#%{clipdir}/locale.po/es_ES*/mod-ini.po
#%{clipdir}/locale.po/ru_RU*/mod-ini.po
#%{clipdir}/locale.pot/mod-ini/*

%files utils
%defattr(-,root,root)
%{clipdir}/bin/bdbf*
%{clipdir}/bin/clip_bl
%{clipdir}/bin/clip_blank
%{clipdir}/bin/clip_cld
%{clipdir}/bin/clip_dbf2txt
%{clipdir}/bin/clip_fl
%{clipdir}/bin/clip_hindex
%{clipdir}/bin/clip_hseek
%{clipdir}/bin/clip_hv
%{clipdir}/bin/clip_prg
%{clipdir}/bin/clip_run
%{clipdir}/bin/clip_we
%{clipdir}/bin/ctosgml
%{clipdir}/bin/dbc
%{clipdir}/bin/ftosgml
%{clipdir}/bin/pp_ron
%{clipdir}/bin/sqlrun
%{clipdir}/bin/wcl2prg
%{clipdir}/bin/www_clip
%{clipdir}/etc/.macro
%{clipdir}/etc/.templ
#%{clipdir}/locale.pot/bdbfs/*.pot
%{clipdir}/locale.po/*/bdbfs.po
%{clipdir}/locale.mo/*/bdbfs.mo

%files lib
%defattr(-,root,root)
%{clipdir}/charsets/*
%{clipdir}/etc/environment
%{clipdir}/etc/printers.ini
%{clipdir}/etc/termcap
%{clipdir}/etc/terminfo/*/*
%{clipdir}/keymaps/*
%{clipdir}/lang/*
%{clipdir}/term/*
%{clipdir}/lib/libclip.so

%if "%{with_cobra}" != "0"
%files cobra
%defattr(-,root,root)
%{clipdir}/bin/cobra_clnt1
%{clipdir}/bin/cobra_serv
%{clipdir}/cobra/auth/*
%{clipdir}/cobra/cobra*

%{clipdir}/cobra/*.po
%{clipdir}/cobra/files/*
%{clipdir}/cobra/tcp-wrap/*
#%{clipdir}/locale.pot/cobra_clnt/*
#%{clipdir}/locale.pot/cobra_serv/*
#%{clipdir}/locale.pot/mod-ini/cobra_codb.pot
#%{clipdir}/locale.mo/*/cobra*
#%{clipdir}/locale.po/*/cobra*
%{clipdir}/cobra/mod-ini/*
%endif

%if "%{with_codb}" != "0"
%files codb
%defattr(-,root,root)
%{clipdir}/include/codb_dbf.ch
%{clipdir}/lib/libclip-codb.*
#%{clipdir}/codb_ab/plugins/*
#%{clipdir}/codb_ab/plugins/.*
%{clipdir}/bin/codb_*
%{clipdir}/bin/codb
%{clipdir}/codb_ab/reports/*
%{clipdir}/codb_ab/reports/.*
%{clipdir}/codb_ab/plugins/*
%{clipdir}/codb_ab/plugins/.*
#%{clipdir}/codb_abx/plugins/*
#%{clipdir}/codb_abx/plugins/.*
%{clipdir}/include/codb.ch
%{clipdir}/include/codbcfg.ch
%{clipdir}/locale.po/ru_*/codb.po
%{clipdir}/locale.pot/codb/*
%{clipdir}/locale.mo/*/codb.mo
%{clipdir}/locale.po/es_*/codb.po
%{clipdir}/lib/libcodb-query.*
%{clipdir}/locale.po/pt_BR.8859-1/codb.po
%endif

%if "%{with_bzip2}" != "0"
%files bzip2
%defattr(-,root,root)
%{clipdir}/doc/example/clip-bzip2/*
%{clipdir}/lib/libclip-bzip2.*
%endif

%if "%{with_com}" != "0"
%files com
%defattr(-,root,root)
%{clipdir}/doc/example/clip-com/*
#%{clipdir}/doc/clip-com/*
%{clipdir}/lib/libclip-com.*
%endif

%if "%{with_r2d2}" != "0"
%files r2d2
%defattr(-,root,root)
%{clipdir}/include/r2d2lib.ch
%{clipdir}/lib/libclip-r2d2.*
#%{clipdir}/locale.mo/es_ES*/clip-r2d2.mo
#%{clipdir}/locale.mo/ru_RU*/clip-r2d2.mo
#%{clipdir}/locale.po/es_ES*/clip-r2d2.po
#%{clipdir}/locale.po/ru_RU*/clip-r2d2.po
#%{clipdir}/locale.pot/clip-r2d2/*
%endif

%if "%{with_crypto}" != "0"
%files crypto
%defattr(-,root,root)
%{clipdir}/doc/example/clip-crypto/*
%{clipdir}/lib/libclip-crypto.*
%endif

%if "%{with_ui}" != "0"
%files ui
%defattr(-,root,root)
%{clipdir}/doc/example/clip-ui/*
%{clipdir}/lib/libclip-ui.*
%{clipdir}/include/clip-ui.ch
%endif


%if "%{with_cti}" != "0"
%files cti
%defattr(-,root,root)
%{clipdir}/doc/example/clip-cti/*
%{clipdir}/etc/.calendar
%{clipdir}/include/cti.ch
%{clipdir}/include/cti/*
%{clipdir}/lib/libclip-cti.*
%{clipdir}/locale.pot/clip-cti/*
%endif

%if "%{with_gtk}" != "0"
%files gtk
%defattr(-,root,root)
%{clipdir}/cliprc/clip-gtk.cliprc
%{clipdir}/doc/example/clip-gtk/*
%{clipdir}/include/clip-gtk.ch
%{clipdir}/include/clip-gtk.h
%{clipdir}/lib/libclip-gtk.*
%{clipdir}/lib/drivers/driver-gtk.*
#%{clipdir}/locale.pot/gtk/*
%endif

%if "%{with_gtk2}" != "0"
%files gtk2
%defattr(-,root,root)
%{clipdir}/cliprc/clip-gtk2.cliprc
%{clipdir}/doc/example/clip-gtk2/*
%{clipdir}/include/clip-gtk2.ch
%{clipdir}/include/clip-gtk2.h
%{clipdir}/include/gtk2-stock.ch
%{clipdir}/lib/libclip-gtk2.*
#%{clipdir}/lib/drivers/driver-gtk2.*
#%{clipdir}/locale.pot/gtk2/*
%endif

%if "%{with_gzip}" != "0"
%files gzip
%defattr(-,root,root)
%{clipdir}/doc/example/clip-gzip/*
%{clipdir}/lib/libclip-gzip.*
%endif

%if "%{with_mysql}" != "0"
%files mysql
%defattr(-,root,root)
%{clipdir}/doc/example/clip-mysql/*
%{clipdir}/doc/clip-mysql/*
%{clipdir}/include/mysql.ch
%{clipdir}/lib/libclip-mysql.*
%endif

%if "%{with_oasis}" != "0"
%files oasis
%defattr(-,root,root)
%{clipdir}/include/nanfor/*
%{clipdir}/include/netto/*
%{clipdir}/lib/libclip-nanfor.*
%{clipdir}/lib/libclip-netto.*
%endif

%if "%{with_odbc}" != "0"
%files odbc
%defattr(-,root,root)
%{clipdir}/lib/libclip-odbc.*
%endif

%if "%{with_postgres}" != "0"
%files postgres
%defattr(-,root,root)
%{clipdir}/doc/example/clip-postgres/*
%{clipdir}/doc/clip-postgres/*
%{clipdir}/include/postgres.ch
%{clipdir}/lib/libclip-postgres.*
%endif

%if "%{with_postscript}" != "0"
%files postscript
%defattr(-,root,root)
%{clipdir}/doc/example/clip-postscript/*
%{clipdir}/include/clip-postscript.ch
%{clipdir}/lib/libclip-postscript.*
%endif

%if "%{with_rtf}" != "0"
%files rtf
%defattr(-,root,root)
%{clipdir}/doc/example/clip-rtf/*
%{clipdir}/include/objects.ch
%{clipdir}/include/richtext.ch
%{clipdir}/lib/libclip-rtf.*
%endif

%if "%{with_gd}" != "0"
%files gd
%defattr(-,root,root)
%{clipdir}/doc/example/clip-gd/*
%{clipdir}/doc/clip-gd/*
%{clipdir}/include/gdinfo.ch
%{clipdir}/lib/libclip-gd.*
%{clipdir}/lib/libgd.*
%endif

%if "%{with_fw}" != "0"
%files fw
%defattr(-,root,root)
%{clipdir}/doc/example/clip-fw/*
%{clipdir}/doc/example/clip-fw/.*
%{clipdir}/lib/libclip-fw.*
%{clipdir}/locale.mo/*/clip-fw.mo
%{clipdir}/locale.po/*/clip-fw.po
%{clipdir}/locale.pot/clip-fw/*
%endif

%if "%{with_kamache}" != "0"
%files kamache
%defattr(-,root,root)
%{clipdir}/kamache/kamache*
%{clipdir}/kamache/mod-clip/*
%{clipdir}/kamache/mod-ini/*
%endif

%if "%{with_xml}" != "0"
%files xml
%defattr(-,root,root)
%{clipdir}/bin/ocmng
%{clipdir}/bin/cleanxmo.sh
%{clipdir}/bin/xml2xmo
%{clipdir}/lib/libclip-xml.*
%{clipdir}/include/clip-expat.*
%{clipdir}/doc/example/clip-xml/*
%endif

%changelog

* Mon Dec 12 2006 Serge Dudko <serge@cis.by>
- build clip version 1.2.0 .  Compatible with ASPLinux 11 and FC4.
- added XML package definition for this release

* Wed Dec 28 2005 Slava Zanko <SlavaZ@cis.by>
- build clip version 1.1.15

* Fri Jul 15 2005 Slava Zanko <SlavaZ@cis.by>
- build clip version 1.1.14
- added rules for clip-ui, clip-kamache, clip-r2d2 packages

* Fri Apr 16 2004 Slava Zanko <SlavaZ@cis.by>
- added rules for clip-gd package CISLinux

* Fri Apr 16 2004 Slava Zanko <SlavaZ@cis.by>
- creating spec file for compatibility with CISLinux
