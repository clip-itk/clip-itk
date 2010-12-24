? "hello"
?
return

#define BUG165

#ifdef BUG165

while .t.
	k:=inkey(10)
        ? k
        if (chr(k)=='q')
        	quit
        end
end

#endif


#ifdef BUGu1
BEGIN SEQU
	? 'b1'
    BEGIN SEQU
        ? 'b2'
	BREAK
        ? 'b3'
    END
	? 'end2'
        break
RECOVER
	? 'recover1'
END

?
#endif


#ifdef BUG162

ttt:=.T.
ttt:=ttt+1      // error
? ttt
?

/*PROC ErrorSys()
RETURN ErrorBlock({|e| DefError(e)})
**********
FUNC DefError(e)
? 'error ', e
?
RETURN 5
*/


#endif

#ifdef BUG161

xx:=&('aa:=2*2')
? xx, aa, VALTYPE(aa)
xx:=&('aa:=(2=2)')
? xx, aa, VALTYPE(aa)

/* 1^3 - run-time error*/

xx:=&('aa:=1^3')
? xx, aa, VALTYPE(aa)
xx:=&('aa:={|_1| _1^3}')
? xx, EVAL(aa, 5), VALTYPE(aa)
?
return


#endif

#ifdef BUG159

m1:={{"fff1","c",10,0}}
dbcreate("test1",m1)
m2:={{"fff2","c",10,0}}
dbcreate("test2",m2)
use test1 new
append blank
replace test1->fff1 with "asdf1"
use test2 new
append blank
replace test2->fff2 with "asdf2"

//b1:={|| local(p1),p1:=@test1->fff1, p1}
//b2:={|| local(p2),p2:=@test2->fff2, p2}

//b1:={|| local(p1),p1:=@fff1, p1}
//b2:={|| local(p2),p2:=@fff2, p2}

//p1:=eval(b1)
//p2:=eval(b2)

p1:=@test1->fff1
p2:=@test2->fff2

? test1->fff1, p1 //eval(b1)
? test2->fff2, p2 //eval(b2)

p1:='a1'
p2:='a2'

? test1->fff1, p1
? test2->fff2, p2
?
return


#endif

#ifdef BUG160

clear screen
? "hello"
inkey(0)
save screen to scr
/* in scan mode - Y have keyboard bugs */
run("/usr/local/bin/y")
//inkey(0)
/* not restored old screen*/
restore screen from scr
/* */
? inkey(0)
? "hello2"
?
return



#endif

#ifdef BUG155

/*
memvar E_CW_D
memvar E_CW_N

E_CW_D:=1
E_CW_N:=2

SAVE TO 1.mem ALL LIKE E_*
*/


RESTORE FROM 1.mem ADDI
SAVE TO 2.mem ALL LIKE E_*

?

#endif

#ifdef BUG154

m()

func m()
//begin sequence
break 'asdf'
//end

? 'asdf'
?

return


#endif

#ifdef BUG151

InitDokX("ABC", .T.)
?
return nil

FUNCTION InitDokX(cTyp, lNew, aDef, cTrw, nEwi, cExit)
LOCAL aDok:={}, ii, n, dt, nN:=0, nV:=0, bWhn, bVld, bFld, cInf, xVal, xPod;
      ,cTmp, lTmp, lKor, nTmp, aSt, lSmVat:=.F., cUw, nNt, lTr:=.F., lPj:=.F.;
            ,nSmB:=0, nSmN:=0, nSmV:=0, nH, nX:=0, nY:=0, nPos, lRen, cFR

? cTyp, lNew, "XX"
return nil


ASCAN(aDef,{|a|a[1]="DDO"})
bWhn:={|n,o,w,i,j,t| .T.}
bVld:={|n,o,w,i,j,t| .T.}
ASCAN(aDef,{|a|a[1]="DKS"})
ASCAN(aDef,{|a|a[1]="NKS"})
AADD(aDok[1],{{|a,x|}})
bWhn:={|n,o,w,i,j,t| .t.}
bVld:={|n,o,w,i,j,t| .t.}
ASCAN(aDef,{|a|a[1]="DDO"})
bWhn:={|n,o,w,i,j,t| .T.}
bVld:={|n,o,w,i,j,t| .t.}
ASCAN(aDef,{|a|a[1]="NDO"})
bWhn:={|n,o,w,i,j,t| .T.}
bVld:={|n,o,w,i,j,t| .T.}
bFld:={|a,x|!EMPTY(x)}


ASCAN(aDef,{|a|a[1]="KOR"})
ASCAN(aDef,{|a|a[1]="GRU"})
bWhn:={|n,o,w,i,j,t| .T.}
bVld:={|n,o,w,i,j,t,nP,nK| .T.}
ASCAN(aDef,{|a|a[1]="POJ"})
bWhn:={|n,o,w,i,j,t| .T.}
bVld:={|n,o,w,i,j,t,nP,nK| .t.}
ASCAN(aDef,{|a|a[1]="TKS"})
bWhn:={|n,o,w,i,j,t| .T.}
bVld:={|n,o,w,i,j,t,nP,nK|.t.}
bFld:={|a,x|.t.}
ASCAN(aDok[1],{|a|a[1]="I"})
ASCAN(aDef,{|a|a[1]="KON"})
ASCAN(aDef,{|a|a[1]="KOK"})
bWhn:= {|n,o,w,i,j,t| .T.}

bVld:= {|n,o,w,i,j,t,nP,nK| .t.}
ASCAN(aDef,{|a|a[1]="OZD"})
bWhn:={|n,o,w,i,j,t| .T.}
bVld:={|n,o,w,i,j,t| lNew}
ASCAN(aDef,{|a|a[1]="UWA"})
bWhn:={|n,o,w,i,j,t| .T.}
bVld:={|n,o,w,i,j,t| .T.}
ASCAN(aDef,{|a|a[1]="DVA"})
bWhn:={|n,o,w,i,j,t| .T.}
bVld:={|n,o,w,i,j,t| .t.}
bWhn:={|n,o,w,i,j,t| .T.}
bVld:={|n,o,w,i,j,t| .T.}
bFld:={|a,x|.t.}
ASCAN(aDef,{|a|a[1]="NOV"})


AADD(aDok[1],{|a,x|a[1]})
ASCAN(aSt,{|a|a[2]=-1})
ASCAN(aDef,{|a|a[1]="1"})
bWhn:={|n,o,w,i,j,t| .T. }
ASCAN(aDef,{|a|a[1]="1"})
bWhn:={|n,o,w,i,j,t| .T. }
ASCAN(aDef,{|a|a[1]="2"})
bWhn:={|n,o,w,i,j,t| .T.}
bVld:={|n,o,w,i,j,t| .T.}
ASCAN(aDef,{|a|a[1]="BRU"})
bWhn:={|n,o,w,i,j,t| .T.}
bVld:={|n,o,w,i,j,t| .T.}
AADD(aDok[1],{|a,x|cTyp})
return nil



#endif

#ifdef BUG149

#xtranslate XYZ => a

XYZ := 1


#endif

#ifdef BUG149_0

 do P1 with L_B
 ? L_B

 P1(L_A)

 ? L_A

 return


 //procedu P1(P_A)
 func P1(P_A)

 P_A=1

 ?

 return

#endif

#ifdef BUG148

 proc main

 local L_A
 clear screen

 L_A=P2({1})
 P3(L_A, {2})
 ? L_A[1, 2, 1]

 P1(L_A)
 ? L_A[1, 2, 1]





 do P1 with L_A
 ? L_A[1, 2, 1]

 return


 procedu P1(P_A)

 P_A=P2({1})
 ? 'p1:', p_a
 P3(P_A, {2})
 ? 'p1.2:', p_a


 return


 functio P2(P_R)

 return {{P_R}}


 functio P3(P_A, P_R)
 local b

 ? 'p3:', p_a
 AAdd(P_A[1], NIL)
 ? 'p3.1:', p_a

 //P_A[1, 2]=AClone(P_A[1, 1])
 b=AClone(P_A[1, 1])
 P_A[1, 2]={33}
 ? 'p3.2:', p_a[1,2]
 P_A[1, 2, 1]=P_R[1]

 return NIL

#endif

#ifdef BUG147

#command LOCATE                                                         ;
         [FOR <for>]                                                    ;
=> __dbLocate( <{for}>)


loca for a=b

#command ROCATE                                                         ;
         [FOR <for>]                                                    ;
                                                                        ;
=> __dbLocate( <{for}>)


roca for a=b
?
return


#endif


#ifdef BUG146

aaa("aaa", {}) // prints NIL (should "aaa")
// aaa("aaa")  // works OK (prints "aaa")

func aaa(file)
? file
?


#endif

#ifdef BUG145
local a := {|| .t.}
? codestr(eval(a))
?

//gives

//EVAL(NIL)

#endif

#ifdef BUG144


x:=200
y:=x++
? y,x    // equal 200
?

dbcreate("_test",{{"x","N",10,0}})
use _test alias test
test->(dbappend())
test->x:=200
y:=test->x++
? y,test->x
// in clipper equal 200 (I think correct) in clip equal 201
?
return


#endif

#ifdef BUG141
local a
fn(@a)
//fn(a)
a:="{1}"
? a
?
fn(@a)
//fn(a)
? a
?
return nil

function fn(a)
//local a
//private a
a:={3}
return nil


#endif

#ifdef BUG140


? 'test'
?

/*
//static a:=40

#define NNN  450
clear screen
for i=1 to NNN
    start(@asdf(),i)
    sleep(0.1)
    ?? i,""
next
inkey(0)

static function asdf(n)
	sleep(0.01)
  	?? "c",n,""
return
*/

/*

#define NNN  550
clear screen
for i=1 to NNN
        start(@asdf(),i)
        ?? i,""
next
// wait for closing all  tasks
inkey(0)
for i=1 to NNN
	start(@asdf(),i)
	?? i,""
next
inkey(0)

static function asdf(n)
       sleep(2)
       ?? "c",n,""
return

*/

#endif



#ifdef BUG130

str='asdfqwer'
? str
? str[2,5]
x:=str[2,5]
? x
? str[3]
? str[0]
? str[3,300]
?


#endif

#ifdef BUG139


m->first="XXX"
use test
? test->first         && ????? "a"
first="XX1"
? m->first            && ????? "XXX"
? first               && ????? "XXX", ? ?????? ???? "a"
?
use
return



//? m->varname
//m->varname = 1
//? m->varname
//?

#endif

#ifdef BUG133


//aaa:=33
//? aaa

//memvar->aaa
? memvar->aaa // prints NIL, and must generate an error
? aaa // generates error
?

#endif

#ifdef BUG122

#command METHOD:<msg> => add(#<msg>)
METHOD:aaa

//preprocessor gives
//add( ":aaa" )
//      ^
//instead of
//add( "aaa" )

#endif

#ifdef BUG121

clear screen

obj:={getnew()}
obj[1]:block:={||"test"}

// 1) it is OK, it works in Clipper and CLIP
string:="eval(obj[1]:block)"
?&string

// 2) it works in CLIP but not in Clipper
string:="(obj[1]):varget()"
?&string

// 3) it works in Clipper but not in CLIP
string:="obj[1]:varget()"
?&string


#endif

#ifdef BUG104

while .T.
	if (inkey()==27)
        	exit
	end
end

#endif

#ifdef BUG117
mc='+w/bg,+gr/b'
CLEAR SCREEN
? cset:=set( _SET_CANCEL, .f. )
? set( _SET_CANCEL, cset )
? scankey(0)  // pRess "2" - scan code==3 as Ctrl+C

? scankey(0)
RETURN ( NIL )


#endif

#ifdef BUG118
? "begin"
/*
? "one* /"
? "two"
*/
? "end"
?


#endif

