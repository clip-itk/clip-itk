//  __cname:="{|_1| _field_ iif(_1==NIL,field->last,field->last:=_1) _field_ }"
//  __cname:="{|_1| iif(_1==NIL, field->last, f->last:='adsf' )  }"
//  __cname:=&__cname

select 1
use test
? select(), alias()
*bl='{|_1| _field_ iif(_1==NIL,TEST->FIRST,TEST->FIRST:=_1) _field_ }'
bl='{|_1| iif(_1==NIL,TEST->last,TEST->last:=_1) }'
bl=&bl
? time(),time(),time()
? eval(bl), eval(bl, time() ), eval(bl)

sleep(1)
//bl:=fieldwblock("last",1)
? eval(bl), eval(bl,time()), eval(bl)
sleep(1)
bl:={|_1|iif(_1==NIL,test->last,test->last:=_1)}
? eval(bl), eval(bl,time()), eval(bl)

?
return
