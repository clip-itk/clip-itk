#include "config.ch"

#ifndef _AC_DEFINED
#define _AC_DEFINED

#define AC_NONE_STRINGS [ None selected strings ]

/* code of user fuction messages */
#define AC_IDLE            0          /* Ожидание нажатия клавиш          */
#define AC_HITTOP          1          /* Попытка движения вверх за список */
#define AC_HITBOTTOM       2          /* Попытка движения вниз за список  */
#define AC_EXCEPT          3          /* Необрабатываемая клавиша         */
#define AC_NOITEM          4          /* Нет выбранной позиции            */

/* return code from user function */
#define AC_ABORT            0     /* Прервать ACHOICE(), вернуть 0              */
#define AC_SELECT           1     /* Выбрать текущую позицию, вернуть ее номер  */
#define AC_CONT             2     /* Продолжить ACHOICE()                       */
#define AC_GOTO             3     /* Перейти к следующей позиции с первой       */
				  /* буквой, соответствующей нажатой клавише    */
#define AC_REDRAW           4     /* Re-Draw the ACHOICE() window. */

#endif

