/*
   Copyright (C) 2001  ITK
   Author   : Paul Lasarev <paul@itk.ru>
   License : (GPL) http://www.itk.ru/clipper/license.html
 */
/*
   $Log: clipdbg.c,v $
   Revision 1.50  2004/05/26 09:52:23  clip
   rust: some cleanings

   Revision 1.49  2004/05/21 11:22:18  clip
   rust: minor fix for 'configure -m'

   Revision 1.48  2003/11/11 11:36:58  clip
   uri: call errorblock with EG_SIGNAL if signal from system sended

   Revision 1.47  2003/11/04 11:18:34  clip
   post signal handler
   paul

   Revision 1.46  2003/09/02 14:27:42  clip
   changes for MINGW from
   Mauricio Abre <maurifull@datafull.com>
   paul

   Revision 1.45  2002/11/26 14:31:47  clip
   rust: added parameter 'method' to _clip_var2str() and _clip_str2var()

   Revision 1.44  2002/09/11 12:29:00  clip
   build fixes
   paul

   Revision 1.43  2002/01/16 15:29:08  clip
   chinese patch
   preproc bugs
   some pseudographic chars < 32
   paul

   Revision 1.42  2001/12/26 12:12:17  clip
   share container for ClipMachine's
   paul

   Revision 1.41  2001/11/02 08:21:53  clip
   dbg again work
   paul

   Revision 1.40  2001/10/29 06:51:21  clip
   fix text fopen modes
   paul

   Revision 1.39  2001/10/15 07:25:19  clip
   solaris fix

   Revision 1.38  2001/09/12 10:13:12  clip
   export some funcs
   paul

   Revision 1.37  2001/08/28 06:18:34  clip
   -s configure flag
   uninitalized var warnings with optimesed compile
   paul

   Revision 1.36  2001/08/25 12:52:12  clip
   localnames in debugger again work
   paul

   Revision 1.35  2001/04/17 10:45:25  clip
   ; in expr command
   paul

   Revision 1.34  2001/04/16 09:42:12  clip
   print_var delimiter now is ';' instead ':'
   paul

   Revision 1.33  2001/04/16 09:21:10  clip
   ::name in dbg
   paul

   Revision 1.32  2001/04/03 09:17:00  clip
   license errors
   paul

   Revision 1.31  2001/03/30 11:51:03  clip
   add copyright

   Revision 1.30  2001/03/26 10:57:38  clip
   1usec delay after kill()
   paul

   Revision 1.29  2001/03/26 09:47:47  clip
   continue
   paul

   Revision 1.28  2001/03/22 07:22:27  clip
   watch command
   paul

   Revision 1.27  2001/03/20 14:58:57  clip
   until exact to given line
   paul

   Revision 1.26  2001/03/20 14:30:32  clip
   until file:line
   paul

   Revision 1.25  2001/03/20 12:20:41  clip
   rm breakpoint command
   paul

   Revision 1.24  2001/03/19 08:14:26  clip
   -binary flag in expr_command
   CODE type in var2str/str2var
   paul

   Revision 1.23  2001/03/16 09:42:16  clip
   next/step cleanups
   paul

   Revision 1.22  2001/03/16 08:56:10  clip
   next command clenup
   paul

   Revision 1.21  2001/03/15 09:53:50  clip
   signal/write sequences
   paul

   Revision 1.20  2001/03/13 10:59:18  clip
   next/step/until commands now do'nt print ending '.' -> frontend
   will wait up to event
   paul

   Revision 1.19  2001/03/12 13:49:08  clip
   warning fix
   paul

   Revision 1.18  2001/03/12 13:47:18  clip
   VAR2STR, STR2VAR funcs
   paul

   Revision 1.17  2001/03/05 10:01:43  clip
   append step command
   append option command
   paul

   Revision 1.16  2001/02/26 12:02:57  clip
   repeated breakpoints
   paul

   Revision 1.15  2001/02/22 13:43:23  clip
   fix
   paul

   Revision 1.14  2001/02/22 11:37:38  clip
   start data_command
   paul

   Revision 1.13  2001/02/22 09:53:36  clip
   dbg: expr command
   paul

   Revision 1.12  2001/02/22 08:29:31  clip
   add next and until commands
   paul

   Revision 1.11  2001/02/21 12:52:59  clip
   append HASHNAME(hash) - inverce to HASHSTR(str)

   append obj:modify() trigger:
   modify(obj,hash,newval) -> real new val
   MAPMODIFY(obj, enable) switch modify processing

   paul

   Revision 1.10  2001/02/20 07:38:23  clip
   calls like
   s:substr(2,3)
   are now equivalent to
   substr(s,2,3)
   paul

   Revision 1.9  2001/02/19 13:18:37  clip
   hidden option runtime recognition, currently
   one option: --debug[=debuglevel] - to enable runtime debug connection
   paul

   Revision 1.8  2001/02/16 12:48:50  clip
   breakpoints
   paul

   Revision 1.7  2001/02/13 13:33:57  clip
   dbg bpoints
   paul

   Revision 1.6  2001/02/08 14:08:28  clip
   Readline usage imrpoved
   paul

   Revision 1.5  2001/02/08 07:44:44  clip
   readline usage in clip_dbg
   paul

   Revision 1.4  2001/02/08 06:35:54  clip
   static defs in .po
   paul

   Revision 1.3  2001/02/07 11:47:15  clip
   localdefs
   paul

   Revision 1.2  2001/02/06 13:07:25  clip
   hash in .po, dbg
   paul

   Revision 1.1  2001/02/01 13:05:06  clip
   debug links
   paul

 */

/*
   TODO:
   +step without entrance in funcs
   +switch to turn off debugging in codeblocks
   +ClipVar serialisation

   delete breakpoint
   db workplace info
   ClipMachine flags info
 */

#include "clipcfg.h"
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <stdio.h>
#include <signal.h>
#include <ctype.h>
#include <math.h>
#include <time.h>
#ifdef OS_MINGW
#include <ltdl.h>
#else
#include <dlfcn.h>
#endif
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <ctype.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>

