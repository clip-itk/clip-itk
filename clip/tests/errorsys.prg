#include "error.ch"

#define NTRIM(n)		( LTrim(Str(n)) )
proc ErrorSys()
	ErrorBlock( {|e| DefError(e)} )
return


static func DefError(e)
local i, cMessage, aOptions, nChoice

	? "DefError"
        ? e
        ? e:genCode
        ? e:GENCODE
        ?


	if ( e:genCode == EG_ZERODIV )
		return (0)
	end

	if ( e:genCode == EG_OPEN .and. e:osCode == 32 .and. e:canDefault )
		NetErr(.t.)
		return (.f.)									// NOTE
	end

	if ( e:genCode == EG_APPENDLOCK .and. e:canDefault )
		NetErr(.t.)
		return (.f.)									// NOTE
	end
	if e:gencode==EG_NOFUNC
		break(e)
	endif

	cMessage := ErrorMessage(e)

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
			nChoice := Alert( cMessage, aOptions )

		else
			nChoice := Alert( cMessage + ;
							";(DOS Error " + NTRIM(e:osCode) + ")", ;
							aOptions )
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

	if ( !Empty(e:osCode) )
		cMessage += " (DOS Error " + NTRIM(e:osCode) + ") "
	end

	? cMessage
	i := 2
	while ( !Empty(ProcName(i)) )
		? "Called from", Trim(ProcName(i)) + ;
			"(" + NTRIM(ProcLine(i)) + ")  "

		i++
	end


	ErrorLevel(1)
	QUIT

return (.f.)


static func ErrorMessage(e)
local cMessage


	cMessage := if( e:severity > ES_WARNING, "Error ", "Warning " )


	if ( ValType(e:subsystem) == "C" )
		cMessage += e:subsystem()
	else
		cMessage += "???"
	end


	if ( ValType(e:subCode) == "N" )
		cMessage += ("/" + NTRIM(e:subCode))
	else
		cMessage += "/???"
	end

	if ( ValType(e:description) == "C" )
		cMessage += ("  " + e:description)
	end

	if ( !Empty(e:filename) )
		cMessage += (": " + e:filename)

	elseif ( !Empty(e:operation) )
		cMessage += (": " + e:operation)

	end

return (cMessage)

