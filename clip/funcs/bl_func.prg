// BL Interpreter
#ifdef FSHIP
#include "inkey.fh"
#else
#include "inkey.ch"
#endif
#define comm_char '//'
#ifdef FSHIP
#define x_EOL (chr(10))
#else
	#ifdef __CLIP__
		#define x_EOL (chr(10))
        #else
		#define x_EOL (chr(13)+chr(10))
	#endif
#endif
#define x_comment -2
#define x_eval -1
#define x_if 0
#define x_else 1
#define x_endif 2
#define x_while 3
#define x_endw 4
#define x_for 5
#define x_next 6
#define x_private 7
#define x_public 8
#define x_release 9
#define x_exit 10
#define x_loop 11
#define x_proc 12
#define x_endp 13
#define x_call 14
#define x_write 15
#define x_return 16
#define x_push 17
#define x_pop 18
#define x_param 19
#define x_block 20
#define x_elif 21
#define x_loadlib 22

#ifdef __CLIP__
	#define myalert  alert
#else
	#translate myalert => alert
#endif

memvar aCommStack,blStack

static blprocs:={}

function progparse(s)
local a
local aCode:={}
local i,n,cTok,nTok
static x_keywords:={"if","else","endif","while","endw","for","next",;
                    "private","public","release","exit","loop",;
                    "proc","endp","call","write","return","push","pop",;
                    "param","block","elif","loadlib"}
memvar aCommStack
private aCommStack:={}
blprocs:={}
a:=lineparse(s,x_EOL)
for i:=1 to len(a)
  a[i]:=alltrim(a[i])
  aadd(aCode,nil)
  if substr(a[i],1,len(comm_char))==comm_char .or. empty(a[i])
    aCode[len(aCode)]:={x_comment,a[i]}
  else
    n:=at(' ',a[i])
    if n<>0
      cTok:=substr(a[i],1,n-1)
    else
      cTok:=a[i]
      n:=len(a[i])
    endif
    do case
    case ((nTok:=ascan(x_keywords,lower(cTok)))<>0) .and. ((nTok-1)<>x_loadlib)
      aCode[len(aCode)]:={nTok-1,commparse(aCode,nTok-1,substr(a[i],n+1))}
    case (nTok-1)==x_loadlib
      aCode[len(aCode)]:={x_comment,a[i]}
      loadprocs(substr(a[i],n+1),a)
    otherwise
      aCode[len(aCode)]:={x_eval,mkblk(a[i],i)}
    end case
  endif
next
chkstack(aCommStack)
release aCommStack
return aCode

function chkstack(a)
local i,s
if len(a)==0
 return .t.
endif
for i:=1 to len(a)
  myalert("Uncomplete operator in line "+alltrim(str(a[i][2])),{'Ok'})
next
return .f.

function mkblkerr(e,i)
myalert('Error in expression in line '+alltrim(str(i)),{'Stop'})
BREAK(e)
return e

function mkblk(s,i,ReadyBlock)
STATIC e
LOCAL r,errblk,c
e:=errorblock({|err| mkblkerr(err,i)})
begin sequence
  if ReadyBlock==nil
    c:=if(empty(s),'.t.',s)
    r:=&("{|| "+c+"}")
  else
    r:=&(s)
  endif
recover using errblk
  r:=nil
end sequence
errorblock(e)
return r

