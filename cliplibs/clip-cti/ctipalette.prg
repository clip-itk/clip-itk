/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_PALETTE is a set of colors */

function cti_palette_new()
	local obj := map()

	obj:classname	:= "CTI_PALETTE"

	obj:AppWorkspace		:= "W/B"
	obj:Window			:= "BG/B"
	obj:ActiveBorder		:= "GR+/B"
	obj:ActiveCaption		:= "GR+/B"
	obj:InactiveBorder		:= "BG/B"
	obj:InactiveCaption		:= "BG/B"
	obj:Dialog			:= "W+/W"
	obj:DialogActiveBorder		:= "W+/W"
	obj:DialogActiveCaption		:= "W+/W"
	obj:DialogInactiveBorder	:= "N/W"
	obj:DialogInactiveCaption	:= "N/W"
	obj:Background			:= "W+/B"
	obj:Btn				:= "GR+/BG"
	obj:BtnHighLight		:= "GR+/B"
	obj:Menu			:= "N/BG"
	obj:ActiveMenu			:= "W+/N"
	obj:DisabledMenu		:= "W/BG"
	obj:MenuBorder			:= "N/BG"
	obj:WindowFrame			:= "N/W"
	obj:WindowText			:= "N/W"
	obj:Control			:= "N/BG"
	obj:ActiveControl		:= "W+/BG"
	obj:DisabledControl		:= "W/B"
	obj:Selection			:= "W+/G"
	obj:StatusBar			:= "N/W"
	obj:Label			:= "BG/B"
	obj:ListTitle			:= "N/BG"
	obj:DisabledRow			:= "BR/BG"
	obj:Shadow			:= "W/N"

	obj:FillChar			:= ""
//	obj:AppWorkspaceFill		:= "ê"
return obj

function cti_get_system_palette()
return cti_palette_new()
