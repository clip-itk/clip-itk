
/*
   $Log: scankey.c,v $
   Revision 1.34  2005/02/03 17:21:29  clip
   uri: kbdstat(), bit #18, for En/Ru detection. Only for scan mode keyboard.

   Revision 1.33  2004/12/15 07:05:37  clip
   uri: add KSET*()

   Revision 1.32  2004/07/08 10:28:37  clip
   uri: small fix

   Revision 1.31  2004/07/08 09:15:35  clip
   uri: small fix

   Revision 1.30  2004/07/08 07:21:05  clip
   uri: small fix for kbdstat()

   Revision 1.29  2003/09/02 14:27:43  clip
   changes for MINGW from
   Mauricio Abre <maurifull@datafull.com>
   paul

   Revision 1.28  2003/02/18 10:17:53  clip
   possible fixes scancode priority to ALT-CTRL-SHIFT
   paul

   Revision 1.27  2003/02/07 09:14:53  clip
   leds on linux console in scan mode
   closes #104
   paul

   Revision 1.26  2002/12/20 11:21:46  clip
   fix for ^2, ^6, Ctrl+numpads in scan mode
   closes #88
   paul

   Revision 1.25  2002/12/20 08:53:50  clip
   fix enhanced scancodes in Cygwin
   closes #12
   asdf

   Revision 1.24  2002/12/17 12:08:46  clip
   fix scancodes for keypad '/' '*' '-' '+' + alt/ctrl
   paul

   Revision 1.23  2002/09/20 10:41:45  clip
   fix for shift-Home/End/PgUn/PgDn/Up/Down/Left/Right
   paul

   Revision 1.22  2002/07/30 11:05:14  clip
   scancodes
   paul

   Revision 1.21  2002/07/30 10:44:10  clip
   preproc: fix for delim
   paul

   Revision 1.20  2002/07/30 08:06:16  clip
   Alt0-9 in scanmode
   paul

   Revision 1.19  2002/05/28 06:48:27  clip
   scankey tricks
   paul

   Revision 1.18  2002/05/27 14:10:59  clip
   scankey fix
   paul

   Revision 1.17  2002/03/15 11:49:42  clip
   fix for Numlock key scancode in win >= 2k
   paul

   Revision 1.16  2002/01/30 08:20:07  clip
   cigwin PG_CHARS fixes
   bzip2 func prefix auto-configuration
   paul

   Revision 1.15  2001/05/30 10:49:27  clip
   switch
   paul

   Revision 1.14  2001/05/30 10:37:19  clip
   vt switch
   paul

   Revision 1.13  2001/05/30 10:31:21  clip
   vt switch -- no - 1
   paul

   Revision 1.12  2001/05/30 10:19:43  clip
   VT switch in scan mode on console
   paul

   Revision 1.11  2001/05/15 10:34:28  clip
   memdebug
   paul

   Revision 1.10  2000/12/08 12:59:50  clip
   rus kbd and caps_lock flags

   Revision 1.9  2000/12/06 07:37:54  clip
   adsf
   paul

   Revision 1.8  2000/12/05 07:22:07  clip
   alt=
   paul

   Revision 1.7  2000/12/04 14:12:09  clip
   tab
   paul

   Revision 1.6  2000/12/04 10:09:49  clip
   keymaps
   paul

   Revision 1.5  2000/12/03 13:00:41  clip
   scankeys
   paul

   Revision 1.4  2000/12/03 12:42:34  clip
   scancodes
   paul

   Revision 1.3  2000/12/03 10:52:56  clip
   scancodes
   paul

   Revision 1.2  2000/12/02 12:46:57  clip
   scancodes
   paul

   Revision 1.1  2000/11/30 14:57:15  clip
   scancode support
   paul

 */

#include "../clipcfg.h"
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#ifndef OS_MINGW
#include <sys/ioctl.h>
#endif

#include "../clip.h"
#include "scankey.h"

/* #define DBG  */
/* #define DBG0 */
/* #define DBG1 */
/* #define DBG2 */

#define KG_SHIFT	0
#define KG_CTRL		2
#define KG_ALT		3
#define KG_ALTGR	1
#define KG_SHIFTL	4
#define KG_SHIFTR	5
#define KG_CTRLL	6
#define KG_CTRLR	7
#define KG_CAPSSHIFT	8

#define K_SHIFTLOCK	K(KT_LOCK,KG_SHIFT)
#define K_CTRLLOCK	K(KT_LOCK,KG_CTRL)
#define K_ALTLOCK	K(KT_LOCK,KG_ALT)
#define K_ALTGRLOCK	K(KT_LOCK,KG_ALTGR)
#define K_SHIFTLLOCK	K(KT_LOCK,KG_SHIFTL)
#define K_SHIFTRLOCK	K(KT_LOCK,KG_SHIFTR)
#define K_CTRLLLOCK	K(KT_LOCK,KG_CTRLL)
#define K_CTRLRLOCK	K(KT_LOCK,KG_CTRLR)

#define NR_SHIFT	9
#define NR_PAD		20
#define NR_DEAD		6
#define NR_ASCII	26
#define NR_LOCK		8

#define KT_LATIN	0	/* we depend on this being zero */
#define KT_LETTER	11	/* symbol that can be acted upon by CapsLock */
#define KT_FN		1
#define KT_SPEC		2
#define KT_PAD		3
#define KT_DEAD		4
#define KT_CONS		5
#define KT_CUR		6
#define KT_SHIFT	7
#define KT_META		8
#define KT_ASCII	9
#define KT_LOCK		10
#define KT_SLOCK	12

#define K(t,v)		(((t)<<8)|(v))
#define KTYP(x)		((x) >> 8)
#define KVAL(x)		((x) & 0xff)

#define K_SHIFT		K(KT_SHIFT,KG_SHIFT)
#define K_CTRL		K(KT_SHIFT,KG_CTRL)
#define K_ALT		K(KT_SHIFT,KG_ALT)
#define K_ALTGR		K(KT_SHIFT,KG_ALTGR)
#define K_SHIFTL	K(KT_SHIFT,KG_SHIFTL)
#define K_SHIFTR	K(KT_SHIFT,KG_SHIFTR)
#define K_CTRLL		K(KT_SHIFT,KG_CTRLL)
#define K_CTRLR		K(KT_SHIFT,KG_CTRLR)
#define K_CAPSSHIFT	K(KT_SHIFT,KG_CAPSSHIFT)

