// Using FiveWin browses for inline data capture

#include "fwin/FiveWin.ch"

//----------------------------------------------------------------//

function Main()

   local oDlg, oLbx

   USE ./data/data.dbf

   DEFINE DIALOG oDlg FROM 5,10 TO 24, 56 ;
      TITLE "Browse inline data capture"

   @  1, 0.50 LISTBOX oLbx FIELDS SIZE 175, 95  OF oDlg

   /*
   oLbx:lCellStyle = .t.
   oLbx:lAutoEdit  = .t.
   oLbx:lAutoSkip  = .t.
   */

   @ 12,  2 BUTTON "&Edit" OF oDlg SIZE 40, 12 ;
      ACTION MsgInfo()/*oLbx:Edit()*/

   @ 12, 10 BUTTON "&OK" OF oDlg SIZE 40, 12 ;
      ACTION oDlg:End() DEFAULT

   @ 12, 18 BUTTON "&Cancel" OF oDlg SIZE 40, 12 ;
      ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

return nil

//----------------------------------------------------------------//

procedure AppSys   //  XBase++ requirement

return
