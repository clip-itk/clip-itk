#ifndef _BOX_DEFINED
#define _BOX_DEFINED

#ifndef __NO_PGCH__

#include <pgch.ch>
#define B_SINGLE PGCH_B_SINGLE
#define B_DOUBLE PGCH_B_DOUBLE

#else

/*
#define B_SINGLE translate_charset(__CHARSET__,host_charset(),'ÇÄÉÅÖÄÑÅ')
#define B_DOUBLE translate_charset(__CHARSET__,host_charset(),'•†®°Æ†´°')
*/
/*
#define B_SINGLE 'ÇÄÉÅÖÄÑÅ'
#define B_DOUBLE '•†®°Æ†´°'
*/

#define	__B_SINGLE ( CHR(218) + CHR(196) + CHR(191) + CHR(179) + ;
                     CHR(217) + CHR(196) + CHR(192) + CHR(179)   )

#define __B_DOUBLE ( CHR(201) + CHR(205) + CHR(187) + CHR(186) + ;
                     CHR(188) + CHR(205) + CHR(200) + CHR(186)   )

#define B_SINGLE translate_charset("cp866",host_charset(),__B_SINGLE)
#define B_DOUBLE translate_charset("cp866",host_charset(),__B_DOUBLE)

#endif

/*
#define B_SINGLE_DOUBLE	translate_charset(__CHARSET__,host_charset(),'¢†¶Å¨†©Å')

#define	B_DOUBLE_SINGLE	translate_charset(__CHARSET__,host_charset(),'§Äß°≠Ä™°')
*/

#define __B_SINGLE_DOUBLE ( CHR(214) + CHR(196) + CHR(183) + CHR(186) + ;
                            CHR(189) + CHR(196) + CHR(211) + CHR(186)   )

#define	__B_DOUBLE_SINGLE ( CHR(213) + CHR(205) + CHR(184) + CHR(179) + ;
                            CHR(190) + CHR(205) + CHR(212) + CHR(179)   )

#define B_SINGLE_DOUBLE translate_charset("cp866",host_charset(),__B_SINGLE_DOUBLE)
#define B_DOUBLE_SINGLE translate_charset("cp866",host_charset(),__B_DOUBLE_SINGLE)

#endif
