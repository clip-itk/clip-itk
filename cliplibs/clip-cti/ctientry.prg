/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_ENTRY - object, that use to edit data of variable types: N, C, L, D, M */

#include "cti.ch"
#include "cticontrol.ch"
#include "ctientry.ch"
#include "ctievents.ch"

#include "setcurs.ch"
#include "inkey.ch"

#define K_UNDO          K_CTRL_U

#define	SUPERCLASS	CTI_CONTROL

function cti_entry_new(VarType,Picture)
	local obj := cti_inherit(cti_control_new(),"CTI_ENTRY")

	obj:__getobj	:= nil
	obj:__block	:= nil
	obj:__var	:= nil
	obj:__vartype	:= VarType
	obj:__picture	:= Picture
	obj:__cursorPos	:= 1
	obj:__initialized	:= FALSE
	obj:__first_key	:= FALSE
	obj:__control_focused	:= FALSE

	obj:__real_draw		:= @cti_entry_real_draw()
	obj:__set_cursor	:= @cti_entry_set_cursor()
	obj:__set_color		:= @cti_entry_set_color()
	obj:__handle_event	:= @cti_entry_handle_event()
	obj:get_value		:= {|_obj|iif(.not. _obj:__initialized,nil,_obj:__var)}
	obj:set_value		:= @cti_entry_set_value()
	obj:__init		:= @cti_entry_init()
	obj:__make_buffer	:= @cti_entry_make_buffer()
	obj:__set_focus		:= @cti_entry_set_focus()

	obj:realize_real	:= @cti_entry_realize_real()

	obj:__initialized	:= obj:__init()
return obj

static function cti_entry_make_buffer(obj)
	CALL SUPER obj:__make_buffer()
	obj:__getobj:winbuffer := obj:__buffer
return

static function cti_entry_set_focus(obj)
	CALL SUPER obj:__set_focus()
	obj:__first_key := FALSE
return TRUE

static function cti_entry_set_cursor(obj)
	if obj:__initialized .and. ;
		obj:__abs_top!=nil .and. obj:__abs_left!=nil .and. ;
		obj:__abs_top>=0 .and. obj:__abs_top<=maxrow() .and. ;
                obj:__abs_left>=0 .and. obj:__abs_left<=maxcol()

		obj:__calc_abs_coords()
		setpos(obj:__abs_top,obj:__abs_left + obj:__getobj:cursorPos - 1)
		setcursor(SC_NORMAL)
	else
		CALL SUPER obj:__set_cursor()
		return FALSE
	endif
return TRUE

static function cti_entry_init(obj)
	local pic_default

	if .not. obj:__vartype $ "NLCDM"; return .F.; endif

	switch (obj:__vartype)
		case "N"
		obj:__var := 0

		case "C"
		obj:__var := space(10)

		case "L"
		obj:__var := .F.

		case "D"
		obj:__var := ctod("")

		case "M"
		obj:__var := ""
	end
	obj:__getobj := getNew(0,0,,,obj:__picture,obj:palette:Control+","+obj:palette:Control+","+obj:palette:ActiveControl)
	obj:__block:={|_1|local(_2:=@obj:__var), iif(_1==NIL,_2,_2:=_1)}
	obj:__getobj:block := obj:__block
	obj:__getobj:__firstKey := FALSE
	if obj:__getobj:picture!=nil
		if .not. "K" $ obj:__getobj:__flags
			obj:__getobj:picture := "@K"+iif("@"$+obj:__getobj:picture,""," ")+obj:__getobj:picture
			obj:__getobj:__flags += "K"
		endif
	endif
//	obj:set_size(0,0)
//	obj:__getobj:setfocus()
//	obj:__getobj:killfocus()
//	obj:set_size(1,obj:__getobj:__winlen)
	obj:signal_connect(HASH_CTI_LOST_FOCUS_SIGNAL,{|_obj,_sig|_obj:__getobj:assign()})
return TRUE

static function cti_entry_real_draw(obj)
	local color

	if .not. obj:__initialized; return .F.; endif

	if obj:__is_focused
		if obj:__first_key
			color := obj:Palette:ActiveControl
		else
			color := obj:Palette:Selection
			obj:__getobj:__firstKey := obj:__first_key
		endif
	else
		color := obj:Palette:Control
	endif
	if !obj:__is_enabled; color := obj:Palette:DisabledControl; endif

	if obj:__control_focused != obj:__is_focused
		if obj:__is_focused
			obj:__getobj:setfocus()
		else
			obj:__getobj:killfocus()
		endif
		obj:__control_focused := obj:__is_focused
	endif

	obj:__getobj:setcolor(color)
	obj:__getobj:display()
