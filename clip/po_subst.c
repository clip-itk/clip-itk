/*
	$Log: po_subst.c,v $
	Revision 1.9  2002/10/29 12:20:27  clip
	fixes for non-multibyte jade parser
	use 'make html NOUTF=1' for such case
	paul
	
	Revision 1.8  2002/10/24 13:05:44  clip
	tdoc: add English GPL text
	paul

*/
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <errno.h>
#include <time.h>
#include <iconv.h>

#include "coll.h"
#include "po_util.h"
#include "clipcfg.h"

typedef struct
{
	char *filename;
        char *charset;
        iconv_t cd;
	Coll ids;
}
PoFile;

static Coll po_files;

static int read_po_file(char *filename);

typedef struct
{
	FILE *out;
}
ParseData;

static int entry_handler(void *par, char *filename, int mline, char *txt);
static int norm_handler(void *par, char *txt, int len);

static int verbose = 0;
static char *prgname = "";
static char *filename = "stdin";
static char *encoding = 0;

void static
debug(int level, const char *fmt, ...)
{
	va_list ap;

	if (level > verbose)
		return;

	va_start(ap, fmt);
	fprintf(stderr, "%s: debug %d: ", prgname, level);
	vfprintf(stderr, fmt, ap);
	fprintf(stderr, "\n");
	fflush(stderr);

	va_end(ap);
}

int
main(int argc, char **argv)
{
	int r = 0, setout = 0;
	char *start = "\137(";
	char *stop = ")\137";
	int fnum = 0;
	FILE *in, *out;
	ParseData par;

	in = stdin;
	out = stdout;

	prgname = strrchr(argv[0], '/');
	if (prgname)
		++prgname;
	else
		prgname = argv[0];

	init_Coll(&po_files, 0, 0);

	for (++argv, --argc; argc > 0;)
	{
		char *ap;

		ap = argv[0];

		if (ap[0] == '-')
		{
			switch (ap[1])
			{
			default:
				fflush(stdout);
				fprintf(stderr, "unknown option: %s\n", ap);
				fflush(stderr);
			case 'h':
			case 'H':
				goto help;
			      err:
				fflush(stdout);
				fprintf(stderr, "invalid command string\n");
				fflush(stderr);
			      help:
				fprintf(stdout, "usage: %s [options] \n", prgname);
				fprintf(stdout, "\t-i <po_filename> filename of input translation, may be mutltiple times\n");
				fprintf(stdout,
					"\t-o <in_filename> <out_filename> template/result pair (stdin/stdout) \n");
				fprintf(stdout, "\t-s <start_string> start entry string (default is \"_(\")\n");
				fprintf(stdout, "\t-p <stop_string> stop entry string (default is \")_\")\n");
				fprintf(stdout, "\t-v<level> set verbose level\n");
				fprintf(stdout, "\t-u recode to utf-8\n");
				fprintf(stdout, "\t-e <encoding> recode to encoding\n");
				return 1;
			case 'u':
                        	encoding = "utf-8";
				break;
			case 'e':
				if (argc < 2 || argv[1][0] == '-')
					goto err;
				encoding = argv[1];
				debug(1, "set output encoding to '%s'", encoding);
				argc--;
				argv++;
				break;
			case 's':
				if (argc < 2 || argv[1][0] == '-')
					goto err;
				start = argv[1];
				debug(1, "set start string to '%s'", start);
				argc--;
				argv++;
				break;
			case 'p':
				if (argc < 2 || argv[1][0] == '-')
					goto err;
				stop = argv[1];
				debug(1, "set stop string to '%s'", stop);
				argc--;
				argv++;
				break;
			case 'v':
				if (ap[2])
					verbose = atoi(ap + 2);
				else
					++verbose;
				break;
			case 'i':
				if (argc < 2 || argv[1][0] == '-')
					goto err;
				debug(1, "read po file %s", argv[1]);
				if (read_po_file(argv[1]))
				{
					fprintf(stderr, "error reading po file '%s': %s\n", argv[1], strerror(errno));
					return 1;
				}
				argc--;
				argv++;
				break;
			case 'o':
                        	setout++;
				if (argc < 2 || argv[1][0] == '-')
					goto err;
				if (in != stdin)
					fclose(in);
				filename = argv[1];
				in = fopen(argv[1], "r");
				if (!in)
				{
					fprintf(stderr, "cannot open input file '%s': %s\n", argv[1], strerror(errno));
					return 1;
				}
				debug(1, "open input file %s", argv[1]);
				argc--;
				argv++;
				if (argc < 2 || argv[1][0] == '-')
					goto err;
				if (out != stdout)
					fclose(out);
				out = fopen(argv[1], "w");
				if (!out)
				{
					fprintf(stderr, "cannot open output file '%s': %s\n", argv[1], strerror(errno));
					return 1;
				}
				debug(1, "open output file %s", argv[1]);
				argc--;
				argv++;
				break;
			}

			++argv, --argc;
		}

		if (!setout)
			continue;

	      parse:

		if (!po_files.count)
			goto err;
		fnum++;
		par.out = out;
		r = po_parse_template(in, filename, start, stop, &par, entry_handler, norm_handler);
		if (r)
			return r;

		++argv, --argc;
	}

	if (!fnum)
		goto parse;

	return 0;
}

