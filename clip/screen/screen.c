
/*
   $Log: screen.c,v $
   Revision 1.80  2002/06/22 09:34:16  clip
   uri: shift & alt залипание

   Revision 1.79  2002/05/31 09:32:20  clip
   again label under CYGWIN

   Revision 1.78  2002/05/28 10:54:59  clip
   uri: trapshift(),trapanykey(),keysend() added

   Revision 1.77  2002/05/28 06:48:27  clip
   scankey tricks
   paul

   Revision 1.76  2002/05/27 14:10:59  clip
   scankey fix
   paul

   Revision 1.75  2002/05/27 11:17:58  clip
   scankey() fix
   paul

   Revision 1.74  2002/05/27 09:52:41  clip
   uri: added "set fopen mode DOS|POSIX"

   Revision 1.73  2002/05/18 11:59:06  clip
   fix for f13-f20 func keys, as shift-F
   paul

   Revision 1.72  2002/04/24 09:51:14  clip
   _SET_DISPBOX turn off pg char translation
   paul

   Revision 1.71  2002/04/09 12:14:04  clip
   screen patches by Przemyslaw Czerpak
   paul

   Revision 1.70  2002/03/27 14:41:11  clip
   fix for Blink attribute
   paul

   Revision 1.69  2002/03/25 10:53:46  clip
   wrong i18n messages recoding
   paul

   Revision 1.68  2002/03/25 09:10:59  clip
   full move locale.po/ru to locale.po/ru_RU.KOI8-R
   paul

   Revision 1.67  2002/03/15 11:49:42  clip
   fix for Numlock key scancode in win >= 2k
   paul

   Revision 1.66  2002/03/05 11:52:44  clip
   redrawing on console fix 'д'
   paul

   Revision 1.65  2002/03/05 09:39:47  clip
   box drawing in scan mode
   paul

   Revision 1.64  2002/02/01 10:00:54  clip
   charset improvments
   paul

   Revision 1.63  2002/01/30 08:20:07  clip
   cigwin PG_CHARS fixes
   bzip2 func prefix auto-configuration
   paul

   Revision 1.62  2002/01/16 15:29:08  clip
   chinese patch
   preproc bugs
   some pseudographic chars < 32
   paul

   Revision 1.61  2001/12/11 07:48:25  clip
   middle mouse button
   paul

   Revision 1.60  2001/11/30 14:09:35  clip
   mouse & f1 esc conflict
   paul

   Revision 1.59  2001/11/28 12:41:38  clip
   mouse under cygwin
   paul

   Revision 1.58  2001/11/28 09:46:29  clip
   scanmode mouse events
   paul

   Revision 1.57  2001/11/27 16:02:55  clip
   mouse fixes
   paul

   Revision 1.56  2001/11/27 15:45:41  clip
   fixes for mouse
   paul

   Revision 1.55  2001/11/27 15:03:42  clip
   thish fucked comment

   Revision 1.54  2001/11/27 15:02:42  clip
   XTERM_MOUSE envar

   Revision 1.53  2001/11/27 13:46:15  clip
   mouse functions now work in xterm/rxvt terminals
   paul

   Revision 1.51  2001/11/26 15:39:50  clip
   Linux console GPM mouse handling
   paul

   Revision 1.50  2001/11/16 13:06:26  clip
   CYGWIN w32_hStdIn initialsation
   paul

   Revision 1.49  2001/11/16 11:40:01  clip
   export w32_hStdIn for CYGWIN tasks
   paul

   Revision 1.48  2001/11/16 10:15:59  clip
   CYGWIN & tasks
   paul

   Revision 1.47  2001/11/09 06:38:28  clip
   add terminfo catalog to $CLIPROOT/etc and it's usage in screen.c
   paul

   Revision 1.46  2001/11/08 09:30:40  clip
   high-color background fix
   paul

   Revision 1.45  2001/11/08 08:26:56  clip
   pseudographics & colors redraw fix
   paul

   Revision 1.44  2001/11/07 12:21:19  clip
   now absent termcap/terminfo under CYGWIN in w32 console mode is not error
   paul

   Revision 1.43  2001/10/29 11:56:34  clip
   fix for BLINK(intensitive background)
   paul

   Revision 1.42  2001/10/29 06:51:21  clip
   fix text fopen modes
   paul

   Revision 1.41  2001/09/12 10:13:12  clip
   export some funcs
   paul

   Revision 1.40  2001/09/11 12:28:10  clip
   changes
   paul

   Revision 1.39  2001/09/05 07:37:45  clip
   cygwin
   paul

   Revision 1.38  2001/07/26 13:31:05  clip
   last position in scroll
   paul

   Revision 1.37  2001/05/30 10:19:44  clip
   VT switch in scan mode on console
   paul

   Revision 1.36  2001/05/15 10:34:28  clip
   memdebug
   paul

   Revision 1.35  2001/04/10 10:53:19  clip
   scroll
   paul

   Revision 1.34  2001/02/22 13:43:24  clip
   fix
   paul

   Revision 1.33  2001/02/22 13:26:50  clip
   inkey() bug
   paul

   Revision 1.32  2001/02/22 13:03:48  clip
   inkey()
   paul

   Revision 1.31  2001/02/01 13:05:06  clip
   debug links
   paul

   Revision 1.30  2000/12/21 07:41:50  clip
   termcap init
   paul

   Revision 1.29  2000/12/06 13:13:01  clip
   loadable charset tables. size 256
   paul

   Revision 1.28  2000/12/04 14:12:10  clip
   tab
   paul

   Revision 1.27  2000/12/04 12:39:03  clip
   pgchars
   paul

   Revision 1.26  2000/12/04 11:43:06  clip
   pg_chars
   paul

   Revision 1.25  2000/12/04 11:09:59  clip
   del scancode
   paul

   Revision 1.24  2000/12/04 10:49:23  clip
   keymaps
   paul

   Revision 1.23  2000/12/04 10:09:49  clip
   keymaps
   paul

   Revision 1.22  2000/12/03 13:18:23  clip
   getRaw now push scancodes in handler
   paul

   Revision 1.21  2000/12/03 10:52:56  clip
   scancodes
   paul

   Revision 1.20  2000/12/02 13:47:40  clip
   CLIPROOT now may be envar
   paul

   Revision 1.19  2000/12/02 12:46:57  clip
   scancodes
   paul

   Revision 1.18  2000/11/21 11:31:13  clip
   io
   paul

   Revision 1.17  2000/11/08 08:11:06  clip
   ctrlbreak fix
   paul

   Revision 1.16  2000/10/31 11:50:07  clip
   setcancel and set(_SET_CANCEL)
   paul

   Revision 1.15  2000/05/23 23:07:30  clip
   scroll
   Paul Lasarev <paul@itk.ru>

   Revision 1.14  2000/05/16 15:44:22  clip
   add kend
   Paul Lasarev <paul@itk.ru>

   Revision 1.13  2000/05/03 22:06:40  clip
   *** empty log message ***

   Revision 1.12  2000/05/03 21:40:27  clip
   *** empty log message ***

   Revision 1.11  2000/05/03 21:39:22  clip
   add set cursor shape

   Revision 1.10  2000/05/01 20:12:43  clip
   VMIN=1 VTIME=0

   Revision 1.9  2000/05/01 19:40:58  clip
   SunOS port

   Revision 1.8  2000/04/20 19:39:52  paul
   take lines & columns from termcap/terminfo, defaults to 25x80

   Revision 1.7  2000/04/13 17:38:47  paul
   f10-f12 keys

   Revision 1.6  2000/03/10 15:56:10  paul
   xon/xoff gluk

   Revision 1.5  2000/03/07 13:35:03  paul
   fix bug with repeated GetKey_Wait

   Revision 1.4  1999/12/10 19:39:44  paul
   add correct terminal init/resume

   Revision 1.3  1999/12/04 19:15:13  uri
   новый gcc

   Revision 1.2  1999/11/02 23:05:52  axl
   start of logging CVS

 */

#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <termios.h>
#include <sys/ioctl.h>
#include <ctype.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>

#include "screen.h"
#include "tcaps.h"
#include "charset.h"
#include "scankey.h"
#include "../clip.h"

#ifdef OS_CYGWIN

#include <w32api/windows.h>
#include <sys/cygwin.h>

static int w32_console = 0;
static CHAR_INFO *w32_screen = 0;
static COORD w32_size, w32_beg, w32_end;
HANDLE w32_hStdIn = INVALID_HANDLE_VALUE, w32_hStdOut = INVALID_HANDLE_VALUE;	/* standard input, output handles */
static unsigned char *w32_scan_buf = 0;
static int w32_scan_buf_len = 0;
static int w32_scan_buf_size = 0;
static int w32_scrsize = 0;

static void w32_flush(void);
static void w32_clear(void);
static void w32_set_cursor_shape(int cursor);
static void w32_set_cursor(int r, int c);
static void w32_beep(void);
static int w32_readch(void);

#ifdef USE_TASKS
#include "../task/task.h"
#endif

#endif

#ifndef timercmp
#define	timercmp(a, b, CMP) 						      \
  (((a)->tv_sec == (b)->tv_sec) ? 					      \
   ((a)->tv_usec CMP (b)->tv_usec) : 					      \
   ((a)->tv_sec CMP (b)->tv_sec))
#endif

#ifdef HAVE_GPM_H

#include <gpm.h>

static Gpm_Connect conn;

#endif

#define RAWMODE_ESC 117

static int xterm_mouse = 0, xterm_pos = 0, xterm_buttons = 0, xterm_x = 0, xterm_y = 0;

#if 0
#define GPM_XTERM_ON \
  printf("%c[?1001s",27), fflush(stdout), /* save old hilit tracking */ \
  printf("%c[?1000h",27), fflush(stdout)	/* enable mouse tracking */

#define GPM_XTERM_OFF \
  printf("%c[?1000l",27), fflush(stdout), /* disable mouse tracking */ \
  printf("%c[?1001r",27), fflush(stdout)	/* restore old hilittracking */
#endif

extern char *CLIPROOT;

static void init_mouse(ScreenBase * base, char **envp);

#define Meta1_key 0x10000
#define Meta2_key 0x20000
#define National_key 0x30000

static char *FNAMES[] = {
	"/etc/terminfo",
	"/usr/lib/terminfo",
	"/usr/share/terminfo",
	"/usr/share/lib/terminfo",
	"/usr/share/misc/termcap",
	"/etc/termcap",
};

#define FSTDNUM  4
#define FNUM  6

/* cursor goto handling with padding/delay checking */
void scr_tgoto(char *CM, int destcol, int destline, char *buf, int buflen);
int scr_tputs(const char *str, int affcnt, int (*put_c) (int, void *), void *par);

static char *scan_start = 0;
static char *scan_stop = 0;
typedef enum
{
	ScanNone = 0,
	ScanIoctl,
	ScanTerminal,
}
ScanMode;
ScanMode scr_scan_mode = ScanNone;
static void start_scan_mode(int fd);
static void stop_scan_mode(int fd);
static unsigned long get_wait_key(ScreenBase * base, long milliseconds, int raw);

typedef struct
{
	char *str;
	unsigned long val;
	int strlen;
}
Keytab;

static const Keytab init_keytab[] = {
	{0, Meta1_key,},	/* meta1 */
	{0, Meta2_key,},	/* meta2 */
	{0, National_key,},	/* national */

				/* 3 */ {0, KEY_LEFT,},
				/* "kl" */
	{0, KEY_RIGHT,},	/* "kr" */
	{0, KEY_UP,},		/* "ku" */
	{0, KEY_DOWN,},		/* "kd" */
				/*7*/ {0, KEY_PGDN,},
				/* "kN" */
	{0, KEY_PGUP,},		/* "kP" */
	{0, KEY_HOME,},		/* "kh" */
				/*10*/ {0, KEY_END,},
				/* "kH" */
	{0, KEY_INS,},		/* "kI" */
	{0, KEY_BS,},		/* "kb" */
	{0, KEY_DEL,},		/* "kD" */

				/* 14 */ {0, KEY_F1},
				/* "k1" */
	{0, KEY_F2},		/* "k2" */
	{0, KEY_F3},		/* "k3" */
	{0, KEY_F4},		/* "k4" */
	{0, KEY_F5},		/* "k5" */
	{0, KEY_F6},		/* "k6" */
	{0, KEY_F7},		/* "k7" */
	{0, KEY_F8},		/* "k8" */
	{0, KEY_F9},		/* "k9" */
				/*23*/ {0, KEY_F10},
				/* "k0" */

				/*24*/ {0, KEY_F11},
				/* "k11" */
				/*25*/ {0, KEY_F12},
				/* "k12" */

	{0, KEY_F13},		/* "k13" */
	{0, KEY_F14},		/* "k14" */
	{0, KEY_F15},		/* "k15" */
	{0, KEY_F16},		/* "k16" */
	{0, KEY_F17},		/* "k17" */
	{0, KEY_F18},		/* "k18" */
	{0, KEY_F19},		/* "k19" */
	{0, KEY_F20},		/* "k20" */
/* 36 */
	/* ANSI  alternatives */
#if 0
	{"\033[M", KEY_F1,},
#else
	{"\033[M", KEY_MOUSE,},	/* start of XTERM mouse sequence \e[MCbCxCy */
#endif

	{"\033[N", KEY_F2,},
	{"\033[O", KEY_F3,},
	{"\033[P", KEY_F4,},
	{"\033[Q", KEY_F5,},
	{"\033[R", KEY_F6,},
	{"\033[S", KEY_F7,},
	{"\033[T", KEY_F8,},
	{"\033[U", KEY_F9,},
	{"\033[V", KEY_F10,},

	{"\033[D", KEY_LEFT,},
	{"\033[C", KEY_RIGHT,},
	{"\033[A", KEY_UP,},
	{"\033[B", KEY_DOWN,},
	{"\033[G", KEY_PGDN,},
	{"\033[I", KEY_PGUP,},
	{"\033[H", KEY_HOME,},
	{"\033[F", KEY_END,},
	{"\033[L", KEY_INS,},
	{"\010", KEY_BS,},
	{"\177", KEY_DEL,},

	/* vt100/linux  alternatives */

	{"\033[[A", KEY_F1,},
	{"\033[[B", KEY_F2,},
	{"\033[[C", KEY_F3,},
	{"\033[[D", KEY_F4,},
	{"\033[[E", KEY_F5,},

	/* some strange xterms */
	{"\033[11~", KEY_F1,},
	{"\033[12~", KEY_F2,},
	{"\033[13~", KEY_F3,},
	{"\033[14~", KEY_F4,},
	{"\033[15~", KEY_F5,},

	{"\033[17~", KEY_F6,},
	{"\033[18~", KEY_F7,},
	{"\033[19~", KEY_F8,},
	{"\033[20~", KEY_F9,},
	{"\033[21~", KEY_F10,},

	{"\033[23~", KEY_F11,},
	{"\033[24~", KEY_F12,},
	{"\033[25~", KEY_F13,},
	{"\033[26~", KEY_F14,},

	{"\033[28~", KEY_F15,},
	{"\033[29~", KEY_F16,},
	{"\033[30~", KEY_F17,},
	{"\033[31~", KEY_F18,},

	{"\033[33~", KEY_F19,},
	{"\033[34~", KEY_F20,},

/*
   { "\033[D",  KEY_LEFT ,   },
   { "\033[C",  KEY_RIGHT,  },
   { "\033[A",  KEY_UP   ,     },
   { "\033[B",  KEY_DOWN ,   },
 */
	{"\033[6~", KEY_PGDN,},
	{"\033[5~", KEY_PGUP,},
	{"\033[1~", KEY_HOME,},
	{"\033[4~", KEY_END,},
	{"\033[2~", KEY_INS,},
/*      { "\177",       KEY_BS   ,   }, */
	{"\033[3~", KEY_DEL,},

	/* Esc-key  alternatives */

	{"\033\061", KEY_F1,},
	{"\033\062", KEY_F2,},
	{"\033\063", KEY_F3,},
	{"\033\064", KEY_F4,},
	{"\033\065", KEY_F5,},
	{"\033\066", KEY_F6,},
	{"\033\067", KEY_F7,},
	{"\033\070", KEY_F8,},
	{"\033\071", KEY_F9,},
	{"\033\060", KEY_F10,},

	{"\033l", KEY_LEFT,},
	{"\033r", KEY_RIGHT,},
	{"\033u", KEY_UP,},
	{"\033d", KEY_DOWN,},
	{"\033n", KEY_PGDN,},
	{"\033p", KEY_PGUP,},
	{"\033h", KEY_HOME,},
	{"\033e", KEY_END,},
	{"\033i", KEY_INS,},
	{"\033s", KEY_BS,},
	{"\033b", KEY_DEL,},

	{"\033\033", 27,},

	{0, 0},
};

