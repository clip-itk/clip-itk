/*
   Copyright (C) 2001  ITK
   Author   : Paul Lasarev <paul@itk.ru>
   License : (GPL) http://www.itk.ru/clipper/license.html
 */
/*
   $Log: clipvm.c,v $
   Revision 1.114  2004/04/14 10:38:32  clip
   rust: suppress GCC 3.3.3 warnings

   Revision 1.113  2004/01/23 09:42:29  clip
   uri: small fix in macro_in_string

   Revision 1.112  2003/11/14 10:13:48  clip
   fix trap in PO code
   paul

   Revision 1.111  2003/11/13 13:17:31  clip
   add error 'po code too large'
   paul

   Revision 1.110  2003/11/13 08:16:43  clip
   fall back for switch
   paul

   Revision 1.108  2003/11/04 11:18:34  clip
   post signal handler
   paul

   Revision 1.107  2003/09/08 15:06:03  clip
   uri: next step fixes for mingw from uri

   Revision 1.106  2003/09/02 14:27:42  clip
   changes for MINGW from
   Mauricio Abre <maurifull@datafull.com>
   paul

   Revision 1.105  2003/08/14 08:46:56  clip
   fix charset
   fix #154
   paul

   Revision 1.104  2003/08/13 10:36:42  clip
   extend limit of 255 local vars.
   fixes #151
   paul

   Revision 1.103  2003/07/03 07:15:55  clip
   fix a lot of warnings
   paul

   Revision 1.102  2003/05/16 11:08:02  clip
   initial support for using assembler instead C
   now activated if environment variable CLIP_ASM is defined to any value
   paul

   Revision 1.101  2003/03/25 10:31:13  clip
   possible fixes #133
   paul

   Revision 1.100  2003/03/17 08:24:59  clip
   Solaris 8 patches
   paul

   Revision 1.99  2003/01/05 12:32:25  clip
   possible fixes #95,#98
   paul

   Revision 1.98  2003/01/05 10:34:23  clip
   possible fixes #98
   paul

   Revision 1.97  2002/12/31 08:03:36  clip
   assign to locals
   closes #95
   paul

   Revision 1.96  2002/12/23 13:57:47  clip
   reference to temporary object
   frame structure extended!
   closes #90
   paul

   Revision 1.95  2002/12/05 12:38:01  clip
   fix sigsegv with local vars in codeblock
   possible fixes #15
   may be memleaks...
   paul

   Revision 1.94  2002/12/04 07:09:59  clip
   simple profiler realised
   start program with --profile will generate <progname>.pro profile
   limitations: manual written C functions are not profiled, bad accuracy
   paul

   Revision 1.93  2002/11/10 13:20:17  clip
   fix for gcc-3.2 optimisation
   paul

   Revision 1.92  2002/08/02 10:07:03  clip
   double errblock call fix
   paul

   Revision 1.91  2002/05/16 09:07:43  clip
   possible to disable expansion in strings:
   SET MACRO_IN_STRING OFF
   paul

   Revision 1.90  2002/04/30 12:52:01  clip
   add -stack flag to configure to enable runtime stack check
   paul

   Revision 1.89  2002/03/27 13:33:01  clip
   SHORT overflow in .po with too much STRINGs.
   .po format changed
   paul

   Revision 1.88  2002/02/06 08:30:13  clip
   static codeblocks
   paul

   Revision 1.87  2002/01/31 08:35:53  clip
   LOADLIB now append dll's suffix automatically
   paul

   Revision 1.86  2002/01/30 13:02:06  clip
   use DLLREALSUFF instead DLLSUFF in clip_makeslib
   eval(b, @l)
   full filename in load error
   paul

   Revision 1.85  2002/01/30 07:00:09  clip
   prevent double loading of libraries
   paul

   Revision 1.84  2002/01/29 13:12:17  clip
   load( dll)
   tested under linux
   paul

   Revision 1.83  2002/01/08 10:01:58  clip
   break
   without parameter trap NIL
   paul

   Revision 1.82  2002/01/04 12:14:03  clip
   pcode was limited to 1 byte for array count
   paul

   Revision 1.81  2002/01/04 10:29:48  clip
   big module
   paul

   Revision 1.80  2001/12/21 14:09:41  clip
   fall back
   paul

   Revision 1.79  2001/12/21 13:50:13  clip
   pcode fix
   paul

   Revision 1.78  2001/12/20 13:19:33  clip
   *** empty log message ***

   Revision 1.77  2001/11/23 13:36:45  clip
   assign by ref to map/array members:
   o:a := @var
   to break reference, use:
   o:a := @nil
   paul

   Revision 1.76  2001/11/22 11:33:32  clip
   a:='test->first'
   ? field->&a
   paul

   Revision 1.75  2001/11/12 14:13:46  clip
   START(cFuncname) now work :)
   paul

   Revision 1.74  2001/11/08 07:36:07  clip
   test under solaris do not undestand -L flag
   fix for close fd at ClipFile destroy
   paul

   Revision 1.73  2001/11/07 10:48:31  clip
   fixes for use mmap in win32
   paul

   Revision 1.72  2001/11/06 10:20:41  clip
   _clip_call_errblock in various points
   paul

   Revision 1.71  2001/10/22 07:27:51  clip
   SPARC fixes
   paul

   Revision 1.70  2001/09/24 04:48:24  clip
   os-dependend DLL suffix in runtime load function
   From: Anton Ustyancev <anton@cinvest.chel.su>
   paul

   Revision 1.69  2001/09/21 10:29:15  clip
   memvar priority in macro
   paul

   Revision 1.68  2001/09/19 12:54:23  clip
   push string in pcode
   paul

   Revision 1.67  2001/09/07 06:31:48  clip
   dll bindings
   paul

   Revision 1.66  2001/09/04 08:26:59  clip
   CODEBLOCK pseudofunction
   process codeblocks with macro calls as CODEBLOCK
   paul

   Revision 1.65  2001/08/27 09:45:30  clip
   switch operator
   paul

   Revision 1.64  2001/08/26 12:11:59  clip
   reflocals
   paul

   Revision 1.63  2001/08/26 11:37:00  clip
   selfref detection in local(b:=@localvar)
   paul

   Revision 1.62  2001/08/26 09:10:06  clip
   references
   paul

   Revision 1.61  2001/08/25 12:30:33  clip
   memleak in @func()
   paul

   Revision 1.60  2001/08/24 16:48:51  clip
   privates/paramters
   paul

   Revision 1.59  2001/08/24 14:38:47  clip
   CODESTR pseudofunction
   paul

   Revision 1.58  2001/08/23 13:52:06  clip
   merge with NEWLOCALS
   paul

   Revision 1.57.2.11  2001/08/23 10:13:42  clip
   fix field/memvar order in references
   paul

   Revision 1.57.2.10  2001/08/23 07:47:38  clip
   memfix
   paul

   Revision 1.57.2.9  2001/08/22 13:52:39  clip
   assign to field
   paul

   Revision 1.57.2.8  2001/08/21 14:29:39  clip
   refernce to macro: b:=@&s
   paul

   Revision 1.57.2.7  2001/08/21 12:10:36  clip
   local init in codeblock, f.e.:

   local a:={1,2,3}
   cb:={|x|local(b:=a[2]),iif(x==NIL,b,b:=x)}
   ? eval(cb)
   ? a
   ? eval(cb,'dddd')
   ? a
   ?

   paul

   Revision 1.57.2.6  2001/08/21 08:29:55  clip
   reference assign (like b:=@a[1])
   paul

   Revision 1.57.2.5  2001/08/20 07:13:47  clip
   block with macro
   fields with macro
   paul

   Revision 1.57.2.4  2001/08/16 13:41:54  clip
   fix
   paul

   Revision 1.57.2.3  2001/08/15 13:34:45  clip
   fix
   paul

   Revision 1.57.2.2  2001/08/06 06:41:04  clip
   PCODE
   paul

   Revision 1.57.2.1  2001/08/03 12:07:59  clip
   NEWLOCALS initial
   paul

   Revision 1.57  2001/06/14 10:20:13  clip
   LOADBLOCK(<cName>) -> code
   paul

   Revision 1.56  2001/05/30 09:45:43  clip
   for .. in .. [keys]
   paul

   Revision 1.55  2001/05/14 13:41:36  clip
   zero size
   paul

   Revision 1.54  2001/05/04 08:38:26  clip
   assign_field with macro
   paul

   Revision 1.53  2001/04/27 08:07:22  clip
   error handler
   paul

   Revision 1.52  2001/04/03 09:17:00  clip
   license errors
   paul

   Revision 1.51  2001/03/30 11:51:03  clip
   add copyright

   Revision 1.50  2001/03/19 10:16:22  clip
   hashnames
   paul

   Revision 1.49  2001/03/16 09:42:16  clip
   next/step cleanups
   paul

   Revision 1.48  2001/02/22 11:37:38  clip
   start data_command
   paul

   Revision 1.47  2001/02/22 09:53:36  clip
   dbg: expr command
   paul

   Revision 1.46  2001/02/08 06:35:54  clip
   static defs in .po
   paul

   Revision 1.45  2001/02/07 11:47:15  clip
   localdefs
   paul

   Revision 1.44  2001/02/06 13:07:25  clip
   hash in .po, dbg
   paul

   Revision 1.43  2001/02/01 13:05:06  clip
   debug links
   paul

   Revision 1.42  2001/01/19 08:43:33  clip
   append RDD direct access in rt.y

   functions (yet empty):
   int _clip_rddfieldno(ClipMachine * mp, int rddno, long namehash);
   int _clip_rddfield(ClipMachine * mp, int rddno, int fieldno);

   syntax:
   _rdd_ 2 <expr> _rdd_
   for direct access to RDD 2 in <expr>
   That means, rdd field names override normal fields/memvars

   paul

   Revision 1.41  2001/01/18 14:41:28  clip
   fixed memory leaks (CLIP_PUSH_STRDUP - t.flags=F_NONE)

   Revision 1.40  2000/12/26 12:17:26  clip
   load .so from CLIPROOT if no path
   paul

   Revision 1.39  2000/12/26 10:03:42  clip
   load now can load .so
   -s generate .so
   paul

   Revision 1.38  2000/12/09 12:13:28  clip
   locale
   paul

   Revision 1.37  2000/12/08 08:29:23  clip
   privates
   paul

   Revision 1.36  2000/12/07 07:19:38  clip
   [ string_constants ] - prepare for i18n
   linear sequence of func names in .po
   paul

   Revision 1.35  2000/12/05 13:03:17  clip
   run_vm: ClipVar.t.memo = 0 for NUMERIC_t

   rustCVS: ----------------------------------------------------------------------

   Revision 1.34  2000/11/23 06:50:23  clip
   load(name [,array])
   paul

   Revision 1.33  2000/11/22 14:52:20  clip
   .po now can be start with any (for example #!/usr/bin/cliprun) string
   paul

   Revision 1.32  2000/11/22 13:45:14  clip

   paul

   Revision 1.31  2000/11/22 11:50:44  clip
   pcode link sequence
   paul

   Revision 1.30  2000/11/22 09:37:42  clip
   init procedure in pcode
   paul

   Revision 1.29  2000/11/22 09:03:54  clip
   statics pcode
   paul

   Revision 1.28  2000/11/22 08:04:17  clip
   params in pcode
   paul

   Revision 1.27  2000/11/20 11:46:49  clip
   add CLIP_PUSH_STRDUP vm command
   rt compiler now use one
   paul

   Revision 1.26  2000/10/26 06:57:52  clip
   for..next in .po
   Paul Lasarev <paul@itk.ru>

   Revision 1.25  2000/05/25 16:00:40  clip
   macro in codeblocks
   break
   Paul Lasarev <paul@itk.ru>

   Revision 1.24  2000/05/24 18:34:17  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.23  2000/05/24 16:56:34  clip
   bugs
   Paul Lasarev <paul@itk.ru>

   Revision 1.22  2000/05/12 17:08:21  clip
   add error:syserr member
   Paul Lasarev <paul@itk.ru>

   Revision 1.21  2000/04/28 17:55:25  clip

   bsd fixes

   Revision 1.20  2000/04/12 20:24:44  paul
   init in .po switched off

   Revision 1.19  2000/04/10 21:42:17  paul
   field->&asdf := expr

   Revision 1.18  2000/04/07 14:37:24  paul
   EMPTY

   Revision 1.17  2000/03/30 16:25:14  paul
   PARAM

   Revision 1.16  2000/03/29 22:36:24  paul
   clip_trap_err

   Revision 1.15  2000/03/29 21:20:49  paul
   only first errblock

   Revision 1.14  2000/03/29 20:43:43  paul
   break loop

   Revision 1.13  2000/03/29 18:26:15  paul
   errorblock

   Revision 1.12  2000/03/24 18:10:11  paul
   trace

   Revision 1.11  2000/03/24 17:28:45  paul
   call tracing

   Revision 1.10  2000/03/21 21:30:25  paul
   uplocals in pcode

   Revision 1.9  2000/03/21 15:57:44  paul
   obj:el += val  for pcode fixed

   Revision 1.8  2000/03/21 14:53:28  paul
   macroassign; __FIELD__ with macroassign

   Revision 1.7  2000/03/20 18:59:48  paul
   __field__ directive

   Revision 1.6  2000/03/03 21:37:36  paul
   preprocessor bug fix, warnings removed

   Revision 1.5  2000/01/14 18:05:36  axl
   Some changes :) (don't remember)

   Revision 1.4  1999/10/28 21:10:01  paul
   runtime compiler: array access, obj calls

   Revision 1.3  1999/10/27 17:29:34  paul
   change param handling

   Revision 1.2  1999/10/26 19:11:23  paul
   start cvs logging

 */

