/*
$Log: screen.h,v $
Revision 1.19  2002/05/27 11:17:58  clip
scankey() fix
paul

Revision 1.18  2002/05/18 11:59:07  clip
fix for f13-f20 func keys, as shift-F
paul

Revision 1.17  2002/04/24 09:51:14  clip
_SET_DISPBOX turn off pg char translation
paul

Revision 1.16  2002/04/09 12:14:04  clip
screen patches by Przemyslaw Czerpak
paul

Revision 1.15  2002/01/16 15:29:08  clip
chinese patch
preproc bugs
some pseudographic chars < 32
paul

Revision 1.14  2001/12/11 07:48:25  clip
middle mouse button
paul

Revision 1.13  2001/11/27 14:58:09  clip
comment in cvs log message

Revision 1.12  2001/11/27 13:46:15  clip
mouse functions now work in xterm* / rxvt* terminals
paul

Revision 1.10  2001/11/26 15:39:50  clip
Linux console GPM mouse handling
paul

Revision 1.9  2001/10/29 11:56:34  clip
fix for BLINK(intensitive background)
paul

Revision 1.8  2000/12/06 13:13:01  clip
loadable charset tables. size 256
paul

Revision 1.7  2000/12/03 10:52:56  clip
scancodes
paul

Revision 1.6  2000/12/02 12:46:57  clip
scancodes
paul

Revision 1.5  2000/05/23 23:07:32  clip
scroll
Paul Lasarev <paul@itk.ru>

Revision 1.4  2000/05/03 21:39:23  clip
add set cursor shape

Revision 1.3  2000/04/13 17:38:48  paul
f10-f12 keys

Revision 1.2  1999/11/02 23:05:53  axl
start of logging CVS

*/

#ifndef SCREEN_H
#define SCREEN_H

/* cursor goto handling with padding/delay checking */
void scr_tgoto(char *CM, int destcol, int destline, char *buf, int buflen);
int scr_tputs(const char *str, int affcnt, int (*put_c)(int, void*), void *par);

struct ScreenBase;

typedef unsigned char ScreenPgChars[256];

int init_tty(struct ScreenBase *base, int fd, char **envp,
	int clear_on_exit, ScreenPgChars *pg_chars,
	char *errbuf, int errbuflen);
int destroy_tty(struct ScreenBase *base);
int iscolor_tty(struct ScreenBase *base);

int restore_tty(struct ScreenBase *base);    	/* restore start mode */
int restart_tty(struct ScreenBase *base);    	/* set work mode */

typedef struct Screen
{
	char *mem;
	unsigned char **chars;
	unsigned char **colors;
	unsigned char **attrs;
	int *touched;
	int *lnums;		/* scroll info */
	int x, y;		/* cursor position */
	int beeps;
	int cursor;	/* 0 - normal; 1 - invisible; 2 - fullblock */
	struct ScreenBase *base;
} Screen;

#define PG_ATTR 0x80		/* must be or'd with color for PG effect */
#define PG_SIZE         44

typedef struct ScreenBase
{
	int Lines;
	int Columns;
	int clear_on_exit;
	int fd;
	char *terminalName;
	Screen* realScreen;
        int mouse_present;
        int mouse_y;
        int mouse_x;
        int mouse_visible;
        int mouse_auto_visible;
        int mouse_top;
        int mouse_bottom;
        int mouse_left;
        int mouse_right;
        int mouse_buttons;
        int mouse_dclick_speed;
        int mouse_clicks_left;
        int mouse_clicks_right;
        int mouse_clicks_middle;
        const char *mouse_driver;
	unsigned char pg_chars[PG_SIZE];
	void *data;
}
ScreenBase;

Screen *new_Screen(ScreenBase *base);

void clear_Screen(Screen *scr);
void setCtrlBreak_Screen(Screen *scr, int val);
void delete_Screen(Screen * scr);
void sync_Screen(Screen * scr);
void redraw_Screen(Screen * scr);
void addLine_Screen(Screen * scr, int line, unsigned char attr);
void delLine_Screen(Screen * scr, int line, unsigned char attr);
void scroll_Screen(Screen * scr, int beg, int end, int num, unsigned char attr);
void scrollw_Screen(Screen * scr, int beg, int left, int end, int right, int num, unsigned char attr);
void beep_Screen(Screen * scr);
void setAttr_Screen(Screen * scr, int * blink, int * bold);
int setPgMode_Screen(Screen *scr, int newmode);