#define KEYTAB_SIZE (sizeof(init_keytab)/sizeof(Keytab))

typedef struct
{
	ScreenBase *base;

	int termcap_Visuals;
	int fd;
	Screen *realScreen;

	char *termcap_TI, *termcap_TE;
	char *termcap_KS, *termcap_KE;
	char *termcap_CM;

	char *termcap_GS, *termcap_GE;
	char *termcap_G1, *termcap_G2;
	char *termcap_AS, *termcap_AE;

	char *termcap_AC;
	char *termcap_AL, *termcap_DL;
	char *termcap_SF, *termcap_SR, *termcap_CS;
	char *termcap_CL, *termcap_CE;
	char *termcap_TS, *termcap_FS;
	int termcap_NF, termcap_NB;

	char *termcap_CF, *termcap_CB;
	char *termcap_MF, *termcap_MB;
	char *termcap_MD, *termcap_mb, *termcap_MH, *termcap_MR, *termcap_ME;
	char *termcap_SE, *termcap_SO;

	char *termcap_AF, *termcap_AB;
	char *termcap_SETF, *termcap_SETB;

	char *termcap_PO, *termcap_PF, *termcap_POO;
	char *termcap_Km, *termcap_Mi;
	char *termcap_Ct;

	char termcap_C2;
	char termcap_MS;
	int termcap_HS;

	char termcap_xo;
	int termcap_XN, termcap_XF;

	char *termcap_BL;

	char *termcap_IS;
	char *termcap_EA;

	char *termcap_VE;	/* normal visible */
	char *termcap_VS;	/* very visible */
	char *termcap_VI;	/* invisible */

	int termcap_lines;
	int termcap_columns;

	unsigned long next_key;

	unsigned char outbuf[1024];
	unsigned char *outptr;

	int lineDrawMode;
	int boldMode;
	int blinkMode;
	int useBlinkAttr, useBoldAttr;
	int oldcolor;
	int oldcursor;
	int matchpos, matchno, lomatch, himatch;
	int national_mode, has_meta1, has_meta2;
	int prev_national_mode, prev_has_meta1, prev_has_meta2;
	int key_count;

	short ctab[16], btab[16];
	int scrool, rscrool;

	char meta_key[16];
	char meta1_key[16];
	char meta2_key[16];
	char national_key[16];

	unsigned char nationalTable[128];
	unsigned char inputTable[256];
	unsigned char outputTable[256];
	unsigned char pgTable[256];

	struct termios start_mode;
	struct termios work_mode;

	int pg_mode;

	Keytab keytab[KEYTAB_SIZE];

	Terminfo terminfo;
}
ScreenData;

static struct termios start_mode;

static const char ascii_pg_chars[PG_SIZE] = " fv<>^#o:\\+>*-#+<++!#~--_#++++++|-++++++++|";

static void init_ScreenData(ScreenData * dp);
static void destroy_ScreenData(ScreenData * dp);

/* termcap statics { */

static void initKey(ScreenData * dp);
static void termcap_clear_screen(ScreenData * dp);
static void termcap_scroll(ScreenBase * base, int top, int bottom, int n);
static void termcap_put_char(ScreenData * dp, int ch);
static void termcap_put_graph_char(ScreenData * dp, int ch);

static int termcap_put_raw_char(int c, void *p);
static void termcap_put_raw_str(ScreenData * dp, const char *str);
static void termcap_flush(ScreenData * dp);
static void termcap_set_color(ScreenData * dp, int color);
static void termcap_set_fgbg(ScreenData * dp, int fg, int bg);
static void termcap_set_cursor(ScreenData * dp, int y, int x);
static void termcap_beep(ScreenData * dp);
static void termcap_set_cursor_shape(ScreenData * dp, int cursor);

#define VisualBold	1
#define VisualBlink	2
#define VisualDim	4
#define VisualInverse	8
#define VisualColors	16
#define VisualGraph	32

/* termcap statics }[ termcap init  */

static char *
skipDelay(char *cp)
{
	while (*cp >= '0' && *cp <= '9')
		++cp;
	if (*cp == '.')
	{
		++cp;
		while (*cp >= '0' && *cp <= '9')
			++cp;
	}
	if (*cp == '*')
		++cp;
	return (cp);
}

static const int cga_to_ansi[16] = {	/* ansi colors: */
	0,			/* 0black */
	4,			/* 1red */
	2,			/* 2green */
	6,			/* 3brown */
	1,			/* 4blue */
	5,			/* 5magenta */
	3,			/* 6cyan */
	7,			/* 7gray */
	0,
	4,
	2,
	6,
	1,
	5,
	3,
	7,
};

static void
setColorMap(ScreenData * dp, char *fg, char *bg)
{
	short buf[16];
	int i, fglen = 0;
	int bglen = 0;

	if (dp->termcap_NF > 16 || dp->termcap_NF < 0)
		dp->termcap_NF = 16;
	if (dp->termcap_NB > 16 || dp->termcap_NB < 0)
		dp->termcap_NB = 16;
	if (!dp->termcap_MF)
	{
		if (!strncasecmp(dp->base->terminalName, "pc3", 3))
			dp->termcap_MF = "0125436789ADCBEF";
		else
			dp->termcap_MF = "0123456789ABCDEF";
	}
	if (!dp->termcap_MB)
	{
		if (!strncasecmp(dp->base->terminalName, "pc3", 3))
			dp->termcap_MB = "0125436789ADCBEF";
		else
			dp->termcap_MB = "0123456789ABCDEF";
	}
	for (i = 0; i < 16; ++i)
		dp->ctab[i] = dp->btab[i] = -1;

	if (fg)
		fglen = strlen(fg);
	if (bg)
		bglen = strlen(bg);

	for (i = 0; i < 16 && i < dp->termcap_NF; ++i)
	{
		if (!dp->termcap_MF[i])
			break;
		else if (dp->termcap_MF[i] >= '0' && dp->termcap_MF[i] <= '9')
			dp->ctab[dp->termcap_MF[i] - '0'] = i;
		else if (dp->termcap_MF[i] >= 'A' && dp->termcap_MF[i] <= 'F')
			dp->ctab[dp->termcap_MF[i] - 'A' + 10] = i;
	}
	memcpy(buf, dp->ctab, sizeof(buf));
	for (i = 0; i < 16 && i < dp->termcap_NF && i < fglen; ++i)
	{
		if (fg[i] >= '0' && fg[i] <= '9')
			dp->ctab[i] = buf[fg[i] - '0'];
		else if (fg[i] >= 'A' && fg[i] <= 'F')
			dp->ctab[i] = buf[fg[i] - 'A' + 10];
	}
	for (i = 0; i < 16 && i < dp->termcap_NB; ++i)
	{
		if (!dp->termcap_MB[i])
			break;
		else if (dp->termcap_MB[i] >= '0' && dp->termcap_MB[i] <= '9')
			dp->btab[dp->termcap_MB[i] - '0'] = i;
		else if (dp->termcap_MF[i] >= 'A' && dp->termcap_MF[i] <= 'F')
			dp->btab[dp->termcap_MB[i] - 'A' + 10] = i;
	}
	memcpy(buf, dp->btab, sizeof(buf));
	for (i = 0; i < 16 && i < dp->termcap_NB && i < bglen; ++i)
	{
		if (bg[i] >= '0' && bg[i] <= '9')
			dp->btab[i] = buf[bg[i] - '0'];
		else if (bg[i] >= 'A' && bg[i] <= 'F')
			dp->btab[i] = buf[bg[i] - 'A' + 10];
	}
	for (i = 1; i < 8; ++i)
	{
		if (dp->ctab[i] >= 0 && dp->ctab[i + 8] < 0)
			dp->ctab[i + 8] = dp->ctab[i];
		if (dp->ctab[i + 8] >= 0 && dp->ctab[i] < 0)
			dp->ctab[i] = dp->ctab[i + 8];
		if (dp->btab[i] >= 0 && dp->btab[i + 8] < 0)
			dp->btab[i + 8] = dp->btab[i];
		if (dp->btab[i + 8] >= 0 && dp->btab[i] < 0)
			dp->btab[i] = dp->btab[i + 8];
	}
}

int
restore_tty(ScreenBase * base)
{
	ScreenData *dp = (ScreenData *) base->data;

#ifdef OS_CYGWIN
	if (w32_console)
		return 0;
#endif
	return tcsetattr(base->fd, TCSADRAIN, &dp->start_mode);
}

int
restart_tty(ScreenBase * base)
{
	struct termios ts;
	ScreenData *dp = (ScreenData *) base->data;

#ifdef OS_CYGWIN
	if (w32_console)
		return 0;
#endif
	tcgetattr(base->fd, &ts);
	ts.c_iflag &= ~(IGNBRK | BRKINT | PARMRK | ISTRIP | INLCR | IGNCR | ICRNL | IXON);
	ts.c_oflag &= ~OPOST;
	ts.c_oflag |= ONLCR | OPOST;
	ts.c_lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);
	ts.c_lflag |= ISIG;
	ts.c_cflag &= ~(CSIZE | PARENB);
	ts.c_cflag |= CS8;
	if (scr_scan_mode)
	{
		int i;

		for (i = 0; i < NCCS; i++)
			ts.c_cc[i] = 0;
	}
	else
		ts.c_cc[VINTR] = 'C' - '@';

	ts.c_cc[VTIME] = 0;
	ts.c_cc[VMIN] = 1;

	if (!scr_scan_mode && dp->termcap_xo)
	{
		ts.c_cc[VSTOP] = dp->termcap_XF;
		ts.c_cc[VSTART] = dp->termcap_XN;
		ts.c_iflag |= IXON;
	}
	else
	{
		ts.c_iflag &= ~IXON;
	}

	dp->work_mode = ts;

	return tcsetattr(base->fd, TCSANOW, &ts);
}

static void
exit_tty()
{
#if 0
	termcap_put_raw_str(termcap_ME);
	termcap_set_color(COLOR_WHITE | COLOR_BACK_BLACK);
	if (clear_on_exit)
		termcap_clear_screen();
	termcap_set_cursor(Lines - 1, 0);
	termcap_put_raw_str(termcap_TE);
	termcap_put_raw_str(termcap_KE);
	termcap_flush();
#endif
	stop_scan_mode(0);
#ifdef OS_CYGWIN
	if (w32_console)
		return;
#endif

#ifndef OS_CYGWIN
	if (xterm_mouse)	/* xterm */
	{
		const char msg[] = "\033[?1000l\033[?1001r";

		write(1, msg, sizeof(msg) - 1);
	}
#endif

#ifdef HAVE_GPM_H
	if (gpm_fd >= 0)
		Gpm_Close();
#endif

	tcsetattr(0, TCSADRAIN, &start_mode);
}

static void
squeesh_entry(char *entry)
{
	int i, l = strlen(entry);
	char *s = entry;

	for (i = 0; i < l - 2;)
	{
		if (s[i] == '%' && s[i + 1] == 'p' && isdigit(s[i + 2]))
		{
			memmove(s + i, s + i + 3, l - i - 2);
			l -= 3;
		}
		else
			i++;
	}
}

static void
squeesh_if_need(char *entry)
{
	static int need_squeesh = 0, first = 1;

	if (first)
	{
		/* check for old-style tgoto - it don't und. %p1 */
		char buf[32];

		scr_tgoto("%p1%d", 2, 10, buf, sizeof(buf));
		if (strcmp(buf, "10"))
			need_squeesh = 1;
		first = 0;
	}
	if (need_squeesh)
		squeesh_entry(entry);
}

static char *
get_env(char **envp, char *name)
{
	char *s;
	int l;
	int ln = strlen(name);

	for (; (s = *envp); ++envp)
	{
		l = strcspn(s, "=");
		if (ln == l && !memcmp(name, s, l))
		{
			s += l;
			if (*s)
				return s + 1;
			else
				return s;
		}
	}
	return 0;
}

static char *
read_oct(char *p)
{
	char *r, *s;
	char c;

	r = s = strdup(p);
	while ((c = *p))
	{
		if (c == '\\')
		{
			p++;
			c = *p;
			if (!c)
				break;
			switch (c)
			{
			case '0':
			case '1':
			case '2':
			case '3':
			case '4':
			case '5':
			case '6':
			case '7':
				if (p[1] && p[2] && isdigit(p[1]) && isdigit(p[2]))
				{
					c = strtol(p, 0, 8);
					p += 2;
				}
				break;
			case 't':
				c = '\t';
				break;
			case 'n':
				c = '\n';
				break;
			case 'r':
				c = '\r';
				break;
			case 'b':
				c = '\b';
				break;
			case 'v':
				c = '\v';
				break;
			case 'e':
				c = '\033';
				break;
			case 'a':
				c = '\007';
				break;
			}
		}

		*s = c;
		s++;

		p++;
	}
	*s = 0;
	return r;
}

