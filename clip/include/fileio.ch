#ifndef _FIO_DEFINED
#define _FIO_DEFINED

#define F_ERROR            (-1)

/* Fseek() modes */
#define FS_SET             0     /* from BOF */
#define FS_RELATIVE        1     /* from current position */
#define FS_END             2     /* from EOF */

#ifdef __CLIP__
	#translate FGOTOP(<f>)     => FSEEK( <f>, 0, FS_SET )
	#translate FGOBOTTOM(<f>)  => FSEEK( <f>, 0, FS_END)
	#translate FPOS(<f>)       => FSEEK( <f>, 0, FS_RELATIVE )
	#translate FBOF(<f>)       => (FPOS(<f>) == 0)
	#translate FEOF(<f>)       => (FPOS(<f>) == FSize(<f>))
#endif

/* mode open for FOPEN */
#define FO_READ            0
#define FO_WRITE           1
#define FO_READWRITE       2

/* access modes for FOPEN */
#define FO_COMPAT          0
#define FO_EXCLUSIVE      16
#define FO_DENYWRITE      32
#define FO_DENYREAD       48
#define FO_DENYNONE       64
#define FO_SHARED         64


/* create modes for FCREATE */
#define FC_NORMAL      0
#define FC_DEFAULT     FC_NORMAL
#define FC_READONLY    1
#define FC_HIDDEN      2
#define FC_SYSTEM      4

/* FSETDEVMODE() device modes */
#define FD_RAW       1
#define FD_BINARY    1
#define FD_COOKED    2
#define FD_TEXT      2
#define FD_ASCII     2

/* Internal CLIP types of opened files */
#define FT_NONE       -1
#define FT_ERROR      FT_NONE
#define FT_UNKNOWN    0
#define FT_FILE       1
#define FT_STREAM     2
#define FT_PIPE       3
#define FT_SOCKET     4

/* FLOCKF() locking modes (FS compatibility) */
#define FF_UNLCK	0	/* Unlock the whole file */
#define FF_RDLCK	1	/* Lock for reading by currrent process,
  				prevents others from writing */
#define FF_WRLCK	2	/* Lock for writing by current porcess,
				prevents others from reading */



#endif

