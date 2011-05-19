
/*
   $Log$
   Revision 1.1  2006/06/22 19:35:31  itk
   uri: init sf.net repository

   Revision 1.8  2005/02/22 08:09:43  clip
   uri: small fix

   Revision 1.7  2004/05/21 11:22:19  clip
   rust: minor fix for 'configure -m'

   Revision 1.6  2003/09/02 14:27:43  clip
   changes for MINGW from
   Mauricio Abre <maurifull@datafull.com>
   paul

   Revision 1.5  2001/12/20 12:45:56  clip
   fix for OPENBSD

   Revision 1.4  2001/05/15 10:34:28  clip
   memdebug
   paul

   Revision 1.3  2000/12/02 12:46:57  clip
   scancodes
   paul

   Revision 1.2  1999/11/02 23:05:54  axl
   start of logging CVS

 */

#include <limits.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <ctype.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>

#include "../clip.h"

#ifdef unix
	#ifndef _WIN32
		#include <unistd.h>
		#define DELIM '/'
		#define DELIMSTR "/"
	#endif
#endif

#ifdef _WIN32
	#define DELIM '\\'
	#define DELIMSTR "\\"
#endif

#ifndef DELIMSTR

#define DELIM '/'
#define DELIMSTR "/"

#endif

#include "../clip.h"
#include "tcaps.h"

/* max length of termcap entry */
#define TBUFSIZE  2048
/* max number of tc= indirections */
#define MAXHOP   32

static char *tbuf;		/* terminal entry buffer */
static int hopcount;		/* detect infinite loops */
static int fnum;
static int match_count;
static char **fnames;
static char *errbuf;
static int errbuflen, errcode;

static int tgetent(char *, char *, int);
static int tnchktc(char *, int);
static int tnamatch(char *);
static int cmp_bucket(const void *p1, const void *p2);
static void err(char *fmt,...);
static void split_entry(Terminfo * info, char *entry);
static int tdecode(char *bp, Terminfo * info);
static int place_buf(Terminfo * info, int need);
static int read_info(Terminfo * info, char *path);