#include "clipcfg.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#ifdef HAVE_MMAN_H
	#include <sys/mman.h>
#endif
#include <sys/types.h>
#include <errno.h>
#include <fcntl.h>
#ifdef OS_MINGW
	#include <ltdl.h>
	#define dlerror lt_dlerror
#else
	#include <dlfcn.h>
#endif
#include <ctype.h>

#include "clip.h"
#include "clipvm.h"
#include "hash.h"
#include "ar.h"
#include "coll.h"

#ifdef USE_TASKS
	#include "task/task.h"
#endif
#ifndef RTLD_NOW
	#define RTLD_NOW DL_LAZY
#endif


#define NEW(type) ((type*)calloc(sizeof(type),1))
#define NEWVECT(type,len) ((type*)calloc(sizeof(type),(len)))
#define VAR(type,var,ini) type *var=(type*)(ini)
#define NEWVAR(type,var) type *var=(type*)calloc(sizeof(type),1)
#define c_DELETE(type,var)	{destroy_##type(var);free(var);}
#define M_OFFS(base,nl,ns) ((base)+8+nl*sizeof(long)+ns*sizeof(short))
#define F_OFFS(fp,nl,ns,nb) ((fp)+(nl)*sizeof(long)+(ns)*sizeof(short)+(nb))

/*static void get_name(char *func, char **sp); */
static void get_str(char *modbeg, int no, char **sp, int *len);
static void get_num(char *modbeg, int no, double *sp, int *len, int *dec);
static void get_static(ClipMachine * mp, ClipFile * file, ClipVar * statics, char *modbeg, int no, ClipVar ** dest);
static void get_func(char *modbeg, int no, char **fp);
static int run_vm(ClipMachine * mp, ClipBlock * bp);
static void make_func(struct ClipFile *file, ClipCodeVar * dest, long *hash);
static char *get_proc_name(ClipCodeVar * dest);

/* [ load pcode */

#ifdef FORCEALIGN

static short
GETSHORT(void *p)
{
	short r;

	memcpy(&r, p, sizeof(r));
	return r;
}

static long
GETLONG(void *p)
{
	long r;

	memcpy(&r, p, sizeof(r));
	return r;
}

static void
SETLONG(void *ptr, long l)
{
	memcpy(ptr, &l, sizeof(l));
}

static void
SETINT(void *ptr, int l)
{
	memcpy(ptr, &l, sizeof(l));
}

static short get_short(void* ptr)
{
	short **pp = (short**)ptr;
        short r;

	memcpy(&r, pp, sizeof(r));
        (*pp)++;
        return r;
}

static long get_long(void* ptr)
{
	long **pp = (long**)ptr;
        long r;

	memcpy(&r, pp, sizeof(r));
        (*pp)++;
        return r;
}

static unsigned char get_byte(void* ptr)
{
	unsigned char **pp = (unsigned char**)ptr;
        return *(*pp)++;
}

#else

#define GETSHORT(p) (*(short*)(p))
#define GETLONG(p) (*(long*)(p))
#define SETLONG(ptr,l) (*(long*)(ptr)=(l))
#define SETINT(ptr,l) (*(int*)(ptr)=(l))

static short get_short(void* ptr)
{
	short **pp = (short**)ptr;
        return *(*pp)++;
}

static long get_long(void* ptr)
{
	long **pp = (long**)ptr;
        return *(*pp)++;
}

static unsigned char get_byte(void* ptr)
{
	unsigned char **pp = (unsigned char**)ptr;
        return *(*pp)++;
}

#endif

#define GET_SHORT(pp) get_short(&(pp))
#define GET_LONG(pp) get_long(&(pp))
#define GET_BYTE(pp) get_byte(&(pp))