#define K_P0		K(KT_PAD,0)
#define K_P1		K(KT_PAD,1)
#define K_P2		K(KT_PAD,2)
#define K_P3		K(KT_PAD,3)
#define K_P4		K(KT_PAD,4)
#define K_P5		K(KT_PAD,5)
#define K_P6		K(KT_PAD,6)
#define K_P7		K(KT_PAD,7)
#define K_P8		K(KT_PAD,8)
#define K_P9		K(KT_PAD,9)
#define K_PPLUS		K(KT_PAD,10)	/* key-pad plus */
#define K_PMINUS	K(KT_PAD,11)	/* key-pad minus */
#define K_PSTAR		K(KT_PAD,12)	/* key-pad asterisk (star) */
#define K_PSLASH	K(KT_PAD,13)	/* key-pad slash */
#define K_PENTER	K(KT_PAD,14)	/* key-pad enter */
#define K_PCOMMA	K(KT_PAD,15)	/* key-pad comma: kludge... */
#define K_PDOT		K(KT_PAD,16)	/* key-pad dot (period): kludge... */
#define K_PPLUSMINUS	K(KT_PAD,17)	/* key-pad plus/minus */
#define K_PPARENL	K(KT_PAD,18)	/* key-pad left parenthesis */
#define K_PPARENR	K(KT_PAD,19)	/* key-pad right parenthesis */

#define K_DOWN		K(KT_CUR,0)
#define K_LEFT		K(KT_CUR,1)
#define K_RIGHT		K(KT_CUR,2)
#define K_UP		K(KT_CUR,3)

#define K_F1		K(KT_FN,0)
#define K_F2		K(KT_FN,1)
#define K_F3		K(KT_FN,2)
#define K_F4		K(KT_FN,3)
#define K_F5		K(KT_FN,4)
#define K_F6		K(KT_FN,5)
#define K_F7		K(KT_FN,6)
#define K_F8		K(KT_FN,7)
#define K_F9		K(KT_FN,8)
#define K_F10		K(KT_FN,9)
#define K_F11		K(KT_FN,10)
#define K_F12		K(KT_FN,11)
#define K_F13		K(KT_FN,12)
#define K_F14		K(KT_FN,13)
#define K_F15		K(KT_FN,14)
#define K_F16		K(KT_FN,15)
#define K_F17		K(KT_FN,16)
#define K_F18		K(KT_FN,17)
#define K_F19		K(KT_FN,18)
#define K_F20		K(KT_FN,19)
#define K_FIND		K(KT_FN,20)
#define K_INSERT	K(KT_FN,21)
#define K_REMOVE	K(KT_FN,22)
#define K_SELECT	K(KT_FN,23)
#define K_PGUP		K(KT_FN,24)	/* PGUP is a synonym for PRIOR */
#define K_PGDN		K(KT_FN,25)	/* PGDN is a synonym for NEXT */
#define K_MACRO		K(KT_FN,26)
#define K_HELP		K(KT_FN,27)
#define K_DO		K(KT_FN,28)
#define K_PAUSE		K(KT_FN,29)

#define SIZE(x) (sizeof(x)/sizeof((x)[0]))
#define BITS_PER_LONG (sizeof(long)*8)

/* clip/screen.h keycodes */
#define META_MASK   0x10000000
#define META1_MASK  0x20000000
#define META2_MASK  0x40000000
#define META(x)    ((x)|META_MASK)
#define META1(x)    ((x)|META1_MASK)
#define META2(x)    ((x)|META2_MASK)
#define IS_META1(x) ((x)&META1_MASK)
#define IS_META2(x) ((x)&META2_MASK)
#define CNTRL(x) ((x) & 037)

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

#define MAX_NR_FUNC	256	/* max nr of strings assigned to keys */
#define MAX_DIACR	256
#define MAX_NR_KEYMAPS	256
#define NR_KEYS		128

struct kbdiacr
{
	unsigned char diacr, base, result;
};

typedef enum
{
	ScanNone = 0,
	ScanIoctl,
	ScanTerminal,
}
ScanMode;
extern ScanMode scr_scan_mode;

extern char *func_table[MAX_NR_FUNC];
extern unsigned int keymap_count;
extern unsigned short *key_maps[MAX_NR_KEYMAPS];
extern unsigned short plain_map[NR_KEYS];
extern struct kbdiacr accent_table[MAX_DIACR];
extern unsigned int accent_table_size;

/* shift state counters.. */
static unsigned char k_down[NR_SHIFT] =
{0,};

/* keyboard key bitmap */
static unsigned long key_down[256 / BITS_PER_LONG] =
{
	0,
};

static void compute_shiftstate(void);

static int chg_bit(int bit, void *addr);
static int test_bit(int bit, void *addr);
static int test_and_set_bit(int bit, void *addr);
static int test_and_clear_bit(int bit, void *addr);

static long shift_state = 0;
static long lockstate = 0;
static long slockstate = 0;
static int capslock_state = 0;
static int insert_state = 0;
int scan_numlock_state = 0;

/*static int meta_state = 0; */
static int applic_mode = 0;

static int dead_key_next = 0;
static int diacr = 0;
static int npadch = -1;		/* -1 or number assembled on pad */
static int rep = 0;

static int kbd_translate(unsigned char scancode, unsigned char *keycode);
static char kbd_unexpected_up(unsigned char keycode);
static void put_queue(long key);
static void put_fqueue(long key);
static void put_aqueue(long key);
static void put_acqueue(long key);
static void puts_queue(char *str);
static long get_queue(void);
static unsigned char handle_diacr(unsigned char);
static void to_utf8(unsigned short c);
static void applkey(int key, char mode);
static void set_console(int no, int diff);

static void set_kbd_led(void);

typedef void (*k_hand) (unsigned char value, char up_flag);
typedef void (k_handfn) (unsigned char value, char up_flag);

