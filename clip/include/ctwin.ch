/*
	define symbols for function wbox()
*/

#ifndef _WB_DEFINED
#define _WB_DEFINED

#ifdef CLIP
*charset koi8-r
#endif

#define WB_DOUBLE_CLEAR 	 0     /* ¥ ¨ */
#define WB_SINGLE_CLEAR 	 1     /* ‚€ƒ */
#define WB_DOUBLE_SINGLE_CLEAR	 2     /* ¢ ¦ */
#define WB_SINGLE_DOUBLE_CLEAR	 3     /* ¤€§ */

#define WB_DOUBLE		 4     /* ¥ ¨ */
#define WB_SINGLE		 5     /* ‚€ƒ */
#define WB_DOUBLE_SINGLE	 6     /* ¢ ¦ */
#define WB_SINGLE_DOUBLE	 7     /* ¤€§ */

#define WB_HALF_FULL_CLEAR	 8     /* ‹ */

#define WB_HALF_CLEAR		 9     /* ‹ */

#define WB_FULL_HALF_CLEAR	10     /*  */

#define WB_FULL_CLEAR		11     /*  */

#define WB_HALF_FULL		12     /* ‹ */

#define WB_HALF 		13     /* ‹ */

#define WB_FULL_HALF		14     /*  */

#define WB_FULL 		15     /*  */

#ifdef __CLIP__

#define WB_0     translate_charset(__CHARSET__,host_charset(),"¥ ¨¡® «¡ ")
#define WB_1     translate_charset(__CHARSET__,host_charset(),"‚€ƒ…€„ ")
#define WB_2     translate_charset(__CHARSET__,host_charset(),"¢ ¦¬ © ")
#define WB_3     translate_charset(__CHARSET__,host_charset(),"¤€§¡­€ª¡ ")

#define WB_4     translate_charset(__CHARSET__,host_charset(),"¥ ¨¡® «¡" )
#define WB_5     translate_charset(__CHARSET__,host_charset(),"‚€ƒ…€„" )
#define WB_6     translate_charset(__CHARSET__,host_charset(),"¢ ¦¬ ©" )
#define WB_7     translate_charset(__CHARSET__,host_charset(),"¤€§¡­€ª¡" )

#define WB_8     translate_charset(__CHARSET__,host_charset(),"‹Œ ")

#define WB_9     translate_charset(__CHARSET__,host_charset(),"‹Œ ")

#define WB_10    translate_charset(__CHARSET__,host_charset()," ")

#define WB_11    translate_charset(__CHARSET__,host_charset()," ")

#define WB_12    translate_charset(__CHARSET__,host_charset(),"‹Œ")

#define WB_13    translate_charset(__CHARSET__,host_charset(),"‹Œ")

#define WB_14    translate_charset(__CHARSET__,host_charset(),"")

#define WB_15    translate_charset(__CHARSET__,host_charset(),"")

#endif

#endif