#ifdef BUG115
/*this not work */
#command xMENU TO <x> ;
   => <x> := _xMenu ( IF (ValType (#<x>) == "U", <x> := 1, <x>) )
/* but this work */
/*
 #command xMENU TO <x> ;
   => <x> := _xMenu ( IF (ValType (<x>) == "U", <x> := 1, <x>) )
*/

xMENU to  a


#endif

#ifdef BUG114
beep()
beep(1)
beep(10)

procedure beep(g)
LOCAL I
//default g to 1
g := IIF( g == NIL , 1 , g )
FOR i := 1 TO g
     Tone(1100,0)
NEXT
RETURN



#endif

#ifdef BUG113
local a,b // not work assign to "b"
//private a,b // work correctly

a:="hello"
b:=@a
? a,b
b:="world"
? a,b
?
return

#endif

#ifdef BUG111

? dosparam()
?


#endif



#ifdef BUG100

#include <llibg.ch>

? Mstate()[LLM_STATE_LEFT]
?
//, LLM_STATE_RIGHT already return 0,79


#endif

#ifdef BUG99

_bdbfbrow:=map()
_econd := {|| _bdbfbrow:test}
res:=Eval(_econd)

#endif

#ifdef BUG98
clear
s:="a"
bl:= _GET_(s):block
? s,eval(bl)
? eval(bl,"2345")
? s,eval(bl)
?
return

function __CGET__(block,aSubscript,cName,cRealName,cPic,bValid,bWhen)
	local oget,row:=row(),col:=col()
	oGet := getnew(row(),col(),block,cName,cPic,,,bValid,bWhen)
	oGet:subscript := aSubscript
	oGet:realName  := cRealName
	setpos(row,col)
        ? "__CGET__"
return oGet

/*
function __CGET__(block,aSubscript,cName,cRealName,cPic,bValid,bWhen)
        ? "__CGET__"
return block
*/


/*
a:="asdf"
s:="a"
//_GET_(&s)
x:= @&s
//x:=@s
? x,&s//,a
x:="1234"
? x,&s//,a
?
return
*/

#endif


#ifdef BUG96
function Main()
        local obj = map()
return
#endif


#ifdef BUG95
//function main()
local a1:={1,2,3}, a2:={1,2}
f1(@a1,@a2)
//? len(a1), len(a2)
? a1, a2
?
return nil
function f1(a1,a2)
local a,b
a:=a1
a:=a2
return nil

/*
result:
    0 2
    should be:
    3 2
*/
#endif

/*
//#94

m:={;
    {"a",{"b","c"},'<commands>'},;
    {"b",{"c","d"},'<commands>'},;
    {"c",{"y"},'<commands>'},;
    {"y",{},'<commands>'};
   }

t:={"a",{"b","c"},'<commands>'}

x := depsort(m/*, t */)

? 'x:', x
?
/*
    {;
     {"y",{},'<commands>'},;
     {"c",{"y"},'<commands>'},;
     {"b",{"c","d"},'<commands>'},;
     {"a",{"b","c"},'<commands>'};
    }
*/
*/

/*
//#85
local an:={1,2}
? an
f2(an)
? an
f1(@an)
? an
?

Func f1(a1)
a1:={1,2,3}
return

Func F2(a1)
local a2:=a1
a2[1]:=111
return
*/

/*
local a1:={1,2,3}, a2:={1,2}
f1(@a1,@a2)
?
return

function f1(a1,a2)
local a, l:=(.t.)
? valtype(a1), len(a1), valtype(a2), len(a2), valtype(a), len(a)
// a:=NIL // with this line bugs closed
a:=iif(l, a1, a2)
l:=!l
? valtype(a1), len(a1), valtype(a2), len(a2), valtype(a), len(a)
a:=iif(l, a1, a2)
l:=!l
// next line have bugs - a!=a2, and a and a2 is crashed.
? valtype(a1), len(a1), valtype(a2), len(a2), valtype(a), len(a)
return
*/

/*
local c
f(@c)
?
return
function f(c)

//local c
c:={||.T.}
? valtype(c)
c:={c}
? c
?? ":", valtype(c), valtype(c[1])//, valtype(c[1,1]), valtype(c[1,1,1])
?
return nil
*/
/*
local a
local obj := map()

obj:fff := @_fff()
? a := obj:fff():ccc
//? a
? obj:fff():ccc
?

static function _fff
local o := map()
o:ccc := "qwe"
return o

init proc adsf

? 'asdf'

return

init proc clipinit
? 'clipinit'

return

init proc qwer

? 'qwer'

return


*/
/*
clear screen
while .t.
   ?(key:=inkey(0))

   if key()=27
         quit
   endif

end
*/
/*
Local an:={'a','b'},n
cls
funcArr(@an,@n)
//? len(an),n     //?? an={}, n=7
? an, n
return NIL

Func FuncArr(a1,m)
Local lF:=.t.

a1[1]:=0
? a1

a1:={1,2,3}
? a1
m:=7
return lF

*/
/*
clear screen
while .t.
  ?(key:=scankey(0))

   if key==224
        ?scankey(0)
   endif
   if inkey()=27
         quit
   endif

end

*/
/*


clear screen
for i=1 to 10
	key:=scankey(0)

	? key
	if key==224
        	key:=scankey(0)
	        ? key
	endif
	if (inkey()==27)
		quit
	endif
next
*/

/*
while .t.
	k:=inkey(0)
        ? k
        if k==27
        	exit
        end
end
?
*/
/*
local b
? b := f():a
? f():a
?

func f()
local m := map()
m:a := "qwe"
return m
*/

/*
m:={{"num","N",6,0},{"text","M",10,0}}
dbcreate("_a",m)
use
use _a
s1:="field->text"
s2:=field->text
? type("s2"),valtype(s2),type("field->text"),valtype(field->text),valtype(&s1)
append blank
replace text with "sdfsdfsd"
s2:=field->text
? type("s2"),valtype(s2),type("field->text"),valtype(field->text),valtype(&s1)
?
return

// clipper return "C" for type("s2") and valtype(s2), for other "M".
// clip return "M" for all expressions
// my opinion: after assing clipper clear flag "memo" in var structure.
*/

/*
local c
f(@c)
?
return nil

function f(ac)
local ac1
ac:={||.T.}
? valtype(ac)
//ac:={ac}
ac1:={ac}
//ac1[1]:=ac
ac:=ac1
?? ":", valtype(ac), valtype(ac[1])
//, valtype(ac[1,1]), valtype(ac[1,1,1])
? ac, ac[1]
*/

/*
static sKb

//func main()
//cls
? outkb({|| outlog(__FILE__,__LINE__)})
?

return


func OutKb(kb)
//static sKb
//local skb

//if valtype (kb) == 'B'
//valtype(kb) == 'B'
fff(kb) == 'B'
//'B' == valtype(kb)
sKb:=kb
//endif
eval(sKb)
//eval(kb)
return

func fff(f)
return
*/
/*
aaa()
bbb()

function aaa()
   ccc()
   return

static function bbb()
local i, ret
for i=1 to 10000
       //substr("asdf",1,4)
       next
return

static function ccc()
local i, ret
for i=1 to 10000
     //substr("asdf",1,4)
     next
return
*/

/*
local a:="first"
use test

? test->first
test->&a = time()   // not work
//test->a = time()   // not work
//test->&a := time()  // work
//? test->&a = time()
? test->first
?
return

*/

/*
mpar(1,2,3,4,5)

func mpar()

? pcount()
qout(param(1));


return


*/


/*
m:=map()
m:code := "code1"
? mapeval(m, "CODE ")  // this line work
? mapeval(m, "CODE")   // this line not work
?
*/

/*
//local j
j := "1"
b1:= {|| &j }
j := "2"
b2:= {|| &j }
? eval(b1),eval(b2) // clipper result is "1","2"
?
return
*/

/*
use test
bl:= _GET_(field->first,"field->first")
? bl
? eval(bl)
?

function __CGET__(xData,ind,varName,realName,p4,p5,p6)
    ? '__CGET__:',xData," ind:",ind," varName:",varname," realName:",realname,",",p4,",",p5,",",p6,","
return xData
*/

/*
clear screen
s1:="data"; s2:="s1"
oget := _CGET_(&s2,"&s2","@K XXXXXX") // buggy work
? s2,&s2,s1
? eval(oGet)
? eval(oGet,"asdasd")
? eval(oGet)
? s2,&s2,s1
?
return

function __CGET__(xData,ind,varName,realName,p4,p5,p6)
    ? '__CGET__:',xData," ind:",ind," varName:",varname," realName:",realname,",",p4,",",p5,",",p6,","
return xData
*/

/*
vat:=0

a:={|_1| local(_p:=@var), iif(_1==NIL,_p,_p:=_1 ) }

_CGET_(field->first,"field->first")

return

func __CGET__(obj, sub, name, p1, p2)

? 'obj=', obj
? 'sub=', sub
? 'name=', name
? 'p1=', p1
? 'p2=', p2
?
return
*/
/*
clear screen

//inkey(0)

*/
/*
local xxx
clear screen
s1:="data"; s2:="s1"
xxx :=@&s2
//oget := _CGET_(xxx,"&s2","@K XXXXXX") // this line work correctly
oget := _CGET_(&s2,"&s2","@K XXXXXX") // buggy work
? s2,&s2,s1
? eval(oGet)
? eval(oGet,"asdasd")
? eval(oGet)
? s2,&s2,s1
?
return

function __CGET__(xData,ind,varName,realName,p4,p5,p6)
    local block
        ? '__CGET__:',xData," ind:",ind," varName:",varname," realName:",realname,",",p4,",",p5,",",p6,","
            // varname for "&s2" in NIL, this is not correctly
    block := {|_1| iif(pcount()==0, xData, xData := _1)}
return block
*/


/*
local b:='aaaa'

a:={{1,0},{2,3}}

i=2
//? codestr(a)
_CGET_(a[1,i],'1',2,'333')
_CGET_(a[1])
_CGET_(a,'1')
_CGET_(b,'1', 2)

func __CGET__(obj, sub, name, p1, p2)

? 'obj=', obj
? 'sub=', sub
? 'name=', name
? 'p1=', p1
? 'p2=', p2
?

return
*/

/*
xx := &("{||iif(a,b,)}")
xx := &("{||a,b,}")

*/
/*
clear screen
m_color=    'GR+/B,W+/R,,,W+/N  '
//setcolor(m_color)
//cls
//? inkey(0.01)
//? inkey(0.01)
? inkey(0.01)

retu

*/
/*
? inkey(0)
set(_SET_ESC_DELAY, 100)
? inkey(0)
?
*/

/*
#command IF <condition> THEN <*aktion*> ;
 => IF <condition>; outlog("if", __FILE__,__LINE__) ;<aktion> ;ENDIF




outlog("1", __FILE__,__LINE__)




IF  MainCycle() THEN    outlog("2", __FILE__,__LINE__)
mainCycle()
outlog("3", __FILE__,__LINE__)

function maincycle()
// this output is bad
outlog("called from:",procname(1),procline(1))
return .t.

*/

/*
tttt()
? 'a'
?
*/

/*
local j

j := "1"
b1:= {|| &j }
j := "2"
b2:= {|| &j }
? eval(b1),eval(b2) // clipper result is "1","2"
?
return
*/


/*
static function f1(self)
i:=ascan(WinChain,{|x|x:kk==::kk})
retu i

*/

/*
#define print(x,y,t) @ y,x SAY t
? "a"
print(50,1,AX_Loaded("W:\"))
//qout(AX_Loaded('w:\'))
print(50,1,AX_Loaded('w:\'))
? "b"
?
*/
/*
ffffff()
*/
/*
private x:=1
Local cKb:='{|z| z:=memv->x}'
//Local cKb:='{|z| z:=memvar->x}'
// if "memv" change to "memvar" - this test work correctly
Local kb
kb:=&cKb
eval(kb)
return
*/
/*fileDialog()*/
/*
? 'OEM', getOEMcp()
? 'ANSI', getANSIcp()
? 'CONSOLE', getCONSOLEcp()
? 'CONSOLEOUTPUT', getCONSOLEOUTPUTcp()
? 'qwerty' // cp1251 -> utf-8: '—Ñ—ã–≤–∞'
?
inkey(0)

clear screen
@ 10,5 say ''
? 'OEM', getOEMcp()
? 'ANSI', getANSIcp()
? 'CONSOLE', getCONSOLEcp()
? 'CONSOLEOUTPUT', getCONSOLEOUTPUTcp()
? 'qwerty' // cp1251 -> utf-8: '—Ñ—ã–≤–∞'
?
inkey(0)
*/
/*
a:=map()
a:asdf:='asdf'
//a:qwer:='qwer'

//? a
//? 'asdf'
? a:asdf
? a
//? 'qwer', a:qwer
?
*/
/*
? gettext("asdf")

for i:=0 to 32
//? i, ngettext("error", "error", i)
?  i, [error]^i
next

?
*/
/*
exit
exit
exit
exit
exit

func main()
cls
outkb({|| outlog(__FILE__,__LINE__)})
return

func OutKb(kb)
static sKb:={|| NIL}

if valtype (kb) == 'B'
        sKb:=kb
endif

eval(sKb)
return
*/

/*
/* not fixed*/
a:=map()
a:classname := "A"
b:=map()
b:classname := "B"
b:c:= @asdf()

a:b:= b
? a:b:c()
?
return


static function asdf(self)
  ? qself() //:classname   //     "A"
  ? self //:classname        //     "B"
return "C"

*/

/*
? 'got:', GETCLIPBOARDDATA()
? 'set:', SETCLIPBOARDDATA('adsfasdf')
? 'got:', GETCLIPBOARDDATA()
?
*/
/*
clear screen
while .t.
  ? (key:=scankey(0))

   if key==224
	? scankey(0)
   endif
   if inkey()=27
	quit
   endif
   asdf()
end

func asdf()
return

static func qwer()
return

*/
/*
Local nSum := 0, cf := 'age'
use test new
dbEval({|| nSum += &(cf)})
? nsum
?
return

*/

/*
#xcommand REPORT [ <oReport> ] ;
        [ TITLE <bTitle, ...> [<TFmt:LEFT,CENTER,CENTERED,RIGHT>] ];
        [ HEADER <bHead, ...> [<HFmt:LEFT,CENTER,CENTERED,RIGHT>] ];
        [ FOOTER <bFoot, ...> [<FFmt:LEFT,CENTER,CENTERED,RIGHT>] ];
        [ FONT <oFont, ...> ]  ;
        [ PEN <oPen, ...> ]  ;
        [ <lSum:SUMMARY> ] ;
        [ <file: FILE, FILENAME, DISK> <cRptFile> ] ;
        [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
	[ <toPrint: TO PRINTER> ] ;
	[ <toScreen: PREVIEW> ] ;
	[ TO FILE <(toFile)> ] ;
	[ TO DEVICE <oDevice> ] ;
	[ CAPTION <cName> ] ;
	=> ;
	[ <oReport> := ] RptBegin({<{bTitle}>}, {<{bHead}>}, {<{bFoot}>},;
	{<oFont>}, {<oPen>}, <.lSum.>, <cRptFile>, <cResName>,;
	[<.toPrint.>], <.toScreen.>, <(toFile)>, <oDevice>, <cName>,;
	[UPPER(<(TFmt)>)], [UPPER(<(HFmt)>)], [UPPER(<(FFmt)>)] )



REPORT oRPT TITLE "ASDF"

*/

/*
? __CLIP_MODULE__
? [asdf]
? loadModuleMsg(__CLIP_MODULE__, "locale.mo/my/tests.mo")
? [asdf]
? loadModuleMsg(__CLIP_MODULE__, "locale.mo/ru_RU.KOI8-R/tests.mo")
? [asdf]
?

*/
/* not fixed
local c
f(@c)
?
return nil

function f(ac)
local ac1
ac:={||.T.}
? valtype(ac)
//ac:={ac}
ac1:={ac}
//ac1[1]:=ac
ac:=ac1
?? ":", valtype(ac), valtype(ac[1])//, valtype(ac[1,1]), valtype(ac[1,1,1])
? ac, ac[1]
*/

/*
Local nSum := 0, cf := 'age'
use test new
dbEval({|| nSum += &(cf)})
? nsum
?
return
*/


/*
#define COMMENT "/*"


? COMMENT
? at(COMMENT, line)
*/



/*
s:="ASDF"
o:=map()
o[s] := s
? s $ o, s, o
s:="asdf"
o:=map()
o[s] := s
? s $ o, s, o
?
return

*/

/*
*reference asdf
//memvar x
x:=1
? x
asdf(x)
? x
?

function asdf(a)
	a:=2
return
*/

/*
#translate :memoBlock   => :cargo\[1\]
#translate :memoArrOcur => :cargo\[2\]

 oGet :memoBlock   := bVar
 oGet :memoArrOcur := nOcur
*/

/*
//#define END        "END:"
#define end        END

do while .t.
end   // clipper doesn't replace this !
*/

/*
#xcommand DEFINE PAGESETUP <oRTF> ;
		[ MARGINS <nLeft>, <nRight>, <nTop>, <nBottom> ] ;
		[ PAGEWIDTH <nWidth> ] ;
		[ PAGEHEIGHT <nHeight> ] ;
		[ TABWIDTH <nTabWidth> ] ;
		[ <landscape: LANDSCAPE> ] ;
		[ <lNoWidow: NOWIDOW> ] ;
		[ ALIGN <vertalign: TOP, BOTTOM, JUSTIFY, CENTER> ] ;
		[ PAGENUMBERS <cPgnumPos: LEFT, RIGHT, CENTER> ] ; // not supported
		[ <lPgnumTop: PAGENUMBERTOP> ] ; // not supported
	=> ;
		<oRTF>:PageSetup( <nLeft>, <nRight>, <nTop>, <nBottom>, ;
				 <nWidth>, <nHeight>, <nTabWidth>, <.landscape.>, <.lNoWidow.>, ;
				 <"vertalign"> , <cPgnumPos>, <.lPgnumTop.> )

DEFINE PAGESETUP oRTF MARGINS 1.75, 1.75, 1, 1 	TABWIDTH .5 ALIGN CENTER

*/

/*
/***********************not fixed */
//static sKb:={|| }
static sKb

sKb:={|| }
//func main()
cls

? sKb

outkb({|| outlog(__FILE__,__LINE__)})

return

func OutKb(kb)
local l

? valtype (kb) == 'B'
//if (valtype (kb) == 'B')
//   sKb:=kb
//endif
? sKb
//eval(sKb)
   //eval(Kb)
? 'asdf'
return
*/


/*/  this is a long comment */


/*
#command OBJECT <x1>:<y1>  => asdf(<x1>,<y1>)

OBJECT oNewGauge:Gauge

*/

/*
#command @ <row>, <col> GET <var>                 ;
 [ PICTURE <pic> ]                                ;
 CONDITION <aSelect>                              ;
 [ VALID <valid> ]                                ;
 [ WHEN <when> ]                                  ;
 [ SEND <msg> ]                                   ;
 => SetPos( <row>, <col> )                        ;
 ; AAdd( GetList,                                 ;
         LogicGet( _GET_( <var>, <( var )>, < pic>,;
                         <{ valid }>, <{ when }>  ;
                       )                          ;
                ,<aSelect>)                       ;
       )                                          ;
 [ ; ATail( GetList ):<msg> ]


@ nRow+3, nLeft+34 GET lOrient CONDITION {"vertic.", " horiz."}
*/


/*
#Translate .<Object>:FunctionKey   => <Object>:cargo\[ 1 \]

?  .browse:FunctionKey

*/
/*
#command IF <condition> THEN <*aktion*>         ;
        => IF <condition> ; <aktion> ; ENDIF

#define QuitMess(mess) Nfind(m->_base+mess) ; RETURN !SelectBase()

IF 'U' $ Type('_Pole[1]') THEN QuitMess(_CORRUPTED)
*/


/*
#command SAVE ALL LIKE <skel> TO <(file)>                               ;
      => __MSave( <(file)>, <(skel)>, .t. )

SAVE ALL LIKE lbl_*.* TO &label_mem

*/

/*
//#command DEFAULT <Var1> = <DefValue1> [, <Var2> = <DefValue2> ] => ;
//        <Var1> = if( <Var1> == NIL, <DefValue1>, <Var1> ) ;;
//                [<Var2> = if( <Var2> == NIL, <DefValue2>, <Var2> );]

#command DEFAULT <Var1> = <DefValue1> [, <Var2> = <DefValue2> ] => ;
        <Var1> = if( <Var1> == NIL, <DefValue1>, <Var1> ) ;
                [;<Var2> = if( <Var2> == NIL, <DefValue2>, <Var2> )]

DEFAULT nX = 2
DEFAULT nY = 1

*/
/*
#command THUSE <(db)>                                                ;
               [<no: NO ORDER>]                                      ;
               [VIA <rdd>]                                           ;
               [ALIAS <a>]                                           ;
               [<ex: EXCLUSIVE>]                                     ;
               [<sh: SHARED>]                                        ;
               [<ro: READONLY>]                                      ;
               [INDEX <ntx,...>]                                     ;
               [NETERR <bneterr>]                                    ;
                                                                     ;
      => s_thuse(                                                    ;
                  <(db)>, <(a)>, [{ <(ntx)> }], <rdd>,               ;
                  if(<.sh.> .or. <.ex.>, !<.ex.>, NIL),              ;
                  <.ro.>, <.no.>, <bneterr>                          ;
                )                                                    ;

Local bd:='bd1'
Local aInd:='bdInd1'
thuse (bd) index (aInd) exclusive
return
*/

/*
m:={}
? asize(m,-1)
?
return
*/

/*
#defin ATOP_CHOICE_PA { " N/N ;§Æ™„¨", "èÆ·‚†¢È®™;ß†™†ßÁ®™", " Ñ†‚† ;Æ‚£‡„ß™®","Ñ†‚†;Ø‡®•¨™®","ë„¨¨† ØÆ;Ø‡Æ§†¶≠Æ©","ë„¨¨† ØÆ;ß†™„ØÆÁ≠Æ©","ë„¨¨†; ™ÆØ´†‚•","é‚§•´" }
// cp866 -> utf-8:
// { " N/N ;–¥–æ–∫—É–º", "–ü–æ—Å—Ç–∞–≤—â–∏–∫;–∑–∞–∫–∞–∑—á–∏–∫", " –î–∞—Ç–∞ ;–æ—Ç–≥—Ä—É–∑–∫–∏","–î–∞—Ç–∞;–ø—Ä–∏–µ–º–∫–∏","–°—É–º–º–∞ –ø–æ;–ø—Ä–æ–¥–∞–∂–Ω–æ–π","–°—É–º–º–∞ –ø–æ;–∑–∞–∫—É–ø–æ—á–Ω–æ–π","–°—É–º–º–∞; –∫–æ–ø–ª–∞—Ç–µ","–û—Ç–¥–µ–ª" }
// { " N/N ;docum", "Supplier;customer", " Date of;shipment","Date of;acceptance","amount of;sales","amount of;Procurement","Amount;Due","Section" }

#define AFIELD_CHOICE_PA { "Nd", "Kod", "DataOt","DataPr","SumRo","SumOp","SumPay",{||m_pa_ttn->OtdelEx} }

? ATOP_CHOICE_PA
? AFIELD_CHOICE_PA
?
*/

/*
x:=map()
x["01"] := "asdf"
? x
? adel(x,`01`)
? x
?
*/

/*
@ x++,y say [Can`t]
*/

/*
? upper(123455)
*/

/*
private first:="121212"
use test
field->first:=time()
first := "sdfsdfsd"
? field->first,m->first, first
//                        ````````
//  when compiling in CLIP with an option -a , latest 'first' should be got
//  from 'memvar'
?
return
*/
/*
use test
//index on first to test
? first
?
return
*/

/*
qout( [Loading standard definitions from: '] + sCH + "'")


#define ASDF "0/7"

? ASDF
set color to ASDF

*/

/*
private first:="121212"
use test
field->first:=time()
first := "sdfsdfsd"
? field->first,m->first, first
//                        ````````
//  when compiling in CLIP with an option -a , latest 'first' should be got
//  from 'memvar'
?
return
*/

/*
#command select <classname> ;
    from <dep> ;
    [where <wExpr>] ;
    [order by <xOrder>] ;
    to <varname>;
    => ;
    <varname> := codb_oql_select(<"classname">,<"dep">,<"wExpr">,<"xOrder">)

select currency from GBL0101 where "'01' $ code" to idList
select currency from GBL0101 where "01&\' $ code" to idList
*/

/*
local aa:=11,bb:=22

 o:=map()
 o:a:=1
 o:b:=2

? mapEval(o,{||aa+bb}) // 33
? mapEval(o,{||a+b})
? mapEval(o,"a+b")
? mapEval(o,{|c|a+b+c},4)
?

*/
/*
o:=map()
o:operator_add = @add_f()
o:operator_sub = @sub_f()
o+33-444
?
return


static func add_f(l,r)
? 'add_f', l, r
return l

static func sub_f(l,r)
? 'sub_f', l, r
return
*/
/*
local gdata
asdf:="1111"
_var := "asdf"
//gdata:=@&_var
gdata:=@asdf
? _var,gdata,asdf
gdata:="aaaaa"
? _var,gdata,asdf
asdf:="bbbb"
? _var,gdata,asdf
&_var := "2222"
? _var,gdata,asdf
?
*/

/*
o:=map()
? o
? "asdf" $ o
? o
? o:asdf
//if .f. .or. valtype(o:asdf)
//endif
//? o:asdf
?
return
*/


/*
asdf("test" )
return
function asdf(fname2)
   local struct:={}
   use (fname2)
   do while !eof()
      aadd(struct,field->asdfghjkl) //,field->field_type,field->field_len,fie$>       skip
   enddo
   use
return
*/

/*
        local B, i


        B:=winbuf_create(5,10)

set color to "w/g"
        clear screen

        winbuf_display(B,10,10)
        inkey(0)

        for i:=0 to 4
                winbuf_out_at(B,i,0,space(10),"W/B")
        next

        winbuf_display(B,10,10)
        inkey(0)

        winbuf_out_at(B,2,3," WinBuffer test ","GR+/BG")
        winbuf_out_at(B,3,3," WinBuffer test ","R+/GR")
        winbuf_display(B,10,10)
        inkey(0)
return

*/

/*
//#command SET FILTER TO <x:&>                                            ;
//        => ? ( <(x)> )                                            ;
//#command SET FILTER TO <x:&>                                            ;
//        => ? ( <(x)> )                                            ;


//use test
//fff:=""
//set optimize off
set filter to &fff
//goto top
//? recno(), first
*/

/*
      Devpos( Prow() + 1, 0 )
      Devout( Replicate( "ƒ", IIF( lSaldo, n_field - 2, n_field ) * 15 + 15 ; // cp866->utf-8: "‚îÄ"
                         * ( Len( _Undef ) - nItogk - IIF( lSaldo, 2, 0 ) ) ;
                       )                                                   ;
            )

  ? asdf
*/
/*

   LOCATE for AllTrim(BAZA) == PROVOD .and. AllTrim(FIELD_NAME) == "SK"
//   LOCATE for D .and. A
//   LOCATE for PROVOD .and. Alltr

//      cKredit:= if(Found(), AllTrim(NAM), "")

    REPORT FORM (db_file) TO PRINT FOR ProcRun(ncount,++count)
    REPORT FORM (db_file) TO PRINTER FOR ProcRun(ncount,++count)

*/
/*

#xcommand @ <nRow>, <nCol> COMBOBOX [ <oCbx> VAR ] <cVar> ;
	     [ <items: ITEMS, PROMPTS> <aItems> ] ;
	     [ SIZE <nWidth>, <nHeight> ] ;
	     [ <dlg:OF,WINDOW,DIALOG> <oWnd> ] ;
	     [ <help:HELPID, HELP ID> <nHelpId> ] ;
	     [ ON CHANGE <uChange> ] ;
	     [ VALID <uValid> ] ;
	     [ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
	     [ <pixel: PIXEL> ] ;
	     [ FONT <oFont> ] ;
	     [ <update: UPDATE> ] ;
	     [ MESSAGE <cMsg> ] ;
	     [ WHEN <uWhen> ] ;
	     [ <design: DESIGN> ] ;
	     [ BITMAPS <acBitmaps> ] ;
	     [ ON DRAWITEM <uBmpSelect> ] ;
	     [ STYLE <nStyle> ] ;
       => ;
	  [ <oCbx> := ] TComboBox():New( <nRow>, <nCol>, BSETGET(<cVar>),;
	     <aItems>, <nWidth>, <nHeight>, <oWnd>, <nHelpId>,;
	     [{|Self|<uChange>}], <{uValid}>, <nClrText>, <nClrBack>,;
	     <.pixel.>, <oFont>, <cMsg>, <.update.>, <{uWhen}>,;
	     <.design.>, <acBitmaps>, [{|nItem|<uBmpSelect>}], <nStyle> )



   @ 1, 2 COMBOBOX oCbx1                                      ;
      VAR cItem1                                                ;
      ITEMS { "One", "Two", "Three", 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten' }                           ;
      SIZE 100, 20						;
      HELP ID ID_SIMPLE				;
      OF oDlg                                      ;
      ON CHANGE ( cItem4 := cItem1, oSay:Refresh() )            ;
      VALID ( MsgBeep(), cItem4 := cItem1 ,                     ;
	      oSay:Refresh(), .T. )				;
      STYLE CBS_SIMPLE
*/
/*
   @ 1, 2 COMBOBOX oCbx1                                      ;
      VAR cItem1                                                ;
      ITEMS { "One", "Two", "Three", 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten' }                           ;
      SIZE 100, 20						;
      ON CHANGE ( cItem4 := cItem1, oSay:Refresh() )            ;
      VALID ( MsgBeep(), cItem4 := cItem1 ,                     ;
	      oSay:Refresh(), .T. )				;
      STYLE CBS_SIMPLE
*/


/*
clear screen
do while lastkey()!=27
        ? inkey(0)
enddo
?
return
*/

/*
#xcommand DEFAULT <uVar1> := <uVal1> ;
	       [, <uVarN> := <uValN> ] => ;
		  <uVar1> := If( <uVar1> == nil, <uVal1>, <uVar1> ) ;;
		[ <uVarN> := If( <uVarN> == nil, <uValN>, <uVarN> ); ]

 DEFAULT nTop := 2, nLeft := 2, nBottom := 20, nRight := 70,;
		lVScroll := .f., lHScroll := .f.,;
		nClrFore := CLR_WHITE, nClrBack := GetSysColor( COLOR_WINDOW ),;
		nStyle   := 0,;
		cBorder  := "SINGLE", lSysMenu := .t., lCaption := .t.,;
		lMin     := .t., lMax := .t., lPixel := .f.

*/
/*

 REST FROM (m->_VueFile) ADDI

#xcommand @ <nRow>, <nCol> SCROLLBAR [ <oSbr> ] ;
           [ <h: HORIZONTAL> ] ;
           [ <v: VERTICAL> ] ;
           [ RANGE <nMin>, <nMax> ] ;
           [ PAGESTEP <nPgStep> ] ;
           [ SIZE <nWidth>, <nHeight> ] ;
           [ <up:UP, ON UP> <uUpAction> ] ;
           [ <dn:DOWN, ON DOWN> <uDownAction> ] ;
           [ <pgup:PAGEUP, ON PAGEUP> <uPgUpAction> ] ;
           [ <pgdn:PAGEDOWN, ON PAGEDOWN> <uPgDownAction> ] ;
           [ <pos: ON THUMBPOS> <uPos> ] ;
           [ <pixel: PIXEL> ] ;
           [ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
           [ OF <oWnd> ] ;
           [ MESSAGE <cMsg> ] ;
           [ <update: UPDATE> ] ;
           [ WHEN <uWhen> ] ;
           [ VALID <uValid> ] ;
           [ <lDesign: DESIGN> ] ;
       => ;
        [ <oSbr> := ] TScrollBar():New( <nRow>, <nCol>, <nMin>, <nMax>, <nPgStep> ;
           (.not.<.h.>) [.or. <.v.> ], <oWnd>, <nWidth>, <nHeight> ,;
           [<{uUpAction}>], [<{uDownAction}>], [<{uPgUpAction}>], ;
           [<{uPgDownAction}>], [\{|nPos| <uPos> \}], [<.pixel.>],;
           <nClrText>, <nClrBack>, <cMsg>, <.update.>, <{uWhen}>, <{uValid}>,;
           <.lDesign.> )



      @ 2, 5 SCROLLBAR OF oWnd                                  ;
       UP   nMsgBox( "Hey!, Go Up" )                       ;
       DOWN nMsgBox( "Going down man" )

      @ 2, 5 SCROLLBAR OF oWnd                                  ;
       ON UP   nMsgBox( "Hey!, Go Up" )                       ;
       ON DOWN nMsgBox( "Going down man" )


*/
/*
clear screen
do while lastkey()!=27
        ? inkey(0)
enddo
?
return

*/

/*
*reference aaa // here it has stopped working
memvar x
x:="asdasdasdas"
? "by default reference"
? x
aaa(x)
? x
?
? "by real reference"
? x
aaa(@x)
? x
?
return

function aaa(y)
        y:="12321312"
return
*/

/*
? "sdfsdfsd" sdfgdfgdf"
*/


/*
m:=map()
? m, refcount(m)
b:=m
? refcount(m)
?

*/
/*
? "sdfsdfsd" sdfsdfsd"
?
return


#define CH "//"
qout(CH)

#define LS [afd]

aaa( LS ] )

#define comm_char '//'
qout( comm_char)

*/
/*
local m:={}
//private m:={}
asdf:="qwert"
s:="asdf"
b:={|ppp|aadd(m,&ppp)}
eval(b,s)
? m
?
return
*/
/*
#xcommand MENUITEM [ <oMenuItem> PROMPT ] [<cPrompt>] ;
           [ MESSAGE <cMsg> ] ;
           [ <checked: CHECK, CHECKED, MARK> ] ;
           [ <enable: ENABLED, DISABLED> ] ;
           [ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
           [ <resource: RESOURCE, RESNAME, NAME> <cResName> ] ;
           [ ACTION <uAction,...> ] ;
           [ WHEN <wAction> ] ;
           [ BLOCK <bAction> ] ;
           [ <of: OF, MENU, SYSMENU> <oMenu> ] ;
           [ ACCELERATOR <nState>, <nVirtKey> ] ;
           [ <help: HELP> ] ;
           [ <HelpId: HELP ID, HELPID> <nHelpId> ] ;
     => ;
        [ <oMenuItem> := ] MenuAddItem( <cPrompt>, <cMsg>,;
           <.checked.>, [ Upper(<(enable)>) == "ENABLED" ],;
           [\{|oMenuItem|<uAction>\}],;
           <cBmpFile>, <cResName>, <oMenu>, <bAction>, <nState>, <nVirtKey>,;
           <.help.>, <nHelpId>)



      MENUITEM "E&xit..." ACTION oWnd:Choose()
      MENUITEM "Choose" ACTION oFont:end()

*/




/*
#translate memv->s_cur_t => thcur_t() //1
//#translate       s_cur_t => thcur_t() //
//#translate memv->s_cur_l => thcur_l() //2
//#translate       s_cur_r => thcur_r() //3
//#translate memv->s_cur_r => thcur_r() //

m1:= memv->s_cur_t
//m2:= memv->s_cur_l
//m3:= memv->s_cur_r
//return NIL

*/

/*
o:=map()
//? o
//? "asdf" $ o
//? o
? o:asdf
?
return
*/


/*
#xtranslate     o:<obj>:<fun>()                 =>      Eval( <obj> \[<fun>\],<obj> )
#xtranslate     owDisplay       => 1
//o := NewWindow(10, 20, 18, 59)
//? owDisplay
o:a:dasdf()
o:o:owDisplay() // show [1()]  "()" is an odd
*/

/*
#xtranslate     owDisplay       => 1


//#xtranslate     o:<obj>:<fun> =>      Eval( <obj> <[fun]>,<obj> )
#xtranslate     o:<obj>:<fun> =>      Eval( <obj> \[<fun>\],<obj> )
//? owDisplay
? o:o:owDisplay
o:o:owDisplay
*/

/*
#command  THREAD [KEY <key,...>]  ;
          => ;
          thread(GetList, { <key> } ) ;;
          Getlist := {}

//FUNC MAIN()
//Local key_to, akey_to
thread key key_to
thread key akey_to  //2
//preprocessor does not recognize the 1-st construction (key key_to)
//THREAD   Key key_to
//THREAD  (GETLIST , { akey_to } )
//GETLIST := {}
return
*/

/*
PUBLIC s_frame1, s_frame2
CLS
s_frame1 := "ÀÊÁ ÊÚÁ "
?? 'clip_deb 02 '
m->s_frame2 := "˝¸ÏÎÌ¸˚Î "
memv->s_frame2 := "˝¸ÏÎÌ¸˚Î "
? "end", s_frame2
?
return

*/

/*
// not fixed
clear screen
? YesVar("colViewe")
?
return


FUNCTION YesVar( cNameVar )
LOCAL SvErrorBlock
LOCAL ExVal := .F.
LOCAL tmpVar

  SvErrorBlock := ERRORBLOCK( { || VarBreak() } )
  BEGIN SEQUENCE
    ? cNameVar, isMemvar(cnamevar)
    // no such variable, and varbreak() not called
    ? &cNameVar
    ? cNameVar, isMemvar(cnamevar)
    tmpVar := &(cNameVar)
    ? cNameVar, isMemvar(cnamevar)
    ExVal := .T.
  END
  ERRORBLOCK( SvErrorBlock )

? exval
RETURN ExVal

STATIC FUNCTION VarBreak()
  ? "error"
  BREAK
RETURN Nil
*/


/*
#Translate .<objeto>:Column        =>  <objeto>\[ OR_COLUMN ]
#Translate .<objeto>:lenCol         =>  <objeto>\[ OC_LEN ]

? .oReport:Column
? .oReport:Column[nColuna]
? ..oReport:Column[nColuna]:lenCol > 0

//aReport [ Column ]

//? oReport [ Column ]

//? adsf
*/

/*
/*
#xcommand DEFAULT <uVar1> := <uVal1> [, <uVarN> := <uValN> ]      => ;
		<uVar1> := if(<uVar1> == NIL, <uVal1>, <uVar1>) ;;
		[<uVarN> := if(<uVarN> == NIL, <uValN>, <uVarN>) ;;]
*/

/*
#xcommand DEFAULT <uVar1> := <uVal1> [, <uVarN> := <uValN> ]      => ;
		<uVar1> := if(<uVar1> == NIL, <uVal1>, <uVar1>) ;
		[;; <uVarN> := if(<uVarN> == NIL, <uValN>, <uVarN>)]

*/

#xcommand DEFAULT <Desc> [, <DescN> ]      => ;
		  __DFT__( <Desc> ) [ ; __DFT__( <DescN> ) ]

#xtranslate __DFT__( <Var> = <Dft> )  => ;
	    if( <Var> == nil, <Var> := <Dft>, <Var>)

#xtranslate __DFT__( <Var> := <Dft> ) => ;
	    if( <Var> == nil, <Var> := <Dft>, <Var>)


//	    __DFT__( <Var> := <Dft> )


/*
#xcommand DATA <Vol1> => ;
	obj:<Vol1> := NIL
*/

#xcommand DATA <Vol1> [, <VolN>] => ;
	obj:<Vol1> := NIL ;
	[ ; obj:<VolN> := NIL ]


function a()
	DATA cFileName,adsf
	DATA nFontSize
	DATA aTranslate
	DATA nFontNum
	DATA nScale
	DATA lTrimSpaces

DEFAULT ;
	cFileName := "REPORT.RTF", ;
	aFontData := { "Courier New Cyr" }, ;
        b = 33
	nFontSize := 12
	nScale    := INCH_TO_TWIP

return


*/
/*
static tp_proc := NIL

function minkey(time,mask)
                switch skey
                              case 29
                        case 42
                        case 54
                        case 56
                        case 58
                        case 69
                        case 70
                        otherwise
                end
return ret

*/
/*
function trapshift(proc_name,mode)
      local ret := tp_proc
return ret


*/

/*
#command IF <condition> THEN <*aktion*>               ;
      => IF <condition> ; <aktion> ; ENDIF

IF VALType(_StepMenu)#'N ' THEN _StepMenu=1

*/



/*
@ 0,0 get v picture aPic [1][3]    // doesn't compile
@ 0,0 get v picture aPic [1] [3]    // doesn't compile
*/

/*
local p

p="{|x| if(pcount()==0,100,x)}"
y:= &p

Eval(y,1)
*/

/*
clear screen
? scankey(0)   // But if just press ALT
? scankey(0)
? nextkey()
? "inkey1=",inkey(0) // and then press SPACE key
? scankey(0)   // then issued the scan code of release SPACE key
? scankey(0)
? nextkey()
? "inkey2=",inkey(0)
? scankey(0)
? scankey(0)
?
*/
/*
clear screen
? 1,scankey(0) // gives the code press
? 2,scankey(0) // gives the code release
? 11,scankey(0) // gives the code press
? 22,scankey(0) // gives the code release
? 3,nextkey()  // does nothing - it's wrong
? 4,inkey(0)   // forward to the next pressing, although space is already fully
             // processed and should be in buffer.
? 5,inkey()   // and this gives 0 - as it should

?
*/
/*
//#translate memv -> s_cur_t => thcurt()
#translate memv->s_cur_t => thcurt()
//, preprocessor converts
? memv->s_cur_t
? memv->s_clrsong
//in thcurt() -> s_clrsong
?

*/

/*
if .f.
	public a := 1 //field->b
else
	public a := 0
endif

? a
?
*/

/*
var='QQQQ'
? "asdf &var asdf"
SET MACRO_IN_STRING OFF
? "asdf &var asdf"
?
*/

/*
// here it does not compile
@ 5,15 SAY "ë " GET TopData VALID ADDMONTH(dbalans,1)>TopData.and.TopData>=dbalans
// @ 5,15 SAY "‚ñí " GET TopData VALID ADDMONTH(dbalans,1)>TopData.and.TopData>=dbalans
// but this is normal - look as the same code!
@ 1,2 say "a" GET TopData VALID a>b.and.b>=c
*/
/*
out:=space(0); err :=space(0)

? "syscmd ret=",syscmd("clip -p test","",@out,@err)
? "out=", out
?
?
?
? "err=", err
?
return

*/
/*
_field -> (a) -> fieldname := "asdf"
// clipper this is perceived as
(a) -> fieldname := "asdf"

*/
/*
obj:=0
? Obj:P
return
*/
/*

//procedure main
local alias,i,bbb
dbcreate("aaa",{{"aaa","c",10,0}})
use aaa
alias := "aaa"
for i:=1 to 100
      bbb := "alias"+alltrim(str(i))
      (alias)->( qout("i="), qqout(i) )
next

*/

/*
//procedure main
local alias,i,bbb
use test
alias:="test"
//? 'adsfasfd'
//?
for i:=1 to 100
//	? i
      (alias)->( /*1, 1*/qout('i='), qqout(i) )
next
? 'end'
?
*/

/*
clear screen
@ 1,1 say "123456&\n234567890"
x:=wopen(10,10,20,20)
wselect(x)
wbox()
@ 1,1 say "123456&\n234567890"

*/
/*
LOCAL key:="PARAM" //+STR(ALG,3)+STR(OPER,3)+STR(ORDER,3)"
dbcreate("param",{{"PARAM","C",10,0}})
use param
INDEX ON &key TO param
//param:="dsfsfs"
s:="param"
? &s
?
*/

/*
param:="dsfsfs"
s:="m->param"
? &s  // not compiled at run-time
?
return
*/

/*
Local ca := 'TEST'

use test

? (ca)->(first)
*/

/*
//function main
parameters _from,_to
SCROLL()
 SETPOS(0 ,0)
RddSetDefault("DBFCDX")
SET ( 11 , "ON" )
SET ( 8 , "OFF" )
SET ( 101 , "OFF" )
tm =seconds()
FX_SELECT( "select " + [ code_t,sklad_id,volume from ostatok.dbf       where (sklad_id=1 or sklad_id=6)            .and. volume>0       into table exp1.dbf ] )
QOUT( seconds()-tm )
tm =seconds()
FX_SELECT( "select " + [ code_t,sklad_id,volume from ostatok.dbf        into table exp2.dbf ] )
QOUT(  )
QOUT( seconds()-tm )
tm =seconds()
FX_SELECT( "select " + [ * from ostatok.dbf        into table exp3.dbf ] )
QOUT(  )
QOUT( seconds()-tm )
*/
/*
m:={}
asize(m,65535)
//asize(m,65500)
? len(m)
? aadd(m,"")
? aadd(m,"")
? aadd(m,"")
? aadd(m,"")
? aadd(m,"")
? aadd(m,"")
? aadd(m,"")
? aadd(m,"")
? aadd(m,"")
?
return
*/
/*
local a:={1}, b[1], c
iif( valtype( b[1] )=="A", b[1], b[1] )
//b[1]:=a
? b[1]
b[1]:=a
//? 'c1', c
c:=b[1]
? 'a, c2', a, c
? 'abc', a,b,c
? len(c),valtype(c)
? c[1]
?
return nil
*/

/*
#xtranslate amemv->s_cur_t => thcurt()

qout(amemv->s_clrsong, amemv->s_cur_t )

*/

/*
while .f.
	? 'aa'
enddo
? 'bbb'
PUBLIC row_a[3]        && first row for each section
PUBLIC row_x[3]        && last row for each section

* filling by constants
row_a[1] = 6

? row_a
? row_x
?

*/

/*
a:={"first"}
aaa("&a[1]")

function aaa(a1)
? a1
// clipper here displays "&a[1]"
// may be, doesn't recognize the "&a" if 'A' isn't a string.
?
return

*/
/*
b:="test"
a:={"first"}
use test

#command IINDEX ON <key> TO <(file)> [<u: UNIQUE>];
      => aaa(;
                   <(file)>, <"key">,;
                    <{key}>,iif( <.u.>, .t., NIL);
            )

IIndex On &(a[1]) To (b)
IIndex On &b To (b)
   //       ``````   here it is not recognized neither by 'codestr'
   // or when passing parameters to a function
   // "Generally speaking, CLIPPER preprocessor recognize string
   // "&(a)" as simple (a) without any strings - just reduces "&"
   // and deletes macro and quotes


function aaa(a1,a2,a3,a4)
? a1,a2,a3,a4
?
return
*/


/*
local aColor := { ;
        {"INFO", {"R+/BG*","G+/BG*","R+/W","R+/W*","BG/BG*"}  } ,;
        {"MENU", {"W+/B*","BG+/B*","B/W*"}                    } }
local n, cVar

//? aColor
//?

for n := 1 to len( aColor )
  //? 'n', n //, cVar
  //?
  cVar := "C_" + aColor[n,1]
  //? 'cVar', cVar
  //? aColor[n,2]
  public &cVar := aColor[n,2]  // It is in this line probably does't properly
                              // handle [n,2]
	? cVar, &cVar

next
?
*/

/*
@ 1,2 Get x Picture asdf Color ("1/2")
//@ 1,2 Get x Picture (Pic[Nfield]) Color ("1/2")
//("GR+/RB") //Valid TsDocName(Nfield)
*/

/*
local NumPic := "999999999.99", NumLen := len(NumPic)

? NumPic, NumLen
?
*/
/*
FUNCTION dbf_seek2 (line, text)
LOCAL ii, first := 9999
FOR ii := 1 to (iif (isEval, 99, 1000))
   seek ( first -- )
NEXT
RETURN NIL
*/

/*
* charset cp866
CLEAR SCREEN
@ 2, 2 SAY REPLICATE(CHR(245),32)
? REPLICATE(CHR(245),32)
?
inkey(0)
*/
/*
FUNCTION dbf_seek2 (line, text)
LOCAL ii
FOR ii := 1 to (iif (isEval, 99, 1000))
? ii
NEXT
RETURN NIL

*/
/*
//func main
Exitter()
return nil

func Exitter
? 'exitter'
?
QUIT
? 'after quit'
return nil
*/

/*
#Translate .<objeto>:Column        =>  <objeto>\[ OR_COLUMN ]
#Translate .<objeto>:lenCol         =>  <objeto>\[ OC_LEN ]

? ..oReport:Column[nColuna]:lenCol > 0

*/
/*
#include "box.ch"
@ 10,10,20,20 box B_DOUBLE

//function main()
//        local N:=100
//        local A:=1,B:=2

//        clear screen
        @ 10,10,20,20 box B_DOUBLE

//        read
return
*/
/*
*** Not fixed
#Translate .<objeto>:Column        =>  <objeto>\[ OR_COLUMN ]
#Translate .<objeto>:lenCol         =>  <objeto>\[ OC_LEN ]

? ..oReport:Column[nColuna]:lenCol > 0

*/
/*
a := 2 * 2 + 1
? a

a := 2 ;
   * 2 ;
   + 1

? a
?
return
*/

/*
local aFn, qq

clear screen
aFn:={ "devout('abc')" }
//aFn:={ "{||devout('abc')}" }
//aFn:={ 0 }

//empty(aFn[1])
if !empty(aFn[1])
  aFn[1]:=&("{||"+aFn[1]+"}")
//  aFn[1]:=&("{||devout('abc')}")
//  aFn[1]:=&(aFn[1])
endif

qq:=aFn[1]

?
? aFn[1], qq, eval(afn[1]), eval(qq)
qq:=nil
? aFn[1], qq
?
return nil
*/
/*
clear screen
dispbegin()

        dispbegin()
              scr:=savescreen()
              dispout("dfsdfsd")
              restscreen(,,,,scr)
      dispend()
        dispbegin()
                // This displays until the last dispend()
              dispOutAt(10, 10, "get1", "1/2" )
      dispend()

        dispbegin()
              scr:=savescreen()
              dispout("dfsdfsd")
              restscreen(,,,,scr)
      dispend()

        dispbegin()
              dispOutAt(12, 10, "get2", "1/2" )
      dispend()

inkey(0)
dispend()
inkey(0)
? "3sgfdgdfgd"
?
return
*/

/*
//function main()
local aFn, qq

clear screen
aFn:={ "devout('abc')" }

if !empty(aFn[1])
  aFn[1]:=&("{||"+aFn[1]+"}")
endif

qq:=aFn[1]

?
? aFn[1], qq, eval(afn[1]), eval(qq)
qq:=nil
? aFn[1], qq
?
return nil
*/

/*
//function main()
//inkey(0)
? "main"
?
return nil

exit procedure fppn_eClose()
? "exit"
?
return

*/
/*
static cb:={|a|qqout(a)}
//static cb:={||qqout('a')}

function main
eval(cb,"abc")
return nil
*/
/*
function main()
? &("INKEY(0) # 13")
?
return nil
*/

/*
//Comment not processed:
#translate .<object>:AliasDBF   => <object> //[ _AliasDBF \]

//and command looks as not processed too (if comment deleted):
//#command .<object>:AliasDBF   => <object>\[ _AliasDBF \]
 .oArcDic:AliasDBF # "CLIE"
*/
/*

//this not compile
#define SET_OF_USA  [{}] + "[]" + [l;']
//#define SET_OF_USA  a+[l']

//on this generally crashed
//#define SET_OF_USA  ["{}]

? SET_OF_USA
? [asdf]
*/

/*
#define _ALIASDBF    2

#translate .<object>:AliasDBF   => <object>\[ _AliasDBF ]
//#command .<object>:AliasDBF   => <object>
  .oArcDic:AliasDBF # "CLIE"


//better yet here is:
//exactly at end just "]", but no  "\]".
//This not at one happens, probably still be such a thing

//#translate .<object>:AliasDBF   => <object>\[ _AliasDBF ]
  .oArcDic:AliasDBF # "CLIE"
*/
/*
mmm='asdf'
use \a\&mmm shared
//use \a\b\c\&mmm shared
*/

/*
*reference asdf
private x
x:="1111"
?x
asdf(x)
? x
?
return

function asdf(a)
        a:="2222"
        return
*/

/*
private a:=map()
//local a:=map()
a:b:='qwer'
a:b
a->b:='asdf'
? a->b
? a:b
?
('a')->b:='www'
? ('a')->b
?
*/

/*
x:="xbrowse"

? &x()
ret:= &x.()
? "ret=",ret
?
return

FUNC Xbrowse
? 'Xbrowse'
return 2

*/
/*
#xcommand if <true> then <action> => ;
          if <true> ; <action> ; end

 if .not. lCold then FT_PutKey( K_ENTER )
*/

/*
#xtranslate SX_DESCEND([<tag>],[<ind>]) =>      ORDDESCEND([<tag>],[<ind>])

? sx_descend(,)

*/
/*
//#command DEFAULT <p> TO <val> [, <pn> TO <valn> ]  =>;
//         <p> := IIF( <p> == Nil, <val>, <p> );     ;
//         [ <pn> := IIF( <pn> == Nil, <valn>, <pn> ) ]

#command DEFAULT <p> TO <val> [, <pn> TO <valn> ]  =>;
         <p> := IIF( <p> == Nil, <val>, <p> );
         [; <pn> := IIF( <pn> == Nil, <valn>, <pn> ) ]


DEFAULT lColour TO ISCOLOR()+a
DEFAULT cChr TO chr(254)+chr(254)
//cChr := PadR( cChr, 2 )
*/
/*

#xcommand if <true> then <action> => ;
          if <true> ; <action> ; end

#xtranslate isBetween( <val>, <lower>, <upper> ) => ;
            ( <val> \>= <lower> .and. <val> \<= <upper> )

if isBetween( nKey,97,122 ) then nKey -= 32


#translate lowbyte( <X> )       => (      if( (<X>) \< 0, 65536 + (<X>), (<X>)) % 256   )

? lowbyte(1)
?


#xtranslate SX_DESCEND([<tag>],[<ind>]) =>      ORDDESCEND([<tag>],[<ind>])

? sx_descend(,)

#xtranslate asdf => QWER

#xtranslate -\> => :
//#xtranslate -> => :

a:=map()
a->b='bbb'
? a->b
? f->a
?
*/

/*
*charset cp866
clear screen
set color to 1/2
@ 10,20 to 15,60 DOUBLE
//@ 12,30 say "è‡Æ¢•‡ÆÁ™†" // cp866->utf-8: "–ü—Ä–æ–≤–µ—Ä–æ—á–∫–∞" 
@ 12,30 say "Checking"
inkey(0)
set color to 3/4
@ 0,0,24,79 box "∞∞∞∞∞∞∞∞∞" // cp866->utf-8: "‚ñë‚ñë‚ñë‚ñë‚ñë‚ñë‚ñë‚ñë‚ñë"
inkey(0)

*/
/*
str1:="ab"+chr(0)+"c"
str2:="ab"+chr(0)+"d"
set exact on
? "This is exactly from 0-symbol in string"
? str1 = str2, str1 != str2, " => .f., .t."
set exact off
? str1 = str2, str1 != str2, " => .f., .t."
? str1 == str2   // .f.
?
? ""this is still correct :)"
set exact on
? "abc" = "", "abc" >= "", "abc" > "", " => .f., .t., .t."
? "abc" = "", "abc" <= "", "abc" < "", " => .f., .f., .f. "
? "but it doesn't understand why"
set exact off
? "abc" = "", "abc" >= "", "abc" > "", " => .t., .t., .f. "
? "abc" = "", "abc" <= "", "abc" < "", " => .t., .t., .f. "
?
return nil
*/
/*
str1:="ab"+chr(0)+"c"
str2:="ab"+chr(0)+"d"
set exact on
? str1 = str2, str1 != str2
set exact off
? str1 = str2, str1 != str2
? str1 == str2
?

*/


/*
#command IF <condition> THEN <*aktion*>               ;
      => IF <condition> ; <aktion> ; ENDIF

IF VALType(_StepMenu)#'N 'THEN _StepMenu=1

*/

/*
#translate Stable() => IF !_bdbfbrow:Stable; _bdbfbrow:ForceStable();ENDIF

stable()
*/
/*
#define ClearVScroll() FOR i:=_tp2+_h to bottom-1 ;  @ i,r_bord say '±'; NEXT // cp866->utf-8: '‚ñí'
#define ClearHScroll()  @ b_Bord,l_1 Say _Sp

ClearVScroll()

ClearHScroll()
*/

/*
#include "box.ch"

//function main()
//        local N:=100
//        local A:=1,B:=2

        clear screen
//        @ 10,10,20,20 box B_DOUBLE
      @ 11,11 say "N" get N valid ((A:=B,.T.),.T.)

        read
return


*/
/*
para a,b,c
? a,b,c
?
return

*/
/*
clear screen
//dispbegin()
DispBox(0,0,10,50)
@ 0,5 say 'Distribution of the year'
@ 1,5 say 'Distribution of the year'
//dispend()
wait
*/
/*
#xtranslate Really(<var>)=> (TYPE(<'var'>)=='L' .AND. <var>)

      IF Really(m->_AutoRestore)      // from INI
              m->_NeedRestoreVue:=.T.
      ELSE
              _i:=.T.
      ENDIF

*/
/*
static cb:={|a|qqout(a)}
//static cb:={||qqout('a')}

function main()
eval(cb,"abc")
return nil
*/
/*
#ifdef FlagShip
static aE:=0
#else
static aE:=1
#endif

function main()
   ? aE
return nil
*/
/*
#command    TB_CREATE                                                   ;
                COLUMNS       <aColumns>                                ;
                [ TITLE       <cTitle>                      ]           ;
            TO <oBrowse>                                                ;
            =>                                                          ;
            oBrowse := aaa(<aColumns>,<cTitle>)

TB_CREATE columns {a,b,c} TITLE "  " TO oFltSelBrowse

TB_CREATE ;
    columns {a,b,c} ;
    TITLE "  " ;
    TO oFltSelBrowse
*/

/*
static procedure aaa

#xtranslate procDef <name> with <par1> : <scope1> [,<parN> : <scopeN>] ;
          [ static <svar1,...> ]                                       ;
          [ local  <lvar1,...> ]                                       ;
            =>                                                         ;
            procedure <name> ( <par1> [ , <parN> ] )                   ;
        [ ; static <svar1> ]                                           ;
        [ ; local  <lvar1> ]

//static
static procDef xShadow with y1:N, x1:N, y2:N, x2:N local savedRect

   y1 += 1
   x1 += 2
   y2 += 1
   x2 += 2
   if y1 <=   maxRow() - 1 .AND. x1 <= maxCol()
      restScreen( y1, x1, y2, x2, sShadow( saveScreen( y1, x1, y2, x2)))
   endIf
return
*/
/*
#include "set.ch"

a:=map()
a:a:='a'
? set(_SET_MAPERR,.t.)

? a:a, a:b
? a
? set(_SET_MAPERR,.f.)
?
? a
? a:a, a:b


?

*/
/*
replace a with b [1]
?

*/
/*
a:="1"; b:="a"; c:="3"
ca='ca  '
clear screen
? c&b
 @ 1,1 get c&b
 read
@ 4,1 say c&b
return

*/
/*
/*************** tst.prg *************/
#xtranslate MY_SECONDS() => SECONDS()
//#xdefine MY_SECONDS() SECONDS()
function abc()
local nTime := MY_SECONDS()  AS NUMERIC
return nil
/*************************************/
*/
/*
is preprocesed correctly by clip -P tst.prg
to form:

function abc()
LOCAL nTime := SECONDS()  AS NUMERIC
return nil

*/

/*
//function main
private q1 := 1000, expr := "q1*0.133245"
 ? q1, &expr
  ?
return

*/
/*      if y2 > maxRow() - 1 then y2 := maxRow() - 1
      if x2 > maxCol()     then x2 := maxCol()*/

/*
#xtranslate is_dos() => (.t.)
#command FUNCTION  <xx> AS <yy> => FUNCTION <xx>

func f()
? f
if is_dos()             // not translated
	? 'asdf'
endif


function xyz()          // set an internal pointer in wrong state
if is_dos()             // not translated
	? 'xyz'
endif


#translate ISCHARACTER( <v1> )   => ( valtype( <v1> ) == "C" )

#command if <cond> do <*stmt*> => if <cond> ; <stmt>; endif

if isCharacter( cStr) do ? cStr

   if isCharacter( cStr)
      cCurStr := cStr
   endIf




#command IF <condition> THEN <*aktion*>               ;
      => IF <condition> ; <aktion> ; ENDIF

 IF Parce(m->_IndexFile,'I=',,@_oldind)==0 THEN Parce(m->_tmp,'I=',,@_oldind)

*/
/*
#include"inkey.ch"

cls
?Inkey(0,INKEY_KEYBOARD) // returns 0 with any mouse movement
?INKEY(0,INKEY_ALL)
?
return
*/
/*
#define MENU_RECS() Menu2({ALL_RECS,'The remaining'},;
                           _scope,;
             'Choose the scope')

MENU_RECS()
*/
/*
//local cb:={|a|qout(a)}
static cb:={|a|qout(a)}
//cb:={|a|qout(a)}

func main
eval(cb,"abc")
?
return nil
*/
/*
#xcommand DEFAULT <uVar1> := <uVal1> ;
               [, <uVarN> := <uValN> ] => ;
                 <uVar1> := Iif( <uVar1> == nil, <uVal1>, <uVar1> ) ;;
                [ <uVarN> := Iif( <uVarN> == nil, <uValN>, <uVarN> ); ]

DEFAULT lVbx:= .f., ab:=n3, a:b:=432



DEFAULT nStyle := numOR ( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU )

DEFAULT nClrText := CLR_BLACK, nClrBack := GetSysColor( COLOR_BTNFACE ), ;
         lPixels := .f., nTop := 0, nLeft := 0, nBottom := 10, nRight := 40, ;
          nWidth := 0, nHeight := 0
*/

/*
#xtranslate fs_pwrite([<xx,...>]) => GEN_OSERR(<"xx">,ERR_OS)
function testing(string)
local i
i := fs_pwrite( 0, string )
i += fs_pwrite( 0, substr( (string), i+1 ) )
return nil


*/
/*
#xtranslate funcDef <name> with <par1> : <scope1> [,<parN> : <scopeN>] ;
          [ static <svar1,...> ]                                       ;
          [ local  <lvar1,...> ]                                       ;
            =>                                                         ;
            function <name> ( <par1> [ , <parN> ] )                    ;
        [ ; static <svar1> ]                                           ;
        [ ; local  <lvar1> ]                                           ;
          ; assert( pCount() <= len( { <par1> [ , <parN> ] })          ;
                    .AND. valType( <par1> ) $ <"scope1">               ;
                  [ .AND. valType( <parN> ) $ <"scopeN"> ],            ;
                    paramCheck() + nStr( pCount())                     ;
                    + " " + valType( <par1> )                          ;
                  [ + " " + valType( <parN> ) ] )

funcDef uWStSStrPush with xElem:C
return uPush( statStrStack, xElem)

*/
/*
#xtranslate ADD_EXT(<name>,<ext>)=> (UPPER(ALLTRIM(<name>))+if('.' $<name>,'',<ext>))

? add_ext("a","b")
?
*/

/*
m:={"1","2","3", "4"}
? m
  ? m[1]
  m[1]
  ? m[1]
  Aeval( m, { | _bUndef | _bUndef } )
  ? m[1]
? m
?
return
*/
/*
#xcommand ABC <xx,...>  => qqout(<xx>)

ABC { "A", ;
 ; //      "B", ;
      "C" }


#xtranslate procDef <name>                                             ;
          [ static <svar1,...> ]                                       ;
          [ local  <lvar1,...> ]                                       ;
            =>                                                         ;
            procedure <name>                                           ;
        [ ; static <svar1> ]                                           ;
        [ ; local  <lvar1> ]                                           ;
          ; assert( pCount() = 0, paramProc() + nStr( pCount()) )

static statStrStack := {}

procDef uWStSStrInit static s1, s2 local l1,l2,l3
   statStrStack := {}
return
*/
/*
#xcommand ABC <xx,...>  => qqout(<xx>)

ABC { ;//
  ;//   "A", ;
      "B", ;
      "C" }

*/
/*
#command ABC <xx,...> AS <yy> => qqout(<xx>)
ABC x := 1 AS intvar

#command LOCAL <xx,...> AS <yy> => LOCAL <xx>
#command XLOCAL <xx,...> AS <yy> => LOCAL <xx>


local x:=1 AS INTVAR // this not translated
Xlocal x:=1 AS INTVAR // but this translated.
? x
return nil
*/

/*

//local cb:={|a|qout(a)}
static cb:={|a|qout(a)}
//cb:={|a|qout(a)}

func main
eval(cb,"abc")
?
return nil
*/
/*
#translate .<Object>:ManualSld     => <Object>\[ _ManualSld  \]
.oF:manualSld()

// specifically, if no definitions for:
.oF:DicInitget()
*/
/*
#xtranslate $1B => 27
//#xdefine $1B  27
#Translate .<Object>:ArqSld        => <Object>\[ _ArqSld  \]

#translate .<Object>:ManualSld     => <Object>\[ _ManualSld  \]
.oF:manualSld()

//function main()
a:=$1b
qout($1b)
? chr($1B)


.asdf:ArqSld

return nil

*/

/*
set Key K_F2 to asdf()

//in clipper obtained
//setket(K_F2,{|p,l,v| asdf(p,l,v)})

*/
/*
DO WHILE (pos := AT(";",txt)) != 0
	tmp := ALLTRIM(SUBSTR(txt,1,pos-1))
	IF tmp != ""
		AADD(ar,STRTRAN(tmp,CHR(1),";"))
	ENDIF
	txt := SUBSTR(txt,pos+1)
ENDDO

*/
/*
#define GET_COL         (oG:cargo[2])  // Column number of GET

oG:=map()
oG:cargo:={1,2}
col:=-10
? og
GET_COL      = col - 1          //  <=== line 132
? og
(oG:cargo[2]) = col - 1
? og

?
return

*/

/*
#command SELECT <*x*> => fx_select("select "+ \[<x>\])

select sklad_id from ostatok ;
      where (sklad_id=1 ;
         or sklad_id=6) ;
        and volume>0 ;
      group by sklad_id,code_t


*/
/*
#xtranslate IFLEX ( <a> ) => IF (LX () == <a>) ; NEXT_LEXEM ()

func a
        IFLEX(L_EOL)  // Here takes this line
            ? 1
        ENDIF
        IFLEX (L_EOL) // but this line not :)
            ? 2
        ENDIF
    return Nil
*/
/*
#xtranslate DECLARE => PRIVATE

DECLARE asdf
DECLARE fff
rqwe declare aaa
*/
/*
clear screen
? '&\001&\002&\003'
?
*/
/*

#include "ASSERT.CH"

FUNCTION uTop(aStack)
ASSERT( LEN( aStack) > 0, "Attempt to apply uTop to an empty stack" )
RETURN aTail( aStack)

*/
/*
Private c      := "cName"
Private cName1 := "Dave"
Private cName2 := "Pearson"

? .3
   ? &c.1
   ? &c.2

*/
/*
(oG:cargo[2]) = col -1
#define GET_COL         (oG:cargo[2])  // Column number of GET

GET_COL      = col - 1          //  <=== line 132
*/

/*
? loadlib("libclip-gzip")
? h:=gzipOpen("asdf.gz", "wb")
? gzipClose(h)
?
*/
/*
local bl, l:=.f.

bl := {|lEnd|  lEnd:=.t. /*atest(@lend) */}

