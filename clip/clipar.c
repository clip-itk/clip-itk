/*
    Copyright (C) 2001  ITK
    Author   : Paul Lasarev <paul@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
   $Log$
   Revision 1.1  2006/06/22 19:01:32  itk
   uri: initial

   Revision 1.20  2003/09/08 15:06:02  clip
   uri: next step fixes for mingw from uri

   Revision 1.19  2003/09/05 12:11:52  clip
   uri: initial fixes for mingw+win32 from uri

   Revision 1.18  2003/04/08 09:30:42  clip
   pcode sequience
   closes #134
   paul

   Revision 1.17  2001/10/29 06:51:21  clip
   fix text fopen modes
   paul

   Revision 1.16  2001/08/28 06:18:34  clip
   -s configure flag
   uninitalized var warnings with optimesed compile
   paul

   Revision 1.15  2001/04/03 09:17:00  clip
   license errors
   paul

   Revision 1.14  2001/03/30 11:51:03  clip
   add copyright

   Revision 1.13  2000/05/24 18:34:09  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.12  2000/05/03 19:32:34  clip
   add prefix 'clip_' to all clip functions

   Revision 1.11  2000/04/28 19:01:10  clip
   tmpname fix

   Revision 1.10  2000/04/28 17:55:24  clip

   bsd fixes

   Revision 1.9  2000/04/20 20:15:47  paul
   *** empty log message ***

   Revision 1.8  2000/04/12 20:24:43  paul
   init in .po switched off

   Revision 1.7  2000/04/12 15:10:46  paul
   cmd line - opt flags

   Revision 1.6  2000/04/07 14:37:23  paul
   EMPTY

   Revision 1.5  2000/04/04 22:00:45  paul
   module length

   Revision 1.4  2000/04/04 18:46:40  paul
   clipar

   Revision 1.3  2000/03/03 21:37:35  paul
   preprocessor bug fix, warnings removed

   Revision 1.2  1999/10/26 19:11:19  paul
   start cvs logging

 */

#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdarg.h>
#include <time.h>
#include <ctype.h>
#include "coll.h"
#include "clipcfg.h"

#ifdef OS_MINGW
	#include "getopt.h"
#endif

extern char *optarg;
extern int optind;

static int table_flag = 0;
static int c_flag = 0, verbose_level = 0;

static int print_table(char *arname);
static int make_c_file(char *arname, int argc, char **argv);
static int make_pa_file(char *arname, int argc, char **argv);
static void v_printf(int level, const char *fmt,...);

static char tmp_file[255];

int
main(int argc, char **argv)
{
	int ch, i;
	char *arname;

	tmp_file[0] = 0;
	while ((ch = getopt(argc, argv, "tchVv")) != EOF)
		switch (ch)
		{
		case 'V':
			printf("0.1\n");
			exit(0);
		case 'v':
			verbose_level++;
			break;
		case 't':
			table_flag = 1;
			break;
		case 'c':
			c_flag = 1;
			break;
		case 'h':
		      usage:
		default:
			printf("usage: clipar [-tcvV] <file>.pa [<file>.po|<file>.pa...]\n");
			printf("\t-t print table of archive\n");
			printf("\t-c make C file\n");
			printf("\t-v increase verbose level\n");
			printf("\t-V print version and exit\n");
			exit(1);
		}
	argc -= optind;
	argv += optind;

	if (table_flag && argc < 1)
		goto usage;

	if (table_flag)
	{
		for (i = 0; i < argc; ++i)
		{
			if (argc > 1)
				v_printf(0, "file '%s' table:\n", argv[i]);
			print_table(argv[i]);
		}
		return 0;
	}

	arname = argv[0];
	argv++;
	argc--;

	if (argc < 1)
		goto usage;

	if (c_flag)
		return make_c_file(arname, argc, argv);

	return make_pa_file(arname, argc, argv);
}

static void
error(const char *fmt,...)
{
	va_list ap;

	va_start(ap, fmt);
	fprintf(stderr, "clipar: ");
	vfprintf(stderr, fmt, ap);
	fputc('\n', stderr);
	va_end(ap);
	if (tmp_file[0])
		unlink(tmp_file);
	exit(3);
}

static void
v_printf(int level, const char *fmt,...)
{
	va_list ap;

	va_start(ap, fmt);
	if (level > verbose_level)
		return;
	vfprintf(stdout, fmt, ap);
	va_end(ap);
}

#define M_OFFS(base,nl,ns) ((base)+8+nl*sizeof(long)+ns*sizeof(short))
#define F_OFFS(fp,nl,ns,nb) ((fp)+nl*sizeof(long)+ns*sizeof(short)+nb)