#include "clip.h"
#include "clipvm.h"
#include "hash.h"
#include "screen/screen.h"
#include "error.ch"
#include "hashcode.h"
#include "rational.h"
#include "screen/charset.h"
#include "coll.h"
#include "rdd.h"

int _clip_debugnext = 0;

typedef int DbgCommand(ClipMachine * mp, int argc, char **argv);
typedef struct
{
	char *name;
	DbgCommand *dcp;
	char *help;
}
DbgCommandBucket;

static void delete_ClipBreakPoint(void *bp);
static int compare_ClipBreakPoint(void *p1, void *p2);
static ClipBreakPoint cur_bp =
{0, 0, 0};
ClipBreakPoint *_clip_breakpoint = 0;

static Coll breakpoints =
{0, 0, 0, 0, 0, 0};
static Coll sbreakpoints =
{0, 0, 0, 0, 0, 0};

static Coll watchs =
{0, 0, 0, 0, 0, 0};
static Coll swatchs =
{0, 0, 0, 0, 0, 0};

static void print_dbg(ClipMachine * mp, ClipVar * vp, int binary);
static DbgCommandBucket dbg_buckets[];
static int debug_flag = 0;	/* will be setted by _clip_sigdebug,

				   that means - there is data on debugger input socket
				 */
static int debugging = 0;
static int in_breakpoint = 0;
static ClipBreakPoint *prev_bp = 0;
FILE *_clip_dbg_in = 0;
static int dbg_in_fd = -1;
FILE *_clip_dbg_out = 0;
static Coll *dbg_commands = 0;
static int cur_frame = 0;
static ClipFrame *get_frame(ClipMachine * mp);
int _clip_process_dbg(ClipMachine * mp, char *cmd);
static int in_sigdebug = 0;
static int next_line = 0;
static char *next_file = 0, *next_proc = 0;
static int until_line = 0;
static char *until_file = 0;
static int bp_in_codeblock = 0;

static const char *nullstr(const char *str);

void
_clip_sigdebug(int sig)
{
	sigset_t oldset, newset;

#ifndef OS_MINGW
	sigemptyset(&newset);
	sigaddset(&newset, SIGUSR1);
	sigprocmask(SIG_BLOCK, &newset, &oldset);
#endif

	_clip_logg(0, "got debug signal %d", sig);
	in_sigdebug = 1;
	if (!_clip_dbg_in)
	{
		char path[256];

		snprintf(path, sizeof(path), "/tmp/clip_dbg.%lu.in", (unsigned long) getpid());
		_clip_dbg_in = fopen(path, "rt");
		if (!_clip_dbg_in)
		{
			_clip_logg(0, "debug: cannot open debug input '%s': %s", path, strerror(errno));
		}
		else
		{
			setvbuf(_clip_dbg_in, 0, _IOLBF, 0);
			/*fcntl(fileno(_clip_dbg_in), F_SETFL, O_NONBLOCK); */
			dbg_in_fd = fileno(_clip_dbg_in);
		}
	}
	if (!_clip_dbg_out)
	{
		char path[256];

		snprintf(path, sizeof(path), "/tmp/clip_dbg.%lu.out", (unsigned long) getpid());
		_clip_dbg_out = fopen(path, "wt");
		if (!_clip_dbg_out)
		{
			_clip_logg(0, "debug: cannot open debug output '%s': %s", path, strerror(errno));
		}
		else
		{
			setvbuf(_clip_dbg_out, 0, _IOFBF, 0);
		}
	}

	if (!breakpoints._free)
	{
		init_Coll(&breakpoints, delete_ClipBreakPoint, 0);
		init_Coll(&sbreakpoints, 0, compare_ClipBreakPoint);
		init_Coll(&watchs, free, 0);
		init_Coll(&swatchs, 0, strcasecmp);
	}

	if (_clip_dbg_in && _clip_dbg_out)
	{
		debug_flag = 1;
		debugging = 1;
		_clip_debug(cur_ClipMachine());
	}
	in_sigdebug = 0;

#ifndef OS_MINGW
	sigprocmask(SIG_SETMASK, &oldset, 0);
#endif
}

void
_clip_sigint(int sig)
{
	ClipMachine *mp;

	if (!debugging)
	{
		_clip_signal(sig);
		return;
	}

	mp = cur_ClipMachine();

	fprintf(_clip_dbg_out, "\nsigint: file %s line %d proc %s", nullstr(mp->fp->filename), mp->fp->line, nullstr(mp->fp->procname));
	fprintf(_clip_dbg_out, "\n.\n");
	fflush(_clip_dbg_out);
	_clip_logg(1, "sigint: file %s line %d proc %s", nullstr(mp->fp->filename), mp->fp->line, nullstr(mp->fp->procname));
	_clip_in_breakpoint();
}


void
_clip_sigint_real(int sig)
{
	ClipMachine *mp;

	if (!debugging)
	{
		_clip_sig_flag = sig;
		_clip_signal_real(sig);
		return;
	}

	mp = cur_ClipMachine();

	fprintf(_clip_dbg_out, "\nsigint: file %s line %d proc %s", nullstr(mp->fp->filename), mp->fp->line, nullstr(mp->fp->procname));
	fprintf(_clip_dbg_out, "\n.\n");
	fflush(_clip_dbg_out);
	_clip_logg(1, "sigint: file %s line %d proc %s", nullstr(mp->fp->filename), mp->fp->line, nullstr(mp->fp->procname));
	_clip_in_breakpoint();
}

CLIP_DLLEXPORT int
_clip_line(ClipMachine * mp)
{
	if (!_clip_debuglevel)
		return 0;
	_clip_debug(mp);
	return 0;
}

void
_clip_in_breakpoint(void)
{
	for (in_breakpoint = 1; in_breakpoint;)
		usleep(100000);
}

