#ifndef _CTKBD_DEFINED
#define _CTKBD_DEFINED

/********************* KBDSTAT(), TRAPSHIFT() *********************/

#define KST_RIGHTSHIFT	    1	// shift right	 pressed
#define KST_LEFTSHIFT	    2	// shift left	 pressed
#define KST_CTRL	    4	// ctrl 	 pressed anyhow
#define KST_ALT 	    8	// alt		 pressed anyhow
#define KST_SCROLLOCK	   16	// scroll-lock	 active
#define KST_NUMLOCK	   32	// num	 -lock	 active
#define KST_CAPSLOCK	   64	// caps  -lock	 active
#define KST_INSERT	  128	// insert-mode	 active
#define KST_LEFTCTRL	  256	// ctrl left	 pressed (only MF-2)
#define KST_LEFTALT	  512	// alt left	 pressed (only MF-2)
#define KST_RIGHTCTRL	 1024	// Ctrl right	 pressed (only MF-2)
#define KST_RIGHTALT	 2048	// Alt right	 pressed (only MF-2)
#define KST_SCROLL	 4096	// scroll-lock	 pressed (only MF-2)
#define KST_NUM 	 8192	// num	 -lock	 pressed (only MF-2)
#define KST_CAPS	16384	// caps  -lock	 pressed (only MF-2)
#define KST_SYSRQ	32768	// sysrequest	 pressed (only MF-2)
// CLIP extention
#define KST_NATKBD	131072  // nation keyboard actived


/******************* KBDSPEED() ******************
*
*  first parameter  : milli seconds delay
*/
#define KBD_DELAY_250	    0
#define KBD_DELAY_500	    1
#define KBD_DELAY_750	    2
#define KBD_DELAY_1000	    3

/*  second parameter : repitition rate */

#define KBD_RATE_MAX	    0	// 30 chars per second
#define KBD_RATE_MIN	   31	//  2 chars per second

#endif

