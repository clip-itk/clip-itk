/*
$Log$
Revision 1.1  2006/06/22 19:35:31  itk
uri: init sf.net repository

Revision 1.2  1999/11/02 23:05:55  axl
start of logging CVS

*/

#ifndef TCAPS_H
#define TCAPS_H

/* BOOLS */
#define NO_bw     0
#define NO_am     1
#define NO_bce    2
#define NO_ccc    3
#define NO_xhp    4
#define NO_xt     5
#define NO_xenl   6
#define NO_eo     7
#define NO_gn     8
#define NO_hc     9
#define NO_km     10
#define NO_hs     11
#define NO_hls    12
#define NO_os     13
#define NO_sam    14
#define NO_hz     15
#define NO_ul     16
#define NO_xon    17
#define NO_C2	18
#define NO_CY   19

#define NO_bs     20

#define NO_mir    21
#define NO_msgr   20
#define NO_pt     21


#define MAX_BOOL  22

/* NUMS */
#define NO_cols    0
#define NO_it      1
#define NO_lines   2
#define NO_xmc     3
#define NO_colors  4
#define NO_pairs   5
#define NO_ncv     6
#define NO_wsl     7
#define NO_btns    8

#define NO_Nb      9
#define NO_Nf      10


#define MAX_NUM  11

/* STRS */
#define NO_cbt         1
#define NO_bel         2
#define NO_cr          3
#define NO_csr         4
#define NO_tbc         5
#define NO_mgc         6
#define NO_clear       7
#define NO_el1         8
#define NO_el          9
#define NO_ed          10
#define NO_hpa         11
#define NO_cwin        12
#define NO_cup         13
#define NO_cud1        14
#define NO_home        15
#define NO_civis       16
#define NO_cub1        17
#define NO_cnorm       18
#define NO_cuf1        19
#define NO_ll          20
#define NO_cup1        21
#define NO_cvvis       22
#define NO_dl1         23
#define NO_dsl         24
#define NO_smacs       25
#define NO_blink       26
#define NO_bold        27
#define NO_smcup       28
#define NO_dim         29
#define NO_prot        30
#define NO_rev         31
#define NO_invis       32
#define NO_smso        33
#define NO_smul        34
#define NO_smxon       35
#define NO_ech         36
#define NO_rmacs       37
#define NO_sgr0        38
#define NO_rmcup       39
#define NO_rmso        40
#define NO_rmul        41
#define NO_rmxon       42
#define NO_ff          43
#define NO_fsl         44
#define NO_is1         45
#define NO_is2         46
#define NO_is3         47
#define NO_initc       48
#define NO_initp       49
#define NO_ich1        50
#define NO_il1         51
#define NO_oc          52
#define NO_op          53
#define NO_dch         54
#define NO_dl          55
#define NO_cud         56
#define NO_ich         57
#define NO_indn        58
#define NO_il          59
#define NO_cub         60
#define NO_cuf         61
#define NO_rin         62
#define NO_cuu         63
#define NO_rep         64
#define NO_rs1         65
#define NO_rs2         66
#define NO_rs3         67
#define NO_rc          68
#define NO_vpa         69
#define NO_sc          70
#define NO_ind         71
#define NO_ri          72
#define NO_sgr         73
#define NO_setb        74
#define NO_scp         75
#define NO_setf        76
#define NO_wind        77
#define NO_hw          78
#define NO_tsl         79
#define NO_uc          80
#define NO_xoffc       81
#define NO_xonc        82
#define NO_smsc        83
#define NO_rmsc        84
#define NO_getm        85
#define NO_kmous       86
#define NO_minfo       87
#define NO_reqmp       88
#define NO_scesc       89
#define NO_setab       90
#define NO_setaf       91

#define NO_rs	       92
#define NO_enacs       93
#define NO_smam        94
#define NO_rmam        95
#define NO_hts         96
#define NO_rmir        97
#define NO_dch1        98
#define NO_vt          99

#define NO_Cb   100
#define NO_Cf   101
#define NO_Cs   102
#define NO_Ce   103
#define NO_Ct   104
#define NO_Mb   105
#define NO_Mf   106
#define NO_g1   107
#define NO_g2   108
#define NO_sb   109
#define NO_ht   110
#define NO_cuu1 111

