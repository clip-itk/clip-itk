#!/bin/sh
[ -n "$MAKE" ] || MAKE=make
export MAKE
rm -f *.bak
rm -f $CLIPROOT/bin/clip_bl $CLIPROOT/bin/clip_blank $CLIPROOT/bin/clip_run \
      $CLIPROOT/bin/www_clip $CLIPROOT/bin/wcl2prg $CLIPROOT/bin/sqlrun \
      $CLIPROOT/bin/clip_prg $CLIPROOT/bin/clip_we $CLIPROOT/bin/clip_hv \
      $CLIPROOT/bin/clip_cld
if [ -d brow ]
then
	cd brow; $MAKE clean; cd ..
fi
if [ -d doc_utils ]
then
	cd doc_utils; $MAKE clean; cd ..
fi
if [ -d cobra_serv ]
then
	cd cobra_serv; $MAKE clean; cd ..
fi
if [ -d cobra_clnt ]
then
	cd cobra_clnt; $MAKE clean; cd ..
fi
if [ -d debug ]
then
	cd debug; $MAKE clean; cd ..
fi
if [ -d samples ]
then
	cd samples; $MAKE clean; cd ..
fi
if [ -d utils ]
then
	cd utils; $MAKE clean; cd ..
fi
if [ -d kamache ]
then
	cd kamache; $MAKE clean; cd ..
fi
if [ -d pp ]
then
	cd pp; $MAKE clean; cd ..
fi
if [ -d udb ]
then
	cd udb; $MAKE clean; cd ..
fi
if [ -d udbx ]
then
	cd udbx; $MAKE clean; cd ..
fi
if [ -d dbc ]
then
   cd dbc
   $MAKE clean
   cd ..
fi
if [ -d ca_dbu ]
then
   cd ca_dbu
   $MAKE clean
   cd ..
fi
if [ -d ca_dbu53 ]
then
   cd ca_dbu53
   $MAKE clean
   cd ..
fi

if [ -d hiper ]
then
   cd hiper
   $MAKE clean
   cd ..
fi

if [ -d bdbfs ]
then
   cd bdbfs
   $MAKE clean
   cd ..
fi