static void
get_str(char *modbeg, int no, char **sp, int *len)
{
	short strOffs = GETSHORT(F_OFFS(modbeg, 4, 3, 0));
	char *bp = (modbeg + strOffs);

	bp += 2 * no * sizeof(long);

	SETINT(len, GET_LONG(bp));
	*sp = modbeg + GETLONG(bp);
}

static int
load_pobj(ClipMachine * mp, struct ClipFile *file, const char *name, int mallocMem)
{
	struct stat st;
	int fd;
	long len;
	char *sp, *end, *modbeg;

	memset(file, 0, sizeof(*file));

	if (stat(name, &st) != 0)
	{
		_clip_trap_printf(mp, __FILE__, __LINE__, "cannot stat file '%s': %s", name, strerror(errno));
		return _clip_call_errblock(mp, 1);
	}

	if (!S_ISREG(st.st_mode))
	{
		_clip_trap_printf(mp, __FILE__, __LINE__, "is not regular file '%s'", name);
		return _clip_call_errblock(mp, 1);
	}

	len = st.st_size;
	if (len < 38)
	{
		_clip_trap_printf(mp, __FILE__, __LINE__, "is not pobj file '%s'", name);
		return _clip_call_errblock(mp, 1);
	}

	fd = open(name, O_RDONLY);
	if (fd < 0)
	{
		_clip_trap_printf(mp, __FILE__, __LINE__, "open file '%s' error: %s", name, strerror(errno));
		return _clip_call_errblock(mp, 1);
	}

	file->bodyMem = mallocMem;
	file->bodySize = len;
#ifdef HAVE_MMAN_H
	if (file->bodyMem == 0)
	{
		file->body = mmap(NULL, len, PROT_READ, MAP_SHARED, fd, 0);
#ifndef OS_CYGWIN
		close(fd);
		fd = -1;
#endif
		file->fd = fd;
		if (file->body == (char *) -1)
		{
			_clip_trap_printf(mp, __FILE__, __LINE__, "mmap file '%s' error: %s", name, strerror(errno));
			return _clip_call_errblock(mp, -1);
		}
	}
	else
#endif
	{
		char *s;
		int readed, r;

		file->bodyMem = 1;
		file->body = (char *) malloc(len);
		for (s = file->body, readed = 0; readed < len; readed += r, s += r)
		{
			int portion = 4096;

			if ((len - readed) < portion)
				portion = len - readed;
			r = read(fd, s, portion);
			if (r < portion)
			{
				close(fd);
				free(file->body);
				_clip_trap_printf(mp, __FILE__, __LINE__, "read file '%s' error: %s", name, strerror(errno));
				return _clip_call_errblock(mp, -1);
			}
			close(fd);
			file->fd = -1;
		}

	}

	sp = file->mem = file->body;
	end = sp + len;

	if (sp[0] == '#' && sp[1] == '!')
	{
		for (sp += 2; sp < end; sp++)
			if (*sp == '\n')
			{
				sp++;
				break;
			}
	}

	file->body = sp;

	if (memcmp(sp, "!<pobj>\n", 8))
	{
		_clip_trap_printf(mp, __FILE__, __LINE__, " '%s' is not valid pobj file: invalid magic", name);
		destroy_ClipFile(mp, file);
		return _clip_call_errblock(mp, 1);
	}

	sp += 8;
	sp += sizeof(long);

	/*
	   if (GETLONG( sp != (len - 8 - 2 * sizeof(long))))
	   {
	   _clip_trap_printf(mp, __FILE__, __LINE__, " '%s' is not valid pobj file: invalid length", name);
	   destroy_ClipFile(mp, file);
	   return 1;
	   }
	 */
	sp += sizeof(long);

	modbeg = sp;
	sp += sizeof(long);

	file->nstatics = GETLONG(sp);

	file->statics = (ClipVar *) calloc(sizeof(ClipVar), file->nstatics + 1);
	file->staticsMem = 1;

	sp += sizeof(short) * 7 + sizeof(long) * 4;

	/*++sp; */
	file->name = strdup(sp);

	_clip_hash_buckets(mp, file);

	return 0;
}

void
_clip_hash_buckets(ClipMachine * mp, ClipFile * file)
{
	char *hp = 0;
	int len = 0;
	int count = 0;
	int i;
	int nstrings;
	int nstatics;
	ClipHashNames *hash_names;
	ClipHashBucket *buckets;
	char *modbeg;
	ClipVarDef *statics;

	if (file->hash_names)
		return;

	modbeg = file->body + 8 + 2 * sizeof(long);

	nstrings = GETSHORT(F_OFFS(modbeg, 2, 1, 0));
	get_str(modbeg, nstrings - 1, &hp, &len);

	count = GETLONG(F_OFFS(hp, 0, 0, 0));
	nstatics = GETLONG(F_OFFS(hp, 1, 0, 0));

	hash_names = NEW(ClipHashNames);
	if (count)
		buckets = (ClipHashBucket *) calloc(sizeof(ClipHashBucket), count);
	else
		buckets = 0;
	hash_names->num = count;
	hash_names->buckets = buckets;
	hash_names->mem = F_OFFS(hp, 2 + nstatics + 2 * count, 0, 0);

	for (i = 0; i < count; i++)
	{
		long hash, offs;

		hash = buckets[i].hash = GETLONG(F_OFFS(hp, 2 + nstatics + 2 * i, 0, 0));
		offs = buckets[i].offs = GETLONG(F_OFFS(hp, 2 + nstatics + 2 * i + 1, 0, 0));
		if (_clip_debuglevel)
		{
			char *str, *s;

			s = (char *) HashTable_fetch(mp->hashnames, hash);
			if (!s)
			{
				str = hash_names->mem + offs;
				s = strdup(str);
				HashTable_store(mp->hashnames, s, hash);
			}
		}
	}

	file->hash_names = hash_names;

	statics = file->staticDefs = (ClipVarDef *) calloc(sizeof(ClipVarDef), nstatics + 1);

	file->staticDefs[0].name = nstatics;
	for (i = 0; i < nstatics; i++)
	{
		statics[i + 1].name = GETLONG(F_OFFS(hp, 2 + i, 0, 0));
		statics[i + 1].vp = file->statics + i + 1;
	}
}

static Coll *loaded_dlls = 0;

static int
load_dll(ClipMachine * mp, const char *name, struct Coll *names, ClipVar * resp)
{
	void *hp;
	char buf[256], *s, *e;
	char uname[128];
	const char **spp;
	ClipModule *entry;
	ClipFunction **fpp;
	ClipNameEntry *np;
	ClipFile **cpp;
	struct DBFuncTable **dpp;
	int l, ret = 0, i;

	s = strrchr(name, '/');
	if (s)
		snprintf(buf, sizeof(buf), "%s", name);
	else
		snprintf(buf, sizeof(buf), "%s/lib/%s", CLIPROOT, name);

	if (!loaded_dlls)
	{
		loaded_dlls = new_Coll(free, strcmp);
	}
	else
	{
		if (search_Coll(loaded_dlls, buf, 0))
			return 0;
	}

#ifdef OS_MINGW
	hp = lt_dlopen(buf);
#else
	hp = dlopen(buf, RTLD_NOW);
#endif
	if (!hp)
	{
		_clip_trap_printf(mp, __FILE__, __LINE__, "shared loading problem: %s: file %s", dlerror(), buf);
		return _clip_call_errblock(mp, 1);
	}

	insert_Coll(loaded_dlls, strdup(buf));

/*
   path/name.ext -> name_module entry symbol
 */

	s = strrchr(name, '/');
	if (!s)
		s = (char *) name;
	else
		s = s + 1;
	e = strchr(s, '.');
	if (e)
		l = e - s;
	else
		l = strlen(s);
	if (l > sizeof(uname))
		l = sizeof(uname);

	for (i = 0; i < l; i++, s++)
	{
		if (*s == '-')
			uname[i] = '_';
		else
			uname[i] = toupper(*s);
	}
	uname[l] = 0;
	snprintf(buf, sizeof(buf), "clip__MODULE_%s", uname);

#ifdef OS_MINGW
	entry = (ClipModule *) lt_dlsym(hp, buf);
#else
	entry = (ClipModule *) dlsym(hp, buf);
#endif

	if (!entry)
	{
		_clip_trap_printf(mp, __FILE__, __LINE__, "shared '%s' fetch name '%s' problem: %s", name, buf, dlerror());
		return _clip_call_errblock(mp, 1);
	}

	for (np = entry->cfunctions; np && np->f; ++np)
		_clip_register_hash(mp, np->f, np->hash);

	for (fpp = entry->inits; fpp && *fpp; ++fpp)
		_clip_main_func(mp, *fpp, _clip_argc, _clip_argv, _clip_envp);

	for (fpp = entry->exits; fpp && *fpp; ++fpp)
	{
		mp->cexits = (ClipFunction **) realloc(mp->cexits, (mp->ncexits + 1) * sizeof(ClipFunction *));
		mp->cexits[mp->ncexits] = *fpp;
		++mp->ncexits;
	}

	for (spp = entry->pfunctions; spp && *spp; ++spp)
		if (_clip_load(mp, *spp, 0, 0))
			++ret;
/*
	if (entry->cpfile && _clip_register_file(mp, entry->cpfile))
		++ret;
*/
	for (cpp = entry->cpfiles; cpp && *cpp; ++cpp)
		if (_clip_register_file(mp, *cpp))
			++ret;

	for (dpp = entry->dbdrivers; dpp && *dpp; ++dpp)
		if (_clip_register_driver(mp, *dpp))
			++ret;

	add_ClipVect(&mp->dlls, hp);

	return ret;
}

