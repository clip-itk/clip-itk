/*   Business graphics - defines                	     */
/*   Copyright (C) 2001  ITK                                 */
/*   Author  : Elena Kornilova (alena@itk.ru)                */
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html  */

#ifndef _BGGRAPH_DEFINED
#define _BGGRAPH_DEFINED

#define ZSTR(item)	alltrim(toString(item))

/* business graphic types */
#define BG_TYPE_HIST		1
#define BG_TYPE_HIST_CUMUL	2
#define BG_TYPE_HIST_NORM	3
#define BG_TYPE_HIST_3D 	4
#define BG_TYPE_LINE		5
#define BG_TYPE_LINE_CUMUL	6
#define BG_TYPE_LINE_NORM	7
#define BG_TYPE_CIRCLE		8
#define BG_TYPE_RING    	9

/* align legend for graphics */
#define BG_ALIGN_NONE	0
#define BG_ALIGN_TOP	1
#define BG_ALIGN_BOTTOM	2
#define BG_ALIGN_RIGHT	3
#define BG_ALIGN_LEFT	4


#define	BG_DEFX	500
#define	BG_DEFY	500

#define BG_DEF_WIDTH	30
#endif
