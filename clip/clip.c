/*
    Copyright (C) 2001  ITK
    Author   : Paul Lasarev <paul@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/*
 * $Log: clip.c,v $
 * Revision 1.61  2002/10/11 11:53:17  clip
 * fix clip_makelib for raw .o files
 * fix -N help message
 * paul
 *
 * Revision 1.60  2002/10/11 10:27:11  clip
 * primary support for search of unresolved function names:
 * clip compler flag -N and/or envar CLIP_NAMES=yes will generate
 * files .ex (external refs) and .nm (defined names)
 * clip_makeslib will join .ex and .nm files if CLIP_NAMES=yes
 * new util clip_makelib also will join .ex .nm
 * new util clip_cp may be used to copy lib/obj files and correspond
 * .ex .nm files automatic
 * Closes: #17
 * paul
 *
 * Revision 1.59  2002/09/27 06:36:01  clip
 * fix clip -H for CLIP_LOCALE_ROOT, __CLIP_MODULE__
 * paul
 *
 * Revision 1.58  2002/09/25 11:47:25  clip
 * add function: loadModuleMsg(cModule, cFilename_mo) -> bResult
 * predefined macro: __CLIP_MODULE__  expands to current module name as "modname"
 * new accepted environment var: CLIP_LOCALE_ROOT
 * 	used by clip, clip_msgmerge, clip_msgfmt, and at runtime
 * paul
 *
 * Revision 1.57  2002/07/30 08:30:31  clip
 * full path in .prg names
 * paul
 *
 * Revision 1.56  2002/05/23 13:16:10  clip
 * uri: add environment CLIP_LANG as LANG processing
 *
 * Revision 1.55  2002/05/16 07:56:19  clip
 * clip return error on 'unknown file type' instead of warning
 * paul
 *
 * Revision 1.54  2002/03/05 10:34:02  clip
 * no-as-word as default
 * paul
 *
 * Revision 1.53  2002/03/02 12:22:55  clip
 * add desctiption of -q option into -h
 * paul
 *
 * Revision 1.52  2002/03/02 11:24:54  clip
 * add compatability option:
 * -q <word>
 * --compat=<word>
 * possible words:
 * 	as-word  	- default value
 *         no-as-word
 * paul
 *
 * Revision 1.51  2002/02/20 09:51:39  clip
 * change VERSION to CLIP_VERSION
 * paul
 *
 * Revision 1.50  2002/01/18 09:47:10  clip
 * -d<outdir>, --outdir=<outdir> option
 * -o<oname> work correct
 * fw install fix
 * paul
 *
 * Revision 1.49  2001/10/29 06:51:21  clip
 * fix text fopen modes
 * paul
 *
 * Revision 1.48  2001/10/08 10:34:20  clip
 * , in command_list
 *
 * Revision 1.47  2001/10/08 09:34:39  clip
 * universal quoting in command substitution
 *
 * Revision 1.46  2001/10/03 07:15:05  clip
 * add ADDLIBS into configure, -lregex to CYGWIN
 * paul
 *
 * Revision 1.45  2001/09/27 06:44:24  clip
 * add -R (--noremove-c) option, defaults to remove temporary .c files
 * paul
 *
 * Revision 1.44  2001/09/21 09:53:25  clip
 * charsets handling
 * paul
 *
 * Revision 1.43  2001/09/20 14:43:44  clip
 * #cmdstr <options>
 * add preprocessor directive
 * paul
 *
 * Revision 1.42  2001/09/20 13:55:15  clip
 * C level error partial explanation
 * paul
 *
 * Revision 1.41  2001/09/20 13:49:53  clip
 * long options
 * paul
 *
 * Revision 1.40  2001/09/20 13:10:00  clip
 * add long options
 * paul
 *
 * Revision 1.39  2001/09/12 11:19:02  clip
 * compile modes
 * paul
 *
 * Revision 1.38  2001/09/08 07:16:23  clip
 * paths
 * paul
 *
 * Revision 1.37  2001/09/06 14:01:06  clip
 * -L flag
 * paul
 *
 * Revision 1.36  2001/09/06 12:17:30  clip
 * cygwin
 * paul
 *
 * Revision 1.35  2001/08/30 14:37:53  clip
 * new library binding
 * paul
 *
 * Revision 1.34  2001/08/28 09:49:09  clip
 * shared libs
 * paul
 *
 * Revision 1.33  2001/08/28 06:18:34  clip
 * -s configure flag
 * uninitalized var warnings with optimesed compile
 * paul
 *
 * Revision 1.32  2001/08/27 05:15:34  clip
 * $CLIPROOT/cliprc  order
 * paul
 *
 * Revision 1.31  2001/08/27 05:09:20  clip
 * $CLIPROOT/cliprc/ processing
 * paul
 *
 * Revision 1.30  2001/05/28 12:49:44  clip
 * $CLIPROOT/cliprc
 * paul
 *
 * Revision 1.29  2001/05/28 12:08:46  clip
 * full_name & /
 * paul
 *
 * Revision 1.28  2001/04/03 09:17:00  clip
 * license errors
 * paul
 *
 * Revision 1.27  2001/03/30 11:51:02  clip
 * add copyright
 *
 * Revision 1.26  2001/02/16 12:48:50  clip
 * breakpoints
 * paul
 *
 * Revision 1.25  2001/01/18 11:57:40  clip
 * CLIPROOT now more correctly used by compiler
 * CONSOLE_FLAG now work
 * paul
 *
 * Revision 1.24  2000/12/26 10:03:42  clip
 * load now can load .so
 * -s generate .so
 * paul
 *
 * Revision 1.23  2000/12/25 14:18:59  clip
 * append $CLIPROOT/.cliprc processing
 * paul
 *
 * Revision 1.22  2000/12/08 11:55:27  clip
 * start localisation
 * paul
 *
 * Revision 1.21  2000/12/06 13:13:01  clip
 * loadable charset tables. size 256
 * paul
 *
 * Revision 1.20  2000/12/03 08:45:20  clip
 * add CLIPLIBS envar
 * paul
 *
 * Revision 1.19  2000/12/02 13:47:40  clip
 * CLIPROOT now may be envar
 * paul
 *
 * Revision 1.18  2000/12/02 12:46:57  clip
 * scancodes
 * paul
 *
 * Revision 1.17  2000/11/22 14:52:19  clip
 * .po now can be start with any (for example #!/usr/bin/cliprun) string
 * paul
 *
 * Revision 1.16  2000/11/21 13:25:08  clip
 * -l
 * paul
 *
 * Revision 1.15  2000/05/24 18:34:07  clip
 * _clip_push_area
 * indents all
 * Paul Lasarev <paul@itk.ru>
 *
 * Revision 1.14  2000/05/03 19:32:32  clip
 * add prefix 'clip_' to all clip functions
 *
 * Revision 1.13  2000/05/01 19:40:49  clip
 * SunOS port
 *
 * Revision 1.12  2000/04/27 22:55:45  clip
 * freebsd fix
 *
 * Revision 1.11  2000/04/12 15:10:45  paul
 * cmd line - opt flags
 *
 * Revision 1.10  2000/04/11 16:24:36  paul
 * add '+' options
 *
 * Revision 1.9  2000/04/11 14:30:15  paul
 * .cliprc prioritate the environment
 *
 * Revision 1.8  2000/04/10 20:56:23  paul
 * multiple -U
 *
 * Revision 1.7  2000/04/10 20:49:21  paul
 * $HOME/.cliprc
 *
 * Revision 1.6  2000/04/10 20:21:59  paul
 * $HOME/.cliprc
 *
 * Revision 1.5  2000/04/10 18:58:40  paul
 * .cliprc processign
 *
 * Revision 1.4  2000/04/07 18:23:16  paul
 * -a flag
 *
 * Revision 1.3  2000/04/04 17:37:45  paul
 * main
 *
 * Revision 1.2  1999/12/28 22:03:02  serg
 * *** empty log message ***
 *
 * Revision 1.1  1999/10/25 16:39:27  paul
 * first entry
 *
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <sys/times.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>

#include "clic.h"
#include "clipcfg.h"
#include "getopt.h"

#include <dirent.h>

char *CLIPROOT = CLIP_ROOT;
char *CLIP_LOCALE_ROOT = CLIP_ROOT;

int compat_as_word = 0;

static int syntax_tree_flag = 0;
static int write_obj_flag = 1;
static int codegen_flag = 1;
static int compile_flag = 1, c_flag = 0;
static int exec_flag = 0;
int shared_flag = 0;
#ifdef STD_LIBDIR
	int eshared_flag = 1;
#else
	int eshared_flag = 0;
#endif
int rmc_flag = 1;
int genDebug = 0, pcode_flag = 0, pc_flag;
int optLevel = 0;
int vmLongJmps = 0;
int verbose = 1;
int main_flag = 0;
int nomain_flag = 0;
int auto_memvar = 0;
const char *std_ch_filename = "std.ch";
char *CC = "gcc";
char *COMPILE_FLAG = "-c";
char *CFLAGS = "";
char *COPT = "-O2";
char *CDBG = "-g";
char *OUT_FLAG = "-o";
char *INCLUDE_FLAG = "-I";
char *OBJSUF = ".o";
char *SOBJSUF = ".so";
char *LIBSUF = ".a";
char *SLIBSUF = DLLSUFF;
char *CLIPLIB = "libclip.a";
char *MATHLIB = "-lm";
char *CLIPLIBS = "";
char *CLIP_MODULE = 0;

/*char *DLLIB = "-ldl"; */
char *CLIPSLIB = "libclip" DLLSUFF;
char *SFLAGS = "-shared";
char *LINK = "gcc";
static char *oname = 0;
int namespace_warning = 0;
char *clic_charset = 0;
char *outdir = 0;

