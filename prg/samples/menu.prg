//#define TEST
/*
	menu demonstration
*/

   #include "button.ch"   // Menu definitions
   #include "inkey.ch"    // Key definitions


   local oInfo

   SET( _SET_EVENTMASK, INKEY_ALL )

   msetcursor(.T.)

   cls

   oInfo=MENU_Create()

   DO WHILE MenuModal(oInfo,1,24,1,79,"r/w") <> 999
   ENDDO

   return(NIL)



// This function will create the menu and return the newly created
// MenuObject as its return value.  This menu consists of three "Main Menu choices" ..
// File, Edit, and Options.  Additionally, the Edit TopBarMenu item has a secondary menu for
// one of its menu items.

function MENU_Create()
   local oTopBar, oPopUp, oPopUp1, oItem


      // TopBar() creates the menu at the very top of the screen
      oTopBar := TopBar( 0, 0, 79)
      oTopBar:ColorSpec :="b/w,gr+/rb,r/w,g/rb,n+/w,w+/b"


      // Create a new popup menu named FILE and add it to the TopBar object
      oPopUp := PopUp()
      oPopUp :ColorSpec:= "b/w,gr+/rb,r/w,g/rb,n+/w,w+/b"
      oTopBar:AddItem( MenuItem ( "&File",oPopUp) )


      // Add some menu items to the newly created File popup
      oItem :=MenuItem( "&New" ,{|| MyCreateFile() }, K_CTRL_N,"Create a new file", 101)
      oPopUp:AddItem( oItem)


      oItem :=MenuItem( "&Open..." ,{|| MyOpenFile() }, K_CTRL_O,"Open a file")
      oPopUp:AddItem( oItem)


      oItem :=MenuItem( "&Save" ,{|| MySaveFile() }, K_CTRL_S,"Save a file")

      // Disable this menu item
      oItem:Enabled := .f.
      oPopUp:AddItem( oItem)


      // Add a separator
      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )


      oItem :=MenuItem( "&Print..." ,{|| MyPrintFile() }, K_CTRL_P,"Print a file",HASH_Print)
      // Disable this menu item
      oItem:Enabled := .f.
      oPopUp:AddItem( oItem)


      // Another separator
      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )


      oItem :=MenuItem( "E&xit" ,{|| .t. }, K_ALT_F4,"End of application", 999)
      oPopUp:AddItem( oItem)


      // Create a second popup menu named EDIT and attach it to oTopBar
      oPopUp := PopUp()
      oPopUp :ColorSpec:= "b/w,gr+/rb,r/w,g/rb,n+/w,w+/b"
      oTopBar:AddItem( MenuItem ( "&Edit",oPopUp) )

      // Add some menu items to this EDIT popup menu
      oItem :=MenuItem( "&Undo" ,{|| MyUndo() }, K_CTRL_Z,"Reverse changes made to this file")
      oPopUp:AddItem( oItem)


      oItem :=MenuItem( "Cu&t" ,{|| MyCut() }, K_CTRL_X,"Cut to clipboard")
      oPopUp:AddItem( oItem)


      oItem :=MenuItem( "&Copy" ,{|| MyCopy() }, K_CTRL_C,"Copy to clipboard")
      oPopUp:AddItem( oItem)


      oItem :=MenuItem( "&Paste" ,{|| MyPaste() }, K_CTRL_V,"Paste from clipboard")
      oPopUp:AddItem( oItem)

      // Another separator
      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )


      // Create a new popup menu on the EDIT popup menu named Go.  (This is also
      // known as a "Cascading" menu.)
      oPopUp1 := PopUp()
      oPopUp1 :ColorSpec:= "b/w,gr+/rb,r/w,g/rb,n+/w,w+/b"
      oItem :=MenuItem( "&Go",oPopUp1 )

      oPopup:AddItem( oItem )

      // Add some items to the Go cascading menu
      oItem :=MenuItem( "&Go To..." ,{|| MyGoToLine() }, K_F5,"Go to a specific line number")
      oPopUp1:AddItem( oItem)


      oItem :=MenuItem( "G&o To Top" ,{|| MyGoTop() }, K_CTRL_HOME,"Go to top of file")
      oPopUp1:AddItem( oItem)


      oItem :=MenuItem( "Go To &Bottom" ,{|| MyGoBottom() }, K_CTRL_END,"Go to bottom of file")
      oPopUp1:AddItem( oItem)

      // Change the style of the GO popup menu.  The second character in
      // the string below represents the arrow that will be displayed next
      // to the word GO.  The default is a "", but I have changed it to
      // a ">".  I have kept the check mark ("âˆš") the same as the default.
      oItem :Style = "–>"

      // Add yet another separator
      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )


      // Add one final menu item to the EDIT popup menu
      oItem :=MenuItem( "&Find..." ,{|| MySearch() }, K_ALT_F3,"Search for text")
      oPopUp:AddItem( oItem)

      //Create a 3rd PopUpMenu called OPTIONS and attatch it to oTopBar
      oPopUp := PopUp()
      oPopUp :ColorSpec:= "b/w,gr+/rb,r/w,g/rb,n+/w,w+/b"
      oTopBar:AddItem( MenuItem ( "&Options",oPopUp) )


      oItem :=MenuItem( "AutoSave" ,{|| MyAutoSave() },,"Toggle auto save preference")
      oItem:Checked := .t.
      oPopUp:AddItem( oItem)
      oItem :=MenuItem( "Tab Stops..." ,{|| MyTabStops() },,"Set number of spaces for tab stops")
      oPopUp:AddItem( oItem)

   // Return our TopBar object back to MENU_Test()
   return ( oTopBar)


// The following are dummy functions which do not do anything
// These functions are here to avoid receiving Unresolved External
// Errors

FUNCTION MyCreateFile()
	alert("create file")
RETURN NIL

FUNCTION MyOpenFile()
RETURN NIL

FUNCTION MySaveFile()
RETURN NIL

FUNCTION MyPrintFile()
RETURN NIL

FUNCTION MyUndo()
RETURN NIL

FUNCTION MyCut()
RETURN NIL

FUNCTION MyCopy()
RETURN NIL

FUNCTION MyPaste()
RETURN NIL

FUNCTION MyGoToLine()
RETURN NIL

FUNCTION MyGoTop()
RETURN NIL

FUNCTION MyGoBottom()
RETURN NIL

FUNCTION MySearch()
RETURN NIL

FUNCTION MyAutoSave()
RETURN NIL

FUNCTION MyTabStops()
RETURN NIL
