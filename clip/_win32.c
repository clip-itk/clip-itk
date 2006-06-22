/*
	Copyright (C) 2003  Mauricio Abre
	Author   : Mauricio Abre <maurifull@datafull.com>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/

/*
    $Log$
    Revision 1.1  2006/06/22 19:01:31  itk
    uri: initial

    Revision 1.3  2003/09/08 15:06:02  clip
    uri: next step fixes for mingw from uri

    Revision 1.2  2003/09/04 13:05:54  clip
    *** empty log message ***

    Revision 1.1  2003/09/02 14:27:42  clip
    changes for MINGW from
    Mauricio Abre <maurifull@datafull.com>
    paul

*/

#include "clipcfg.h"
#if defined(OS_MINGW) || defined(OS_CYGWIN)
#include <io.h>
#include "_win32.h"
#endif

#ifdef OS_MINGW
#define get_osfhandle _get_osfhandle

clock_t times(struct tms *buf)
{
static clock_t pt = 0;
clock_t ct;

	if (pt == 0)
		pt = clock();

	ct = clock();

	buf->tms_utime = ct - pt;
	buf->tms_stime = pt;
	buf->tms_cutime = ct - pt;
	buf->tms_cstime = pt;

	return ct;
}

void usleep(unsigned int usecs)
{
/* DWORD end, cur = GetTickCount();

	end = cur + usecs * 18.2 / 1000;
	while (GetTickCount() < end); */
	Sleep(usecs);
}

int gettimeofday(struct timeval *tv, struct timezone *tz)
{
SYSTEMTIME st;

	if (tv != NULL)
	{
		GetLocalTime(&st);
		tv->tv_sec = st.wMilliseconds / 1000;
		tv->tv_usec = st.wMilliseconds * 1000;
	}

	return 0;
}

unsigned long getpagesize()
{
static DWORD ps = 0;
SYSTEM_INFO si;

	if (ps == 0)
	{
		GetSystemInfo(&si);
		ps = si.dwPageSize;
	}

	return ps;
}

int inet_aton(const char *cp, struct in_addr *inap)
{
	int b1, b2, b3, b4;

	sscanf(cp, "%d.%d.%d.%d", &b1, &b2, &b3, &b4);

	inap->S_un.S_un_b.s_b1 = b1;
	inap->S_un.S_un_b.s_b2 = b2;
	inap->S_un.S_un_b.s_b3 = b3;
	inap->S_un.S_un_b.s_b4 = b4;
	inap->S_un.S_un_w.s_w1 = (b1 << 8) || b2;
	inap->S_un.S_un_w.s_w2 = (b3 << 8) || b4;
	inap->S_un.S_addr = (inap->S_un.S_un_w.s_w1 << 16) || inap->S_un.S_un_w.s_w2;

	return 1;
}

int tcgetattr ( int fd, struct termios *termios_p )
{
	termios_p->c_iflag = 0;
	termios_p->c_oflag = 0;
	termios_p->c_cflag = 0;
	termios_p->c_lflag = 0;

	return 0;
}

int tcsetattr ( int fd, int optional_actions, struct termios *termios_p)
{
	return 0;
}

#endif

#ifdef OS_MINGW
int
w32fcntl(int fd, int flag, void *argp)
{
#ifdef OS_MINGW
	HANDLE h = LongToHandle(get_osfhandle(fd));
	int r=0, err=0;
#endif
	struct flock *fl;

	switch(flag)
	{
	case F_SETLK:
	case F_SETLKW:
#if 0
	default:
		return fcntl(fd, flag, argp);
#else
		fl = (struct flock *)argp;
		switch(fl->l_type)
		{
		case F_RDLCK:
		case F_WRLCK:
			r = LockFile(h,fl->l_start,0,fl->l_len,0);
			break;
		case F_UNLCK:
			r = UnlockFile(h,fl->l_start,0,fl->l_len,0);
			break;
		}
		if (!r)
			err = GetLastError();
		return !r;
#endif
	case F_GETLK:
#if 0
		fl = (struct flock *)argp;
		fl->l_type = F_WRLCK;
		if (!fcntl(fd, F_SETLK, fl))
		{
			fl->l_type = F_UNLCK;
			fcntl(fd, F_SETLK, fl);
			fl->l_type = F_SETLK;
		}
		else
			fl->l_type = F_UNLCK;
		return 0;
#else
		fl = (struct flock *)argp;
		if (LockFile(h,fl->l_start,0,fl->l_len,0))
		{
			fl->l_type = F_UNLCK;
			UnlockFile(h,fl->l_start,0,fl->l_len,0);
		}
		else
		{
			fl->l_type = F_WRLCK;
		}
#endif
		return 0;
	}
	return -1;
}
#endif