int names_flag = 0;

Coll poName;
Coll paName;
Coll include_files;
Coll lib_dirs;
Coll arglibs;

char *prgname;

static void
get_env(char *name, char *val)
{
	if (!name || !val || !*val)
		return;

	if (!strcmp(name, "CC"))
		CC = val;
	else if (!strcmp(name, "CLIPROOT"))
		CLIPROOT = strdup(val);
	else if (!strcmp(name, "CLIP_LOCALE_ROOT"))
		CLIP_LOCALE_ROOT = strdup(val);
	else if (!strcmp(name, "CLIP_MODULE"))
		CLIP_MODULE = strdup(val);
	else if (!strcmp(name, "CFLAGS"))
		CFLAGS = strdup(val);
	else if (!strcmp(name, "COPT"))
		COPT = strdup(val);
	else if (!strcmp(name, "CDBG"))
		CDBG = strdup(val);
	else if (!strcmp(name, "OUT_FLAG"))
		OUT_FLAG = strdup(val);
	else if (!strcmp(name, "INCLUDE_FLAG"))
		INCLUDE_FLAG = strdup(val);
	else if (!strcmp(name, "OBJSUF"))
		OBJSUF = strdup(val);
	else if (!strcmp(name, "SOBJSUF"))
		SOBJSUF = strdup(val);
	else if (!strcmp(name, "LIBSUF"))
		LIBSUF = strdup(val);
	else if (!strcmp(name, "SLIBSUF"))
		SLIBSUF = strdup(val);
	else if (!strcmp(name, "COMPILE_FLAG"))
		COMPILE_FLAG = strdup(val);
	else if (!strcmp(name, "SFLAGS"))
		SFLAGS = strdup(val);
	else if (!strcmp(name, "CLIPLIB"))
		CLIPLIB = strdup(val);
	else if (!strcmp(name, "CLIPLIBS"))
		CLIPLIBS = strdup(val);
	else if (!strcmp(name, "CLIPSLIB"))
		CLIPSLIB = strdup(val);
	else if (!strcmp(name, "CLIP_NAMES"))
        {
        	if (!strcasecmp(val, "yes")||!strcasecmp(val, "on"))
                	names_flag = 1;
        	else if (!strcasecmp(val, "no")||!strcasecmp(val, "off"))
                	names_flag = 0;
		else
			names_flag = atoi(val);
	}
	else if (!strcmp(name, "CLIP_CMDSTR"))
	{
		int argc;
		char *str = strdup(val);
		char *argv[32], *s;

		for (argc = 0; argc < 32 && (s = strtok(str, ",")) != NULL; ++argc)
		{
			argv[argc] = s;
			str = NULL;
		}
		get_opt(argc, argv);
	}

}