return .T.

static function cti_entry_realize_real(obj)
	local height, width

	if .not. obj:__initialized; return FALSE; endif

	height := obj:height; width := obj:width
	obj:set_size(0,0)
	obj:__getobj:setfocus()
	obj:__getobj:killfocus()
	height := iif(height==nil,1,height)
	width  := iif(width==nil,obj:__getobj:__winlen,width)
	obj:set_size(height,width)

	CALL SUPER obj:realize_real()
return TRUE

static function cti_entry_set_value(obj,value)
	local sig, old_value

	old_value := obj:__var
	obj:__var := value
	if .not. obj:__initialized; return .F.; endif
	obj:__getobj:reload()
	sig := cti_signal_new(HASH_CTI_CHANGED_SIGNAL)
	sig:old_value := old_value
	sig:value := obj:__var
	obj:signal_emit(sig)
	obj:draw_queue()
return .T.

static function cti_entry_handle_event(obj,event)
***********************************************
	local cKey, old_value, sig
	local not_changed := FALSE

	if .not. obj:__initialized; return .F.; endif
	if event:type != CTI_KEYBOARD_EVENT; return .F.; endif

//PROCEDURE GetApplyKey( oGet, nKey, GetList, oMenu, oMsg )
/*
   LOCAL cKey
   LOCAL bKeyBlock
   LOCAL MouseRow, MouseColumn
   LOCAL nButton
   LOCAL nHotItem
   LOCAL lSetKey

   IF "SETKEY" $ oget .and. !( ( bKeyBlock := oget:SETKEY( nKey ) ) == NIL )
      IF valtype( nKey:=eval( bKeyBlock, oGet, nKey ) ) != "N" .or. nkey == 0
	 RETURN
      ENDIF
   ENDIF

   IF !( ( bKeyBlock := SETKEY( nKey ) ) == NIL )
      IF ( lSetKey := GetDoSetKey( bKeyBlock, oGet ) )
	 RETURN
      ENDIF
   ENDIF

   IF ( !( GetList == NIL ) .AND. ;
	( ( nHotItem := Accelerator( GetList, nKey, oMsg ) ) != 0 ) )
      oGet:ExitState := GE_SHORTCUT
      oStatus:nextget  := nHotItem
      oStatus:lastexit := GE_SHORTCUT

   ELSEIF ( !( VALTYPE( oMenu ) == "O" ) )
   ELSEIF ( ( nHotItem := oMenu:GetAccel( nKey ) ) != 0 )
      oStatus:menuid := MenuModal( oMenu, nHotItem, ;
      oMsg:row, oMsg:left, oMsg:right, oMsg:color )
      nKey := 0

   ELSEIF ( IsShortCut( oMenu, nKey )  )
      nKey := 0

   ENDIF

   DO CASE
   CASE( nKey == K_UP )
      keyExit:=5
      if oGet:classname=="TEXTGET"
         oget:up()
      else
         oGet:exitState := GE_UP
      endif

   CASE( nKey == K_SH_TAB )
      keyExit:=5
      oGet:exitState := GE_UP

   CASE( nKey == K_DOWN )
      keyExit:=2
      if oGet:classname=="TEXTGET"
         oget:down()
      else
         oGet:exitState := GE_DOWN
      endif

   CASE( nKey == K_TAB )
      keyExit:=2
      oGet:exitState := GE_DOWN

   CASE( nKey == K_ENTER )
      keyExit:=15
      if oGet:classname=="TEXTGET"
         oget:insertLine()
      else
         oGet:exitState := GE_ENTER
      endif

   CASE( nKey == K_ESC )
      keyExit:=12
      IF ( SET( _SET_ESCAPE ) )
	 oGet:Undo()
	 oGet:exitState := GE_ESCAPE
      ENDIF

   CASE( nKey == K_PGUP )
      keyExit:=6
      if oGet:classname=="TEXTGET"
         oget:pgup()
      else
         oGet:exitState := GE_WRITE
      endif

   CASE( nKey == K_PGDN )
      keyExit:=7
      if oGet:classname=="TEXTGET"
         oget:pgdn()
      else
         oGet:exitState := GE_WRITE
      endif

   CASE( nKey == K_CTRL_HOME )
      keyExit:=15
      oGet:exitState := GE_TOP

#ifdef CTRL_END_SPECIAL
   CASE( nKey == K_CTRL_END )
      keyExit:=14
      oGet:exitState := GE_BOTTOM
#else
   CASE( nKey == K_CTRL_W )
      keyExit:=14
      oGet:exitState := GE_WRITE
#endif
   CASE( ( nKey == K_LBUTTONDOWN ) .OR. ( nKey == K_LDBLCLK ) )
      MouseRow    := mROW()
      MouseColumn := mCOL()

      IF ( !( VALTYPE( oMenu ) == "O" ) )
	 nButton := 0

      ELSEIF ( !( oMenu:ClassName() == "TOPBARMENU" ) )
	 nButton := 0

      ELSEIF ( ( nButton := oMenu:HitTest( MouseRow, MouseColumn ) ) != 0 )
	 oStatus:menuid := MenuModal( oMenu, nHotItem, ;  // Changed.
	 oMsg:row, oMsg:left, oMsg:right, oMsg:color )
	 nButton := 1

      ENDIF

      IF ( nButton != 0 )

      ELSEIF ( ( nButton := ;
	 oGet:HitTest( MouseRow, MouseColumn ) ) == HTCLIENT )

	 DO WHILE ( oGet:Col + oGet:Pos - 1 > MouseColumn )
	    oGet:Left()

	    IF oGet:typeOut
	       oGet:Home()
	       EXIT
	    ENDIF

	 ENDDO

	 DO WHILE ( oGet:Col + oGet:Pos - 1 < MouseColumn )
	    oGet:Right()

	    IF oGet:typeOut
	       oGet:End()
	       EXIT
	    ENDIF

	 ENDDO

      ELSEIF !( nButton == HTNOWHERE )
      ELSEIF ( !( GetList == NIL ) .AND. ;
	 HitTest( GetList, MouseRow, MouseColumn, oMsg ) != 0 )
	 oGet:exitstate := GE_MOUSEHIT
	 oStatus:lastexit := GE_MOUSEHIT
      ELSE
	 oGet:exitstate := GE_NOEXIT
      ENDIF

*/

