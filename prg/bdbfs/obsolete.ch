/*
ีออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
ณ Source file: OBSOLETE.CH                                                 ณÛ
ณ Description: Conversions for obsolete SIx Driver functions.              ณÛ
ณ Notes      : This file is referenced by all of the other SIx Driver      ณÛ
ณ              header files.                                               ณÛ
ณ Notice     : Copyright 1995 - SuccessWare 90, Inc.                       ณÛ
ิออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพÛ
  ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
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

// SIx 2.0 Compatibity
#command SET DIRTYREAD ON                          => Sx_SetTurbo(.T.)
#command SET DIRTYREAD OFF                         => Sx_SetTurbo(.F.)
#xtranslate Sx_SetDirty( [<param>] )               => Sx_SetTurbo( [<param>] )
#xtranslate Sx_DirtyArea( [<param>] )              => Sx_TurboArea( [<param>] )