static k_handfn
 do_self, do_fn, do_spec, do_pad, do_dead, do_cons, do_cur, do_shift, do_meta, do_ascii, do_lock, do_lowercase, do_slock,
 do_dead2, do_ignore;

static k_hand key_handler[16] =
{
	do_self, do_fn, do_spec, do_pad, do_dead, do_cons, do_cur, do_shift,
	do_meta, do_ascii, do_lock, do_lowercase, do_slock, do_dead2,
	do_ignore, do_ignore
};

#ifdef DBG
static char *key_handler_names[16] =
{
	"do_self", "do_fn", "do_spec", "do_pad",
	"do_dead", "do_cons", "do_cur", "do_shift",
	"do_meta", "do_ascii", "do_lock", "do_lowercase",
	"do_slock", "do_dead2", "do_ignore", "do_ignore"
};

#endif

typedef void (*void_fnp) (void);
typedef void (void_fn) (void);

static void_fn do_null, enter, show_ptregs, send_intr, lastcons, caps_toggle, num, hold, scroll_forw, scroll_back, boot_it,
 caps_on, compose, SAK, decr_console, incr_console, spawn_console, bare_num, show_mem, show_state;

static void_fnp spec_fn_table[] =
{
	do_null, enter, show_ptregs, show_mem,
	show_state, send_intr, lastcons, caps_toggle,
	num, hold, scroll_forw, scroll_back,
	boot_it, caps_on, compose, SAK,
	decr_console, incr_console, spawn_console, bare_num
};

#ifdef DBG
static char *spec_fn_names[] =
{
	"do_null", "enter", "show_ptregs", "show_mem",
	"show_state", "send_intr", "lastcons", "caps_toggle",
	"num", "hold", "scroll_forw", "scroll_back",
	"boot_it", "caps_on", "compose", "SAK",
	"decr_console", "incr_console", "spawn_console", "bare_num"
};

#endif

/* maximum values each key_handler can handle */
static const int max_vals[] =
{
	255, SIZE(func_table) - 1, SIZE(spec_fn_table) - 1, NR_PAD - 1,
	NR_DEAD - 1, 255, 3, NR_SHIFT - 1,
	255, NR_ASCII - 1, NR_LOCK - 1, 255,
	NR_LOCK - 1, 255
};

const int NR_TYPES = SIZE(max_vals);

static long *queue_beg = 0, *queue_end = 0, *queue_max = 0;

static void
put_fqueue(long key)
{
	int r = shift_state;

	if (r & ( (1<<KG_ALT) | (1<<KG_ALTGR)) )
		key = META1(key);
	else if (r & ( (1<<KG_CTRL) | (1<<KG_CTRLL) | (1<<KG_CTRLR)))
		key = META2(key);
	else if (r & ( (1<<KG_SHIFT) | (1<<KG_SHIFTL) | (1<<KG_SHIFTR)))
		key = META1(META2(key));

	put_queue(key);
}

static void
put_aqueue(long key)
{
	int r = shift_state;

	if (r & ( (1<<KG_ALT) | (1<<KG_ALTGR)) )
		key = META1(key);

	put_queue(key);
}

static void
put_acqueue(long key)
{
	int r = shift_state;

	if (r & ( (1<<KG_ALT) | (1<<KG_ALTGR)) )
		key = META1(key);
	else if (r & ( (1<<KG_CTRL) | (1<<KG_CTRLL) | (1<<KG_CTRLR)))
		key = META2(key);

	put_queue(key);
}


static void
put_queue(long key)
{
	if (queue_end == queue_max)
	{
		int l = queue_max - queue_beg;
		int p = queue_end - queue_beg;

		l = l * 2;
		if (l < 16)
			l = 16;
		queue_beg = (long *) realloc(queue_beg, l * sizeof(long));

		queue_end = queue_beg + p;
		queue_max = queue_beg + l;
	}
	*queue_end = key;
	queue_end++;
}

static void
puts_queue(char *str)
{
	unsigned char *b = (unsigned char *) str;

	for (; *b; b++)
		put_queue(*b);

}

static long
get_queue(void)
{
	long r;

	if (!queue_beg)
		return 0;
	if (queue_end == queue_beg)
		return 0;
	r = *queue_beg;
	queue_end--;
	if (queue_beg != queue_end)
		memmove(queue_beg, queue_beg + 1, (queue_end - queue_beg) * sizeof(*queue_beg));
	return r;
}

unsigned int
scan_state(void)
{
	int r = shift_state;

	if (capslock_state)
		r |= ( 1 << SCAN_CAPSLOCK );
	if (scan_numlock_state)
		r |= ( 1 << SCAN_NUMLOCK );
	if (insert_state)
		r |= ( 1 << SCAN_INSERT );
	if (slockstate)
		r |= ( 1 << SCAN_SLOCK );
	if (lockstate)
		r |= ( 1 << SCAN_NATKBD );

#ifdef DBG
	printf("compute scan_state=%d\r\n", r);
#endif
	return r;
}
unsigned int
set_scan_state(int value,int locktype)
{
	int r = -1 ;

	switch (locktype)
	{
		case 1:
			r = scan_numlock_state;
			if (value >=0 )
				scan_numlock_state = value;
			break;
		case 2:
			r = capslock_state;
			if (value >=0 )
				capslock_state = value;
			break;
		case 3:
			r = slockstate;
			if (value >=0 )
				slockstate = value;
			break;
		case 4:
			r = insert_state;
			if (value >=0 )
				insert_state = value;
			break;
	}

#ifdef DBG
	printf("set scan_state=%d,%d\r\n", value,locktype);
#endif
	return r;
}

long
scan_check(void)
{
	long value = get_queue();
#ifdef DBG2
	printf("scan_check: %d\r\n", value);
#endif
	return value;
}

long
scan_key(unsigned char scancode)
{
	scan_push(scancode);
	return get_queue();
}

static int first_key = 0;

void
scan_reset(void)
{
	first_key = 0;
}