#define NO_smkx       112
#define NO_rmkx       113

#define NO_mc4	114
#define NO_mc5	115
#define NO_mc5p	116



#define MAX_STR  117

/* KEYS */
#define NO_ka1        0
#define NO_kb2        1
#define NO_ka3        2
#define NO_kc1        3
#define NO_kc3        4
#define NO_kbs        5
#define NO_kcbt       6
#define NO_kctab      7
#define NO_kdch1      8
#define NO_kcud1      9
#define NO_kf0        10
#define NO_kf1        11
#define NO_kf2        12
#define NO_kf3        13
#define NO_kf4        14
#define NO_kf5        15
#define NO_kf6        16
#define NO_kf7        17
#define NO_kf8        18
#define NO_kf9        19
#define NO_kf10       20
#define NO_kf11       21
#define NO_kf12       22
#define NO_kf13       23
#define NO_kf14       24
#define NO_kf15       25
#define NO_kf16       26
#define NO_kf17       27
#define NO_kf18       28
#define NO_kf19       29
#define NO_kf20       30
#define NO_kf21       31
#define NO_kf22       32
#define NO_kf23       33
#define NO_kf24       34
#define NO_kf25       35
#define NO_kf26       36
#define NO_kf27       37
#define NO_kf28       38
#define NO_kf29       39
#define NO_kf30       40
#define NO_kf31       41
#define NO_kf32       42
#define NO_kf33       43
#define NO_kf34       44
#define NO_kf35       45
#define NO_kf36       46
#define NO_kf37       47
#define NO_kf38       48
#define NO_kf39       49
#define NO_kf40       50
#define NO_kf41       51
#define NO_kf42       52
#define NO_kf43       53
#define NO_kf44       54
#define NO_kf45       55
#define NO_kf46       56
#define NO_kf47       57
#define NO_kf48       58
#define NO_kf49       59
#define NO_kf50       60
#define NO_kf51       61
#define NO_kf52       62
#define NO_kf53       63
#define NO_kf54       64
#define NO_kf55       65
#define NO_kf56       66
#define NO_kf57       67
#define NO_kf58       68
#define NO_kf59       69
#define NO_kf60       70
#define NO_kf61       71
#define NO_kf62       72
#define NO_kf63       73
#define NO_khome      74
#define NO_kich1      75
#define NO_kcub1      76
#define NO_kll        77
#define NO_knp        78
#define NO_kpp        79
#define NO_kcuf1      80
#define NO_kind       81
#define NO_kri        82
#define NO_khts       83
#define NO_kcuu1      84
#define NO_kclr      85

#define NO_acsc	     86


#define NO_kfnd	     87
#define NO_kbeg	     88
#define NO_kcan	     89
#define NO_kclo	     90
#define NO_kcmd	     91
#define NO_kcpy	     92
#define NO_kcrt	     93
#define NO_kend	     94
#define NO_kent	     95
#define NO_kext	     96

#define MAX_KEY  97

typedef struct Terminfo
{
	char *name;
	char bools[MAX_BOOL];
        int nums[MAX_NUM];
        short strings[MAX_STR];
        short keys[MAX_KEY];
        char *buf;
        int bufsize;
        int bufpos;
} Terminfo;

void init_Terminfo(Terminfo *tp);
void destroy_Terminfo(Terminfo *tp);

/* all references from *infos will be into *bufp (and *bufp will be realloc'ed) */
int read_tcap( int fnum, char **fnames, /* names of termcap files */
		int tnum, Terminfo *infos, char *errbuf, int errbuflen );

int read_tinfo( int fnum, char **fnames, /* names of terminfo root dirs */
		int tnum, Terminfo *infos, char *errbuf, int errbuflen  );

int read_term( int fnum, char **fnames, /* if first fname is a dir, use terminfo, else tcap */
		int tnum, Terminfo *infos, char *errbuf, int errbuflen  );

int read_tcapbuf( char *buf, Terminfo * info, char *Errbuf, int Errbuflen);


typedef struct
{
	const char *name;
	short no;
	char type;
}
TermcapBucket;

TermcapBucket *tgetentry(const char *name);

#endif
