#ifndef _CTMISC_DEFINED
#define _CTMISC_DEFINED

/******************* DATATYPE() *******************/

#define TYPE_UNDEF	   0	// undefined
#define TYPE_STR	   1	// string
#define TYPE_NUM	   2	// numeric
#define TYPE_LOG	   4	// logical
#define TYPE_DATE	   8	// date
#define TYPE_ALIAS	  16	// alias
#define TYPE_MEMO	   1	// memo field
#define TYPE_WORD	 128	// 16-Bit word
#define TYPE_ARRAY	 544	// array
#define TYPE_BLOCK	4096	// codeblock


/******************** KBDTYPE() ********************/

#define KEYBOARD_PC	   0	// PC keyboard
#define KEYBOARD_AT	   1	// AT keyboard
#define KEYBOARD_MF2	   2	// enhanced keyboard (MF2) with 101/102 keys, F11, F12

#endif