/* recognisible termcap names */
static const TermcapBucket termcapNames[] =
{
	{"@0", NO_kfnd, 'K'},	/* find  key */
	{"@1", NO_kbeg, 'K'},	/* begin  key */
	{"@2", NO_kcan, 'K'},	/* cancel  key */
	{"@3", NO_kclo, 'K'},	/* close  key */
	{"@4", NO_kcmd, 'K'},	/* command  key */
	{"@5", NO_kcpy, 'K'},	/* copy  key */
	{"@6", NO_kcrt, 'K'},	/* create  key */
	{"@7", NO_kend, 'K'},	/* end  key */
	{"@8", NO_kent, 'K'},	/* enter  key */
	{"@9", NO_kext, 'K'},	/* exit  key */
	{"AB", NO_setab, 'S'},	/* Set background color using ANSI escape */
	{"AF", NO_setaf, 'S'},	/* Set foreground color using ANSI escape */
	{"AL", NO_il, 'S'},	/* insert #1 lines (P*) */
	{"BT", NO_btns, 'N'},	/* number of buttons on mouse */
	{"C2", NO_C2, 'B'},	/* Cf set both fg and bg */
	{"CW", NO_cwin, 'S'},	/* define a window #1 from #2,#3 to #4,#5 */
	{"CY", NO_CY, 'B'},	/* Cyrillic extention enabled */
	{"Cb", NO_Cb, 'S'},	/* Cyrillic extention color background */
	{"Ce", NO_Cb, 'S'},	/* Cyrillic extention end */
	{"Cf", NO_Cf, 'S'},	/* Cyrillic extention color foreground */
	{"Co", NO_colors, 'N'},	/* maximum number of colors on screen */
	{"Cs", NO_Cb, 'S'},	/* Cyrillic extention start */
	{"Ct", NO_Ct, 'S'},	/* Cyrillic extention terminal translation filename */
	{"DC", NO_dch, 'S'},	/* delete #1 characters (P*) */
	{"DL", NO_dl, 'S'},	/* delete #1 lines (P*) */
	{"DO", NO_cud, 'S'},	/* down #1 lines (P*) */
	{"F1", NO_kf11, 'K'},	/*  F11 function key      */
	{"F2", NO_kf12, 'K'},	/*  F12 function key      */
	{"F3", NO_kf13, 'K'},	/*  F13 function key      */
	{"F4", NO_kf14, 'K'},	/*  F14 function key      */
	{"F5", NO_kf15, 'K'},	/*  F15 function key      */
	{"F6", NO_kf16, 'K'},	/*  F16 function key      */
	{"F7", NO_kf17, 'K'},	/*  F17 function key      */
	{"F8", NO_kf18, 'K'},	/*  F18 function key      */
	{"F9", NO_kf19, 'K'},	/*  F19 function key      */
	{"FA", NO_kf20, 'K'},	/*  F20 function key      */
	{"FB", NO_kf21, 'K'},	/*  F21 function key      */
	{"FC", NO_kf22, 'K'},	/*  F22 function key      */
	{"FD", NO_kf23, 'K'},	/*  F23 function key      */
	{"FE", NO_kf24, 'K'},	/*  F24 function key      */
	{"FF", NO_kf25, 'K'},	/*  F25 function key      */
	{"FG", NO_kf26, 'K'},	/*  F26 function key      */
	{"FH", NO_kf27, 'K'},	/*  F27 function key      */
	{"FI", NO_kf28, 'K'},	/*  F28 function key      */
	{"FJ", NO_kf29, 'K'},	/*  F29 function key      */
	{"FK", NO_kf30, 'K'},	/*  F30 function key      */
	{"FL", NO_kf31, 'K'},	/*  F31 function key      */
	{"FM", NO_kf32, 'K'},	/*  F32 function key      */
	{"FN", NO_kf33, 'K'},	/*  F33 function key      */
	{"FO", NO_kf34, 'K'},	/*  F34 function key      */
	{"FP", NO_kf35, 'K'},	/*  F35 function key      */
	{"FQ", NO_kf36, 'K'},	/*  F36 function key      */
	{"FR", NO_kf37, 'K'},	/*  F37 function key      */
	{"FS", NO_kf38, 'K'},	/*  F38 function key      */
	{"FT", NO_kf39, 'K'},	/*  F39 function key      */
	{"FU", NO_kf40, 'K'},	/*  F40 function key      */
	{"FV", NO_kf41, 'K'},	/*  F41 function key      */
	{"FW", NO_kf42, 'K'},	/*  F42 function key      */
	{"FX", NO_kf43, 'K'},	/*  F43 function key      */
	{"FY", NO_kf44, 'K'},	/*  F44 function key      */
	{"FZ", NO_kf45, 'K'},	/*  F45 function key      */
	{"Fa", NO_kf46, 'K'},	/*  F46 function key      */
	{"Fb", NO_kf47, 'K'},	/*  F47 function key      */
	{"Fc", NO_kf48, 'K'},	/*  F48 function key      */
	{"Fd", NO_kf49, 'K'},	/*  F49 function key      */
	{"Fe", NO_kf50, 'K'},	/*  F50 function key      */
	{"Ff", NO_kf51, 'K'},	/*  F51 function key      */
	{"Fg", NO_kf52, 'K'},	/*  F52 function key      */
	{"Fh", NO_kf53, 'K'},	/*  F53 function key      */
	{"Fi", NO_kf54, 'K'},	/*  F54 function key      */
	{"Fj", NO_kf55, 'K'},	/*  F55 function key      */
	{"Fk", NO_kf56, 'K'},	/*  F56 function key      */
	{"Fl", NO_kf57, 'K'},	/*  F57 function key      */
	{"Fm", NO_kf58, 'K'},	/*  F58 function key      */
	{"Fn", NO_kf59, 'K'},	/*  F59 function key      */
	{"Fo", NO_kf60, 'K'},	/*  F60 function key      */
	{"Fp", NO_kf61, 'K'},	/*  F61 function key      */
	{"Fq", NO_kf62, 'K'},	/*  F62 function key      */
	{"Fr", NO_kf63, 'K'},	/*  F63 function key      */
	{"Gm", NO_getm, 'S'},	/* Curses should get button events */
	{"IC", NO_ich, 'S'},	/* insert #1 characters (P*) */
	{"Ic", NO_initc, 'S'},	/* initialize color #1 to (#2,#3,#4) */
	{"Ip", NO_initp, 'S'},	/* Initialize color pair #1 to fg=(#2,#3,#4), bg=(#5,#6,#7) */
	{"K1", NO_ka1, 'K'},	/*  upper left of keypad  */
	{"K2", NO_kb2, 'K'},	/*  center of keypad      */
	{"K3", NO_ka3, 'K'},	/*  upper right of keypad */
	{"K4", NO_kc1, 'K'},	/*  lower left of keypad  */
	{"K5", NO_kc3, 'K'},	/*  lower right of keypad */
	{"Km", NO_kmous, 'S'},	/* Mouse event has occurred */
	{"LE", NO_cub, 'S'},	/* move #1 characters to the left (P) */
	{"MC", NO_mgc, 'S'},	/* clear right and left soft margins */
	{"Mb", NO_Mb, 'S'},	/* Cyrillic extention background color map */
	{"Mf", NO_Mf, 'S'},	/* Cyrillic extention foreground color map */
	{"Mi", NO_minfo, 'S'},	/* Mouse status information */
	{"NC", NO_ncv, 'N'},	/* video attributes that can't be used with colors */
	{"Nb", NO_Nb, 'N'},	/* number of background colors */
	{"Nf", NO_Nf, 'N'},	/* number of foreground colors */
	{"RA", NO_rmam, 'S'},	/* disable automatic margins */
	{"RI", NO_cuf, 'S'},	/* move #1 characters to the right (P*) */
	{"RQ", NO_reqmp, 'S'},	/* Request mouse position */
	{"RX", NO_rmxon, 'S'},	/* turn off xon/xoff handshaking */
	{"S4", NO_smsc, 'S'},	/* Enter PC scancode mode */
	{"S5", NO_rmsc, 'S'},	/* Exit PC scancode mode */
	{"S7", NO_scesc, 'S'},	/* Escape for scancode emulation */
	{"SA", NO_smam, 'S'},	/* enable automatic margins */
	{"SF", NO_indn, 'S'},	/* scroll forward #1 lines (P) */
	{"SR", NO_rin, 'S'},	/* scroll back #1 lines (P) */
	{"SX", NO_smxon, 'S'},	/* turn on xon/xoff handshaking */
	{"Sb", NO_setb, 'S'},	/* Set background color #1 */
	{"Sf", NO_setf, 'S'},	/* Set foreground color #1 */
	{"UP", NO_cuu, 'S'},	/* up #1 lines (P*) */
	{"XF", NO_xoffc, 'S'},	/* XOFF character */
	{"XN", NO_xonc, 'S'},	/* XON character */
	{"YE", NO_sam, 'B'},	/* printing in last column causes cr */
	{"ac", NO_acsc, 'K'},	/* graphics charset pairs, based on  vt100 */
	{"ae", NO_rmacs, 'S'},	/* end alternate char acter set (P) */
	{"al", NO_il1, 'S'},	/* insert line (P*) */
	{"am", NO_am, 'B'},	/* terminal has automatic margins */
	{"as", NO_smacs, 'S'},	/* start alternate character set (P) */
	{"bl", NO_bel, 'S'},	/* audible signal (bell) (P) */
	{"bs", NO_bs, 'B'},	/* Control-H (8 dec.) performs a backspace */
	{"bt", NO_cbt, 'S'},	/* back tab (P) */
	{"bw", NO_bw, 'B'},	/* cub1 wraps from column 0 to last column */
	{"cb", NO_el1, 'S'},	/* Clear to beginning of line (P) */
	{"cc", NO_ccc, 'B'},	/* terminal can redefine existing colors */
	{"cd", NO_ed, 'S'},	/* clear to end of screen (P) */
	{"ce", NO_el, 'S'},	/* clear to end of line (P) */
	{"ch", NO_hpa, 'S'},	/* horizontal position #1, absolute (P) */
	{"cl", NO_clear, 'S'},	/* clear screen and home cursor (P) */
	{"cm", NO_cup, 'S'},	/* move to row #1 columns #2 */
	{"co", NO_cols, 'N'},	/* number of columns in a line */
	{"cr", NO_cr, 'S'},	/* carriage return */
	{"cs", NO_csr, 'S'},	/* change region to line #1 to line #2 */
	{"ct", NO_tbc, 'S'},	/* clear all tab stops */
	{"cv", NO_vpa, 'S'},	/* vertical position #1 absolute (P) */
	{"dc", NO_dch1, 'S'},	/* Delete one character (P*) */
	{"dl", NO_dl1, 'S'},	/* delete line (P*) */
	{"do", NO_cud1, 'S'},	/* down one line */
	{"ds", NO_dsl, 'S'},	/* disable status line */
	{"eA", NO_enacs, 'S'},	/* enable alternate charset */
	{"ec", NO_ech, 'S'},	/* erase #1 characters (P) */
	{"ei", NO_rmir, 'S'},	/*  exit insert mode */
	{"eo", NO_eo, 'B'},	/* can erase overstrikes with a blank */
	{"f0", NO_kf0, 'K'},	/*  F0 function key       */
	{"f1", NO_kf1, 'K'},	/*  F1 function key       */
	{"f2", NO_kf2, 'K'},	/*  F2 function key       */
	{"f3", NO_kf3, 'K'},	/*  F3 function key       */
	{"f4", NO_kf4, 'K'},	/*  F4 function key       */
	{"f5", NO_kf5, 'K'},	/*  F5 function key       */
	{"f6", NO_kf6, 'K'},	/*  F6 function key       */
	{"f7", NO_kf7, 'K'},	/*  F7 function key       */
	{"f8", NO_kf8, 'K'},	/*  F8 function key       */
	{"f9", NO_kf9, 'K'},	/*  F9 function key       */
	{"ff", NO_ff, 'S'},	/* hardcopy terminal page eject (P*) */
	{"fs", NO_fsl, 'S'},	/* return from status line */
	{"g1", NO_g1, 'S'},	/* Cyrillic extention graphic charset one-line */
	{"g2", NO_g2, 'S'},	/* Cyrillic extention graphic charset double-line */
	{"ge", NO_rmacs, 'S'},	/* end alternate char acter set (P) */
	{"gn", NO_gn, 'B'},	/* generic line type */
	{"gs", NO_smacs, 'S'},	/* start alternate character set (P) */
	{"hc", NO_hc, 'B'},	/* hardcopy terminal */
	{"hl", NO_hls, 'B'},	/* terminal uses only HLS color notation (tektronix) */
	{"ho", NO_home, 'S'},	/* home cursor (if no cup) */
	{"hs", NO_hs, 'B'},	/* has extra status line */
	{"hz", NO_hz, 'B'},	/* can't print ~'s (hazeltine) */
	{"i1", NO_is1, 'S'},	/* initialization string */
	{"i3", NO_is3, 'S'},	/* initialization string */
	{"ic", NO_ich1, 'S'},	/* insert character (P) */
	{"is", NO_is2, 'S'},	/* initialization string */
	{"it", NO_it, 'N'},	/* tabs initially every # spaces */
	{"k0", NO_kf0, 'K'},	/*  F0 function key       */
	{"k1", NO_kf1, 'K'},	/*  F1 function key       */
	{"k2", NO_kf2, 'K'},	/*  F2 function key       */
	{"k3", NO_kf3, 'K'},	/*  F3 function key       */
	{"k4", NO_kf4, 'K'},	/*  F4 function key       */
	{"k5", NO_kf5, 'K'},	/*  F5 function key       */
	{"k6", NO_kf6, 'K'},	/*  F6 function key       */
	{"k7", NO_kf7, 'K'},	/*  F7 function key       */
	{"k8", NO_kf8, 'K'},	/*  F8 function key       */
	{"k9", NO_kf9, 'K'},	/*  F9 function key       */
	{"k;", NO_kf10, 'K'},	/*  F10 function key      */
	{"kB", NO_kcbt, 'K'},	/*  back-tab key          */
	{"kC", NO_kclr, 'K'},	/*  clear screen key          */
	{"kD", NO_kdch1, 'K'},	/*  delete-character key  */
	{"kF", NO_kind, 'K'},	/*  scroll-forward key    */
	{"kH", NO_kll, 'K'},	/*  lower-left key (home down (end) ) */
	{"kI", NO_kich1, 'K'},	/*  insert-character key  */
	{"kN", NO_knp, 'K'},	/*  next-page key         */
	{"kP", NO_kpp, 'K'},	/*  previous-page key     */
	{"kR", NO_kri, 'K'},	/*  scroll-backward key   */
	{"kT", NO_khts, 'K'},	/*  set-tab key           */
	{"kb", NO_kbs, 'K'},	/*  backspace key         */
	{"kd", NO_kcud1, 'K'},	/*  down-arrow key        */
	{"ke", NO_rmkx, 'S'},	/*  turn keypad off     */
	{"kh", NO_khome, 'K'},	/*  home key              */
	{"kl", NO_kcub1, 'K'},	/*  left-arrow key        */
	{"km", NO_km, 'B'},	/* Has a meta key, sets msb high */
	{"kr", NO_kcuf1, 'K'},	/*  right-arrow key       */
	{"ks", NO_smkx, 'S'},	/*  Turn keypad on         */
	{"kt", NO_kctab, 'K'},	/*  clear-tab key         */
	{"ku", NO_kcuu1, 'K'},	/*  up-arrow key          */
	{"le", NO_cub1, 'S'},	/* move left one space */
	{"li", NO_lines, 'N'},	/* number of lines on screen or page  */
	{"ll", NO_ll, 'S'},	/* last line, first column (if no cup) */
	{"mb", NO_blink, 'S'},	/* turn on blinking */
	{"md", NO_bold, 'S'},	/* turn on bold (extra bright) mode */
	{"me", NO_sgr0, 'S'},	/* turn off all attributes */
	{"mh", NO_dim, 'S'},	/* turn on half-bright mode */
	{"mi", NO_mir, 'B'},	/* safe to move while in insert mode */
	{"mk", NO_invis, 'S'},	/* turn on blank mode (characters invisible) */
	{"mp", NO_prot, 'S'},	/* turn on protected mode */
	{"mr", NO_rev, 'S'},	/* turn on reverse video mode */
	{"ms", NO_msgr, 'B'},	/* safe to move while in standout mode */
	{"nd", NO_cuf1, 'S'},	/* move right one space */
	{"oc", NO_oc, 'S'},	/* Set all color pairs to the original ones */
	{"op", NO_op, 'S'},	/* Set default pair to its original value */
	{"os", NO_os, 'B'},	/* terminal can overstrike */
	{"pa", NO_pairs, 'N'},	/* maximum number of color-pairs on the screen */
	{"pf", NO_mc4, 'S'},	/* printer off */
	{"pO", NO_mc5p, 'S'},	/* printer on for %1 bytes */
	{"po", NO_mc5, 'S'},	/* printer on */
	{"pt", NO_pt, 'B'},	/* unknown extention */
	{"r1", NO_rs1, 'S'},	/* reset string */
	{"r2", NO_rs2, 'S'},	/* reset string */
	{"r3", NO_rs3, 'S'},	/* reset string */
	{"rc", NO_rc, 'S'},	/* restore cursor to position of last save_cursor */
	{"rp", NO_rep, 'S'},	/* repeat char #1 #2 times (P*) */
	{"rs", NO_rs, 'S'},	/* reset string */
	{"sa", NO_sgr, 'S'},	/* define video attributes #1-#9 (PG9) */
	{"sb", NO_sb, 'S'},	/* scroll text down (P) */
	{"sc", NO_sc, 'S'},	/* save current cursor position (P) */
	{"se", NO_rmso, 'S'},	/* exit standout mode */
	{"sf", NO_ind, 'S'},	/* scroll text up (P) */
	{"sg", NO_xmc, 'N'},	/* number of blank characters left by smso or rmso */
	{"so", NO_smso, 'S'},	/* begin standout mode */
	{"sp", NO_scp, 'S'},	/* Set current color pair to #1 */
	{"sr", NO_ri, 'S'},	/* scroll text down (P) */
	{"st", NO_hts, 'S'},	/* Set tabulator stop in all rows at current column */
	{"ta", NO_ht, 'S'},	/* tab to next 8-space hardware tab stop */
	{"te", NO_rmcup, 'S'},	/* strings to end programs using cup */
	{"ti", NO_smcup, 'S'},	/* string to start programs using cup */
	{"ts", NO_tsl, 'S'},	/* move to status line */
	{"uc", NO_uc, 'S'},	/* underline char and move past it */
	{"ue", NO_rmul, 'S'},	/* exit underline mode */
	{"ul", NO_ul, 'B'},	/* underline character overstrikes */
	{"up", NO_cuu1, 'S'},	/* up one line */
	{"us", NO_smul, 'S'},	/* begin underline mode */
	{"ut", NO_bce, 'B'},	/* screen erased with background color */
	{"ve", NO_cnorm, 'S'},	/* make cursor appear normal (undo civis/cvvis) */
	{"vi", NO_civis, 'S'},	/* make cursor invisible */
	{"vs", NO_cvvis, 'S'},	/* make cursor very visible */
	{"vt", NO_vt, 'S'},	/* virtual terminal number */
	{"wi", NO_wind, 'S'},	/* current window is lines #1-#2 cols #3-#4 */
	{"ws", NO_wsl, 'N'},	/* columns in status line */
	{"xn", NO_xenl, 'B'},	/* newline ignored after 80 cols (concept) */
	{"xo", NO_xon, 'B'},	/* terminal uses xon/xoff handshaking */
	{"xs", NO_xhp, 'B'},	/* standout not erased, by overwriting (hp) */
	{"xt", NO_xt, 'B'},	/* tabs destructive, magic so char (t1061) */
};

