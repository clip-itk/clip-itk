;Wide used commands definition

#IFDEF _CLIPPER_CH
	#BREAK
#ENDIF

//SET COMMANDS
__bSet:={|x| UPPER(LTRIM(x)) $ "ONÿ.T." }

#xcommand SET EXACT <x>		=> Set(1, EVAL(__bSet,"<x>"))

#xcommand SET DECIMALS TO <x>	=> Set(3, <x>)

#xcommand SET PATH TO <x>	=> Set(6, "<x>")

#xcommand SET DEFAULT TO <x>	=> Set(7, "<x>")

#xcommand SET CENTURY <x>	=> __SetCentury(EVAL(__bSet,"<x>")), _req:=2

#xcommand SET EPOCH TO <year>	=> Set(5, <year>), _req:=2
#xcommand SET DATE FORMAT TO <x> => Set(4, <x>), _req:=2
#xcommand SET DATE TO AMERICAN => Set(4, if(__SetCentury(), "mm/dd/yyyy", "mm/dd/yy"))
#xcommand SET DATE TO ANSI => Set(4, if(__SetCentury(), "yyyy.mm.dd", "yy.mm.dd"))
#xcommand SET DATE TO BRITISH => Set(4, if(__SetCentury(), "dd/mm/yyyy", "dd/mm/yy"))
#xcommand SET DATE TO FRENCH => Set(4, if(__SetCentury(), "dd/mm/yyyy", "dd/mm/yy"))
#xcommand SET DATE TO GERMAN => Set(4, if(__SetCentury(), "dd.mm.yyyy", "dd.mm.yy"))
#xcommand SET DATE TO ITALIAN => Set(4, if(__SetCentury(), "dd-mm-yyyy", "dd-mm-yy"))
#xcommand SET DATE TO JAPANESE => Set(4, if(__SetCentury(), "yyyy/mm/dd", "yy/mm/dd"))
#xcommand SET DATE TO USA => Set(4, if(__SetCentury(), "mm-dd-yyyy", "mm-dd-yy"))

#xcommand SET PRINTER TO <file> => Set(23, <file>)
#xcommand SET DELIMITERS TO <x> => Set(33, <x>)

#xcommand SET SOFTSEEK <x>	=> Set( 9, EVAL(__bSet,"<x>"))

#xcommand SET UNIQUE <x>	=> Set(10, EVAL(__bSet,"<x>"))

#xcommand SET DELETED <x>	=> Set(11, EVAL(__bSet,"<x>"))

#xcommand SET BELL <x>		=> Set(26, EVAL(__bSet,"<x>"))
#xcommand SET CONFIRM <x>	=> Set(27, EVAL(__bSet,"<x>"))
#xcommand SET ESCAPE <x>	=> Set(28, EVAL(__bSet,"<x>"))
#xcommand SET INTENSITY <x>	=> Set(31, EVAL(__bSet,"<x>"))

#xcommand SET COLOR TO <x>	=> _bm:=<x>, _req:=0

#xcommand RUN <x>	=> BliRun("<x>")

/***
* DB
*/

#xcommand USE NEW <file>=> DbUseArea(.T.,,"<file>",;
				     IF("<file>" < "A","_"+"<file>","<file>"),;
				     .T.),;
			   DbSelectArea("1")

#xcommand USE HERE <file>=> DbUseArea(.F.,,"<file>",;
				     IF("<file>" < "A","_"+"<file>","<file>"),;
				     .T.)

#xcommand USE <file>	=> _base:="<file>", _req:=0

#xcommand USE => DBCLOSEAREA()

#xcommand CLOSE <file>	=> <file>->(DBCLOSEAREA())

#xcommand SELECT <x>	=> DbSelectArea("<x>")

#xcommand SEEK <x>	=> dBSeek(<x>)

#xcommand FIND <x>	=> dBSeek("<x>")

#xcommand SOFTSEEK <x>	=> dBSeek(<x>, .T.)

#xcommand WILDSEEK <x>	=> DbGoTop(), SeekWild(.T., <x>)
#xcommand WILDSEEKNEXT <x>	=> SeekWild(.T., <x>)

#xcommand GOTO <x> => DbGoto(<x>)
#xcommand GO BOTTOM => DbGoBottom()
#xcommand GO TOP => DbGoTop()
#xcommand GO <x> => DbGoTo(<x>)

#xcommand APPEND BLANK => dbappend(),_req:=2

#xcommand PACK	=> PackProg()

#xcommand ZAP	=> Zap()

#xcommand DELETE => IF( TryRlock(), DbDelete(),)
#xcommand RECALL => IF( TryRlock(), DbRecall(),)
#xcommand INVERT => DBEval({||Rlock(), IF(DELE(),dbRecall(),dbDelete())})

#xcommand SUM TO <x> => SumFor(), <x>:=__sum

#xcommand SKIP <x>	=> DBSKIP(<x>)
#xcommand SKIP		=> DBSKIP()

#xcommand SET MEMOBLOCK TO <x> => Sx_SetMemoBlock(<x>)


/***
* MEMVAR variables
*/
#xcommand RELEASE ALL LIKE <skel> => __MRelease( "<skel>", .T. )
#xcommand RELEASE ALL EXCEPT <skel> => __MRelease( "<skel>", .F. )
#xcommand RELEASE ALL => __MRelease( "*", .T. )
#xcommand RELEASE <var> => __MxRelease( "<var>" )

/***
* SAVE / RESTORE SCREEN
*/
#xcommand SAVE SCREEN TO <var> => ScrSave(@<var>)
#xcommand SAVE SCREEN => ScrSave()
#xcommand RESTORE SCREEN FROM <var> => ScrRest(<var>)
#xcommand RESTORE SCREEN => ScrRest()


/***
* INDEXES and TAGS
*/

#xcommand SET INDEX ADDI TO <idx> => ordListAdd("<idx>")
#xcommand SET INDEX TO <idx> => ordListClear(); ordListAdd("<idx>")

#xcommand REINDEX => Reindex()

//variable TempFile should be defined for next 2 commands
#xcommand TEMPINDEX ON <key> => DbCreateIndex(TempFile, "<key>", Compile("<key>")),;
				_IndexFile:=TempFile,;
				_OldInd:=TempFile,;
				_req:=2

#xcommand TEMPINDEX UNIQ ON <key> => DbCreateIndex(TempFile, "<key>", Compile("<key>"), .T.),;
				_IndexFile:=TempFile,;
				_OldInd:=TempFile,;
				_req:=2


#xcommand SET TAGORDER TO <order> => ordSetFocus(<order>)
#xcommand CLEAR ORDER => ordSetFocus(0)
#xcommand SET TAG TO <tag> => ordSetFocus("<tag>")
#xcommand SET ORDER TO <xOrder> => ordSetFocus(<xOrder>)

#xcommand DELETE TAG ALL	=> Sx_KillTag(.T.)
#xcommand DELETE TAG <tag>	=> ordDestroy("<tag>")

/***
* RELATIONS
*/
#xcommand CLEAR RELATION => dbClearRel()

//always for area 2
#xcommand SET RELATION TO <key> =>;
	  dbClearRel(),;
	  dbSetRelation("2", Compile("<key>"), "<key>"),;
	  _req:=2

//always for key RelationKey
#xcommand SET RELATION INTO <alias> =>;
	  dbClearRel(),;
	  dbSetRelation("<alias>", Compile(RelationKey), RelationKey),;
	  _req:=2

#DEFINE _CLIPPER_CH
