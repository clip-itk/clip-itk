
******************************************************************
function TTime()

	local obj	:= map()
        obj:classname	:= "TTIME"
        obj:nTime	:= 0
        obj:new		:= @tt_new()
        obj:system	:= @tt_system()
        obj:addHours	:= @tt_addHours()
        obj:addMinutes	:= @tt_addMinutes()
        obj:addSeconds	:= @tt_addSeconds()
        obj:cAdd	:= @tt_add()
        obj:Add		:= @tt_add()
        obj:cSub	:= @tt_sub()
        obj:Sub		:= @tt_sub()
        obj:cGetTime	:= @tt_getTime()
        obj:getTime	:= @tt_getTime()
        obj:sysChange	:= @tt_sysChange()

return obj

******************************************************************
static function tt_New(self, nHours, nMinutes, nSeconds )
   DEFAULT nHours TO 0, nMinutes TO 0, nSeconds TO 0
   self:nTime = iIf( nHours != 0, nHours * 3600, 0 ) + ;
             iIf( nMinutes != 0, ( nMinutes * 60 ), 0 ) + nSeconds
   self:nTime %= 86400
return self
******************************************************************
static function tt_System(self)
   local cTime := Time()
   self:nTime = ( Val( SubStr( cTime, 1, 2 ) ) * 3600 ) + ;
             ( Val( SubStr( cTime, 4, 2 ) ) *   60 ) + ;
               Val( SubStr( cTime, 7, 2 ) )
return self
******************************************************************
static function tt_Add( nHours, nMinutes, nSeconds )
   local oTime := TTime():New( nHours, nMinutes, nSeconds )
   ::nTime += oTime:nTime
   ::nTime %= 86400
return ::GetTime()
******************************************************************
static function tt_Sub( nHours, nMinutes, nSeconds )
   local oTime
   if ValType( nHours ) == "N"
      oTime = TTime():New( nHours, nMinutes, nSeconds )
   else
      oTime = nHours
   endif
   ::nTime -= oTime:nTime
   ::nTime %= 86400
return ::GetTime()
******************************************************************
static function tt_GetTime()
   local nTemp    := ::nTime
   local nHours   := Int( nTemp / 3600 )
   local nMinutes := nTemp - ( nHours * 3600 )
   local nSeconds := nMinutes % 60
return StrZero( nHours, 2 ) + ":" + StrZero( Int( nMinutes / 60 ), 2 ) + ":" + ;
       StrZero( nSeconds, 2 )

******************************************************************
static function tt_SysChange()
return //SysTime( ::nTime )
******************************************************************
static function tt_AddHours( nHours )
return ::nTime += ( nHours * 3600 )
******************************************************************
static function tt_AddMinutes( nMinutes )
return ::nTime += ( nMinutes * 60 )
******************************************************************
static function tt_AddSeconds( nSeconds )
return ::nTime += nSeconds
******************************************************************