int
init_tty(ScreenBase * base, int fd, char **envp, int Clear_on_exit, ScreenPgChars * pg_table, char *errbuf, int errbuflen)
{
	ScreenData *dp;
	char *p;
	struct winsize ws;
	int i, tfd;
	int translateGraphMode = 0;
	static int first = 1;
	char *tcap;
	int fnum;
	char **fnames, *fbuf;
	int col = 0, row = 0;
	int ret = 0;

	memset(base, 0, sizeof(ScreenBase));

	base->fd = fd;
	base->clear_on_exit = Clear_on_exit;

	if (!isatty(fd))
	{
		snprintf(errbuf, errbuflen, "can run only on terminal");
		return -1;
	}

	p = get_env(envp, "TERM");
	if (!p)
		base->terminalName = strdup("ansi");
	else
		base->terminalName = strdup(p);

	dp = (ScreenData *) calloc(sizeof(ScreenData), 1);
	base->data = dp;

	init_Terminfo(&dp->terminfo);

	dp->terminfo.name = base->terminalName;

#ifdef OS_CYGWIN
	p = get_env(envp, "CLIP_W32CONSOLE");
	if (p && *p)
	{
		if (!strcasecmp(p, "yes"))
		{
			CONSOLE_SCREEN_BUFFER_INFO info;

			if (w32_hStdOut == INVALID_HANDLE_VALUE)
				w32_hStdOut = GetStdHandle(STD_OUTPUT_HANDLE);
			if (w32_hStdIn == INVALID_HANDLE_VALUE)
				w32_hStdIn = GetStdHandle(STD_INPUT_HANDLE);
			if (w32_hStdOut == INVALID_HANDLE_VALUE || w32_hStdIn == INVALID_HANDLE_VALUE)
			{
				snprintf(errbuf, errbuflen, "cannot take w32 console");
				return -1;
			}
			/* set up mouse and window input */
			if (!SetConsoleMode(w32_hStdIn, ENABLE_MOUSE_INPUT))
			{
				snprintf(errbuf, errbuflen, "cannot set w32 console mode");
				return -1;
			}
			GetConsoleScreenBufferInfo(w32_hStdOut, &info);
			base->Columns = info.dwSize.X;
			base->Lines = info.dwSize.Y;
			col = info.dwCursorPosition.X;
			row = info.dwCursorPosition.Y;
			w32_console = 1;
			scr_scan_mode = ScanIoctl;
		}
	}

#endif

	tcap = get_env(envp, "TERMCAP");
	if (!tcap)
		tcap = get_env(envp, "TERMINFO");
	fnum = FNUM + 2;
	fnames = (char **) alloca(sizeof(char *) * fnum);

	for (i = 0; i < FSTDNUM; i++)
		fnames[i] = FNAMES[i];
	fnames[FSTDNUM] = (char *) alloca(256);
	snprintf(fnames[FSTDNUM], 256, "%s/etc/terminfo", CLIPROOT);
	fnames[FSTDNUM + 1] = (char *) alloca(256);
	snprintf(fnames[FSTDNUM + 1], 256, "%s/etc/termcap", CLIPROOT);
	for (; i < FNUM; i++)
		fnames[i + 2] = FNAMES[i];

	if (tcap && *tcap)
	{
		char *slp = strchr(tcap, '/');
		char *clp = strchr(tcap, ':');
		char *vlp = strchr(tcap, '|');

		if (slp && (!clp || clp > slp) && (!vlp || (vlp > clp && vlp > slp)))
		{
			/* tcap is a list of files */
			char *s;
			int l;

			fnum = 0;
			for (s = tcap; *s;)
			{
				l = strcspn(s, ":");
				fnum++;
				s += l;
				if (!*s)
					break;
				s++;
				l = strspn(s, ":");
				s += l;
			}

			fnames = (char **) alloca(sizeof(char *) * fnum);

			fbuf = (char *) alloca((l = (strlen(tcap) + 1)));
			memcpy(fbuf, tcap, l);

			fnum = 0;
			for (s = fbuf; *s;)
			{
				fnames[fnum] = s;
				l = strcspn(s, ":");
				fnum++;
				s += l;
				if (!*s)
					break;
				*s++ = 0;
				l = strspn(s, ":");
				s += l;
			}
			if (read_term(fnum, fnames, 1, &dp->terminfo, errbuf, errbuflen))
			{
#ifdef OS_CYGWIN
				if (!w32_console)
#endif
					return -1;
			}
		}
		else
		{
			/* tcap is a termcap entry */
			if (read_tcapbuf(tcap, &dp->terminfo, errbuf, errbuflen))
			{
#ifdef OS_CYGWIN
				if (!w32_console)
#endif
					return -1;
			}
		}
	}
	else if (read_term(fnum, fnames, 1, &dp->terminfo, errbuf, errbuflen))
	{
#ifdef OS_CYGWIN
		if (!w32_console)
#endif
			return -1;
	}

	p = get_env(envp, "LINS");
	if (p && *p)
		base->Lines = atoi(p);
	p = get_env(envp, "LINES");
	if (p && *p)
		base->Lines = atoi(p);
	p = get_env(envp, "COLS");
	if (p && *p)
		base->Columns = atoi(p);
	p = get_env(envp, "COLUMNS");
	if (p && *p)
		base->Columns = atoi(p);
	dp->fd = fd;
	init_ScreenData(dp);
	dp->base = base;

#ifdef OS_CYGWIN
	if (!w32_console)
	{
#endif
		if (!dp->termcap_CM)
		{
			snprintf(errbuf, errbuflen, "too dumb terminal '%s' (no cursor move capabilitie)", base->terminalName);
			free(base->terminalName);
			destroy_ScreenData(dp);
			free(dp);
			return -1;
		}
#ifdef OS_CYGWIN
	}
#endif

	if (ioctl(fd, TIOCGWINSZ, &ws) != -1)
	{
		if (ws.ws_row > 0)
			base->Lines = ws.ws_row;
		if (ws.ws_col > 0)
			base->Columns = ws.ws_col;
	}

	if (!base->Lines && dp->termcap_lines > 0)
		base->Lines = dp->termcap_lines;

	if (!base->Columns && dp->termcap_columns > 0)
		base->Columns = dp->termcap_columns;

	if (!base->Lines && !base->Columns)
	{
		base->Lines = 25;
		base->Columns = 80;
	}

	if (!base->Lines)
		base->Lines = 25;
	if (!base->Columns)
		base->Columns = 80;

	if (base->Lines < 2 || base->Columns <= 10)
	{
		snprintf(errbuf, errbuflen, "too small screen: is: %dx%d need: 2x10", base->Lines, base->Columns);
		return -1;
	}

	if (pg_table)
		memcpy(dp->pgTable, pg_table, 256);

	memcpy(base->pg_chars, ascii_pg_chars, PG_SIZE);
	squeesh_if_need(dp->termcap_CM);

	dp->scrool = dp->termcap_AL && dp->termcap_DL;
	if (!(dp->rscrool = dp->termcap_SF && dp->termcap_SR))
		dp->termcap_SF = dp->termcap_SR = 0;

	if (dp->termcap_ME)
	{
		if (dp->termcap_SO)
			dp->termcap_SO = skipDelay(dp->termcap_SO);
		else if (dp->termcap_MR)
			dp->termcap_SO = skipDelay(dp->termcap_MR);
	}

	dp->termcap_Visuals = 0;
	if ((dp->termcap_NF > 0 && dp->termcap_NB > 0 && dp->termcap_CF && (dp->termcap_CB || dp->termcap_C2))
	    || (dp->termcap_AF && dp->termcap_AB) || (dp->termcap_SETF && dp->termcap_SETB))
	{
		if (!dp->termcap_NF)
			dp->termcap_NF = 16;
		if (!dp->termcap_NB)
			dp->termcap_NB = 16;
		dp->termcap_Visuals |= VisualColors;
		if (dp->termcap_CF /* && strstr(dp->termcap_CF,"%p1") */ )
			squeesh_if_need(dp->termcap_CF);
		if (dp->termcap_CB)
			squeesh_if_need(dp->termcap_CB);
		if (dp->termcap_AB)
			squeesh_if_need(dp->termcap_AB);
		if (dp->termcap_AF)
			squeesh_if_need(dp->termcap_AF);
		if (dp->termcap_SETF)
			squeesh_if_need(dp->termcap_SETF);
		if (dp->termcap_SETB)
			squeesh_if_need(dp->termcap_SETB);
	}
	if (dp->termcap_MH)
		dp->termcap_Visuals |= VisualDim;
	if (dp->termcap_MD)
		dp->termcap_Visuals |= VisualBold;
	if (dp->termcap_mb)
		dp->termcap_Visuals |= VisualBlink;
	if (dp->termcap_SO)
		dp->termcap_Visuals |= VisualInverse;
	if (dp->termcap_G1 || dp->termcap_G2 || dp->termcap_AC)
		dp->termcap_Visuals |= VisualGraph;

	if (dp->termcap_Visuals & VisualColors)
		setColorMap(dp, "0123456789ABCDEF", "0123456789ABCDEF");
	else
		dp->termcap_CE = 0;	/* Don't use clear to end of line. */

	p = get_env(envp, "CLIP_COLORMAP");
	if (p && *p)
		setColorMap(dp, p, p);

	for (i = 0; i < 256; ++i)
		dp->inputTable[i] = i /*+ 256 */ ;
	for (i = 0; i < 256; ++i)
		dp->outputTable[i] = i /*+ 256 */ ;
	/*dp->outputTable[127] = 0xdf; */

	if (dp->termcap_Ct && (tfd = open(dp->termcap_Ct, O_RDONLY)) >= 0)
	{
		read(tfd, dp->outputTable + 128 + 64, 64);	/* koi8 alpha's out translation */
		read(tfd, dp->nationalTable + 32, 96);	/* 96-RED CYRILLIC 128 - NORMAL CYRILLIC TRANSLATION */
		read(tfd, dp->inputTable + 128, 128);
		if (read(tfd, dp->outputTable + 128, 64) == 64)	/* koi8 pseudograph out translation */
			translateGraphMode = 1;

		close(tfd);
	}

	{
		char *p1, *p2;
		cons_CharsetEntry *cs1 = 0, *cs2 = 0;
		int len1 = 0, len2 = 0;

		p1 = get_env(envp, "CLIP_HOSTCS");
		p2 = get_env(envp, "CLIP_CLIENTCS");
		if (!p1 || !p2 || !*p1 || !*p2)
			goto norm;

		if (load_charset_name(p1, &cs1, &len1))
		{
			snprintf(errbuf, errbuflen, "cannot load charset file '%s': %s", p1, strerror(errno));
			ret = 1;
			goto norm;
		}

		if (load_charset_name(p2, &cs2, &len2))
		{
			snprintf(errbuf, errbuflen, "cannot load charset file '%s': %s", p2, strerror(errno));
			ret = 2;
			goto norm;
		}

		_clip_logg(3, "set out translation: %s -> %s", p1, p2);

		make_translation(cs1, len1, cs2, len2, dp->outputTable);
		make_translation(cs2, len2, cs1, len1, dp->inputTable);

		free(cs1);
		free(cs2);

	      norm:
	}

	if (dp->termcap_Visuals & VisualGraph)
	{
		char *g1 = dp->termcap_G1;
		char *g2 = dp->termcap_G2;
		char *p;

		p = get_env(envp, "CLIP_LINECHARS");
		if (p && *p)
			g1 = read_oct(p);
		p = get_env(envp, "CLIP_DLINECHARS");
		if (p && *p)
			g2 = read_oct(p);

		if (g2 && !g1)
			g1 = g2;
		if (g1 && !g2)
			g2 = g1;

		if (translateGraphMode)
		{
			/* use RFC KOI8 standart:
			   :g1=\200\201\204\211\205\206\212\207\202\210\203:
			   :g2=\240\241\253\273\256\261\276\265\245\270\250:
			 */
			g1 = "\200\201\204\211\205\206\212\207\202\210\203";
			g2 = "\240\241\253\273\256\261\276\265\245\270\250";
		}
		if (g1)
		{
			i = strlen(g1);
			if (i > 0)
				base->pg_chars[PG_HLINE] = g1[0];
			if (i > 1)
				base->pg_chars[PG_VLINE] = g1[1];
			if (i > 2)
				base->pg_chars[PG_LLCORNER] = g1[2];
			if (i > 3)
				base->pg_chars[PG_BTEE] = g1[3];
			if (i > 4)
				base->pg_chars[PG_LRCORNER] = g1[4];
			if (i > 5)
				base->pg_chars[PG_LTEE] = g1[5];
			if (i > 6)
				base->pg_chars[PG_PLUS] = g1[6];
			if (i > 7)
				base->pg_chars[PG_RTEE] = g1[7];
			if (i > 8)
				base->pg_chars[PG_ULCORNER] = g1[8];
			if (i > 9)
				base->pg_chars[PG_TTEE] = g1[9];
			if (i > 10)
				base->pg_chars[PG_URCORNER] = g1[10];

			if (g2)
			{
				i = strlen(g2);
				if (i > 0)
					base->pg_chars[PG_HLINE2] = g2[0];
				if (i > 1)
					base->pg_chars[PG_VLINE2] = g2[1];
				if (i > 2)
					base->pg_chars[PG_LLCORNER2] = g2[2];
				if (i > 3)
					base->pg_chars[PG_BTEE2] = g2[3];
				if (i > 4)
					base->pg_chars[PG_LRCORNER2] = g2[4];
				if (i > 5)
					base->pg_chars[PG_LTEE2] = g2[5];
				if (i > 6)
					base->pg_chars[PG_PLUS2] = g2[6];
				if (i > 7)
					base->pg_chars[PG_RTEE2] = g2[7];
				if (i > 8)
					base->pg_chars[PG_ULCORNER2] = g2[8];
				if (i > 9)
					base->pg_chars[PG_TTEE2] = g2[9];
				if (i > 10)
					base->pg_chars[PG_URCORNER2] = g2[10];

			}
		}
		else if (dp->termcap_AC)
		{
			int l, i;
			char *s = dp->termcap_AC;
			unsigned char *pg_chars = base->pg_chars;

			l = strlen(s);
			if (l % 2)
				l--;

			for (i = 0; i < l; i += 2)
			{
				switch (s[i])
				{
				case '}':
					pg_chars[PG_STERLING] = s[i + 1];
					break;
				case '.':
					pg_chars[PG_DARROW] = s[i + 1];
					break;
				case ',':
					pg_chars[PG_LARROW] = s[i + 1];
					break;
				case '+':
					pg_chars[PG_RARROW] = s[i + 1];
					break;
				case '-':
					pg_chars[PG_UARROW] = s[i + 1];
					break;
				case 'h':
					pg_chars[PG_BOARD] = s[i + 1];
					break;
				case '~':
					pg_chars[PG_BULLET] = s[i + 1];
					break;
				case 'a':
					pg_chars[PG_CKBOARD] = s[i + 1];
					break;
				case 'f':
					pg_chars[PG_DEGREE] = s[i + 1];
					break;
				case 'z':
					pg_chars[PG_GEQUAL] = s[i + 1];
					break;
				case '{':
					pg_chars[PG_PI] = s[i + 1];
					break;
				case 'q':
					pg_chars[PG_HLINE2] = pg_chars[PG_HLINE] = s[i + 1];
					break;
				case 'i':
					pg_chars[PG_LANTERN] = s[i + 1];
					break;
				case 'n':
					pg_chars[PG_PLUS2] = pg_chars[PG_PLUS] = s[i + 1];
					break;
				case 'y':
					pg_chars[PG_LEQUAL] = s[i + 1];
					break;
				case 'm':
					pg_chars[PG_LLCORNER2] = pg_chars[PG_LLCORNER] = s[i + 1];
					break;
				case 'j':
					pg_chars[PG_LRCORNER2] = pg_chars[PG_LRCORNER] = s[i + 1];
					break;
				case '|':
					pg_chars[PG_NEQUAL] = s[i + 1];
					break;
				case 'g':
					pg_chars[PG_PLMINUS] = s[i + 1];
					break;
				case 'o':
					pg_chars[PG_S1] = s[i + 1];
					break;
				case 'p':
					pg_chars[PG_S3] = s[i + 1];
					break;
				case 'r':
					pg_chars[PG_S7] = s[i + 1];
					break;
				case 's':
					pg_chars[PG_S9] = s[i + 1];
					break;
				case '0':
					pg_chars[PG_BLOCK] = s[i + 1];
					break;
				case 'w':
					pg_chars[PG_TTEE2] = pg_chars[PG_TTEE] = s[i + 1];
					break;
				case 'u':
					pg_chars[PG_RTEE2] = pg_chars[PG_RTEE] = s[i + 1];
					break;
				case 't':
					pg_chars[PG_LTEE2] = pg_chars[PG_LTEE] = s[i + 1];
					break;
				case 'v':
					pg_chars[PG_BTEE2] = pg_chars[PG_BTEE] = s[i + 1];
					break;
				case 'l':
					pg_chars[PG_ULCORNER2] = pg_chars[PG_ULCORNER] = s[i + 1];
					break;
				case 'k':
					pg_chars[PG_URCORNER2] = pg_chars[PG_URCORNER] = s[i + 1];
					break;
				case 'x':
					pg_chars[PG_VLINE2] = pg_chars[PG_VLINE] = s[i + 1];
					break;
				}
			}
		}
	}

	p = get_env(envp, "CLIP_SCANSTART");
	if (p && *p)
		scan_start = read_oct(p);

	p = get_env(envp, "CLIP_SCANSTOP");
	if (p && *p)
		scan_stop = read_oct(p);

	p = get_env(envp, "CLIP_KEYMAP");
	if (p && *p)
	{
		char path[256];
		FILE *file;

		snprintf(path, sizeof(path), "%s/keymaps/%s", CLIPROOT, p);

		file = fopen(path, "rt");
		if (!file)
		{
			snprintf(errbuf, errbuflen, "cannot read keymap file '%s': %s", path, strerror(errno));
			return -1;
		}
		if (load_keymap(file, errbuf, errbuflen))
		{
			fclose(file);
			return -1;
		}
		fclose(file);
	}

	p = get_env(envp, "CLIP_SCANMODE");
	if (p && *p)
	{
		if (!strcasecmp(p, "ioctl"))
			scr_scan_mode = ScanIoctl;
		else if (!strcasecmp(p, "terminal"))
			scr_scan_mode = ScanTerminal;
	}

#ifdef OS_CYGWIN
	if (!w32_console)
#endif
		tcgetattr(dp->fd, &dp->start_mode);
	if (first)
	{
		start_scan_mode(0);

#ifdef OS_CYGWIN
		if (!w32_console)
#endif
			tcgetattr(0, &start_mode);
		first = 0;
		atexit(exit_tty);
	}

	restart_tty(base);
	base->realScreen = new_Screen(base);
	base->realScreen->y = row;
	base->realScreen->x = col;

#ifdef OS_CYGWIN
	if (w32_console)
	{
		CHAR_INFO p;
		int i;

		w32_size.X = base->Columns;
		w32_size.Y = base->Lines;
		w32_scrsize = base->Lines * base->Columns;
		w32_screen = (CHAR_INFO *) malloc(w32_scrsize * sizeof(CHAR_INFO));

		p.Char.AsciiChar = ' ';
		p.Attributes = 7;
		for (i = 0; i < w32_scrsize; i++)
			w32_screen[i] = p;
		w32_beg.X = 0;
		w32_beg.Y = 0;
		w32_end.X = w32_size.X - 1;
		w32_end.Y = w32_size.Y - 1;
		if (Clear_on_exit)
		{
			w32_flush();
		}
	}
	else
#endif
	{
		termcap_put_raw_str(dp, dp->termcap_IS);
		termcap_put_raw_str(dp, dp->termcap_TI);
		termcap_put_raw_str(dp, dp->termcap_VE);
		termcap_put_raw_str(dp, dp->termcap_KS);
		termcap_put_raw_str(dp, dp->termcap_EA);
		termcap_put_raw_str(dp, dp->termcap_ME);
		termcap_flush(dp);

		termcap_set_color(dp, COLOR_WHITE | COLOR_BACK_BLACK);
		if (Clear_on_exit)
		{
			termcap_clear_screen(dp);
			termcap_flush(dp);
		}
	}

	init_mouse(base, envp);

	return ret;
}

