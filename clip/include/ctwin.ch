/*
	define symbols for function wbox()
*/

#ifndef _WB_DEFINED
#define _WB_DEFINED

#define WB_DOUBLE_CLEAR 	 0     /* •†® */
#define WB_SINGLE_CLEAR 	 1     /* ÇÄÉ */
#define WB_DOUBLE_SINGLE_CLEAR	 2     /* ¢†¶ */
#define WB_SINGLE_DOUBLE_CLEAR	 3     /* §Äß */

#define WB_DOUBLE		 4     /* •†® */
#define WB_SINGLE		 5     /* ÇÄÉ */
#define WB_DOUBLE_SINGLE	 6     /* ¢†¶ */
#define WB_SINGLE_DOUBLE	 7     /* §Äß */

#define WB_HALF_FULL_CLEAR	 8     /* çãç */

#define WB_HALF_CLEAR		 9     /* èãé */

#define WB_FULL_HALF_CLEAR	10     /* èçé */

#define WB_FULL_CLEAR		11     /* ççç */

#define WB_HALF_FULL		12     /* çãç */

#define WB_HALF 		13     /* èãé */

#define WB_FULL_HALF		14     /* èçé */

#define WB_FULL 		15     /* ççç */

#ifdef __CLIP__

#define __WB_0 chr(201)+chr(205)+chr(187)+chr(186)+chr(188)+chr(205)+chr(200)+chr(186)
#define WB_0     translate_charset("cp437",host_charset(),__WB_0+chr(32))
#define WB_4     translate_charset("cp437",host_charset(),__WB_0)
#define __WB_1 chr(218)+chr(196)+chr(191)+chr(179)+chr(217)+chr(196)+chr(192)+chr(179)
#define WB_1     translate_charset("cp437",host_charset(),__WB_1+chr(32))
#define WB_5     translate_charset("cp437",host_charset(),__WB_1)
#define __WB_2 chr(213)+chr(205)+chr(184)+chr(179)+chr(190)+chr(205)+chr(212)+chr(179)
#define WB_2     translate_charset("cp437",host_charset(),__WB_2+chr(32))
#define WB_6     translate_charset("cp437",host_charset(),__WB_2)
#define __WB_3 chr(214)+chr(196)+chr(183)+chr(186)+chr(189)+chr(196)+chr(211)+chr(186)
#define WB_3     translate_charset("cp437",host_charset(),__WB_3+chr(32))
#define WB_7     translate_charset("cp437",host_charset(),__WB_3)

#define __WB_8 chr(219)+chr(223)+chr(219)+chr(219)+chr(219)+chr(220)+chr(219)+chr(219)
#define WB_8     translate_charset("cp437",host_charset(),__WB_8+chr(32))
#define WB_12    translate_charset("cp437",host_charset(),__WB_8)
#define __WB_9 chr(222)+chr(223)+chr(221)+chr(221)+chr(221)+chr(220)+chr(222)+chr(222)
#define WB_9     translate_charset("cp437",host_charset(),__WB_9+chr(32))
#define WB_13    translate_charset("cp437",host_charset(),__WB_9)
#define __WB_10 chr(222)+chr(219)+chr(221)+chr(221)+chr(221)+chr(219)+chr(222)+chr(222)
#define WB_10    translate_charset("cp437",host_charset(),__WB_10+chr(32))
#define WB_14    translate_charset("cp437",host_charset(),__WB_10)
#define __WB_11 chr(219)+chr(219)+chr(219)+chr(219)+chr(219)+chr(219)+chr(219)+chr(219)
#define WB_11    translate_charset("cp437",host_charset(),__WB_11+chr(32))
#define WB_15    translate_charset("cp437",host_charset(),__WB_11)
#endif

#endif
