#ifndef _PRINT_CH
#define _PRINT_CH

//----------------------------------------------------------------------------//
// Printer

#xcommand PRINT [ <oPrint> ] ;
             [ <name:TITLE,NAME,DOC> <cDocument> ] ;
             [ <user: FROM USER> ] ;
             [ <prvw: PREVIEW> ] ;
       => ;
          [ <oPrint> := ] PrintBegin( [<cDocument>], <.user.>, <.prvw.> )

#xcommand PRINTER [ <oPrint> ] ;
             [ <name:NAME,DOC> <cDocument> ] ;
             [ <user: FROM USER> ] ;
             [ <prvw: PREVIEW> ] ;
       => ;
          [ <oPrint> := ] PrintBegin( [<cDocument>], <.user.>, <.prvw.> )

#xcommand PAGE => PageBegin()

#xcommand ENDPAGE => PageEnd()

#xcommand ENDPRINT   => PrintEnd()
#xcommand ENDPRINTER => PrintEnd()

//----------------------------------------------------------------------------//

#endif
