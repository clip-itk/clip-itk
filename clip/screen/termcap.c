
/*
   $Log: termcap.c,v $
   Revision 1.3  2000/12/02 12:46:57  clip
   scancodes
   paul

   Revision 1.2  1999/11/02 23:05:56  axl
   start of logging CVS

 */

#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <fcntl.h>

/* max length of termcap entry */
#define BUFSIZE  1024
/* max number of tc= indirections */
#define MAXHOP   32
#define NKEY	 100

static char SHARETERMCAP[] = "/usr/share/misc/termcap";
static char TERMCAP[] = "/etc/termcap";
static char MYTERMCAP[] = "/usr/lib/deco/termcap";
static char MY_LOCAL_TERMCAP[] = "/usr/local/lib/deco/termcap";
static char MYLCLTERMCAP[256];

static char *tname;		/* terminal name */
static char *tcapfile;		/* termcap file name */
static char *tbuf;		/* terminal entry buffer */
static char *envtermcap = 0;	/* global variable TERMCAP */
static hopcount;		/* detect infinite loops */

static char *tskip(char *);
static char *tdecode(char *, char **);
static int _tgetent(char *, char *, char *);
static int tnchktc();
static int tnamatch(char *);

char *tgetstr(char *str, char **area);

/* termcap statics ][ termcap init  */

static void
errexit(const char *msg)
{
	char msg2[] = " terminal=";

	write(2, msg, strlen(msg));
	write(2, msg2, strlen(msg2));
	write(2, tname, strlen(tname));
	write(2, "\n", 1);
	exit(3);
}

int
tgetent(char *bp, char *t_name)
{
	char *tcap_addfile;

	tname = t_name;
	tcap_addfile = getenv("TERMCAP_ADDFILE");
	if (tcap_addfile)
	{
		strncpy(MYLCLTERMCAP, tcap_addfile, 255);
		MYLCLTERMCAP[255] = 0;
	}
	else
		strcpy(MYLCLTERMCAP, MY_LOCAL_TERMCAP);
	if (!envtermcap)
		envtermcap = getenv("TERMCAP");
	if (envtermcap && *envtermcap == '/')
	{
		tcapfile = envtermcap;
		envtermcap = 0;
	}
	if (!envtermcap)
		envtermcap = "";
	if (!tcapfile || access(tcapfile, 0) < 0)
		tcapfile = SHARETERMCAP;
	if (access(tcapfile, 0) < 0)
		tcapfile = TERMCAP;
	return (
		       _tgetent(bp, tname, MYLCLTERMCAP)
		       || _tgetent(bp, tname, MYTERMCAP)
		       || _tgetent(bp, tname, tcapfile)
		);
}

static int
_tgetent(char *bp, char *name, char *termcap)
{
	int c;
	int tf = -1;
	char *cp = envtermcap;
	char *ibuf;
	int i = 0;
	int cnt = 0;

	tbuf = bp;

	/* TERMCAP can have one of two things in it. It can be the */
	/* name of a file to use instead of /etc/termcap. In this */
	/* case it must start with a "/". Or it can be an entry to */
	/* use so we don't have to read the file. In this case it */
	/* has to already have the newlines crunched out. */
	if (cp && *cp)
	{
		envtermcap = "";
		tbuf = cp;
		c = tnamatch(name);
		tbuf = bp;
		if (c)
		{
			strcpy(bp, cp);
			return (tnchktc());
		}
	}
	if (tf < 0)
		tf = open(termcap, 0);
	if (tf < 0)
		return (0);
	ibuf = (char *) malloc(BUFSIZE);
	i = 0;
	cnt = 0;
	for (;;)
	{
		cp = bp;
		for (;;)
		{
			if (i == cnt)
			{
				cnt = read(tf, ibuf, BUFSIZE);
				if (cnt <= 0)
				{
					close(tf);
					free(ibuf);
					return (0);
				}
				i = 0;
			}
			c = ibuf[i++];
			if (c == '\n')
			{
				if (cp > bp && cp[-1] == '\\')
				{
					cp--;
					continue;
				}
				break;
			}
			if (cp >= bp + BUFSIZE)
			{
				errexit("Termcap entry too long");
				break;
			}
			else
				*cp++ = c;
		}
		*cp = 0;

		/* The real work for the match. */
		if (tnamatch(name))
		{
			close(tf);
			free(ibuf);
			return (tnchktc());
		}
	}
	return -1;
}