#define TCAPNUM (sizeof(termcapNames)/sizeof(TermcapBucket))

#define BOOLCOUNT 44
#define NUMCOUNT  39
#define STRCOUNT  412

typedef struct
{
	char bools[BOOLCOUNT];
	char nums[NUMCOUNT];
	struct
	{
		char num;
		char type;
	}
	strs[STRCOUNT];
}
TerminfoNums;

static const TerminfoNums tnums =
{
	 /* BOOLEANS */
	{
		/* bw */ NO_bw,
		/* am */ NO_am,
		/* xsb */ -1,
		/* xhp */ NO_xhp,
		/* xenl */ NO_xenl,
		/* eo */ NO_eo,
		/* gn */ NO_gn,
		/* hc */ NO_hc,
		/* km */ NO_km,
		/* hs */ NO_hs,
		/* in */ -1,
		/* da */ -1,
		/* db */ -1,
		/* mir */ NO_mir,
		/* msgr */ NO_msgr,
		/* os */ NO_os,
		/* eslok */ -1,
		/* xt */ NO_xt,
		/* hz */ NO_hz,
		/* ul */ NO_ul,
		/* xon */ NO_xon,
		/* nxon */ -1,
		/* mc5i */ -1,
		/* chts */ -1,
		/* nrrmc */ -1,
		/* npc */ -1,
		/* ndscr */ -1,
		/* ccc */ NO_ccc,
		/* bce */ NO_bce,
		/* hls */ NO_hls,
		/* xhpa */ -1,
		/* crxm */ -1,
		/* daisy */ -1,
		/* xvpa */ -1,
		/* sam */ NO_sam,
		/* cpix */ -1,
		/* lpix */ -1,
		/* OTbs */ -1,
		/* OTns */ -1,
		/* OTnc */ -1,
		/* OTMT */ -1,
		/* OTNL */ -1,
		/* OTpt */ -1,
		/* OTxr */ -1,
	},
	 /* NUMERICS */
	{
		/* cols */ NO_cols,
		/* it */ NO_it,
		/* lines */ NO_lines,
		/* lm */ -1,
		/* xmc */ NO_xmc,
		/* pb */ -1,
		/* vt */ -1,
		/* wsl */ NO_wsl,
		/* nlab */ -1,
		/* lh */ -1,
		/* lw */ -1,
		/* ma */ -1,
		/* wnum */ -1,
		/* colors */ NO_colors,
		/* pairs */ NO_pairs,
		/* ncv */ NO_ncv,
		/* bufsz */ -1,
		/* spinv */ -1,
		/* spinh */ -1,
		/* maddr */ -1,
		/* mjump */ -1,
		/* mcs */ -1,
		/* mls */ -1,
		/* npins */ -1,
		/* orc */ -1,
		/* orl */ -1,
		/* orhi */ -1,
		/* orvi */ -1,
		/* cps */ -1,
		/* widcs */ -1,
		/* btns */ NO_btns,
		/* bitwin */ -1,
		/* bitype */ -1,
		/* OTug */ -1,
		/* OTdC */ -1,
		/* OTdN */ -1,
		/* OTdB */ -1,
		/* OTdT */ -1,
		/* OTkn */ -1,
	},
	 /* STRINGS */
	{
	/* cbt */
		{NO_cbt, 'S'},
	/* bel */
		{NO_bel, 'S'},
	/* cr */
		{NO_cr, 'S'},
	/* csr */
		{NO_csr, 'S'},
	/* tbc */
		{NO_tbc, 'S'},
	/* clear */
		{NO_clear, 'S'},
	/* el */
		{NO_el, 'S'},
	/* ed */
		{NO_ed, 'S'},
	/* hpa */
		{NO_hpa, 'S'},
		/* cmdch */
		{-1, 0},
	/* cup */
		{NO_cup, 'S'},
	/* cud1 */
		{NO_cud1, 'S'},
	/* home */
		{NO_home, 'S'},
	/* civis */
		{NO_civis, 'S'},
	/* cub1 */
		{NO_cub1, 'S'},
		/* mrcup */
		{-1, 0},
	/* cnorm */
		{NO_cnorm, 'S'},
	/* cuf1 */
		{NO_cuf1, 'S'},
	/* ll */
		{NO_ll, 'S'},
	/* cuu1 */
		{NO_cuu1, 'S'},
	/* cvvis */
		{NO_cvvis, 'S'},
	/* dch1 */
		{NO_dch1, 'S'},
	/* dl1 */
		{NO_dl1, 'S'},
	/* dsl */
		{NO_dsl, 'S'},
		/* hd */
		{-1, 0},
	/* smacs */
		{NO_smacs, 'S'},
	/* blink */
		{NO_blink, 'S'},
	/* bold */
		{NO_bold, 'S'},
	/* smcup */
		{NO_smcup, 'S'},
		/* smdc */
		{-1, 0},
	/* dim */
		{NO_dim, 'S'},
		/* smir */
		{-1, 0},
	/* invis */
		{NO_invis, 'S'},
	/* prot */
		{NO_prot, 'S'},
	/* rev */
		{NO_rev, 'S'},
	/* smso */
		{NO_smso, 'S'},
	/* smul */
		{NO_smul, 'S'},
	/* ech */
		{NO_ech, 'S'},
	/* rmacs */
		{NO_rmacs, 'S'},
	/* sgr0 */
		{NO_sgr0, 'S'},
	/* rmcup */
		{NO_rmcup, 'S'},
		/* rmdc */
		{-1, 0},
	/* rmir */
		{NO_rmir, 'S'},
	/* rmso */
		{NO_rmso, 'S'},
	/* rmul */
		{NO_rmul, 'S'},
		/* flash */
		{-1, 0},
	/* ff */
		{NO_ff, 'S'},
	/* fsl */
		{NO_fsl, 'S'},
	/* is1 */
		{NO_is1, 'S'},
	/* is2 */
		{NO_is2, 'S'},
	/* is3 */
		{NO_is3, 'S'},
		/* if */
		{-1, 0},
	/* ich1 */
		{NO_ich1, 'S'},
	/* il1 */
		{NO_il1, 'S'},
		/* ip */
		{-1, 0},
	/* kbs */
		{NO_kbs, 'K'},
		/* ktbc */
		{-1, 0},
	/* kclr */
		{NO_kclr, 'K'},
	/* kctab */
		{NO_kctab, 'K'},
	/* kdch1 */
		{NO_kdch1, 'K'},
		/* kdl1 */
		{-1, 0},
	/* kcud1 */
		{NO_kcud1, 'K'},
		/* krmir */
		{-1, 0},
		/* kel */
		{-1, 0},
		/* ked */
		{-1, 0},
	/* kf0 */
		{NO_kf0, 'K'},
	/* kf1 */
		{NO_kf1, 'K'},
	/* kf10 */
		{NO_kf10, 'K'},
	/* kf2 */
		{NO_kf2, 'K'},
	/* kf3 */
		{NO_kf3, 'K'},
	/* kf4 */
		{NO_kf4, 'K'},
	/* kf5 */
		{NO_kf5, 'K'},
	/* kf6 */
		{NO_kf6, 'K'},
	/* kf7 */
		{NO_kf7, 'K'},
	/* kf8 */
		{NO_kf8, 'K'},
	/* kf9 */
		{NO_kf9, 'K'},
	/* khome */
		{NO_khome, 'K'},
	/* kich1 */
		{NO_kich1, 'K'},
		/* kil1 */
		{-1, 0},
	/* kcub1 */
		{NO_kcub1, 'K'},
	/* kll */
		{NO_kll, 'K'},
	/* knp */
		{NO_knp, 'K'},
	/* kpp */
		{NO_kpp, 'K'},
	/* kcuf1 */
		{NO_kcuf1, 'K'},
	/* kind */
		{NO_kind, 'K'},
	/* kri */
		{NO_kri, 'K'},
	/* khts */
		{NO_khts, 'K'},
	/* kcuu1 */
		{NO_kcuu1, 'K'},
	/* rmkx */
		{NO_rmkx, 'S'},
	/* smkx */
		{NO_smkx, 'S'},
		/* lf0 */
		{-1, 0},
		/* lf1 */
		{-1, 0},
		/* lf10 */
		{-1, 0},
		/* lf2 */
		{-1, 0},
		/* lf3 */
		{-1, 0},
		/* lf4 */
		{-1, 0},
		/* lf5 */
		{-1, 0},
		/* lf6 */
		{-1, 0},
		/* lf7 */
		{-1, 0},
		/* lf8 */
		{-1, 0},
		/* lf9 */
		{-1, 0},
		/* rmm */
		{-1, 0},
		/* smm */
		{-1, 0},
		/* nel */
		{-1, 0},
		/* pad */
		{-1, 0},
	/* dch */
		{NO_dch, 'S'},
	/* dl */
		{NO_dl, 'S'},
	/* cud */
		{NO_cud, 'S'},
	/* ich */
		{NO_ich, 'S'},
	/* indn */
		{NO_indn, 'S'},
	/* il */
		{NO_il, 'S'},
	/* cub */
		{NO_cub, 'S'},
	/* cuf */
		{NO_cuf, 'S'},
	/* rin */
		{NO_rin, 'S'},
	/* cuu */
		{NO_cuu, 'S'},
		/* pfkey */
		{-1, 0},
		/* pfloc */
		{-1, 0},
		/* pfx */
		{-1, 0},
		/* mc0 */
		{-1, 0},
	/* mc4 */
		{NO_mc4, 'S'},
	/* mc5 */
		{NO_mc5, 'S'},
	/* rep */
		{NO_rep, 'S'},
	/* rs1 */
		{NO_rs1, 'S'},
	/* rs2 */
		{NO_rs2, 'S'},
	/* rs3 */
		{NO_rs3, 'S'},
		/* rf */
		{-1, 0},
	/* rc */
		{NO_rc, 'S'},
	/* vpa */
		{NO_vpa, 'S'},
	/* sc */
		{NO_sc, 'S'},
	/* ind */
		{NO_ind, 'S'},
	/* ri */
		{NO_ri, 'S'},
	/* sgr */
		{NO_sgr, 'S'},
	/* hts */
		{NO_hts, 'S'},
	/* wind */
		{NO_wind, 'S'},
	/* ht */
		{NO_ht, 'S'},
	/* tsl */
		{NO_tsl, 'S'},
	/* uc */
		{NO_uc, 'S'},
		/* hu */
		{-1, 0},
		/* iprog */
		{-1, 0},
	/* ka1 */
		{NO_ka1, 'K'},
	/* ka3 */
		{NO_ka3, 'K'},
	/* kb2 */
		{NO_kb2, 'K'},
	/* kc1 */
		{NO_kc1, 'K'},
	/* kc3 */
		{NO_kc3, 'K'},
	/* mc5p */
		{NO_mc5p, 'S'},
		/* rmp */
		{-1, 0},
	/* acsc */
		{NO_acsc, 'K'},
		/* pln */
		{-1, 0},
	/* kcbt */
		{NO_kcbt, 'K'},
	/* smxon */
		{NO_smxon, 'S'},
	/* rmxon */
		{NO_rmxon, 'S'},
	/* smam */
		{NO_smam, 'S'},
	/* rmam */
		{NO_rmam, 'S'},
	/* xonc */
		{NO_xonc, 'S'},
	/* xoffc */
		{NO_xoffc, 'S'},
	/* enacs */
		{NO_enacs, 'S'},
		/* smln */
		{-1, 0},
		/* rmln */
		{-1, 0},
	/* kbeg */
		{NO_kbeg, 'K'},
	/* kcan */
		{NO_kcan, 'K'},
	/* kclo */
		{NO_kclo, 'K'},
	/* kcmd */
		{NO_kcmd, 'K'},
	/* kcpy */
		{NO_kcpy, 'K'},
	/* kcrt */
		{NO_kcrt, 'K'},
	/* kend */
		{NO_kend, 'K'},
	/* kent */
		{NO_kent, 'K'},
	/* kext */
		{NO_kext, 'K'},
	/* kfnd */
		{NO_kfnd, 'K'},
		/* khlp */
		{-1, 0},
		/* kmrk */
		{-1, 0},
		/* kmsg */
		{-1, 0},
		/* kmov */
		{-1, 0},
		/* knxt */
		{-1, 0},
		/* kopn */
		{-1, 0},
		/* kopt */
		{-1, 0},
		/* kprv */
		{-1, 0},
		/* kprt */
		{-1, 0},
		/* krdo */
		{-1, 0},
		/* kref */
		{-1, 0},
		/* krfr */
		{-1, 0},
		/* krpl */
		{-1, 0},
		/* krst */
		{-1, 0},
		/* kres */
		{-1, 0},
		/* ksav */
		{-1, 0},
		/* kspd */
		{-1, 0},
		/* kund */
		{-1, 0},
		/* kBEG */
		{-1, 0},
		/* kCAN */
		{-1, 0},
		/* kCMD */
		{-1, 0},
		/* kCPY */
		{-1, 0},
		/* kCRT */
		{-1, 0},
		/* kDC */
		{-1, 0},
		/* kDL */
		{-1, 0},
		/* kslt */
		{-1, 0},
		/* kEND */
		{-1, 0},
		/* kEOL */
		{-1, 0},
		/* kEXT */
		{-1, 0},
		/* kFND */
		{-1, 0},
		/* kHLP */
		{-1, 0},
		/* kHOM */
		{-1, 0},
		/* kIC */
		{-1, 0},
		/* kLFT */
		{-1, 0},
		/* kMSG */
		{-1, 0},
		/* kMOV */
		{-1, 0},
		/* kNXT */
		{-1, 0},
		/* kOPT */
		{-1, 0},
		/* kPRV */
		{-1, 0},
		/* kPRT */
		{-1, 0},
		/* kRDO */
		{-1, 0},
		/* kRPL */
		{-1, 0},
		/* kRIT */
		{-1, 0},
		/* kRES */
		{-1, 0},
		/* kSAV */
		{-1, 0},
		/* kSPD */
		{-1, 0},
		/* kUND */
		{-1, 0},
		/* rfi */
		{-1, 0},
	/* kf11 */
		{NO_kf11, 'K'},
	/* kf12 */
		{NO_kf12, 'K'},
	/* kf13 */
		{NO_kf13, 'K'},
	/* kf14 */
		{NO_kf14, 'K'},
	/* kf15 */
		{NO_kf15, 'K'},
	/* kf16 */
		{NO_kf16, 'K'},
	/* kf17 */
		{NO_kf17, 'K'},
	/* kf18 */
		{NO_kf18, 'K'},
	/* kf19 */
		{NO_kf19, 'K'},
	/* kf20 */
		{NO_kf20, 'K'},
	/* kf21 */
		{NO_kf21, 'K'},
	/* kf22 */
		{NO_kf22, 'K'},
	/* kf23 */
		{NO_kf23, 'K'},
	/* kf24 */
		{NO_kf24, 'K'},
	/* kf25 */
		{NO_kf25, 'K'},
	/* kf26 */
		{NO_kf26, 'K'},
	/* kf27 */
		{NO_kf27, 'K'},
	/* kf28 */
		{NO_kf28, 'K'},
	/* kf29 */
		{NO_kf29, 'K'},
	/* kf30 */
		{NO_kf30, 'K'},
	/* kf31 */
		{NO_kf31, 'K'},
	/* kf32 */
		{NO_kf32, 'K'},
	/* kf33 */
		{NO_kf33, 'K'},
	/* kf34 */
		{NO_kf34, 'K'},
	/* kf35 */
		{NO_kf35, 'K'},
	/* kf36 */
		{NO_kf36, 'K'},
	/* kf37 */
		{NO_kf37, 'K'},
	/* kf38 */
		{NO_kf38, 'K'},
	/* kf39 */
		{NO_kf39, 'K'},
	/* kf40 */
		{NO_kf40, 'K'},
	/* kf41 */
		{NO_kf41, 'K'},
	/* kf42 */
		{NO_kf42, 'K'},
	/* kf43 */
		{NO_kf43, 'K'},
	/* kf44 */
		{NO_kf44, 'K'},
	/* kf45 */
		{NO_kf45, 'K'},
	/* kf46 */
		{NO_kf46, 'K'},
	/* kf47 */
		{NO_kf47, 'K'},
	/* kf48 */
		{NO_kf48, 'K'},
	/* kf49 */
		{NO_kf49, 'K'},
	/* kf50 */
		{NO_kf50, 'K'},
	/* kf51 */
		{NO_kf51, 'K'},
	/* kf52 */
		{NO_kf52, 'K'},
	/* kf53 */
		{NO_kf53, 'K'},
	/* kf54 */
		{NO_kf54, 'K'},
	/* kf55 */
		{NO_kf55, 'K'},
	/* kf56 */
		{NO_kf56, 'K'},
	/* kf57 */
		{NO_kf57, 'K'},
	/* kf58 */
		{NO_kf58, 'K'},
	/* kf59 */
		{NO_kf59, 'K'},
	/* kf60 */
		{NO_kf60, 'K'},
	/* kf61 */
		{NO_kf61, 'K'},
	/* kf62 */
		{NO_kf62, 'K'},
	/* kf63 */
		{NO_kf63, 'K'},
	/* el1 */
		{NO_el1, 'S'},
	/* mgc */
		{NO_mgc, 'S'},
		/* smgl */
		{-1, 0},
		/* smgr */
		{-1, 0},
		/* fln */
		{-1, 0},
		/* sclk */
		{-1, 0},
		/* dclk */
		{-1, 0},
		/* rmclk */
		{-1, 0},
	/* cwin */
		{NO_cwin, 'S'},
		/* wingo */
		{-1, 0},
		/* hup */
		{-1, 0},
		/* dial */
		{-1, 0},
		/* qdial */
		{-1, 0},
		/* tone */
		{-1, 0},
		/* pulse */
		{-1, 0},
		/* hook */
		{-1, 0},
		/* pause */
		{-1, 0},
		/* wait */
		{-1, 0},
		/* u0 */
		{-1, 0},
		/* u1 */
		{-1, 0},
		/* u2 */
		{-1, 0},
		/* u3 */
		{-1, 0},
		/* u4 */
		{-1, 0},
		/* u5 */
		{-1, 0},
		/* u6 */
		{-1, 0},
		/* u7 */
		{-1, 0},
		/* u8 */
		{-1, 0},
		/* u9 */
		{-1, 0},
	/* op */
		{NO_op, 'S'},
	/* oc */
		{NO_oc, 'S'},
	/* initc */
		{NO_initc, 'S'},
	/* initp */
		{NO_initp, 'S'},
	/* scp */
		{NO_scp, 'S'},
	/* setf */
		{NO_setf, 'S'},
	/* setb */
		{NO_setb, 'S'},
		/* cpi */
		{-1, 0},
		/* lpi */
		{-1, 0},
		/* chr */
		{-1, 0},
		/* cvr */
		{-1, 0},
		/* defc */
		{-1, 0},
		/* swidm */
		{-1, 0},
		/* sdrfq */
		{-1, 0},
		/* sitm */
		{-1, 0},
		/* slm */
		{-1, 0},
		/* smicm */
		{-1, 0},
		/* snlq */
		{-1, 0},
		/* snrmq */
		{-1, 0},
		/* sshm */
		{-1, 0},
		/* ssubm */
		{-1, 0},
		/* ssupm */
		{-1, 0},
		/* sum */
		{-1, 0},
		/* rwidm */
		{-1, 0},
		/* ritm */
		{-1, 0},
		/* rlm */
		{-1, 0},
		/* rmicm */
		{-1, 0},
		/* rshm */
		{-1, 0},
		/* rsubm */
		{-1, 0},
		/* rsupm */
		{-1, 0},
		/* rum */
		{-1, 0},
		/* mhpa */
		{-1, 0},
		/* mcud1 */
		{-1, 0},
		/* mcub1 */
		{-1, 0},
		/* mcuf1 */
		{-1, 0},
		/* mvpa */
		{-1, 0},
		/* mcuu1 */
		{-1, 0},
		/* porder */
		{-1, 0},
		/* mcud */
		{-1, 0},
		/* mcub */
		{-1, 0},
		/* mcuf */
		{-1, 0},
		/* mcuu */
		{-1, 0},
		/* scs */
		{-1, 0},
		/* smgb */
		{-1, 0},
		/* smgbp */
		{-1, 0},
		/* smglp */
		{-1, 0},
		/* smgrp */
		{-1, 0},
		/* smgt */
		{-1, 0},
		/* smgtp */
		{-1, 0},
		/* sbim */
		{-1, 0},
		/* scsd */
		{-1, 0},
		/* rbim */
		{-1, 0},
		/* rcsd */
		{-1, 0},
		/* subcs */
		{-1, 0},
		/* supcs */
		{-1, 0},
		/* docr */
		{-1, 0},
		/* zerom */
		{-1, 0},
		/* csnm */
		{-1, 0},
	/* kmous */
		{NO_kmous, 'S'},
	/* minfo */
		{NO_minfo, 'S'},
	/* reqmp */
		{NO_reqmp, 'S'},
	/* getm */
		{NO_getm, 'S'},
	/* setaf */
		{NO_setaf, 'S'},
	/* setab */
		{NO_setab, 'S'},
		/* pfxl */
		{-1, 0},
		/* devt */
		{-1, 0},
		/* csin */
		{-1, 0},
		/* s0ds */
		{-1, 0},
		/* s1ds */
		{-1, 0},
		/* s2ds */
		{-1, 0},
		/* s3ds */
		{-1, 0},
		/* smglr */
		{-1, 0},
		/* smgtb */
		{-1, 0},
		/* birep */
		{-1, 0},
		/* binel */
		{-1, 0},
		/* bicr */
		{-1, 0},
		/* colornm */
		{-1, 0},
		/* defbi */
		{-1, 0},
		/* endbi */
		{-1, 0},
		/* setcolor */
		{-1, 0},
		/* slines */
		{-1, 0},
		/* dispc */
		{-1, 0},
		/* smpch */
		{-1, 0},
		/* rmpch */
		{-1, 0},
	/* smsc */
		{NO_smsc, 'S'},
	/* rmsc */
		{NO_rmsc, 'S'},
		/* pctrm */
		{-1, 0},
	/* scesc */
		{NO_scesc, 'S'},
		/* scesa */
		{-1, 0},
		/* ehhlm */
		{-1, 0},
		/* elhlm */
		{-1, 0},
		/* elohlm */
		{-1, 0},
		/* erhlm */
		{-1, 0},
		/* ethlm */
		{-1, 0},
		/* evhlm */
		{-1, 0},
		/* OTi2 */
		{-1, 0},
		/* OTrs */
		{-1, 0},
		/* OTnl */
		{-1, 0},
		/* OTbc */
		{-1, 0},
		/* OTko */
		{-1, 0},
		/* OTma */
		{-1, 0},
		/* OTG2 */
		{-1, 0},
		/* OTG3 */
		{-1, 0},
		/* OTG1 */
		{-1, 0},
		/* OTG4 */
		{-1, 0},
		/* OTGR */
		{-1, 0},
		/* OTGL */
		{-1, 0},
		/* OTGU */
		{-1, 0},
		/* OTGD */
		{-1, 0},
		/* OTGH */
		{-1, 0},
		/* OTGV */
		{-1, 0},
		/* OTGC */
		{-1, 0},
		/* meml */
		{-1, 0},
		/* memu */
		{-1, 0},
		/* box1 */
		{-1, 0},
	}
};

