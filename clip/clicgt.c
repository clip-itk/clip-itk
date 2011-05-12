/*
	$Log$
	Revision 1.1  2006/06/22 19:01:32  itk
	uri: initial
	
	Revision 1.15  2005/07/07 12:47:50  clip
	uri: some fix for gcc4
	
	Revision 1.14  2003/09/08 15:06:02  clip
	uri: next step fixes for mingw from uri

	Revision 1.13  2003/09/02 14:27:42  clip
	changes for MINGW from
	Mauricio Abre <maurifull@datafull.com>
	paul

*/

#include <sys/types.h>
#include <sys/stat.h>

#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <string.h>
#include <locale.h>
#include <dirent.h>
#include <ctype.h>

#include "clipcfg.h"

#ifndef OS_MINGW
#include <sys/mman.h>
#endif

#include "gettext.h"
#include "clic.h"
#include "plural.h"

#ifdef HAVE_ICONV
#include <iconv.h>
#else
#include "screen/charset.h"
#endif

#ifndef O_BINARY
#define O_BINARY 0
#endif

#ifdef OS_CYGWIN
#define NO_MMAP
#endif

typedef struct
{
	char *name;
	char *module;
	int ok;

	char *data;
	int use_mmap;
	int fd;
	size_t mmap_size;
	int must_swap;
	nls_uint32 nstrings;
	struct string_desc *orig_tab;
	struct string_desc *trans_tab;
	nls_uint32 hash_size;
	nls_uint32 *hash_tab;
	char *charset;

	char *nullentry;
	unsigned nplural;
	PluralData *pd;

	int tr_inited;
#ifdef HAVE_ICONV
	iconv_t it;
#else
	unsigned char trans_tbl[256];
#endif
}
Locale;

static Locale *lp = 0;
static Locale *init_locale(char *module);
static int inited = 0;
static char *find_msg(Locale * lp, const char *msgid, int *lenp);
static nls_uint32 SWAP(nls_uint32 i);
static unsigned long hash_string(const char *str);

static char *tr_charset(Locale *lp, char *msg);

char *
_clic_gettext(const char *s)
{
	char *sp;

	if (!lp && !inited)
	{
		inited = 1;
		lp = init_locale("clip");
	}

	if (!lp)
		return (char *) s;

	sp = find_msg(lp, s, 0);

	if (sp)
		return tr_charset(lp, sp);
	return (char *) s;
}

char *
_clic_ngettext(const char *msg, const char *nmsg, int n)
{
	char *sp = 0;
	int l = 0;

	if (!lp && !inited)
	{
		inited = 1;
		lp = init_locale("clip");
	}

	if (!lp)
		goto ret;


#ifdef PO_COMPAT
	{
		int l1, l2;
		char *buf;

		l1 = strlen(msg);
		l2 = strlen(nmsg);
#ifdef OS_MINGW
		buf = malloc(l1+l2+2);
#else
		buf = alloca(l1+l2+2);
#endif

		memcpy(buf, msg, l1);
		memcpy(buf+l1+1, nmsg, l2);
		buf[l1] = PO_COMPAT_CHAR;
		buf[l1+l2+1] = 0;

		sp = find_msg(lp, buf, &l);
#ifdef OS_MINGW
		free(buf);
#endif
	}
#endif

	if (!sp)
		sp = find_msg(lp, msg, &l);

	if (sp)
	{
		unsigned i, nn;
		char *ep;

		if (!lp->pd)
		{
			if (n == 1)
				return tr_charset(lp, sp);
			sp = find_msg(lp, nmsg, &l);
			if (sp)
				return tr_charset(lp, sp);
			else
				return (char *) nmsg;
		}

		nn = plural_eval(lp->pd, n);
		ep = sp + l;
		for (i = 0;  i < lp->nplural && sp < ep; i++)
		{
			char *p;

#ifdef PO_COMPAT
			p = strchr(sp, PO_COMPAT_CHAR);
			if (!p)
			{
				l = strlen(sp);
				break;
			}
			else
			{
				l = p - sp;
				p++;
			}
#else
			p = sp + strlen(sp) + 1;
#endif
			if (p >= ep || i >= nn)
				break;
			sp = p;
		}

#ifdef PO_COMPAT
		{
			/* this is a memleak!!! but... */
			char *rp;
			rp = (char*) malloc(l+1);
			memcpy(rp, sp, l);
			rp[l] = 0;
			return tr_charset(lp, rp);
		}
#else
		return tr_charset(lp, sp);
#endif
	}

      ret:
	return n > 1 ? (char *) nmsg : (char *) msg;
}

