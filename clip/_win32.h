/*
	Copyright (C) 2003  Mauricio Abre
	Author   : Mauricio Abre <maurifull@datafull.com>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/

/*
    $Log: _win32.h,v $
    Revision 1.2  2003/09/05 12:11:52  clip
    uri: initial fixes for mingw+win32 from uri

    Revision 1.1  2003/09/02 14:27:42  clip
    changes for MINGW from
    Mauricio Abre <maurifull@datafull.com>
    paul

*/

#ifndef __WIN32_CLIP_H_

/* don't touch next line!! must be EXACTLY as it is */
#if defined(_WIN32) || defined(OS_MINGW) || defined(OS_CYGWIN)

int w32fcntl(int fd, int flag, void *argp);
#define fcntl w32fcntl

#ifdef OS_CYGWIN
#include <w32api/windows.h>
#else  /* MingW support */
#include <windows.h>
#include <winsock.h>
#include <time.h>
#define F_DUPFD		0
#define F_GETFD		1
#define F_SETFD		2
#define F_GETFL		3
#define F_SETFL		4
#ifndef __USE_FILE_OFFSET64
# define F_GETLK	5
# define F_SETLK	6
# define F_SETLKW	7
#else
# define F_GETLK	F_GETLK64
# define F_SETLK	F_SETLK64
# define F_SETLKW	F_SETLKW64
#endif
#define F_GETLK64	12
#define F_SETLK64	13
#define F_SETLKW64	14

#define F_RDLCK		0
#define F_WRLCK		1
#define F_UNLCK		2

#define F_EXLCK		4
#define F_SHLCK		8

#define O_NONBLOCK   0400
struct flock {
	short int l_type;
	short int l_whence;
#ifndef __USE_FILE_OFFSET64
	long l_start;
	long l_len;
#else
	long l_start;
	long l_len;
#endif
  };

struct timezone {
	int tz_minuteswest;
	int tz_dsttime;
};

struct tms {
	clock_t tms_utime;
	clock_t tms_stime;
	clock_t tms_cutime;
	clock_t tms_cstime;
};

unsigned long getpagesize();
void usleep(unsigned int usecs);
int gettimeofday(struct timeval *tv, struct timezone *tz);
clock_t times(struct tms *buf);
int inet_aton(const char *cp, struct in_addr *inap);
typedef unsigned int socklen_t;
#define INET_ADDRSTRLEN 16

#ifndef CLK_TCK
#define CLK_TCK CLOCKS_PER_SEC
#endif

/* termios */
typedef unsigned char	cc_t;
typedef unsigned int	speed_t;
typedef unsigned int	tcflag_t;

#define NCCS 32
struct termios
  {
    tcflag_t c_iflag;		/* input mode flags */
    tcflag_t c_oflag;		/* output mode flags */
    tcflag_t c_cflag;		/* control mode flags */
    tcflag_t c_lflag;		/* local mode flags */
    cc_t c_line;			/* line discipline */
    cc_t c_cc[NCCS];		/* control characters */
    speed_t c_ispeed;		/* input speed */
    speed_t c_ospeed;		/* output speed */
  };

/* c_cc characters */
#define VINTR 0
#define VQUIT 1
#define VERASE 2
#define VKILL 3
#define VEOF 4
#define VTIME 5
#define VMIN 6
#define VSWTC 7
#define VSTART 8
#define VSTOP 9
#define VSUSP 10
#define VEOL 11
#define VREPRINT 12
#define VDISCARD 13
#define VWERASE 14
#define VLNEXT 15
#define VEOL2 16

/* c_iflag bits */
#define IGNBRK	0000001
#define BRKINT	0000002
#define IGNPAR	0000004
#define PARMRK	0000010
#define INPCK	0000020
#define ISTRIP	0000040
#define INLCR	0000100
#define IGNCR	0000200
#define ICRNL	0000400
#define IUCLC	0001000
#define IXON	0002000
#define IXANY	0004000
#define IXOFF	0010000
#define IMAXBEL	0020000