int
read_term(int fnum, char **fnames,
	  int tnum, Terminfo * infos, char *errbuf, int errbuflen)
{
	struct stat st;
	int r, i;

	for (i = 0; i < fnum; ++i)
	{
		r = stat(fnames[i], &st);
		if (!r)
		{
			if (S_ISDIR(st.st_mode))
				return read_tinfo(fnum, fnames, tnum, infos, errbuf, errbuflen);
			else if (S_ISREG(st.st_mode))
				return read_tcap(fnum, fnames, tnum, infos, errbuf, errbuflen);
		}
	}

	snprintf(errbuf, errbuflen, "no valid termcap/terminfo files:");
	for (i = 0; i < fnum; ++i)
	{
		r = strlen(errbuf);
		snprintf(errbuf + r, errbuflen - r, " %s", fnames[i]);
	}
	return -1;
}

int
read_tcapbuf(char *buf, Terminfo * info, char *Errbuf, int Errbuflen)
{
	errbuf = Errbuf;
	errbuflen = Errbuflen;
	errcode = 0;

	split_entry(info, buf);

	return 0;
}

int
read_tcap(int Fnum, char **Fnames, int tnum, Terminfo * infos
	  ,char *Errbuf, int Errbuflen)
{
	int i, r = 0;
	char buf[TBUFSIZE];
	Terminfo *info;

	fnum = Fnum;
	fnames = Fnames;
	errbuf = Errbuf;
	errbuflen = Errbuflen;
	errcode = 0;

	for (i = 0; i < tnum; ++i)
	{
		info = infos + i;

		match_count = 0;
		r = tgetent(buf, info->name, 0);
		if (r < 0 && errcode)
			return -1;

		if (!r || !match_count)
		{
			snprintf(Errbuf, Errbuflen, "no termcap entry for terminal '%s'",
				 info->name);
			return -1;
		}

		split_entry(info, buf);

	}

	return 0;
}