static char *
tr_charset(Locale *lp, char *msg)
{
	if (lp && lp->charset && out_charset && strcasecmp(lp->charset, out_charset))
	{
#ifdef HAVE_ICONV
		char fastbuf[1024];
		char *rp, *ip, *op;
		size_t il, ol, rl, ret;

		if (!lp->tr_inited)
		{
			lp->it = iconv_open(out_charset, lp->charset);
			lp->tr_inited = 1;
		}
		if (lp->it == (iconv_t)-1)
			return msg;

		il = strlen(msg);
		ol = il * 3;

		if (ol > sizeof(fastbuf)) {
			rp = malloc(ol);
			if (!rp) {
				/* TODO: log failure */
				return msg;
			}
		} else {
			rp = fastbuf;
			ol = sizeof(fastbuf);
		}

		ip = msg;
		op = rp;
		rl = --ol;

		ret = iconv(lp->it, &ip, &il, &op, &ol);

		if (ret == (size_t) -1) {
			/* TODO: log failure + errno */
			if (rp != fastbuf)
				free(rp);
			return msg;
		}

		ol = rl - ol;
		if (rp == fastbuf) {
			/* strndup() */
			rp = malloc(ol + 1);
			memcpy(rp, fastbuf, ol);
			rp[ol] = '\0';
			return rp;
		} else {
			op = realloc(rp, ol + 1);
			if (!op) {
				/* TODO: log failure + errno */
				free(rp);
				return msg;
			} else {
				op[ol] = '\0';
				return op;
			}
		}
		return msg;
#else
		char *rp;
		int i, rl;

		rl = strlen(msg);
		if (!lp->tr_inited)
		{
			char *p1, *p2;
			cons_CharsetEntry *cs1 = 0, *cs2 = 0;
			int len1 = 0, len2 = 0;
			int r1, r2;

			p1 = lp->charset;
			p2 = out_charset;

			if ( (r1=load_charset_name(p1, &cs1, &len1)))
			{
				yywarning("cannot load charset '%s': %s",
					p1, strerror(errno));
			}
			if ( (r2=load_charset_name(p2, &cs2, &len2)))
			{
				yywarning( "cannot load charset '%s': %s",
					p2, strerror(errno));
			}

			if (!r1 && !r2)
			{
				make_translation(cs1, len1, cs2, len2, lp->trans_tbl);
			}
			else
			{
				for(i=0; i<256; i++)
					lp->trans_tbl[i] = i;
			}
			lp->tr_inited = 1;
		}
		rp = (char*)malloc(rl+1);
		for(i=0; i<rl; i++)
			rp[i] = lp->trans_tbl[((unsigned char*)msg)[i]];
		rp[rl] = 0;
		return rp;
#endif
	}
	else
		return msg;
}


static int
m_access(const char *path, int mode)
{
	int r;
	struct stat st;

	if ((r = stat(path, &st)))
		return r;

	if (!S_ISREG(st.st_mode))
	{
		v_printf(2, "no access to file '%s': not a regular file\n", path);
		return 1;
	}

	r = access(path, mode);
	if (r)
		v_printf(2, "no access to file '%s': %s\n", path, strerror(errno));

	return r;
}

#if 0