static char *
read_module(FILE * file)
{
	char *ret = 0;
	char mag[8];
	long beg = ftell(file);
	long l;
	char *filename;

	if (fread(mag, 8, 1, file) != 1)
	{
		if (feof(file))
			return 0;
		goto ferr;
	}
	if (memcmp(mag, "!<pobj>\n", 8))
		error("invalid magic number");
	if (fread(&l, sizeof(l), 1, file) != 1)
		goto ferr;
	if (fread(&l, sizeof(l), 1, file) != 1)
		goto ferr;
	l += 8 + 2 * sizeof(long);

	fseek(file, beg, SEEK_SET);
	ret = malloc(l);
	if (fread(ret, l, 1, file) != 1)
		goto ferr;
	filename = M_OFFS(ret, 8,6/*7, 7*/);

	v_printf(2, "read module %s: %ld bytes\n", filename, l);

	return ret;
      ferr:
	error("unexpected error: %s", strerror(errno));
	return 0;
}

static int
print_table(char *arname)
{
	FILE *file = fopen(arname, "rb");
	char *modp;

	if (!file)
		error("cannot open file '%s': %s", arname, strerror(errno));

	while ((modp = read_module(file)))
	{
		char *modbeg = M_OFFS(modp, 2, 0);
		int j;
		int modlen = *(long *) M_OFFS(modp, 1, 0);
		int funcnum = *(long *) M_OFFS(modp, 5, 2);
		int pubnum = *(long *) M_OFFS(modp, 4, 2);
		int initnum = *(short *) M_OFFS(modp, 8,4/*7, 5*/);
		int exitnum = *(short *) M_OFFS(modp, 8,5/*7, 6*/);
		time_t ts = *(long *) M_OFFS(modp, 0, 0);
		char *filename = M_OFFS(modp, 8,6/*7, 7*/);
		long funcOffs = *(long *) M_OFFS(modp, 7,4/*6, 5*/);
		long *fp = (long *) (modbeg + funcOffs);

		v_printf(0, "%s: %d byte %d func %d pub %d inits %d exits %s", filename, modlen + 8 + 2 * sizeof(long), funcnum, pubnum, initnum, exitnum, ctime(&ts));

		for (j = 0; j < funcnum; ++j, fp += 2)
		{
			v_printf(1, "\t%d:\thash=0x%x\toffs=%ld\n", j, fp[0], fp[1]);
		}

		free(modp);
	}

	fclose(file);
	return 0;
}

static void
read_file(char *name, Coll * cp, Coll * readed)
{
	FILE *file = fopen(name, "rb");
	char *modp;
	int j;

	if (!file)
		error("cannot open file '%s': %s", name, strerror(errno));

	for (j = 0; (modp = read_module(file)); ++j)
	{
		/*char *modbeg = M_OFFS(modp, 2, 0);*/
		char *filename = M_OFFS(modp, 8,6/*7, 7*/);
		char *e = strrchr(filename, '.');

		if (!readed)
		{
			/* all modules */
			append_Coll(cp, modp);
			continue;
		}

		/* skip internal .pa headers */
		if (e && !strcmp(e, ".pa"))
			continue;
		/* skip duplicated modules */
		if (!insert_Coll(readed, filename))
			continue;
		append_Coll(cp, modp);
	}
	v_printf(1, "read file '%s': %d modules\n", name, j);

	fclose(file);
}

static void
fwerr(FILE * file)
{
	fclose(file);
	error("write error: %s", strerror(errno));
}

static void
write_short(FILE * file, short s)
{
	if (fwrite(&s, sizeof(s), 1, file) != 1)
		fwerr(file);
}

static void
write_long(FILE * file, long s)
{
	if (fwrite(&s, sizeof(s), 1, file) != 1)
		fwerr(file);
}

static void
write_str(FILE * file, char *str)
{
	int len = strlen(str);

	if (fwrite(str, len + 1, 1, file) != 1)
		fwerr(file);
}

static void
write_buf(FILE * file, char *buf, int len)
{
	if (fwrite(buf, len, 1, file) != 1)
		fwerr(file);
}

typedef struct
{
	long hash;
	long offs;
}
OffsEntry;

static int
cmp_OffsEntry(void *p1, void *p2)
{
	OffsEntry *o1 = (OffsEntry *) p1;
	OffsEntry *o2 = (OffsEntry *) p2;

	if (o1->hash < o2->hash)
		return -1;
	else if (o1->hash > o2->hash)
		return 1;
	else
		return 0;
}