int
_clip_debug(ClipMachine * mp)
{
	if (!_clip_debuglevel)
		return 0;

	if (!debugging)
		return 0;

	if (in_sigdebug && debug_flag && _clip_dbg_in)
	{
		char buf[1024];
		int l;

		/* read command from _clip_dbg_in */
		if (!dbg_commands)
			dbg_commands = new_Coll(free, 0);
		fgets(buf, sizeof(buf), _clip_dbg_in);
		l = strlen(buf);

		if (l == 1 && buf[0] == '\n')
			buf[0] = '?';
		else if (l > 0 && buf[l - 1] == '\n')
			buf[l - 1] = 0;

		append_Coll(dbg_commands, strdup(buf));

		_clip_logg(4, "dbg read cmd: %s", buf);

		debug_flag = 0;
	}

	if (!dbg_commands)
		return 0;

	/* process commands */
	while (dbg_commands->count)
	{
		char *cmd = (char *) dbg_commands->items[0];
		int r;

		r = _clip_process_dbg(mp, cmd);

		atFree_Coll(dbg_commands, 0);

		if (r > 0)
			return 0;
		else if (r < 0)
			return r;
	}

	/* check breakpoints */
	if (!in_sigdebug)
	{
		ClipBreakPoint *bp = _clip_breakpoint, *nbp;
		int ind;

		if (in_breakpoint)
		{
			fprintf(_clip_dbg_out, "\ninterrupt reached:\n");
			fprintf(_clip_dbg_out, "file:%s", nullstr(mp->fp->filename));
			fprintf(_clip_dbg_out, " line:%d", mp->fp->line);
			fprintf(_clip_dbg_out, " func:%s", nullstr(mp->fp->procname));
			fprintf(_clip_dbg_out, "\n.\n");
			fflush(_clip_dbg_out);
			_clip_in_breakpoint();
			return 0;
		}

		if (next_line && !_clip_debugnext && mp->fp->line && mp->fp->line != next_line)
		{
			next_line = 0;
			fprintf(_clip_dbg_out, "step line reached:\n");
			fprintf(_clip_dbg_out, "file:%s", nullstr(mp->fp->filename));
			fprintf(_clip_dbg_out, " line:%d", mp->fp->line);
			fprintf(_clip_dbg_out, " func:%s", nullstr(mp->fp->procname));
			fprintf(_clip_dbg_out, "\n.\n");
			fflush(_clip_dbg_out);
			_clip_in_breakpoint();
			return 0;
		}

		if (next_line && _clip_debugnext && mp->fp->line && mp->fp->line != next_line
			&& next_file && next_file == mp->fp->filename
			&& next_proc && next_proc == mp->fp->procname
			)
		{
			_clip_debugnext = 0;
			next_line = 0;
			next_file = 0;
			next_proc = 0;
			fprintf(_clip_dbg_out, "next line reached:\n");
			fprintf(_clip_dbg_out, "file:%s", nullstr(mp->fp->filename));
			fprintf(_clip_dbg_out, " line:%d", mp->fp->line);
			fprintf(_clip_dbg_out, " func:%s", nullstr(mp->fp->procname));
			fprintf(_clip_dbg_out, "\n.\n");
			fflush(_clip_dbg_out);
			_clip_in_breakpoint();
			return 0;
		}

		if (until_line && mp->fp->line == until_line
			&& (!until_file || (mp->fp->filename && !strcasecmp(until_file, mp->fp->filename))))
		{
			until_line = 0;
			if (until_file)
			{
				free(until_file);
				until_file = 0;
			}
			fprintf(_clip_dbg_out, "until line reached:\n");
			fprintf(_clip_dbg_out, "file:%s", nullstr(mp->fp->filename));
			fprintf(_clip_dbg_out, " line:%d", mp->fp->line);
			fprintf(_clip_dbg_out, " func:%s", nullstr(mp->fp->procname));
			fprintf(_clip_dbg_out, "\n.\n");
			fflush(_clip_dbg_out);
			_clip_in_breakpoint();
			return 0;
		}

		if (!bp)
		{
			bp = &cur_bp;
			bp->filename = (char *) mp->fp->filename;
			bp->procname = (char *) mp->fp->procname;
			bp->line = mp->fp->line;
		}

		if (search_Coll(&sbreakpoints, bp, &ind))
		{
			nbp = (ClipBreakPoint *) sbreakpoints.items[ind];
			if (nbp == prev_bp)
				return 0;
			if (!bp_in_codeblock && mp->fp->procname && !memcmp(mp->fp->procname, "___code_", 8))
				return 0;
			fprintf(_clip_dbg_out, "\nbreakpoint: file %s line %d proc %s", nullstr(bp->filename), bp->line, nullstr(bp->procname));
			fprintf(_clip_dbg_out, "\n.\n");
			fflush(_clip_dbg_out);
			_clip_logg(1, "breakpoint reached: file %s line %d proc %s", nullstr(bp->filename), bp->line, nullstr(bp->procname));
			prev_bp = nbp;
			_clip_in_breakpoint();
		}
		else
		{
			prev_bp = 0;

			if (watchs.count)
			{
				int i;

				for (i = 0; i < watchs.count; i++)
				{
					ClipVar res;
					char *expr = (char *) watchs.items[i];
					int l;

					memset(&res, 0, sizeof(res));
					debugging = 0;
					mp->noerrblock++;
					_clip_eval_macro(mp, expr, strlen(expr), &res);
					mp->noerrblock--;
					l = _clip_log(&res);
					_clip_destroy(mp, &res);
					debugging = 1;
					if (l)
					{
						/*watch_line=mp->fp->line; */
						fprintf(_clip_dbg_out, "\nwatchpoint: expr '%s' file %s line %d proc %s", expr, nullstr(mp->fp->filename), mp->fp->line, nullstr(mp->fp->procname));
						fprintf(_clip_dbg_out, "\n.\n");
						fflush(_clip_dbg_out);
						_clip_logg(1, "watchpoint reached: expr '%s' file %s line %d proc %s", expr, nullstr(bp->filename), bp->line, nullstr(bp->procname));
						_clip_in_breakpoint();
					}
				}
			}
		}
	}

	return 0;
}

