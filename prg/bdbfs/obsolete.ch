/*
╒══════════════════════════════════════════════════════════════════════════╕
│ Source file: OBSOLETE.CH                                                 │█
│ Description: Conversions for obsolete SIx Driver functions.              │█
│ Notes      : This file is referenced by all of the other SIx Driver      │█
│              header files.                                               │█
│ Notice     : Copyright 1995 - SuccessWare 90, Inc.                       │█
╘══════════════════════════════════════════════════════════════════════════╛█
  ███████████████████████████████████████████████████████████████████████████
*/

#xtranslate Sx_IndexFilter( [<nOrder>] )           => OrdFor( [<nOrder>] )
#xtranslate Sx_TagName([<nOrder>])                 => iif( empty(alias()), "",OrdName([<nOrder>]))
#xtranslate Sx_TagOrder()                          => iif( empty(alias()), 0 ,OrdNumber() )
#xtranslate Sx_SetTagOrder( [<xOrder>] [,<cBag>] ) => Sx_SetTag( [<xOrder>] [,<cBag>]  )
#xtranslate Sx_SetTagOrd( [<xOrder>] [,<cBag>] )   => Sx_SetTag( [<xOrder>] [,<cBag>]  )
#xtranslate Sx_SetTagNo( [<xOrder>] )              => Sx_SetTag( [<xOrder>], iif(ordNumber()>0,ordBagName(),ordBagName(1)))
#xtranslate Sx_SetTagNo( <xOrder>, <cBag> )        => Sx_SetTag( <xOrder>, <cBag> )
#xtranslate _sxCondSet( [<params,...>] )           => OrdCondSet( [<params>] )
#xtranslate SetRDD( [<cRDDname>] )                 => RDDSetDefault( [<cRDDname>] )

