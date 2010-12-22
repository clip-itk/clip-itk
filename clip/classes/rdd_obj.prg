/*
    Copyright (C) 2001  ITK
    Author   : Alexey (alexey@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#ifdef _CHECK_HANDLE
  #define __CHECKING_HANDLE         if ::handle==NIL; return NIL; endif
#else
  #define __CHECKING_HANDLE
#endif

#include "rdd.ch"

#include "box.ch"
#include "Inkey.ch"
#include "Setcurs.ch"
#include "Error.ch"
#include "config.ch"
#include "dbedit.ch"


#define MY_HEADSEP      "†∂†" // utf-8: "‚ïê‚ï§‚ïê"
#define MY_COLSEP       " Å " // utf-8: " ‚îÇ "


function RDDNew(Driver,f_name,Shared,ReadOnly)
  local RDDobj

  RDDobj:=map()
// Attributes
  RDDobj:classname:="RDD"
  RDDobj:handle:=NIL
  RDDobj:table_driver:="DBF"		// Default name of tables driver
  RDDobj:index_driver:="NTX"		// Default name of indexes driver
  RDDobj:memo_driver:="DBT"		// Default name of menu-files driver
  RDDobj:share_mode:=RDD_SHARED		// Default tables opening mode
  RDDobj:read_only:=RDD_READ_WRITE	// Default tables opening mode
  RDDobj:soft_seek:=RDD_SEEK_SOFT	// Default search index mode
  RDDobj:search_result:=.f.    		// Result of last search

  _recover_RDD(RDDObj)

  if f_name<>NIL
    RDDobj:open(Driver,f_name,Shared,ReadOnly)
  endif
return RDDobj

function _recover_RDD(RDDObj)
// Methods
  RDDobj:append:=@rddobj_append()
  RDDobj:bof:=@rddobj_bof()
  RDDobj:browse:=@rddobj_browse()
  RDDobj:browse_StockBrowseNew:=@rddobj_browse_StockBrowseNew()
  RDDobj:browse_skipper:=@rddobj_browse_skipper()
  RDDobj:browse_FancyColors:=@rddobj_browse_FancyColors()
  RDDobj:clearindex:=@rddobj_clearindex()
  RDDobj:clearfilter:=@rddobj_clearfilter()
  RDDobj:close:=@rddobj_close()
  RDDobj:continue:=@rddobj_continue()
  RDDobj:create:=@rddobj_create()
  RDDobj:createindex:=@rddobj_createindex()
  RDDobj:creatememo:=@rddobj_creatememo()
  RDDobj:deleted:=@rddobj_deleted()
  RDDobj:delete:=@rddobj_delete()
  RDDobj:eof:=@rddobj_eof()
  RDDobj:fcount:=@rddobj_fcount()
  RDDobj:fieldname:=@rddobj_fieldname()
  RDDobj:fieldpos:=@rddobj_fieldpos()
  RDDobj:found:=@rddobj_found()
  RDDobj:getareafilter:=@rddobj_getareafilter()
  RDDobj:getvalue:=@rddobj_getvalue()
  RDDobj:gobottom:=@rddobj_gobottom()
  RDDobj:goto:=@rddobj_goto()
  RDDobj:gotokey:=@rddobj_gotokey()
  RDDobj:gotop:=@rddobj_gotop()
  RDDobj:indexkey:=@rddobj_indexkey()
  RDDobj:keyno:=@rddobj_keyno()
  RDDobj:lastkey:=@rddobj_lastkey()
  RDDobj:lastrec:=@rddobj_lastrec()
  RDDobj:locate:=@rddobj_locate()
  RDDobj:newfilter:=@rddobj_newfilter()
  RDDobj:open:=@rddobj_open()
  RDDobj:read:=@rddobj_read()
  RDDobj:recall:=@rddobj_recall()
  RDDobj:recno:=@rddobj_recno()
  RDDobj:reindex:=@rddobj_reindex()
  RDDobj:rlock:=@rddobj_rlock()
  RDDobj:runlock:=@rddobj_runlock()
  RDDobj:seek:=@rddobj_seek()
  RDDobj:setfilter:=@rddobj_setfilter()
  RDDobj:setindex:=@rddobj_setindex()
  RDDobj:setmemo:=@rddobj_setmemo()
  RDDobj:setorder:=@rddobj_setorder()
  RDDobj:setrelation:=@rddobj_setrelation()
  RDDobj:ordscope:=@rddobj_ordscope()
  RDDobj:setareafilter:=@rddobj_setareafilter()
  RDDobj:setscope:=@rddobj_setscope()
  RDDobj:setvalue:=@rddobj_setvalue()
  RDDobj:skip:=@rddobj_skip()
  RDDobj:struct:=@rddobj_struct()
  RDDobj:write:=@rddobj_write()
  RDDobj:zap:=@rddobj_zap()
// Destructor
  RDDobj:destroy:=@rddobj_destroy()
return RDDObj

static function rddobj_gotop()
  __CHECKING_HANDLE
return rddgotop(::handle)

static function rddobj_gobottom()
  __CHECKING_HANDLE
return rddgobottom(::handle)

static function rddobj_found()
return ::search_result

static function rddobj_fcount()		// Returns fields count
  __CHECKING_HANDLE
return rddfcount(::handle)

static function rddobj_fieldpos(FName)		// Returns index of specified field
  __CHECKING_HANDLE
return rddfieldpos(::handle,FName)

static function rddobj_fieldname(FNo)		// Returns field name by index
  __CHECKING_HANDLE
return rddfieldname(::handle,FNo)

static function rddobj_locate(Expr,While,nNext,nRec,lRest)	// Search in table
  __CHECKING_HANDLE
  ::search_result:=rddlocate(::handle,Expr,While,nNext,nRec,lRest)
return ::search_result

static function rddobj_continue()  		// Continue search
  __CHECKING_HANDLE
  ::search_result:=rddcontinue(::handle)
return ::search_result

static function rddobj_struct()  		// Returns table structure
  __CHECKING_HANDLE
return rddstruct(::handle)

static function rddobj_seek(Key,soft,last)
  __CHECKING_HANDLE
  soft:=iif(soft==nil,::soft_seek,soft)
  ::search_result:=rddseek(::handle,Key,soft,last)
return ::search_result

static function rddobj_goto(Rec)
  __CHECKING_HANDLE
return rddgoto(::handle,Rec)

static function rddobj_gotokey(Key)
  __CHECKING_HANDLE
return rddgotokey(::handle,Key)

static function rddobj_open(Driver,f_name,Shared,ReadOnly)
  if ::handle<>NIL; ::close(); endif
  Driver:=iif(Driver==nil,::table_driver,Driver)
  Shared:=iif(Shared==nil,::share_mode,Shared)
  ReadOnly:=iif(ReadOnly==nil,::read_only,ReadOnly)
  ::handle := rddusearea(Driver,f_name,Shared,ReadOnly)
return ::handle

static function rddobj_create(Driver,FName,Stru)
  ::handle := ::handle
  Driver:=iif(Driver==nil,::table_driver,Driver)
return rddcreate(Driver,FName,Stru)

static function rddobj_creatememo(Driver,Name)
  ::handle := ::handle
  Driver:=iif(Driver==nil,::memo_driver,Driver)
return rddcreatememo(Driver,Name)

static function rddobj_zap()
  __CHECKING_HANDLE
return __rddzap(::handle)

static function rddobj_close()
	local ret
  	ret:=iif(::handle<>NIL,rddclosearea(::handle),NIL)
  	::handle:=NIL
  	::search_result:=.f.
return ret

static function rddobj_read()
  __CHECKING_HANDLE
return rddread(::handle)

static function rddobj_write(Rec)
  __CHECKING_HANDLE
return rddwrite(::handle,Rec)

static function rddobj_append(Rec)
  __CHECKING_HANDLE
return rddappend(::handle,Rec)

static function rddobj_recno()
  __CHECKING_HANDLE
return rddrecno(::handle)

static function rddobj_keyno()
  __CHECKING_HANDLE
return rddkeyno(::handle)

static function rddobj_lastrec()
  if ::handle==NIL; return 0; endif
return rddlastrec(::handle)

static function rddobj_lastkey()
  __CHECKING_HANDLE
return rddlastkey(::handle)

static function rddobj_eof()
  if ::handle==NIL; return .t.; endif
return rddeof(::handle)

static function rddobj_bof()
  if ::handle==NIL; return .t.; endif
return rddbof(::handle)

static function rddobj_skip(Recs)
  __CHECKING_HANDLE
return rddskip(::handle,Recs)

static function rddobj_setindex(Driver,Name,Tag)
  __CHECKING_HANDLE
  Driver:=iif(Driver==nil,::index_driver,Driver)
return rddsetindex(::handle,Driver,Name,Tag)

static function rddobj_setmemo(Driver,Name)
  __CHECKING_HANDLE
  Driver:=iif(Driver==nil,::memo_driver,Driver)
return rddsetmemo(::handle,Driver,Name)

static function rddobj_setrelation(Child,Expr)
  __CHECKING_HANDLE
return rddsetrelation(::handle,Child:handle,Expr)

static function rddobj_setorder(Order)
  __CHECKING_HANDLE
return rddsetorder(::handle,Order)

static function rddobj_ordscope(nScope, Val)
  __CHECKING_HANDLE
return rddordscope(::handle,nScope,Val)

static function rddobj_setscope(ScopeTop, ScopeBot)
  __CHECKING_HANDLE
	if ScopeBot==nil; ScopeBot := ScopeTop; endif
	rddordscope(::handle,0,ScopeTop)
	rddordscope(::handle,1,ScopeBot)
return

static function rddobj_setfilter(Filter)
  __CHECKING_HANDLE
return rddsetfilter(::handle,Filter)

static function rddobj_clearfilter()
  __CHECKING_HANDLE
return rddclearfilter(::handle)

static function rddobj_newfilter(Filter)
  __CHECKING_HANDLE
return rddnewfilter(::handle,Filter)

static function rddobj_setareafilter(nFilter)
  __CHECKING_HANDLE
return rddsetareafilter(::handle,nFilter)

static function rddobj_getareafilter()
  __CHECKING_HANDLE
return rddgetareafilter(::handle)

static function rddobj_delete()
  __CHECKING_HANDLE
return rdddelete(::handle)

static function rddobj_deleted()
  __CHECKING_HANDLE
return rdddeleted(::handle)

static function rddobj_recall()
  __CHECKING_HANDLE
return rddrecall(::handle)

static function rddobj_createindex(Driver,Name,Tag,Expr,Unique)
  __CHECKING_HANDLE
  Driver:=iif(Driver==nil,::index_driver,Driver)
return rddcreateindex(::handle,Driver,Name,Tag,Expr,Unique)

static function rddobj_reindex()
  __CHECKING_HANDLE
return rddreindex(::handle)

static function rddobj_clearindex()
  __CHECKING_HANDLE
return rddclearindex(::handle)

static function rddobj_getvalue(cField)
  __CHECKING_HANDLE
return rddgetvalue(::handle,cField)

static function rddobj_setvalue(cField,V)
  __CHECKING_HANDLE
return rddsetvalue(::handle,cField,V)

static function rddobj_indexkey()
  __CHECKING_HANDLE
return rddindexkey(::handle)

static function rddobj_rlock(nRecNo,lRelease)
  __CHECKING_HANDLE
return rddrlock(::handle, nRecNo, lRelease)

static function rddobj_runlock(nRecNo)
  __CHECKING_HANDLE
return rddrlock(::handle, nRecNo)

static function rddobj_destroy()
  if ::handle<>NIL; ::close(); endif
return

*****************************************

static function rddobj_browse(self,top, left, down, right, fields, user_func, picts, headers, hsep,csep,fsep, footers)

    LOCAL bSaveHandler, error, status
    LOCAL browser                       // The TBrowse object
    LOCAL cColorSave, nCursSave         // State preservers
    LOCAL nKey                          // Keystroke
    LOCAL lMore                         // Loop control
    LOCAL cScreen, __user_func,ret

    top  := iif( top  == NIL, 0, top )
    left := iif( left == NIL, 0, left )
    down  := iif( down  == NIL, maxrow(), down )
    right:= iif( right== NIL, maxcol() , right )
    top=max(top,0)
    left=max(left,0)
    down=min(down,maxrow())
    right=min(right,maxcol())

    cScreen := SAVESCREEN()
    nCursSave := SetCursor(SC_NONE)

    browser := TBrowseDB(Top, Left, Down, Right)
    self:browse_StockBrowseNew(browser, fields, headers, footers, picts, hsep, csep, fsep )
    browser:skipBlock := { |x| self:browse_skipper(x, browser) }
    browser:headSep := MY_HEADSEP
    browser:colSep := MY_COLSEP
    self:browse_FancyColors(browser)
    lMore := .T.
    DO WHILE lMore
        IF browser:colPos <= browser:freeze
            browser:colPos := browser:freeze + 1
        ENDIF

        nKey := 0
        DO WHILE nKey == 0 .AND. .NOT. browser:stable
            browser:stabilize()
            nKey := InKey()
        ENDDO

        IF browser:stable
                IF browser:hitTop .OR. browser:hitBottom
                    TONE(125, 0)
                ENDIF
                browser:refreshCurrent()
                browser:ForceStable()
                nKey := InKey(0)
        ENDIF

        IF empty(user_func) .and. (nKey == K_ESC .or. nkey==K_ENTER)
            lMore := .F.
        ELSE
            ApplyKey(browser, nKey)
            if empty(user_func)
               loop
            endif
            status:=DE_IDLE
            if self:lastrec()==0
               status:=DE_EMPTY
            endif
            if browser:hitTop
               status:=DE_HITTOP
            endif
            if browser:hitBottom
               status:=DE_HITBOTTOM
            endif
            // DE_EXCEPT           4          // Key don't handled
            if "(" $ user_func
                __user_func:=user_func
            else
                __user_func:=user_func+"("+alltrim(str(status))+","+alltrim(str(browser:colPos))+")"
            endif
            ret=&__user_func
            if ret==DE_ABORT
               lmore:=.f.
            endif
            if ret==DE_REFRESH
               browser:refreshAll()
            endif
        ENDIF
    ENDDO

    SETCURSOR(nCursSave)
    RESTSCREEN(,,,,cScreen)

return  NIL

static function rddobj_browse_skipper(n, browse)
    LOCAL i
    i := 0
    IF n == 0 .OR. ::lastrec() == 0
        ::SKIP(0)
    ELSEIF n > 0 .and. ::RECNO() != ::lastrec() + 1
        DO WHILE i < n
            ::SKIP(1)
            IF ( ::EOF() )
                ::SKIP(-1)
                EXIT
            ENDIF
            i++
        ENDDO
    ELSEIF n < 0
        DO WHILE i > n
            ::SKIP(-1)
            IF ( ::BOF() )
                EXIT
            ENDIF
            i--
        ENDDO
    ENDIF
RETURN i

STATIC PROCEDURE ApplyKey(browse, nKey)
    local status
    DO CASE
    CASE nKey == K_DOWN
        browse:down()
    CASE nKey == K_PGDN
        browse:pageDown()
    CASE nKey == K_CTRL_PGDN
        browse:goBottom()
    CASE nKey == K_UP
        browse:up()
    CASE nKey == K_PGUP
        browse:pageUp()
    CASE nKey == K_CTRL_PGUP
        browse:goTop()
    CASE nKey == K_RIGHT
        browse:right()
    CASE nKey == K_LEFT
        browse:left()
    CASE nKey == K_HOME
        browse:home()
    CASE nKey == K_END
        browse:end()
    CASE nKey == K_CTRL_LEFT
        browse:panLeft()
    CASE nKey == K_CTRL_RIGHT
        browse:panRight()
    CASE nKey == K_CTRL_HOME
        browse:panHome()
    CASE nKey == K_CTRL_END
        browse:panEnd()
    OTHERWISE
    ENDCASE
RETURN

STATIC PROCEDURE rddobj_browse_FancyColors(self,browse)
    LOCAL n, column
    LOCAL xValue

    browse:colorSpec := setcolor()
    if empty(browse:colorSpec)
         browse:colorSpec := "N/W, N/BG, B/W, B/BG, B/W, B/BG, R/W, B/R"
    else
         browse:colorSpec := setcolor()+", N/W, N/BG, B/W, B/BG, B/W, B/BG, R/W, B/R"
    endif
    FOR n := 1 TO browse:colCount
        column := browse:getColumn(n)
        xValue := EVAL(column:block)

        IF VALTYPE(xValue) != "N"
            column:defColor := {3, 4}
        ELSE
            column:colorBlock := {|x| if( x < 0, {7, 8}, {5, 6} )}
            column:defColor := {7, 8}
        ENDIF
    NEXT
RETURN

static function rddobj_browse_StockBrowseNew(self,browse, fields, headers, footers, picts, hsep, csep, fsep )
    LOCAL n, column, cType, strhead, strfoot, col_block, astru, i
    local strpict, strhsep, strcsep, strfsep

    if empty( fields )
      astru := self:struct()
      fields:=array(len(astru))
      i:=1; aeval(astru,{|x|fields[i++]:=x[1]})
    endif
    if empty(headers); headers:={}; endif
    if empty(footers); footers:={}; endif
    if empty(picts); picts:=array(len(fields)); endif
    if empty(hsep); hsep:=array(len(fields)); endif
    if empty(csep); csep:=array(len(fields)); endif
    if empty(fsep); fsep:=array(len(fields)); endif
    if valtype(picts)=="C"
       strpict=picts
       picts:={}
       asize(picts,len(fields))
       afill(picts,strpict)
    endif
    if valtype(picts)=="A"
       for n = len(picts)+1 to len(fields)
           aadd(picts,nil)
       next
    endif
    if valtype(headers)=="C"
       strhead=headers
       headers:={}
       asize(headers,len(fields))
       afill(headers,strhead)
    endif
    if valtype(headers)=="A"
       for n = len(headers)+1 to len(fields)
           aadd(headers,fields[n])
       next
    endif
    if valtype(footers)=="C"
       strfoot=footers
       footers:={}
       asize(footers,len(fields))
       afill(footers,strfoot)
    endif
    if valtype(footers)=="A"
       for n = len(footers)+1 to len(fields)
           aadd(footers,"")
       next
    endif
    if valtype(hsep)=="C"
       strhsep=hsep; hsep:=array(len(fields)); afill(hsep,strhsep)
    endif
    if valtype(csep)=="C"
       strcsep=csep; csep:=array(len(fields)); afill(csep,strcsep)
    endif
    if valtype(fsep)=="C"
       strhsep=fsep; fsep:=array(len(fields)); afill(fsep,strfsep)
    endif
    FOR n := 1 TO len(fields)
        if valtype(fields[n])=="C"
          col_block:="{|| __rdd__ "+alltrim(str(self:handle))+" "+fields[n]+" __rdd__}"
          col_block:=&col_block
        else
          col_block:=fields[n]
        endif
        //column := TBColumnNew(Field(n), FieldWBlock(Field(n), Select()))
        column := TBColumnNew(fields[n], col_block)
        column:heading:=headers[n]
        column:footing:=footers[n]
        column:picture:=picts[n]
        column:headSep:=hsep[n]
        column:colSep:=csep[n]
        column:footSep:=fsep[n]
        browse:addColumn(column)
    next
RETURN NIL



