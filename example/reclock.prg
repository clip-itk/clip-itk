//
//

? 'tru open test.dbf shared'
use "test.dbf" shared
? 'try rlock'
while ! rlock()
	?? "."
        sleep(1)
end
? '.T.'
? 'Press any key to unlock'
inkey(0)
unlock
? 'Press any key to exit'
inkey(0)
?