static void
delete_Locale(void *item)
{
	Locale *lp;

	if (!item)
		return;

	lp = (Locale *) item;

#ifndef NO_MMAP
	if (lp->use_mmap)
		munmap((caddr_t) lp->data, lp->mmap_size);
	else
#endif
		free(lp->data);
	if (lp->fd != -1)
		close(lp->fd);
	free(lp->name);
	free(lp->module);
	free(lp->charset);
	if (lp->pd)
		plural_delete(lp->pd);

#ifdef HAVE_ICONV
	if (lp->it != (iconv_t)-1 && lp->it != (iconv_t)-2)
		iconv_close(lp->it);
#endif

	free(lp);
}

#endif

static Locale *
init_locale(char *module)
{
	Locale *lp;
	int fd /*, j, ind */ ;
	int use_mmap = 0;
	size_t size;
	struct stat st;
	struct mo_file_header *data = (struct mo_file_header *) -1;
	nls_uint32 revision;
	char path[256];
	char loc[32];
	char *locale = "";
	char *charset = 0;

	lp = (Locale *) calloc(1, sizeof(Locale));
	lp->module = strdup(module);
#ifdef HAVE_ICONV
	lp->it = (iconv_t)-1;
#endif
	lp->tr_inited = 0;

	path[0] = 0;

	for (;;)
	{
		char *e;
		DIR *dir;
		char *locale;

		locale = getenv("CLIP_LANG");
		if (!locale || !*locale)
			locale = getenv("LANG");
		if (!locale || !*locale)
			locale = getenv("LC_MESSAGE");
		if (!locale || !*locale)
			locale = getenv("LC_ALL");
		if (!locale || !*locale)
			return 0;

		if (charset)
		{
			free(charset);
			charset = 0;
		}
		snprintf(loc, sizeof(loc), "%s", locale);
		snprintf(path, sizeof(path), "%s/locale.mo/%s/%s.mo", CLIP_LOCALE_ROOT, loc, module);



		if (!m_access(path, R_OK))
		{
			e = strrchr(loc, '.');
			if (e)
				charset = strdup(e + 1);
			break;
		}

		e = strrchr(loc, '.');
		if (e)
			*e = 0;
		snprintf(path, sizeof(path), "%s/locale.mo/%s/%s.mo", CLIP_LOCALE_ROOT, loc, module);

		if (!m_access(path, R_OK))
		{
			if (e)
				charset = strdup(e + 1);
			break;
		}

		e = strrchr(loc, '_');
		if (e)
			*e = 0;

		snprintf(path, sizeof(path), "%s/locale.mo", CLIP_LOCALE_ROOT);
		dir = opendir(path);
		if (dir)
		{
			struct dirent *dp;
			int br = 0;

			while ((dp = readdir(dir)))
			{
				if (strncmp(dp->d_name, loc, strlen(loc)))
					continue;

				snprintf(path, sizeof(path), "%s/locale.mo/%s/%s.mo", CLIP_LOCALE_ROOT, dp->d_name, module);

				if (!m_access(path, R_OK))
				{
					br = 1;
					e = strrchr(dp->d_name, '.');
					if (e)
						charset = strdup(e + 1);
					break;
				}
			}
			closedir(dir);
			if (br)
				break;
			else
				path[0] = 0;
		}
		break;
	}

	lp->name = strdup(locale);
	if (*path == 0)
	{
		v_printf(2, "locale settings not found for module '%s'\n", module);
		return 0;
	}
	if (m_access(path, R_OK))
	{
		v_printf(2, "no access to locale file '%s': %s\n", path, strerror(errno));
		return 0;
	}

	fd = open(path, O_RDONLY | O_BINARY);
	if (fd < 0)
	{
		v_printf(1, "cannot open locale file '%s': %s\n", path, strerror(errno));
		return 0;
	}
	else
		v_printf(3, "open locale file '%s', charset '%s'\n", path, charset);

	if (fstat(fd, &st) != 0 || ((size = st.st_size) < sizeof(struct mo_file_header)))
	{
		close(fd);
		v_printf(1, "cannot stat locale file '%s': %s\n", path, strerror(errno));
		return 0;
	}

#ifndef NO_MMAP
	data = (struct mo_file_header *) mmap(NULL, size, PROT_READ, MAP_PRIVATE, fd, 0);
	if (data != (struct mo_file_header *) -1)
	{
		/* mmap() call was successful.  */
#ifndef OS_CYGWIN
/* this f...ed win32 require(undocumented, of couse!) that fd must be keeped OPEN while use mmaped memory...*/
		close(fd);
		fd = -1;
#endif
		use_mmap = 1;
	}
#endif
	/* If the data is not yet available (i.e. mmap'ed) we try to load
	   it manually.  */

	if (data == (struct mo_file_header *) -1)
	{
		size_t to_read;
		char *read_ptr;

		data = (struct mo_file_header *) malloc(size);

		to_read = size;
		read_ptr = (char *) data;
		do
		{
			long int nb = (long int) read(fd, read_ptr, to_read);

			if (nb == -1)
			{
				close(fd);
				v_printf(1, "cannot read locale file '%s': %s\n", path, strerror(errno));
				return 0;
			}

			read_ptr += nb;
			to_read -= nb;
		}
		while (to_read > 0);

		close(fd);
		fd = -1;
	}

	/* Using the magic number we can test whether it really is a message
	   catalog file.  */
	if (data->magic != _MAGIC && data->magic != _MAGIC_SWAPPED)
	{
		/* The magic number is wrong: not a message catalog file.  */
#ifndef NO_MMAP
		if (use_mmap)
			munmap((caddr_t) data, size);
		else
#endif
			free(data);
		if (fd != -1)
			close(fd);
		v_printf(1, "wrong magic number of locale file '%s'\n", path);
		return 0;
	}

	lp->use_mmap = use_mmap;
	lp->mmap_size = size;
	lp->must_swap = data->magic != _MAGIC;
	lp->data = (char *) data;
	lp->fd = fd;
	lp->charset = charset;
	/* Fill in the information about the available tables.  */
	revision = W(lp->must_swap, data->revision);
	switch (revision)
	{
	case 0:
		lp->nstrings = W(lp->must_swap, data->nstrings);
		lp->orig_tab = (struct string_desc *) ((char *) data + W(lp->must_swap, data->orig_tab_offset));
		lp->trans_tab = (struct string_desc *) ((char *) data + W(lp->must_swap, data->trans_tab_offset));
		lp->hash_size = W(lp->must_swap, data->hash_tab_size);
		lp->hash_tab = (nls_uint32 *) ((char *) data + W(lp->must_swap, data->hash_tab_offset));
		break;
	default:
		v_printf(1, "illegal revision of locale file '%s': %d\n", path, revision);
#ifndef NO_MMAP
		if (use_mmap)
			munmap((caddr_t) data, size);
		else
#endif
			free(data);
		if (fd != -1)
			close(fd);
		free(lp);
		return 0;
	}

	lp->ok = 1;
	lp->nullentry = find_msg(lp, "", 0);

	if (lp->nullentry)
	{
		char *plural;
		char *nplurals;

		plural = strstr(lp->nullentry, "plural=");
		nplurals = strstr(lp->nullentry, "nplurals=");
		if (plural && nplurals)
		{
			char *endp;
			unsigned long int n;
			int l;

			/* First get the number.  */
			nplurals += 9;
			while (*nplurals != '\0' && isspace((unsigned char) *nplurals))
				++nplurals;
			if (!(*nplurals >= '0' && *nplurals <= '9'))
				goto no_plural;
			for (endp = nplurals, n = 0; *endp >= '0' && *endp <= '9'; endp++)
				n = n * 10 + (*endp - '0');
			if (nplurals == endp)
				goto no_plural;
			lp->nplural = n;

			plural += 7;
			l = strcspn(plural, ";\n\r");
			lp->pd = plural_new(plural, l);
		}
	      no_plural:
		charset = strstr(lp->nullentry, "charset=");
		if (charset)
			{
			int l;
			charset += 8;
			l = strcspn(charset, ";\n\r \t");
			if (lp->charset)
				free(lp->charset);
			lp->charset = (char*) malloc(l+1);
			memcpy(lp->charset, charset, l);
			lp->charset[l] = 0;
		}
	}

	if (lp->charset)
	{
		char *s;

		for (s = lp->charset; *s; s++)
			*s = tolower(*s);
	}

	return lp;
}