function commparse(aCode,nTok,s)
local r,k,n,i
do case
  case nTok==x_if
    /*
       if --> {x_if,{if_blk,else_pc,endif_pc,elif_pc}}
    */
    r:={mkblk(s,len(aCode)),0,0,0}
    apush(aCommStack,{x_if,len(aCode)})
  case nTok==x_elif
    /*
      elif --> {x_elif,{if_blk,else_pc,endif_pc,elif_pc,if_pc}}
    */
    k:=apop(aCommStack)
    if k<>nil .and. (k[1]==x_if .or. k[1]==x_elif)
      aCode[k[2]][2][2]:=len(aCode)
      r:={mkblk(s,len(aCode)),0,0,0,IF(k[1]==x_if,k[2],aCode[k[2]][2][5])}
    else
      myalert('ELIF without IF in line '+alltrim(str(len(aCode))),{'Ok'})
      r:=nil
    endif
    apush(aCommStack,{x_elif,len(aCode)})
  case nTok==x_else
    /*
       else --> {x_else,if_pc}
    */
    k:=apop(aCommStack)
    if k<>nil .and. (k[1]==x_if .or. k[1]==x_elif)
      apush(aCommStack,k)
      r:=k[2]
      aCode[r][2][2]:=len(aCode)
      if k[1]==x_elif
        n:=aCode[k[2]][2][5]
        aCode[n][2][3]:=len(aCode)
      endif
    else
      myalert('ELSE without IF in line '+alltrim(str(len(aCode))),{'Ok'})
      r:=nil
    endif
  case nTok==x_endif
    /*
       endif --> {x_endif,if_pc}
    */
    k:=apop(aCommStack)
    if k<>nil .and. (k[1]==x_if .or. k[1]==x_elif)
      r:=k[2]
      aCode[r][2][3]:=len(aCode)
      if k[1]==x_elif
        n:=aCode[k[2]][2][5]
        aCode[n][2][3]:=len(aCode)
      endif
    else
      myalert('ENDIF without IF in line '+alltrim(str(len(aCode))),{'Ok'})
      r:=nil
    endif
  case nTok==x_while
    /*
      while --> {x_while,{while_blk,endw_pc}}
    */
    r:={mkblk(s,len(aCode)),0}
    apush(aCommStack,{x_while,len(aCode)})
  case nTok==x_endw
    /*
      endw --> {x_endw,while_pc}
    */
    k:=apop(aCommStack)
    if k<>nil .and. k[1]==x_while
      r:=k[2]
      aCode[r][2][2]:=len(aCode)
    else
      myalert('ENDW without WHILE in line '+alltrim(str(len(aCode))),{'Ok'})
      r:=nil
    endif
  case nTok==x_for
    /*
      for --> {x_for,{init_blk,if_blk,inc_blk,next_pc}}
    */
    apush(aCommStack,{x_for,len(aCode)})
    n:=lineparse(s,';')
    if len(n)==3 .or. len(n)==2
      r:={mkblk(n[1],len(aCode)),mkblk(n[2],len(aCode)),IF(len(n)==3,mkblk(n[3],len(aCode)),mkblk('',len(aCode))),0}
    else
      myalert('FOR must have 3 arguments!',{'Ok'})
      r:=nil
    endif
  case nTok==x_next
    /*
      next --> {x_next,for_pc}
    */
    k:=apop(aCommStack)
    if k<>nil .and. k[1]==x_for
      r:=k[2]
      aCode[r][2][4]:=len(aCode)
    else
      myalert('NEXT without FOR in line '+alltrim(str(len(aCode))),{'Ok'})
      r:=nil
    endif
  case nTok==x_private
    /*
      private --> {x_private,array_of_var_names}
    */
    r:=lineparse(s,',')
  case nTok==x_public
    /*
      public --> {x_public,array_of_var_names}
    */
    r:=lineparse(s,',')
  case nTok==x_release
    /*
      release --> {x_release,array_of_var_names}
    */
    r:=lineparse(s,',')
  case nTok==x_exit .or. nTok==x_loop
    /*
      exit --> {x_exit,closest_loop_pc}
      loop --> {x_loop,closest_loop_pc}
    */
    n:=scantok(aCommStack,{x_while,x_for})
    if n<>0
      r:=aCommStack[n][2]
    else
      myalert(IF(nTok==x_exit,'EXIT','LOOP')+' not in loop in line '+alltrim(str(len(aCode))),{'Ok'})
      r:=nil
    endif
  case nTok==x_proc
    /*
       proc --> {x_proc,{proc_name,endp_pc,ret_pc=0}
    */
    apush(aCommStack,{x_proc,len(aCode)})
    apush(blprocs,{lower(alltrim(s)),len(aCode)})
    r:={lower(alltrim(s)),0,0}
  case nTok==x_endp
    /*
       endp --> {x_endp,proc_pc}
    */
    k:=apop(aCommStack)
    if k<>nil .and. k[1]==x_proc
      r:=k[2]
      aCode[r][2][2]:=len(aCode)
    else
      myalert('ENDP without PROC in line '+alltrim(str(len(aCode))),{'Ok'})
      r:=nil
    endif
  case nTok==x_call
    /*
       call --> {x_call,proc_name}
    */
    r:=lower(alltrim(s))
  case nTok==x_write
    r:=mkblk(s,len(aCode))
  case nTok==x_return
    /*
       return --> {ret_pc,ret_expr}
    */
    n:=scantok(aCommStack,{x_proc})
    if n<>0
      if empty(alltrim(s))
        r:={aCommStack[n][2]}
      else
        r:={aCommStack[n][2],mkblk(s,len(aCode))}
      endif
    else
      //myalert('RETURN not within PROC in line '+alltrim(str(len(aCode))),{'Ok'})
      r:={nil}
    endif
  case nTok==x_push
    r:=mkblk("apush(blStack,"+s+")",len(aCode))
  case nTok==x_pop
    r:=mkblk(s+":=apop(blStack)",len(aCode))
  case nTok==x_param
    r:={}
    k:=lineparse(s,',')
    for i:=1 to len(k)
      apush(r,{alltrim(k[i]),mkblk(alltrim(k[i])+":=apop(blStack)",len(aCode))})
    next
  case nTok==x_block
    r:=mkblk(s,len(aCode),.t.)