void newMatch_Key(ScreenBase *base);
int match_Key(ScreenBase *base, unsigned char b, unsigned long *keyp); /* true if matched */
unsigned long get_Key(ScreenBase *base);	  /* wait forever */
unsigned long getWait_Key(ScreenBase *base, long milliseconds); /* 0 means nowait */

unsigned long getRaw_Key(ScreenBase *base);
unsigned long getRawWait_Key(ScreenBase * base, long milliseconds);
int getState_Key(ScreenBase *base);
/* state bits */
#define KEY_SHIFT	0
#define KEY_CTRL	2
#define KEY_ALT		3
#define KEY_ALTGR	1
#define KEY_SHIFTL	4
#define KEY_SHIFTR	5
#define KEY_CTRLL	6
#define KEY_CTRLR	7
#define KEY_CAPSSHIFT	8

#define KEY_SLOCK	9
#define KEY_NUMLOCK	10
#define KEY_CAPSLOCK	11
#define KEY_INSLOCK	12

/* colors */
#define COLOR_BLACK   		0x0
#define COLOR_BLUE    		0x1
#define COLOR_GREEN   		0x2
#define COLOR_CYAN    		0x3
#define COLOR_RED     		0x4
#define COLOR_MAGENTA 		0x5
#define COLOR_YELLOW  		0x6
#define COLOR_WHITE   		0x7

#define COLOR_HI		0x8
#define COLOR_HI_BLACK 		0x8
#define COLOR_HI_BLUE  		0x9
#define COLOR_HI_GREEN 		0xA
#define COLOR_HI_CYAN  		0xB
#define COLOR_HI_RED   		0xC
#define COLOR_HI_MAGENTA	0xD
#define COLOR_HI_YELLOW 	0xE
#define COLOR_HI_WHITE  	0xF

#define COLOR_BACK_BLACK	0x00
#define COLOR_BACK_BLUE    	0x10
#define COLOR_BACK_GREEN   	0x20
#define COLOR_BACK_CYAN    	0x30
#define COLOR_BACK_RED     	0x40
#define COLOR_BACK_MAGENTA 	0x50
#define COLOR_BACK_YELLOW  	0x60
#define COLOR_BACK_WHITE   	0x70

/* pseudographs */
#define PG_NONE		0
#define PG_STERLING	1
#define PG_DARROW	2
#define PG_LARROW       3
#define PG_RARROW	4
#define PG_UARROW       5
#define PG_BOARD        6
#define PG_BULLET       7
#define PG_CKBOARD      8
#define PG_DEGREE       9
#define PG_DIAMOND      10
#define PG_GEQUAL       11
#define PG_PI           12
#define PG_HLINE        13
#define PG_LANTERN      14
#define PG_PLUS         15
#define PG_LEQUAL       16
#define PG_LLCORNER     17
#define PG_LRCORNER     18
#define PG_NEQUAL       19
#define PG_PLMINUS      20
#define PG_S1           21
#define PG_S3           22
#define PG_S7           23
#define PG_S9           24
#define PG_BLOCK        25
#define PG_TTEE         26
#define PG_RTEE         27
#define PG_LTEE         28
#define PG_BTEE         29
#define PG_ULCORNER     30
#define PG_URCORNER     31
#define PG_VLINE        32

#define PG_HLINE2        33
#define PG_PLUS2         34
#define PG_LLCORNER2     35
#define PG_LRCORNER2     36
#define PG_TTEE2         37
#define PG_RTEE2         38
#define PG_LTEE2         39
#define PG_BTEE2         40
#define PG_ULCORNER2     41
#define PG_URCORNER2     42
#define PG_VLINE2        43


/*  PG chars in range 1-31 */

#define PGCH_HLINE	1
#define PGCH_LLCORNER   2
#define PGCH_LRCORNER   3
#define PGCH_TTEE       4
#define PGCH_RTEE       5
#define PGCH_LTEE       6
#define PGCH_BTEE       7
#define PGCH_ULCORNER   8
#define PGCH_URCORNER   14
#define PGCH_VLINE      15

