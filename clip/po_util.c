/*
	$Log: po_util.c,v $
	Revision 1.7  2002/12/11 07:19:48  clip
	fix bug with '_' processing
	paul
	
	Revision 1.6  2002/11/18 10:53:28  clip
	fix bug with backslash in po_extr/po_subst utils
	paul
	
	Revision 1.5  2002/11/05 07:45:34  clip
	*** empty log message ***
	
	Revision 1.4  2002/11/04 10:21:57  clip
	po compatability mode for old gettext utils
	paul
	
	Revision 1.3  2002/10/24 13:05:44  clip
	tdoc: add English GPL text
	paul
	
*/
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <time.h>

#include "po_util.h"

#define COMPAT_DELIM '\177'

typedef enum
{
	E_Norm,
	E_Start,
	E_Msg,
	E_Stop,
}
ExtractState;

typedef struct
{
	char *ptr;
	int end;
	int size;
}
Buf;

static void put_Buf(Buf * bp, int ch);

static int max_num = 96;

static void
put_Buf(Buf * bp, int ch)
{
	if (bp->end == bp->size)
	{
		int delta;

		delta = bp->size / 4;
		if (delta < 32)
			delta = 32;
		bp->size += delta;
		bp->ptr = (char *) realloc(bp->ptr, bp->size);
	}

	bp->ptr[bp->end++] = ch;
}

int
cmp_PoEntry(void *p1, void *p2)
{
	PoEntry *ep1 = (PoEntry *) p1;
	PoEntry *ep2 = (PoEntry *) p2;

	return strcmp(ep1->msg, ep2->msg);
}

PoEntry *
new_PoEntry(char *msg, char *file, int line, PoEntry * pp)
{
	PoEntry *rp;

	rp = (PoEntry *) calloc(1, sizeof(PoEntry));

	if (msg)
		rp->msg = strdup(msg);
	else
		rp->msg = 0;

	if (file)
		rp->file = strdup(file);
	else
		rp->file = 0;

	rp->line = line;

	rp->next = 0;

	if (pp)
	{
		for (;;)
		{
			if (pp->next)
				pp = pp->next;
			else
				break;
		}
		pp->next = rp;
	}

	return rp;
}

void
delete_PoEntry(void *p)
{
	PoEntry *ep = (PoEntry *) p;

	if (!ep)
		return;

	if (ep->next)
		delete_PoEntry(ep->next);

	if (ep->msg)
		free(ep->msg);
	if (ep->translated)
		free(ep->translated);
	if (ep->file)
		free(ep->file);

	if (ep->plural)
	{
		int i;

		for (i = 0; i < ep->nplural; i++)
			free(ep->plural[i]);
		free(ep->plural);
	}

	if (ep->comments)
	{
		int i;

		for (i = 0; i < ep->ncomments; i++)
			free(ep->comments[i]);
		free(ep->comments);
	}

	free(ep);
}

static int
raw_put_str(FILE * out, char *str)
{
	for (; *str; ++str)
		if (fputc(*str, out) == EOF)
			return EOF;
	return 0;
}