int
scan_push(unsigned char scancode)
{
	unsigned char keycode;
	unsigned char raw_mode = 1;
	int down = !(scancode & 0x80);
	unsigned char up_flag = down ? 0 : 0200;
	unsigned short keysym;
	u_char type;
	int shift_final,shift_local=0;
	unsigned short *key_map;

	if (!first_key)
	{
		first_key = 1;
		if (scancode & 0x80)
			return 0;
	}

#ifdef DBG0
	printf("scan_push: %d\r\n", scancode);
#endif
	/*
	 *  Convert scancode to keycode
	 */
	if (!kbd_translate(scancode, &keycode))
		return 1;

#ifdef DBG0
	printf("translated: down=%d, keycode=%x\r\n", down, keycode);
#endif

	/*
	 * At this point the variable `keycode' contains the keycode.
	 * Note: the keycode must not be 0 (++Geert: on m68k 0 is valid).
	 * We keep track of the up/down status of the key, and
	 * return the keycode if in MEDIUMRAW mode.
	 */

	if (up_flag)
	{
		if (!test_and_clear_bit(keycode, key_down))
		{
			rep = 0;
			up_flag = kbd_unexpected_up(keycode);
		}
	}
	else
		rep = test_and_set_bit(keycode, key_down);

#ifdef DBG1
	printf("up_flag=%d, rep=%d, shift_state=%d\r\n", up_flag, rep, shift_state);
#endif

	/*if (rep)
		return;*/

	/* the XOR below used to be an OR */
	shift_final = shift_state ^ lockstate ^ slockstate;
	shift_local=(shift_final & (1 << KG_SHIFTL) ) | (shift_final & (1 << KG_SHIFTR) );
	key_map = key_maps[shift_final];
	if (shift_local==0 )
		shift_local= (1 << KG_SHIFT);
	if (key_map == NULL)
	{
		shift_final = shift_state ^ lockstate ^ slockstate;
		shift_final = shift_final ^ shift_local;
		shift_local = 0;
		key_map = key_maps[shift_final];
	}
	if (key_map != NULL)
	{
		keysym = key_map[keycode];
		type = KTYP(keysym);
#ifdef DBG2
	printf("\ntype=%x,shift_state=%d,shift_final=%d,keykode=%d,shift_local=%d\r\n",type,shift_state,shift_final,keycode, shift_local);
#endif

		if (type >= 0xf0)
		{
			type -= 0xf0;
			if (type == KT_LETTER)
			{
				type = KT_LATIN;
				if (capslock_state)
				{
					shift_final = shift_final ^ shift_local;
					key_map = key_maps[shift_final];
					//key_map = key_maps[shift_final ^ (1 << KG_SHIFT)];
					if (key_map)
						keysym = key_map[keycode];
#ifdef DBG2
	printf("  caps=%d,keykode=%d,keysym=%d,kg_shift=%d\r\n",shift_final,keycode, keysym, KG_SHIFT );
#endif
				}
			}
#ifdef DBG
			printf("key_handler[%d] call: %s, keysym=0x%x, up_flag=0x%x\r\n", type, key_handler_names[type],
			       keysym & 0xff, up_flag);
#endif
		/*
		printf("\nA keysym=%d,type=%d,%d",keysym,type,KT_SHIFT);
		*/
			(*key_handler[type]) (keysym & 0xff, up_flag);
			if (type != KT_SLOCK)
				slockstate = 0;
		}
		else
		{
			/* maybe only if (kbd->kbdmode == VC_UNICODE) ? */
			if (!up_flag && !raw_mode)
				to_utf8(keysym);
		}
	}
	else
	{
		/* maybe beep? */
		/* we have at least to update shift_state */
		key_map = key_maps[0];
		keysym = key_map[keycode];
		type = KTYP(keysym);
		/*
		printf("\nB keysym=%d,type=%d,%d",keysym,type,KT_SHIFT);
		*/
		/*check CTRL,SHIFT,ALT keys status */
		if (keysym>=63234 && keysym<=63237)
			(*key_handler[KT_SHIFT]) (keysym & 0xff, up_flag);
		else
			compute_shiftstate();
	}
	return 1;
}

/*
 * Translation of escaped scancodes to keycodes.
 * This is now user-settable.
 * The keycodes 1-88,96-111,119 are fairly standard, and
 * should probably not be changed - changing might confuse X.
 * X also interprets scancode 0x5d (KEY_Begin).
 *
 * For 1-88 keycode equals scancode.
 */

#define E0_KPENTER 96
#define E0_RCTRL   97
#define E0_KPSLASH 98
#define E0_PRSCR   99
#define E0_RALT    100
#define E0_BREAK   101		/* (control-pause) */
#define E0_HOME    102
#define E0_UP      103
#define E0_PGUP    104
#define E0_LEFT    105
#define E0_RIGHT   106
#define E0_END     107
#define E0_DOWN    108
#define E0_PGDN    109
#define E0_INS     110
#define E0_DEL     111

#define E1_PAUSE   119

/*
 * The keycodes below are randomly located in 89-95,112-118,120-127.
 * They could be thrown away (and all occurrences below replaced by 0),
 * but that would force many users to use the `setkeycodes' utility, where
 * they needed not before. It does not matter that there are duplicates, as
 * long as no duplication occurs for any single keyboard.
 */
#define SC_LIM 89

#define FOCUS_PF1 85		/* actual code! */
#define FOCUS_PF2 89
#define FOCUS_PF3 90
#define FOCUS_PF4 91
#define FOCUS_PF5 92
#define FOCUS_PF6 93
#define FOCUS_PF7 94
#define FOCUS_PF8 95
#define FOCUS_PF9 120
#define FOCUS_PF10 121
#define FOCUS_PF11 122
#define FOCUS_PF12 123

#define JAP_86     124
/* tfj@olivia.ping.dk:
 * The four keys are located over the numeric keypad, and are
 * labelled A1-A4. It's an rc930 keyboard, from
 * Regnecentralen/RC International, Now ICL.
 * Scancodes: 59, 5a, 5b, 5c.
 */
#define RGN1 124
#define RGN2 125
#define RGN3 126
#define RGN4 127

/* BTC */
#define E0_MACRO   112
/* LK450 */
#define E0_F13     113
#define E0_F14     114
#define E0_HELP    115
#define E0_DO      116
#define E0_F17     117
#define E0_KPMINPLUS 118
/*
 * My OmniKey generates e0 4c for  the "OMNI" key and the
 * right alt key does nada. [kkoller@nyx10.cs.du.edu]
 */
