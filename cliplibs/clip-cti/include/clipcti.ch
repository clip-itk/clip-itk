/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

#ifndef __CLIP_CTI_CH__
#define __CLIP_CTI_CH__

#define		CTI_VERSION	"0.5"

#define		CTI_ACCEL_CHAR	"&"

#ifndef TRUE
#define		TRUE	.T.
#endif

#ifndef FALSE
#define		FALSE	.F.
#endif

#command CALL SUPER <obj>:<meth>( <params,...>) [TO <var>] => ;
	[<var>:=]eval(<obj>:__VIRTUAL__:SUPERCLASS:<meth>,<obj>,<params>)

#command CALL SUPER <obj>:<meth>() [TO <var>] => ;
	[<var>:=]eval(<obj>:__VIRTUAL__:SUPERCLASS:<meth>,<obj>)

/*
#command OBJECT <obj> CALL SUPER <meth>( <params,...>) [TO <var>] => ;
	[<var>:=]eval(<obj>:__VIRTUAL__:SUPERCLASS:<meth>,<obj>,<params>)

#command OBJECT <obj> CALL SUPER <meth>() [TO <var>] => ;
	[<var>:=]eval(<obj>:__VIRTUAL__:SUPERCLASS:<meth>,<obj>)
*/

#translate	cti_return_if_fail(<cond>,<ret>)=> if .not. (<cond>); outlog(__FILE__,__LINE__,procname(),"warning: "+<"cond">+" failed"); return <ret>; endif
#translate	cti_return_if_fail(<cond>)	=> cti_return_if_fail(<cond>,.F.)

#translate	cti_return_if_fail2(<cond>,<ret>)=> if .not. (<cond>); outlog(2,__FILE__,__LINE__,procname(),"warning: "+<"cond">+" failed"); return <ret>; endif
#translate	cti_return_if_fail2(<cond>)	=> cti_return_if_fail2(<cond>,.F.)

#define		CTI_JUSTIFY_LEFT		0
#define		CTI_JUSTIFY_CENTER		1
#define		CTI_JUSTIFY_RIGHT		2

#define		CTI_SELECTION_SINGLE		0
#define		CTI_SELECTION_BROWSE		1
#define		CTI_SELECTION_MULTIPLE		2
#define		CTI_SELECTION_EXTENDED		3

#endif
