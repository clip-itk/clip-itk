/*
   $Log$
   Revision 1.1  2006/06/22 19:01:35  itk
   uri: initial

   Revision 1.12  2003/09/05 12:11:53  clip
   uri: initial fixes for mingw+win32 from uri

   Revision 1.11  2003/01/22 08:10:40  clip
   registration fix
   paul

   Revision 1.10  2002/11/06 12:55:44  clip
   fix plural/singular
   paul

   Revision 1.9  2002/11/01 07:54:13  clip
   load msg file bug fix
   paul

   Revision 1.8  2002/10/31 10:33:59  clip
   plural form runtime messages support:
   gettext(cMsgid [,cModule])->cTranslated
   ngettext(cMsgid, cMsgid_plural, nNum, [,cModule]) ->cTranslated
   paul

   Revision 1.7  2002/09/25 11:47:25  clip
   add function: loadModuleMsg(cModule, cFilename_mo) -> bResult
   predefined macro: __CLIP_MODULE__  expands to current module name as "modname"
   new accepted environment var: CLIP_LOCALE_ROOT
   	used by clip, clip_msgmerge, clip_msgfmt, and at runtime
   paul

   Revision 1.6  2000/12/11 09:47:15  clip
   append setlocale() call
   all libC string functions now must work correct with correct charsets
   paul

   Revision 1.5  2000/12/10 13:40:02  clip
   bug in .pot writing
   paul

   Revision 1.4  2000/12/10 10:58:03  clip
   pot string format
   paul

   Revision 1.3  2000/12/09 12:13:28  clip
   locale
   paul

   Revision 1.2  2000/12/08 15:27:07  clip
   locale
   paul

   Revision 1.1  2000/12/08 11:55:27  clip
   start localisation
   paul

 */
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#include "clic.h"
#include "clipcfg.h"

static FILE *out = 0;
static char *fname = 0, *mname = 0;
static char *file_name = 0;

#ifdef OS_MINGW
#define mkdir(D, M)	mkdir(D)
#endif

static int
make_dir(char *path)
{
	char dir[256];
	int r;

	strncpy(dir, path, sizeof(dir));
	r = mkdir(dir, 0775);
	if (r && errno == EEXIST)
		return 0;

	if (r)
	{
		char *s = strrchr(dir, '/');

		if (s)
		{
			*s = 0;
			r = make_dir(dir);
			if (r)
				yywarning("cannot create dir '%s': %s", dir, strerror(errno));
			else
			{
				strncpy(dir, path, sizeof(dir));
				if ((r = mkdir(dir, 0775)))
					yywarning("cannot create dir '%s': %s", dir, strerror(errno));
			}
			return r;
		}
		else
		{
			return -1;
		}
	}
	return 0;
}

static int
set_locale(void)
{
	char path[256], *s, *e;
	char *filename = file_name;

	if (out)
	{
		fclose(out);
		out = 0;
	}

	snprintf(path, sizeof(path), "%s/locale.pot/%s", CLIP_LOCALE_ROOT, CLIP_MODULE);

	if (make_dir(path))
	{
		file_name = 0;
		return -1;
	}

	snprintf(path, sizeof(path), "%s", filename);
	s = strrchr(path, '/');
	e = strrchr(path, '.');
	if (!s)
		s = path;
	if (e && e > path)
		*e = 0;

	free(fname);
	fname = strdup(s);

	snprintf(path, sizeof(path), "%s/locale.pot/%s/%s.pot", CLIP_LOCALE_ROOT, CLIP_MODULE, fname);
	mname = strdup(CLIP_MODULE);
	for (s = mname; *s; s++)
		*s = toupper(*s);

	out = fopen(path, "w");
	if (!out)
	{
		yywarning("cannot create file '%s': %s", path, strerror(errno));
		file_name = 0;
		return -1;
	}
	v_printf(1, "\nopen locale file '%s'\n", path);

	return 0;
}

int
set_locale_name(char *name)
{
	if (out)
	{
		fclose(out);
		out = 0;
	}
	file_name = strdup(name);
	return 0;
}

int
resume_locale(void)
{
	if (out)
	{
		fclose(out);
		out = 0;
	}
	return 0;
}

static int
put_char(FILE * out, int ch)
{
	switch (ch)
	{
	case '"':
		return fputs("\\\"", out);
	case '\n':
		return fputs("\\n\"\n\"", out);
	case '\r':
		return fputs("\\r", out);
	case '\v':
		return fputs("\\v", out);
	case '\t':
		return fputs("\\t", out);
	default:
		if (ch >= 0 && ch < 32)
		{
			char oct[5];

			sprintf(oct, "\\03%o", ch);
			return fputs(oct, out);
		}
		else
		{
			if (fputc(ch, out) == EOF)
				return EOF;
		}
	}
	return 0;
}

static int
put_str(FILE * out, char *str)
{
	for (; *str; ++str)
		if (put_char(out, *str) == EOF)
			return -1;
	return 0;
}

int
put_locale_string(char *name)
{
	if (!out && file_name)
		set_locale();
	if (!out)
		return 0;

	fprintf(out, "#: %s:%ld\n", file_name, clic_line);
	fprintf(out, "msgid \"");
	put_str(out, name);
	fprintf(out, "\"\n");
	fprintf(out, "msgstr \"\"\n\n");

	v_printf(2, "wrote locale message entry '%s'\n", name);
	return 0;
}

int
put_locale_string_plural(char *singular, char *plural)
{
	if (!out && file_name)
		set_locale();
	if (!out)
		return 0;

	fprintf(out, "#: %s:%ld\n", file_name, clic_line);
	fprintf(out, "msgid \"");
	put_str(out, singular);
	fprintf(out, "\"\n");
	fprintf(out, "msgid_plural \"");
	put_str(out, plural);
	fprintf(out, "\"\n");
	fprintf(out, "msgstr[0] \"\"\n");
	fprintf(out, "msgstr[1] \"\"\n\n");

	v_printf(2, "wrote plural locale message '%s' '%s'\n", singular, plural);

	/*put_locale_string(singular);*/
	/*put_locale_string(plural);*/

	return 0;
}