#define E0_OK	124
/*
 * New microsoft keyboard is rumoured to have
 * e0 5b (left window button), e0 5c (right window button),
 * e0 5d (menu button). [or: LBANNER, RBANNER, RMENU]
 * [or: Windows_L, Windows_R, TaskMan]
 */
#define E0_MSLW	125
#define E0_MSRW	126
#define E0_MSTM	127

static unsigned char high_keys[128 - SC_LIM] =
{
	RGN1, RGN2, RGN3, RGN4, 0, 0, 0,	/* 0x59-0x5f */
	0, 0, 0, 0, 0, 0, 0, 0,	/* 0x60-0x67 */
	0, 0, 0, 0, 0, FOCUS_PF11, 0, FOCUS_PF12,	/* 0x68-0x6f */
	0, 0, 0, FOCUS_PF2, FOCUS_PF9, 0, 0, FOCUS_PF3,		/* 0x70-0x77 */
	FOCUS_PF4, FOCUS_PF5, FOCUS_PF6, FOCUS_PF7,	/* 0x78-0x7b */
	FOCUS_PF8, JAP_86, FOCUS_PF10, 0	/* 0x7c-0x7f */
};

static unsigned char e0_keys[128] =
{
	0, 0, 0, 0, 0, 0, 0, 0,	/* 0x00-0x07 */
	0, 0, 0, 0, 0, 0, 0, 0,	/* 0x08-0x0f */
	0, 0, 0, 0, 0, 0, 0, 0,	/* 0x10-0x17 */
	0, 0, 0, 0, E0_KPENTER, E0_RCTRL, 0, 0,		/* 0x18-0x1f */
	0, 0, 0, 0, 0, 0, 0, 0,	/* 0x20-0x27 */
	0, 0, 0, 0, 0, 0, 0, 0,	/* 0x28-0x2f */
	0, 0, 0, 0, 0, E0_KPSLASH, 0, E0_PRSCR,		/* 0x30-0x37 */
	E0_RALT, 0, 0, 0, 0, E0_F13, E0_F14, E0_HELP,	/* 0x38-0x3f */
	E0_DO, E0_F17, 0, 0, 0, 0, E0_BREAK, E0_HOME,	/* 0x40-0x47 */
	E0_UP, E0_PGUP, 0, E0_LEFT, E0_OK, E0_RIGHT, E0_KPMINPLUS, E0_END,	/* 0x48-0x4f */
	E0_DOWN, E0_PGDN, E0_INS, E0_DEL, 0, 0, 0, 0,	/* 0x50-0x57 */
	0, 0, 0, E0_MSLW, E0_MSRW, E0_MSTM, 0, 0,	/* 0x58-0x5f */
	0, 0, 0, 0, 0, 0, 0, 0,	/* 0x60-0x67 */
	0, 0, 0, 0, 0, 0, 0, E0_MACRO,	/* 0x68-0x6f */
	0, 0, 0, 0, 0, 0, 0, 0,	/* 0x70-0x77 */
	0, 0, 0, 0, 0, 0, 0, 0	/* 0x78-0x7f */
};

static int
kbd_translate(unsigned char scancode, unsigned char *keycode)
{
	static int prev_scancode = 0;

	/* special prefix scancodes.. */
	if (scancode == 0xe0 || scancode == 0xe1)
	{
		prev_scancode = scancode;
#ifdef DBG0
	printf("kbd_translate1: return 0: scan=%d prev=%d\r\n", scancode, prev_scancode);
#endif

		return 0;
	}

	/* 0xFF is sent by a few keyboards, ignore it. 0x00 is error */
	if (scancode == 0x00 || scancode == 0xff)
	{
		prev_scancode = 0;

		return 0;
	}

	scancode &= 0x7f;

	if (prev_scancode)
	{
		/*
		 * usually it will be 0xe0, but a Pause key generates
		 * e1 1d 45 e1 9d c5 when pressed, and nothing when released
		 */
		if (prev_scancode != 0xe0)
		{
			if (prev_scancode == 0xe1 && scancode == 0x1d)
			{
				prev_scancode = 0x100;
				return 0;
			}
			else if (prev_scancode == 0x100 && scancode == 0x45)
			{
				*keycode = E1_PAUSE;
				prev_scancode = 0;
			}
			else
			{
				prev_scancode = 0;
				return 0;
			}
		}
		else
		{
			prev_scancode = 0;
			/*
			 *  The keyboard maintains its own internal caps lock and
			 *  num lock statuses. In caps lock mode E0 AA precedes make
			 *  code and E0 2A follows break code. In num lock mode,
			 *  E0 2A precedes make code and E0 AA follows break code.
			 *  We do our own book-keeping, so we will just ignore these.
			 */
			/*
			 *  For my keyboard there is no caps lock mode, but there are
			 *  both Shift-L and Shift-R modes. The former mode generates
			 *  E0 2A / E0 AA pairs, the latter E0 B6 / E0 36 pairs.
			 *  So, we should also ignore the latter. - aeb@cwi.nl
			 */
			if (scancode == 0x2a || scancode == 0x36)
				return 0;

			if (e0_keys[scancode])
				*keycode = e0_keys[scancode];
			else
			{
				return 0;
			}
		}
	}
	else if (scancode >= SC_LIM)
	{
		/* This happens with the FOCUS 9000 keyboard
		   Its keys PF1..PF12 are reported to generate
		   55 73 77 78 79 7a 7b 7c 74 7e 6d 6f
		   Moreover, unless repeated, they do not generate
		   key-down events, so we have to zero up_flag below */
		/* Also, Japanese 86/106 keyboards are reported to
		   generate 0x73 and 0x7d for \ - and \ | respectively. */
		/* Also, some Brazilian keyboard is reported to produce
		   0x73 and 0x7e for \ ? and KP-dot, respectively. */

		*keycode = high_keys[scancode - SC_LIM];

		if (!*keycode)
		{
			return 0;
		}
	}
	else
		*keycode = scancode;
	return 1;
}

static int
test_bit(int bit, void *addr)
{
	int b = bit % BITS_PER_LONG;
	unsigned long *wp = ((unsigned long *) addr) + bit / BITS_PER_LONG;

	return *wp & (1 << b);
}

