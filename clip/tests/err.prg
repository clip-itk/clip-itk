ErrorSys()

ff()

begin sequence

errorblock({|e|errf(e)})
f("fasdf","rqwer")

recover using error
? "recover"
? type(error)
? error
?
end sequence

function f

//break "my error"
ff()

function ff

fff()

static function errf(e)
? "errf"
? e
break e
