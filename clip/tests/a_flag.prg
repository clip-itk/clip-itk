
q:="p"
//private &q
//eval({||p:=0})

p:=0
a(p)

quit

procedure a(n)
private &q
//private p
if n<20
	p:=n
	qout(n,p)
	a(n+1)
	qout(n,p)
endif
return



/*
private p
p:=0

a(p)

quit

procedure a(n)
private p
if n<20
	p:=n
	qout(n,p)
	a(n+1)
	qout(n,p)
endif

return
*/

/*
field age
use test
? age
age++
? age
++age
? age
?
*/
