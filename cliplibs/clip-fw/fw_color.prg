/*   FiveWin likely functions					*/
/*   								*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#define COLOR_ACTIVEBORDER	10	// Active window border
#define COLOR_ACTIVECAPTION	2	// Active window title
#define COLOR_APPWORKSPACE	12	// Background color of MDI
#define COLOR_BACKGROUND	1	// Desktop
#define COLOR_BTNFACE		15	// Face shading on push buttons
#define COLOR_BTNHIGHTLIGHT	20	// Selected button in a control
#define COLOR_BTNSHADOW		16	// Edge shading on push buttons
#define COLOR_BTNTEXT		18	// Text on push buttons
#define COLOR_CAPTIONTEXT	9	// Text in title bar, size button, scroll-bar arrow button
#define COLOR_GRAYTEXT		17	// Grayed (dimmed) text
#define COLOR_HIGHTLIGHT	13	// Background of selected item in a control
#define COLOR_HIGHTLIGHTTEXT	14	// Text of selected item in a control
#define COLOR_INACTIVEBORDER	11	// Inactive window border
#define COLOR_INACTIVECAPTION	3	// Inactive window title
#define COLOR_INACTIVECAPTIONTEXT	19	// Color of text in an inactive title
#define COLOR_MENU		4	// Menu background
#define COLOR_MENUTEXT		7	// Text in menus
#define COLOR_SCROLLBAR		0	// Scroll-bar grey area
#define COLOR_WINDOW		5	// Window background
#define COLOR_WINDOWFRAME	6	// Window frame
#define COLOR_WINDOWTEXT	8	// Text in windows

#translate RGB( <nRed>, <nGreen>, <nBlue> ) => ;
	      ( <nRed> + ( <nGreen> * 256 ) + ( <nBlue> * 65536 ) )

*************
function GetSysColor(nTypeColor)
local nRGB
	do switch nTypeColor
	case COLOR_ACTIVEBORDER
		nRGB := RGB(0x55,0x55,0x55)
	case COLOR_ACTIVECAPTION
	case COLOR_APPWORKSPACE
	case COLOR_BACKGROUND
	case COLOR_BTNFACE
		nRGB := RGB(0xC0, 0xC0, 0xC0)
	case COLOR_BTNHIGHTLIGHT
		nRGB := RGB(0xDA, 0xDA, 0xDA)
	case COLOR_BTNSHADOW
		nRGB := RGB(0x88, 0x88, 0x88)
	case COLOR_BTNTEXT
		nRGB := RGB(0x00, 0x00, 0x00)
	case COLOR_CAPTIONTEXT
		nRGB := RGB(0xF0, 0xF0, 0xF0)
	case COLOR_GRAYTEXT
	case COLOR_HIGHTLIGHT
	case COLOR_HIGHTLIGHTTEXT
	case COLOR_INACTIVEBORDER
	case COLOR_INACTIVECAPTION
	case COLOR_INACTIVECAPTIONTEXT
	case COLOR_MENU
		nRGB := RGB(0x88, 0x88, 0x88)
	case COLOR_MENUTEXT
		nRGB := RGB(0x00, 0x00, 0x00)
	case COLOR_SCROLLBAR
	case COLOR_WINDOW
		nRGB := RGB(0xAA, 0xAA, 0xAA)
	case COLOR_WINDOWFRAME
	case COLOR_WINDOWTEXT
		nRGB := RGB(0x00, 0x00, 0x00)

	endswitch
return nRGB