static int
test_and_set_bit(int bit, void *addr)
{
	int b = bit % BITS_PER_LONG;
	unsigned long *wp = ((unsigned long *) addr) + bit / BITS_PER_LONG;
	int r = *wp & (1 << b);

	*wp |= (1 << b);
	return r;
}

static int
chg_bit(int bit, void *addr)
{
	int b = bit % BITS_PER_LONG;
	unsigned long *wp = ((unsigned long *) addr) + bit / BITS_PER_LONG;
	int r = *wp & (1 << b);

	if (r)
		*wp &= ~(1 << b);
	else
		*wp |= (1 << b);

	return !r;
}

static int
test_and_clear_bit(int bit, void *addr)
{
	int b = bit % BITS_PER_LONG;
	unsigned long *wp = ((unsigned long *) addr) + bit / BITS_PER_LONG;
	int r = *wp & (1 << b);

	*wp &= ~(1 << b);
	return r;
}

static char
kbd_unexpected_up(unsigned char keycode)
{
	/* unexpected, but this can happen: maybe this was a key release for a
	   FOCUS 9000 PF key; if we want to see it, we have to clear up_flag */
	if (keycode >= SC_LIM || keycode == 85)
		return 0;
	else
		return 0200;
}

/* called after returning from RAW mode or when changing consoles -
   recompute k_down[] and shift_state from key_down[] */
/* maybe called when keymap is undefined, so that shiftkey release is seen */
static void
compute_shiftstate(void)
{
	int i, j, k, sym, val;

	shift_state = 0;
	for (i = 0; i < SIZE(k_down); i++)
		k_down[i] = 0;

	for (i = 0; i < SIZE(key_down); i++)
		if (key_down[i])
		{		/* skip this word if not a single bit on */
			k = i * BITS_PER_LONG;
			for (j = 0; j < BITS_PER_LONG; j++, k++)
				if (test_bit(k, key_down))
				{
					sym = plain_map[k];
					if (KTYP(sym) == KT_SHIFT)
					{
						val = KVAL(sym);
						if (val == KVAL(K_CAPSSHIFT))
							val = KVAL(K_SHIFT);
						k_down[val]++;
						shift_state |= (1 << val);
					}
				}
		}
#ifdef DBG2
	printf("compute shift_state=%ld\r\n", shift_state );
#endif
}

static void
do_self(unsigned char value, char up_flag)
{
#ifdef DBG2
	printf("do_self: %d\r\n", value);
#endif

	//printf("\nr=%d\n",r);

	if (up_flag)
		return;		/* no action, if this is a key release */

	if  (shift_state & ( (1<<KG_ALT) | (1<<KG_ALTGR)) )
	{
		switch (value)
		{
		case '/':
			break;
		case '[':
		case ']':
		case ';':
		case '\'':
		case ',':
		case '.':
			break;
		case '-':
			value = '_';
			break;
		case '=':
		case '\\':
			break;
		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			break;
		default:
			goto norm;
		}
		do_meta(value, up_flag);
		return;
	}
norm:
	if (diacr)
		value = handle_diacr(value);

	if (dead_key_next)
	{
		dead_key_next = 0;
		diacr = value;
		return;
	}

	switch (value)
	{
	case 0x7f:
	case '2':
		put_acqueue(value);
		break;
	case 0x9:
		put_fqueue(value);
		break;
	default:
		put_queue(value);
		break;
	}
}

/*
 * We have a combining character DIACR here, followed by the character CH.
 * If the combination occurs in the table, return the corresponding value.
 * Otherwise, if CH is a space or equals DIACR, return DIACR.
 * Otherwise, conclude that DIACR was not combining after all,
 * queue it and return CH.
 */
static unsigned char
handle_diacr(unsigned char ch)
{
	int d = diacr;
	int i;

	diacr = 0;

	for (i = 0; i < accent_table_size; i++)
	{
		if (accent_table[i].diacr == d && accent_table[i].base == ch)
			return accent_table[i].result;
	}

	if (ch == ' ' || ch == d)
		return d;

	put_queue(d);
	return ch;
}

/*
 * Many other routines do put_queue, but I think either
 * they produce ASCII, or they produce some user-assigned
 * string, and in both cases we might assume that it is
 * in utf-8 already.
 */
static void
to_utf8(unsigned short c)
{
	if (c < 0x80)
		put_queue(c);	/*  0*******  */
	else if (c < 0x800)
	{
		put_queue(0xc0 | (c >> 6));	/*  110***** 10******  */
		put_queue(0x80 | (c & 0x3f));
	}
	else
	{
		put_queue(0xe0 | (c >> 12));	/*  1110**** 10****** 10******  */
		put_queue(0x80 | ((c >> 6) & 0x3f));
		put_queue(0x80 | (c & 0x3f));
	}
	/* UTF-8 is defined for words of up to 31 bits,
	   but we need only 16 bits here */
}

static void
do_fn(unsigned char value, char up_flag)
{
#ifdef DBG2
	printf("do_fn: %d\r\n", value);
#endif

	if (value < SIZE(func_table))
	{
#if 1
		if ( K(KT_FN, value) == K_INSERT )
			insert_state = !up_flag;

		if (up_flag)
			return;


		switch (K(KT_FN, value))
		{
		case K_PGDN:
			put_acqueue(KEY_PGDN);
			break;
		case K_PGUP:
			put_acqueue(KEY_PGUP);
			break;
		case K_INSERT:
			put_acqueue(KEY_INS);
			break;
		case K_REMOVE:
			put_acqueue(KEY_DEL);
			break;
		case K_FIND:
			put_acqueue(KEY_HOME);
			break;
		case K_SELECT:
			put_acqueue(KEY_END);
			break;
		case K_F1:
			put_fqueue(KEY_F1);
			break;
		case K_F2:
			put_fqueue(KEY_F2);
			break;
		case K_F3:
			put_fqueue(KEY_F3);
			break;
		case K_F4:
			put_fqueue(KEY_F4);
			break;
		case K_F5:
			put_fqueue(KEY_F5);
			break;
		case K_F6:
			put_fqueue(KEY_F6);
			break;
		case K_F7:
			put_fqueue(KEY_F7);
			break;
		case K_F8:
			put_fqueue(KEY_F8);
			break;
		case K_F9:
			put_fqueue(KEY_F9);
			break;
		case K_F10:
			put_fqueue(KEY_F10);
			break;
		case K_F11:
			put_fqueue(KEY_F11);
			break;
		case K_F12:
			put_fqueue(KEY_F12);
			break;
		}
#else
		if (func_table[value])
			puts_queue(func_table[value]);
#endif
	}
}

