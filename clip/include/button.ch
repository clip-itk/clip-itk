#ifndef _BUTTON_DEFINED
#define _BUTTON_DEFINED

#define SCROLL_VERTICAL         1
#define SCROLL_HORIZONTAL       2

/*
#define MENU_SEPARATOR   translate_charset(__CHARSET__,host_charset(), "€")
#define SEPARATOR_DOUBLE translate_charset(__CHARSET__,host_charset(), "± µ" )
#define SEPARATOR_SINGLE translate_charset(__CHARSET__,host_charset(), "†€‡" )
#define SEPARATOR_DOUBLE_SINGLE translate_charset(__CHARSET__,host_charset(), "°€´" )
*/
#define MENU_SEPARATOR   translate_charset("cp437",host_charset(), chr(196))
#define SEPARATOR_DOUBLE translate_charset("cp437",host_charset(), chr(204)+chr(205)+chr(185) )
#define SEPARATOR_SINGLE translate_charset("cp437",host_charset(), chr(195)+chr(196)+chr(180))
#define SEPARATOR_DOUBLE_SINGLE translate_charset("cp437",host_charset(), chr(199)+chr(196)+chr(182))

/* hit test return value constants */

#define HTNOWHERE                0
#define HTTOPLEFT               -1
#define HTTOP                   -2
#define HTTOPRIGHT              -3
#define HTRIGHT                 -4
#define HTBOTTOMRIGHT           -5
#define HTBOTTOM                -6
#define HTBOTTOMLEFT            -7
#define HTLEFT                  -8

#define HTBORDERFIRST           -8
#define HTBORDERLAST            -1

#define HTCAPTION               -1025

#define HTCLIENT                -2049

#define HTSCROLLTHUMBDRAG       -3073
#define HTSCROLLUNITDEC         -3074
#define HTSCROLLUNITINC         -3075
#define HTSCROLLBLOCKDEC        -3076
#define HTSCROLLBLOCKINC        -3077

#define HTSCROLLFIRST           -3077
#define HTSCROLLLAST            -3073

#define HTDROPBUTTON            -4097
#define HTSEPARATOR             -4098

#define HTCELL                  -5121
#define HTHEADING               -5122
#define HTFOOTING               -5123
#define HTHEADSEP               -5124
#define HTFOOTSEP               -5125
#define HTCOLSEP                -5126

#define HTMENU                  -6145
#define HTSIZE			-6146
#define HTMINBUTTON             -6147
#define HTMAXBUTTON             -6148
#define HTGROWBOX		HTSIZE
#define HTREDUCE		HTMINBUTTON
#define HTZOOM			HTMAXBUTTON

#endif


/*€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€*/
