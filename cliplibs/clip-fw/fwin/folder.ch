#ifndef _FOLDER_CH
#define _FOLDER_CH

//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> FOLDER [<oFolder>] ;
	     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
	     [ <prm: PROMPT, PROMPTS, ITEMS> <cPrompt,...> ] ;
	     [ <dlg: DIALOG, DIALOGS, PAGE, PAGES> <cDlgName1> [,<cDlgNameN>] ] ;
	     [ <lPixel: PIXEL> ] ;
	     [ <lDesign: DESIGN> ] ;
	     [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
	     [ OPTION <nOption> ] ;
	     [ SIZE <nWidth>, <nHeight> ] ;
	     [ MESSAGE <cMsg> ] ;
       => ;
	  [<oFolder> := ] TFolder():New( <nRow>, <nCol>,;
	     [\{<cPrompt>\}], \{ <cDlgName1> [,<cDlgNameN>] \},;
	     <oWnd>, <nOption>, <nClrFore>, <nClrBack>, <.lPixel.>,;
	     <.lDesign.>, <nWidth>, <nHeight>, <cMsg> )

#xcommand REDEFINE FOLDER [<oFolder>] ;
	     [ ID <nId> ] ;
	     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
	     [ <prm: PROMPT, PROMPTS, ITEMS> <cPrompt,...> ] ;
	     [ <dlg: DIALOG, DIALOGS, PAGE, PAGES> <cDlgName1> [,<cDlgNameN>] ] ;
	     [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
	     [ OPTION <nOption> ] ;
	     [ ON CHANGE <uChange> ] ;
       => ;
	  [<oFolder> := ] TFolder():ReDefine( <nId>, [\{<cPrompt>\}],;
	     \{ <cDlgName1> [,<cDlgNameN>] \}, <oWnd>,;
	     <nOption>, <nClrFore>, <nClrBack>,;
	     [{|nOption,nOldOption| <uChange>}] )

//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> TABS [<oTabs>] ;
	     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
	     [ <prm: PROMPT, PROMPTS, ITEMS> <cPrompt,...> ] ;
	     [ <act: ACTION, EXECUTE> <uAction> ] ;
	     [ <lPixel: PIXEL> ] ;
	     [ <lDesign: DESIGN> ] ;
	     [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
	     [ OPTION <nOption> ] ;
	     [ TO <nBottom>, <nRight> ] ;
	     [ MESSAGE <cMsg> ] ;
       => ;
	  [<oTabs> := ] TTabs():New( <nRow>, <nCol>, <nBottom>, <nRight>,;
	     [\{<cPrompt>\}], [{|nOption|<uAction>}],;
	     <oWnd>, <nOption>, <nClrFore>, <nClrBack>, <.lPixel.>,;
	     <.lDesign.>, <cMsg> )

#xcommand REDEFINE TABS [<oTabs>] ;
	     [ ID <nId> ] ;
	     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
	     [ <prm: PROMPT, PROMPTS, ITEMS> <cPrompt,...> ] ;
	     [ <act: ACTION, EXECUTE> <uAction> ] ;
	     [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
	     [ OPTION <nOption> ] ;
       => ;
	  [<oTabs> := ] TTabs():ReDefine( <nId>, [\{<cPrompt>\}],;
	     [{|nOption|<uAction>}], <oWnd>, <nOption>, <nClrFore>, <nClrBack> )

//----------------------------------------------------------------------------//

#endif
