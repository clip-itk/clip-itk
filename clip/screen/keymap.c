
/*
   $Log$
   Revision 1.1  2006/06/22 19:35:31  itk
   uri: init sf.net repository

   Revision 1.4  2005/07/06 15:30:28  clip
   uri: strange trouble with new util loadkeys and old kernel. not fixed goodly.

   Revision 1.3  2001/05/15 10:34:28  clip
   memdebug
   paul

   Revision 1.2  2000/12/02 12:46:57  clip
   scancodes
   paul

   Revision 1.1  2000/11/30 14:57:15  clip
   scancode support
   paul

 */

#include <stdio.h>
#include <string.h>
#include <errno.h>

#include "../clip.h"
#include "scankey.h"

#define MAX_NR_FUNC	256	/* max nr of strings assigned to keys */
#define MAX_DIACR	256
#define MAX_NR_KEYMAPS	256
#define NR_KEYS		128

struct kbdiacr
{
	unsigned char diacr, base, result;
};

static char *funcbuf = 0;
static int funcbufsize = 0;
char *func_table[MAX_NR_FUNC];
unsigned int keymap_count;
unsigned short *key_maps[MAX_NR_KEYMAPS];
unsigned short plain_map[NR_KEYS];
struct kbdiacr accent_table[MAX_DIACR];
unsigned int accent_table_size;

#ifndef LIBROOT
#define LIBROOT "/usr/local/lib/clip"
#endif

#ifndef CLIP_KEYMAP_ROOT
#define CLIP_KEYMAP_ROOT  LIBROOT "/keymaps"
#endif

static int line_no = 0;

static int
get_str(FILE * file, char *buf, int bufsize)
{
	char *s;
	int l, i;

      again:
	s = fgets(buf, bufsize, file);
	if (!s)
		return -1;
	line_no++;

	l = strlen(s);
	if (l <= 1 || s[0] == '\n')
		goto again;

	l--;
	buf[l] = 0;

	for (i = 0; i < l; i++)
	{
		switch (buf[i])
		{
		case ' ':
		case '\t':
			continue;
		case '#':
			goto again;
		}
		break;
	}

	if (i)
		memmove(buf, buf + i, l - i + 1);

	return 0;
}

int
load_keymap(FILE *file, char *errbuf, int errbuflen)
{
	char buf[256];
	int r = 0;
	int max_nr_keymaps;
	int max_nr_func;
	int max_diacr;
	int i;

	if (get_str(file, buf, sizeof(buf)))
		goto err;
	if (sscanf(buf, "%d", &max_nr_keymaps) != 1)
		goto err;
	if (max_nr_keymaps > MAX_NR_KEYMAPS)
		goto err;

	if (get_str(file, buf, sizeof(buf)))
		goto err;
	if (sscanf(buf, "%d", &keymap_count) != 1)
		goto err;
	if (keymap_count > MAX_NR_KEYMAPS)
		goto err;

	for (i = 0; i < max_nr_keymaps; i++)
	{
		unsigned short *keymap;
		int size, j;

		if (get_str(file, buf, sizeof(buf)))
			goto err;
		if (sscanf(buf, "%d", &size) != 1)
			goto err;

		if (size == 0)
		{
			key_maps[i] = 0;
			continue;
		}
//#define NEW_NR_KEYS
/*
	new kernels have value 512.
	loadkeys util what generated under new kernels
	created	file with 512 items.
	But old kernel and files support only 128 items per map.
	This patch make for ignoring items 129...512.
*/
#ifndef NEW_NR_KEYS
		if (size < 0 || size > NR_KEYS)
			goto err;
#else
		if (size < 0 )
			goto err;
#endif

		keymap = (unsigned short *) calloc(size, sizeof(unsigned short));

		key_maps[i] = keymap;

		for (j = 0; j < size; j++)
		{
			unsigned us;

			if (get_str(file, buf, sizeof(buf)))
				goto err;
#ifdef NEW_NR_KEYS
			if (j > NR_KEYS)
				continue;
			if ( strncmp(buf,"#keymap",7)==0 )
				exit;
#endif
			if (sscanf(buf, "%u", &us) != 1)
				goto err;
			keymap[j] = us;
		}
	}

	if (get_str(file, buf, sizeof(buf)))
		goto err;
	if (sscanf(buf, "%d", &funcbufsize) != 1)
		goto err;
	funcbuf = (char *) calloc(1, funcbufsize);

	for (i = 0; i < funcbufsize; i++)
	{
		int ch;

		if (get_str(file, buf, sizeof(buf)))
			goto err;
		if (sscanf(buf, "%d", &ch) != 1)
			goto err;
		funcbuf[i] = ch;
	}

	if (get_str(file, buf, sizeof(buf)))
		goto err;
	if (sscanf(buf, "%d", &max_nr_func) != 1)
		goto err;
	if (max_nr_func > MAX_NR_FUNC)
		goto err;

	for (i = 0; i < max_nr_func; i++)
	{
		int offs;

		if (get_str(file, buf, sizeof(buf)))
			goto err;
		if (sscanf(buf, "%d", &offs) != 1)
			goto err;

		if (offs < 0)
			func_table[i] = 0;
		else if (offs >= funcbufsize)
			goto err;
		else
			func_table[i] = funcbuf + offs;
	}

	if (get_str(file, buf, sizeof(buf)))
		goto err;
	if (sscanf(buf, "%d", &max_diacr) != 1)
		goto err;
	if (max_diacr > MAX_DIACR)
		goto err;

	if (get_str(file, buf, sizeof(buf)))
		goto err;
	if (sscanf(buf, "%d", &accent_table_size) != 1)
		goto err;
	if (accent_table_size < 0 || accent_table_size > max_diacr)
		goto err;

	for (i = 0; i < accent_table_size; i++)
	{
		struct kbdiacr *kp = &accent_table[i];
		int diacr, base, result;

		if (get_str(file, buf, sizeof(buf)))
			goto err;
		if (sscanf(buf, "%d %d %d", &diacr, &base, &result) != 3)
			goto err;

		kp->diacr = diacr;
		kp->base = base;
		kp->result = result;
	}

	goto norm;
      err:

	if (errbuf)
		snprintf(errbuf, errbuflen, "keymap format error: line %d '%s' %s",
			 line_no, buf, strerror(errno));
	r = -1;

      norm:
	return r;
}
