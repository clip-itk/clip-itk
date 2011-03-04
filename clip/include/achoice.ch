#include "config.ch"

#ifndef _AC_DEFINED
#define _AC_DEFINED

#define AC_NONE_STRINGS [ None selected strings ]

/* code of user fuction messages */
#define AC_IDLE            0          /* Waiting for keystrokes               */
#define AC_HITTOP          1          /* attempt to move up beyond the list   */
#define AC_HITBOTTOM       2          /* attempt to move down beyond the list */
#define AC_EXCEPT          3          /* Unhandled key                        */
#define AC_NOITEM          4          /* There is no selected position        */

/* return code from user function */
#define AC_ABORT            0     /* Abort ACHOICE(), return 0                  */
#define AC_SELECT           1     /* "Choose current position, return number    */
#define AC_CONT             2     /* Continue ACHOICE()                         */
#define AC_GOTO             3     /* Go to the next position from the first     */
				  /* symbol with appropriate keystroke          */
#define AC_REDRAW           4     /* Re-Draw the ACHOICE() window. */

#endif

