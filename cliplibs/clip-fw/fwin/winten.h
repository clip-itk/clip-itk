#ifndef _WINTEN_H
#define _WINTEN_H

// WinTen.h - Is to avoid conflicts between Clipper and Windows API
// functions with names of 10 characters or less.

// If you are going to develop some new C function to conect the API,
// check that it is here, if length 10 characters or less, and include
// it here if not


#define	AbortDoc	_AbortDoc
#define	AddAtom		_AddAtom
#define	AnsiToOem	_AnsiToOem
#define AnsiLower       _AnsiLower
#define AnsiUpper       _AnsiUpper
#define Arc             _Arc
#define	AppendMenu	_AppendMenu
#define	BeginPaint	_BeginPaint
#define BitBlt          _BitBlt
#define	ChooseFont	_ChooseFont
#define	Chord		_Chord
#define ClassFirst      _ClassFirst
#define ClassNext       _ClassNext
#define CloseComm       _CloseComm
#define	CreateDC	_CreateDC
#define	CreateFont	_CreateFont
#define CreateIC        _CreateIC
#define CreateIcon      _CreateIcon
#define	CreateMenu	_CreateMenu
#define	CreatePen	_CreatePen
#define	DeleteDC	_DeleteDC
#define	DeleteAtom	_DeleteAtom
#define	DeleteMenu	_DeleteMenu
#define	DialogBox	_DialogBox
#define Dos3Call        _Dos3Call
#define DPtoLP          _DPtoLP
#define DragFinish      _DragFinish
#define DrawIcon        _DrawIcon
#define	DrawText	_DrawText
#define	Ellipse		_Ellipse
#define	EndDialog	_EndDialog
#define	EndDoc		_EndDoc
#define	EndPage		_EndPage
#define	EndPaint	_EndPaint
#define	Escape		_Escape
#define ExtTextOut      _ExtTextOut
#define FillRect        _FillRect
#define	FindAtom	_FindAtom
#define	FindText	_FindText
#define	FindWindow	_FindWindow
#define	FloodFill	_FloodFill
#define FlushComm       _FlushComm
#define FrameRect       _FrameRect
#define FrameRgn        _FrameRgn
#define	GetBkColor	_GetBkColor
#define	GetBkMode	_GetBkMode
#define GetCapture      _GetCapture
#define GetCursor       _GetCursor
#define	GetDC		_GetDC
#define	GetDCEx		_GetDCEx
#define	GetDCOrg	_GetDCOrg
#define	GetDIBits	_GetDIBits
#define	GetDlgItem	_GetDlgItem
#define	GetFocus	_GetFocus
#define GetMapMode      _GetMapMode
#define	GetMenu		_GetMenu
#define	GetMessage	_GetMessage
#define	GetObject	_GetObject
#define	GetParent	_GetParent
#define	GetPixel	_GetPixel
#define GetProp         _GetProp
#define GetROP2         _GetROP2
#define	GetSubMenu	_GetSubMenu
#define	GetVersion	_GetVersion
#define	GetWindow	_GetWindow
#define	GlobalFree	_GlobalFree
#define	GlobalLock	_GlobalLock
#define GlobalNext      _GlobalNext
#define	GlobalSize	_GlobalSize
#define	HideCaret	_HideCaret
#define	InsertMenu	_InsertMenu
#define	InvertRect	_InvertRect
#define	InvertRgn	_InvertRgn
#define	IsChild		_IsChild
#define	IsIconic	_IsIconic
#define	IsMenu		IsMenu_3_1	// _IsMenu
#define IsTask          _IsTask
#define IsWindow        _IsWindow
#define	IsZoomed	_IsZoomed
#define	KillTimer	_KillTimer
#define	LineTo		_LineTo
#define	LoadBitmap	_LoadBitmap
#define	LoadCursor	_LoadCursor
#define	LoadIcon	_LoadIcon
#define LoadMenu        _LoadMenu
#define	LoadString	_LoadString
#define LocalAlloc      _LocalAlloc
#define LocalFirst      _LocalFirst
#define LocalInfo       _LocalInfo
#define LocalInit       _LocalInit
#define LocalNext       _LocalNext
#define LPtoDP          _LPtoDP
#define LZClose         _LZClose
#define LZCopy          _LZCopy
#define LZOpenFile      _LZOpenFile
#define MAPILogoff      _MAPILogoff
#define MAPILogon       _MAPILogon
#define MemoryRead      _MemoryRead
#define MessageBox      _MessageBox
#define mmioClose       _mmioClose
#define mmioOpen        _mmioOpen
#define mmioRead        _mmioRead
#define mmioSeek        _mmioSeek
#define ModifyMenu      _ModifyMenu
#define ModuleNext      _ModuleNext
#define MoveTo          _MoveTo
#define	MoveWindow	_MoveWindow
#define	OemToAnsi	_OemToAnsi
#define OpenComm        _OpenComm
#define OpenIcon        _OpenIcon
#define OpenFile        _OpenFile
#define Pie             _Pie
#define	Polygon		_Polygon
#define	Polyline	_Polyline
#define	PrintDlg	_PrintDlg
#define PtInRect        _PtInRect
#define ReadComm        _ReadComm
#define Rectangle       _Rectangle
#define	ReleaseDC	_ReleaseDC
#define RemoveProp      _RemoveProp
#define ResetDC         _ResetDC
#define RoundRect       _RoundRect
#define	SetBkColor	_SetBkColor
#define	SetBkMode	_SetBkMode
#define SetCapture      _SetCapture
#define	SetCursor	_SetCursor
#define	SetFocus	_SetFocus
#define SetMapMode      _SetMapMode
#define SetMenu         _SetMenu
#define SetParent       _SetParent
#define SetPixel        _SetPixel
#define SetProp         _SetProp
#define	SetROP2		_SetROP2
#define	SetTimer	_SetTimer
#define ShellAbout      _ShellAbout
#define ShowCaret       _ShowCaret
#define ShowCursor      _ShowCursor
#define ShowWindow      _ShowWindow
#define StartDoc        _StartDoc
#define StartPage       _StartPage
#define StretchBlt      _StretchBlt
#define TaskFirst       _TaskFirst
#define TaskNext        _TaskNext
#define TaskSwitch      _TaskSwitch
#define TextOut         _TextOut
#define TimerCount      _TimerCount
#define UnionRect       _UnionRect
#define WinExec         _WinExec
#define WriteComm       _WriteComm
#define WinHelp         _WinHelp
#define Yield           _Yield
#define wsprintf        WSPRINTF

