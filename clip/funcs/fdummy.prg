******************************************************************
function _generror()
return	nil
******************************************************************
function oemToAnsi(str)
return	str
******************************************************************
function ansiToOem(str)
return	str

******************************************************************
function msgAlert(str)
return	alert(str)

******************************************************************
function msgStop(str)
return	alert(str)
******************************************************************
FUNCTION DbSkipper(n)
    LOCAL i
    i := 0
    IF n == 0 .OR. RECCOUNT() == 0
        SKIP 0
    ELSEIF n > 0 .and. RECNO() != RECCOUNT() + 1
        DO WHILE i < n
            SKIP 1
            IF ( EOF() )
                SKIP -1
                EXIT
            ENDIF
            i++
        ENDDO
    ELSEIF n < 0
        DO WHILE i > n
            SKIP -1
            IF ( BOF() )
                EXIT
            ENDIF
            i--
        ENDDO
    ENDIF
RETURN i