static void
split_vector(char *str, char ***vpp, int *lenp)
{
	int l;
	char *tok;

	while ((tok = strtok(str, " \t")))
	{
		str = 0;
		if (!*tok)
			continue;
		l = (*lenp)++;
		*vpp = (char **) realloc(*vpp, (l + 1) * sizeof(char *));

		(*vpp)[l] = tok;
	}
}

static ClipFrame *
get_frame(ClipMachine * mp)
{
	ClipFrame *fp;
	int i;

	for (i = 0, fp = mp->fp; fp; fp = fp->up)
	{
		if (!fp->line)
			continue;
		if (i == cur_frame)
			return fp;
		i++;
	}

	if (!fp)
		fp = mp->fp;
	return fp;
}

static DbgCommandBucket *
find_dbg_command(char *cmd)
{
	DbgCommandBucket *dcp, *dbeg, *dend, *fp = 0;

	for (dcp = dbg_buckets; dcp->name; dcp++)
	{
		int l;
		int found = 0;

		if (toupper(dcp->name[0]) != toupper(cmd[0]))
			continue;

		for (dbeg = dcp; dcp->name && toupper(dcp->name[0]) == toupper(cmd[0]); dcp++)
		{
			if (!strcasecmp(dcp->name, cmd))
				return dcp;
		}

		dend = dcp;
		l = strlen(cmd);
		for (dcp = dbeg; dcp < dend; dcp++)
		{
			if (!strncasecmp(dcp->name, cmd, l))
			{
				found++;
				fp = dcp;
			}
		}
		if (found == 1)
			return fp;

		return 0;
	}

	return 0;
}

int
_clip_process_dbg(ClipMachine * mp, char *str)
{
	char **argv = 0;
	int argc = 0;
	char *cmd = 0;
	DbgCommandBucket *bp;
	int r = 0;

	_clip_logg(0, "process dbg cmd: '%s'", str);

	split_vector(str, &argv, &argc);

	if (!argc)
		goto empty;

	cmd = argv[0];

	bp = find_dbg_command(cmd);

	_clip_logg(0, "find dbg cmd: '%s', %d argc", cmd, argc);
	/*fprintf(_clip_dbg_out, "\n"); */
	if (bp)
		r = bp->dcp(mp, argc - 1, argv + 1);
	else
	{
		int i;

		fprintf(_clip_dbg_out, "unknown command (try ?):");
		for (i = 0; i < argc; i++)
			fprintf(_clip_dbg_out, " %s", argv[i]);
		fprintf(_clip_dbg_out, "\n");
	}

	  empty:
	if (r >= 0)
	{
		fprintf(_clip_dbg_out, ".\n");
	}
	fflush(_clip_dbg_out);

/*ret: */
	free(argv);
	_clip_logg(0, "end cmd: '%s'", cmd);
	return r;
}

static int
expr_command(ClipMachine * mp, int argc, char **argv)
{
	int i;
	char *s = 0;
	int l = 0;
	ClipVar res;
	int binary = 0;

	for (i = 0; i < argc; i++)
	{
		if (!strcasecmp(argv[i], "-binary"))
			binary = 1;
		else
			break;
	}

	for (; i < argc; i++)
	{
		int ln = strlen(argv[i]);

		s = (char *) realloc(s, l + ln + 2);
		s[l] = ' ';
		memcpy(s + l + 1, argv[i], ln);
		s[l + 1 + ln] = 0;
		l += ln + 1;
	}

	memset(&res, 0, sizeof(res));
	debugging = 0;
	mp->noerrblock++;
	_clip_eval_macro(mp, s, l, &res);
	mp->noerrblock--;
	fprintf(_clip_dbg_out, "expr; var; ");
	print_dbg(mp, &res, binary);
	_clip_destroy(mp, &res);
	debugging = 1;

	fprintf(_clip_dbg_out, "\n");

	free(s);
	return 0;
}

static int
kill_command(ClipMachine * mp, int argc, char **argv)
{
	int code = 0;

	if (argc > 0)
		code = atoi(argv[0]);

	fprintf(_clip_dbg_out, "dbg kill: %s: exit now", _clip_progname);
	fprintf(_clip_dbg_out, "\n.\n");
	fflush(_clip_dbg_out);

	exit(code);
	return 0;
}

static int
help_command(ClipMachine * mp, int argc, char **argv)
{
	if (argc < 1)
	{
		DbgCommandBucket *bp;
		int i;

		for (i = 0, bp = dbg_buckets; bp->name; bp++, i++)
		{
			fprintf(_clip_dbg_out, "%s", bp->name);
			if (!i || i % 9)
				fputc('\t', _clip_dbg_out);
			else
				fputc('\n', _clip_dbg_out);
		}
	}
	else
	{
		DbgCommandBucket *bp;

		bp = find_dbg_command(argv[0]);
		if (bp)
			fprintf(_clip_dbg_out, "%s", bp->help);
		else
			fprintf(_clip_dbg_out, "unknown command %s", argv[0]);
	}
	fprintf(_clip_dbg_out, "\n");

	return 0;
}

static const char *
nullstr(const char *str)
{
	if (str)
		return str;
	else
		return "";
}

static int
frame_command(ClipMachine * mp, int argc, char **argv)
{
	if (argc < 1)
	{
		ClipFrame *fp;

		  prframe:
		fp = get_frame(mp);
		fprintf(_clip_dbg_out, "%d: file:%s", cur_frame, nullstr(fp->filename));
		fprintf(_clip_dbg_out, " line:%d", fp->line);
		fprintf(_clip_dbg_out, " func:%s\n", nullstr(fp->procname));
		return 0;
	}
	else
	{
		int fno = atoi(argv[0]);
		ClipFrame *fp;
		int i;

		for (i = 0, fp = mp->fp; fp; fp = fp->up)
		{
			if (!fp->line)
				continue;
			if (i == fno)
			{
				cur_frame = fno;
				goto prframe;
			}
			i++;
		}
	}

	return 0;
}