eval(bl, @l)
qout(l)
atest(@l)
qout(l)
qout()

static function atest(lEnd)
      qout('2 lEnd=', lEnd)

      lEnd := .t.
return
*/


/*
? load(cliproot()+"/lib/libclip-gzip.so")
? h:=gzipOpen("asdf.gz", "wb")
? gzipClose(h)
?
*/
/*
function main()
 ? "Content-type: text/plain"
 ?
 ?
 ? "<HTML><BODY>hello cgi world</BODY><HTML>"
 ?
return
*/
/*
? 'before'
altd(2)
? 'after'
?
*/
/*
local a:={"asdf"}
errorBlock({|x|break(x)})  // for avoid recursion
_alert("1",a)   // this works
_alert("2",@a)  // but this :)
? a
?
return

***************************************************************
function _alert(str, mmes,colorp)
? mmes  // displays array
//? len(mmes)
? mmes[1] // but element doesn't
return
*/

/*
clear screen
set cancel off
? inkey(0)
set cancel on
? inkey(0)

?
return
*/

/*
set path to "/data/current/point/DBFS;/home/ostatok/temp"

use /home/ostatok/temp/body.dbf  SHARED
*/

/*
local am :={}

? am
asdf2( am )    // here the array should not be changed
                // and in CLIP array doesn't change
? am
asdf2(@am)     // but there must
               // and in Clipper actually an array changed - I was check.
? am
?
?
return

function asdf2(m)
        m:={3,4}
? "asdf2",m
return

*/
/*
clear screen
dispbox(0,0,24,79)
inkey(0)

*/
/*

        local p1, p2:='asdf'

	? p1, p2
	StorTest(@p1,@p2)
        ? p1, p2
        ?

*/
/*
? 'asdf'
?
*/
/*
#include <fwin/FiveWin.ch>

   @ 2,  2 BUTTON "&Start"                                     ;
      SIZE 80, 20                                              ;
      ACTION (lEnd := .F.)

   @ 2, 20 BUTTON "&End"                                       ;
      SIZE 80, 20                                              ;
      ACTION lEnd:=.T.
*/

