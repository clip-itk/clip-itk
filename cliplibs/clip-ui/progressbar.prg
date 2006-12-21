/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library                                     */
/*                                                                         */
/*   Copyright (C) 2005 by E/AS Software Foundation                        */
/*   Author: Igor Satsyuk <satsyuk@tut.by>                                 */
/*                                                                         */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

static driver := getDriver()

/* ProgressBar class */
function UIProgressBar( text )
	local obj := driver:createProgressBar(text)

	obj:className := "UIProgressBar"
	_recover_UIPROGRESSBAR(obj)
return obj

function _recover_UIPROGRESSBAR( obj )
	obj:setValue 	:= @ui_setValue()
return obj

static function ui_setValue(self, percent, text)
	if valtype(percent) != 'N'
		percent := val(percent)
	endif
	if percent > 1 .and. percent < 100
		percent := percent/100
	endif
	if empty(text)
		text := ltrim(str(percent*100, 0)) + '%'
	endif
	driver:setProgressBarPercent(self, percent, text)
return .T.