int
destroy_tty(struct ScreenBase *base)
{
	ScreenData *dp;

	if (!base)
		return -1;

	dp = (ScreenData *) base->data;
	if (!dp)
		return 0;

#ifdef OS_CYGWIN
	if (w32_console)
	{
		if (base->clear_on_exit)
			w32_clear();
	}
	else
#endif
	{
		termcap_put_raw_str(dp, dp->termcap_ME);
		termcap_set_color(dp, COLOR_WHITE | COLOR_BACK_BLACK);
		if (base->clear_on_exit)
			termcap_clear_screen(dp);
		termcap_set_cursor(dp, base->Lines - 1, 0);
		/*termcap_put_raw_str(dp, dp->termcap_TE); */
		termcap_put_raw_str(dp, dp->termcap_FS);
		termcap_put_raw_str(dp, dp->termcap_VE);
		termcap_put_raw_str(dp, dp->termcap_KE);
		termcap_flush(dp);
	}

	restore_tty(base);

	delete_Screen(base->realScreen);
	destroy_ScreenData(dp);
	free(dp);
	free(base->terminalName);
	memset(base, 0, sizeof(ScreenBase));

	return 0;
}

static const unsigned char koi8_nationalTable[128] = {
	0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7,
	0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 0xe, 0xf,
	0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
	0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,

	' ', '!', 252, '/', 44, ':', '.', 218,
	'?', '%', ';', '+', 194, '-', 192, '/',
	'0', '1', '2', '3', '4', '5', '6', '7',
	'8', '9', 246, 214, 226, '=', 224, '?',
	'"', 230, 233, 243, 247, 245, 225, 240,
	242, 251, 239, 236, 228, 248, 244, 253,
	250, 234, 235, 249, 229, 231, 237, 227,
	254, 238, 241, 200, '\\', 223, ',', '_',
	'`', 198, 201, 211, 215, 213, 193, 208,
	242 - 32, 251 - 32, 239 - 32, 236 - 32, 228 - 32, 248 - 32, 244 - 32, 253 - 32,
	250 - 32, 234 - 32, 235 - 32, 249 - 32, 229 - 32, 231 - 32, 237 - 32, 227 - 32,
	222, 206, 209, 232, '|', 255, '~', 127,
};

static void
destroy_ScreenData(ScreenData * dp)
{
}

static char *
get_str(ScreenData * dp, int no)
{
	char *rp;

	if (dp->terminfo.strings[no] == -1)
		return 0;

	rp = dp->terminfo.buf + dp->terminfo.strings[no];
	if (!*rp)
		return 0;
	else
		return rp;
}

static char *
get_key(ScreenData * dp, int no)
{
	char *rp;

	if (dp->terminfo.keys[no] == -1)
		return 0;

	rp = dp->terminfo.buf + dp->terminfo.keys[no];
	if (!*rp)
		return 0;
	else
		return rp;
}

static void
init_ScreenData(ScreenData * dp)
{
	char *bools = dp->terminfo.bools;
	int *nums = dp->terminfo.nums;
	char *s;

	dp->termcap_TI = get_str(dp, NO_smcup);
	dp->termcap_TE = get_str(dp, NO_rmcup);

	dp->termcap_KS = get_str(dp, NO_smkx);
	dp->termcap_KE = get_str(dp, NO_rmkx);

	dp->termcap_CM = get_str(dp, NO_cup);

	dp->termcap_GS = get_str(dp, NO_smacs);
	dp->termcap_GE = get_str(dp, NO_rmacs);
	dp->termcap_AS = get_str(dp, NO_smacs);
	dp->termcap_AE = get_str(dp, NO_rmacs);

	dp->termcap_G1 = get_str(dp, NO_g1);
	dp->termcap_G2 = get_str(dp, NO_g2);
	dp->termcap_AC = get_key(dp, NO_acsc);

	dp->termcap_AL = get_str(dp, NO_il1);
	dp->termcap_DL = get_str(dp, NO_dl1);

	dp->termcap_SF = get_str(dp, NO_indn);
	dp->termcap_SR = get_str(dp, NO_rin);
	dp->termcap_CS = get_str(dp, NO_csr);

	dp->termcap_CL = get_str(dp, NO_clear);
	dp->termcap_CE = get_str(dp, NO_el);

	dp->termcap_TS = get_str(dp, NO_tsl);
	dp->termcap_FS = get_str(dp, NO_fsl);

	dp->termcap_NF = nums[NO_Nf];
	dp->termcap_NB = nums[NO_Nb];

	dp->termcap_lines = nums[NO_lines];
	dp->termcap_columns = nums[NO_cols];

	dp->termcap_CF = get_str(dp, NO_Cf);
	dp->termcap_CB = get_str(dp, NO_Cb);

	dp->termcap_MF = get_str(dp, NO_Mf);
	dp->termcap_MB = get_str(dp, NO_Mb);

	dp->termcap_MD = get_str(dp, NO_bold);
	dp->termcap_mb = get_str(dp, NO_blink);
	dp->termcap_MH = get_str(dp, NO_dim);
	dp->termcap_MR = get_str(dp, NO_rev);
	dp->termcap_ME = get_str(dp, NO_sgr0);

	dp->termcap_SE = get_str(dp, NO_rmso);
	dp->termcap_SO = get_str(dp, NO_smso);

	dp->termcap_AF = get_str(dp, NO_setaf);
	dp->termcap_AB = get_str(dp, NO_setab);

	dp->termcap_SETF = get_str(dp, NO_setf);
	dp->termcap_SETB = get_str(dp, NO_setb);

	dp->termcap_PO = get_str(dp, NO_mc5);
	dp->termcap_POO = get_str(dp, NO_mc5p);
	dp->termcap_PF = get_str(dp, NO_mc4);

	dp->termcap_Km = get_str(dp, NO_kmous);
	dp->termcap_Mi = get_str(dp, NO_minfo);

	dp->termcap_Ct = get_str(dp, NO_Ct);
	dp->termcap_C2 = bools[NO_C2];
	dp->termcap_MS = bools[NO_msgr];

	dp->termcap_xo = bools[NO_xon];

	s = get_str(dp, NO_xonc);
	if (s)
		dp->termcap_XN = s[0];
	s = get_str(dp, NO_xoffc);
	if (s)
		dp->termcap_XF = s[0];

	dp->termcap_HS = bools[NO_hs];

	dp->termcap_BL = get_str(dp, NO_bel);

	dp->termcap_IS = get_str(dp, NO_is2);
	dp->termcap_EA = get_str(dp, NO_enacs);

	dp->termcap_VS = get_str(dp, NO_cvvis);
	dp->termcap_VE = get_str(dp, NO_cnorm);
	dp->termcap_VI = get_str(dp, NO_civis);
#if 0
	printf("%s\n", dp->termcap_VS);
	printf("%s\n", dp->termcap_VE);
	printf("%s\n", dp->termcap_VI);
	sleep(10);
#endif

	dp->next_key = 0;
	dp->outptr = dp->outbuf;
	dp->lineDrawMode = 0;
	dp->boldMode = 0;
	dp->blinkMode = 0;
	dp->useBlinkAttr = 1;
	dp->useBoldAttr = 1;
	dp->oldcolor = 0;
	dp->oldcursor = 0;
	dp->matchpos = 0;
	dp->matchno = 0;
	dp->lomatch = 255;
	dp->himatch = 0;
	dp->national_mode = 0;
	dp->has_meta1 = 0;
	dp->has_meta2 = 0;
	dp->prev_national_mode = 0;
	dp->prev_has_meta1 = 0;
	dp->prev_has_meta2 = 0;
	dp->key_count = 0;
	dp->scrool = 0;
	dp->rscrool = 0;
	dp->pg_mode = 1;

	strncpy(dp->meta_key, "\033", sizeof(dp->meta_key));
	strncpy(dp->meta1_key, "\012", sizeof(dp->meta1_key));
	strncpy(dp->meta2_key, "\013", sizeof(dp->meta2_key));
	strncpy(dp->national_key, "\016", sizeof(dp->national_key));

	memcpy(dp->nationalTable, koi8_nationalTable, 128);

	initKey(dp);
}

void
clear_Screen(Screen * scr)
{
	int i, j;
	ScreenData *dp = (ScreenData *) scr->base->data;
	int Lines = scr->base->Lines;
	int Columns = scr->base->Columns;

	for (i = 0; i < Lines; ++i)
		for (j = 0; j < Columns; ++j)
		{
			scr->chars[i][j] = scr->base->realScreen->chars[i][j] = ' ';
			scr->colors[i][j] = scr->base->realScreen->colors[i][j] = COLOR_WHITE | COLOR_BACK_BLACK;
			scr->attrs[i][j] = scr->base->realScreen->attrs[i][j] = 0;
		}

#ifdef OS_CYGWIN
	if (w32_console)
	{
		w32_clear();
	}
	else
#endif
	{
		termcap_set_color(dp, COLOR_WHITE | COLOR_BACK_BLACK);
		termcap_clear_screen(dp);
		termcap_flush(dp);
	}
}