/*
count to rw1 for at(wk1,fai0c)!=0 .and. (cpd1>=fai0a .and. cpd1<=fai0b) .and. _yy=faiyy .and. timeodr<='0700' and &cpcnd1 and (skjno1!='EVA' and skjno1!='ANK' and skjno1!='QFA' and (skjno1!='SIA' or at('*',skjno3)<>0) and (skjno1!='UPS' or at('*',skjno3)<>0))
//@  1,31 say 'asdf' get m.f pict '!!!'

//@  1,31 say 'ØËΩu:' get m.flyfrom pict '!!!'
*/
/*
				COPY TO ddbbuuuu.txt SDF
				USE &filename
				APPEND FROM ddbbuuuu.txt SDF
@ M.wt, M->wl, M->wt + M->wh + 1, M->wl + 45 BOX frame

@ ::ntop+i-1, ::nLeft say replicate(" ", ::nRight-::nLeft+1) color ::__colors[1]
@ ::ntop+i-1, ::nLeft+::findR[2]-dx-1 say substr(str, ::findR[2]-dx-xi+1, ::findR[3]) color ::__colors[4]
@ 2, fl get tab picture "9999"  color get_color


#xcommand DEFAULT <uVar1> := <uVal1> ;
               [, <uVarN> := <uValN> ] => ;
                 <uVar1> := Iif( <uVar1> == nil, <uVal1>, <uVar1> ) ;;
                [ <uVarN> := Iif( <uVarN> == nil, <uValN>, <uVarN> ); ]

DEFAULT lVbx:= .f., ab:=n3, a:b:=432



DEFAULT nStyle := numOR ( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU )

DEFAULT nClrText := CLR_BLACK, nClrBack := GetSysColor( COLOR_BTNFACE ), ;
         lPixels := .f., nTop := 0, nLeft := 0, nBottom := 10, nRight := 40, ;
          nWidth := 0, nHeight := 0

*/
/*
#include "pgch.ch"
clear screen
@ 1,10 say chr(PGCH_VLINE)+chr(PGCH_URCORNER)

*/
/*
#command SELECT <*x*> => fx_select("select "+ \[<x>\])

#command SELECT <whatever>              => dbSelectArea( <(whatever)> )

select 0
select * from a
?
return

*/
/*
reco = recno()

skip -=4
skip -1
skip ++aasd
skip //rew

skip ::a
				change ++

        QUIT               && -=[Bye]=- exit
quit

if .t.
	skip := 3
	skip -> asdf
end
skip   += 5
skip -= 10
skip 3
  funcn = boxarray[M->cursor] && to normal variable for macro

  if ++a
   	?
/* ElseIf NM == "ASIZE" .and. len (data) == 4 .and. ;
     Short (data[4]) == L_PLUS .and. ;
     Short (data[4][3]) == L_CALLFUNC .and. ;
     data[4][3][2] == "LEN" .and. ;
     EqExpr (data[3], data[4][3][3])
     data[2] := "__SIZEINCR"
     data[4] := data[4][2]
*/ endif //
if ::asdf
	? 'asdf'
	field->name
        m->fff
 /* *rqwerqe*****/ endif
