#if 0
#include <w32api/windows.h>
#include <io.h>
#endif

int
w32fcntl(int fd, int flag, void *argp)
{
#if 0
	HANDLE h = LongToHandle(get_osfhandle(fd));
	int r=0, err=0;
#endif
	struct flock *fl;

	switch(flag)
	{
	case F_SETLK:
	case F_SETLKW:
#if 1
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
#if 1
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

#define fcntl w32fcntl