void
setCtrlBreak_Screen(Screen * scr, int val)
{
	ScreenData *dp = (ScreenData *) scr->base->data;

#ifdef OS_CYGWIN
	if (w32_console)
		return;
#endif

	if (val)
	{
#if 0
		dp->work_mode.c_oflag |= OPOST;
#endif
		dp->work_mode.c_lflag |= ISIG;
		dp->work_mode.c_cc[VINTR] = 'C' - '@';
	}
	else
	{
#if 0
		dp->work_mode.c_oflag &= ~OPOST;
#endif
		dp->work_mode.c_lflag &= ~ISIG;
		dp->work_mode.c_cc[VINTR] = 0;
	}
	tcsetattr(dp->fd, TCSADRAIN, &dp->work_mode);
}

static int
compkeys(void *ap, void *bp)
{
	int cmp;
	Keytab *a = (Keytab *) ap;
	Keytab *b = (Keytab *) bp;

	if (!a->str)
	{
		if (!b->str)
			return (0);
		return (1);
	}
	if (!b->str)
		return (-1);
	cmp = strcmp(a->str, b->str);
	return (cmp);
}

static void
initKey(ScreenData * dp)
{
	Keytab *kp;
	Keytab *map = dp->keytab;
	int i;
	char *s;

	memcpy(map, init_keytab, sizeof(init_keytab));
	map[0].str = dp->meta1_key;
	map[1].str = dp->meta2_key;
	map[2].str = dp->national_key;

	map[3].str = get_key(dp, NO_kcub1);	/* kl */
	map[4].str = get_key(dp, NO_kcuf1);	/* kr */
	map[5].str = get_key(dp, NO_kcuu1);	/* ku */
	map[6].str = get_key(dp, NO_kcud1);	/* kd */

	map[7].str = get_key(dp, NO_knp);	/* kN */
	map[8].str = get_key(dp, NO_kpp);	/* kP */
	s = get_key(dp, NO_khome);	/* kh */
	if (!s)
		s = get_key(dp, NO_kend);	/* @7 */
	map[9].str = s;
	map[10].str = get_key(dp, NO_kll);	/* kH */
	map[11].str = get_key(dp, NO_kich1);	/* kI */
	map[12].str = get_key(dp, NO_kbs);	/* kb */
	map[13].str = get_key(dp, NO_kdch1);	/* kD */

	map[14].str = get_key(dp, NO_kf1);	/* k1 */
	map[15].str = get_key(dp, NO_kf2);	/* k2 */
	map[16].str = get_key(dp, NO_kf3);	/* k3 */
	map[17].str = get_key(dp, NO_kf4);	/* k4 */
	map[18].str = get_key(dp, NO_kf5);	/* k5 */
	map[19].str = get_key(dp, NO_kf6);	/* k6 */
	map[20].str = get_key(dp, NO_kf7);	/* k7 */
	map[21].str = get_key(dp, NO_kf8);	/* k8 */
	map[22].str = get_key(dp, NO_kf9);	/* k9 */
	map[23].str = get_key(dp, NO_kf0);	/* k0 */

	map[24].str = get_key(dp, NO_kf11);	/* k11 */
	map[25].str = get_key(dp, NO_kf12);	/* k12 */
	map[26].str = get_key(dp, NO_kf13);	/* k13 */
	map[27].str = get_key(dp, NO_kf14);	/* k14 */
	map[28].str = get_key(dp, NO_kf15);	/* k15 */
	map[29].str = get_key(dp, NO_kf16);	/* k16 */
	map[30].str = get_key(dp, NO_kf17);	/* k17 */
	map[31].str = get_key(dp, NO_kf18);	/* k18 */
	map[32].str = get_key(dp, NO_kf19);	/* k19 */
	map[33].str = get_key(dp, NO_kf20);	/* k20 */

	qsort(map, KEYTAB_SIZE, sizeof(Keytab), (int (*)(const void *, const void *)) compkeys);

	dp->key_count = 0;
	for (kp = map, i = 0; kp->val && i < KEYTAB_SIZE; kp++, i++)
	{
		dp->key_count++;
		if (kp->str)
		{
			kp->strlen = strlen(kp->str);
			if (kp->str[0])
			{
				if (kp->str[0] < dp->lomatch)
					dp->lomatch = kp->str[0];
				if (kp->str[0] > dp->himatch)
					dp->himatch = kp->str[0];
			}
		}
		else
			kp->strlen = 0;
	}

}

/* termcap init ][ termcap capabilities  */

static void
termcap_put_char(ScreenData * dp, int ch)
{
	if (dp->lineDrawMode)
	{
		if (dp->termcap_GE)
			termcap_put_raw_str(dp, dp->termcap_GE);
		else if (dp->termcap_AE)
			termcap_put_raw_str(dp, dp->termcap_AE);
		dp->lineDrawMode = 0;
	}

	if ((ch & 0x80) || (ch < 32))
	{
		int pg;

		if (scr_scan_mode && ch > 32)
			termcap_put_raw_char(dp->outputTable[ch], dp);
		else if (dp->pg_mode && (pg = dp->pgTable[ch]))
			termcap_put_graph_char(dp, (pg >= PG_SIZE) ? pg : dp->base->pg_chars[pg]);
		else
			termcap_put_raw_char(dp->outputTable[ch], dp);
	}
	else
		termcap_put_raw_char(ch, dp);
}

static void
termcap_put_graph_char(ScreenData * dp, int ch)
{
	if (!dp->lineDrawMode && (dp->termcap_GS || dp->termcap_AS))
	{
		if (dp->termcap_GS)
			termcap_put_raw_str(dp, dp->termcap_GS);
		else
			termcap_put_raw_str(dp, dp->termcap_AS);
		dp->lineDrawMode = 1;
	}

	if (scr_scan_mode)
		termcap_put_raw_char(dp->outputTable[ch], dp);
	else
		termcap_put_raw_char(ch, dp);
}

static int
termcap_put_raw_char(int c, void *par)
{
	ScreenData *dp = (ScreenData *) par;

	if (dp->outptr >= dp->outbuf + sizeof(dp->outbuf))
		termcap_flush(dp);
	*dp->outptr++ = c;
	return 0;
}

static void
termcap_put_raw_str(ScreenData * dp, const char *str)
{
	if (!str)
		return;
	scr_tputs(str, 1, termcap_put_raw_char, dp);
}

static void
termcap_flush(ScreenData * dp)
{
	if (dp->outptr > dp->outbuf)
		write(dp->fd, dp->outbuf, dp->outptr - dp->outbuf);
	dp->outptr = dp->outbuf;
}

static void
termcap_set_color(ScreenData * dp, int color)
{
	int fg, bg;

	/*color &= 0xff; */

	if (dp->oldcolor == color)
		return;

	if (dp->lineDrawMode)
	{
		if (dp->termcap_GE)
			termcap_put_raw_str(dp, dp->termcap_GE);
		else if (dp->termcap_AE)
			termcap_put_raw_str(dp, dp->termcap_AE);
		dp->lineDrawMode = 0;
	}

	if (dp->termcap_Visuals & VisualColors)
	{
		termcap_set_fgbg(dp, color & 0xf, (color >> 4) & 0xf);
		dp->oldcolor = color;
		return;
	}

	/* Set dim/bold/inverse. */
	fg = color & 0xf;
	bg = color & 0xf0;
	switch (dp->termcap_Visuals & (VisualBold | VisualBlink | VisualDim | VisualInverse))
	{
	case VisualBold | VisualDim | VisualInverse:
		if (bg)
		{
			if (fg > 7)
				goto bold_inverse;
			else if (fg < 7)
				goto dim_inverse;
			else
				goto inverse;
		}
		if (fg > 7)
			goto bold;
		if (fg < 7)
			goto dim;
		goto normal;
	case VisualDim | VisualInverse:
		if (!bg)
		{
			if (fg >= 7)
				goto normal;
			else
				goto dim;
		}
		if (fg >= 7)
			goto inverse;
	      dim_inverse:
		termcap_put_raw_str(dp, dp->termcap_MH);
		termcap_put_raw_str(dp, dp->termcap_SO);
		break;
	case VisualBold | VisualInverse:
		if (!bg)
		{
			if (fg <= 7)
				goto normal;
			else
				goto bold;
		}
		if (fg <= 7)
			goto inverse;
	      bold_inverse:
		termcap_put_raw_str(dp, dp->termcap_MD);
		termcap_put_raw_str(dp, dp->termcap_SO);
		break;
	case VisualBold | VisualDim:
		if (fg > 7)
			goto bold;
		if (fg < 7)
			goto dim;
		if (bg & 8)
			goto blink;
		goto normal;
	case VisualInverse:
		if (!bg)
			goto normal;
	      inverse:
		termcap_put_raw_str(dp, dp->termcap_ME);
		termcap_put_raw_str(dp, dp->termcap_SO);
		break;
	case VisualBold:
		if (fg <= 7)
			goto normal;
	      bold:
		termcap_put_raw_str(dp, dp->termcap_ME ? dp->termcap_ME : dp->termcap_SE);
		termcap_put_raw_str(dp, dp->termcap_MD);
		break;
	case VisualBlink:
		if (bg <= 7)
			goto normal;
	      blink:
		termcap_put_raw_str(dp, dp->termcap_ME ? dp->termcap_ME : dp->termcap_SE);
		termcap_put_raw_str(dp, dp->termcap_mb);
		break;
	case VisualDim:
		if (fg >= 7)
			goto normal;
	      dim:
		termcap_put_raw_str(dp, dp->termcap_ME ? dp->termcap_ME : dp->termcap_SE);
		termcap_put_raw_str(dp, dp->termcap_MH);
		break;
	case 0:
	      normal:
		termcap_put_raw_str(dp, dp->termcap_ME ? dp->termcap_ME : dp->termcap_SE);
		break;
	}
	dp->oldcolor = color;
}

static void
termcap_set_cursor_shape(ScreenData * dp, int cursor)
{
	if (dp->oldcursor == cursor)
		return;
#if 0
	printf("VE: '%s'\n", dp->termcap_VE ? dp->termcap_VE + 1 : "");
	printf("VI: '%s'\n", dp->termcap_VI ? dp->termcap_VI + 1 : "");
	printf("VS: '%s'\n", dp->termcap_VS ? dp->termcap_VS + 1 : "");
	fflush(stdout);
#endif

	switch (cursor)
	{
	case 0:
	default:
		termcap_put_raw_str(dp, dp->termcap_VE);
		break;
	case 1:
		termcap_put_raw_str(dp, dp->termcap_VI);
		break;
	case 2:
		if (dp->termcap_VS)
			termcap_put_raw_str(dp, dp->termcap_VS);
		else
			termcap_put_raw_str(dp, dp->termcap_VE);
		break;
	}

	dp->oldcursor = cursor;
}

static void
termcap_set_fgbg(ScreenData * dp, int fg, int bg)
{
	/* This should be optimized later. */
	/* For example, we could have an array of 128 color */
	/* switching escape strings, precompiled during Init phase. */
	char buf[32];
	int bold, blink;

	fg = dp->ctab[fg];
	if (fg < 0)
		fg = 7;		/* bg = ctab [bg]; */
	bg = dp->btab[bg];
	if (bg < 0)
		bg = 0;

	bold = (fg & 0x8 && dp->useBoldAttr ? 1 : 0);
	blink = (bg & 0x8 && dp->useBlinkAttr ? 1 : 0);

	if ((bold ^ dp->boldMode) || (blink ^ dp->blinkMode))
	{
		termcap_put_raw_str(dp, dp->termcap_ME);
		dp->boldMode = 0;
		dp->blinkMode = 0;
	}

	if (bold && !dp->boldMode)
	{
		termcap_put_raw_str(dp, dp->termcap_MD);
		dp->boldMode = 1;
	}
	if (blink && !dp->blinkMode)
	{
		termcap_put_raw_str(dp, dp->termcap_mb);
		dp->blinkMode = 1;
	}

	if (dp->termcap_AF && dp->termcap_AB)
	{
		scr_tgoto(dp->termcap_AF, 0, /*fg, */ cga_to_ansi[fg], buf, sizeof(buf));
		termcap_put_raw_str(dp, buf);
		scr_tgoto(dp->termcap_AB, 0, /*bg, */ cga_to_ansi[bg], buf, sizeof(buf));
		termcap_put_raw_str(dp, buf);
	}
	else if (dp->termcap_SETF && dp->termcap_SETB)
	{
		scr_tgoto(dp->termcap_SETF, 0, fg, /*cga_to_ansi[fg], */ buf, sizeof(buf));
		termcap_put_raw_str(dp, buf);
		scr_tgoto(dp->termcap_SETB, 0, bg, /*cga_to_ansi[bg], */ buf, sizeof(buf));
		termcap_put_raw_str(dp, buf);
	}
	else if (dp->termcap_C2 && dp->termcap_CF)
	{
		scr_tgoto(dp->termcap_CF, bg, fg, /*cga_to_ansi[bg], cga_to_ansi[fg], */ buf, sizeof(buf));
		termcap_put_raw_str(dp, buf);
	}
	else if (dp->termcap_CF && dp->termcap_CB)
	{
		scr_tgoto(dp->termcap_CF, 0, fg /* cga_to_ansi[fg] */ , buf, sizeof(buf));
		termcap_put_raw_str(dp, buf);
		scr_tgoto(dp->termcap_CB, 0, bg /* cga_to_ansi[bg] */ , buf, sizeof(buf));
		termcap_put_raw_str(dp, buf);
	}
}

static void
termcap_set_cursor(ScreenData * dp, int y, int x)
{
	char buf[32];

	scr_tgoto(dp->termcap_CM, x, y, buf, sizeof(buf));
	termcap_put_raw_str(dp, buf);
}

static void
termcap_clear_screen(ScreenData * dp)
{
	if (dp->lineDrawMode)
	{
		if (dp->termcap_GE)
			termcap_put_raw_str(dp, dp->termcap_GE);
		else if (dp->termcap_AE)
			termcap_put_raw_str(dp, dp->termcap_AE);
		dp->lineDrawMode = 0;
	}
	termcap_put_raw_str(dp, dp->termcap_ME);
	dp->boldMode = 0;
	termcap_put_raw_str(dp, dp->termcap_CL);
	termcap_set_cursor(dp, 0, 0);
}