int
read_tinfo(int fnum, char **fnames, int tnum, Terminfo * infos
	   ,char *Errbuf, int Errbuflen)
{
	int r = 0;
	int i, j, found;
	Terminfo *info;

	errbuf = Errbuf;
	errbuflen = Errbuflen;
	errcode = 0;

	for (i = 0; i < tnum; ++i)
	{
		found = 0;
		info = infos + i;
		r = 0;

		for (j = 0; j < fnum; ++j)
		{
			char path[PATH_MAX];

			snprintf(path, PATH_MAX, "%s" DELIMSTR "%c" DELIMSTR "%s",
				 fnames[j], info->name[0], info->name);

			r = read_info(info, path);
			if (!r)
				++found;
		}

		if (!found)
		{
			snprintf(Errbuf, Errbuflen, "no terminfo entry for terminal '%s'",
				 info->name);
			return -1;
		}

	}

	return 0;
}

static void
err(char *fmt,...)
{
	va_list ap;

	va_start(ap, fmt);
	vsnprintf(errbuf, errbuflen, fmt, ap);
	errcode = 1;

	va_end(ap);
}

static int
tgetent(char *bp, char *name, int beg)
{
	int j;
	int c;
	int tf = -1;
	char *cp = 0;
	char ibuf[TBUFSIZE];
	int i = 0;
	int cnt = 0;

	if (beg >= fnum)
		return 0;

	tbuf = bp;

	for (j = beg; j < fnum; ++j)
	{
		char *termcap = fnames[j];

		tf = open(termcap, 0);
		if (tf < 0)
			continue;
		i = 0;
		cnt = 0;
		for (;;)
		{
			cp = bp;
			for (;;)
			{
				if (i == cnt)
				{
					cnt = read(tf, ibuf, TBUFSIZE);
					if (cnt <= 0)
						goto nextf;
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
				if (cp >= bp + TBUFSIZE)
				{
					err("Termcap entry too long");
					break;
				}
				else
					*cp++ = c;
			}
			*cp = 0;

			/* The real work for the match. */
			if (tnamatch(name))
			{
				++match_count;
				close(tf);
				return tnchktc(name, j);
			}
		}
		  nextf:
		close(tf);
	}
	return -1;
}

static int
tnchktc(char *name, int beg)
{
	register char *p, *q;
	char tcname[16];	/* name of similar terminal */
	char tcbuf[TBUFSIZE];
	char *holdtbuf = tbuf;
	int l;

	p = tbuf + strlen(tbuf) - 2;	/* before the last colon */
	while (*--p != ':')
		if (p < tbuf)
		{
			err("Bad termcap entry");
			return 0;
		}
	p++;
	/* p now points to beginning of last field */
	if (p[0] != 't' || p[1] != 'c')
		return 1;
	strcpy(tcname, p + 3);
	q = tcname;
	while (*q && *q != ':')
		q++;
	*q = 0;
	if (++hopcount > MAXHOP)
	{
		err("Infinite tc= loop");
		return 0;
	}

	if (!strcmp(tcname, name))
		++beg;
	if (tgetent(tcbuf, tcname, beg) <= 0)
	{
		hopcount = 0;	/* unwind recursion */
		return 1;
	}
	for (q = tcbuf; *q != ':'; q++)
		;
	l = p - holdtbuf + strlen(q);
	if (l > TBUFSIZE)
	{
		err("Termcap entry too long\n");
		q[TBUFSIZE - (p - tbuf)] = 0;
	}
	strcpy(p, q + 1);
	tbuf = holdtbuf;
	hopcount = 0;		/* unwind recursion */

	return 1;
}

static int
tnamatch(char *np)
{
	register char *Np, *Bp;

	Bp = tbuf;
	if (*Bp == '#')
		return 0;
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

static void
split_entry(Terminfo * info, char *entry)
{
	char *bp;
	char name[3];

	name[2] = 0;
	bp = entry;
	while (bp && *bp)
	{
		TermcapBucket *fp;

		bp = tskip(bp);
		if (!bp[0] || !bp[1])
			break;
		if (bp[0] == ':' || bp[1] == ':')
			continue;
		name[0] = *bp++;
		name[1] = *bp++;

		/*if (*bp == '@')
		   continue; */
		if (name[0] == ' ' || name[1] == ' ')
			continue;

		fp = (TermcapBucket *) bsearch(name, termcapNames, TCAPNUM,
						   sizeof(TermcapBucket), cmp_bucket);

		if (!fp)
		{
			/*printf("unknown termcap entry: %s\n", name); */
			continue;
		}

		switch (*bp)
		{
		case ':':
			/* bool */
			if (fp->type == 'B')
			{
				info->bools[fp->no] = 1;
			}
			break;
		case '#':
			/* num */
			if (fp->type == 'N')
			{
				int base, i;

				++bp;
				if (info->nums[fp->no] != -1)
					break;
				base = 10;
				if (*bp == '0')
					base = 8;
				i = 0;
				while (*bp >= '0' && *bp <= '9')
					i = i * base, i += *bp++ - '0';
				info->nums[fp->no] = i;
			}
			break;
		case '=':
			/* string */
			{
				int s;

				++bp;
				if (fp->type == 'S')
					if (info->strings[fp->no] != -1)
						break;
				if (fp->type == 'K')
					if (info->keys[fp->no] != -1)
						break;

				s = tdecode(bp, info);
				if (fp->type == 'S')
					info->strings[fp->no] = s;
				else if (fp->type == 'K')
					info->keys[fp->no] = s;
			}
			break;
		case 0:
			return;
		default:
			continue;
		}
	}
}

static int
place_buf(Terminfo * info, int need)
{
	if ((info->bufsize - info->bufpos) < need)
	{
		int delta, osize;

		delta = info->bufsize / 3;
		if (delta < need)
			delta = need;
		if (delta < 8)
			delta = 8;
		osize = info->bufsize;
		info->bufsize += delta;
		info->buf = realloc(info->buf, info->bufsize);
		memset(info->buf+osize, 0, delta);
	}

	return info->bufsize - info->bufpos;
}

static int
tdecode(char *bp, Terminfo * info)
{
	int c;
	char *dp;
	int i;
	char *str;
	int retpos;

	/* skip the delay */
#if 0
	while (isdigit(*bp))
		++bp;
#endif

	str = bp;
	retpos = info->bufpos;
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
		place_buf(info, 1);
		info->buf[info->bufpos++] = c;
	}

	if (info->bufpos == retpos)
		return -1;

	place_buf(info, 1);
	info->buf[info->bufpos++] = 0;

	return retpos;
}

static int
cmp_bucket(const void *p1, const void *p2)
{
	return strcmp((const char *) p1, ((const TermcapBucket *) p2)->name);
}

void
init_Terminfo(Terminfo * info)
{
	int i;

	info->name = 0;

	for (i = 0; i < MAX_BOOL; ++i)
		info->bools[i] = 0;
	for (i = 0; i < MAX_NUM; ++i)
		info->nums[i] = -1;
	for (i = 0; i < MAX_STR; ++i)
		info->strings[i] = -1;
	for (i = 0; i < MAX_KEY; ++i)
		info->keys[i] = -1;

	info->buf = 0;
	info->bufsize = 0;
	info->bufpos = 0;
}

void
destroy_Terminfo(Terminfo * info)
{
	if (info->buf)
	{
		free(info->buf);
		info->buf = 0;
	}
	info->bufsize = info->bufpos = 0;
}

#undef  BYTE
#define BYTE(p,n)	(unsigned char)((p)[n])

#define IS_NEG1(p)	((BYTE(p,0) == 0377) && (BYTE(p,1) == 0377))
#define IS_NEG2(p)	((BYTE(p,0) == 0376) && (BYTE(p,1) == 0377))
#define LOW_MSB(p)	(BYTE(p,0) + 256*BYTE(p,1))
#define MAGIC		0432	/* first two bytes of a compiled entry */
#define MAX_NAME_SIZE	127	/* maximum legal name field size */
#define MAX_ENTRY_SIZE	4096	/* maximum legal entry size */
#define MAX_ALIAS	14	/* maximum size of individual name or alias */

#define M_MIN(a,b)	((a)<(b)?(a):(b))

static int
read_info(Terminfo * info, char *filename)
{
	int name_size, bool_count, num_count, str_count, str_size;
	int i, fd, numread, size, r;
	char buf[MAX_ENTRY_SIZE], *str_table;

	if ((fd = open(filename, O_RDONLY
#ifdef _WIN32
			   | O_BINARY
#endif
		 )) < 0)
		return -1;

	/* grab the header */
	if ((r = read(fd, buf, 12)) < 12)
		goto clret;

	if (LOW_MSB(buf) != MAGIC)
	{
		  clret:
		close(fd);
		return (0);
	}
	name_size = LOW_MSB(buf + 2);
	bool_count = LOW_MSB(buf + 4);
	num_count = LOW_MSB(buf + 6);
	str_count = LOW_MSB(buf + 8);
	str_size = LOW_MSB(buf + 10);

	/* grab the name */
	size = M_MIN(MAX_NAME_SIZE, (unsigned) name_size);
	if (read(fd, buf, size) < size)
		goto clret;
	buf[MAX_NAME_SIZE] = '\0';

#if 0
	ptr->term_names = calloc(strlen(buf) + 1, sizeof(char));

	strcpy(ptr->term_names, buf);
#endif

	if (name_size > MAX_NAME_SIZE)
		lseek(fd, (off_t) (name_size - MAX_NAME_SIZE), 1);

	/* grab the booleans */
	size = M_MIN(BOOLCOUNT, (unsigned) bool_count);
	if (read(fd, buf, size) < size)
		goto clret;
	if (bool_count > BOOLCOUNT)
		lseek(fd, (off_t) (bool_count - BOOLCOUNT), 1);
	else
		for (i = bool_count; i < BOOLCOUNT; i++)
			buf[i] = 0;

	for (i = 0; i < BOOLCOUNT; ++i)
	{
		int no = tnums.bools[i];

		if (no < 0)
			continue;
		if (buf[i])
			info->bools[no] = 1;
	}

	/*
	 * If booleans end on an odd byte, skip it.  The machine they
	 * originally wrote terminfo on must have been a 16-bit
	 * word-oriented machine that would trap out if you tried a
	 * word access off a 2-byte boundary.
	 */
	if ((name_size + bool_count) % 2 != 0)
		read(fd, buf, 1);

	/* grab the numbers */
	size = M_MIN(NUMCOUNT * 2, (unsigned) num_count * 2);
	if (read(fd, buf, size) < size)
		goto clret;

	for (i = 0; i < M_MIN(num_count, NUMCOUNT); i++)
	{
		int no = tnums.nums[i];

		if (no < 0)
			continue;

		if (info->nums[no] != -1)
			continue;

		if (IS_NEG1(buf + 2 * i))
			continue;
		else if (IS_NEG2(buf + 2 * i))
			continue;
		else
			info->nums[no] = LOW_MSB(buf + 2 * i);
	}
	if (num_count > NUMCOUNT)
		lseek(fd, (off_t) (2 * (num_count - NUMCOUNT)), 1);

	if (str_count && str_size)
	{
		/* grab the string offsets */
		numread = read(fd, buf, (unsigned) (str_count * 2));
		if (numread < str_count * 2)
			goto clret;

		str_table = buf + numread;
		if (str_count > STRCOUNT)
			lseek(fd, (off_t) (2 * (str_count - STRCOUNT)), 1);

		/* finally, grab the string table itself */
		numread = read(fd, str_table, (unsigned) str_size);
		if (numread != str_size)
			goto clret;

		for (i = 0; i < str_count; i++)
		{
			int no = tnums.strs[i].num;
			int type = tnums.strs[i].type;

			if (no < 0)
				continue;

			if (type == 'S' && info->strings[no] != -1)
				continue;
			if (type == 'K' && info->keys[no] != -1)
				continue;

			if (IS_NEG1(buf + 2 * i))
				continue;
			else if (IS_NEG2(buf + 2 * i))
				continue;
			else
			{
				int offs, l;
				char *s, *p;

				offs = LOW_MSB(buf + 2 * i);
				s = str_table + offs;
				l = strlen(s) + 1;
				place_buf(info, l);

#if 0
				memcpy(info->buf + info->bufpos, s, l);
#else
				for (l = 0, p = info->buf + info->bufpos; *s;)
				{
					int c;

					/* skip the delay info */
					if ((c = s[0]) == '$' && s[1] == '<')
					{
						char *s1;

						for (s1 = s + 2; *s1; ++s1)
							if (*s1 == '>')
								break;
						if (*s1)
							s = s1 + 1;
						else
							s = s1;
					}
					else
					{
						*p = c;
						++s;
						++p;
						++l;
					}
				}
				*p = 0;
				++l;
#endif

				if (type == 'S')
					info->strings[no] = info->bufpos;
				else if (type == 'K')
					info->keys[no] = info->bufpos;
				info->bufpos += l;
			}
		}
	}

	return 0;
}

TermcapBucket *
tgetentry(const char *name)
{
	return (TermcapBucket *) bsearch(name, termcapNames, TCAPNUM,
					 sizeof(TermcapBucket), cmp_bucket);
}