static int
tnchktc()
{
	register char *p, *q;
	char tcname[16];	/* name of similar terminal */
	char *tcbuf;
	char *holdtbuf = tbuf;
	int l;

	p = tbuf + strlen(tbuf) - 2;	/* before the last colon */
	while (*--p != ':')
		if (p < tbuf)
		{
			errexit("Bad termcap entry");
			return (0);
		}
	p++;
	/* p now points to beginning of last field */
	if (p[0] != 't' || p[1] != 'c')
		return (1);
	strcpy(tcname, p + 3);
	q = tcname;
	while (*q && *q != ':')
		q++;
	*q = 0;
	if (++hopcount > MAXHOP)
	{
		errexit("Infinite tc= loop");
		return (0);
	}
	tcbuf = (char *) malloc(BUFSIZE);
	if (!_tgetent(tcbuf, tcname, tcapfile))
	{
		hopcount = 0;	/* unwind recursion */
		free(tcbuf);
		return (0);
	}
	for (q = tcbuf; *q != ':'; q++);
	l = p - holdtbuf + strlen(q);
	if (l > BUFSIZE)
	{
		errexit("Termcap entry too long\n");
		q[BUFSIZE - (p - tbuf)] = 0;
	}
	strcpy(p, q + 1);
	tbuf = holdtbuf;
	hopcount = 0;		/* unwind recursion */
	free(tcbuf);
	return (1);
}

static int
tnamatch(char *np)
{
	register char *Np, *Bp;

	Bp = tbuf;
	if (*Bp == '#')
		return (0);
	for (;;)
	{
		for (Np = np; *Np && *Bp == *Np; Bp++, Np++)
			continue;
		if (*Np == 0 && (*Bp == '|' || *Bp == ':' || *Bp == 0))
			return (1);
		while (*Bp && *Bp != ':' && *Bp != '|')
			Bp++;
		if (*Bp == 0 || *Bp == ':')
			return (0);
		Bp++;
	}
}

static char *
tskip(char *bp)
{
	while (*bp && *bp != ':')
		bp++;
	if (*bp == ':')
		bp++;
	return (bp);
}

char *
tgetstr(char *id, char **area)
{
	register char *bp;
	char name[2];

	if (!tbuf)
		return NULL;
	bp = tbuf;
	for (;;)
	{
		bp = tskip(bp);
		if (!bp[0] || !bp[1])
			break;
		if (bp[0] == ':' || bp[1] == ':')
			continue;
		name[0] = *bp++;
		name[1] = *bp++;
		if (id[0] != name[0] || id[1] != name[1])
			continue;
		if (*bp == '@')
			continue;

		switch (*bp)
		{
		case '#':
		case ':':
		case 0:
			break;
		default:
			if (*bp != '=')
				continue;
			bp++;
			return tdecode(bp, area);
		}
	}
	return NULL;
}

int
tgetflag(const char *id)
{
	register char *bp;
	char name[2];

	if (!tbuf)
		return 0;
	bp = tbuf;
	for (;;)
	{
		bp = tskip(bp);
		if (!bp[0] || !bp[1])
			break;
		if (bp[0] == ':' || bp[1] == ':')
			continue;
		name[0] = *bp++;
		name[1] = *bp++;
		if (id[0] != name[0] || id[1] != name[1])
			continue;
		if (*bp == '@')
			continue;

		switch (*bp)
		{
		case '#':
		default:
			continue;
		case ':':
			return 1;
		case 0:
			return 0;
		}
	}
	return 0;
}

int
tgetnum(const char *id)
{
	register char *bp;
	register i, base;
	char name[2];

	if (!tbuf)
		return 0;
	bp = tbuf;
	for (;;)
	{
		bp = tskip(bp);
		if (!bp[0] || !bp[1])
			break;
		if (bp[0] == ':' || bp[1] == ':')
			continue;
		name[0] = *bp++;
		name[1] = *bp++;
		if (id[0] != name[0] || id[1] != name[1])
			continue;
		if (*bp == '@')
			continue;

		if (*bp != '#')
			continue;
		bp++;
		base = 10;
		if (*bp == '0')
			base = 8;
		i = 0;
		while (*bp >= '0' && *bp <= '9')
			i = i * base, i += *bp++ - '0';
		return i;
	}
	return 0;
}

static char *
tdecode(char *str, char **area)
{
	register char *cp;
	register int c;
	register char *dp;
	int i;

	cp = *area;
	while ((c = *str++) && c != ':')
	{
		switch (c)
		{

		case '^':
			c = *str++ & 037;
			break;

		case '\\':
			dp = "E\033^^\\\\::n\nr\rt\tb\bf\f";
			c = *str++;
		      nextc:
			if (*dp++ == c)
			{
				c = *dp++;
				break;
			}
			dp++;
			if (*dp)
				goto nextc;
			if (c >= '0' && c <= '9')
			{
				c -= '0', i = 2;
				do
					c <<= 3, c |= *str++ - '0';
				while (--i && *str >= '0' && *str <= '9');
			}
			break;
		}
		*cp++ = c;
	}
	*cp++ = 0;
	str = *area;
	*area = cp;
	return (str);
}