CLIP_DLLEXPORT int
_clip_load_inits(ClipMachine * mp, ClipFile * file)
{
	long funcOffs = GETLONG(M_OFFS(file->body, 7, 4));
	char *modbeg = M_OFFS(file->body, 2, 0);
	int pubnum = GETLONG(M_OFFS(file->body, 4, 2));
	int initnum = GETSHORT(M_OFFS(file->body, 8, 4));
	int exitnum = GETSHORT(M_OFFS(file->body, 8, 5));
	ClipBlock b;
	ClipCodeVar c;
	int i;
	long hash;

	c.u.block = &b;

	file->pos = (long *) (modbeg + funcOffs);
	file->pos += 2 * pubnum;
	/*file->end = file->pos + 2 * num; */
	for (i = 0; i < initnum; ++i)
	{
		make_func(file, &c, &hash);
		file->pos += 2;
		_clip_main_code(mp, c.u.block, _clip_argc, _clip_argv, _clip_envp);
	}
	for (i = 0; i < exitnum; ++i)
	{
		make_func(file, &c, &hash);
		file->pos += 2;
		mp->exits = (ClipBlock *) realloc(mp->exits, (mp->nexits + 1) * sizeof(ClipBlock));
		mp->exits[mp->nexits] = *c.u.block;
		++file->refCount;
		++mp->nexits;
	}
	return 0;
}

CLIP_DLLEXPORT int
_clip_load(ClipMachine * mp, const char *name, struct Coll *names, ClipVar * resp)
{
	ClipFile *file = 0;
	int r = 0;
	ClipBlock b;
	ClipCodeVar c;
	long hash;
	char *e = strrchr(name, '.');
	char *s = strrchr(name, '/');

	c.u.block = &b;
	if (e && (!s || s < e))
	{
		if (!strcmp(e, ".po") || !strcmp(e, ".pa"))
		{
			file = NEW(ClipFile);
			r = load_pobj(mp, file, name, 0);
		}
		else if (!strcasecmp(e, DLLREALSUFF))
		{
			r = load_dll(mp, name, names, resp);
			return r;
		}
		else
		{
			_clip_trap_printf(mp, __FILE__, __LINE__, "unknown file type: '%s'", name);
			return _clip_call_errblock(mp, 1);
		}
	}
	else
	{
		char path[256];

		snprintf(path, sizeof(path), "%s.po", name);
		if (!access(path, R_OK))
		{
			file = NEW(ClipFile);
			r = load_pobj(mp, file, path, 0);
		}
		else
		{
			snprintf(path, sizeof(path), "%s.pa", name);
			if (!access(path, R_OK))
			{
				file = NEW(ClipFile);
				r = load_pobj(mp, file, path, 0);
			}
			else
			{
				snprintf(path, sizeof(path), "%s%s", name, DLLREALSUFF);
				if (!access(path, R_OK))
				{
					r = load_dll(mp, path, names, resp);
					return r;
				}
				else
				{
					_clip_trap_printf(mp, __FILE__, __LINE__, "cannot load file: '%s'", name);
					return _clip_call_errblock(mp, 1);
				}
			}
		}
	}

	if (r)
		return r;

	++file->refCount;

	for (r = _clip_first_File(file, &c, &hash); r; r = _clip_next_File(file, &c, &hash))
	{
		if (c.t.type == CCODE_t)
		{
			if (resp)
			{
				ClipVar *vp;

				vp = NEW(ClipVar);

				CLEAR_CLIPVAR(resp);
				resp->t.flags = F_MPTR;
				resp->t.type = CCODE_t;
				resp->p.vp = vp;

				vp->t.count = 1;
				vp->t.type = CCODE_t;
				vp->t.flags = F_NONE;
				vp->c.u.func = c.u.func;
				++file->refCount;
				break;
			}
			else
			{
				if (_clip_register_hash(mp, c.u.func, hash))
					++file->refCount;
			}
		}
		else if (c.t.type == PCODE_t)
		{
			if (resp)
			{
				ClipVar *vp;
				ClipBlock *bp;

				vp = NEW(ClipVar);
				bp = NEW(ClipBlock);

				CLEAR_CLIPVAR(resp);
				resp->t.flags = F_MPTR;
				resp->t.type = PCODE_t;
				resp->p.vp = vp;

				vp->t.count = 1;
				vp->t.type = PCODE_t;
				vp->t.flags = F_NONE;
				*bp = *c.u.block;
				vp->c.u.block = bp;
				++file->refCount;
				break;
			}
			else
			{
				if (_clip_register_block(mp, *c.u.block, hash))
				{
					char *name;

					if (names)
					{
						name = get_proc_name(&c);
						append_Coll(names, strdup(name));
					}

					++file->refCount;
				}
			}
		}
	}

	_clip_load_inits(mp, file);

	delete_ClipFile(mp, file);

	return 0;
}

void
delete_ClipFile(ClipMachine * mp, ClipFile * fp)
{
	if (destroy_ClipFile(mp, fp))
		free(fp);
}

int
destroy_ClipFile(ClipMachine * mp, ClipFile * fp)
{
	int i;

	if (!fp)
		return 0;
	--fp->refCount;
	if (fp->refCount > 0)
		return 0;

	switch (fp->bodyMem)
	{
#ifndef OS_MINGW
	case 0:
		munmap(fp->mem, fp->bodySize);
		break;
#endif
	case 1:
		free(fp->mem);
		break;
	}
	if (fp->fd >2 )
		close(fp->fd);

	for (i = 0; i < fp->nstatics; ++i)
		_clip_destroy(mp, fp->statics + i);

	switch (fp->staticsMem)
	{
#ifndef OS_MINGW
	case 0:
		munmap((void *) fp->statics, sizeof(ClipVar) * fp->nstatics);
		break;
#endif
	case 1:
		free(fp->statics);
		break;
	}

	free(fp->name);
	if (fp->hash_names)
	{
		free(fp->hash_names->buckets);
		/*free(fp->hash_names->mem); */
		free(fp->hash_names);
	}

	return 1;
}

static void
make_func(struct ClipFile *file, ClipCodeVar * dest, long *hash)
{
	char *modbeg = M_OFFS(file->body, 2, 0);

	dest->t.type = PCODE_t;
	dest->t.flags = F_NONE;
	dest->u.block->file = file;
	SETLONG(hash, GETLONG(file->pos + 0));
	dest->u.block->func = modbeg + GETLONG(file->pos + 1);
}

static char *
get_proc_name(ClipCodeVar * dest)
{
	int nprivates, nlocals, nreflocals, numlocals;
	char *procname, *func;

	if (dest->t.type != PCODE_t)
		return "";

	func = dest->u.block->func;
	nlocals = GETSHORT(F_OFFS(func, 3, 0, 1));
	nreflocals = GETSHORT(F_OFFS(func, 3, 1, 1));
	numlocals = nlocals + nreflocals;
	nprivates = GETSHORT(F_OFFS(func, 3, 3, 1));
	procname = F_OFFS(func, 3 + nprivates + numlocals, 5 + numlocals, 1 + 1);

	return procname;
}

int
_clip_first_File(struct ClipFile *file, ClipCodeVar * dest, long *hash)
{
	long funcOffs = GETLONG(M_OFFS(file->body, 7, 4));
	char *modbeg = M_OFFS(file->body, 2, 0);
	int pubnum = GETLONG(M_OFFS(file->body, 4, 2));

	/*int initnum = GETLONG( M_OFFS(file->body, 7, 5)); */
	/*int exitnum = GETLONG( M_OFFS(file->body, 7, 6)); */
	int num;

	num = pubnum;

	file->pos = (long *) (modbeg + funcOffs);
	file->end = file->pos + 2 * num;
	if (num == 0)
		return 0;
	make_func(file, dest, hash);
	file->pos += 2;

	return 1;
}

int
_clip_next_File(struct ClipFile *file, ClipCodeVar * dest, long *hash)
{
	if (file->pos == file->end)
		return 0;
	make_func(file, dest, hash);
	file->pos += 2;
	return 1;
}