*/

/*
@ a := 1, 2 SAY "TEST"
*/
/*
#command CLASS <name>                                                   ;
               [VAR <var1> [,<varn>]]                                   ;
               [METHOD <met1> = <fun1> [<metn> = <funn>]]               ;
                                                                        ;
      => function <name>                                                ;
       ;     static hClass := 0                                         ;
       ;     local aVar := {}, aMet := {}                               ;
       ;     if hClass = 0                                              ;
      [;          AAdd( aVar, <"var1"> )]                               ;
      [;          AAdd( aVar, <"varn"> )]                               ;
      [;          AAdd( aMet, { <"met1">, <"fun1"> } )]                 ;
      [;          AAdd( aMet, { <"metn">, <"funn"> } )]                 ;
       ;          hClass := __Class( <"name">, aVar, aMet )             ;
       ;     end                                                        ;
       ;     return __ClassIns( hClass )

CLASS MyClas VAR a,b,c METHOD m1 = f1 m2 = f2 m3 = f3

*/
/*
#command KEY [ <Var1> ] [B [<bVar>]] [, <VarN> ] ;
	=> Done( [ <"Var1"> ] [,<VarN> ] [, <{bVar}> ] )

KEY a, b B c d

*/
/*
for i:= iif(.t.,1,2) to iif(.t.,3,4)
  ? i
next
?
*/