/* c_oflag bits */
#define OPOST	0000001
#define OLCUC	0000002
#define ONLCR	0000004
#define OCRNL	0000010
#define ONOCR	0000020
#define ONLRET	0000040
#define OFILL	0000100
#define OFDEL	0000200
#if defined __USE_MISC || defined __USE_XOPEN
# define NLDLY	0000400
# define   NL0	0000000
# define   NL1	0000400
# define CRDLY	0003000
# define   CR0	0000000
# define   CR1	0001000
# define   CR2	0002000
# define   CR3	0003000
# define TABDLY	0014000
# define   TAB0	0000000
# define   TAB1	0004000
# define   TAB2	0010000
# define   TAB3	0014000
# define BSDLY	0020000
# define   BS0	0000000
# define   BS1	0020000
# define FFDLY	0100000
# define   FF0	0000000
# define   FF1	0100000
#endif

#define VTDLY	0040000
#define   VT0	0000000
#define   VT1	0040000

#ifdef __USE_MISC
# define XTABS	0014000
#endif

/* c_cflag bit meaning */
#ifdef __USE_MISC
# define CBAUD	0010017
#endif
#define  B0	0000000		/* hang up */
#define  B50	0000001
#define  B75	0000002
#define  B110	0000003
#define  B134	0000004
#define  B150	0000005
#define  B200	0000006
#define  B300	0000007
#define  B600	0000010
#define  B1200	0000011
#define  B1800	0000012
#define  B2400	0000013
#define  B4800	0000014
#define  B9600	0000015
#define  B19200	0000016
#define  B38400	0000017
#ifdef __USE_MISC
# define EXTA B19200
# define EXTB B38400
#endif
#define CSIZE	0000060
#define   CS5	0000000
#define   CS6	0000020
#define   CS7	0000040
#define   CS8	0000060
#define CSTOPB	0000100
#define CREAD	0000200
#define PARENB	0000400
#define PARODD	0001000
#define HUPCL	0002000
#define CLOCAL	0004000
#ifdef __USE_MISC
# define CBAUDEX 0010000
#endif
#define  B57600   0010001
#define  B115200  0010002
#define  B230400  0010003
#define  B460800  0010004
#define  B500000  0010005
#define  B576000  0010006
#define  B921600  0010007
#define  B1000000 0010010
#define  B1152000 0010011
#define  B1500000 0010012
#define  B2000000 0010013
#define  B2500000 0010014
#define  B3000000 0010015
#define  B3500000 0010016
#define  B4000000 0010017
#define __MAX_BAUD B4000000
#ifdef __USE_MISC
# define CIBAUD	  002003600000		/* input baud rate (not used) */
# define CRTSCTS  020000000000		/* flow control */
#endif

/* c_lflag bits */
#define ISIG	0000001
#define ICANON	0000002
#if defined __USE_MISC || defined __USE_XOPEN
# define XCASE	0000004
#endif
#define ECHO	0000010
#define ECHOE	0000020
#define ECHOK	0000040
#define ECHONL	0000100
#define NOFLSH	0000200
#define TOSTOP	0000400
#ifdef __USE_MISC
# define ECHOCTL 0001000
# define ECHOPRT 0002000
# define ECHOKE	 0004000
# define FLUSHO	 0010000
# define PENDIN	 0040000
#endif
#define IEXTEN	0100000

/* tcflow() and TCXONC use these */
#define	TCOOFF		0
#define	TCOON		1
#define	TCIOFF		2
#define	TCION		3

/* tcflush() and TCFLSH use these */
#define	TCIFLUSH	0
#define	TCOFLUSH	1
#define	TCIOFLUSH	2

/* tcsetattr uses these */
#define	TCSANOW		0
#define	TCSADRAIN	1
#define	TCSAFLUSH	2


#define _IOT_termios /* Hurd ioctl type field.  */ \
  _IOT (_IOTS (cflag_t), 4, _IOTS (cc_t), NCCS, _IOTS (speed_t), 2)


int tcgetattr ( int fd, struct termios *termios_p );
int tcsetattr ( int fd, int optional_actions, struct termios *termios_p);
#endif
#endif

#endif