static int
bt_command(ClipMachine * mp, int argc, char **argv)
{
	ClipFrame *fp;
	int i;

	for (i = 0, fp = mp->fp; fp; fp = fp->up)
	{
		if (!fp->line)
			continue;
		fprintf(_clip_dbg_out, "%d: file:%s", i, nullstr(fp->filename));
		fprintf(_clip_dbg_out, " line:%d", fp->line);
		fprintf(_clip_dbg_out, " func:%s\n", nullstr(fp->procname));
		i++;
	}

	return 0;
}

static int
ls_command(ClipMachine * mp, int argc, char **argv)
{
	ClipFrame *fp = get_frame(mp);
	int nstatics = fp->statics ? fp->statics[0].name : 0;
	int nlocals = fp->localvars ? fp->localvars->size : 0;
	int nprivates = HashTable_len(mp->privates);
	int npublics = HashTable_len(mp->publics);
	int show_local = 0, show_static = 0, show_private = 0, show_public = 0;
	int i, r;
	char buf[96];

	for (i = 0; i < argc; i++)
	{
		if (!strcasecmp(argv[i], "local"))
			show_local = 1;
		else if (!strcasecmp(argv[i], "static"))
			show_static = 1;
		else if (!strcasecmp(argv[i], "private"))
			show_private = 1;
		else if (!strcasecmp(argv[i], "public"))
			show_public = 1;
	}

	if (!show_local && !show_static && !show_private && !show_public)
	{
		show_local = 1;
		show_static = 1;
		show_private = 1;
		show_public = 1;
	}

	if (show_local)
	{
		fprintf(_clip_dbg_out, "%d locals:", nlocals);
		if (fp->localvars)
		{
			char *s = (char *) fp->localvars->names;

			for (i = 0; i < nlocals; i++)
			{
				fprintf(_clip_dbg_out, " %s", s);
				s += strlen(s) + 1;
			}
		}
		fprintf(_clip_dbg_out, "\n");
	}
	if (show_static)
	{
		fprintf(_clip_dbg_out, "%d statics:", nstatics);
		for (i = 0; i < nstatics; i++)
		{
			ClipVarDef *dp = fp->statics + i + 1;

			_clip_hash_name(mp, dp->name, buf, sizeof(buf));
			fprintf(_clip_dbg_out, " %s", buf);
		}
		fprintf(_clip_dbg_out, "\n");
	}
	if (show_private)
	{
		fprintf(_clip_dbg_out, "%d privates:", nprivates);
		for (r = HashTable_first(mp->privates); r; r = HashTable_next(mp->privates))
		{
			VarEntry *vp = (VarEntry *) HashTable_current(mp->privates);

			_clip_hash_name(mp, vp->hash, buf, sizeof(buf));
			fprintf(_clip_dbg_out, " %s", buf);

			for (vp = vp->next; vp; vp = vp->next)
			{
				_clip_hash_name(mp, vp->hash, buf, sizeof(buf));
				fprintf(_clip_dbg_out, " %s", buf);
			}
		}
		fprintf(_clip_dbg_out, "\n");
	}
	if (show_public)
	{
		fprintf(_clip_dbg_out, "%d publics:", npublics);
		for (r = HashTable_first(mp->publics); r; r = HashTable_next(mp->publics))
		{
			VarEntry *vp = (VarEntry *) HashTable_current(mp->publics);

			_clip_hash_name(mp, vp->hash, buf, sizeof(buf));
			fprintf(_clip_dbg_out, " %s", buf);

			for (vp = vp->next; vp; vp = vp->next)
			{
				_clip_hash_name(mp, vp->hash, buf, sizeof(buf));
				fprintf(_clip_dbg_out, " %s", buf);
			}
		}
		fprintf(_clip_dbg_out, "\n");
	}

	return 0;
}

static int
is_dig(const char *s, int l)
{
	int i;

	for (i = 0; i < l; i++)
		if (!isdigit(s[i]))
			return 0;
	return 1;
}

static void
parse_name(const char *name, long *hashp, long **dimp, int *ndimp)
{
	const char *s;
	int l;
	long val;

	if (!memcmp(name, "::", 2))
	{
		*hashp = _clip_casehashbytes(0, "__SELF__", 8);
		l = strcspn(name + 1, "[]:");
		s = name + 1 + l;
	}
	else
	{
		l = strcspn(name, "[]:");
		*hashp = _clip_casehashbytes(0, name, l);
		s = name + l;
	}
	for (;;)
	{
		l = strspn(s, "[]:");
		s += l;
		l = strcspn(s, "[]:");
		if (!l)
			break;
		*dimp = (long *) realloc(*dimp, sizeof(long) * (1 + *ndimp));

		if (is_dig(s, l))
			val = atoi(s) - 1;
		else
			val = _clip_casehashbytes(0, s, l);
		(*dimp)[*ndimp] = val;
		(*ndimp)++;
		s += l;
	}
}

static void
print_dbg(ClipMachine * mp, ClipVar * vp, int binary)
{
	if (!binary)
		_clip_print_dbg(mp, vp);
	else
	{
		char *str = 0;
		long len = 0;

		_clip_var2str(mp, vp, &str, &len, 1);
		fwrite(str, len, 1, _clip_dbg_out);
		fwrite("\n", 1, 1, _clip_dbg_out);
		free(str);
	}
}

