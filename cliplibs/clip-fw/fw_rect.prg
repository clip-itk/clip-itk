/*   FiveWin likely classes					*/
/*   TRect							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/


static Selector := GetSelector()

function TRect()
local obj := map()

	obj:className	:= "FWIN_TRECT"
	obj:nTop	:= NIL
	obj:nLeft	:= NIL
	obj:nBottom	:= NIL
	obj:nRight	:= NIL

	_recover_FWIN_TRECT(obj)
return obj
*************
function _recover_FWIN_TRECT(obj)

	obj:New		:= @fw_New()
	obj:nWidth	:= { | self | ( self:nRight - self:nLeft + 1 ) }
	obj:nHeight	:= { | self | ( self:nBottom - self:nTop + 1 ) }

return obj
**************
static function fw_New( self, nTop, nLeft, nBottom, nRight )

	self:nTop    = nTop
	self:nLeft   = nLeft
	self:nBottom = nBottom
	self:nRight  = nRight

return Self
