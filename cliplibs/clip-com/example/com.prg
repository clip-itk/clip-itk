port:=1

? 'found', COM_NUM(), 'ports'

IF ! COM_OPEN(port)
     ? "cannot opened port !", FERRORSTR()
     break
ENDIF

? 'init', COM_INIT(port, 9600, 'N', 8, 1)

? COM_SOFT(port, .f.)
? COM_HARD(port, .f.)

? COM_TIMEOUT(port, 20)

msg:='Hello, World!'
? 'send', COM_SEND(port, msg)

? 'count', COM_COUNT(port)
? 'read', COM_READ(port, 10)

? COM_CLOSE(port)

?