static int
make_pa_file(char *arname, int argc, char **argv)
{
	Coll coll;
	Coll offs;
	Coll inits, exits;
	Coll readed;
	int i;
	long npub, nstat, modpos;
	short ninit, nexit;
	FILE *file;
	time_t ts;
	long mod_len, mod_beg, func_Offs, fp, end;

	init_Coll(&coll, free, NULL);
	init_Coll(&offs, NULL, cmp_OffsEntry);
	init_Coll(&inits, NULL, NULL);
	init_Coll(&exits, NULL, NULL);
	init_Coll(&readed, NULL, strcmp);
	for (i = 0; i < argc; ++i)
		read_file(argv[i], &coll, &readed);

	npub = 0;
	ninit = 0;
	nexit = 0;
	nstat = 0;
	modpos = 0;
	for (i = 0; i < coll.count; ++i)
	{
		char *modp = (char *) coll.items[i];
		char *modbeg = M_OFFS(modp, 2, 0);
		long modlen = *(long *) M_OFFS(modp, 1, 0);
		long funcOffs = *(long *) M_OFFS(modp, 7,4/*6, 5*/);
		long *f_p = (long *) (modbeg + funcOffs);
		long funcnum = *(long *) M_OFFS(modp, 4, 2);

		/*long allnum = *(long *) M_OFFS(modp, 5, 2); */
		short initnum = *(short *) M_OFFS(modp, 8,4 /*7, 5*/);
		short exitnum = *(short *) M_OFFS(modp, 8,5 /*7, 6*/);
		long statnum = *(long *) M_OFFS(modp, 3, 0);
		long *statOffs = (long *) M_OFFS(modp, 2, 0);
		int j;

		*statOffs = nstat;
		nstat += statnum;
		modpos += 8 + 2 * sizeof(long);

		for (j = 0; j < funcnum; ++j)
		{
			OffsEntry *op = malloc(sizeof(OffsEntry));

			op->hash = *f_p;
			++f_p;
			op->offs = *f_p + modpos;
			++f_p;
			insert_Coll(&offs, op);
		}
		for (j = 0; j < initnum; ++j)
		{
			OffsEntry *op = malloc(sizeof(OffsEntry));

			op->hash = *f_p;
			++f_p;
			op->offs = *f_p + modpos;
			++f_p;
			insert_Coll(&inits, op);
		}
		for (j = 0; j < exitnum; ++j)
		{
			OffsEntry *op = malloc(sizeof(OffsEntry));

			op->hash = *f_p;
			++f_p;
			op->offs = *f_p + modpos;
			++f_p;
			insert_Coll(&exits, op);
		}

		modpos += modlen;
	}
	npub = offs.count;
	ninit = inits.count;
	nexit = exits.count;

	file = fopen(arname, "wb");
	if (!file)
		error("cannot open file '%s': %s", arname, strerror(errno));

	time(&ts);
	v_printf(1, "write file '%s', %d func\n", arname, npub);

	write_buf(file, "!<pobj>\n", 8);
	write_long(file, ts);
	mod_len = ftell(file);
	write_long(file, 0);
	mod_beg = ftell(file);
	write_long(file, 0);
	write_long(file, nstat);
	write_short(file, 0);
	write_short(file, 0);
	write_long(file, npub);
	write_long(file, npub + ninit + nexit);
	write_short(file, 0);
	write_short(file, 0);
	write_long(file, 0);
	func_Offs = ftell(file);
	write_long(file, 0);
	write_short(file, ninit);
	write_short(file, nexit);
	write_str(file, arname);
	/* func    */

	fp = ftell(file);

	modpos = fp - mod_beg + (npub + ninit + nexit) * sizeof(long) * 2;

	for (i = 0; i < offs.count; ++i)
	{
		OffsEntry *op = (OffsEntry *) offs.items[i];

		write_long(file, op->hash);
		write_long(file, op->offs + modpos);
	}
	for (i = 0; i < inits.count; ++i)
	{
		OffsEntry *op = (OffsEntry *) inits.items[i];

		write_long(file, op->hash);
		write_long(file, op->offs + modpos);
	}
	for (i = 0; i < exits.count; ++i)
	{
		OffsEntry *op = (OffsEntry *) exits.items[i];

		write_long(file, op->hash);
		write_long(file, op->offs + modpos);
	}

	end = ftell(file);
	fseek(file, mod_len, SEEK_SET);
	write_long(file, end - mod_beg);
	fseek(file, func_Offs, SEEK_SET);
	write_long(file, fp - mod_beg);
	fseek(file, end, SEEK_SET);

	for (i = 0; i < coll.count; ++i)
	{
		char *modp = (char *) coll.items[i];
		long modlen = *(long *) M_OFFS(modp, 1, 0);
		modlen += 8 + 2 * sizeof(long);

		write_buf(file, modp, modlen);
	}

	end = ftell(file);
	/*
	   fseek(file, mod_len, SEEK_SET);
	   write_long(file, end-mod_beg);
	 */
	v_printf(1, "done, %ld bytes\n", end);
	fclose(file);
	return 0;
}