/* ] load pcode */
/* [ ClipBlock */

void
_clip_init_Block(ClipMachine * mp, ClipBlock * dest, struct ClipFile *file, char *func)
{
	dest->file = file;
	dest->func = func;
	++file->refCount;
}

void
destroy_Block(ClipMachine * mp, ClipBlock * bp)
{
	delete_ClipFile(mp, bp->file);
}

void
_clip_dup_Block(ClipMachine * mp, ClipBlock * src, ClipBlock * dest)
{
	*dest = *src;
	++src->file->refCount;
}

#if 0
static void
get_name(char *func, char **sp)
{
	short npriv = GETSHORT(F_OFFS(func, 3, 2, 1));
	char *name = F_OFFS(func, 3, 3, 1) + npriv * sizeof(long) + 1;

	*sp = name;
}
#endif

static void
get_num(char *modbeg, int no, double *sp, int *len, int *dec)
{
	short numOffs = GETSHORT(F_OFFS(modbeg, 4, 2, 0));
	short numNum = GETSHORT(F_OFFS(modbeg, 2, 0, 0));
	double *bp = (double *) (modbeg + numOffs);
	unsigned char *lens = (unsigned char *) (bp + numNum);
	unsigned char *decs = lens + numNum;

	memcpy(sp, bp + no, sizeof(*sp));
	memcpy(len, lens + no, sizeof(*len));
	memcpy(dec, decs + no, sizeof(*dec));
}

static void
get_static(ClipMachine * mp, ClipFile * file, ClipVar * statics, char *modbeg, int no, ClipVar ** dest)
{
	if (!statics->t.count)
	{
		ClipBlock init;
		long initOffs = GETLONG(F_OFFS(modbeg, 4, 4, 0));

		statics->t.count = 1;
		init.file = file;
		init.func = modbeg + initOffs;
		_clip_code_func(mp, &init, 0, 0, 0);
	}
	*dest = statics + no + 1;
}

static void
get_func(char *modbeg, int no, char **fp)
{
	long funcOffs = GETLONG(F_OFFS(modbeg, 5, 4, 0));
	long *bp = (long *) (modbeg + funcOffs);

	bp += 2 * no;
	++bp;
	*fp = modbeg + GETLONG(bp);
}

/* ] ClipBlock */
/* [ run codeblock */

static int
do_code(ClipMachine * mp, struct ClipBlock *cp, int argc, int isProc, int rest, ClipVarFrame * uplocals)
{
	int ret, _argc = mp->argc;
	ClipFrame *fp = mp->fp;
	ClipVar *bp = mp->bp;
	ClipVarFrame *s_up = mp->fp->localvars;

	mp->argc = argc;
	mp->bp = fp->sp;
	mp->fp->localvars = uplocals;

	if (_clip_profiler)
	{
		_clip_stop_profiler(mp);
	}

	_clip_logg(6, "PCODE call from: proc '%s' file '%s' line %d", fp->procname ? fp->procname : "unknown", fp->filename, fp->line);
	for (;;)
	{
		int dnext = 0;

		if (_clip_debuglevel)
		{
			dnext = _clip_debugnext;
			_clip_debug(mp);
		}

#ifdef USE_TASKS
		Task_yield();
#endif
		ret = run_vm(mp, cp);

		if (_clip_sig_flag)
			_clip_signal_real(_clip_sig_flag);

		if (_clip_debuglevel)
		{
			if (!dnext && _clip_debugnext)
			{
				_clip_debugnext = 0;
			}
		}
		_clip_logg(4, "PCODE return=%d to: proc '%s' file '%s' line %d", ret, fp->procname ? fp->procname : "unknown", fp->filename, fp->line);

		if (!ret)
			break;

		if (!mp->trapVar)
			_clip_generr(mp, ret);

		if (ret < 0)
			break;

		if (!_clip_errorblock(mp, mp->trapVar, ret))
		{
			ret = -ret;
			break;
		}

		mp->argc = _argc;
		mp->fp = fp;
		mp->bp = bp;
		mp->fp->localvars = s_up;
	}

	mp->argc = _argc;
	mp->fp = fp;
	mp->bp = bp;
	mp->fp->localvars = s_up;

	if (isProc)
		++argc;
	for (; argc; --argc)
	{
		--(fp->sp);
		_clip_destroy(mp, fp->sp);
	}

	if (_clip_profiler)
	{
		_clip_start_profiler(mp);
		mp->pbucket->callno--;
	}

	return ret;
}

CLIP_DLLEXPORT int
_clip_code_func(ClipMachine * mp, struct ClipBlock *cp, int argc, int rest, ClipVarFrame * uplocals)
{
	return do_code(mp, cp, argc, 0, rest, uplocals);
}

CLIP_DLLEXPORT int
_clip_code_proc(struct ClipMachine *mp, struct ClipBlock *cp, int argc, int rest, ClipVarFrame * uplocals)
{
	return do_code(mp, cp, argc, 1, rest, uplocals);
}

static int
search_long(long *coll, int count, long key)
{
	int l, h, i;
	long c;

	l = 0;
	h = count - 1;
	while (l <= h)
	{
		i = (l + h) >> 1;
		if ((c = GETLONG(coll+i)) < key)
			l = i + 1;
		else
		{
			if (c == key)
				return i;
			h = i - 1;
		}
	}
	return -1;
}