static void
termcap_scroll(ScreenBase * base, int top, int bottom, int n)
{
	ScreenData *dp = (ScreenData *) base->data;
	Screen *realScreen = base->realScreen;
	int Lines = base->Lines;
	int Columns = base->Columns;

	if (n > 0)
	{
		memmove(realScreen->chars[top + n], realScreen->chars[top], (bottom - top + 1 - n) * Columns);
		memset(realScreen->chars[top], ' ', n * Columns);
		memset(realScreen->colors[top], dp->oldcolor, n * Columns);
		memset(realScreen->attrs[top], 0, n * Columns);
		if (dp->termcap_SR && top == 0 && bottom == Lines - 1)
		{
			termcap_set_cursor(dp, 0, 0);
			while (--n >= 0)
				termcap_put_raw_str(dp, dp->termcap_SR);
		}
		else if (dp->termcap_AL && dp->termcap_DL)
			while (--n >= 0)
			{
				termcap_set_cursor(dp, bottom, 0);
				termcap_put_raw_str(dp, dp->termcap_DL);
				termcap_set_cursor(dp, top, 0);
				termcap_put_raw_str(dp, dp->termcap_AL);
			}
	}
	else
	{
		memmove(realScreen->chars[top], realScreen->chars[top - n], (bottom - top + 1 + n) * Columns);
		memset(realScreen->chars[bottom + n + 1], ' ', (-n) * Columns);
		memset(realScreen->colors[bottom + n + 1], dp->oldcolor, (-n) * Columns);
		memset(realScreen->attrs[bottom + n + 1], 0, (-n) * Columns);
		if (dp->termcap_SF && top == 0 && bottom == Lines - 1)
		{
			termcap_set_cursor(dp, Lines - 1, 0);
			while (++n <= 0)
				termcap_put_raw_str(dp, dp->termcap_SF);
		}
		else if (dp->termcap_AL && dp->termcap_DL)
			while (++n <= 0)
			{
				termcap_set_cursor(dp, top, 0);
				termcap_put_raw_str(dp, dp->termcap_DL);
				termcap_set_cursor(dp, bottom, 0);
				termcap_put_raw_str(dp, dp->termcap_AL);
			}
	}
}

static void
termcap_beep(ScreenData * dp)
{
	if (dp->termcap_BL)
		termcap_put_raw_str(dp, dp->termcap_BL);
	else
		termcap_put_raw_str(dp, "\007");
}

void
newMatch_Key(ScreenBase * base)
{
	ScreenData *dp = (ScreenData *) base->data;

	dp->matchpos = 0;
	dp->matchno = 0;
}

static int
cmp_first(const void *k1, const void *k2)
{
	char *key = (char *) k1;
	Keytab *el = (Keytab *) k2;

	if (!el->str)
		return -1;
	if (*key == el->str[0])
		return 0;
	else if (*key < el->str[0])
		return -1;
	return 1;
}

static int
term_match_Key(ScreenBase * base, unsigned char b, unsigned long *keyp)
{
	int trymatch = 0;
	unsigned char kb;
	unsigned long key = b;
	ScreenData *dp = (ScreenData *) base->data;
	Keytab *keytab = dp->keytab;
	int key_count = dp->key_count;

	if (xterm_mouse && xterm_pos)
	{
		int mb, t, bb = 0;
		static struct timeval tv1 = { 0, 0 }, tv2;
		static int clicks = 0;

		switch (xterm_pos)
		{
		case 1:
			xterm_buttons = b - 040;
			xterm_pos = 2;
			return 0;
		case 2:
			xterm_x = b - 040 - 1;
			xterm_pos = 3;
			return 0;
		case 3:
		default:
			xterm_y = b - 040 - 1;
			xterm_pos = 0;

			if (xterm_x < base->mouse_left)
				xterm_x = base->mouse_left;
			if (xterm_x > base->mouse_right)
				xterm_x = base->mouse_right;
			if (xterm_y < base->mouse_top)
				xterm_y = base->mouse_top;
			if (xterm_y > base->mouse_bottom)
				xterm_y = base->mouse_bottom;
			base->mouse_x = xterm_x;
			base->mouse_y = xterm_y;
			base->mouse_auto_visible = 1;

			mb = xterm_buttons & 0x3;
			if (mb != 3)
			{
				long dt;

				if (mb == 0)
					bb = MOUSE_BUTTONS_LEFT;
				else if (mb == 1)
					bb = MOUSE_BUTTONS_MIDDLE;
				else if (mb == 2)
					bb = MOUSE_BUTTONS_RIGHT;
				t = MOUSE_TYPE_DOWN;
				base->mouse_buttons = bb;

				gettimeofday(&tv2, 0);

				dt = (tv2.tv_sec - tv1.tv_sec) * 1000 + (tv2.tv_usec - tv1.tv_usec) / 1000;

				if (tv1.tv_sec && dt < base->mouse_dclick_speed)
				{
					clicks++;
					clicks %= 2;
				}
				else
					clicks = 0;
			}
			else
			{
				bb = base->mouse_buttons;
				if (bb == MOUSE_BUTTONS_LEFT)
					base->mouse_clicks_left++;
				if (bb == MOUSE_BUTTONS_RIGHT)
					base->mouse_clicks_right++;
				if (bb == MOUSE_BUTTONS_MIDDLE)
					base->mouse_clicks_middle++;
				base->mouse_buttons = 0;
				t = MOUSE_TYPE_UP | (MOUSE_TYPE_SINGLE << clicks);
				gettimeofday(&tv1, 0);
				clicks = 0;
			}

			_clip_logg(3, "got xterm mouse event: type=%d y=%d x=%d buttons=%d clicks=%d", t, xterm_y, xterm_x, bb,
				   clicks);
			key = MOUSE_MASK;
			key |= MOUSE_SET_TYPE(t);
			key |= MOUSE_SET_ROW(xterm_y);
			key |= MOUSE_SET_COL(xterm_x);
			key |= MOUSE_SET_BUTTONS(bb);

			dp->next_key = key;
			*keyp = key;
			return 1;
		}
	}

	if (dp->matchpos == 0)
	{
		/* if ( b>=lomatch && b<=himatch ) { */
		dp->matchno = -1;
		trymatch = 1;	/* check for begin of key string */
		/* } */
	}
	else
		trymatch = 1;

	if (trymatch)
	{
		if (dp->matchno < 0)
		{
			Keytab *kp;

			kp = (Keytab *) bsearch(&b, keytab, key_count, sizeof(Keytab), cmp_first);

			if (!kp)
				goto end_match;
			while (kp > keytab && kp->str[0] == (char) b)
				kp--;
			dp->matchno = kp - keytab;
		}
		for (; dp->matchno < key_count; dp->matchno++)
		{
			Keytab *k = &keytab[dp->matchno];

			if (dp->matchpos == k->strlen)
				continue;
			if (dp->matchpos > k->strlen)
			{
				dp->matchpos = 0;
				return 0;
			}
			kb = k->str[dp->matchpos];
			if (kb != b)
				continue;

			dp->matchpos++;
			if (dp->matchpos == k->strlen)
			{	/* match ended */
				key = k->val;
				dp->matchpos = 0;
				/* dirty hack */
				if (xterm_mouse && k->str && k->strlen == 3 && !strcmp(k->str, "\033[M"))
				{
					xterm_pos = 1;
					return 0;
				}
				goto end_match;
			}
			return 0;	/* wait to continue matching */
		}

		dp->matchpos = 0;
		return 0;
	}

      end_match:
	if (!dp->has_meta2)
	{
		if (key == Meta1_key)
		{
			dp->has_meta1 = 1;
			return 0;
		}
		else if (key == Meta2_key)
		{
			dp->has_meta2 = 1;
			return 0;
		}
	}

	if (dp->national_mode && key >= 64 && key < 128)
		key = dp->nationalTable[key];
	else if (key >= 0 && key <= 255)
		key = dp->inputTable[key];
	dp->prev_has_meta1 = dp->has_meta1;
	dp->prev_has_meta2 = dp->has_meta2;
	if (dp->has_meta1)
	{
		key = META1(key);
		dp->has_meta1 = 0;
	}
	if (dp->has_meta2)
	{
		key = META2(key);
		dp->has_meta2 = 0;
	}

	if (key == National_key)
	{
		dp->national_mode = !dp->national_mode;
		return 0;
	}

	if (key == KEY_MOUSE)
	{
		if (xterm_mouse)
		{
			xterm_pos = 1;
			return 0;
		}
		else
			key = KEY_F1;
	}

	dp->next_key = key;
	*keyp = key;

	return 1;
}

int
getState_Key(ScreenBase * base)
{
	if (scr_scan_mode)
		return scan_state();
	else
	{
		ScreenData *dp = (ScreenData *) base->data;
		int m1 = dp->prev_has_meta1;
		int m2 = dp->prev_has_meta2;
		int r = 0;

		if (m1 && m2)
			r |= (1 << KEY_SHIFT);
		else if (m1)
			r |= (1 << KEY_ALT);
		else if (m2)
			r |= (1 << KEY_CTRL);
		return r;
	}
}

static int
scan_match_Key(ScreenBase * base, unsigned char b, unsigned long *keyp)
{
	long key;

	if (xterm_mouse && b == RAWMODE_ESC)
	{
		xterm_pos = 1;
		return 0;
	}

	if (xterm_mouse && xterm_pos)
	{
		int mb, t, bb = 0;
		static struct timeval tv1 = { 0, 0 }, tv2;
		static int clicks = 0;

		switch (xterm_pos)
		{
		case 1:
			xterm_buttons = b;
			xterm_pos = 2;
			return 0;
		case 2:
			xterm_x = b;
			xterm_pos = 3;
			return 0;
		case 3:
		default:
			xterm_y = b;
			xterm_pos = 0;

			if (xterm_x < base->mouse_left)
				xterm_x = base->mouse_left;
			if (xterm_x > base->mouse_right)
				xterm_x = base->mouse_right;
			if (xterm_y < base->mouse_top)
				xterm_y = base->mouse_top;
			if (xterm_y > base->mouse_bottom)
				xterm_y = base->mouse_bottom;
			base->mouse_x = xterm_x;
			base->mouse_y = xterm_y;
			base->mouse_auto_visible = 1;

			if (xterm_buttons & 0x4)
			{
				t = MOUSE_TYPE_MOVE;
				bb = base->mouse_buttons;
			}
			else
			{
				mb = xterm_buttons & 0x3;
				if (mb != 3)
				{
					long dt;

					if (mb == 0)
						bb = MOUSE_BUTTONS_LEFT;
					else if (mb == 1)
						bb = MOUSE_BUTTONS_MIDDLE;
					else if (mb == 2)
						bb = MOUSE_BUTTONS_RIGHT;
					base->mouse_buttons = bb;

					gettimeofday(&tv2, 0);

					dt = (tv2.tv_sec - tv1.tv_sec) * 1000 + (tv2.tv_usec - tv1.tv_usec) / 1000;

					if (tv1.tv_sec && dt < base->mouse_dclick_speed)
					{
						clicks++;
						clicks %= 2;
					}
					else
						clicks = 0;

					t = MOUSE_TYPE_DOWN;
				}
				else
				{
					bb = base->mouse_buttons;
					if (bb == MOUSE_BUTTONS_LEFT)
						base->mouse_clicks_left++;
					if (bb == MOUSE_BUTTONS_RIGHT)
						base->mouse_clicks_right++;
					if (bb == MOUSE_BUTTONS_MIDDLE)
						base->mouse_clicks_middle++;
					base->mouse_buttons = 0;
					t = MOUSE_TYPE_UP | (MOUSE_TYPE_SINGLE << clicks);
					gettimeofday(&tv1, 0);
					clicks = 0;
				}
			}

			_clip_logg(3, "got xterm rawmode mouse event: type=%d y=%d x=%d xt_buttons=%d buttons=%d clicks=%d", t,
				   xterm_y, xterm_x, xterm_buttons, bb, clicks);
			key = MOUSE_MASK;
			key |= MOUSE_SET_TYPE(t);
			key |= MOUSE_SET_ROW(xterm_y);
			key |= MOUSE_SET_COL(xterm_x);
			key |= MOUSE_SET_BUTTONS(bb);

			*keyp = key;
			return 1;
		}
	}

	key = scan_key(b);

	if (key)
	{
		*keyp = key;
               	//scan_reset();
		return 1;
	}
	else
		return 0;
}

int
match_Key(ScreenBase * base, unsigned char b, unsigned long *keyp)
{
	if (scr_scan_mode)
		return scan_match_Key(base, b, keyp);
	else
		return term_match_Key(base, b, keyp);
}

unsigned long
getRaw_Key(ScreenBase * base)
{
#if 1
	return getRawWait_Key(base, 1000 * 6000);
#else
	unsigned char ch = 0;

#ifdef OS_CYGWIN
	if (w32_console)
		ch = w32_readch();
	else
#endif
	if (!scr_scan_mode)
		return 0;

	read(base->fd, &ch, 1);

	if (scr_scan_mode)
		scan_push(ch);
	else
	{
		unsigned long r = 0;

		if (term_match_Key(base, ch, &r))
			return r;
		else
			return 0;
	}

	return ch;
#endif
}

unsigned long
getRawWait_Key(ScreenBase * base, long milliseconds)
{
	if (!scr_scan_mode)
        	return 0;
	return get_wait_key(base, milliseconds, 1);
}

#ifdef HAVE_GPM_H

/*-------------------------------------------------------------------*/
static int
gpm_get_event(Gpm_Event * event)
{
	int r;

	if (gpm_fd < 0)
		return 0;

	r = Gpm_GetEvent(event);
	return r;
}

static unsigned long
get_gpm_mouse(ScreenBase * base)
{
	unsigned long key = 0;
	int r;
	Gpm_Event event;

	r = gpm_get_event(&event);
	if (r > 0)
	{
		if (event.x < base->mouse_left)
			event.x = base->mouse_left;
		if (event.x > base->mouse_right)
			event.x = base->mouse_right;
		if (event.y < base->mouse_top)
			event.y = base->mouse_top;
		if (event.y > base->mouse_bottom)
			event.y = base->mouse_bottom;
		base->mouse_x = event.x;
		base->mouse_y = event.y;
		base->mouse_auto_visible = 1;
		if (event.type & GPM_DOWN)
			base->mouse_buttons = event.buttons;
		else if (event.type & GPM_UP)
		{
			if (event.buttons & GPM_B_LEFT)
				base->mouse_clicks_left++;
			if (event.buttons & GPM_B_RIGHT)
				base->mouse_clicks_right++;
			if (event.buttons & GPM_B_MIDDLE)
				base->mouse_clicks_middle++;
			base->mouse_buttons = 0;
		}
	}
	_clip_logg(3, "got gp_get_event: %d type=%d y=%d x=%d buttons=%d m_buttons=%d", r, event.type, event.y, event.x,
		   event.buttons, base->mouse_buttons);
	if (r == 1)
	{
		key = MOUSE_MASK;
		key |= MOUSE_SET_TYPE(event.type);
		key |= MOUSE_SET_ROW(event.y);
		key |= MOUSE_SET_COL(event.x);
		key |= MOUSE_SET_BUTTONS(event.buttons);
	}
	return key;
}