static int
make_c_file(char *Arname, int argc, char **argv)
{
	int ret = 0, i;
	Coll coll;
	char *modp, *modbeg;
	FILE *file = 0;
	time_t ts;
	char name[64], *e, *s, arname[256];
	int nstatics;
	long size;

	strncpy(arname, Arname, sizeof(arname));
	s = strrchr(arname, '/');
	if (!s)
		s = arname;
	e = strrchr(s, '.');
	if (!e)
		e = s + strlen(s);
	strcpy(e, ".c");

#if 0
	tmpnam(tmp_file);
	strcat(tmp_file, ".pa");
#else
	/*snprintf(tmp_file, sizeof(tmp_file), "/tmp/clipar.XXXXXX");
	   mktemp(tmp_file);
	   strcat(tmp_file, ".pa"); */
	snprintf(tmp_file, sizeof(tmp_file), "/tmp/clipar.%lx%lx.pa", (long) getpid(), (long) random());
#endif

	if (make_pa_file(tmp_file, argc, argv))
		goto err;

	init_Coll(&coll, free, NULL);

	read_file(tmp_file, &coll, NULL);
	if (coll.count < 1)
		error("%s have no modules", tmp_file);

	file = fopen(arname, "wb");
	if (!file)
		error("cannot open file '%s': %s", arname, strerror(errno));

	v_printf(0, "write file '%s'\n", arname);

	fprintf(file, "/*\n");
	fprintf(file, " *\tfile '%s', \n", arname);
	fprintf(file, " *\tautomatically generated by clipar\n");
	fprintf(file, " *\tfrom sources:\n");
	for (i = 0; i < argc; ++i)
		fprintf(file, " *\t%s\n", argv[i]);
	time(&ts);
	fprintf(file, " *\tat %s", ctime(&ts));
	fprintf(file, " */\n");

	fprintf(file, "\n#include \"clip.h\"\n\n");

	s = strrchr(arname, '/');
	if (!s)
		s = arname;
	e = strrchr(s, '.');
	if (!e)
		e = s + strlen(s);
	strcpy(name, "clip__PCODE_");
	i = strlen(name);
	memcpy(name + i, s, e - s);
	name[i + (e - s)] = 0;

	modp = (char *) coll.items[0];
	modbeg = M_OFFS(modp, 2, 0);
	nstatics = *(long *) M_OFFS(modp, 3, 0);
	fprintf(file, "static ClipVar %s_statics[%d];", name, nstatics);

	fprintf(file, "\nstatic char %s_body[]=\n{\n", name);
	for (size = 0, i = 0; i < coll.count; ++i)
	{
		char *mp = (char *) coll.items[i];
		long modlen = *(long *) M_OFFS(mp, 1, 0);
		long j, k;

		modlen += 8 + 2 * sizeof(long);

		for (j = 0; j < modlen;)
		{
			fprintf(file, "\t");
			for (k = 0; k < 32 && j < modlen; ++j, ++k, ++size)
				fprintf(file, "%d,", mp[j]);
			fprintf(file, "\n");
		}
	}
	fprintf(file, "\n};\n");
	fprintf(file, "\nstruct ClipFile ");
	for (i = 0; i < (int)strlen(name); ++i)
		fputc(toupper(name[i]), file);
	fprintf(file, " =\n{\n");
	fprintf(file, "\t1,\n");
	fprintf(file, "\t%s_body,\n", name);
	fprintf(file, "\t%ld,\n", size);
	fprintf(file, "\t3,\n");
	fprintf(file, "\t\"%s\",\n", arname);
	fprintf(file, "\t%s_statics,\n", name);
	fprintf(file, "\t3,\n");
	fprintf(file, "\t0,\n");
	fprintf(file, "\t0,\n");
	fprintf(file, "};\n\n");

	for (i = 0; i < (int)strlen(name); ++i)
		name[i] = toupper(name[i]);

	fprintf(file, "\nClipModule %s_module =\n{\n ", name + 7);
	fprintf(file, "\t\"%s\",\n", name + 7);
	fprintf(file, "\t0,\n");
	fprintf(file, "\t0,\n");
	fprintf(file, "\t0,\n");
	fprintf(file, "\t&%s,\n", name);
	fprintf(file, "\t0,\n");
	fprintf(file, "\t0,\n");
	fprintf(file, "\t0,\n");
	fprintf(file, "};\n\n");

	v_printf(0, "done, %ld bytes\n", ftell(file));
	goto norm;
      err:
	ret = 1;
      norm:
	unlink(tmp_file);
	tmp_file[0] = 0;
	fclose(file);
	return ret;
}
