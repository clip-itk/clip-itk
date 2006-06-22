/*
   $Log$
   Revision 1.1  2006/06/22 19:35:17  itk
   uri: init sf.net repository

   Revision 1.21  2002/11/27 13:40:44  clip
   initial _CGET_ pseudofunction(bug 62):
   _CGET_(var[i1,i2,i3,...]) -> __CGET__(@var[i1,i2,i3],{i1,i2,i3},"var",...)
   paul

   Revision 1.20  2001/11/22 10:44:19  clip
   expr: '(' expr_list ')' stack fix
   paul

   Revision 1.19  2001/11/06 09:13:13  clip
   local array elements in macro blocks
   paul

   Revision 1.18  2001/09/28 09:55:44  clip
   add compiler pragma:
   *reference [name1 ... nameN]
   to force call-by-reference for function's  name1..nameN arguments
   paul

   Revision 1.17  2001/09/21 10:29:15  clip
   memvar priority in macro
   paul

   Revision 1.16  2001/09/05 05:30:26  clip
   CODEBLOCK/CODESTR now can have paramters, f.e:
   CODESTR(|a| f->first==a) will generate string
   {|A|FIELD->FIRST==A}
   paul

   Revision 1.15  2001/09/04 08:26:59  clip
   CODEBLOCK pseudofunction
   process codeblocks with macro calls as CODEBLOCK
   paul

   Revision 1.14  2001/08/27 09:45:31  clip
   switch operator
   paul

   Revision 1.13  2001/08/26 11:37:01  clip
   selfref detection in local(b:=@localvar)
   paul

   Revision 1.12  2001/08/24 14:38:47  clip
   CODESTR pseudofunction
   paul

   Revision 1.11  2001/08/23 13:52:06  clip
   merge with NEWLOCALS
   paul

   Revision 1.10.2.2  2001/08/23 10:13:43  clip
   fix field/memvar order in references
   paul

   Revision 1.10.2.1  2001/08/21 12:10:36  clip
   local init in codeblock, f.e.:

   local a:={1,2,3}
   cb:={|x|local(b:=a[2]),iif(x==NIL,b,b:=x)}
   ? eval(cb)
   ? a
   ? eval(cb,'dddd')
   ? a
   ?

   paul

   Revision 1.10  2001/05/30 09:45:43  clip
   for .. in .. [keys]
   paul

   Revision 1.9  2001/02/06 13:07:25  clip
   hash in .po, dbg
   paul

   Revision 1.8  2000/12/09 12:13:28  clip
   locale
   paul

   Revision 1.7  2000/10/18 10:56:17  clip
   append rationals
   Paul Lasarev <paul@itk.ru>

   Revision 1.6  2000/05/24 18:34:39  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.5  2000/04/29 19:49:35  clip
   array elment object call

   Revision 1.4  2000/03/30 20:30:38  paul
   loop in pcode

   Revision 1.3  2000/03/21 14:53:30  paul
   macroassign; __FIELD__ with macroassign

   Revision 1.2  1999/10/26 19:11:35  paul
   start cvs logging

 */

#ifndef NODEPRIV_H
#define NODEPRIV_H

typedef struct
{
	Node node;
	Node *expr;
}
OperExprNode;

#define CONST_NUMBER 0
#define CONST_STRING 1
#define CONST_NIL 2
#define CONST_LOGIC 3
#define CONST_ISTRING 4

typedef struct
{
	Node node;
	int type;
	int no;
	char *val;
	char *rval;
	Function *func;
	int len;
}
ConstNode;

typedef struct
{
	Node node;
	VarColl *cp;
	char *name;
}
DefNode;

typedef struct
{
	Node node;
	Var *vp;
	int lval;
	int isArg;
	int p1;
	Function *fp;
}
VarNode;

typedef struct
{
	Node node;
	Var *vp;
	long space;
	char *spacename;
}
CreateVarNode;

typedef struct
{
	Node node;
	Node *expr;
	int i;
}
ExprNode;

typedef struct
{
	Node node;
	char *name;
	long hash;
	int argc;
	int isC;
	Function *func;
	Function *cfunc;
	int rest;
	int byref;
}
CallNode;

typedef struct
{
	Node node;
	Node *var;
	Node *expr;
	int op;
	int field_flag;
}
AssignNode;

typedef struct
{
	Node node;
	char *area;
	Node *areaExpr;
	char *name;
	Node *nameExpr;
	Node *expr;
}
AssignFieldNode;

typedef struct
{
	Node node;
	Coll *cp;
}
NewArrayNode;

typedef struct
{
	Node node;
	char *name;
	char *area;
	Node *nameExpr;
	Node *areaExpr;
}
FieldNode;

typedef struct
{
	Node node;
	char *name;
	long hash;
	int argc;
	Node *obj;
	int rest;
}
ObjNode;

typedef struct
{
	Node node;
	Function *func;
	Function *fp;
	Coll inits;
}
CodeNode;

typedef struct
{
	Node node;
	char *ctext;
}
LangNode;

typedef struct
{
	Node node;
	Node *arr;
	int dim;
	Node *expr;
	int op;
	Node *oarr;
}
ArrElNode;

typedef struct
{
	Node node;
	Node *name;
	int argc;
}
CallNameNode;

typedef struct
{
	Node node;
	Node *expr1;
	Node *expr2;
	int op;
}
OpNode;

typedef struct
{
	Node node;
	Node *expr;
	int isIncr;
	int isPost;
}
IncrNode;

typedef struct
{
	Node node;
	Coll *elseifs;
	Node *elselist;
	int labelNo;
}
IfNode;

typedef struct
{
	Node node;
	Node *expr;
	Node *list;
	int labelNo;
}
WhileNode;

typedef struct
{
	Node node;
	int isLoop;
	int offs;
	int processed;
}
LoopExitNode;

typedef struct
{
	Node node;
	Node *var;
	Node *init;
	Node *to;
	Node *step;
	Node *list;
	int labelNo;
	int keys;
}
ForNode;

typedef struct
{
	Node node;
	Node *list;
	Node *using;
	Node *recover;
	int seqNo;
	int curSeqNo;
	int toffs;
	int seqLevel;
}
SeqNode;

typedef struct
{
	Node node;
	Node *expr;
	char *name;
	Function *fp;
	int selfref;
}
RefNode;

typedef struct
{
	Node node;
	Node *expr;
	StrBuf *buf;
	Coll coll;
	VarColl *params;
	int block;
}
CodestrNode;

typedef struct
{
	Node node;
	Node *expr;
	Coll *cases;
	Node *other;
	Coll *labels;
}
SwitchNode;

typedef struct
{
	Node node;
	int last;
}
ExprListNode;

typedef struct
{
	Node node;
	Coll coll;
        int last;
}
ExprArrNode;

#endif