static int
run_vm(ClipMachine * mp, ClipBlock * bp)
{
	char *func = bp->func;
	char *modbeg = func - GETLONG(func);
	char *pp = modbeg + GETLONG(F_OFFS(func, 1, 0, 0));
	char code;
	long len = GETLONG(F_OFFS(func, 2, 0, 0));
	char *beg = pp, *end = pp + len;
	long staticsOffs = GETLONG(modbeg);
	ClipFile *file = bp->file;
	ClipVar *statics = file->statics + staticsOffs;
	int nlocals = GETSHORT(F_OFFS(func, 3, 0, 1));
	int nreflocals = GETSHORT(F_OFFS(func, 3, 1, 1));
	int ret = 0;
	int i;
#if 0
	ClipVar *locals /* = (ClipVar *) alloca(sizeof(ClipVar) * nlocals) */ ;
#endif
	int maxdeep = GETSHORT(F_OFFS(func, 3, 2, 1));
#ifdef OS_MINGW
	ClipVar *stack = (ClipVar *) malloc(sizeof(ClipVar) * maxdeep);
#else
	ClipVar *stack = (ClipVar *) alloca(sizeof(ClipVar) * maxdeep);
#endif
	char *filename = F_OFFS(modbeg, 7, 4, 0);
	int nprivates = GETSHORT(F_OFFS(func, 3, 3, 1));

	/*int nparams = GETSHORT( F_OFFS(func, 3, 4, 1)); */
	/*long *privates = (long *) F_OFFS(func, 3, 5, 1); */
	/*long *localDefHashs = (long *) F_OFFS(func, 3 + nprivates, 5, 1); */
	int numlocals = nlocals + nreflocals;

	/*ClipVarDef *ldp, *localDefs = (ClipVarDef *) alloca(sizeof(ClipVarDef) * (numlocals+1)); */
	/*short *localDefNums = (short *) F_OFFS(func, 3 + nprivates + numlocals, 5, 1); */

	char *procname = F_OFFS(func, 3 + nprivates + numlocals, 5 + numlocals, 1 + 1);
	char *localnames = procname + *(unsigned char *) F_OFFS(func, 3 + nprivates + numlocals, 5 + numlocals, 1) + 1;

	/*ClipVar *params = (ClipVar *)alloca( nparams*sizeof(ClipVar)); */
	ClipFrame frame =
	{stack, stack, filename, 0, 0, 0, 0 /*localDefs */ , file->staticDefs, 0,
	 file->hash_names, procname, maxdeep, 0};
	unsigned char c, c1;
	short s, s1;
	long l, l1;
	ClipVar *vp;
	ClipBlock bl;
	char *trap_pp = 0;
	int debuglevel = _clip_debuglevel;
	ClipVarFrame *localvars = 0, *reflocals = 0;
	int local_locals = 0;

	if (!nlocals && !nreflocals)
	{
		reflocals = frame.localvars = mp->fp->localvars;
		if (reflocals && reflocals->refcount)
			reflocals->refcount++;
	}
	else if (nreflocals)
	{
		localvars = (ClipVarFrame *) calloc(1, sizeof(ClipVarFrame) + numlocals * sizeof(ClipVar));
		localvars->vars = (ClipVar *) (localvars + 1);
		localvars->refcount = 1;
		reflocals = frame.localvars = localvars;
		localvars->size = numlocals;
		localvars->names = localnames;
	}
	else
	{
#if 1
		localvars = (ClipVarFrame *) calloc(1, sizeof(ClipVarFrame) + numlocals * sizeof(ClipVar));
		localvars->vars = (ClipVar *) (localvars + 1);
		localvars->size = numlocals;
		localvars->refcount = 1;
		localvars->names = localnames;
		reflocals = frame.localvars = localvars;
#else
		locals = (ClipVar *) alloca(sizeof(ClipVar) * numlocals);
		memset(locals, 0, numlocals * sizeof(ClipVar));
		localvars = (ClipVarFrame *) alloca(sizeof(ClipVarFrame));
		localvars->vars = locals;
		localvars->size = numlocals;
		localvars->refcount = 0;
		localvars->names = localnames;
		reflocals = frame.localvars = localvars;
		local_locals = 1;
#endif
	}

	frame.up = mp->fp;
	mp->fp = &frame;

#if 0
	localDefs[0].name = numlocals;
	for (i = 0, ldp = localDefs + 1; i < numlocals; i++, ldp++, localDefHashs++, localDefNums++)
	{
		/*int no = *localDefNums; */
		long hash = *localDefHashs;

		ldp->name = hash;
		/*
		   if (no < 0)
		   ldp->vp = reflocals - no;
		   else
		 */
		/*ldp->vp = locals + no; */
		ldp->vp = 0;
	}
#endif

	if (_clip_profiler)
		_clip_start_profiler(mp);

	_clip_logg(4, "PCODE call: proc '%s' file '%s' line %d", frame.procname ? frame.procname : "unknown", frame.filename, frame.line);

      cont:
	while (pp >= beg && pp < end)
	{
		if (debuglevel)
			_clip_debug(mp);
		switch ((code = *pp++))
		{
		case CLIP_NOP:
			break;
		case CLIP_POP:
			_clip_pop(mp);
			break;
		case CLIP_LINE:
			frame.line = GET_SHORT(pp);
			if (debuglevel)
				_clip_line(mp);
			break;
		case CLIP_PUSH_NUM:
			{
				int len, dec;
				double d;

				s = GET_SHORT(pp);
				frame.sp->t.memo = 0;
				frame.sp->t.type = NUMERIC_t;
				frame.sp->t.flags = F_NONE;
				get_num(modbeg, s, &d, &len, &dec);
				frame.sp->t.len = len;
				frame.sp->t.dec = dec;
				frame.sp->n.d = d;
				frame.sp->t.memo = 0;
				++frame.sp;
			}
			break;
		case CLIP_PUSH_STR:
#if 0
			s = GET_SHORT(pp);
			frame.sp->t.type = CHARACTER_t;
			frame.sp->t.flags = F_MSTAT;
			frame.sp->t.memo = 0;
			get_str(modbeg, s, &(frame.sp->s.str.buf), &(frame.sp->s.str.len));
			/*
			if ( !(mp->flags1 & NOEXPAND_MACRO_FLAG) )
			{
			*/
				if (strchr(frame.sp->s.str.buf, '&'))
					_clip_expand_var(mp, frame.sp);
			/*}*/
			++frame.sp;
			break;
#endif
		case CLIP_PUSH_STRDUP:
			s = GET_SHORT(pp);
			frame.sp->t.type = CHARACTER_t;
			frame.sp->t.flags = F_NONE;
			frame.sp->t.memo = 0;
			{
				char *str = "";
				int len = 0;

				get_str(modbeg, s, &str, &len);
				frame.sp->s.str.buf = _clip_memdup(str, len);
				frame.sp->s.str.len = len;
			}
			/*
			if ( !(mp->flags1 & NOEXPAND_MACRO_FLAG) )
			{
			*/
				if (strchr(frame.sp->s.str.buf, '&'))
					_clip_expand_var(mp, frame.sp);
			/*}*/
			++frame.sp;
			break;
		case CLIP_PUSH_NIL:
			frame.sp->t.type = UNDEF_t;
			frame.sp->t.flags = F_NONE;
			++frame.sp;
			break;
		case CLIP_PUSH_TRUE:
			frame.sp->t.type = LOGICAL_t;
			frame.sp->t.flags = F_NONE;
			frame.sp->l.val = 1;
			++frame.sp;
			break;
		case CLIP_PUSH_FALSE:
			frame.sp->t.type = LOGICAL_t;
			frame.sp->t.flags = F_NONE;
			frame.sp->l.val = 0;
			++frame.sp;
			break;
		case CLIP_MEMVAR_PUBLIC:
			l = GET_LONG(pp);
			_clip_memvar_public(mp, l);
			break;
		case CLIP_MEMVAR_SPACE:
			l = GET_LONG(pp);
			l1 = GET_LONG(pp);
			_clip_memvar_space(mp, _clip_space(mp, l), l1, 1);
			break;
		case CLIP_MEMVAR_PRIVATE:
			l = GET_LONG(pp);
			_clip_memvar_private(mp, l);
			break;
		case CLIP_MEMVAR_PUBLIC_POP:
			l = _clip_pop_hash(mp);
			_clip_memvar_public(mp, l);
			break;
		case CLIP_MEMVAR_SPACE_POP:
			l = GET_LONG(pp);
			l1 = _clip_pop_hash(mp);
			_clip_memvar_space(mp, _clip_space(mp, l), l1, 1);
			break;
		case CLIP_MEMVAR_PRIVATE_POP:
			l = _clip_pop_hash(mp);
/*_clip_memvar_private(mp, l);*/
			_clip_add_private(mp, l);
			break;
		case CLIP_MEMVAR_PARAM:
			l = GET_LONG(pp);
			c = GET_BYTE(pp);
			_clip_memvar_param(mp, l, c);
			break;
		case CLIP_PUSH_PARAM:
			c = GET_BYTE(pp);
			s = GET_SHORT(pp);
			_clip_param(mp, c, s);
			break;
		case CLIP_PUSH_LOCAL:
			s = GET_SHORT(pp);
			if ((ret = _clip_push_local(mp, s)))
				goto _trap;
			break;
		case CLIP_PUSH_REF_LOCAL:
			s = GET_SHORT(pp);
#if 0
			frame.sp->p.vp = _clip_ref_local(mp, s);
#else
			{
				ClipVar *vp1 = _clip_ref_local(mp, s);
				frame.sp->p.vp = vp1;
			}
#endif
			break;
		case CLIP_PUSH_STATIC:
			s = GET_SHORT(pp);
			get_static(mp, file, statics, modbeg, s, &vp);
			if ((ret = _clip_push_static(mp, vp)))
				goto _trap;
			break;
		case CLIP_PUSH_REF_STATIC:
			s = GET_SHORT(pp);
			get_static(mp, file, statics, modbeg, s, &vp);
			frame.sp->p.vp = vp;
			break;
		case CLIP_PUSH_MEMVAR:
			l = GET_LONG(pp);
			if ((ret = _clip_memvar(mp, l)))
				goto _trap;
			break;
		case CLIP_PUSH_FMEMVAR:
			l = GET_LONG(pp);
			if ((ret = _clip_fmemvar(mp, l)))
				goto _trap;
			break;
		case CLIP_PUSH_MEMVARF:
			l = GET_LONG(pp);
			if ((ret = _clip_memvarf(mp, l)))
				goto _trap;
			break;
		case CLIP_REF_FMEMVAR:
			l = GET_LONG(pp);
			if ((ret = _clip_ref_fmemvar(mp, l)))
				goto _trap;
			break;
		case CLIP_PUSH_REF_MEMVAR:
			l = GET_LONG(pp);
#if 0
			frame.sp->p.vp = _clip_ref_memvar(mp, l);
#else
			{
				ClipVar *vp1 = _clip_ref_memvar(mp, l);
				frame.sp->p.vp = vp1;
			}
#endif
			break;
		case CLIP_PUSH_REF_MEMVAR_NOADD:
			l = GET_LONG(pp);
			{
				ClipVar *vp1 = _clip_ref_memvar_noadd(mp, l);
				frame.sp->p.vp = vp1;
			}
			break;
		case CLIP_PUSH_PUBLIC:
			l = GET_LONG(pp);
			if ((ret = _clip_public(mp, l)))
				goto _trap;
			break;
		case CLIP_PUSH_REF_PUBLIC:
			l = GET_LONG(pp);
#if 0
			frame.sp->p.vp = _clip_ref_public(mp, l);
#else
			{
				ClipVar *vp1 = _clip_ref_public(mp, l);
				frame.sp->p.vp = vp1;
			}
#endif
			break;
		case CLIP_REFMACRO:
			if ((ret = _clip_refmacro(mp)))
				goto _trap;
			break;
		case CLIP_MAKE_REF:
			c = GET_BYTE(pp);
			vp = frame.sp->p.vp;
			if ((ret = _clip_ref(mp, vp, c)))
				goto _trap;
			break;
		case CLIP_UNREF_ARR:
			_clip_unref_arr(mp);
			break;
		case CLIP_FIELD:
			l = GET_LONG(pp);
			l1 = GET_LONG(pp);
			if ((ret = _clip_field(mp, l, l1)))
				goto _trap;
			break;
		case CLIP_FIELD_POP:
			l = GET_LONG(pp);
			l1 = _clip_pop_hash(mp);
			if ((ret = _clip_field(mp, l, l1)))
				goto _trap;
			break;
		case CLIP_FIELD_POP_NAME:
			_clip_pop_fieldhash(mp, &l1, &l);
			if ((ret = _clip_field(mp, l, l1)))
				goto _trap;
			break;
		case CLIP_PUSH_AREA:
			l = GET_LONG(pp);
			if ((ret = _clip_push_area(mp, l)))
				goto _trap;
			break;
		case CLIP_PUSH_AREA_POP:
			l = _clip_pop_hash(mp);
			if ((ret = _clip_push_area(mp, l)))
				goto _trap;
			break;
		case CLIP_POP_AREA:
			if ((ret = _clip_pop_area(mp)))
				goto _trap;
			break;
		case CLIP_FUNC:
			c = GET_BYTE(pp);
			l = GET_LONG(pp);
			if ((ret = _clip_func_hash(mp, l, c, 0, reflocals)))
				goto _trap;
			break;
		case CLIP_FUNCR:
			c = GET_BYTE(pp);
			l = GET_LONG(pp);
			if ((ret = _clip_func_hash(mp, l, c, 1, reflocals)))
				goto _trap;
			break;
		case CLIP_PROC:
			c = GET_BYTE(pp);
			l = GET_LONG(pp);
			if ((ret = _clip_proc_hash(mp, l, c, 0, reflocals)))
				goto _trap;
			break;
		case CLIP_PROCR:
			c = GET_BYTE(pp);
			l = GET_LONG(pp);
			if ((ret = _clip_proc_hash(mp, l, c, 1, reflocals)))
				goto _trap;
			break;
		case CLIP_SFUNC:
			c = GET_BYTE(pp);
			s = GET_SHORT(pp);
			bl.file = file;
			get_func(modbeg, s, &bl.func);
			if ((ret = _clip_code_func(mp, &bl, c, 0, reflocals)))
				goto _trap;
			break;
		case CLIP_SFUNCR:
			c = GET_BYTE(pp);
			s = GET_SHORT(pp);
			bl.file = file;
			get_func(modbeg, s, &bl.func);
			if ((ret = _clip_code_func(mp, &bl, c, 1, reflocals)))
				goto _trap;
			break;
		case CLIP_SPROC:
			c = GET_BYTE(pp);
			s = GET_SHORT(pp);
			bl.file = file;
			get_func(modbeg, s, &bl.func);
			if ((ret = _clip_code_proc(mp, &bl, c, 0, reflocals)))
				goto _trap;
			break;
		case CLIP_SPROCR:
			c = GET_BYTE(pp);
			s = GET_SHORT(pp);
			bl.file = file;
			get_func(modbeg, s, &bl.func);
			if ((ret = _clip_code_proc(mp, &bl, c, 1, reflocals)))
				goto _trap;
			break;
		case CLIP_ASSIGN:
			vp = frame.sp->p.vp;
			if ((ret = _clip_assign(mp, vp)))
				goto _trap;
			break;
		case CLIP_REF_DESTROY:
			vp = frame.sp->p.vp;
			/*if (vp->t.flags != F_MREF)*/
				_clip_destroy(mp, vp);
			/*_clip_destroy(mp, vp);*/
			break;
		case CLIP_MACROASSIGN:
			c = GET_BYTE(pp);
			c1 = GET_BYTE(pp);
			if ((ret = _clip_macroassign(mp, c, c1 & 1, c1 & 2)))
				goto _trap;
			break;
		case CLIP_REFASSIGN:
			c = GET_BYTE(pp);
			vp = frame.sp->p.vp;
			if ((ret = _clip_refassign(mp, vp, c)))
				goto _trap;
			break;
		case CLIP_UNREF:
			vp = frame.sp->p.vp;
			_clip_destroy(mp, vp);
			break;
		case CLIP_IASSIGN:
			vp = frame.sp->p.vp;
			if ((ret = _clip_iassign(mp, vp)))
				goto _trap;
			break;
		case CLIP_OPASSIGN:
			c = GET_BYTE(pp);
			vp = frame.sp->p.vp;
			if ((ret = _clip_opassign(mp, vp, c)))
				goto _trap;
			break;
		case CLIP_OPIASSIGN:
			c = GET_BYTE(pp);
			vp = frame.sp->p.vp;
			if ((ret = _clip_opiassign(mp, vp, c)))
				goto _trap;
			break;
		case CLIP_ASSIGN_FIELD:
			l = GET_LONG(pp);
			l1 = GET_LONG(pp);
			if ((ret = _clip_assign_field(mp, l, l1)))
				goto _trap;
			break;
		case CLIP_IASSIGN_FIELD:
			l = GET_LONG(pp);
			l1 = GET_LONG(pp);
			if ((ret = _clip_iassign_field(mp, l, l1)))
				goto _trap;
			break;
		case CLIP_ASSIGN_FIELD_POP:
			l = GET_LONG(pp);
			l1 = _clip_pop_hash(mp);
			if ((ret = _clip_assign_field(mp, l, l1)))
				goto _trap;
			break;
		case CLIP_IASSIGN_FIELD_POP:
			l = GET_LONG(pp);
			l1 = _clip_pop_hash(mp);
			if ((ret = _clip_iassign_field(mp, l, l1)))
				goto _trap;
			break;
		case CLIP_ASSIGN_PFIELD:
			l = _clip_pop_hash(mp);
			l1 = GET_LONG(pp);
			if ((ret = _clip_assign_field(mp, l, l1)))
				goto _trap;
			break;
		case CLIP_IASSIGN_PFIELD:
			l = _clip_pop_hash(mp);
			l1 = GET_LONG(pp);
			if ((ret = _clip_iassign_field(mp, l, l1)))
				goto _trap;
			break;
		case CLIP_ASSIGN_PFIELD_POP:
			l = _clip_pop_hash(mp);
			l1 = _clip_pop_hash(mp);
			if ((ret = _clip_assign_field(mp, l, l1)))
				goto _trap;
			break;
		case CLIP_IASSIGN_PFIELD_POP:
			l = _clip_pop_hash(mp);
			l1 = _clip_pop_hash(mp);
			if ((ret = _clip_iassign_field(mp, l, l1)))
				goto _trap;
			break;
		case CLIP_FM_ASSIGN:
			l = GET_LONG(pp);
			if ((ret = _clip_fm_assign(mp, l)))
				goto _trap;
			break;
		case CLIP_FM_IASSIGN:
			l = GET_LONG(pp);
			if ((ret = _clip_fm_iassign(mp, l)))
				goto _trap;
			break;
		case CLIP_ARRAY:
			l = GET_LONG(pp);
			_clip_sarray(mp, l);
			break;
		case CLIP_DIMARRAY:
			l = GET_LONG(pp);
			_clip_dimarray(mp, l);
			break;
		case CLIP_NEWARRAY:
			l = GET_LONG(pp);
			_clip_vnewarray(mp, l, (long *) pp);
			pp += l * sizeof(long);

			break;
		case CLIP_GET:
			l = GET_LONG(pp);
			if ((ret = _clip_get(mp, l)))
				goto _trap;
			break;
		case CLIP_SET:
			l = GET_LONG(pp);
			if ((ret = _clip_set(mp, l)))
				goto _trap;
			break;
		case CLIP_RETURN_POP:
			_clip_return(mp);
		case CLIP_RETURN:
			goto _return;
		case CLIP_STORE:
			c1 = GET_BYTE(pp);
			c = GET_BYTE(pp);
			if ((ret = _clip_store(mp, c, c1)))
				goto _trap;
			break;
		case CLIP_ISTORE:
			c1 = GET_BYTE(pp);
			c = GET_BYTE(pp);
			if ((ret = _clip_istore(mp, c, c1)))
				goto _trap;
			break;
		case CLIP_OPSTORE:
			c = GET_BYTE(pp);
			c1 = GET_BYTE(pp);
			if ((ret = _clip_opstore(mp, c1, c)))
				goto _trap;
			break;
		case CLIP_OPISTORE:
			c = GET_BYTE(pp);
			c1 = GET_BYTE(pp);
			if ((ret = _clip_opistore(mp, c1, c)))
				goto _trap;
			break;
		case CLIP_FETCH:
			c = GET_BYTE(pp);
			if ((ret = _clip_fetch(mp, c)))
				goto _trap;
			break;
		case CLIP_FETCHREF:
			c = GET_BYTE(pp);
#if 0
			frame.sp->p.vp = _clip_fetchref(mp, c);
#else
			{
				ClipVar *vp1 = _clip_fetchref(mp, c);
				/*printf("%p\n", vp1);*/
				frame.sp->p.vp = vp1;
			}
#endif
			if (!frame.sp->p.vp)
				goto _trap;
			break;
		case CLIP_IFETCH:
			c = GET_BYTE(pp);
			if ((ret = _clip_ifetch(mp, c)))
				goto _trap;
			break;
		case CLIP_CALL:
			c = GET_BYTE(pp);
			l = GET_LONG(pp);
			if ((ret = _clip_call(mp, c, l)))
				goto _trap;
			break;
		case CLIP_PUSH_CODE:
			s = GET_SHORT(pp);
			c = GET_BYTE(pp);
			c1 = GET_BYTE(pp);

			vp = NEW(ClipVar);
			vp->t.type = PCODE_t;
			vp->t.flags = F_NONE;
			vp->t.count = 1;
			vp->c.u.block = NEW(ClipBlock);

			get_func(modbeg, s, &(vp->c.u.block->func));
			vp->c.u.block->file = file;

			if (c)
			{
				int nlocals = c;
				ClipVarFrame *localvars = (ClipVarFrame *) calloc(1, sizeof(ClipVarFrame) + nlocals * sizeof(ClipVar));

				localvars->vars = (ClipVar *) (localvars + 1);
				memcpy(localvars->vars, mp->fp->sp - nlocals, nlocals * sizeof(ClipVar));
				localvars->refcount = 1;
				localvars->size = nlocals;
				vp->c.uplocals = localvars;
				mp->fp->sp -= nlocals;
			}
			else if (!c1 && reflocals && reflocals->refcount)
			{
				reflocals->refcount++;
				vp->c.uplocals = reflocals;
			}
			else
				vp->c.uplocals = 0;

			file->refCount++;

			CLEAR_CLIPVAR(frame.sp);
			frame.sp->t.type = PCODE_t;
			frame.sp->t.flags = F_MPTR;
			frame.sp->p.vp = vp;

			frame.sp++;
			CLIP_CHECK_STACK;

			break;
		case CLIP_MACRO:
			if ((ret = _clip_macro(mp)))
				goto _trap;
			break;
		case CLIP_PCOUNT:
			_clip_pcount(mp);
			break;
		case CLIP_PSHIFT:
			_clip_pshift(mp);
			break;
		case CLIP_PARN:
			if ((ret = _clip_parn(mp)))
				goto _trap;
			break;
		case CLIP_FUNC_NAME:
			c = GET_BYTE(pp);
			if ((ret = _clip_func_name(mp, c)))
				goto _trap;
			break;
		case CLIP_INCR:
			vp = frame.sp->p.vp;
			if ((ret = _clip_incr(mp, vp, 1, 0)))
				goto _trap;
			break;
		case CLIP_INCR_POST:
			vp = frame.sp->p.vp;
			if ((ret = _clip_incr(mp, vp, 1, 1)))
				goto _trap;
			break;
		case CLIP_DECR:
			vp = frame.sp->p.vp;
			if ((ret = _clip_incr(mp, vp, 0, 0)))
				goto _trap;
			break;
		case CLIP_DECR_POST:
			vp = frame.sp->p.vp;
			if ((ret = _clip_incr(mp, vp, 0, 1)))
				goto _trap;
			break;
		case CLIP_OP:
			c = GET_BYTE(pp);
			if ((ret = _clip_op(mp, c)))
				goto _trap;
			break;
		case CLIP_NOT:
			if ((ret = _clip_not(mp)))
				goto _trap;
			break;
		case CLIP_COND:
			s = GET_SHORT(pp);
			if ((ret = _clip_cond(mp, &i)))
				goto _trap;
			if (!i)
				pp += s;
			break;
		case CLIP_TCOND:
			s = GET_SHORT(pp);
			if ((ret = _clip_tcond(mp, &i)))
				goto _trap;
			if (!i)
				pp += s;
			break;
		case CLIP_ITCOND:
			s = GET_SHORT(pp);
			if ((ret = _clip_tcond(mp, &i)))
				goto _trap;
			if (i)
				pp += s;
			break;
		case CLIP_GOTO:
			s = GET_SHORT(pp);
			pp += s;
			break;
		case CLIP_FORSTEP:
			s = GET_SHORT(pp);
			if ((ret = _clip_forstep(mp, &i)))
				goto _trap;
			if (!i)
				pp += s;
			break;
		case CLIP_MAP_FIRST:
			c = GET_BYTE(pp);
			s = GET_SHORT(pp);
			if ((ret = _clip_map_first(mp, c, &i)))
				goto _trap;
			if (!i)
				pp += s;
			break;
		case CLIP_MAP_NEXT:
			c = GET_BYTE(pp);
			s = GET_SHORT(pp);
			if ((ret = _clip_map_next(mp, c, &i)))
				goto _trap;
			if (!i)
				pp += s;
			break;
		case CLIP_MINUS:
			if ((ret = _clip_minus(mp)))
				goto _trap;
			break;
		case CLIP_RESETTRAP:
			trap_pp = 0;
			break;
		case CLIP_SETTRAP:
			s = GET_SHORT(pp);
			trap_pp = pp + s;
			break;
		case CLIP_RECOVER:
			while (frame.sp > frame.stack)
				_clip_destroy(mp, --frame.sp);
			ret = 0;
			break;
		case CLIP_USING:
			if (mp->trapVar)
			{
				vp = frame.sp->p.vp;
				*frame.sp = *mp->trapVar;
				++frame.sp;
				free(mp->trapVar);
				mp->trapVar = 0;
				if ((ret = _clip_assign(mp, vp)))
					goto _trap;
			}
			break;
		case CLIP_BREAK:
#if 0
			/*_clip_trap_str(mp, filename, frame.line, "BREAK");*/
#else
			vp = NEW(ClipVar);
			_clip_trap_var(mp, filename, frame.line, vp);
#endif
			ret = -1;
			goto _trap;
		case CLIP_BREAK_EXPR:
			vp = NEW(ClipVar);
			--frame.sp;
			*vp = *frame.sp;
			_clip_trap_var(mp, filename, frame.line, vp);
			ret = -1;
			goto _trap;
		case CLIP_SWAP:
			c = GET_BYTE(pp);
			_clip_swap(mp, c);
			break;
		case CLIP_PUSH_HASH:
			l = GET_LONG(pp);
			frame.sp->t.memo = 0;
			frame.sp->t.type = NUMERIC_t;
			frame.sp->t.flags = F_NONE;
			frame.sp->t.len = 10;
			frame.sp->t.dec = 0;
			frame.sp->n.d = l;
			frame.sp++;
			CLIP_CHECK_STACK;
			break;
		case CLIP_CALC_HASH:
			_clip_calc_hash(mp);
			break;
		case CLIP_CALC_HASH2:
			_clip_calc_hash2(mp, 1);
			break;
		case CLIP_PUSH_LOCALE:
			_clip_push_locale(mp);
			break;
		case CLIP_RDDFIELD:
			s = GET_SHORT(pp);
			s1 = GET_SHORT(pp);
			_clip_rddfield(mp, s, s1);
			break;
		case CLIP_CATSTR:
			s = GET_SHORT(pp);
			_clip_catstr(mp, s);
			break;
		case CLIP_QUOT:
			_clip_quot(mp);
			break;
		case CLIP_SWITCH:
			s = GET_SHORT(pp);	/* label num */
			l = _clip_pop_shash(mp);	/* hash */
			{
				short other = GET_SHORT(pp);
				long *lp = (long *) pp;
				short *jmps = (short *) (pp + s * sizeof(long));
				int n = search_long(lp, s, l);

				if (n < 0)
					pp += other;
				else
					pp += GETSHORT(jmps+n);
			}
			break;
		default:
			_clip_trap_printf(mp, filename, frame.line, "invalid bytecode %d", code);
			_clip_call_errblock(mp, 1);
			ret = 1;
			goto _trap;
		}
	}
	goto _return;
      _trap:
	if (trap_pp /*&& ret > 0 */ )
	{
		pp = trap_pp;
		goto cont;
	}
	_clip_trap(mp, filename, frame.line);
	/*ret = 1; */
      _return:
	if (_clip_profiler)
		_clip_stop_profiler(mp);
	if (local_locals)
		_clip_destroy_locals(mp);
	_clip_resume(mp, nlocals, nreflocals);
#if 0
	_clip_vresume(mp, nlocals, locals);
#endif
#if 0
	_clip_vresume(mp, nparams, params);
#endif
#if 0
	if (nreflocals)
		_clip_vresume(mp, nreflocals, reflocals);
#endif
/*_clip_vremove_privates(mp, nprivates, privates);*/

#ifdef OS_MINGW
	free(stack);
#endif
	return ret;
}

/* ] run codeblock */