static nls_uint32
SWAP(nls_uint32 i)
{
	return (i << 24) | ((i & 0xff00) << 8) | ((i >> 8) & 0xff00) | (i >> 24);
}

static char *
find_msg(Locale * lp, const char *msgid, int *lenp)
{
	size_t top, act = 0, bottom;

	/* Locate the MSGID and its translation.  */
	if (lp->hash_size > 2 && lp->hash_tab != NULL)
	{
		/* Use the hashing table.  */
		nls_uint32 len = strlen(msgid);
		nls_uint32 hash_val = hash_string(msgid);
		nls_uint32 idx = hash_val % lp->hash_size;
		nls_uint32 incr = 1 + (hash_val % (lp->hash_size - 2));
		nls_uint32 nstr = W(lp->must_swap, lp->hash_tab[idx]);

		if (nstr == 0)
			/* Hash table entry is empty.  */
			return NULL;

		if (W(lp->must_swap, lp->orig_tab[nstr - 1].length) >= len
		    && strcmp(msgid, lp->data + W(lp->must_swap, lp->orig_tab[nstr - 1].offset)) == 0)
		{
			if (lenp)
				*lenp = W(lp->must_swap, lp->trans_tab[nstr - 1].length);
			return (char *) lp->data + W(lp->must_swap, lp->trans_tab[nstr - 1].offset);
		}
		while (1)
		{
			if (idx >= lp->hash_size - incr)
				idx -= lp->hash_size - incr;
			else
				idx += incr;

			nstr = W(lp->must_swap, lp->hash_tab[idx]);
			if (nstr == 0)
				/* Hash table entry is empty.  */
				return NULL;

			if (W(lp->must_swap, lp->orig_tab[nstr - 1].length) >= len
			    && strcmp(msgid, lp->data + W(lp->must_swap, lp->orig_tab[nstr - 1].offset)) == 0)
			{
				if (lenp)
					*lenp = W(lp->must_swap, lp->trans_tab[nstr - 1].length);
				return (char *) lp->data + W(lp->must_swap, lp->trans_tab[nstr - 1].offset);
			}
		}
		/* NOTREACHED */
	}

	/* Now we try the default method:  binary search in the sorted
	   array of messages.  */
	bottom = 0;
	top = lp->nstrings;
	while (bottom < top)
	{
		int cmp_val;

		act = (bottom + top) / 2;
		cmp_val = strcmp(msgid, lp->data + W(lp->must_swap, lp->orig_tab[act].offset));
		if (cmp_val < 0)
			top = act;
		else if (cmp_val > 0)
			bottom = act + 1;
		else
			break;
	}

	if (lenp && bottom < top)
		*lenp = W(lp->must_swap, lp->trans_tab[act].length);
	/* If an translation is found return this.  */
	return bottom >= top ? NULL : (char *) lp->data + W(lp->must_swap, lp->trans_tab[act].offset);
}

/* We assume to have `unsigned long int' value with at least 32 bits.  */
#define HASHWORDBITS 32

/* Defines the so called `hashpjw' function by P.J. Weinberger
   [see Aho/Sethi/Ullman, COMPILERS: Principles, Techniques and Tools,
   1986, 1987 Bell Telephone Laboratories, Inc.]  */

static unsigned long
hash_string(const char *str)
{
	unsigned long int hval, g;

	/* Compute the hash value for the given string.  */
	hval = 0;
	while (*str != '\0')
	{
		hval <<= 4;
		hval += (unsigned long) *str++;
		g = hval & ((unsigned long) 0xf << (HASHWORDBITS - 4));
		if (g != 0)
		{
			hval ^= g >> (HASHWORDBITS - 8);
			hval ^= g;
		}
	}
	return hval;
}