#define GETENV(val) get_env(val,getenv(val))
static void
getEnvironment()
{
	GETENV("CC");
	GETENV("CFLAGS");
	GETENV("COPT");
	GETENV("CDBG");
	GETENV("OUT_FLAG");
	GETENV("INCLUDE_FLAG");
	GETENV("OBJSUF");
	GETENV("SOBJSUF");
	GETENV("LIBSUF");
	GETENV("SLIBSUF");
	GETENV("COMPILE_FLAG");
	GETENV("SFLAGS");
	GETENV("CLIPLIB");
	GETENV("CLIPLIBS");
	GETENV("CLIPROOT");
	GETENV("CLIP_LOCALE_ROOT");
	GETENV("CLIPSLIB");
	GETENV("CLIP_CMDSTR");
	GETENV("CLIP_MODULE");
	GETENV("CLIP_NAMES");
}

#undef GETENV

static void
getrc(char *name)
{
	FILE *file;
	int argc = 0;
	char **argv = 0;
	char buf[256];

	file = fopen(name, "rt");
	if (!file)
		return;

	while (fgets(buf, sizeof(buf), file))
	{
		int l;
		char *s, *p;

		l = strlen(buf);
		if (l < 1)
			continue;

		while ((--l >= 0) && (buf[l] == '\n' || buf[l] == '\r'))
			buf[l] = 0;

		for (s = buf; *s && isspace(*s); s++, l--)
			;

		if (l < 1)
			continue;

		if (*s == '#')
			continue;

		for (p = s; *p && !isspace(*p); p++)
			;
		if (*p)
		{
			*p = 0;
			for (p++; *p && isspace(*p); p++)
				;
		}

		argv = (char **) realloc(argv, sizeof(char *) * (argc + 1));

		argv[argc++] = strdup(s);
		if (*p)
		{
			argv = (char **) realloc(argv, sizeof(char *) * (argc + 1));

			argv[argc++] = strdup(p);
		}
	}

	fclose(file);
	if (argc > 0)
		get_opt(argc, argv);
/*
   while(argc)
   free(argv[--argc]);
 */
	free(argv);
}

static struct option long_options[] =
{
	{"auto-memvar", optional_argument, 0, 'a'},
	{"namespace-warning", optional_argument, 0, 'w'},
	{"verbose", optional_argument, 0, 'v'},
	{"compile", no_argument, 0, 'c'},
	{"main", no_argument, 0, 'm'},
	{"nomain", no_argument, 0, 'n'},
	{"output", required_argument, 0, 'o'},
	{"outdir", required_argument, 0, 'd'},
	{"optimise", optional_argument, 0, 'O'},
	{"include-path", required_argument, 0, 'I'},
	{"library-path", required_argument, 0, 'L'},
	{"define", required_argument, 0, 'D'},
	{"show-syntax-tree", no_argument, 0, 't'},
	{"debug", optional_argument, 0, 'g'},
	{"exec", no_argument, 0, 'e'},
	{"pcode", no_argument, 0, 'p'},
	{"c-pcode", no_argument, 0, 'l'},
	{"shared", no_argument, 0, 's'},
	{"shared-exec", no_argument, 0, 'r'},
	{"preprocess", no_argument, 0, 'P'},
	{"show-command", no_argument, 0, 'C'},
	{"use-std-ch", required_argument, 0, 'U'},
	{"source-charset", required_argument, 0, 'S'},
	{"target-charset", required_argument, 0, 'T'},
	{"environment", required_argument, 0, 'E'},
	{"help", no_argument, 0, 'h'},
	{"help-environment", no_argument, 0, 'H'},
	{"version", no_argument, 0, 'V'},
	{"noremove-c", no_argument, 0, 'R'},
        {"compat", required_argument, 0, 'q'},
        {"names", no_argument, 0, 'N'},
	{0, 0, 0, 0}
};

