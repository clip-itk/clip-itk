/* FiveWin style menu commands */

#include "button.ch"
#ifndef _MENU_DEFINED
#define _MENU_DEFINED

#xcommand MENU [ <oMenu> ]  [ <popup: POPUP> ] ;
       		=>  [ <oMenu> := ] iMenuBegin( <.popup.> )

#xcommand MENUITEM [ <oMenuItem> PROMPT ] [<cPrompt>] ;
             [ MESSAGE <cMsg> ] ;
             [ EVENT   <nEvent> ] ;
             [ <checked: CHECK, CHECKED, MARK> ] ;
             [ <enable: ENABLED, DISABLED> ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
             [ <resource: RESOURCE, RESNAME, NAME> <cResName> ] ;
             [ ACTION <uAction,...> ] ;
             [ BLOCK <bAction> ] ;
             [ <of: OF, MENU, SYSMENU> <oMenu> ] ;
             [ ACCELERATOR <nState>, <nVirtKey> ] ;
             [ <help: HELP> ] ;
             [ <HelpId: HELP ID, HELPID> <nHelpId> ] ;
       => ;
          [ <oMenuItem> := ] iMenuAddItem( <cPrompt>, <cMsg>,;
             <.checked.>, [ Upper(<(enable)>) == "ENABLED" ],;
             [\{|oMenuItem|<uAction>\}],;
             <cBmpFile>, <cResName>, <oMenu>, <bAction>, <nState>, <nVirtKey>,;
             <.help.>, <nHelpId>, , , <nEvent> )

#xcommand SEPARATOR => iMenuAddItem()

#xcommand ENDMENU => iMenuEnd()

#endif