static int
put_char(FILE * out, int ch)
{
	switch (ch)
	{
	case '"':
		return raw_put_str(out, "\\\"");
	case '\n':
		return raw_put_str(out, "\\n\"\n\"");
	case '\r':
		return raw_put_str(out, "\\r");
	case '\v':
		return raw_put_str(out, "\\v");
	case '\t':
		return raw_put_str(out, "\\t");
	case '\\':
		return raw_put_str(out, "\\\\");
	default:
		if (ch >= 0 && ch < 32)
		{
			char oct[5];

			sprintf(oct, "\\03%o", ch);
			return raw_put_str(out, oct);
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
	int num = 0, ch;

	for (; (ch = *str); ++str)
	{
		if (ch == '\n')
		{
			num = 0;
			if (str[1] == 0)
			{
				raw_put_str(out, "\\n");
				return 0;
			}
		}
		else if (num > max_num && (ch == ' ' || ch == '\t'))
		{
			if (raw_put_str(out, "\"\n\""))
				return -1;
			num = 0;
		}
		else
			num++;
		if (put_char(out, ch))
			return -1;
	}
	return 0;
}

int
po_parse_template(FILE * in, char *filename, char *start, char *stop, void *par,
		  int (*entry_handler) (void *par, char *filename, int line, char *txt), int (*norm_handler) (void *par,
													      char *txt,
													      int len))
{
	int ch, s0, p0;
	int sl, pl, pos = 0;
	ExtractState state;
	int mline = 0;
	int line = 0;
	int ret = 0;
	Buf buf;

	memset(&buf, 0, sizeof(Buf));

	sl = strlen(start);
	pl = strlen(stop);
	s0 = start[0];
	p0 = stop[0];

	state = E_Norm;

	for (;;)
	{
		ch = fgetc(in);
		if (ch == EOF)
			return ferror(in);
		if (ch == '\n')
			++line;
	      again:
		switch (state)
		{
		case E_Norm:
			if (ch == s0)
			{
				state = E_Start;
				pos = 1;
				continue;
			}
			else
			{
				if (norm_handler)
				{
					char b = ch;

					ret = norm_handler(par, &b, 1);
					if (ret)
						goto end;
				}
			}
			break;
		case E_Start:
			if (pos == sl)
			{
				state = E_Msg;
				pos = 0;
				buf.end = 0;
				mline = line;
				goto again;
			}
			if (ch != start[pos++])
			{
				state = E_Norm;
				if (norm_handler)
				{
					ret = norm_handler(par, start, pos - 1);
					if (ret)
						goto end;
					goto again;
				}
				continue;
			}
			break;
		case E_Msg:
			if (ch == p0)
			{
				state = E_Stop;
				pos = 1;
				continue;
			}
			put_Buf(&buf, ch);
			break;
		case E_Stop:
			if (pos == pl)
			{
				state = E_Norm;
				put_Buf(&buf, 0);

				if (entry_handler)
				{
					ret = entry_handler(par, filename, mline, buf.ptr);
					if (ret)
						goto end;
				}

				buf.end = 0;
				goto again;
			}
			if (ch != stop[pos])
			{
				int i;

				for (i = 0; i < pos; ++i)
					put_Buf(&buf, stop[i]);

				state = E_Msg;
				goto again;
			}
			pos++;
			break;
		}
	}
      end:
	free(buf.ptr);
	return ret;
}

#define TM_YEAR_ORIGIN 1900

/* Yield A - B, measured in seconds.  */
static long
difftm(const struct tm *a, const struct tm *b)
{
	int ay = a->tm_year + (TM_YEAR_ORIGIN - 1);
	int by = b->tm_year + (TM_YEAR_ORIGIN - 1);

	/* Some compilers cannot handle this as a single return statement.  */
	long days = (
			    /* difference in day of year  */
			    a->tm_yday - b->tm_yday
			    /* + intervening leap days  */
			    + ((ay >> 2) - (by >> 2)) - (ay / 100 - by / 100) + ((ay / 100 >> 2) - (by / 100 >> 2))
			    /* + difference in years * 365  */
			    + (long) (ay - by) * 365l);

	return 60l * (60l * (24l * days + (a->tm_hour - b->tm_hour)) + (a->tm_min - b->tm_min)) + (a->tm_sec - b->tm_sec);
}

/* According to Sun's Uniforum proposal the default message domain is
   named `messages'.  */
#define MESSAGE_DOMAIN_DEFAULT "messages"

int
po_write_header(FILE * out)
{
	time_t now;
	struct tm local_time;
	char tz_sign;
	long tz_min;

	fprintf(out, "# SOME DESCRIPTIVE TITLE.\n\
# FIRST AUTHOR <EMAIL@ADDRESS>, YEAR.\n#\n#, fuzzy\n");

	time(&now);
	local_time = *localtime(&now);
	tz_sign = '+';
	tz_min = difftm(&local_time, gmtime(&now)) / 60;
	if (tz_min < 0)
	{
		tz_min = -tz_min;
		tz_sign = '-';
	}

#if 1
	fprintf(out, "msgid \"\"\nmsgstr \"\"\n\"\
Project-Id-Version: PACKAGE VERSION\\n\"\n\
\"PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE\\n\"\n\
\"Last-Translator: FULL NAME <EMAIL@ADDRESS>\\n\"\n\
\"Language-Team: LANGUAGE <LL@li.org>\\n\"\n\
\"MIME-Version: 1.0\\n\"\n\
\"Content-Type: text/plain; charset=iso-8859-1\\n\"\n\
\"Content-Transfer-Encoding: 8-bit\"\n");
#else
	fprintf(out, "msgid \"\"\nmsgstr \"\"\n\"\
Project-Id-Version: PACKAGE VERSION\\n\"\n\
\"POT-Creation-Date: %d-%02d-%02d %02d:%02d%c%02d%02d\\n\"\n\
\"PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE\\n\"\n\
\"Last-Translator: FULL NAME <EMAIL@ADDRESS>\\n\"\n\
\"Language-Team: LANGUAGE <LL@li.org>\\n\"\n\
\"MIME-Version: 1.0\\n\"\n\
\"Content-Type: text/plain; charset=iso-8859-1\\n\"\n\
\"Content-Transfer-Encoding: 8-bit\"\n", local_time.tm_year + TM_YEAR_ORIGIN, local_time.tm_mon + 1, local_time.tm_mday, local_time.tm_hour, local_time.tm_min, tz_sign, (int) (tz_min / 60), (int) (tz_min % 60));
#endif
	return 0;
}

static void
write_po_header(FILE * out, PoEntry * ep)
{
	PoEntry *pp = ep;
	int i;

	for (i = 0; i < ep->ncomments; i++)
		fprintf(out, "%s\n", ep->comments[i]);

	if (!ep->file)
		return;

	for (;;)
	{
		int i;

		fprintf(out, "\n#:");

		for (i = 0; i < 5; ++i)
		{
			fprintf(out, " %s:%d", pp->file, pp->line);
			if (pp->next)
				pp = pp->next;
			else
				goto ret;
		}
	}

ret:
	if (!ep->ncomments)
        	fprintf(out, "\n");
}

int
po_write_entry(FILE * out, PoEntry * ep, int dupflag)
{
	write_po_header(out, ep);

	if ((!ep->msg || !ep->msg[0]) && (!ep->translated || !ep->translated[0]) && !ep->nplural)
	{
		return 0;
	}

	fprintf(out, "msgid \"");
	if (put_str(out, ep->msg))
		return -1;
	fprintf(out, "\"\n");

	if (ep->msg_plural)
	{
		int i;

		fprintf(out, "msgid_plural \"");
		if (put_str(out, ep->msg_plural))
			return -1;
		fprintf(out, "\"\n");

		for (i = 0; i < ep->nplural; i++)
		{
			fprintf(out, "msgstr[%d] \"", i);

			if (ep->plural[i])
			{
				if (put_str(out, ep->plural[i]))
					return -1;
			}
			else if (dupflag)
			{
				if (put_str(out, ep->msg))
					return -1;
			}
			fprintf(out, "\"\n");
		}

		if (i == 0)
		{
			fprintf(out, "msgstr[0] \"");
			if (dupflag)
			{
				if (put_str(out, ep->msg))
					return -1;
			}
			fprintf(out, "\"\n");
			i++;
		}

		if (i == 1)
		{
			fprintf(out, "msgstr[1] \"");
			if (dupflag)
			{
				if (put_str(out, ep->msg_plural))
					return -1;
			}
			fprintf(out, "\"\n");
		}

	}
	else
	{
		fprintf(out, "msgstr \"");
		if (ep->translated)
		{
			if (put_str(out, ep->translated))
				return -1;
		}
		else if (dupflag)
		{
			if (put_str(out, ep->msg))
				return -1;
		}
		fprintf(out, "\"\n");
	}

	return 0;
}

typedef enum
{
	S_norm,
	S_bs,
	S_oct1,
	S_oct2,
	S_stop,
}
StrState;

static void
end_pl_index(PoEntry * ep, int *pl_index, Buf * msgstr)
{
	int ind;

	ind = *pl_index;
	if (ind < 0)
		return;

	if (ind >= ep->nplural)
	{
		int i;

		ep->plural = (char **) realloc(ep->plural, sizeof(char *) * (ind + 1));

		for (i = ep->nplural; i <= ind; i++)
			ep->plural[i] = 0;

		ep->nplural = ind + 1;
	}

	if (ep->plural[ind])
		free(ep->plural[ind]);

	ep->plural[ind] = msgstr->ptr;

	memset(msgstr, 0, sizeof(Buf));
	*pl_index = -1;
}

PoEntry *
po_read_entry(FILE * in)
{
	char buf[4096];
	PoEntry *ep = 0;
	Buf msgid, msgstr, *bp;
	Buf msgid_plural;
	int pl_index = -1;

	if (!fgets(buf, sizeof(buf), in))
		return 0;

	memset(&msgid, 0, sizeof(Buf));
	memset(&msgid_plural, 0, sizeof(Buf));
	memset(&msgstr, 0, sizeof(Buf));
	ep = new_PoEntry(0, 0, 0, 0);
	bp = 0;

	do
	{
		int l, r;
		char *p = buf;

		for (l = strlen(buf); l > 0 && (buf[l - 1] == '\n' || buf[l - 1] == '\r'); l--)
			;

		buf[l] = 0;

		if (l == 0)
		{
			end_pl_index(ep, &pl_index, &msgstr);
			break;
		}

		if (buf[0] == '#')
		{
			int n = ep->ncomments++;
			ep->comments = (char **) realloc(ep->comments, sizeof(char *) * (n + 1));
			ep->comments[n] = strdup(buf);
			continue;
		}

		if (l > 12 && !memcmp(buf, "msgid_plural", 12))
		{
			end_pl_index(ep, &pl_index, &msgstr);
			bp = &msgid_plural;
			p += 12;
			l -= 12;
		}
		else if (l > 5 && !memcmp(buf, "msgid", 5))
		{
			end_pl_index(ep, &pl_index, &msgstr);
			bp = &msgid;
			p += 5;
			l -= 5;
		}
		else if (l > 6 && !memcmp(buf, "msgstr", 6))
		{
			end_pl_index(ep, &pl_index, &msgstr);
			bp = &msgstr;
			p += 6;
			l -= 6;
			if (p[0] == '[')
			{
				int ll;

				p++;
				l--;
				ll = strcspn(p, "]");
				pl_index = atoi(p);

				p += ll;
				l -= ll;

				ll = strspn(p, "]");
				p += ll;
				l -= ll;
			}
		}
		r = strspn(p, " \t");
		p += r;
		l -= r;

		if (*p == '"')
		{
			StrState state = S_norm;
			char obuf[4];

			if (!bp)
				continue;

			obuf[3] = 0;

			for (p++, l--; l > 0; p++, l--)
			{
				int ch = *p;

				switch (state)
				{
				case S_norm:
					switch (ch)
					{
					case '\\':
						state = S_bs;
						break;
					case '"':
						state = S_stop;
						break;
					default:
						put_Buf(bp, ch);
						break;
					}
					break;
				case S_bs:
					state = S_norm;
					switch (ch)
					{
					case 'n':
						put_Buf(bp, '\n');
						break;
					case 'r':
						put_Buf(bp, '\r');
						break;
					case 't':
						put_Buf(bp, '\t');
						break;
					case 'v':
						put_Buf(bp, '\v');
						break;
					case '0':
					case '1':
					case '2':
					case '3':
					case '4':
					case '5':
					case '6':
					case '7':
						state = S_oct1;
						obuf[0] = ch;
						break;
					default:
						put_Buf(bp, ch);
						break;
					}
					break;
				case S_oct1:
					state = S_norm;
					switch (ch)
					{
					case '0':
					case '1':
					case '2':
					case '3':
					case '4':
					case '5':
					case '6':
					case '7':
						state = S_oct2;
						obuf[1] = ch;
						break;
					default:
						put_Buf(bp, ch);
						break;
					}
					break;
				case S_oct2:
					state = S_norm;
					switch (ch)
					{
					case '0':
					case '1':
					case '2':
					case '3':
					case '4':
					case '5':
					case '6':
					case '7':
						obuf[2] = ch;
						ch = strtol(obuf, 0, 8);
						break;
					default:
						put_Buf(bp, ch);
						break;
					}
					break;
				case S_stop:
					break;
				}
				if (state == S_stop)
					break;
			}

		}

	}
	while (fgets(buf, sizeof(buf), in));

	/*if(msgid.ptr) */
	put_Buf(&msgid, 0);
	/*if(msgstr.ptr) */
	put_Buf(&msgstr, 0);
	if (msgid_plural.ptr)
		put_Buf(&msgid_plural, 0);

	ep->msg = msgid.ptr;
	ep->msg_plural = msgid_plural.ptr;
	ep->translated = msgstr.ptr;

	return ep;
}

PoEntry *
po_read_entry_compat(FILE * in)
{
	PoEntry *ep;
	char *s;
	char *sp;

	ep = po_read_entry(in);
	if (!ep)
		return 0;

	if (ep->nplural || ep->plural || !ep->msg || ep->msg_plural)
		return ep;

	if (!(s = strchr(ep->msg, COMPAT_DELIM)))
		return ep;

	if ((sp = strchr(s + 1, COMPAT_DELIM)))
		return ep;

	ep->msg_plural = strdup(s + 1);
	*s = 0;

	for (s = ep->translated; s && *s;)
	{
		ep->plural = (char **) realloc(ep->plural, sizeof(char *) * (ep->nplural + 1));
		ep->plural[ep->nplural] = s;
		ep->nplural++;
		s = strchr(s, COMPAT_DELIM);
		if (!s)
			break;
		*s = 0;
		s++;
	}

	return ep;
}

int
po_write_entry_compat(FILE * out, PoEntry * ep, int dupflag)
{
	int i;

	write_po_header(out, ep);

	if ((!ep->msg || !ep->msg[0]) && (!ep->translated || !ep->translated[0]) && !ep->nplural)
	{
		return 0;
	}

	fprintf(out, "msgid \"");
	if (put_str(out, ep->msg))
		return -1;

	if (ep->msg_plural)
	{
		fputc(COMPAT_DELIM, out);
		if (put_str(out, ep->msg_plural))
			return -1;
	}
	fprintf(out, "\"\n");

	fprintf(out, "msgstr \"");
	if (ep->msg_plural)
	{
		for (i = 0; i < ep->nplural; i++)
		{
			if (i)
				fputc(COMPAT_DELIM, out);
			if (ep->plural[i])
			{
				if (put_str(out, ep->plural[i]))
					return -1;
			}
			else if (dupflag)
			{
				if (i == 0)
					put_str(out, ep->msg);
				else
					put_str(out, ep->msg_plural);
			}
		}

		if (i == 0)
		{
			if (dupflag)
			{
				if (put_str(out, ep->msg))
					return -1;
			}
			i++;
		}

		if (i == 1)
		{
			fputc(COMPAT_DELIM, out);
			if (dupflag)
			{
				if (put_str(out, ep->msg_plural))
					return -1;
			}
		}

	}
	else
	{
		if (ep->translated)
		{
			if (put_str(out, ep->translated))
				return -1;
		}
		else if (dupflag)
		{
			if (put_str(out, ep->msg))
				return -1;
		}
	}

	fprintf(out, "\"\n");
	return 0;
}