void
get_opt(int arg_c, char **arg_v)
{
	int ch;
	int option_index = 0;
	int argc = arg_c+1, i;
	char **argv = (char **) alloca(sizeof(char*)*(arg_c+1));

	argv[0] = prgname;
	for(i=0; i<arg_c; i++)
		argv[i+1] = arg_v[i];

	optind = 0;
	while ((ch = getopt_long(argc, argv
		, "+v:T:S:o:d:I:i:D:d:E:L:U:u:q:MmnhHaecrsplVgbtPCOwRN"
		, long_options, &option_index)) != EOF)
	{
/*		printf("get_opt: ch=%c argc=%d optind=%d\n", ch, argc, optind);*/
		switch (ch)
		{
		case 'a':
			if (optarg)
				auto_memvar = atoi(optarg);
			else
				auto_memvar = 1;
			break;
		case 'w':
			if (optarg)
				namespace_warning = atoi(optarg);
			else
				namespace_warning = 1;
			break;
		case 'v':
			if (optarg)
				verbose = atoi(optarg);
			else
				++verbose;
			break;
		case 'c':
			compile_flag = 0;
			c_flag = 1;
			break;
		case 'M':
		case 'm':
			main_flag = 1;
			break;
		case 'n':
			nomain_flag = 1;
			break;
		case 'o':
			oname = optarg;
			break;
		case 'O':
			if (optarg)
				optLevel = atoi(optarg);
			else
				++optLevel;
			break;
		case 'I':
		case 'i':
			insert_Coll(&includePaths, strdup(optarg));
			break;
		case 'L':
			insert_Coll(&lib_dirs, strdup(optarg));
			break;
		case 'D':
			append_Coll(&predefines, strdup(optarg));
			break;
		case 'd':
			outdir = optarg;
			break;
		case 't':
			++syntax_tree_flag;
			break;
		case 'g':
		case 'b':
			if (optarg)
				genDebug = atoi(optarg);
			else
				++genDebug;
			break;
		case 'e':
			exec_flag = 1;
			break;
		case 'p':
			pcode_flag = 1;
			break;
		case 'l':
			pc_flag = 1;
			break;
		case 's':
			shared_flag = 1;
			break;
		case 'r':
			eshared_flag = 1;
			break;
		case 'P':
			++preproc_flag;
			break;
		case 'C':
			++command_flag;
			break;
		case 'R':
			rmc_flag = 0;
			break;
		case 'U':
		case 'u':
#if 0
			if (!optarg||!*optarg)
			{
				std_ch_filename = NULL;
				freeAll_Coll(&include_files);
			}
			else
#else
			if (optarg&&*optarg)
#endif
			{
				std_ch_filename = NULL;
				append_Coll(&include_files, strdup(optarg));
			}
			break;
		case 'S':
			sourceCharset = strdup(optarg);
			if (!preproc_flag)
				v_printf(2, "set source charset to %s\n", sourceCharset);
			changeCharset = 1;
			break;
		case 'T':
			targetCharset = clic_charset = strdup(optarg);
			if (!preproc_flag)
				v_printf(2, "set target charset to %s\n", targetCharset);
			changeCharset = 1;
			break;
		case 'E':
			{
				char *s, *p;

				s = strdup(optarg);
				p = strchr(s, '=');
				if (!p)
				{
					yyerror("invalid argument for -E: '%s'", optarg);
					break;
				}
				else
				{
					*p = 0;
					get_env(s, p + 1);
				}
				/*free(s); */
			}
			break;
		case 'q':
                	if (!strcmp(optarg, "as-word"))
                        	compat_as_word = 1;
                	else if (!strcmp(optarg, "no-as-word"))
                        	compat_as_word = 0;
                	else
                        	yyerror("invalid compatability word: '%s'\n"
                        	"possible values: as-word, no-as-word", optarg);
                	break;
		case 'N':
                	names_flag = 1;
                	break;
		default:
			fprintf(stdout,	"try '%s --help' for options details\n", prgname);
			exit(3);
		case 'h':
			{
				fprintf(stdout,
					"Usage: %s [options] [<filename> ...]\n\
options:\n\
 -h, --help\n\
	this help\n\
 -H, --help-environment\n\
	help about acceptable environment variables\n\
 -V, --version\n\
	print clip version\n\
 -v[<level>], --verbose[=<level>]\n\
	set/increase verbose level\n\
 -a, --auto-memvar[=1|0]\n\
	set auto memvar variables mode\n\
 -w, --namespace-warning[=1|0]\n\
	set warning about implicit var declaration\n\
 -e, --exec\n\
	generate executable file\n\
 -c, --compile\n\
	stop after generation C code\n\
 -g,-b, --debug[=1|0]\n\
	generate debug info\n\
 -t, --show-syntax-tree\n\
	print program syntax tree\n\
 -o<name>, --output=<name>\n\
	set output file name\n\
 -d<name>, --outdir=<name>\n\
	set output directory\n\
 -O, --optimise[=<val>]\n\
	set optimisation level\n\
 -M, --main\n\
	use first <filename> as start program point\n\
 -n, --nomain\n\
	don't declare module procedure\n\
 -p, --pcode\n\
	generate pseudocode module\n\
 -l, --c-pcode\n\
	compile C-pseudocode module\n\
 -s, --shared\n\
	compile into shared object\n\
 -r, --shared-exec\n\
	always when possible link with shared libraries\n\
 -I<path>, --include-path=<path>\n\
	add include search path\n\
 -L<path>, --library-path=<path>\n\
	add library path\n\
 -D<name>, --define=<name>\n\
	define macro name\n\
 -D<name=value>, --define=<name=value>\n\
	define macro name as <value>\n\
 -U[<filename>], --use-std-ch[=<filename>]\n\
	use alternate (or none) standard include file (default==std.ch)\n\
 -S<charset>, --source-charset\n\
	define source charset of string constants\n\
 -T<charet>, --target-charset\n\
	define target charset of string constants\n\
 -P, --preprocess\n\
	preprocess only\n\
 -C, --show-command\n\
	print command definitions\n\
 -R, --noremove-c\n\
	do not remove temporary '.c' files\n\
 -N, --names\n\
	warning on unresolved function names (see CLIP_NAMES envar)\n\
 -E<name=value>, --environment=<name=value>\n\
	exact to set same environ variable(see -H for details)\n\
 -q <word>, --compat=<word>\n\
 	set syntax compatability modes:\n\
 	        no-as-word  	- default value\n\
 	 	as-word\n\
\n\
 <filename> files to process\n\
\n\
 all above options may be placed in .cliprc file in current directory,\n\
 in $HOME/.cliprc file, or in any file in $CLIPROOT/cliprc directory\n\
"
					,prgname);
				exit(2);
			}
		case 'H':
			{
				fprintf(stdout, "\n\
%s can accept next environment variables:\n\
\n\
CC\n\
\tname of C compiler (default=='%s')\n\
CFLAGS\n\
\toptions for C compiler (default=='%s')\n\
COMPILE_FLAG\n\
\t'compile-only' flag for C compiler (default=='%s')\n\
COPT\n\
\toptimisation flag for C compiler (default=='%s')\n\
CDBG\n\
\tdebug flag for C compiler (default=='%s')\n\
OUT_FLAG\n\
\toutput flag for C compiler (default=='%s')\n\
INCLUDE_FLAG\n\
\tinclude flag for C compiler (default=='%s')\n\
OBJSUF\n\
\tsuffix for output object files (default=='%s')\n\
SOBJSUF\n\
\tsuffix for output shared files (default=='%s')\n\
LIBSUF\n\
\tsuffix for library files (default=='%s')\n\
SLIBSUF\n\
\tsuffix for shared library files (default=='%s')\n\
SFLAGS\n\
\toptions for C compiler - shared version (default=='%s')\n\
CLIPLIB\n\
\truntime support library (default=='%s')\n\
CLIPSLIB\n\
\truntime support shared library (default=='%s')\n\
CLIPLIBS\n\
\tadditional libs (default=='%s')\n\
CLIPROOT\n\
\troot for all clip related files (default=='%s')\n\
CLIP_LOCALE_ROOT\n\
\troot for locale messages\n\
CLIP_MODULE\n\
\tcurrent locale module (default=='%s')\n\
CLIP_CMDSTR\n\
\tcomma-separated list of command-line options\n\
CLIP_NAMES\n\
\tgenerate .ex, .nm files (possible values yes/no|on/off|0/1)\n\
predefined macros:\n\
\t__FILE__      string - name of current compile file\n\
\t__BASE_FILE__ string - name of root compile file\n\
\t__LINE__      numeric - number of current line in current file\n\
\t__VERSION__   string - version of clip\n\
\t__CLIP__	string - version of clip\n\
\t__SYSTEM__	string - name of operating system\n\
\t__DATE__      string - date in format 'MON DD YYYY'\n\
\t__TIME__      string - current time in format 'HH:MM::SS'\n\
\t__CLIP_MODULE__      string - name of current locale module\n\
",
					prgname, CC, CFLAGS, COMPILE_FLAG, COPT, CDBG, OUT_FLAG,
					INCLUDE_FLAG, OBJSUF,
					SOBJSUF, LIBSUF, SLIBSUF, SFLAGS, CLIPLIB, CLIPSLIB,
					CLIPLIBS, CLIPROOT, CLIP_MODULE);
				exit(2);
			}
		case 'V':
			printVersion(stdout);
			fprintf(stdout, "\n");
			exit(0);
		}
	}
	optind--;
}

