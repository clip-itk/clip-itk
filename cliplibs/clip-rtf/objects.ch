/*
Objects.ch
*/

#ifndef _OBJECTS_CH
#define _OBJECTS_CH

#define _FuncType_

#xtranslate ::      =>    Self:

#xcommand DEFAULT <uVar1> := <uVal1> [, <uVarN> := <uValN> ]      => ;
		<uVar1> := if(<uVar1> == NIL, <uVal1>, <uVar1>) ;
		[ ;; <uVarN> := if(<uVarN> == NIL, <uValN>, <uVarN>) ]

// Class Declaration

#xcommand CLASS <ClsNam>      => ;
	  function <ClsNam>()  ;;
	  local obj:=map() ;;
		obj:ClassName := _AsUpp_(<ClsNam>)

#xcommand CLASS <ClsNam>   ;
	    <from: INHERIT FROM, INHERIT, FROM, OF> <SupCls> [, <MoreSuper> ] ;
    => ;
	  function <ClsNam>()  ;;
	  local obj:=InHerit(_AsFunc_(<SupCls>)) ;;
		obj:ClassName := _AsUpp_(<ClsNam>)


// Declaraciones de Variables de Instancia

#xcommand DATA <Vol1> [, <VolN>] => ;
	obj:<Vol1> := NIL ;
	[ ;; obj:<VolN> := NIL ]


// Metodos declaracion  .
// =========================

#xcommand METHOD <Met> [, MetN] [ CONSTRUCTOR ] => ;
   obj:_AsName_(<Met>) := @_AsName_(<Met>)()

#xcommand METHOD <Met> [, MetN] VIRTUAL [<*x*>] => ;
	obj:_AsName( <Met> ) := \{|| \}

// Una GENIAL idea de Antonio Linares: La declaraci×n "SetGet"
#xcommand METHOD <Met> [, MetN] SETGET [<*x*>]  => ;
	obj:_AsName_(<Met> ) := _SETGET_ [<x>]

#xcommand METHOD <Met> [, MetN] <o: BLOCK, INLINE> <code,...> [ <scp: PUBLIC, EXPORT, LOCAL, HIDDEN> ] => ;
		obj:_AsName_(<Met> ) := _BlkTrans_(<Met> INLINE <code>)



// Traductores de descripciones de m÷todos.

#xtranslate _MetTrans_( <Met> [, MetN] ) => ;
	    _AsStr_( <Met> ), \{|| _AsName_( <Met> )() \}

#xtranslate _MetTrans_( <Met> = <udf> ) => ;
	    _AsStr_( <Met> ), \{|| _AsName_( <udf> )() \}

#xtranslate _MetTrans_( <Met>:_VIRTUAL_ ) => ;
	    _AsStr_( <Met> ), "_VIRTUAL_"

#xtranslate _MetTrans_( <Met>:_SETGET_ ) => ;
	    _AsStr_( <Met> ), \{|| _AsName_( <Met> )() \}, ;
	    "_" + _AsStr_( <Met> ), \{|| _AsName_( <Met> )() \}

#xtranslate _BlkTrans_( <Met> INLINE <code,...> ) => ;
	    \{ | Self | <code> \}

#xtranslate _BlkTrans_( <Met>( [<prm,...>] ) INLINE <code,...> ) => ;
	    \{ | Self [, <prm> ] | <code> \}

#xtranslate _BlkTrans_( <Met> BLOCK <code,...> ) => ;
	    _AsStr_( <Met> ), <code>



// Traductores Gen÷ricos de <Func>[ ( [ <parms,..> ] ) ]

#xtranslate _AsFunc_( <itm> )                   => <itm>()
#xtranslate _AsFunc_( <itm>( [<prm,...>] ) )    =>  <itm>( [<prm>] )

#xtranslate _AsName_( <itm> )                   => <itm>
#xtranslate _AsName_( <itm>( [<prm,...>] ) )    => <itm>

#xtranslate _AsParam_( <itm>() )                => (Self)
#xtranslate _AsParam_( <itm>( [<prm,...>] ) )   => (Self, [<prm>])


#xtranslate _AsStr_( <itm> )                    => <(itm)>
#xtranslate _AsStr_( <itm>( [<prm,...>] ) )     => #<itm>
#xtranslate _AsUpp_( <itm> )                    => upper( _AsStr_( <itm> ) )

#xtranslate _AsStrLst_( <Typ> [, <TypN> ] )     => ;
				    _AsStr_( <Typ> ) [, _AsStr_( <TypN> ) ]
#xtranslate _AsUppLst_( <Typ> [, <TypN> ] )     => ;
				    _AsUpp_( <Typ> ) [, _AsUpp_( <TypN> ) ]



#xcommand ENDCLASS  =>                                ;
		       return obj

#xcommand END CLASS  => ENDCLASS

// Declaraciones para el c×digo ( funci×n × procedimiento ) de los m÷todos.
// ==========================================================================

#xcommand METHOD <Met> [, MetN] CLASS <ClassN> =>;
	static function _AsName_(<Met> ) _AsParam_(<Met> )


/*
//   Sixtaxis Parent / Super
//   =======================

#xtranslate :Parent( <SupCls> ):<*M*> => :<SupCls>:<M>

#xtranslate :Parent:<*M*>             => :_sUPcLS_:<M>

#xtranslate Super:<*M*>               => Self:_sUPcLS_:<M>

#xtranslate :Super  => :Parent

//   Self
//  ======
*/
#endif  // _OBJECTS_CH