static void
do_spec(unsigned char value, char up_flag)
{
#ifdef DBG2
	printf("do_spec: %d\r\n", value);
#endif

	if (up_flag)
		return;
	if (value >= SIZE(spec_fn_table))
		return;
#ifdef DBG
	printf("spec_fn call(%d): %s\r\n", value, spec_fn_names[value]);
#endif
	spec_fn_table[value] ();
}

static void
applkey(int key, char mode)
{
	static char buf[] =
	{0x1b, 'O', 0x00, 0x00};

	buf[1] = (mode ? 'O' : '[');
	buf[2] = key;
	puts_queue(buf);
}

static void
do_pad(unsigned char value, char up_flag)
{
	static const char pad_chars[] = "0123456789+-*/\015,.?()";
	/*static const char app_map[] = "pqrstuvwxylSRQMnnmPQ";*/

#ifdef DBG2
	printf("do_pad: %d\r\n", value);
#endif

	if (up_flag)
		return;		/* no action, if this is a key release */

#if 0
	/* kludge... shift forces cursor/number keys */
	if ( /*vc_kbd_mode(kbd,VC_APPLIC) */ applic_mode && !k_down[KG_SHIFT])
	{
		if (value<sizeof(app_map))
			applkey(app_map[value], 1);
		return;
	}
#endif

	switch (value)
	{
	case KVAL(K_PPLUS):
		put_acqueue('+');
		return;
	case KVAL(K_PMINUS):
		put_acqueue('-');
		return;
	case KVAL(K_PSLASH):
		put_acqueue('/');
		return;
	case KVAL(K_PSTAR):
		put_acqueue('*');
		return;
	}


	if ((!scan_numlock_state /*vc_kbd_led(kbd,VC_NUMLOCK) */
		&& !(shift_state & ( (1<<KG_SHIFT) | (1<<KG_SHIFTL) | (1<<KG_SHIFTR))))
	    || (scan_numlock_state && (shift_state & ( (1<<KG_CTRL) | (1<<KG_CTRLL) | (1<<KG_CTRLR))))
	   )
	{
		switch (value)
		{
		case KVAL(K_PCOMMA):
		case KVAL(K_PDOT):
			do_fn(KVAL(K_REMOVE), 0);
			return;
		case KVAL(K_P0):
			do_fn(KVAL(K_INSERT), 0);
			return;
		case KVAL(K_P1):
			do_fn(KVAL(K_SELECT), 0);
			return;
		case KVAL(K_P2):
			do_cur(KVAL(K_DOWN), 0);
			return;
		case KVAL(K_P3):
			do_fn(KVAL(K_PGDN), 0);
			return;
		case KVAL(K_P4):
			do_cur(KVAL(K_LEFT), 0);
			return;
		case KVAL(K_P6):
			do_cur(KVAL(K_RIGHT), 0);
			return;
		case KVAL(K_P7):
			do_fn(KVAL(K_FIND), 0);
			return;
		case KVAL(K_P8):
			do_cur(KVAL(K_UP), 0);
			return;
		case KVAL(K_P9):
			do_fn(KVAL(K_PGUP), 0);
			return;
		case KVAL(K_P5):
			applkey('G', /*vc_kbd_mode(kbd, VC_APPLIC) */ applic_mode);
			return;
		}
	}

	if (value<sizeof(pad_chars))
		/*put_fqueue(pad_chars[value]);*/
		put_queue(pad_chars[value]);
#if 0
	if (value == KVAL(K_PENTER) && vc_kbd_mode(kbd, VC_CRLF))
		put_queue(10);
#endif
}

static void
do_cur(unsigned char value, char up_flag)
{
#if 1
#ifdef DBG2
	printf("do_cur: %d\r\n", value);
#endif
	if (up_flag)
		return;

	switch (K(KT_CUR, value))
	{
	case K_DOWN:
		put_acqueue(KEY_DOWN);
		break;
	case K_LEFT:
		put_acqueue(KEY_LEFT);
		break;
	case K_RIGHT:
		put_acqueue(KEY_RIGHT);
		break;
	case K_UP:
		put_acqueue(KEY_UP);
		break;
	}
#else
	static const char *cur_chars = "BDCA";

	if (up_flag)
		return;

	applkey(cur_chars[value], /*vc_kbd_mode(kbd,VC_CKMODE) */ 0);
#endif
}

#define A_GRAVE  '`'
#define A_ACUTE  '\''
#define A_CFLEX  '^'
#define A_TILDE  '~'
#define A_DIAER  '"'
#define A_CEDIL  ','
static unsigned char ret_diacr[NR_DEAD] =
{A_GRAVE, A_ACUTE, A_CFLEX, A_TILDE, A_DIAER, A_CEDIL};

/* Obsolete - for backwards compatibility only */
static void
do_dead(unsigned char value, char up_flag)
{
	value = ret_diacr[value];
	do_dead2(value, up_flag);
}

/*
 * Handle dead key. Note that we now may have several
 * dead keys modifying the same character. Very useful
 * for Vietnamese.
 */
static void
do_dead2(unsigned char value, char up_flag)
{
	if (up_flag)
		return;

	diacr = (diacr ? handle_diacr(value) : value);
}

static void
do_cons(unsigned char value, char up_flag)
{
	if (up_flag)
		return;
	set_console(value, 0);
}

static void
set_console(int no, int diff)
{
	if (scr_scan_mode == ScanIoctl)
	{
#ifdef OS_MINGW
		char *tty = NULL;
#else
		char *tty = ttyname(0);
#endif
		int l;
		if (!tty)
			return;
		l = strlen(tty);
		if (l<8)
			return;
		if (!isdigit(tty[8]))
			return;
		if (diff)
			no = atoi(tty+8) - 1 + no;
#ifdef OS_LINUX
		ioctl(0, 0x5606 /*VT_ACTIVATE*/, no + 1);
#endif
	}
}