static char *
diff_clock(clock_t beg, clock_t end)
{
	static char buf[32];
	clock_t diff = end - beg;
	int /*m, */ s, ms;

	s = diff / CLK_TCK;
	ms = (diff % CLK_TCK) * 100 / CLK_TCK;
	/*m=s/60;
	   s=s%60; */
	sprintf(buf, "%d.%02ds", s, ms);
	return buf;
}

static char **ovect = 0;
static int onum = 0;

static void
add_name(const char *name)
{
	char buf[256], *e, *s;

	if (!name || !*name)
		return;

	strcpy(buf, name);
	e = strrchr(buf, '.');
	s = strrchr(buf, '/');
	if (e && (!s || e > s))
	{
		if (!strcasecmp(e, ".c") || !strcasecmp(e, ".cc") || !strcasecmp(e, ".prg"))
			strcpy(e, OBJSUF);
		else if (!strcasecmp(e, OBJSUF) || !strcasecmp(e, SOBJSUF)
			 || !strcasecmp(e, LIBSUF) || !strcasecmp(e, SLIBSUF))
			;
		else if (!strcasecmp(e, ".po") || !strcasecmp(e, ".pa"))
			goto o_nam;
		else if (buf[0] == '-' && buf[1] == 'l')
			;
		else
			return;
	}
	else
	{
		/*e = buf + strlen(buf);
		   strcpy(e, OBJSUF); */
	#ifndef STD_LIBDIR
		if (name[0]=='-' && name[1]=='l')
		{
			snprintf(buf, sizeof(buf), "%s/lib/lib%s" DLLSUFF, CLIPROOT, name + 2);
			if (access(buf, R_OK))
				strncpy(buf, name, sizeof(buf));
		}
	#endif
	}

	ovect = (char **) realloc(ovect, sizeof(char *) * (onum + 1));

	ovect[onum] = strdup(buf);
	++onum;
      o_nam:
	if (!oname)
	{
		strcpy(buf, name);
		e = strrchr(buf, '.');
		s = strrchr(buf, '/');
		if (e && (!s || e > s))
			*e = 0;
		else
			e = buf + strlen(buf);
		#if 0
		if (shared_flag && !exec_flag)
			strcpy(e, SOBJSUF);
		#endif
		oname = strdup(buf);
	}
}

char *__progname;

static void
lib_name(char *buf, int buflen, char *root, char *prefix, char *e, int elen)
{
	if ( ( !root || !root[0] ) && elen>3 && !memcmp(e,"lib", 3) )
	{
		int l;
		char *s = strrchr(e+3, '.');
		if (s)
			l = s-(e+3);
		else
			l = elen -3;
		snprintf(buf, buflen, "-l%.*s", l, e+3);
	}
	else if ( !root || !root[0] || e[0] == '/' || (e[0]=='.'&&e[1]=='/') || (e[0]=='.'&&e[1]=='.'&&e[2]=='/') )
		snprintf(buf, buflen, "%.*s", elen, e);
	else
		snprintf(buf, buflen, "%s/%s/%.*s", root, prefix, elen, e);
}

static void
init_module(void)
{
	char path[256], *s;
	if (! getcwd(path, sizeof(path)))
	{
		CLIP_MODULE = "root";
		return;
	}

	s = strrchr(path, '/');
	if (s)
		s++;
	else
		s = path;

	if (!strcmp(s, "/"))
		s = "root";

	CLIP_MODULE = strdup(s);
}


