/*   FiveWin likely functions for TMENU class			*/
/*   								*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   License : (GPL) http://www.itk.ru/clipper/licence.html	*/

#include <clip-gtk.ch>
#INCLUDE <fwin/FiveWin.ch>

#define MF_ENABLED	0	// Normal
#define MF_GRAYED	1	// Disabled and gray
#define MF_DISABLED	2	// Disabled and not gray
#define MF_BITMAP	4	// Single Bitmap
#define MF_CHECKED	8	// It marks of elect
#define MF_POPUP	16	// The item has menu associate popup
#define MF_BREAK	64	// Menu with several columns
#define MF_OWNERDRAW	256	// The item has own drawing
#define MF_SEPARATOR	2048	// Separador
#define MF_HELP 	16384	// Item to right of horizontal bar

static aMenuStack := {}
static aMenuAccel := {}
static oLastItem  := {}
static Selector	  := GetSelector()

function IsMenu(hItem)
outlog(__FILE__, __LINE__, gtk_WidgetGetTypeName(hItem))

return .f.
function CreateMenu(oMenu)
return eval(Selector:CreateMenu, oMenu)
**************
function CreatePopupMenu(self)
return eval(Selector:CreatePopupMenu, self)
***************
function GetSystemMenu(oWnd, lValue)
return eval(Selector:GetSystemMenu, oWnd, lValue)
**************
function TrackPopUp(hMenu, nFlags, nLeft, nTop, nReserved, hWnd)
local i

return eval(Selector:TrackPopup, hMenu, nFlags, nLeft, nTop, nReserved, hWnd)
*************
function AppendMenu(hMenu, oItem, nFlags, nId, cPrompt)

return eval(Selector:AppendMenu, hMenu, oItem, nFlags, nId, cPrompt)
*************
function MenuBegin(lPopup, lSystem, oWnd)
	FWInitDriver()
return eval(Selector:MenuBegin, lPopup, lSystem, oWnd)
***********
function MenuAddItem(cPrompt, cMsg, lChecked, lActive, bAction, cBmpFile, ;
			cResName, oMenu, bBlock, nVKState, nVirtKey, lHelp, nHelpId, bWhen, lBreak )

return eval(Selector:MenuAddItem, cPrompt, cMsg, lChecked, lActive, bAction, cBmpFile, ;
	    cResName, oMenu, bBlock, nVKState, nVirtKey, lHelp, nHelpId, bWhen, lBreak )
***************
function MenuEnd()
return eval(Selector:MenuEnd)
*****************
function SetMenu(oWnd, oMenu)
return eval(Selector:SetMenu, oWnd, oMenu)
*******************
function GetSubMenu(hMenu, hPopup)
return eval(Selector:GetSubMenu,hMenu, hPopup)
********************
function DrawMenuBar(hWnd)
return eval(Selector:DrawMenuBar, hWnd)
