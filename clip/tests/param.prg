
? _inlist(1,1,2,3,4,5)
//? _inlist(1,2,3,4,5,6,1)
?

func _inlist
local i,j,p,ret:=.f.
j=pcount()
for i=2 to pcount()
   ? i, param(i)
   /*
   if p==param(i)
	ret=.t.
	exit
   endif
   */
next
return ret



