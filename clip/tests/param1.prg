local ln:=5
ln2=xxx(@ln)
? ln,ln2
?
return

function xxx(var)
	? param(1)
        ? param(2)
  bl:={|_p|iif(_p==NIL,var,var:=_p)}
  eval(bl,6)
  ? "aaa",var
return var

