/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "error.ch"

#define NTRIM(n)		( LTrim(Str(n)) )
proc ErrorSys()
	ErrorBlock( {|e| DefError(e)} )
return


static func DefError(e)
local i, cMessage, aOptions, nChoice

	while dispcount()>0
	   dispend()
	enddo
	set(20,"SCREEN")

	if "ARGS" $ e
		for i=1 to len(e:args)
			if valtype(e:args[i]) == "O"
				e:args[i] := "{OBJECT}"
			endif
		next
	endif

	outlog("object error:",e)

	cMessage := ErrorMessage(e)

	if ( e:genCode == EG_ZERODIV )
		return (0)
	end

	if ( e:genCode == EG_SIGNAL )
		if isFunction("CLIP_SHUTDOWN")
			clip("CLIP_SHUTDOWN",e)
		endif
		quit
	endif

	aOptions := { EG_MSG_QUIT }

	if (e:canRetry)
		AAdd(aOptions, EG_MSG_RETRY)
	end

	if (e:canDefault)
		AAdd(aOptions, EG_MSG_DEFAULT)
	end

	nChoice := 0
	while ( nChoice == 0 )

		if ( Empty(e:osCode) )
			if IsFunction("gtk_InitCheck") .and. clip("gtk_InitCheck")
				nChoice := clip("gtk_ErrorMsgBox", cMessage, aOptions, [Error] )
			else
				nChoice := Alert( cMessage, aOptions )
			endif

		else
			if IsFunction("gtk_InitCheck") .and. clip("gtk_InitCheck")
				nChoice := Alert( cMessage + ;
							";(OS Error " + NTRIM(e:osCode) + ")", ;
							aOptions )
			else
				nChoice := clip("gtk_ErrorMsgBox", cMessage + ;
							";(OS Error " + NTRIM(e:osCode) + ")", ;
							aOptions,[Error] )
			endif
		end


		if ( nChoice == NIL )
			exit
		end

	end

	if ( !Empty(nChoice) )

		// do as instructed
		if ( aOptions[nChoice] == EG_MSG_QUIT )
			Break(e)

		elseif ( aOptions[nChoice] == EG_MSG_RETRY )
			return (.t.)

		elseif ( aOptions[nChoice] == EG_MSG_DEFAULT )
			return (.f.)

		end

	end

	ErrorLevel(1)
	QUIT

return (.f.)


func ErrorMessage(e)
local cMessage,i


	cMessage := if( e:severity > ES_WARNING, "Error ", "Warning " )

	if ( ValType(e:subsystem) == "C" )
		cMessage += e:subsystem
	else
		cMessage += "???"
	end


	if ( ValType(e:subCode) == "N" )
		cMessage += ("/" + NTRIM(e:subCode))
	else
		cMessage += "/???"
	end
	cmessage+=";"

	if ( ValType(e:description) == "C" )
		cMessage += e:description
	end

	if ( !Empty(e:operation) )
		cMessage += (": " + e:operation)
	end

	if ( !Empty(e:filename) )
		cMessage += (": " + e:filename)
	end

	if ( ValType(e:syserr) == "C" )
		cMessage += (";"+e:syserr)
	end

	if ( !Empty(e:osCode) )
		cMessage += "; (OS Error " + NTRIM(e:osCode) + ") "
	end

	outlog("error message",cMessage)
	i := 1
	while ( !Empty(ProcName(i)) )
		outlog("Called from", Trim(ProcName(i)) + ;
			"(" + NTRIM(ProcLine(i)) + ")  ")

		i++
	end
return (cMessage)

*********************************************
function error2html(err)
local i
?? "Content-type: text/html"
?
?
? "system error:",err
? "<BR>"
	i := 1
	while ( !Empty(ProcName(i)) )
		? "Called from", allTrim(ProcName(i)) + ;
			"(" + str(ProcLine(i)) + ")  <BR>"

		i++
	end
	outlog("object error:",err)
	errorMessage(err)
quit

