/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "config.ch"
#include "lang.ch"
/*
	Кто знает что тут еще должно быть
        напишите.
*/
/*
#define _GET_INSERT_ON   7     // "Ins"
#define _GET_INSERT_OFF  8     // "   "
#define _GET_INVD_DATE   9     // "Invalid Date"
#define _GET_RANGE_FROM  10    // "Range: "
#define _GET_RANGE_TO    11    // " - "
*/
/*******************************/
function  _NATMSGVER
   return [CLIPMSGS v1.0 04/Sep/02]

/*******************************/
function _DDATEFMT
   return [DD-MM-YYYY]

/*******************************/
function nationmsg(num)
local ret:=[Invalid argument]
	do case
        	case num==1
        	     ret=[Database Files    # Records    Last Update     Size]
         	case num==2
         	     ret=[Do you want more samples?]
         	case num=3
         	     ret=[Page No.]
         	case num==4
         	     ret=[** Subtotal **]
         	case num==5
         	     ret=[* Subsubtotal *]
         	case num==6
         	     ret=[*** Total ***]
		case num==7
                     ret:=[Ins]
		case num==8
                     ret:="   "
		case num==9
                     ret:=[Invalid date]
		case num==10
                     ret:=[Range: ]
		case num==11
                     ret:=" - "
		case num==12
                     ret:="Y/N"
        endcase
return ret


/*******************************/
function isAfFirm(str)
	static ss := [YyTtYy1] //upper(LANG_YES_CHAR)+"Y"
return ( left(str,1) $ ss )
/*******************************/
/*******************************/
function isNegative(str)
	static ss := [NnFfNn0] //upper(LANG_YES_CHAR)+"Y"
return ( left(str,1) $ ss )