static int
read_po_file(char *filename)
{
	FILE *in;
	PoFile *fp;
	PoEntry *ep;
        int first = 1;

	in = fopen(filename, "r");
	if (!in)
		return errno;

	fp = (PoFile *) calloc(1, sizeof(PoFile));
	fp->filename = strdup(filename);
        fp->charset = "iso-8859-1";
        fp->cd = (iconv_t)(-1);
	init_Coll(&fp->ids, delete_PoEntry, cmp_PoEntry);

	while ((ep = po_read_entry(in)))
	{
        	if (first && ep->msg && !ep->msg[0] && ep->translated)
                {
                	char *s;
                	first = 0;
                	s = strstr(ep->translated, "charset=");
                        if (s)
                        {
                        	int l;
                        	s += 8;
				l=strcspn(s, "\r\n \t");
                                if (l)
                                {
                                	fp->charset = (char*) malloc(l+1);
                                        memcpy(fp->charset, s, l);
                                        fp->charset[l] = 0;

                                        debug(1, "found charset %s", fp->charset);
					if (encoding)
                                        {
                                        	fp->cd = iconv_open(encoding, fp->charset);
	                                        if (fp->cd == (iconv_t)(-1))
                                        		debug(0, "ERROR: cannot set output translation %s->utf-8", fp->charset);
                                        	else
                                        		debug(1, "set output translation %s->%s", fp->charset, encoding);
                                        }
                                }
                        }
                }
        	debug(2, "read entry %s:%s", ep->msg, ep->translated);
		insert_Coll(&fp->ids, ep);
	}

	append_Coll(&po_files, fp);

	fclose(in);

	return 0;
}

static char *
find_msg(char *id)
{
	PoEntry e;
	int i;

	e.msg = id;

	for (i = 0; i < po_files.count; i++)
	{
		int ind;
		PoFile *fp = (PoFile *) po_files.items[i];

		if (search_Coll(&fp->ids, &e, &ind))
		{
			PoEntry *ep;

			ep = (PoEntry *) fp->ids.items[ind];
			if (ep->translated && *ep->translated)
                        {
				if (fp->cd == (iconv_t)(-1))
					return ep->translated;
                                else
                                {
                                	static char *obuf = 0;
                                        static int obuflen = 0;
                                	int il, ol, l;
                                        char *is, *os;
                                	il = strlen(ep->translated);
					if (obuflen< il*4)
                                        {
                                        	obuflen = il * 4;
                                                obuf = (char*) realloc(obuf, obuflen);
                                        }


                                	is = ep->translated;
                                        os = obuf;
                                        ol = obuflen;
#ifdef OS_CYGWIN
                                	iconv(fp->cd, (const char **)&is, &il , &os, &ol);
#else
                                	iconv(fp->cd, &is, &il , &os, &ol);
#endif
                                        l = obuflen - ol;
                                        obuf[l] = 0;
                                        return obuf;
                                }
			}
		}
	}

	return id;
}

static int
entry_handler(void *par, char *filename, int mline, char *txt)
{
	ParseData *dp = (ParseData *) par;

	fprintf(dp->out, "%s", find_msg(txt));

	return 0;
}

static int
norm_handler(void *par, char *txt, int len)
{
	ParseData *dp = (ParseData *) par;

	fwrite(txt, 1, len, dp->out);

	return 0;
}
