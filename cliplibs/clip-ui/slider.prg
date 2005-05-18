/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2005 by E/AS Software Foundation			   */
/*   Author: Igor Satsyuk <satsyuk@tut.by>        			   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

static driver := getDriver()

/* Layout class */
function UISlider( value, lower, upper, step )
	local obj

        default value to 0
        default lower to 0
        default upper to 100
        default step to 1
                
        obj := driver:createSlider( lower, upper, step )
        obj:className := "UISlider"
	driver:setValue( obj, value )

        obj:lower := lower
        obj:upper := upper
        obj:step  := step
        
	_recover_UISlider(obj)
return obj

function _recover_UISlider( obj )
	obj:setValue    := @ui_setValue()
	obj:getValue	:= @ui_getValue()
        obj:setRange    := @ui_setRange()
        obj:setStep     := @ui_setStep()
return obj

/* Set value */
static function ui_setValue(self, value)
	driver:setValue( self, value )
return NIL

/* Get value */
static function ui_getValue(self)
return driver:getValue( self )

static function ui_setRange(self, range)
        local lower, upper, nArr
        nArr := split(range, "-")
        if len(nArr) != 2
		return NIL
	endif
	lower := val(nArr[1])
        upper := val(nArr[2])
        self:lower := lower
        self:upper := upper
return driver:setSliderRange(self, lower, upper)

static function ui_setStep(self, step)
        self:step := val(step)
return driver:setSliderStep(self, self:step)