end case
return r

function loadprocs(s,a)
local lines,i
lines:=lineparse(memoread(s),x_EOL)
for i:=1 to len(lines)
  apush(a,lines[i])
next
return nil

function scantok(aStack,aTok)
local i
for i:=len(aStack) to 1 step -1
  if ascan(aTok,aStack[i][1])<>0
    return i
  endif
next
return 0

function apush(a,v)
aadd(a,nil)
a[len(a)]:=v
return v

function apop(a)
local v
if len(a)==0
  return nil
endif
v:=a[len(a)]
adel(a,len(a))
asize(a,len(a)-1)
return v

function atop(a)
return if(len(a)==0,nil,a[len(a)])

function e_eval(p,pc)
eval(p)
return pc+1

function if_eval(p,pc,a)
local r:=eval(p[1])
//return if(r,pc+1,if(p[2]==0,p[3],p[2]+1))
if r == .t.
  return pc+1
endif
if p[2]==0 // IF without ELSE
  return p[3]
endif
if a[p[2]][1]==x_else
  return p[2]+1
endif
r:=a[p[2]][2]
return elif_pc(r,a,p[2])

function elif_pc(p,a,pc)
local r:=eval(p[1])
if !(r==.t.)
  if (p[2]<>0 .and. a[p[2]][1]==x_elif) // there are more ELIF
    return elif_pc(a[p[2]][2],a,p[2])
  elseif p[2]<>0 // there are not ELIF, but ELSE
    return p[2]+1
  else // only ENDIF
    return a[p[5]][2][3]
  endif
endif
return pc+1

function el_eval(p,pc,a)
return a[p][2][3]

function elif_eval(p,pc,a)
return a[p[5]][2][3]

function endif_eval(p,pc)
return pc+1

function while_eval(p,pc)
local r:=eval(p[1])
if !r
  return p[2]+1
endif
return pc+1

function for_eval(p,pc)
local i_v:=eval(p[1])
i_v:=eval(p[2])
if !i_v
  return p[4]+1
endif
return pc+1

function exit_eval(p,a)
local r
do case
  case a[p][1]==x_while
    r:=a[p][2][2]+1
  case a[p][1]==x_for
    r:=a[p][2][4]+1
end case
return r

function loop_eval(p,pc)
memvar a
local r
do case
  case a[p][1]==x_while
    r:=p
  case a[p][1]==x_for
    r:=a[p][2][4]
end case
return r

function endw_eval(p,pc)
return p

function next_eval(p,pc,a)
local v
eval(a[p][2][3])
v:=eval(a[p][2][2])
if !v
  return a[p][2][4]+1
endif
return p+1

function pub_eval(p,pc)
local i,v
for i:=1 to len(p)
  v:=alltrim(p[i])
  public &v
next
return pc+1

function rel_eval(p,pc)
local i,v
for i:=1 to len(p)
  v:=alltrim(p[i])
  release &v
next
return pc+1