// Borland BIVBX10 Support

#define VBXMethod       _VBXMethod
#define VBXInit         _VBXInit
#define VBXTerm         _VBXTerm
#define VBXSetProp      _VBXSetProp
#define VBXGetProp      _VBXGetProp
#define VBXLoadVBX      _VBXLoadVBX
#define VBXSetMode      _VBXSetMode
#define VBXHelp         _VBXHelp
#define VBXCreate       _VBXCreate
#define VBXGetHctl      _VBXGetHctl
#define VBXGetHwnd      _VBXGetHwnd

// ODBC Support

#define SQLGetData      _SQLGetData
#define SQLExecute      _SQLExecute
#define SQLError        _SQLError
#define SQLBindCol      _SQLBindCol
#define SQLPutData      _SQLPutData
#define SQLFreeEnv      _SQLFreeEnv
#define ConnectDlg      _ConnectDlg
#define SQLCancel       _SQLCancel
#define SQLGetInfo      _SQLGetInfo
#define SQLPrepare      _SQLPrepare
#define SQLConnect      _SQLConnect
#define SQLTables       _SQLTables
#define SQLFetch        _SQLFetch
#define SQLColumns      _SQLColumns
#define SQLSetPos       _SQLSetPos

// ZIP management

#define IsZip           _IsZip
#define UnzipFile       _UnzipFile

#endif