static void
do_shift(unsigned char value, char up_flag)
{
	int old_state = shift_state;
#ifdef DBG2
	printf("do_shift: %d\r\n", value);
#endif

	if (rep && !up_flag)
		return;

	/* Mimic typewriter:
	   a CapsShift key acts like Shift but undoes CapsLock */
	if (value == KVAL(K_CAPSSHIFT))
	{
		value = KVAL(K_SHIFT);
		if (!up_flag)
			capslock_state = 0;
		set_kbd_led();
		/*clr_vc_kbd_led(kbd, VC_CAPSLOCK); */
	}

	if (up_flag)
	{
		/* handle the case that two shift or control
		   keys are depressed simultaneously */
		if (k_down[value])
			k_down[value]--;
	}
	else
		k_down[value]++;

	if (k_down[value])
		shift_state |= (1 << value);
	else
		shift_state &= ~(1 << value);

	/* kludge */
	if (up_flag && shift_state != old_state && npadch != -1)
	{
		put_queue(npadch & 0xff);
		npadch = -1;
	}
#ifdef DBG2
	printf("do shift=%ld\r\n", shift_state );
#endif
}

static void
do_meta(unsigned char value, char up_flag)
{
	if (up_flag)
		return;

#if 1
#ifdef DBG2
	printf("do_meta: %d\r\n", value);
#endif
	put_aqueue(value);
#else
	if ( /*vc_kbd_mode(kbd, VC_META) */ meta_state)
	{
		put_queue('\033');
		put_queue(value);
	}
	else
		put_queue(value | 0x80);
#endif
}

static void
do_ascii(unsigned char value, char up_flag)
{
	int base;
#ifdef DBG2
	printf("do_acii: %d\r\n", value);
#endif

	if (up_flag)
		return;

	if (value < 10)		/* decimal input of code, while Alt depressed */
		base = 10;
	else
	{			/* hexadecimal input of code, while AltGr depressed */
		value -= 10;
		base = 16;
	}

	if (npadch == -1)
		npadch = value;
	else
		npadch = npadch * base + value;
}

static void
do_lock(unsigned char value, char up_flag)
{
	if (up_flag || rep)
		return;
	if (value < BITS_PER_LONG)
		chg_bit(value, &lockstate);
	/*chg_vc_kbd_lock(kbd, value); */
}

static void
do_slock(unsigned char value, char up_flag)
{
	//printf("\nA up_flag=%d,rep=%d,state=%ld",up_flag,rep,slockstate);
	if (up_flag || rep)
		return;
	if (value < BITS_PER_LONG)
		chg_bit(value, &slockstate);
	//chg_vc_kbd_slock(kbd, value);
	//printf("B up_flag=%d,rep=%d,state=%ld\n",up_flag,rep,slockstate);
}

static void
do_lowercase(unsigned char value, char up_flag)
{
}

static void
do_ignore(unsigned char value, char up_flag)
{
}

static void
do_null()
{
	compute_shiftstate();
}

static void
enter(void)
{
	if (diacr)
	{
		put_queue(diacr);
		diacr = 0;
	}
	put_queue(13);
#if 0
	if (vc_kbd_mode(kbd, VC_CRLF))
		put_queue(10);
#endif
}

static void
show_ptregs(void)
{
}

static void
show_mem(void)
{
}

static void
show_state(void)
{
}

static void
send_intr(void)
{
}

static void
hold(void)
{
	if (rep)
		return;

	/*
	 * Note: SCROLLOCK will be set (cleared) by stop_tty (start_tty);
	 * these routines are also activated by ^S/^Q.
	 * (And SCROLLOCK can also be set by the ioctl KDSKBLED.)
	 */
#if 0
	if (tty->stopped)
		start_tty(tty);
	else
		stop_tty(tty);
#endif
}

static void
num(void)
{
	if ( /*vc_kbd_mode(kbd,VC_APPLIC) */ applic_mode)
		applkey('P', 1);
	else
		bare_num();
}

/*
 * Bind this to Shift-NumLock if you work in application keypad mode
 * but want to be able to change the NumLock flag.
 * Bind this to NumLock if you prefer that the NumLock key always
 * changes the NumLock flag.
 */
static void
bare_num(void)
{
	if (!rep)
	{
		/*chg_vc_kbd_led(kbd,VC_NUMLOCK); */
		scan_numlock_state = !scan_numlock_state;
		set_kbd_led();
	}
}

static void
lastcons(void)
{
	set_console(-1, 0);
}

static void
decr_console(void)
{
	set_console(-1, 1);
}

static void
incr_console(void)
{
	set_console(1, 1);
}

static void
caps_toggle(void)
{
	if (rep)
		return;
	/*chg_vc_kbd_led(kbd, VC_CAPSLOCK); */
	capslock_state = !capslock_state;
	set_kbd_led();
}

static void
caps_on(void)
{
	if (rep)
		return;
	/*set_vc_kbd_led(kbd, VC_CAPSLOCK); */
	capslock_state = 1;
	set_kbd_led();
}

static void
scroll_forw(void)
{
}

static void
scroll_back(void)
{
}

static void
boot_it(void)
{
}

static void
compose(void)
{
	dead_key_next = 1;
}

static void
SAK(void)
{
	/*
	 * SAK should also work in all raw modes and reset
	 * them properly.
	 */
}

static void
spawn_console(void)
{
}


#ifdef OS_LINUX
#define KDGETLED	0x4B31	/* return current led state */
#define KDSETLED	0x4B32	/* set led state [lights, not flags] */
#define 	LED_SCR		0x01	/* scroll lock led */
#define 	LED_NUM		0x02	/* num lock led */
#define 	LED_CAP		0x04	/* caps lock led */
#endif

static void
set_kbd_led(void)
{
#ifdef OS_LINUX
	int leds = 0;

	if (scan_numlock_state)
		leds |= LED_NUM;
	if (capslock_state)
		leds |= LED_CAP;
	if (slockstate)
		leds |= LED_SCR;

	ioctl(0, KDSETLED, leds);
#endif

}

