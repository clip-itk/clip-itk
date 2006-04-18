/*
   FiveWin-like menu commands.
*/

#include "imenu.ch"
#include "inkey.ch"

local oInfo

   SET( _SET_EVENTMASK, INKEY_ALL )

   msetcursor(.T.)

   cls
   set color to b/w,gr+/rb,r/w,g/rb,n+/w,w+/b

   oInfo=MENU_Create()

   DO WHILE MenuModal(oInfo,1,24,1,79,"r/w") <> 999
   ENDDO

****************************************************
function menu_create
	local omenu

   MENU oMenu
      MENUITEM "File"
      MENU
	 MENUITEM "Open"                        ;
	 ACTION alert("Open ?")                 ;
	 MESSAGE "Open file from disk"

	 MENUITEM "New "                        ;
	    ACTION alert("New ?")               ;
	    MESSAGE "Create new file"

	 SEPARATOR

	 MENUITEM "E&xit"                       ;
	    ACTION __quit()        ;
	    MESSAGE "End of Demonstration"

      ENDMENU

      MENUITEM "Options"
      MENU
	 MENUITEM "Tab size"                        ;
	 ACTION alert("New tab size ?")             ;
	 MESSAGE "set new tab size"

	 MENUITEM "Page size "
	 MENU
		MENUITEM "Page size 60"             ;
		ACTION alert("New page size 60?")   ;
		MESSAGE "Set new page size 60 lines"

		MENUITEM "Page size 65"             ;
		ACTION alert("New page size 65?")   ;
		MESSAGE "Set new page size 65 lines"

		MENUITEM "Page size 80"             ;
		ACTION alert("New page size 80?")   ;
		MESSAGE "Set new page size 80 lines"

	 ENDMENU

	 SEPARATOR

	 MENUITEM "Save options"                    ;
	    ACTION alert("save ?")                  ;
	    MESSAGE "save options to disk"
      ENDMENU
   ENDMENU

return omenu
