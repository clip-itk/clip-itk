/*   FiveWin likely classes					*/
/*   TMsgItem							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#include <fwin/FiveWin.ch>

static aTimers := {}
static nId     := 1
static Selector := GetSelector()

function TTimer()
local obj:=map()

	obj:className	:= "FWIN_TTIMER"
	obj:bAction	:= NIL
	obj:lActive	:= NIL
	obj:nId		:= NIL
	obj:nInterval	:= NIL
	obj:hWndOwner	:= NIL
	obj:Cargo	:= NIL

	_recover_FWIN_TTIMER(obj)

return obj
*****************
function _recover_FWIN_TTIMER(obj)

	obj:New		:= @fw_New()
	obj:Activate	:= @fw_Activate()
	obj:DeActivate	:= {|self| self:lActive := .f., eval(Selector:KillTimer, self:hWndOwner, self:nId )}
	obj:End		:= @fw_End()

return obj
******************
static function fw_New( self, nInterval, bAction, oWnd )

   DEFAULT nInterval := 18, bAction := { || nil }

   self:nInterval = nInterval
   self:bAction   = bAction
   self:nId       = nId++
   self:lActive   = .f.
   self:hWndOwner = If( oWnd != nil, oWnd:hWnd, eval(Selector:GetActiveWindow,) )

   AAdd( aTimers, Self )

return self
**************************
static function fw_Activate(self)
   //self:nId     = SetTimer( self:hWndOwner, self:nId, self:nInterval, 0 )
   self:nId     = eval(Selector:SetTimer, self:hWnd, self:nId, self:nInterval, 0 )
   self:lActive = .t.
return
*************************
static function fw_End(self)

   local nAt

   self:DeActivate()

   if ( nAt := AScan( aTimers, { | o | o == Self } )  ) != 0
      ADel( aTimers, nAt )
      ASize( aTimers, Len( aTimers ) - 1 )
   endif

return
**********************
function TimerEvent( self, nId )

   local nTimer := AScan( aTimers, { | oTimer | oTimer:nId == nId } )

   if nTimer != 0 .and. aTimers[ nTimer ]:lActive
      Eval( aTimers[ nTimer ]:bAction )
   endif

return 0
