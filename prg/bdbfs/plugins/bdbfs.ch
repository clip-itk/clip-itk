;bdbfs specific commands and definitions
#IFDEF _BDBFS_CH
	#BREAK
#ENDIF

;No reopen current table after ini-reading
#xcommand DISABLE REOPEN => lNoReopen:=.T.

;Show the array of messages
#xcommand Okey <arr> => Alert(<arr>)

;Show the message
#xcommand SHOW WITH BELL <x> => NFind(<x>,,,,.T.)
#xcommand SHOW <x> => NFind(<x>)

#xcommand START METER <cMsg> => Meter(1, <cMsg>)
#xcommand SHOW METER <nCurrent> => Meter(2,,<nCurrent>)
#xcommand END METER => Meter(3)

#xcommand START SEARCH => CheckEsc(.T.),;
			  IniSearching()	//it provokes Meter(1)

#xcommand FINISH => Meter(3), OpReady()		//it says: READY

#DEFINE _BDBFS_CH