static void
write_names(File *file)
{
	char path[256];
        char *e;
        int l;
        FILE *out;
        int i;

	if (!names_flag)
        	return;

	snprintf(path, sizeof(path), "%s", file->cname);
        e = strrchr(path, '.');
        if (e)
		l = e - path;
	else
        	l = strlen(path);
	

	snprintf(path + l, sizeof(path) - l, ".nm");

	out = fopen(path, "wt");
        if (out)
        {
        	for(i=0; i < file->functions.count; i++)
                {
                	Function *fp = (Function*) file->functions.items[i];
                        if (fp->isPublic != 1)
                        	continue;
                        fprintf(out, "%s\n", fp->name);
                }
        	fclose(out);
        }
        else
        	yywarning("cannot open defname file '%s': %s", path, strerror(errno));

	snprintf(path + l, sizeof(path) - l, ".ex");

	out = fopen(path, "wt");
        if (out)
        {
        	for(i=0; i < file->undeclExternFunctions.count; i++)
                {
                	char *s = (char*) file->undeclExternFunctions.items[i];
                        fprintf(out, "%s\n", s);
                }
        	fclose(out);
        }
        else
        	yywarning("cannot open exname file '%s': %s", path, strerror(errno));

}

static void
check_names(Coll *ex, Coll *nm)
{
	int i;
        char *s;

	if (!names_flag)
        	return;

        for(i=0; i < ex->count; i++)
        {
        	int no;
        	s = (char*) ex->items[i];
                if (!search_Coll(nm, s, &no))
                	yywarning("possible not defined function %s", s);
        }
}