static void
print_var(ClipMachine * mp, ClipVar * vp, long *dim, int ndim, int binary)
{
	if (!ndim)
		print_dbg(mp, vp, binary);
	else
	{
		if (vp->t.type == ARRAY_t)
		{
			ClipVar var;

			memset(&var, 0, sizeof(var));
			if (_clip_aget(mp, vp, &var, ndim, dim))
			{
				if (!binary)
					fprintf(_clip_dbg_out, "Bad index.\n");
			}
			else
				print_dbg(mp, &var, binary);
			_clip_destroy(mp, &var);
		}
		else if (vp->t.type == MAP_t)
		{
			if (ndim > 1)
			{
				if (!binary)
					fprintf(_clip_dbg_out, "Too deep index.\n");
			}
			else
			{
				ClipVar *vpp = _clip_mget(mp, vp, dim[0]);

				if (vpp)
					print_dbg(mp, vpp, binary);
				else if (!binary)
					fprintf(_clip_dbg_out, "Bad index.\n");
			}
		}
		else if (!binary)
		{
			fprintf(_clip_dbg_out, "Not ARRAY or MAP\n");
		}
	}
}

static int
print_command(ClipMachine * mp, int argc, char **argv)
{
	int show_local = 0, show_static = 0, show_private = 0, show_public = 0, show_memvar = 0, show_field = 0, show_first = 0;
	int i, cnt, binary = 0;

	for (i = 0; i < argc; i++)
	{
		if (!strcasecmp(argv[i], "-local"))
			show_local = 1;
		else if (!strcasecmp(argv[i], "-static"))
			show_static = 1;
		else if (!strcasecmp(argv[i], "-private"))
			show_private = 1;
		else if (!strcasecmp(argv[i], "-public"))
			show_public = 1;
		else if (!strcasecmp(argv[i], "-memvar"))
			show_memvar = 1;
		else if (!strcasecmp(argv[i], "-field"))
			show_field = 1;
		else if (!strcasecmp(argv[i], "-binary"))
			binary = 1;
		else
			break;
	}

	if (!show_local && !show_static && !show_private && !show_public
		&& !show_memvar && !show_field)
	{
		show_local = 1;
		show_static = 1;
		show_field = 1;
		show_public = 1;
		show_private = 1;
		show_first = 1;
	}

	for (cnt = 0; i < argc; i++, cnt++)
	{
		long hash;
		long *dim = 0;
		int ndim = 0;
		int found = 0;
		char *name = argv[i];

		parse_name(name, &hash, &dim, &ndim);

		if (show_local)
		{
			int j = 0;
			ClipFrame *fp = get_frame(mp);
			int nlocals = fp->localvars ? fp->localvars->size : 0;
			char *s;

			if (fp->localvars)
			{
				s = (char *) fp->localvars->names;
				for (j = 0; j < nlocals; j++)
				{
					if (j)
						s += strlen(s) + 1;

					if (_clip_casehashstr(s) == hash)
					{
						fprintf(_clip_dbg_out, "local; %s; ", s);
						print_var(mp, fp->localvars->vars + nlocals - 1 - j, dim, ndim, binary);
						found++;
						if (show_first)
							goto cont;
						else
							break;
					}
				}
			}
			if (j == nlocals)
				if (!show_first)
					fprintf(_clip_dbg_out, "No local variable '%s'", name);
		}

		if (show_static)
		{
			int j;
			ClipFrame *fp = get_frame(mp);
			int nstatics = fp->statics ? fp->statics[0].name : 0;

			for (j = 0; j < nstatics; j++)
			{
				ClipVarDef *dp = fp->statics + j + 1;

				if (dp->name == hash)
				{
					fprintf(_clip_dbg_out, "static; %s; ", name);
					print_var(mp, dp->vp, dim, ndim, binary);
					found++;
					if (show_first)
						goto cont;
					else
						break;
				}
			}
			if (j == nstatics)
				if (!show_first)
					fprintf(_clip_dbg_out, "No static variable '%s'", name);
		}
		if (show_private)
		{
			VarEntry *vp = (VarEntry *) HashTable_fetch(mp->privates, hash);

			if (vp)
			{
				fprintf(_clip_dbg_out, "private; %s; ", name);
				print_var(mp, &vp->var, dim, ndim, binary);
				found++;
				if (show_first)
					goto cont;
			}
			else
			{
				if (!show_first)
					fprintf(_clip_dbg_out, "No private variable '%s'", name);
			}
		}
		if (show_public)
		{
			VarEntry *vp = (VarEntry *) HashTable_fetch(mp->publics, hash);

			if (vp)
			{
				fprintf(_clip_dbg_out, "public; %s; ", name);
				print_var(mp, &vp->var, dim, ndim, binary);
				found++;
				if (show_first)
					goto cont;
			}
			else
			{
				if (!show_first)
					fprintf(_clip_dbg_out, "No public variable '%s'", name);
			}
		}
		if (show_memvar)
		{
			VarEntry *vp = (VarEntry *) HashTable_fetch(mp->privates, hash);

			if (!vp)
				vp = (VarEntry *) HashTable_fetch(mp->publics, hash);

			if (vp)
			{
				fprintf(_clip_dbg_out, "memvar; %s; ", name);
				print_var(mp, &vp->var, dim, ndim, binary);
				found++;
				if (show_first)
					goto cont;
			}
			else
			{
				if (!show_first)
					fprintf(_clip_dbg_out, "No memvar variable '%s'", name);
			}
		}
		if (!found && show_first)
			fprintf(_clip_dbg_out, "No variable '%s'", name);
		  cont:
		fprintf(_clip_dbg_out, "\n");
		free(dim);
	}

	if (!cnt)
		fprintf(_clip_dbg_out, "\n");
	return 0;
}

static void
delete_ClipBreakPoint(void *p)
{
	ClipBreakPoint *bp = (ClipBreakPoint *) p;

	if (!bp)
		return;
	free(bp->filename);
	free(bp->procname);
	free(bp);
}