function progerr(e,n)
local k
k:=myalert('BL runtime error in line '+alltrim(str(n)),{'Stop','More...'},'BL')
if k==2
  myalert(ErrorMessage(e),{'Ok'})
endif
break(e)
return e

function progrun(aCode)
local errblk
static e
private blStack:={},gpc
e:=errorblock({|err| progerr(err,m->gpc)})
begin sequence
realrun(aCode)
recover using errblk
end sequence
errorblock(e)
release blStack
return nil

function realrun(aCode,ipc)
local pc,key,op,p,i,v,k
if ipc==nil
  pc:=1
else
  pc:=ipc
endif
while pc<=len(aCode) .and. pc<>0
  m->gpc:=pc
  op:=aCode[pc][1]
  p:=aCode[pc][2]
  do case
    case op==x_eval .or. op==x_pop .or. op==x_push
      pc:=e_eval(p,pc)
    case op==x_if
      pc:=if_eval(p,pc,aCode)
    case op==x_elif
      pc:=elif_eval(p,pc,aCode)
    case op==x_while
      pc:=while_eval(p,pc)
    case op==x_for
      pc:=for_eval(p,pc)
    case op==x_endif
      pc:=endif_eval(p,pc)
    case op==x_endw
      pc:=endw_eval(p,pc)
    case op==x_next
      pc:=next_eval(p,pc,aCode)
    case op==x_else
      pc:=el_eval(p,pc,aCode)
    case op==x_exit
      pc:=exit_eval(p,aCode)
    case op==x_loop
      pc:=loop_eval(p,pc)
    case op==x_private
      for i:=1 to len(p)
        v:=alltrim(p[i])
        private &v
      next
      pc:=pc+1
    case op==x_public
      pc:=pub_eval(p,pc)
    case op==x_release
      pc:=rel_eval(p,pc)
    case op==x_write
      pc++
    case op==x_proc
      pc:=0
    case op==x_call
      i:=ascan(blprocs,{|x| x[1]==p})
      if i==0
        pc++
      else
        realrun(aCode,blprocs[i][2]+1)
        pc++
      endif
    case op==x_endp
      pc:=0
    case op==x_return
      pc:=0
      if len(p)>1
        apush(blstack,eval(p[2]))
      endif
    case op==x_param
      for i:=len(p) to 1 step -1
        v:=p[i][1]
        private &v
        eval(p[i][2])
      next
      pc++
    case op==x_block
      apush(blstack,p)
      pc++
    otherwise
      pc++
  end case

  /*
     Script can be stopped by Ctrl-BackSpace but only if it is
     non recursive :-( Anyone can help?
  */
  key:=inkey()
  if key==K_CTRL_BS
    exit
  endif
end
return nil

#ifdef FSHIP
#include "error.fh"
#else
#include "error.ch"
#endif
#define NTRIM(n) RTRIM(Str(n))

static function ErrorMessage(e)
local cMessage
// start error message
cMessage := if( e:severity > ES_WARNING, "Error ", "Warning " )
// add subsystem name if available
if ( ValType(e:subsystem) == "C" )
  cMessage += e:subsystem()
else
  cMessage += "???"
end
// add subsystem's error code if available
if ( ValType(e:subCode) == "N" )
  cMessage += ("/" + NTRIM(e:subCode))
else
  cMessage += "/???"
end
// add error description if available
if ( ValType(e:description) == "C" )
  cMessage += ("  " + e:description)
end
// add either filename or operation
if ( !Empty(e:filename) )
  cMessage += (": " + e:filename)
elseif ( !Empty(e:operation) )
  cMessage += (": " + e:operation)
end
return (cMessage)

function lineparse(cline,cdelim)
local a:={},n,s
while !empty(cline)
  n:=at(cdelim,cline)
  aadd(a,nil)
  if n<>0
    a[len(a)]:=substr(cline,1,n-1)
    cline:=substr(cline,n+len(cdelim))
  else
    a[len(a)]:=cline
    cline:=''
  endif
end
return a

function block(s,a)
local cVars:= "" ,i,lfirst := .t.
if ! empty(a)
 for i := 1 to len(a)
  cVars+=a[i]+","
 next
 cVars := left(cVars,len(cVars)-1)
endif
return &("{|"+cVars+"|"+s+"}")

function clmacro(s)
return &s
