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
/*
#ifdef __UNIX__
	if ( e:genCode == EG_OPEN .and. e:osCode == 11 /*.and. e:canDefault */)
#else
	if ( e:genCode == EG_OPEN .and. e:osCode == 32 /*.and. e:canDefault*/ )
#endif
	alert ( " Не возможно открыть нужный файл. Возможно кто-то работает с ним ;" +;
	        " в сети в режиме монопольного использования. Попробуйте зайти ;"+;
	        " в этот раздел через несколько минут.;"+e:description)
		NetErr(.t.)
		return (.f.)									// NOTE
	end
	if ( e:genCode == EG_APPENDLOCK /*.and. e:canDefault */)
 		if alert("Вроде бы запись не добавилась. Попробовать еще ?",{"Да","Нет"})==1
	   		return(.t.)
		else
	   		NetErr(.t.)
	   		return (.f.)                                    // NOTE
		endif
	end
	if e:gencode==EG_NOFUNC
      		alert(" В Вашем варианте программы эта функция отсутствует.;"+;
	       " Свяжитесь с разработчиком системы.")
      		break(e)
   	endif
	if e:gencode==EG_PRINT
		if alert("Ошибка печати ! Повторить ? ",{"Да","Нет"})==1
			return (.t.)
     		else
			pfile=set(24)
			set printer to
			set print off
			set(24,"")
			set(23,.f.)
			ferase(pfile)
			set console off
			e:=NIL
			return (.t.)
	      endif
   	endif

*/

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
							";(OS Error " + NTRIM(e:osCode) + ")", ;
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

	ErrorLevel(1)
	QUIT

return (.f.)


static func ErrorMessage(e)
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
quit