#endif

unsigned long
get_Key(ScreenBase * base)
{
	unsigned char ch;
	unsigned long key;

	newMatch_Key(base);
	for (;;)
	{
#ifdef OS_CYGWIN
		if (w32_console)
			ch = w32_readch();
		else
#endif
		{
#ifdef HAVE_GPM_H
			if (gpm_fd >= 0)
			{
				fd_set rfs;
				int r, n;

			      again:
				FD_ZERO(&rfs);
				FD_SET(gpm_fd, &rfs);
				FD_SET(base->fd, &rfs);
				n = base->fd;
				if (gpm_fd > n)
					n = gpm_fd;

				r = select(n + 1, &rfs, 0, 0, 0);
				if (r > 0 && FD_ISSET(gpm_fd, &rfs))
				{
					key = get_gpm_mouse(base);
					if (key)
						return key;
				}
				if (!FD_ISSET(base->fd, &rfs))
					goto again;
			}
#endif
			if (read(base->fd, &ch, 1) < 1)
				return 0;
		}
		if (match_Key(base, ch, &key))
			return key;
	}
}

#define tv_cmp(a,b,CMP) \
      (((a)->tv_sec == (b)->tv_sec) ?            \
       ((a)->tv_usec CMP (b)->tv_usec) :            \
       ((a)->tv_sec CMP (b)->tv_sec))

#define timer_sub(a, b, result) \
   do {                         \
       (result)->tv_sec = (a)->tv_sec - (b)->tv_sec;     \
       (result)->tv_usec = (a)->tv_usec - (b)->tv_usec;  \
       if ((result)->tv_usec < 0) {                      \
	      --(result)->tv_sec;                        \
	      (result)->tv_usec += 1000000;              \
       }                                                 \
   } while (0)

#define	timer_add(a, b, result)						      \
  do {									      \
    (result)->tv_sec = (a)->tv_sec + (b)->tv_sec;			      \
    (result)->tv_usec = (a)->tv_usec + (b)->tv_usec;			      \
    if ((result)->tv_usec >= 1000000)					      \
      {									      \
	++(result)->tv_sec;						      \
	(result)->tv_usec -= 1000000;					      \
      }									      \
  } while (0)

unsigned long
getWait_Key(ScreenBase * base, long milliseconds)
{
	return get_wait_key(base, milliseconds, 0);
}

static unsigned long
get_wait_key(ScreenBase * base, long milliseconds, int raw)
{
	unsigned char ch;
	struct timeval end, tv, dt;
	unsigned long key;

	gettimeofday(&tv, 0);
	dt.tv_sec = milliseconds / 1000;
	dt.tv_usec = (milliseconds % 1000) * 1000;

	timer_add(&tv, &dt, &end);

	/*newMatch_Key(base); */
	if (raw && !scr_scan_mode)
		return 0;
	if (!raw && scr_scan_mode)
	{
		key = scan_check();
		if (key)
                {
                	scan_reset();
			return key;
		}
	}

#ifdef OS_CYGWIN
	if (w32_console)
	{
		struct timeval timeout;
		long ms_timeout;

		for (;;)
		{
			int r;

			while (w32_scan_buf_len)
			{
				ch = w32_readch();
				if (match_Key(base, ch, &key))
				{
					newMatch_Key(base);
					return key;
				}
			}

			if (!milliseconds || timercmp(&end, &tv, <))
			{
				timeout.tv_sec = 0;
				timeout.tv_usec = 0;
			}
			else
			{
				timer_sub(&end, &tv, &timeout);
			}

			ms_timeout = timeout.tv_sec * 1000 + timeout.tv_usec / 1000;

#ifdef USE_TASKS
			r = Task_wait_read(0, ms_timeout);
			if (r)
				return 0;

#else
			r = WaitForMultipleObjects(1, &w32_hStdIn, 1, ms_timeout);

			if (r != WAIT_OBJECT_0)
				return 0;

#endif

			ch = w32_readch();
			if (raw && scr_scan_mode)
			{
                        	if (!scan_push(ch))
                                	goto again1;
				return ch;
			}
			if (match_Key(base, ch, &key))
			{
				newMatch_Key(base);
				return key;
			}
		     again1:
			gettimeofday(&tv, 0);

		}
		return 0;
	}
#endif

	for (;;)
	{
		struct timeval timeout;
		int r, n;
		fd_set rfs;

		if (!milliseconds || timercmp(&end, &tv, <))
		{
			timeout.tv_sec = 0;
			timeout.tv_usec = 0;
		}
		else
		{
			timer_sub(&end, &tv, &timeout);
		}
		FD_ZERO(&rfs);
		FD_SET(base->fd, &rfs);

		n = base->fd;
#ifdef HAVE_GPM_H
		if (gpm_fd >= 0)
		{
			FD_SET(gpm_fd, &rfs);
			if (gpm_fd > n)
				n = gpm_fd;
		}
#endif

		r = select(n + 1, &rfs, 0, 0, &timeout);

		if (r < 1)
		{
			if (!milliseconds)
				return 0;
			else
			{
				gettimeofday(&tv, 0);
				if (timercmp(&tv, &end, >))
					return 0;
				continue;
			}
		}

#ifdef HAVE_GPM_H
		if (gpm_fd >= 0)
		{
			if (FD_ISSET(gpm_fd, &rfs))
			{
				key = get_gpm_mouse(base);
				if (key)
					return key;
			}
		}
#endif

		if (!FD_ISSET(base->fd, &rfs))
			continue;

		if (read(base->fd, &ch, 1) < 1)
			return 0;

		if (raw && scr_scan_mode)
		{
                        if (!scan_push(ch))
                               	goto again;
			return ch;
		}

		if (match_Key(base, ch, &key))
		{
			newMatch_Key(base);
			return key;
		}
            again:
		gettimeofday(&tv, 0);
	}
}

/* termcap capabilities ][ Screen  */

Screen *
new_Screen(ScreenBase * base)
{
	int i;
	Screen *scr;
	char *mem;
	int Lines = base->Lines;
	int Columns = base->Columns;

	scr = (Screen *) calloc(1, sizeof(Screen));
	scr->base = base;
	scr->mem = mem = (char *) calloc(Lines * Columns * 3 + Lines * 3 * sizeof(char *) + Lines * 2 * sizeof(int), 1);

	scr->chars = (unsigned char **) (mem + Lines * Columns * 3);
	scr->colors = (unsigned char **) (mem + Lines * Columns * 3 + Lines * sizeof(char *));
	scr->attrs = (unsigned char **) (mem + Lines * Columns * 3 + Lines * sizeof(char *) * 2);
	scr->touched = (int *) (mem + Lines * Columns * 3 + Lines * sizeof(char *) * 3);
	scr->lnums = (int *) (mem + Lines * Columns * 3 + Lines * sizeof(char *) * 3 + Lines * sizeof(int));

	for (i = 0; i < Lines; i++)
	{
		scr->chars[i] = (unsigned char *) (mem + Columns * i);
		scr->colors[i] = (unsigned char *) (mem + Lines * Columns + Columns * i);
		scr->attrs[i] = (unsigned char *) (mem + Lines * Columns * 2 + Columns * i);
		scr->lnums[i] = i;
		scr->touched[i] = 0;
	}

	memset(mem, ' ', Lines * Columns);
	memset(mem + Lines * Columns, COLOR_WHITE | COLOR_BACK_BLACK, Lines * Columns);
	memset(mem + Lines * Columns * 2, 0, Lines * Columns);

	scr->y = scr->x = 0;
	scr->beeps = 0;

	return scr;
}

void
delete_Screen(Screen * scr)
{
	free(scr->mem);
	free(scr);
}

void
beep_Screen(Screen * scr)
{
	scr->beeps++;
}

void
addLine_Screen(Screen * scr, int line, unsigned char attr)
{
	int i;
	int Lines = scr->base->Lines;
	int Columns = scr->base->Columns;

	if (line < 0)
		line = 0;
	if (line >= Lines)
		line = Lines - 1;

	for (i = Lines - 1; i > line; i--)
	{
		memcpy(scr->chars[i], scr->chars[i - 1], Columns);
		memcpy(scr->colors[i], scr->colors[i - 1], Columns);
		memcpy(scr->attrs[i], scr->attrs[i - 1], Columns);
		scr->lnums[i] = scr->lnums[i - 1];
		scr->touched[i] = 1;
	}

	scr->lnums[line] = -1;
	scr->touched[line] = 1;
	memset(scr->chars[line], ' ', Columns);
	memset(scr->colors[line], attr, Columns);
	memset(scr->attrs[line], 0, Columns);
}

void
delLine_Screen(Screen * scr, int line, unsigned char attr)
{
	int i;
	int Lines = scr->base->Lines;
	int Columns = scr->base->Columns;

	if (line < 0)
		line = 0;
	if (line >= Lines)
		line = Lines - 1;

	for (i = line; i < Lines - 1; i++)
	{
		memcpy(scr->chars[i], scr->chars[i + 1], Columns);
		memcpy(scr->colors[i], scr->colors[i + 1], Columns);
		memcpy(scr->attrs[i], scr->attrs[i + 1], Columns);
		scr->lnums[i] = scr->lnums[i + 1];
		scr->touched[i] = 1;
	}

	scr->lnums[Lines - 1] = -1;
	scr->touched[Lines - 1] = 1;
	memset(scr->chars[Lines - 1], ' ', Columns);
	memset(scr->colors[Lines - 1], attr, Columns);
	memset(scr->attrs[Lines - 1], 0, Columns);
}

void
scroll_Screen(Screen * scr, int beg, int end, int num, unsigned char attr)
{
	int columns = scr->base->Columns;

	scrollw_Screen(scr, beg, 0, end, columns - 1, num, attr);
}

void
scrollw_Screen(Screen * scr, int beg, int left, int end, int right, int num, unsigned char attr)
{
	int i, dw;
	int Lines = scr->base->Lines;
	int Columns = scr->base->Columns;

	if (beg < 0)
		beg = 0;
	if (end >= Lines)
		end = Lines - 1;
	if (beg > end)
		return;
	if (left < 0)
		left = 0;
	if (right >= Columns)
		right = Columns - 1;
	dw = right - left + 1;

	if (num == 0)
		return;
	for (i = beg; i <= end; i++)
		scr->touched[i] = 1;
	if (num > 0)
	{
		for (i = beg + num; i <= end; i++)
		{
			memcpy(scr->chars[i - num] + left, scr->chars[i] + left, dw);
			memcpy(scr->colors[i - num] + left, scr->colors[i] + left, dw);
			memcpy(scr->attrs[i - num] + left, scr->attrs[i] + left, dw);
			scr->lnums[i - num] = scr->lnums[i];
			/*scr->touched[i - num] = 1; */
		}
		for (i = end - num + 1; i <= end; i++)
		{
			memset(scr->chars[i] + left, ' ', dw);
			memset(scr->colors[i] + left, attr, dw);
			memset(scr->attrs[i] + left, 0, dw);
			scr->lnums[i] = -1;
			/*scr->touched[i] = 1; */
		}
	}
	else
	{
		for (i = end + num; i >= beg; i--)
		{
			memcpy(scr->chars[i - num] + left, scr->chars[i] + left, dw);
			memcpy(scr->colors[i - num] + left, scr->colors[i] + left, dw);
			memcpy(scr->attrs[i - num] + left, scr->attrs[i] + left, dw);
			scr->lnums[i - num] = scr->lnums[i];
			/*scr->touched[i - num] = 1; */
		}
		for (i = beg - num - 1; i >= beg; i--)
		{
			memset(scr->chars[i] + left, ' ', dw);
			memset(scr->colors[i] + left, attr, dw);
			memset(scr->attrs[i] + left, 0, dw);
			scr->lnums[i] = -1;
			/*scr->touched[i] = 1; */
		}
	}
}

static void
syncLine(Screen * scr, int y)
{
	int Lines = scr->base->Lines;
	int Columns = scr->base->Columns;
	int columns = (y == Lines - 1 ? Columns - 1 : Columns);
	int x, e, i, end, l, contnum;
	unsigned char *chars, *ochars, *colors, *ocolors, *attrs, *oattrs;
	ScreenData *dp = (ScreenData *) scr->base->data;

	if (!scr->touched[y])
		return;
	scr->touched[y] = 0;

	chars = scr->chars[y];
	ochars = scr->base->realScreen->chars[y];
	colors = scr->colors[y];
	ocolors = scr->base->realScreen->colors[y];
	attrs = scr->attrs[y];
	oattrs = scr->base->realScreen->attrs[y];

	for (x = 0; x < columns && chars[x] == ochars[x] && colors[x] == ocolors[x] && attrs[x] == oattrs[x]; x++);

	if (x >= columns)
		return;

	for (l = columns - 1; l >= x && chars[l] == ochars[l] && colors[l] == ocolors[l] && attrs[l] == oattrs[l]; l--);

	if (l < x)
		return;

	e = end = l;
	i = x;

#ifdef OS_CYGWIN
	if (w32_console)
	{
		CHAR_INFO *p;

		if (y < w32_beg.Y)
			w32_beg.Y = y;
		if (y > w32_end.Y)
			w32_end.Y = y;
		if (x < w32_beg.X)
			w32_beg.X = x;
		if (e > w32_end.X)
			w32_end.X = e;

		for (p = w32_screen + y * w32_size.X + x; i <= e; i++, p++)
		{
			int ch, pg;

			ch = chars[i];
			p->Attributes = colors[i];
			if (dp->pg_mode && ch < 32 && (pg = dp->pgTable[ch]))
				ch = dp->base->pg_chars[pg];
			else
				ch = dp->outputTable[ch];
			p->Char.AsciiChar = ch;

			ocolors[i] = colors[i];
			ochars[i] = chars[i];
			oattrs[i] = attrs[i];
		}

		return;
	}
#endif

/* Search the first nonblank character from the end of line. */
	if (dp->termcap_CE)
	{
		int p = columns - 1;

		if (chars[p] == ' ')
			while (p > 0 && chars[p] == chars[p - 1] && colors[p] == colors[p - 1] && attrs[p] == attrs[p - 1])
				--p;
		/* If there are more than 4 characters to clear, use CE. */
		if (e > p + 4 || (e > p && y >= Lines - 1))
			e = p - 1;
	}

	contnum = 0;
	for (; i <= e; i++, x++)
	{
		if (x >= Columns || y >= Lines)
			return;

		if (chars[i] == ochars[i] && colors[i] == ocolors[i] && attrs[i] == oattrs[i])
		{
			contnum = 0;
			continue;
		}

		if (!contnum)
			termcap_set_cursor(dp, y, x);
		contnum++;
		termcap_set_color(dp, colors[i] /*& 0x7f */ );
		/*if (colors[i] & 0x80) */
		if (attrs[i] & PG_ATTR)
			termcap_put_graph_char(dp, chars[i]);
		else
			termcap_put_char(dp, chars[i]);
		ocolors[i] = colors[i];
		ochars[i] = chars[i];
		oattrs[i] = attrs[i];
	}

/* Clear the end of line.
   First check if it is needed. */

	if (dp->termcap_CE && e < end)
	{
		termcap_set_cursor(dp, y, x);
		termcap_set_color(dp, colors[i]);
		termcap_put_raw_str(dp, dp->termcap_CE);
		while (i <= end)
		{
			ocolors[i] = colors[i];
			ochars[i] = chars[i];
			oattrs[i] = attrs[i];
			i++;
		}
	}

}