/*

#define GTK_MAPPED                      128
#define GTK_WIDGET_FLAGS(wid)             (gtk_WidgetFlags(wid))
#define GTK_WIDGET_MAPPED(wid)            (NumAnd(GTK_WIDGET_FLAGS (wid),GTK_MAPPED) != 0)

GTK_WIDGET_MAPPED (wid)

for i=0 to (10)
next


*/

/*
begin sequence
  ? "begin"
//	dbskip()

  break
recover using err
  ? "recover"
  ? err  // this variable should be NIL - because break is called
        // wothout parameters
end sequence
  ? "end"
  return
*/

/*
local a:=iif( .t. ,1,2)
local b

b:=iif(.t.,3,4)
? a
? b
?
return
*/

/*
#define  UP        'up'
#define  MED       'med'
#define  LOW       'low'
#define  up        'up'
#define  med       'med'
#define  low       'low'

#command  THWND [COL <row>] [ROW <col>]                    ;
                 KEY <key,...>                             ;
                [COLOR <cl>]                               ;
                [TO <to>]                                  ;
                [KEYEXIT <ke>]                             ;
                [HEAD <head>]                              ;
                [HELP <help>]                              ;
                [FLAG POINTS <fp>]                         ;
                [<ck: CLEARKEY>]                           ;
                 <list,...>                                ;
          =>                                               ;
          S_ThWnd( <col>, <row>, <cl>, <help>, <to>, <ke>, ;
                  { <key> }, { <list> }, <fp>, <head>, <.ck.>)

#command  THWND [COL <row>] [ROW <col>]                     ;
                 KEY ALL                                    ;
                [COLOR <cl>]                                ;
                [TO <to>]                                   ;
                [KEYEXIT <ke>]                              ;
                [HEAD <head>]                               ;
                [HELP <help>]                               ;
                [FLAG POINTS <fp>]                          ;
                [<ck: CLEARKEY>]                            ;
                 <list,...>                                 ;
          =>                                                ;
          S_ThWnd( <col>, <row>, <cl>, <help>, <to>, <ke>,  ;
                  {}, { <list> }, <fp>, <head>, <.ck.> )

#command  THWND [COL <row>] [ROW <col>]                   ;
                 TIME <time>                              ;
                [COLOR <cl>]                              ;
                [HEAD <head>]                             ;
                [HELP <help>]                             ;
                [FLAG POINTS <fp>]                        ;
                [<ck: CLEARKEY>]                          ;
                 <list,...>                               ;
          =>                                              ;
          S_ThWnd( <col>, <row>, <cl>, <help>,,, <time>,  ;
                  { <list> }, <fp>, <head>, <.ck.> )

#command  THWND [COL <row>] [ROW <col>]                                   ;
                [COLOR <cl>]                                              ;
                [TO <to>]                                                 ;
                [HEAD <head>]                                             ;
                [HELP <help>]                                             ;
                [FLAG POINTS <fp>]                                        ;
                [<ck: CLEARKEY>]                                          ;
                 <list,...>                                               ;
          =>                                                              ;
          S_ThWnd( <col>, <row>, <cl>, <help>, <to> ,,, { <list> }, <fp>, ;
                   <head>, <.ck.>)

#command  THMSG [COL <row>] [ROW <col>]          ;
                 TIME <time>                     ;
                [COLOR <cl>]                     ;
                [HEAD <head>]                    ;
                 <list,...>                      ;
          =>                                     ;
          THWND [COL <col>] [ROW <row>]          ;
                 TIME <time>                     ;
                [COLOR <cl>]                     ;
                 HELP 'press any key'            ;
                [HEAD <head>]                    ;
                 FLAG POINTS .f.                 ;
                 CLEARKEY                        ;
                 <list>

#command  THMSG [COL <row>] [ROW <col>]          ;
                [COLOR <cl>]                     ;
                [HEAD <head>]                    ;
                 <list,...>                      ;
          =>                                     ;
          THWND [COL <col>] [ROW <row>]          ;
                [COLOR <cl>]                     ;
                 HELP 'press any key'            ;
                [HEAD <head>]                    ;
                 FLAG POINTS .f.                 ;
                 CLEARKEY                       ;
                 <list>

#command  SETMSG <list,...>                                       ;
          => if( s_clrsong == 1, TONE (150,0), )                  ;
        ;  THMSG COL LOW ROW LOW TIME 15 COLOR s_clr_msg <list>


//cls
THMSG COL 1 ROW 3 TIME 15 COLOR s_clr_msg 'list'
//THMSG COL LOW ROW LOW TIME 15 COLOR s_clr_msg 'list'
setmsg 'Wooohoooo ...', 'aasdf'
*/

