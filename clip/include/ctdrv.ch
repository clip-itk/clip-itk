#ifndef _CTDRV_DEFINED
#define _CTDRV_DEFINED

/******************* INPUTMODE() *******************/

#define IMODE_NO	   0	// no input field used
#define IMODE_WAIT	   1	// WAIT
#define IMODE_ACCEPT	   2	// ACCEPT
#define IMODE_INPUT	   3	// INPUT
#define IMODE_READ	   4	// READ
#define IMODE_MEMOEDIT	   5	// MEMOEDIT()
#define IMODE_MENU	   6	// MENU
#define IMODE_INKEY	   7	// INKEY()
#define IMODE_DEBUG	   8	// input of debugger
#define IMODE_GETINPUT	   9	// input within GETINPUT()
#define IMODE_GETSECRET   10	// input within GETSECRET()

#endif