#define PGCH_HLINE2     18
#define PGCH_LLCORNER2  19
#define PGCH_LRCORNER2  20
#define PGCH_TTEE2      21
#define PGCH_RTEE2      22
#define PGCH_LTEE2      23
#define PGCH_BTEE2      24
#define PGCH_ULCORNER2  25
#define PGCH_URCORNER2  26
#define PGCH_VLINE2     27

#define PGCH_PLUS       28
#define PGCH_PLUS2      29
#define PGCH_BLOCK      30

#define PGCH_RARROW	16
#define PGCH_LARROW	17



#define META_MASK   0x10000000
#define META1_MASK  0x20000000
#define META2_MASK  0x40000000
#define META(x)    ((x)|META_MASK)
#define META1(x)    ((x)|META1_MASK)
#define META2(x)    ((x)|META2_MASK)
#define IS_META1(x) ((x)&META1_MASK)
#define IS_META2(x) ((x)&META2_MASK)
#define CNTRL(x) ((x) & 037)

#define MOUSE_MASK		0x80000000
#define MOUSE_ROW_MASK		0x000000FF
#define MOUSE_COL_MASK		0x0000FF00
#define MOUSE_TYPE_MASK 	0x00FF0000
#define MOUSE_BUTTONS_MASK	0x0F000000

#define IS_MOUSE(x) ((x)&MOUSE_MASK)
#define MOUSE_ROW(x) ((x)&MOUSE_ROW_MASK)
#define MOUSE_COL(x) (((x)&MOUSE_COL_MASK)>>8)
#define MOUSE_TYPE(x) (((x)&MOUSE_TYPE_MASK)>>16)
#define MOUSE_BUTTONS(x) (((x)&MOUSE_BUTTONS_MASK)>>24)

#define MOUSE_SET_ROW(x) (((unsigned long)(x))&MOUSE_ROW_MASK)
#define MOUSE_SET_COL(x) ((((unsigned long)(x))<<8)&MOUSE_COL_MASK)
#define MOUSE_SET_TYPE(x) ((((unsigned long)(x))<<16)&MOUSE_TYPE_MASK)
#define MOUSE_SET_BUTTONS(x) ((((unsigned long)(x))<<24)&MOUSE_BUTTONS_MASK)

/* MOUSE_TYPE values */
#define MOUSE_TYPE_MOVE		1
#define MOUSE_TYPE_DRAG		2
#define MOUSE_TYPE_DOWN		4
#define MOUSE_TYPE_UP   	8
#define MOUSE_TYPE_SINGLE	16
#define MOUSE_TYPE_DOUBLE	32

/* MOUSE_BUTTONS values */
#define MOUSE_BUTTONS_LEFT	4
#define MOUSE_BUTTONS_MIDDLE	2
#define MOUSE_BUTTONS_RIGHT	1


#define KEY_LEFT    META('l')
#define KEY_RIGHT   META('r')
#define KEY_UP      META('u')
#define KEY_DOWN    META('d')
#define KEY_PGDN    META('n')
#define KEY_PGUP    META('p')
#define KEY_HOME    META('h')
#define KEY_END     META('e')
#define KEY_INS     META('i')
#define KEY_BS      META('s')
#define KEY_DEL     META('b')
#define KEY_ENTER   '\r'
#define KEY_ESC	    '\033'

#define KEY_F1      META('1')
#define KEY_F2      META('2')
#define KEY_F3      META('3')
#define KEY_F4      META('4')
#define KEY_F5      META('5')
#define KEY_F6      META('6')
#define KEY_F7      META('7')
#define KEY_F8      META('8')
#define KEY_F9      META('9')
#define KEY_F10     META('0')
#define KEY_F11     META('A')
#define KEY_F12     META('B')

#define KEY_F13     META('C')
#define KEY_F14     META('D')
#define KEY_F15     META('E')
#define KEY_F16     META('F')
#define KEY_F17     META('G')
#define KEY_F18     META('H')
#define KEY_F19     META('I')
#define KEY_F20     META('J')

#define KEY_MOUSE	META('M')

#endif