int
main(int argc, char **argv)
{
	int /*ch, */ i, ii, ret, err_flag = 0;
	clock_t beg, end, Beg, End;
	int files = 0;
	struct tms ts;
	char buf[256];
	char *e;

	prgname = strrchr(argv[0], '/');

	if (prgname)
		prgname++;
	else
		prgname = argv[0];

	e = getenv("CLIP_HOSTCS");
	if (e && *e)
	{
		sourceCharset = targetCharset = strdup(e);
	}
	else if (!e)
	{
		e = getenv("CLIP_LANG");
                if ( e == NULL )
			e = getenv("LANG");
		if (!e || !*e || !strcmp(e, "C") )
			e = getenv("LC_MESSAGES");
		if (!e || !*e || !strcmp(e, "C") )
			e = getenv("LC_ALL");
		if (e && *e)
		{
			char *s = strrchr(e, '.');
			if (s)
			{
				snprintf(buf, sizeof(buf), "%s", s+1);
				for(s=buf; *s; s++)
					*s = tolower(*s);
				sourceCharset = targetCharset = strdup(buf);
			}
		}
	}

	if (!sourceCharset)
		sourceCharset = targetCharset = strdup("c");

	getEnvironment();

	init_Coll(&includePaths, NULL, NULL);
	insert_Coll(&includePaths, ".");
	snprintf(buf, sizeof(buf), "%s/include", CLIPROOT);
	insert_Coll(&includePaths, strdup(buf));
	init_Coll(&lib_dirs, NULL, NULL);
	init_Coll(&arglibs, NULL, NULL);
#ifdef STD_LIBDIR
	snprintf(buf, sizeof(buf), "/usr/lib");
	insert_Coll(&lib_dirs, strdup(buf));
#endif
	snprintf(buf, sizeof(buf), "%s/lib", CLIPROOT);
	insert_Coll(&lib_dirs, strdup(buf));
	init_Coll(&predefines, NULL, NULL);
	init_Coll(&poName, NULL, NULL);
	init_Coll(&paName, NULL, NULL);
	init_Coll(&include_files, NULL, NULL);

	snprintf(buf, sizeof(buf), "__CLIP__=\"%s\"", CLIP_VERSION);
	append_Coll(&predefines, strdup(buf));

	init_module();

	{
		char buf[256], *s;

		s = getenv("HOME");
		if (s && *s)
		{
			snprintf(buf, sizeof(buf), "%s/.cliprc", s);
			getrc(buf);
		}

	}

	getrc(".cliprc");

	{
		char buf[256], *s;
		DIR *dp;

		s = CLIPROOT;
		if (s && *s)
		{
			snprintf(buf, sizeof(buf), "%s/.cliprc", s);
			getrc(buf);
		}

		snprintf(buf, sizeof(buf), "%s/cliprc", CLIPROOT);
		dp = opendir(buf);
		if (dp)
		{
			struct dirent *ep;
			struct stat st;
			Coll files;
			int i;

			init_Coll(&files, free, strcmp);
			while( (ep=readdir(dp)) )
			{
				snprintf(buf, sizeof(buf), "%s/cliprc/%s", CLIPROOT, ep->d_name);
				if ( stat(buf, &st) )
					continue;
				if ( ! S_ISREG(st.st_mode) )
					continue;
				if ( access(buf, R_OK) )
					continue;
				insert_Coll(&files, strdup(buf));
			}
			closedir(dp);

			for(i=0; i<files.count; i++)
			{
				char *name = (char*) files.items[i];
				getrc(name);
			}

			destroy_Coll(&files);
		}
	}

	argc--;
	argv++;
	get_opt(argc, argv);

	argc -= optind;
	argv += optind;

	if (err_flag)
		return 1;

	if (syntax_tree_flag)
	{
		write_obj_flag = 0;
		codegen_flag = 1;
	}

	if (!write_obj_flag)
	{
		/*codegen_flag = 0; */
		compile_flag = 0;
	}
	if (preproc_flag)
	{
		write_obj_flag = 0;
		codegen_flag = 0;
		syntax_tree_flag = 0;
		compile_flag = 0;
		exec_flag = 0;
		pcode_flag = 0;
		pc_flag = 0;
		shared_flag = 0;
	}

	if (pcode_flag)
	{
		pc_flag = 0;
		shared_flag = 0;
	}

	if (pc_flag)
		pcode_flag = 1;

#if 0
	if (shared_flag && pcode_flag)
	{
		v_printf(0, "conflict between -s and -p flags\n");
		exit(1);
	}
#endif

	if (pcode_flag && c_flag)
	{
		v_printf(0, "conflict between -c and -p flags\n");
		exit(1);
	}

	/*if ( exec_flag && !main_flag && !shared_flag)
	   {
	   v_printf(0, "-e(xec) flag without -M(ain) or -s(hared) flags\n");
	   exit(2);
	   } */

	if (pcode_flag)
	{
		compile_flag = 0;
	}

	if (nomain_flag && main_flag)
	{
		v_printf(0, "conflict between -n and -m flags\n");
		exit(1);
	}

	if (!exec_flag && oname)
        {
        	char *e;
                if (oname[0] == '/')
        		snprintf(buf, sizeof(buf), "%s", oname);
                else
        		snprintf(buf, sizeof(buf), "%s%s%s", outdir?outdir:"", outdir?"/":"", oname);
                e = strrchr(buf, '/');
                if (e)
                {
                	*e = 0;
        		outdir = strdup(buf);
        	}
        }

	if (!outdir)
        	outdir = ".";

        if (outdir)
        {
        	char cdir[256];
        	getcwd(cdir, sizeof(cdir));

		if (!chdir(outdir))
                {
                	getcwd(buf, sizeof(buf));
                        outdir = strdup(buf);
                	chdir(cdir);
                }
                else
                {
			yyerror("cannot change to output dir '%s': %s", outdir, strerror(errno) );
                        exit(1);
                }
        }

	if (!preproc_flag)
	{
		v_printf(2, "set source charset to %s\n", sourceCharset);
		v_printf(2, "set target charset to %s\n", targetCharset);
	}

	init_lex();
	init_parser();

	if (argc < 1)
		ii = -1;
	else
		ii = 0;

	Beg = times(&ts);
	if (argc > 0)
	{
		for (i = 0; i < argc; i++)
		{
			char *e;

			e = argv[i];
			if (e[0] == '-' && e[1] == 'L')
			{
				insert_Coll(&lib_dirs, strdup(e+2));
				continue;
			}
			e = strrchr(argv[i], '.');
			if (!e)
			{
				e = argv[i];
				if (e[0] == '-' && e[1] == 'l')
					/*append_Coll(&arglibs, strdup(e+2))*/;
				else
					yyerror("unknown file type '' file '%s'", argv[i]);
				continue;
			}
			else if (!strcasecmp(e, ".po"))
				insert_Coll(&poName, strdup(argv[i]));
			else if (!strcasecmp(e, ".pa"))
				insert_Coll(&paName, strdup(argv[i]));
			else if (strcasecmp(e, ".prg")
				 && strcasecmp(e, ".c")
				 && strcasecmp(e, ".cc")
				 && strcasecmp(e, OBJSUF)
				 && strcasecmp(e, SOBJSUF)
				 && strcasecmp(e, ".a")
				 && strcasecmp(e, ".lib")
				)
			{
				yywarning("unknown file type '%s' file '%s'", e, argv[i]);
				continue;
			}
		}
	}

	for (; clic_errorcount == 0 && ii < argc; ii++)
	{
		++files;
		if (ii < 0)
		{
			v_printf(1, "no input files, so use stdin; -h will help\n");
			fflush(stderr);
			set_locale_name("stdin");
			ret = clic_parse("stdin", stdin);
			add_name("stdin");
		}
		else
		{
			char *e;

			e = strrchr(argv[ii], '.');
			add_name(argv[ii]);

			if (!e)
				continue;
			else if (!strcasecmp(e, ".c") || !strcasecmp(e, ".cc") || !strcasecmp(e, ".cpp"))
			{
				if (!preproc_flag)
				{
					v_printf(1, "process file '%s' ..", argv[ii]);
					v_neednl = 1;
				}

				beg = times(&ts);
				compile_CFile(argv[ii]);
				end = times(&ts);

				if (!preproc_flag)
				{
					v_neednl = 0;
					if (clic_errorcount == 0)
						v_printf(1, ".. done, %s\n", diff_clock(beg, end));
					else
						v_printf(1, "%d errors\n", clic_errorcount);
				}
				continue;
			}
			else if (strcasecmp(e, ".prg"))
			{
				continue;
			}

			if (ii > 0)
				main_flag = 0;

			if (!preproc_flag)
			{
				v_printf(1, "parsing file '%s' ..", argv[ii]);
				v_neednl = 1;
			}
			beg = times(&ts);
			set_locale_name(argv[ii]);
			ret = clic_parse(argv[ii], 0);
			end = times(&ts);

			if (!preproc_flag)
			{
				v_neednl = 0;
				if (clic_errorcount == 0)
					v_printf(1, ".. done (%d/%d lines, %d warnings, %s)\n", clic_line, all_lines, clic_warncount, diff_clock(beg, end));
				else
					v_printf(1, "%d errors, %d warnings\n", clic_errorcount, clic_warncount);
			}
		}
		if (ret)
			break;

		if (clic_errorcount == 0 && codegen_flag)
		{
			v_printf(2, "codegen file '%s' ..", curFile->name);
			v_neednl = 1;
			beg = times(&ts);
			codegen_File(curFile);
			end = times(&ts);
			v_neednl = 0;
			if (clic_errorcount == 0)
				v_printf(2, ".. done, %s\n", diff_clock(beg, end));
			else
				v_printf(2, "%d errors\n", clic_errorcount);
		}
		if (clic_errorcount == 0 && syntax_tree_flag)
		{
			print_File(curFile);
		}
		if (clic_errorcount == 0 && write_obj_flag)
		{
			if (pcode_flag)
			{
				long len;

				v_printf(1, "writing file '%s' ..", curFile->s_cname);
				v_neednl = 1;
				beg = times(&ts);
				write_OFile(curFile, &len);
                                write_names(curFile);
				end = times(&ts);
				v_neednl = 0;
				if (clic_errorcount == 0)
					v_printf(1, ".. done, %ld bytes ,%s\n", len, diff_clock(beg, end));
				else
					v_printf(1, "%d errors\n", clic_errorcount);
			}
			else
			{
				v_printf(2, "writing file '%s' ..", curFile->s_cname);
				v_neednl = 1;
				write_File(curFile);
                                write_names(curFile);
				v_neednl = 0;
				if (clic_errorcount == 0)
					v_printf(2, ".. done\n");
				else
					v_printf(2, "%d errors\n", clic_errorcount);
			}
		}

		if (clic_errorcount == 0 && (compile_flag || pc_flag))
		{
			if (ii)
				main_flag = 0;
			v_printf(1, "compile file '%s' ..", curFile->s_cname);
			v_neednl = 1;
			beg = times(&ts);
			compile_File(curFile->cname);
			end = times(&ts);
			v_neednl = 0;
			if (clic_errorcount == 0)
				v_printf(1, ".. done, %s\n", diff_clock(beg, end));
			else
				v_printf(1, "%d errors\n", clic_errorcount);

			if (clic_errorcount == 0 && shared_flag && !exec_flag )
			{
				v_printf(1, "make shared object '%s' ..", curFile->s_cname);
				v_neednl = 1;
				beg = times(&ts);
				share_File(curFile->cname);
				end = times(&ts);
				v_neednl = 0;
				if (clic_errorcount == 0)
					v_printf(1, ".. done, %s\n", diff_clock(beg, end));
				else
					v_printf(1, "%d errors\n", clic_errorcount);

			}
		}

		if (ii < 0)
			break;

		delete_File(curFile);
		curFile = NULL;
	}

	if (clic_errorcount == 0 && exec_flag)
	{
		char cmd[1024*8], *e;
		char cfuncname[256];
		char* libroot;
		int i;
                Coll ex, nm;

		init_Coll(&ex, free, strcasecmp);
		init_Coll(&nm, free, strcasecmp);
#ifdef STD_LIBDIR
		libroot = 0;
#else
		libroot = CLIPROOT;
#endif

		++files;
#ifdef STD_LIBDIR
		if (eshared_flag||shared_flag)
		{
			snprintf(cmd, sizeof(cmd), "-lclip");
			add_name (cmd);
		}
		else
#endif
		{
			e = (eshared_flag||shared_flag) ? CLIPSLIB : CLIPLIB;
			lib_name(cmd, sizeof(cmd), libroot, "lib", e, strlen(e));
			add_name(cmd);
		}
		for(e=CLIPLIBS;*e;)
		{
			int l;
			l = strspn(e, " \t");
			e += l;
			l = strcspn(e, " \t");
			if (!l)
				break;
			lib_name(cmd, sizeof(cmd), libroot, "lib", e, l);
			add_name(cmd);
			e += l;
		}
		for(e=ADDLIBS;*e;)
		{
			int l;
			l = strspn(e, " \t");
			e += l;
			l = strcspn(e, " \t");
			if (!l)
				break;
			memcpy(cmd, e, l);
			cmd[l] = 0;
			add_name(cmd);
			e += l;
		}
		add_name(MATHLIB);
		add_name(DLLIB);

		/* generate _cfunctions */
		sprintf(cfuncname, "%s_ref.c", oname);
		v_printf(1, "generate reference file '%s' ..", cfuncname);
		v_neednl = 1;
		beg = times(&ts);
		write_Cfunc(cfuncname, onum, ovect, &ex, &nm);
                check_names(&ex, &nm);
		end = times(&ts);
		v_neednl = 0;
		if (clic_errorcount == 0)
			v_printf(1, ".. done, %s\n", diff_clock(beg, end));
		else
			v_printf(1, "%d errors\n", clic_errorcount);
		if (clic_errorcount)
			goto end;

		sprintf(cmd, "%s", CC);
		for (e = cmd + strlen(cmd), i = 0; i < includePaths.count; ++i)
		{
			sprintf(e, " %s %s", INCLUDE_FLAG, (char *) includePaths.items[i]);
			e = cmd + strlen(cmd);
		}

		for (e = cmd + strlen(cmd), i = 0; i < lib_dirs.count; ++i)
		{
			sprintf(e, " -L%s", (char *) lib_dirs.items[i]);
			e = cmd + strlen(cmd);
		}

		sprintf(cmd + strlen(cmd), " %s %s %s %s %s %s", optLevel ? COPT : "", genDebug ? CDBG : "",
			CFLAGS, cfuncname, OUT_FLAG, oname);
		for (e = cmd + strlen(cmd), i = 0; i < onum; ++i)
		{
			sprintf(e, " %s", ovect[i]);
			e = cmd + strlen(cmd);
		}

		v_printf(1, "make file '%s' ..", oname);
		v_neednl = 1;
		beg = times(&ts);
		v_printf(2, "%s\n", cmd);
		if (system(cmd))
			yyerror("C level error in command: %s", cmd);
		else if (rmc_flag)
			unlink(cfuncname);

		end = times(&ts);
		v_neednl = 0;
		if (clic_errorcount == 0)
			v_printf(1, ".. done, %s\n", diff_clock(beg, end));
		else
			v_printf(1, "%d errors\n", clic_errorcount);
	}

      end:
	End = times(&ts);

	resume_parser();
	resume_lex();
	resume_locale();

	if (!preproc_flag)
		v_printf(1, "clip: %d files, %s\n", files, diff_clock(Beg, End));
	return clic_errorcount == 0 ? 0 : 1;
}