//outlog(__FILE__,__LINE__,procname(),event:keycode, K_CTRL_T)

   DO CASE
   CASE( event:keycode == K_UNDO )
      obj:__getobj:Undo()

   CASE( event:keycode == K_HOME )
      obj:__getobj:Home()

   CASE( event:keycode == K_END )
      obj:__getobj:End()

   CASE( event:keycode == K_RIGHT )
      obj:__getobj:Right()

   CASE( event:keycode == K_LEFT )
      obj:__getobj:Left()

   CASE( event:keycode == K_CTRL_RIGHT )
      obj:__getobj:wordRight()

   CASE( event:keycode == K_CTRL_LEFT )
      obj:__getobj:wordLeft()

   CASE( event:keycode == K_BS )
      obj:__getobj:BackSpace()

   CASE( event:keycode == K_DEL )
      obj:__getobj:Delete()

   CASE( event:keycode == K_CTRL_T )
      obj:__getobj:delWordRight()

   CASE( event:keycode == K_CTRL_Y )
      obj:__getobj:delEnd()

   CASE( event:keycode == K_CTRL_BS )
      obj:__getobj:delWordLeft()

/*
   CASE( event:keycode == K_INS )
      SET( _SET_INSERT, !SET( _SET_INSERT ) )
      ShowScoreboard()
*/
   OTHERWISE
      IF ( event:keycode >= 32 .AND. event:keycode <= 255 )
	 cKey := CHR( event:keycode )
	 IF ( obj:__getobj:type == "N" .AND. ( cKey == "." .OR. cKey == "," ) )
	    obj:__getobj:toDecPos()
	 ELSE
	    IF ( SET( _SET_INSERT ) )
	       obj:__getobj:Insert( cKey )
	    ELSE
	       obj:__getobj:OverStrike( cKey )
	    ENDIF

	    IF ( obj:__getobj:typeOut )
	       IF ( SET( _SET_BELL ) )
		  ?? CHR(7)
	       ENDIF
/*
	       IF ( !SET( _SET_CONFIRM ) )
 	 	  keyExit:=15
		  obj:__getobj:exitState := GE_ENTER
	       ENDIF
*/
	    ENDIF
	 ENDIF
      else
      	not_changed := TRUE
      ENDIF
   ENDCASE
	if not_changed
		// nothing
	else
		obj:__first_key := TRUE
		obj:draw_queue()
	endif
	if obj:__getobj:changed
		old_value := obj:__getobj:varGet()
		obj:__var := obj:__getobj:unTransform()
		sig := cti_signal_new(HASH_CTI_CHANGED_SIGNAL)
		sig:old_value := old_value
		sig:value := obj:__var
		obj:signal_emit(sig)
	endif
return

static function cti_entry_set_color(obj,color)
	if .not. obj:__initialized; return .F.; endif
	obj:__getobj:color := color
return .T.

