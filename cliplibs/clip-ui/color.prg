/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2003, 2004 by E/AS Software Foundation 	           */
/*   Author: Andrey Cherepanov <sibskull@mail.ru>			   */
/*   Last change: 27 Aug 2004						   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

/* UIColor class */
function UIColor( color, opacity )
        local r, g, b, o
	local obj := map()
	obj:className := "UIColor"
	color := iif(empty(color),"#000000",color)
	
	if left(color,1) != '#'
		obj = gdk_ColorParse(color)
	else
		o := iif(empty(opacity),255,opacity)
		r := cton(substr(color,2,2),16)
		g := cton(substr(color,4,2),16)
		b := cton(substr(color,6,2),16)
		obj:red   := iif(r==0,0,(r+1)*256-1)
		obj:green := iif(g==0,0,(g+1)*256-1)
		obj:blue  := iif(b==0,0,(b+1)*256-1)
		obj:opacity := iif(o==0,0,(o+1)*256-1)
	endif
return obj