/*
clear screen
@ 1,1 say "sfsdfs" get a picture "@S20"
read
*/

/*
static a,b,c as asdf,d,e as asdf2
local a1,b1,c1 as int
loca as
static f as array
static r

? a,b,c,as
?

func asdf(p1, p2, p3 as map)
	? p3
return

function asdf1(a,b,c as asdf, d as asdf2)  as asdf3
return


*/
/*
if .t.
	? 'if'
endif asdf
endif

enddo qwer
endcase rqewr
endfor zxvc

*/
/*
str:= "{"
for i=1 to 258
        str+=alltrim(str(i))+","
next
str+="259 }"
s:={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259}
? s
? str
? &str
?

return

*/
/*
#command LOCAL <xx,...> AS <yy> => LOCAL <xx>

local x:=1 AS INTVAR
? x
?

*/
/*
static func_1 := 1

//function main()

? func_1
return nil

*/
/*
#define STR   3
str:=&str
*/
/*
use test

? age
? test->age += 3
? age
a:={|| test->age = 3}
? eval(a)
? age
?

*/
/*
//use test

select 1

*/
/*
use test

? first
TEST->(dbskip(1))
? first
test->(dbskip(1))    // while executing - bad alias
? first
?


*/
/*
arr:={1,3,4}
asize(arr, 10)
? afull(arr)
? arr
?


******
*	afull()
*
*	find the number of contiguous full elements before the first null string
******
FUNCTION afull

PARAMETERS array
PRIVATE i

* perform exact search
SET EXACT ON

* search for null string
i = ascan(M->array, "")

? 'i=', i
? 'm->i =', m->i

* back to normal
SET EXACT OFF

IF M->i = 0
	* no null strings means completely full
	i = LEN(M->array)

ELSE
	* element of first null string - 1
	i = M->i - 1

ENDIF

RETURN M->i

*/

/*
STATIC aFLitem  := {,, " ~File                    ",, .t., -1000,"Redirect printing to file",}

#define Redirect aFLitem[4]

func fff
aFLitem:={}
Redirect:=4        // On this statement got message about undefined variable
? aFLitem[1]
return nil

*/
/*
Field age

use test

? age

//test->age += 10
age += 10
//Field->age += 10


? age
?
*/
/*
m:=map()
m:asdf='asdf'
? m
f(m)

function f
? 'asdf:', ::asdf
? 'self:', __self__
?
return


*/
/*
    #xtranslate  IsFlock() => (.f.)
    #xtranslate  append_rec() => DbAppend(.f.)

    #xtranslate  IsSIXdrv() => (.f.)

    #xtranslate  CompressTxt( <str> )   => <str>
    #xtranslate  DeCompressTxt( <str> ) => <str>

    #xtranslate  EnCryptTxt( <str> [, <key>] ) => EnKodMix( <str> [, <key>] )
    #xtranslate  DeCryptTxt( <str> [, <key>] ) => DeKodMix( <str> [, <key>] )

    #xtranslate  DBFpass( [<pass>] )    =>
    #xtranslate  IsDBFcrypt()           => (.f.)
    #xtranslate  DBFencrypt( [<pass>] ) =>


    #xtranslate fs_select(   [<xx,...>] ) => GEN_OSERR(.f.)
    #xtranslate fs_ferror(   [<xx,...>] ) => GEN_OSERR(ERR_OS)
    #xtranslate fs_fcreate(  [<xx,...>] ) => GEN_OSERR(ERR_OS)
    #xtranslate fs_popen(    [<xx,...>] ) => GEN_OSERR(0)
    #xtranslate fs_pclose(   [<xx,...>] ) => GEN_OSERR(ERR_OS)
    #xtranslate fs_pwrite(   [<xx,...>] ) => GEN_OSERR(ERR_OS)
    #xtranslate fs_pread(    [<xx,...>] ) => GEN_OSERR(ERR_OS)
    #xtranslate fs_open_rs(  [<xx,...>] ) => GEN_OSERR(ERR_OS)
    #xtranslate fs_net_rs(   [<xx,...>] ) => GEN_OSERR(ERR_OS)
    #xtranslate fs_close_rs( [<xx,...>] ) => GEN_OSERR(ERR_OS)
    #xtranslate fs_reini_rs( [<xx,...>] ) => GEN_OSERR(ERR_OS)
    #xtranslate fs_stop_rs(  [<xx,...>] ) => GEN_OSERR(ERR_OS)
    #xtranslate fs_canrd_rs( [<xx,...>] ) => GEN_OSERR(ERR_OS)
    #xtranslate fs_clrbf_rs( [<xx,...>] ) => GEN_OSERR(ERR_OS)
    #xtranslate fs_write_rs( [<xx,...>] ) => GEN_OSERR(ERR_OS)
    #xtranslate fs_read_rs(  [<xx,...>] ) => GEN_OSERR(ERR_OS)
    #xtranslate fs_addstrm(  [<xx,...>] ) => GEN_OSERR(ERR_OS)
    #xtranslate fs_delstrm(  [<xx,...>] ) => GEN_OSERR(ERR_OS)
    #xtranslate fs_stpstrm(  [<xx,...>] ) => GEN_OSERR(ERR_OS)
    #xtranslate fs_runstrm(  [<xx,...>] ) => GEN_OSERR(ERR_OS)
    #xtranslate fs_timstrm(  [<xx,...>] ) => GEN_OSERR(ERR_OS)
    #xtranslate fs_clrstrm(  [<xx,...>] ) => GEN_OSERR(ERR_OS)
    #xtranslate fs_canstrm(  [<xx,...>] ) => GEN_OSERR(ERR_OS)
    #xtranslate fs_sndstrm(  [<xx,...>] ) => GEN_OSERR(ERR_OS)
    #xtranslate fs_recstrm(  [<xx,...>] ) => GEN_OSERR(ERR_OS)

    #xtranslate is_dos() => (.t.)
    #xtranslate beep(<nFrq>,<nTi>)      => rc_tone(<nFrq>,<nTi>)
    #xtranslate rc_tone(<nFrq>,<nTi>)   => cl_tone(<nFrq>,<nTi>)
    #xtranslate secondscpu([<nType>])   => rc_seconds()
    #xtranslate rc_seconds()            => seconds()
    #xtranslate rc_sleep(<nMiliSec>)    => cl_sleep(<nMiliSec>)
    #xtranslate rc_cursor([<nShape>])   => setcursor([<nShape>])
    #xtranslate rc_faccess(<cFi>,<cRi>) => cl_faccess(<cFi>,<cRi>)
    #xtranslate strpeek(<cStr>,<nPos>)        => asc(substr(<cStr>,<nPos>,1))
    #xtranslate strpoke(<cStr>,<nPos>,<nVal>) => stuff(<cStr>,<nPos>,1,chr(<nVal>))

    #command PROTOTYPE [<xx,...>] =>
    #command FUNCTION  <xx> AS <yy> => FUNCTION <xx>
    #command PROCEDURE <xx> AS <yy> => PROCEDURE <xx>
    #command STATIC FUNCTION  <xx> AS <yy> => STATIC FUNCTION <xx>
    #command STATIC PROCEDURE <xx> AS <yy> => STATIC PROCEDURE <xx>
    #command LOCAL <xx,...> AS <yy> => LOCAL <xx>
    #xcommand LOCAL_INT    <xx,...>  => LOCAL <xx>
    #xcommand LOCAL_BYTE   <xx,...>  => LOCAL <xx>
    #xcommand LOCAL_LONG   <xx,...>  => LOCAL <xx>
    #xcommand LOCAL_DOUBLE <xx,...>  => LOCAL <xx>

    #xcommand STATIC_INT    <xx,...>  => STATIC <xx>
    #xcommand STATIC_BYTE   <xx,...>  => STATIC <xx>
    #xcommand STATIC_LONG   <xx,...>  => STATIC <xx>
    #xcommand STATIC_DOUBLE <xx,...>  => STATIC <xx>
    #xcommand STATIC <xx,...> AS <yy> => STATIC <xx>
    #xcommand ASDF1 <xx,...> AS <yy> =>
    #xcommand ASDF2 <xx,...> AS <yy> =>
/*


  #xcommand c2blck_and( <cond>, <cDelim>, <cParam> ) => ;
     <cond> := iif( empty( <cond> ), nil,;
                  iif( len( <cond> ) > MX_CMP_LEN,;
                    MkBlckAnd( <cond>, <cDelim>, <cParam> ),;
                    &( "{|" + <cParam> + "|" + <cond> + "}" ) ) )

  #xcommand c2blck_plus( <cBlock>, <cDelim>, <cParam> ) => ;
     <cBlock> := iif( empty( <cBlock> ), nil,;
                    iif( len( <cBlock> ) > MX_CMP_LEN,;
                      MkBlckPlus( <cBlock>, <cDelim>, <cParam> ),;
                      &( "{|" + <cParam> + "|" + <cBlock> + "}" ) ) )
*/

function copyto(fi)
SET DELETE OFF
COPY TO (fi)
SET DELETE ON
return nil
*/

/*
use test
?  1->first
? &("1->first")
?
*/
/*
dbseek(str(1->kod,4),.t.)
do while eof()=.f. .and. kod=1->kod
     us_del()
     dbunlock()
     dbskip()
enddo

*/
/*
keystroke:=4
menu_func:=2
x:=0

/*DO CASE
	CASE M->keystroke = 13 .OR. M->x = M->menu_func
		r = 1
*/
//qout(M->keystroke = 27 .OR.;
//	m -> keystroke = 19)
qout(;
	m -> keystroke == 19)

/*		r = 0
endcase*/
*/

/*
text ->(dbclose())
close text    // Command text
*/
/*
function xyz()
field  y
memvar x
private x:="test"

outstd(x)
eval({||outstd(x)})

outstd(y)
eval({||outstd(y)})

return nil
*/

/*
static a := { 1,2,3, a[1]}

? a
?
*/

/*
field;
	first
memvar;
	m1,m2;
        ,m3

append blank
?
return

*/
/*
label       :=iif(valtype(label)=="C", label, "hello")
?

*/

/*
#xcommand DEFAULT <uVar1> := <uVal1> ;
               [, <uVarN> := <uValN> ] => ;
                 <uVar1> := If( <uVar1> == nil, <uVal1>, <uVar1> ) ;;
                [ <uVarN> := If( <uVarN> == nil, <uValN>, <uVarN> ); ]


DEFAULT lVbx := .f., nStyle := numOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU )

DEFAULT nClrText := CLR_BLACK, nClrBack := GetSysColor( COLOR_BTNFACE ), ;
         lPixels := .f., nTop := 0, nLeft := 0, nBottom := 10, nRight := 40, ;
          nWidth := 0, nHeight := 0

*/


/*
Type:=  2
Type :=  2
Type=  2
Type =  2
Type;
	;
;
	:=  2
Type;
	=  2

? __LINE__

*/
/*
//with TERM=linux-console - works as well,
//but with TERM=linux-koi8 - such a miracle on the screen displays :)
*charset cp866
clear screen
set color to 1/2
@ 10,20 to 15,60 DOUBLE
@ 12,30 say "Checking"
inkey(0)
set color to 3/4
@ 0,0,24,79 box "∞∞∞∞∞∞∞∞∞" // cp866->utf-8: "‚ñë‚ñë‚ñë‚ñë‚ñë‚ñë‚ñë‚ñë‚ñë"
inkey(0)

*/
/*
calias := "test"
cf := "first"
nsum :=time()
use test
select 0
? test->first
(cAlias)->&(cf) := nSum    // this
? test->first
?
return

*/
/*
field->first += 110
field->first ++
*/
/*
for nm := if(lMes == nil, 1, m_mes) to m_mes
	? nm
        ? nil
next
*/
/*
 (cAlias)->&(cf) := nSum    // this

*/
/*
? '1'
xyz()
? '2'
?

function xyz()
static x := chr(27) + "A"
static y :=4
? 'x=', x
?
return nil
*/
/*
#xcommand ASDF ;
        [ ACTION <uAction,...> ] ;
        [<enable: ENABLED, DISABLED>];
         =>;
        asdf( <(enable)> )

asdf action bbb disabled
asdf action bbb

//? 'asdf'
//?

*/
/*
#command ASDF     ;
      => ;
      	asdf screen; asdf gets
//          ASDF GETS;
//          ; asdf screen


          //;
//          ; ASDF GETS

#command ASDF SCREEN => asdf()
#command ASDF GETS => asdfg()

asdf gets; asdf screen
asdf
?
*/

