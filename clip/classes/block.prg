
******************************************************************
function TBlock()

	local obj       := map()
	obj:classname   := "FBLOCK"
	obj:cExpression := NIL
	obj:bBlock      := NIL
	obj:new         := @block_new()            
	obj:eval        := @block_eval()
	obj:exec        := @block_eval()

return obj

******************************************************************
static function block_new(self, cExpression )

   if Type( cExpression ) $ "UEUI"
      MsgAlert( [Class TBlock constructor error:Invalid expression] )
   else
      self:cExpression = cExpression
      self:bBlock      = &( cExpression )
   endif

return self

******************************************************************
static function block_eval(p1,p2,p3,p4,p5,p6,p7,p8,p9)
	local ret:=NIL
	If ::bBlock != NIL
		ret:=Eval( ::bBlock,p1,p2,p3,p4,p5,p6,p7,p8,p9 )
	endif
return ret