void
sync_Screen(Screen * scr)
{
	int y;
	int line, n, topline, botline;
	int Lines = scr->base->Lines;
	ScreenData *dp = (ScreenData *) scr->base->data;

/* make scrolls */

#ifdef OS_CYGWIN
	if (w32_console)
	{
		w32_beg = w32_size;
		w32_end.X = 0;
		w32_end.Y = 0;
	}
	else
#endif
	{

		for (line = 0; line < Lines; line++)
		{
			/* find next range to scrool */

			/* skip fresh lines */
			while (line < Lines && scr->lnums[line] < 0)
				line++;

			/* last line reached - no range to scrool */
			if (line >= Lines)
				break;

			/* top line found */
			topline = line;

			/* skip range of old lines */
			while (line < Lines - 1 && scr->lnums[line] + 1 == scr->lnums[line + 1])
				line++;

			/* bottom line found */
			botline = line;

			/* compute number of scrools, >0 - forward */
			n = topline - scr->lnums[topline];

			if (n == 0)
				continue;
			else if (n > 0)
				topline = scr->lnums[topline];
			else if (n < 0)
				botline = scr->lnums[botline];

			/* do scrool */
			termcap_scroll(scr->base, topline, botline, n);
		}

	}
	for (line = 0; line < Lines; line++)
		scr->lnums[line] = line;

	if (scr->base->mouse_present && !xterm_mouse && scr->base->mouse_visible && scr->base->mouse_auto_visible)
	{
		unsigned char *ptr;

		ptr = scr->colors[scr->base->mouse_y] + scr->base->mouse_x;
		*ptr = ~*ptr;
		scr->touched[scr->base->mouse_y] = 1;
	}

/* update contens */
	for (y = 0; y < Lines; y++)
		syncLine(scr, y);

#ifdef OS_CYGWIN
	if (w32_console)
	{
		for (; scr->beeps > 0; --scr->beeps)
			w32_beep();
		w32_set_cursor(scr->y, scr->x);
		w32_set_cursor_shape(scr->cursor);
		w32_flush();
	}
	else
#endif
	{
		for (; scr->beeps > 0; --scr->beeps)
			termcap_beep(dp);

		termcap_set_cursor(dp, scr->y, scr->x);
		termcap_set_cursor_shape(dp, scr->cursor);

		termcap_flush(dp);
	}

	if (scr->base->mouse_present && !xterm_mouse && scr->base->mouse_visible && scr->base->mouse_auto_visible)
	{
		unsigned char *ptr;

		ptr = scr->colors[scr->base->mouse_y] + scr->base->mouse_x;
		*ptr = ~*ptr;
		scr->touched[scr->base->mouse_y] = 1;
	}
}

void
redraw_Screen(Screen * scr)
{
	int i, j;
	int Lines = scr->base->Lines;
	int Columns = scr->base->Columns;
	ScreenData *dp = (ScreenData *) scr->base->data;
	unsigned char **chars = scr->base->realScreen->chars;
	unsigned char **colors = scr->base->realScreen->colors;
	unsigned char **attrs = scr->base->realScreen->attrs;

	for (i = 0; i < Lines; ++i)
	{
		for (j = 0; j < Columns; ++j)
		{
			chars[i][j] = ' ';
			colors[i][j] = COLOR_WHITE | COLOR_BACK_BLACK;
			attrs[i][j] = 0;
		}
		scr->touched[i] = 1;
	}

	termcap_set_color(dp, COLOR_WHITE | COLOR_BACK_BLACK);
	termcap_clear_screen(dp);
	termcap_flush(dp);

	sync_Screen(scr);

}

int
iscolor_tty(struct ScreenBase *base)
{
	ScreenData *dp = (ScreenData *) base->data;

	return (dp->termcap_Visuals & VisualColors) ? 1 : 0;
}

void
setAttr_Screen(Screen * scr, int *pblink, int *pbold)
{
	ScreenData *dp = (ScreenData *) scr->base->data;
	int blink, bold;

	blink = dp->useBlinkAttr;
	bold = dp->useBoldAttr;

	if (pblink)
	{
		if (*pblink >= 0)
			dp->useBlinkAttr = *pblink ? 1 : 0;
		*pblink = blink;
	}
	if (pbold)
	{
		if (*pbold >= 0)
			dp->useBoldAttr = *pbold ? 1 : 0;
		*pbold = bold;
	}
}

static void
set_rawmode(int fd, int mode)
{
#ifdef OS_LINUX
	long cmd;

	if (mode)
	{
		/*cmd = K_RAW; */
		cmd = 0x00;
	}
	else
		/*cmd = K_XLATE; */
		cmd = 0x01;

	/*ioctl(fd, KDSKBMODE, cmd); */
	ioctl(fd, 0x4B45, cmd);
	write(1, "\033(K", 3);
#endif

#ifdef OS_CYGWIN

#endif
}

static void
start_scan_mode(int fd)
{
	switch (scr_scan_mode)
	{
	case ScanNone:
		break;
	case ScanTerminal:
		if (scan_start)
			write(fd, scan_start, strlen(scan_start));
		break;
	case ScanIoctl:
		set_rawmode(fd, 1);
		break;
	}
}

static void
stop_scan_mode(int fd)
{
	switch (scr_scan_mode)
	{
	case ScanNone:
		break;
	case ScanTerminal:
		if (scan_stop)
			write(fd, scan_stop, strlen(scan_stop));
		break;
	case ScanIoctl:
		set_rawmode(fd, 0);
		break;
	}
}

#ifdef OS_CYGWIN

static void
w32_clear(void)
{
	CHAR_INFO p;
	int i;

	p.Char.AsciiChar = ' ';
	p.Attributes = 7;
	for (i = 0; i < w32_scrsize; i++)
		w32_screen[i] = p;
	w32_beg.X = 0;
	w32_beg.Y = 0;
	w32_end.X = w32_size.X - 1;
	w32_end.Y = w32_size.Y - 1;
	w32_flush();
}

static void
w32_set_cursor(int r, int c)
{
	COORD coord;

	coord.X = c;
	coord.Y = r;
	SetConsoleCursorPosition(w32_hStdOut, coord);
}

static void
w32_set_cursor_shape(int k)
{
	CONSOLE_CURSOR_INFO info;

	switch (k)
	{
	case 0:
		info.bVisible = 1;
		info.dwSize = 10;
		break;
	case 1:
		info.bVisible = 0;
		info.dwSize = 1;	/* ??? !!! $@!@#$% !!! */
		break;
	case 2:
		info.bVisible = 1;
		info.dwSize = 99;
		break;
	}
	SetConsoleCursorInfo(w32_hStdOut, &info);
}

static void
w32_beep(void)
{
	MessageBeep(MB_OK);
}

static void
w32_flush(void)
{
	SMALL_RECT rect;
	int r;

	rect.Top = w32_beg.Y;
	rect.Left = w32_beg.X;
	rect.Bottom = w32_end.Y;
	rect.Right = w32_end.X;

	if (rect.Top > rect.Bottom || rect.Left > rect.Right)
		return;

	r = WriteConsoleOutput(w32_hStdOut, w32_screen, w32_size, w32_beg, &rect);

	w32_beg = w32_size;
	w32_end.X = 0;
	w32_end.Y = 0;
}

static unsigned char
w32_get_scan_buf(void)
{
	unsigned char r = 0;

	if (w32_scan_buf_len)
	{
		r = w32_scan_buf[0];
		--w32_scan_buf_len;
		if (w32_scan_buf_len)
			memmove(w32_scan_buf, w32_scan_buf + 1, w32_scan_buf_len);
	}
	return r;
}

static void
w32_put_scan_buf(unsigned char b)
{
	if (w32_scan_buf_len == w32_scan_buf_size)
	{
		int size = w32_scan_buf_size * 2;

		if (size < 8)
			size = 8;
		w32_scan_buf_size = size;
		w32_scan_buf = (unsigned char *) realloc(w32_scan_buf, size);
	}

	w32_scan_buf[w32_scan_buf_len] = b;
	w32_scan_buf_len++;
}

static void
w32_push_key_event(KEY_EVENT_RECORD * kp)
{
	unsigned char ch;
	unsigned short word;
	int i;
	DWORD pstate;
	static int first = 1;

	word = kp->wVirtualScanCode;
	pstate = kp->dwControlKeyState;

	if (first && word != 0x45 && (pstate & NUMLOCK_ON))
	{
		first = 0;
		scan_numlock_state = 1;
	}

/*      printf("\nread key: scan=0x%x pstate=0x%x count=%d down=%d\n", word, pstate, kp->wRepeatCount, kp->bKeyDown); */

	for (i = 0; i < kp->wRepeatCount; i++)
	{
		if ((pstate & ENHANCED_KEY) && (word != 0x45))
		{
			ch = 0xe0;
			w32_put_scan_buf(ch);
		}
		ch = word /*& 0xff */ ;

		if (!kp->bKeyDown)
			ch |= 0x80;
		w32_put_scan_buf(ch);
	}
}

/*
   push XTERM mouse sequence
 */
static void
w32_push_mouse_event(MOUSE_EVENT_RECORD * mp)
{
	int state = mp->dwButtonState;
	int event = mp->dwEventFlags;
	int bb, x, y, i;
	unsigned char sb[8];

	x = mp->dwMousePosition.X;
	y = mp->dwMousePosition.Y;

	if (event == MOUSE_MOVED)
		bb = 4;
	else if (!state)
		bb = 3;
	else if (state & FROM_LEFT_1ST_BUTTON_PRESSED)
		bb = 0;
	else if (state & FROM_LEFT_2ND_BUTTON_PRESSED)
		bb = 1;
	else if (state & RIGHTMOST_BUTTON_PRESSED)
		bb = 2;
	else
		bb = 4;

	sb[0] = RAWMODE_ESC;
	sb[1] = bb;
	sb[2] = x;
	sb[3] = y;

	for (i = 0; i < 4; i++)
		w32_put_scan_buf(sb[i]);
}

static int
w32_readch(void)
{
	INPUT_RECORD inputBuffer;
	DWORD dwInputEvents;

/*      printf("w32_readch()\n"); */

	if (w32_scan_buf_len)
		return w32_get_scan_buf();

	ReadConsoleInput(w32_hStdIn, &inputBuffer, 1, &dwInputEvents);

	if (inputBuffer.EventType == KEY_EVENT)
	{
		if (inputBuffer.Event.KeyEvent.bKeyDown
		    && (inputBuffer.Event.KeyEvent.wVirtualScanCode == 27)
		    && (inputBuffer.Event.KeyEvent.dwControlKeyState &
			(LEFT_ALT_PRESSED | RIGHT_ALT_PRESSED))
		    && (inputBuffer.Event.KeyEvent.dwControlKeyState & (LEFT_CTRL_PRESSED | RIGHT_CTRL_PRESSED)))
		{
			printf("\nescape key pressed; exiting...\n");
			exit(1);
		}
		w32_push_key_event(&inputBuffer.Event.KeyEvent);
	}
	else if (inputBuffer.EventType == MOUSE_EVENT)
	{
		w32_push_mouse_event(&inputBuffer.Event.MouseEvent);
	}

	return w32_get_scan_buf();
}

#endif

static void
init_mouse(ScreenBase * base, char **envp)
{
	char *term;

#ifndef OS_CYGWIN
	char *e;
#endif

	term = base->terminalName;

	if (base->fd < 0)
		return;

	base->mouse_top = 0;
	base->mouse_left = 0;
	base->mouse_bottom = base->Lines - 1;
	base->mouse_right = base->Columns - 1;
	base->mouse_visible = 1;
	base->mouse_auto_visible = 0;
	base->mouse_dclick_speed = 250;
	base->mouse_driver = "";

#ifdef OS_CYGWIN
	xterm_mouse = 1;
	base->mouse_present = 1;
	base->mouse_driver = "win32console";
	return;
#else

	e = get_env(envp, "XTERM_MOUSE");

	if ((e && (!strcasecmp(e, "yes") || !strcasecmp(e, "on")))
	    || !strncmp(term, "xterm", 5) || !strncmp(term, "rxvt", 4) || strstr(term, "xterm") || strstr(term, "rxvt"))
	{
		const char msg[] = "\033[?1001s\033[?1000h";

		xterm_mouse = 1;

		/* turn xterm mouse on */

		write(1, msg, sizeof(msg) - 1);
		base->mouse_present = 1;
		base->mouse_driver = "xterm";

		return;
	}
#endif

#ifdef HAVE_GPM_H
	{
		int r;

		memset(&conn, 0, sizeof(conn));
		conn.eventMask = GPM_MOVE | GPM_UP | GPM_DOWN | GPM_DRAG | GPM_DOUBLE;
		conn.defaultMask = 0;
		conn.minMod = 0;
		conn.maxMod = 0;
		gpm_zerobased = 1;
		r = Gpm_Open(&conn, 0);
		if (r >= 0)
		{
			base->mouse_present = 1;
			base->mouse_driver = "LinuxConsoleGPM";
		}
		_clip_logg(3, "Gpm_Open return %d", r);
	}
#endif
}

int
setPgMode_Screen(Screen * scr, int newmode)
{
	int r;
	ScreenData *dp;

	dp = ((ScreenData *) scr->base->data);
	r = dp->pg_mode;
	dp->pg_mode = newmode;

	return r;
}

/* Screen ] */