/*
? '1'
xyz()
? '2'
?

function xyz()
static x := chr(27) + "A"
? 'x=', x
?
return nil
*/
/*
function xyz()
public;
    a:=1,;
    b:=3;    c:=5
    ? a
return nil

*/


/*
#command  THREAD [FROM <no>] [KEY <key,...>] [TO <to>] [FLAG CHANGE <fch>] ;
          [KEYEXIT <ke>] [FIELDEXIT <fe>] SAVE ;
                    =>;
          thread(GetList, <no>, { <key> }, <to>, <fch>, <ke>, <fe> )

thread from nGet key {aKeyExit, aSetKeyKb  } to asdf;
  fieldexit @nGet flag change @lUpd  SAVE


thread from nGet;
  fieldexit @nGet flag change @lUpd  key {aKeyExit, aSetKeyKb}, qwer  SAVE

return NIL
*/
*/
/*
static b:='bbb'
static a := { {|| b() }, {|| c() }, b }

? a
eval(a[1])

return

func b
	? 'b'
	?
return
*/
/*
Static aNachs  := {'nachs',, .t., {, 'NN'}}     // utf-8: ‚î¨‚ïö‚ïó ‚ïû‚ïù ‚ïú‚ïù‚ïí‚ïù‚ïõ–¶
field;
   xx // asdf
local a
Memvar IsPred

? xx, ispred, anachs
*/
/*
function main()
static x := (-1)
memvar y
private y := 10
? x, y
?
return nil
*/
/*
#xdefine OrdBagExt() IndexExt()
ordBagExt()
? ordBagExt()
?
*/
/*
#command DEFINE WINDOW <cName> ;
	 [AT <(x1)>,<(y1)>];
	 [SIZE <(x2)>,<(y2)>] ;
	 [TITLE <title>] ;
	 [FOOTER <footer>] ;
	 [<system: SYSTEM>] ;
	 [<double: DOUBLE>] ;
	 [<panel:  PANEL>] ;
	 [<none:  NONE>] ;
	 [<shadow: SHADOW>] ;
	 [<zoom: ZOOM>] ;
	 [<float: FLOAT>] ;
	 [COLOR <color>] ;
	 => ;
         fx_wDefine(<"cName">,<x1>,<y1>,<x2>,<y2>,<"title">,<"footer">,;
         	<.system.>,<.double.>,<.panel.>,<.none.>, ;
         	<.shadow.>,<.zoom.>,<(color)>)

clear screen
//	 <*x*> ;

//this command is executed

    define window moddays at 1,1 size 1,20 system shadow ZOOM float;
        title '≠◊ßÔ§È¥¡' color N/W+

// but this not - probably color is not perceived

    define window moddays at 1,1 size 1,20 system shadow ZOOM float;
         color N/W+ title '≠◊ßÔ§È¥¡'
*/

/*
dimension weekstr(7)
weekstr(1)='1§È'
weekstr(2)='2§@'
weekstr(3)='3§G'
weekstr(4)='4§T'
weekstr(5)='5•|'
weekstr(6)='6§≠'
weekstr(7)='7§ª'
wk:=1
// weekstr perceived as function
? weekstr(val(wk)+1)
? weekstr(2)
?

*/
/*
function main()
memvar X
private X
//private X := 10
? X
?
return nil
*/

/*
#define MGTERM_REC(tim,ln);
	chr( tim ) + ;
	chr( ln )

? MGTERM_REC(65,66)
?

*/

/*
#command  THREAD [FROM <no>] [TO <to>] [FLAG CHANGE <fch>] ;
          [KEYEXIT <ke>] [FIELDEXIT <fe>] [KEY <key,...>] SAVE ;
                    =>;
           thread(GetList, <no>, { <key> }, <to>, <fch>, <ke>, <fe> )

//thread from nGet key {aKeyExit, aSetKeyKb  };
//  fieldexit @nGet flag change @lUpd  SAVE

thread from nGet to fff fieldexit nGet key aKeyExit  SAVE

return NIL

*/

/*
#xdefine AND .AND.

if ( a AND b )
	? a
fi

@ 5,17 get cmpy pict '9' valid cmpy>='1'  and cmpy<='3' // &&±∆ß«

*/
/*
Memvar m_mes
//field m_mes

func main
Local nn := m_mes
return nil
*/
/*
dimension a1(1),a2(1,2),a3(1,2,3)
a1(1) = "asdasd"
a2(1,1) = "32142"
? a1
? a2
? a3
?
*/
/*
memvar adsf
field;
 first

use test

asdf:='asdf'

? m->asdf
? m.asdf
? m .or.m
? m.and.m
//? field->first
//? f->first
//? field.first
//? f.first
//? field(asdf)

?

*/
/*
static x := (-1)
? x

*/
/*
Static aNachs  := {'nachs',, .t., {, 'NN'}}

field;
  xx // asdf
 /* because of this transfer XX */
Memvar IsPred

Function Main(cPath, cPal, cName)
Return nil
?
return
*/

/*
local d:={10.22.1903}
? d
d:={1.1.0}
? d
?
*/
/*
x:='obj:=map(), obj:OAUTOSAVE:=.F.'
? &x
?

*/
/*
local i
public pub1:='pub1', pub2:='pub2'

? start(@f1(), 'p1', 'p2', 'p3')

for i=1 to 10
	? 'main:', i, 'pub2', pub2
	sleep(1)
next

?
return

static func f1(a,b,c)
local i

? 'f1: pub1', pub1
? 'f1: pub2', pub2
pub2:=22
? 'f1: a', a
? 'f1: b', b
? 'f1: c', c

taskstop()
for i=1 to 10
	? 'f11:', i
	pub2:=i
	sleep(0.5)
next
taskstart()

for i=1 to 10
	? 'f12:', i
	pub2:=i
	sleep(0.5)
next


return

*/
/*
local value,val,obj
value:="1"
obj:=map()
val:=@value
obj:val:=@value
? value,val,obj:val
value:="2"
? value,val,obj:val
obj:val:="3"
? value,val,obj:val
val:="4"
? value,val,obj:val
val:=@nil
val:='V'
? value,val,obj:val
obj:val:=@nil
? value,val,obj:val
?
return
*/

/*
local a1 :="first"
use test
? first
? field->&(a1)
? field->&(a1) := time()
? first
?

*/
/*
local vVar := 1,a:="test->first "
use test
select 0
? field->&a
? field->&a :=  time()+&a
? test->first
?
return
*/
/*
local value,obj
    value:="werty"
    obj:=getobj()
    obj:val:=@value
    value:="asdfg"
? value
? obj:val
    obj:val:="zxcvb"
? value
? obj:val
?
return

function getobj()
local obj:=map()
    obj:val	:=nil
return obj
*/
/*
use test
a:="test->first"
//a:="first"
? field->&a
?
return
*/
/*
ii:=0
while ( 1+2,1+2,1+2,1+2,1+2,1+2,1+2,1+2, ii<10)
    ii:=II+1
    ? ii
enddo
?
return

*/
/*
#xcommand DEFINE CURSOR <oCursor> ;
	     [ <resource: RESOURCE, RESNAME, NAME> <cResName> ] ;
	     [ <predef: ARROW, ICON, SIZENS, SIZEWE, SIZENWSE,;
	      SIZENESW, IDEAM, ; // dafdsasd
	      CROSS> ] ;
       => ;
	  <oCursor> := TCursor():New( <cResName>, [ Upper(<(predef)>) ] )

define cursor asdf arrow resname qqq

*/
/*
#xcommand SET <asdf > ;
      => ;
	 qwer(<asdf>)
*/

/*
#xcommand @ <nRow>, <nCol> BUTTONBAR [ <oBar> ] ;
	     [ SIZE <nWidth>, <nHeight> ] ;
	     [ BUTTONSIZE <nBtnWidth>, <nBtnHeight> ] ;
	     [ <look3d: 3D, 3DLOOK> ] ;
	     [ <mode: TOP, LEFT, RIGHT, BOTTOM, FLOAT> ] ;
	     [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
	     [ CURSOR <oCursor> ] ;
      => ;
	 [ <oBar> := ] TBar():NewAt( <nRow>, <nCol>, <nWidth>, <nHeight>,;
	     <nBtnWidth>, <nBtnHeight>, <oWnd>, <.look3d.>, [ Upper(<(mode)>) ],;
	     <oCursor> )

*/
/*
a:={9, 8, 0, 3, 2, 1, 0}
for x in a
? "Select "+str(x, 1)

do switch x
case 0
? "   Selected OK"
case 1
? "   Selected OK"
case 2
? "  Selected OK"
case 3
? "  Selected OK"
case 4
? "  Selected OK"
case 5
? "  Selected OK"
case 6
? "  Selected OK"
case 7
? "  Selected OK"
case 8
? "  Selected OK"
case 9
? "  Selected OK"
otherwise
? "  Selected FIGNJA"
endswitch
next
?

*/

/*
#define GTK_FONT_FILTER_BASE		0 /* the base filter, which can't be changed by the user. */
#define GTK_FONT_FILTER_USER		1 /* the user filter, which can be changed from within
					     the 'Filter' page of the GtkFontSelection widget. */

/* A set of bit flags used to specify the type of fonts shown when calling
 * gtk_font_selection_dialog_set_filter() or gtk_font_selection_set_filter(). */


*/
/*
_Undef7 := Tbcolumnne( XTOC(xValue), _Undef4[ nNum ], ;
		fieldwbloc( _Undef5[ nNum, 1 ], ;
			   Select()            ;
				     )                     ;
			 )

*/
/*
#command  THWND [COL <row>] [ROW <col>]                   ;
		 TIME <time>                              ;
		[COLOR <cl>]                              ;
		[HEAD <head>]                             ;
		[HELP <help>]                             ;
		[FLAG POINTS <fp>]                        ;
		[<ck: CLEARKEY>]                          ;
		 <list,...>                               ;
	  =>                                              ;
	  S_ThWnd( <col>, <row>, <cl>, <help>,,, <time>,  ;
		  { <list> }, <fp>, <head>, <.ck.> )
/*
S_ThWnd( "low", "low", s_clr_msg, "press any key",,, 15, { "Woohooo
..." }, .F.,, .T. )

Clip preprocessor
S_THWND( 'low', 'low', S_CLR_MSG, 'press any key',,, 15, { 'Woohooo
...' }, .F. CLEARKEY ,,.F. )
*/

//THWND col 1 row 10 time 15 color 'bg+/r' 'press any key'
//THWND  time 15 help 'press any key' color 'bg+/r' flagpoints .f. clearkey 'hihihi'
THWND  time 15 flag points .f. clearkey 'hihihi'
*/
/*
aaa()
?
return

func aaa
	? a->b
return

*/
/*
fff(@f1())
?
return

function fff(p)
? 'fff:', p
? eval(p,'asdf')
?



function f1(p)
? 'f1:', p
return .t.

*/
/*
local id1, id2

id1:=start("f1")
id2:=start("f2")

for i=1 to 10
	? 'main: send to ', id1, i, TaskSendMsg(id1, i)
	? 'main: send to ', id2, i, TaskSendMsg(id2, i)
	sleep(1)
next

?
return

func f1
local m

while .t.
	m:=TaskGetMsg()
	? 'f1: got', m
end

func f2
local m

while .t.
	m:=TaskPeekMsg()
	? 'f2: got', m
	sleep(0.5)
end

*/
/*
aaa()
?
return
func aaa
	? a->b
return
*/
/*
? inbyte('0x220')
?
*/
/*
static time_close:=.f.

clear screen
showtime(0,70)
inkey(0)
showtime()
inkey(0)
?
return

function showtime(x,y,lSeconds,cColor,n12,lAm)

	if pcount()==0
		time_close:=.t.
	else
		start("ct_showtime",x,y,lSeconds,cColor,n12,lAm)
	endif

return

function ct_showtime(x,y,lSeconds,cColor,n12,lAm)
	local row,col
	while !time_close
		row:=row(); col:=col()
		@ x,y say time() color cColor
		devpos(row,col)
		sleep(1)
	end

return
*/

/*
local i
public pub1:='pub1', pub2:='pub2'

? start("f1", 'p1', 'p2', 'p3')

for i=1 to 10
	? 'main:', i, 'pub2', pub2
	sleep(1)
next

?
return

func f1(a,b,c)
local i

? 'f1: pub1', pub1
? 'f1: pub2', pub2
pub2:=22
? 'f1: a', a
? 'f1: b', b
? 'f1: c', c

taskstop()
for i=1 to 10
	? 'f11:', i
	pub2:=i
	sleep(0.5)
next
taskstart()

for i=1 to 10
	? 'f12:', i
	pub2:=i
	sleep(0.5)
next


return
*/
/*
set color to "b/w+"
? setcolor()

set color to "b/w*"
? setcolor()

set color to "b/w*+"
? setcolor()

?
*/






/*

#command SUM [ <x1> [, <xn>]  TO  <v1> [, <vn>] ]                       ;
		 [FOR <for>]                                                    ;
		 [WHILE <while>]                                                ;
		 [NEXT <next>]                                                  ;
		 [RECORD <rec>]                                                 ;
		 [<rest:REST>]                                                  ;
		 [ALL]                                                          ;
																		;
	  => <v1> := [ <vn> := ] 0                                          ;
	   ; if ( set(_SET_OPTIMIZE) )                                      ;
	   ;    DBEvalOptimize(                                             ;
			{|| local( <#v1#>:=@<v1> [, <#vn#>:=@<vn>]),	    ;
			<#v1#> := <#v1#> + <x1> [, <#vn#> := <#vn#> + <xn> ]},     ;
			[codestr( <for> )], <{while}>, <next>, <rec>, <.rest.> ;
			   )                                                        ;
	   ; else                                                           ;
	   ;    DBEval(                                                     ;
			{|| local( _##<v1>:=@<v1> [, _##<vn>:=@<vn>]),	    ;
			_##<v1> := _##<v1> + <x1> [, _##<vn> := _##<vn> + <xn> ]},     ;
			<{for}>, <{while}>, <next>, <rec>, <.rest.>            ;
			   )                                                        ;
	   ; end

sum f1,f2,f3,f4 to s1,s2,s3,s4 for first<100
sum f1,f2,f3 to s1[1],s1[2],s3[3] for fi
*/
