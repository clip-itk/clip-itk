#include "set.ch"

? 'set_p:'
set(_SET_LOGLEVEL, 5)
//set key 5 to a1
a1()
set key 5 to a1
? "1"
set key 5 to
? "2"

func a1
? "a1"
?
return