static int
compare_ClipBreakPoint(void *p1, void *p2)
{
	ClipBreakPoint *bp1 = (ClipBreakPoint *) p1;
	ClipBreakPoint *bp2 = (ClipBreakPoint *) p2;
	int l;

	if (bp1->filename && bp2->filename && bp1->filename[0] && bp2->filename[0])
	{
		l = strcasecmp(nullstr(bp1->filename), nullstr(bp2->filename));
		if (l != 0)
			return l;
	}

	if (bp1->line < bp2->line)
		return -1;
	else if (bp1->line > bp2->line)
		return 1;
	return 0;

	/*l = strcasecmp(nullstr(bp1->procname), nullstr(bp2->procname));
	   return l; */
}

static int
bp_command(ClipMachine * mp, int argc, char **argv)
{
	int i;

	if (argc < 1)
	{
		fprintf(_clip_dbg_out, "%d breakpoints:\n", breakpoints.count);
		for (i = 0; i < breakpoints.count; i++)
		{
			ClipBreakPoint *bp = (ClipBreakPoint *) breakpoints.items[i];

			fprintf(_clip_dbg_out, "%d: file:%s line:%d func:%s\n",
				i, nullstr(bp->filename), bp->line, nullstr(bp->procname));
		}
	}
	else
	{
		for (i = 0; i < argc; i++)
		{
			char *s = argv[i], *e;
			int line;
			char *filename = 0, *procname = 0;
			ClipFrame *fp = get_frame(mp);
			ClipBreakPoint *bp;

			if (is_dig(s, strlen(s)))
			{
				line = atoi(s);
				if (fp->filename)
					filename = strdup(fp->filename);
				procname = 0;
			}
			else if ((e = strchr(s, ':')))
			{
				line = atoi(e + 1);
				if (e > s)
					filename = _clip_memdup(s, e - s);
				else if (fp->filename)
					filename = strdup(fp->filename);
				procname = 0;
			}
			else
			{
				line = 0;
				filename = 0;
				procname = strdup(s);
			}

			cur_bp.filename = filename;
			cur_bp.procname = procname;
			cur_bp.line = line;
			if (search_Coll(&sbreakpoints, &cur_bp, 0))
			{
				free(filename);
				free(procname);
				fprintf(_clip_dbg_out, "breakpoint already exist\n");
			}
			else
			{
				bp = (ClipBreakPoint *) calloc(sizeof(ClipBreakPoint), 1);
				bp->filename = filename;
				bp->procname = procname;
				bp->line = line;

				append_Coll(&breakpoints, bp);
				insert_Coll(&sbreakpoints, bp);
			}
		}
	}

	return 0;
}

static int
rm_command(ClipMachine * mp, int argc, char **argv)
{
	int i;

	for (i = 0; i < argc; i++)
	{
		char *s = argv[i], *e;
		int line, ind;
		char *filename = 0, *procname = 0;
		ClipFrame *fp = get_frame(mp);
		ClipBreakPoint *bp;

		if (is_dig(s, strlen(s)))
		{
			line = atoi(s);
			if (fp->filename)
				filename = strdup(fp->filename);
			procname = 0;
		}
		else if ((e = strchr(s, ':')))
		{
			line = atoi(e + 1);
			if (e > s)
				filename = _clip_memdup(s, e - s);
			else if (fp->filename)
				filename = strdup(fp->filename);
			procname = 0;
		}
		else
		{
			line = 0;
			filename = 0;
			procname = strdup(s);
		}

		cur_bp.filename = filename;
		cur_bp.procname = procname;
		cur_bp.line = line;
		if (!search_Coll(&sbreakpoints, &cur_bp, &ind))
		{
			fprintf(_clip_dbg_out, "no breakpoint at file:%s line:%d proc:%s\n",
				nullstr(filename), line, nullstr(procname));
		}
		else
		{
			bp = (ClipBreakPoint *) sbreakpoints.items[ind];
			atRemove_Coll(&sbreakpoints, ind);
			remove_Coll(&breakpoints, bp);
			free(bp->filename);
			free(bp->procname);
			free(bp);
			fprintf(_clip_dbg_out, "breakpoint removed at file:%s line:%d proc:%s\n",
				nullstr(filename), line, nullstr(procname));
		}

		free(filename);
		free(procname);
	}

	return 0;
}

static int
continue_command(ClipMachine * mp, int argc, char **argv)
{
	in_breakpoint = 0;
	return -1;
}

static int
interrupt_command(ClipMachine * mp, int argc, char **argv)
{
	fprintf(_clip_dbg_out, "interrupt at ");
	fprintf(_clip_dbg_out, "file:%s", nullstr(mp->fp->filename));
	fprintf(_clip_dbg_out, " line:%d", mp->fp->line);
	fprintf(_clip_dbg_out, " func:%s\n", nullstr(mp->fp->procname));
	in_breakpoint = 1;
	return 0;
}

static int
next_command(ClipMachine * mp, int argc, char **argv)
{
	next_line = mp->fp->line ? mp->fp->line : -1;
	next_file = (char *) mp->fp->filename;
	next_proc = (char *) mp->fp->procname;
	if (next_file && next_proc)
		_clip_debugnext = 1;
	else
		_clip_debugnext = 0;
	in_breakpoint = 0;
	return -1;
}

static int
step_command(ClipMachine * mp, int argc, char **argv)
{
	_clip_debugnext = 0;
	next_line = mp->fp->line ? mp->fp->line : -1;
	next_file = 0;
	next_proc = 0;
	in_breakpoint = 0;
	return -1;
}

static int
until_command(ClipMachine * mp, int argc, char **argv)
{
	if (argc < 1)
		until_line = mp->fp->line + 1;
	else
	{
		char *e = argv[0];
		char *s = strchr(e, ':');

		if (s)
		{
			until_line = atoi(s + 1);
			until_file = _clip_memdup(e, s - e);
		}
		else
			until_line = atoi(e);
	}
	in_breakpoint = 0;
	return -1;
}

static void
print_wa(ClipMachine * mp, DBWorkArea * wa)
{
	int i;

	for (i = 0; i < mp->areas->count; i++)
	{
		int j;

		wa = (DBWorkArea *) mp->areas->items[i];
		if (!wa || !wa->used)
			continue;
		fprintf(_clip_dbg_out, "no:%d name:%s alias:%s shared:%d ro:%d filter:%s\n"
			,wa->rd->area, wa->rd->name, wa->alias, wa->rd->shared, wa->rd->readonly
			,wa->rd->filter && wa->rd->filter->sfilter?wa->rd->filter->sfilter:"");
		fprintf(_clip_dbg_out, "\t%d fields:\n", wa->rd->nfields);
		for (j = 0; j < wa->rd->nfields; j++)
		{
			RDD_FIELD *fp = wa->rd->fields + j;

			fprintf(_clip_dbg_out, "\t\tno:%d\tname:%s\ttype:%c\tlen:%d\tdec:%d\n"
				,j, fp->name, fp->type, fp->len, fp->dec);
		}
		fprintf(_clip_dbg_out, "\t%d indexes: current %d\n", wa->rd->ords_opened, wa->rd->curord);
		for (j = 0; j < wa->rd->ords_opened; j++)
		{
			RDD_ORDER *ip = wa->rd->orders[j];

			fprintf(_clip_dbg_out, "\t\tno:%d\tname:%s\texpr:%s\tunique:%d\n"
				,j, ip->name, ip->expr, ip->unique);
		}
/*
		fprintf(_clip_dbg_out, "\t%d relations: parent:%s\n", wa->relnum
			,wa->parent ? nullstr(wa->parent->alias) : "");
		for (j = 0; j < wa->relnum; j++)
		{
			DBRelation *rp = wa->relations + j;

			fprintf(_clip_dbg_out, "\t\tno:%d\tchield:%s\texpr:%s\n"
				,j, rp->chield->alias, nullstr(rp->expr));
		}
*/
	}
}

static int
data_command(ClipMachine * mp, int argc, char **argv)
{
	DBWorkArea *wa = 0;

	if (argc < 1)
	{
		fprintf(_clip_dbg_out, "%d workareas:\n", mp->areas->count);
		print_wa(mp, wa);
	}
	else if (argc < 2)
	{
		long area = atoi(argv[0]);

		if (area == -1 && mp->curArea >= 0 && mp->curArea < mp->areas->count)
			wa = (DBWorkArea *) mp->areas->items[mp->curArea];
		else
			area = _clip_casehashstr(argv[0]);

		if (!wa)
		{
			wa = (DBWorkArea *) HashTable_fetch(mp->aliases, area);
			if (!wa)
			{
				if (area >= 0 && area < mp->areas->count)
					wa = (DBWorkArea *) mp->areas->items[area];
			}
		}
		if (wa)
			print_wa(mp, wa);
	}
	else
	{
	}

	fflush(_clip_dbg_out);
	return 0;
}

static int
option_command(ClipMachine * mp, int argc, char **argv)
{
	char *opt, *arg;

	if (argc < 1)
		return 0;

	opt = argv[0];
	arg = (argc > 1) ? argv[1] : 0;

	if (!strcasecmp(opt, "codeblock"))
	{
		if (arg)
			bp_in_codeblock = atoi(arg);
		else
			fprintf(_clip_dbg_out, "codeblock %d", bp_in_codeblock);
	}
	fprintf(_clip_dbg_out, "\n");

	return 0;
}

static int
watch_command(ClipMachine * mp, int argc, char **argv)
{
	int i;

	if (argc < 1)
	{
		for (i = 0; i < watchs.count; i++)
			fprintf(_clip_dbg_out, "watch %d: %s\n", i, (char *) watchs.items[i]);
	}
	else if (argc == 1 && !strcmp(argv[0], "-clear"))
	{
		freeAll_Coll(&watchs);
		freeAll_Coll(&swatchs);
	}
	else
	{
		OutBuf buf;

		init_Buf(&buf);

		for (i = 0; i < argc; i++)
		{
			putBuf_Buf(&buf, argv[i], strlen(argv[i]));
			putBuf_Buf(&buf, " ", 1);
		}
		putByte_Buf(&buf, 0);

		if (search_Coll(&swatchs, buf.buf, 0))
		{
			fprintf(_clip_dbg_out, "watch already exist: %s\n", buf.buf);
			destroy_Buf(&buf);
		}
		else
		{
			insert_Coll(&swatchs, buf.buf);
			append_Coll(&watchs, buf.buf);
		}
	}

	return 0;
}

static DbgCommandBucket dbg_buckets[] =
{
	{"?", help_command, "help [command]\n\tlist all commands\n\tif <command> is given, print help about command"},
	{"break", bp_command, "break[point] [line|procname|filename:line] -- set/show breakpoints"},
	{"cont", continue_command, "cont[inue]  -- continue execution"},
	{"data", data_command, "data[base] [alias] [subcommand] -- database info"},
	{"expr", expr_command, "expr <expression> -- eval expression"},
	{"frame", frame_command, "frame [frame_no] -- set/print current frame info"},
	{"int", interrupt_command, "int[errupt]  -- interrupt execution"},
	{"help", help_command, "help [command]\n\tlist all commands\n\tif <command> is given, print help about command"},
	{"ls", ls_command, "ls [local|static|private|public] -- print list of variables"},
	{"next", next_command, "next -- execute up to line differeint line "},
	{"option", option_command, "option opt [val] -- set/show debug options:\n\
\tcodeblock [0|1] - disable/enable breakpoints in codeblocks\n\
"},
	{"print", print_command, "print [-local|-static|-private|-public|-memvar|-field|-binary] name [..nameN] -- print variable value"},
	{"rm", rm_command, "rm [line|procname|filename:line] -- remove breakpoints"},
	{"quit", kill_command, "quit [exitcode]\n\tterminate program with code exitcode"},
	{"step", step_command, "step -- step program, proceeding through function calls"},
	{"trace", bt_command, "trace  -- print call trace"},
	{"until", until_command, "until [[file:]line] -- execute until the line"},
	{"watch", watch_command, "watch [-clear]|[expr] -- watch expression"},
	{0, 0, 0}
};
