/*
 * $Log$
 * Revision 1.1  2006/06/22 19:35:17  itk
 * uri: init sf.net repository
 *
 * Revision 1.29  2003/03/26 13:10:11  clip
 * possible closes #133, #139
 * paul
 *
 * Revision 1.28  2003/01/05 12:32:25  clip
 * possible fixes #95,#98
 * paul
 *
 * Revision 1.27  2002/11/27 13:40:44  clip
 * initial _CGET_ pseudofunction(bug 62):
 * _CGET_(var[i1,i2,i3,...]) -> __CGET__(@var[i1,i2,i3],{i1,i2,i3},"var",...)
 * paul
 *
 * Revision 1.26  2002/11/06 12:03:41  clip
 * add plural locale construction:
 * [asdf] ^ num_expr == ngettext("asdf", "asdf", num_expr)
 * paul
 *
 * Revision 1.25  2002/10/10 08:30:37  clip
 * &(expr) do not auto-codestr in codeblocks.
 * Closes #16
 * paul
 *
 * Revision 1.24  2002/08/08 09:49:28  clip
 * -a flag cleanup
 * paul
 *
 * Revision 1.23  2002/04/03 13:32:53  clip
 * now possible use in init vars, declared in the same operator:
 * local a:=1, b:=a+1
 * paul
 *
 * Revision 1.22  2002/01/07 07:26:36  clip
 * AS syntax cleanup
 * paul
 *
 * Revision 1.21  2002/01/05 12:50:48  clip
 * LOCAL a,b AS typename
 * STATIC a,b AS typename
 * func( a AS typename, b)
 * recognized, but yet not used
 * paul
 *
 * Revision 1.20  2001/10/02 11:40:31  clip
 * macro in rt compiler
 * paul
 *
 * Revision 1.19  2001/10/02 08:38:29  clip
 * macro from parameters in CODESTR blocks
 * paul
 *
 * Revision 1.18  2001/09/05 05:30:26  clip
 * CODEBLOCK/CODESTR now can have paramters, f.e:
 * CODESTR(|a| f->first==a) will generate string
 * {|A|FIELD->FIRST==A}
 * paul
 *
 * Revision 1.17  2001/09/04 08:26:59  clip
 * CODEBLOCK pseudofunction
 * process codeblocks with macro calls as CODEBLOCK
 * paul
 *
 * Revision 1.16  2001/08/27 09:45:31  clip
 * switch operator
 * paul
 *
 * Revision 1.15  2001/08/26 11:37:01  clip
 * selfref detection in local(b:=@localvar)
 * paul
 *
 * Revision 1.14  2001/08/26 09:10:06  clip
 * references
 * paul
 *
 * Revision 1.13  2001/08/24 14:38:47  clip
 * CODESTR pseudofunction
 * paul
 *
 * Revision 1.12  2001/08/23 13:52:06  clip
 * merge with NEWLOCALS
 * paul
 *
 * Revision 1.11.2.6  2001/08/23 10:13:43  clip
 * fix field/memvar order in references
 * paul
 *
 * Revision 1.11.2.5  2001/08/21 12:10:36  clip
 * local init in codeblock, f.e.:
 *
 * local a:={1,2,3}
 * cb:={|x|local(b:=a[2]),iif(x==NIL,b,b:=x)}
 * ? eval(cb)
 * ? a
 * ? eval(cb,'dddd')
 * ? a
 * ?
 *
 * paul
 *
 * Revision 1.11.2.4  2001/08/21 08:29:55  clip
 * reference assign (like b:=@a[1])
 * paul
 *
 * Revision 1.11.2.3  2001/08/20 10:43:09  clip
 * macro in blocks
 * paul
 *
 * Revision 1.11.2.2  2001/08/16 14:50:19  clip
 * fix
 * paul
 *
 * Revision 1.11.2.1  2001/08/03 12:07:59  clip
 * NEWLOCALS initial
 * paul
 *
 * Revision 1.11  2001/05/30 09:45:43  clip
 * for .. in .. [keys]
 * paul
 *
 * Revision 1.10  2001/05/04 10:29:26  clip
 * params and locals
 * paul
 *
 * Revision 1.9  2000/12/09 12:13:28  clip
 * locale
 * paul
 *
 * Revision 1.8  2000/11/22 13:45:14  clip
 *
 * paul
 *
 * Revision 1.7  2000/05/26 22:23:16  clip
 * public/private &macro
 * Paul Lasarev <paul@itk.ru>
 *
 * Revision 1.6  2000/05/25 16:00:42  clip
 * macro in codeblocks
 * break
 * Paul Lasarev <paul@itk.ru>
 *
 * Revision 1.5  2000/05/24 18:34:38  clip
 * _clip_push_area
 * indents all
 * Paul Lasarev <paul@itk.ru>
 *
 * Revision 1.4  2000/04/29 19:49:34  clip
 * array elment object call
 *
 * Revision 1.3  2000/03/20 18:59:51  paul
 * __field__ directive
 *
 * Revision 1.2  1999/10/27 17:29:38  paul
 * change param handling
 *
 * Revision 1.1  1999/10/25 16:39:28  paul
 * first entry
 *
 */

#ifndef NODE_H
#define NODE_H

#include <stdio.h>
#include "list.h"

void fprintfOffs(FILE * file, int offs, const char *format,...);

struct Node;

typedef struct Var
{
	char *name;
	int no;
	int line;
	int pos;
	int file;
	struct Function *func;
	struct Node *init;
	Coll *arr;
	char *alias;
	struct Node *macro;
	int isRef:1;
	int isFld:1;
	int isParam:1;
	int isCodeParam:1;
        int isLocalRef:1;
	int pno;
	int level;
	struct Var *refvar;
        char *type;
}
Var;

typedef struct VarColl
{
	Coll coll;
	Coll unsorted;
	int type;
}
VarColl;

Var *new_Var(char *name);
Var *newInit_Var(char *name, struct Node *expr);
Var *newArr_Var(char *name, Coll * arr);
Var *newArrInit_Var(char *name, struct Node *exprlist);
Var *mnew_Var(struct Node *macro);
Var *mnewInit_Var(struct Node *macro, struct Node *expr);
Var *mnewArr_Var(struct Node *macro, Coll * arr);
Var *mnewArrInit_Var(struct Node *macro, struct Node *exprlist);
void delete_Var(void *var);

VarColl *new_VarColl();
void delete_VarColl(VarColl *);
int search_VarColl(VarColl * coll, char *name, int *index);
void add_VarColl(VarColl * coll, Var * var);
void rm_VarColl(VarColl * coll, Var * var);
void insert_VarColl(VarColl * coll, Var * var);

VarColl *new_VarColl1(Var * vp);

typedef enum
{
	Print,
	Destroy,
	CalcDeep,
	CText,
	CTextInit,
	CTextLval,
	CTextRef,
	OText,
	OTextLval,
	OTextRef,
	OTextLoop,
	OTextTrap,
	SearchMacro,
	TestConst,
	Codegen1,
	Codegen2,
	PrintSrc,
	Traverse,
}
Pass;

typedef struct Node
{
	ListEl listel;
	List list;
	long line;
	int file;
	int deep;
	int seqNo;
	int isExec:1, isExpr:1, isConst:1, isLval:1, isInit:1, isExit:1, isLoop:1
	,isNum:1, isStr:1, isLog:1, isArray:1, isTop:1, isAssign:1
	,isMinus:1, isField:1, isMacro:1, isExprList:1, isCode:1
	,isArrEl:1, isFMemvar:1, isRef:1, isNil:1, isLocal:1, isMemvar:1
	,isAssignLval:1;
	int (*pass) (void *self, Pass passno, int level, void *par);	/* traverser */
	const char *name;
}
Node;

typedef struct
{
	int (*func)(Node *np, void *par);
	void *par;
}
TraversePar;

void init_Node(void *node, int (*pass) (void *, Pass, int, void *), const char *name);
int pass_Node(void *self, Pass pass, int level, void *par);
int traverse_Node(Node * node, int (*func) (Node * np, void *par), void *par);
int getCount_Node(void *node);
Node *new_Node();
void delete_Node(Node * node);
void append_Node(Node * list, Node * node);
void join_Node(Node * list, Node * node);
void prepend_Node(Node * list, Node * node);

Node *new_OperListNode();
Node *new_OperExprNode(Node * node);

Node *new_NumberConstNode(char *val, char *rval);
Node *new_StringConstNode(char *val);
Node *new_LocaleStringNode(char *val);
Node *new_LogicConstNode(int val);
Node *new_NilConstNode();
Node *new_VardefNode(VarColl * cp);
int compareConstNode(void *n1, void *n2);

Node *new_LocalDefNode(VarColl * cp, int err, int localref);
Node *new_LocalDefNode1(VarColl * cp);
Node *new_StaticDefNode(VarColl * cp);
Node *new_MemvarDefNode(VarColl * cp);
Node *new_FieldDefNode(VarColl * cp, char *alias);
Node *new_PublicDefNode(VarColl * cp);
Node *new_PrivateDefNode(VarColl * cp);
Node *new_ParametersDefNode(VarColl * cp);
Node *new_CreateVarNode(Var * vp, long space, char *spacename);

Node *new_ParamNode(Var * vp);
Node *new_LocalNode(Var * vp);
Node *new_StaticNode(Var * vp);
Node *new_MemvarNode(Var * vp);
Node *new_FMemvarNode(Var * vp);
Node *new_MemvarFNode(Var * vp);
Node *new_PublicNode(Var * vp);
Node *new_PrivateNode(Var * vp);
Node *new_ParameterNode(Var * vp);
Node *new_FieldNode(Var * vp);
Node *new2_FieldNode(char *name1, Node * expr1, char *name2, Node * expr2);
Node *new_AssignFieldNode(char *area, Node * areaExpr, char *name, Node * nameExpr, Node * expr);

Node *new_ArgNode(Node * expr, int byRef);
Node *new_RefNode(Node * expr);
Node *new_CallNode(char *name, Coll * argv, int rest);
Node *new2_CallNode(const char *name, Node * expr1, Node * expr2);
Node *new3_CallNode(const char *name, Node * expr1, Node * expr2, Node *expr3);
Node *new_CallNameNode(Node * name, Coll * argv);
Node *newList_CallNode(char *name, Node * exprlist);
Node *new_ExprListNode();
Node *new_ExprArrNode();
Node *new_AssignNode(Node * var, Node * expr, int op);

Node *new_ArrayInitNode(Node * exprlist);
Node *new_ArrayInitNodeN(Node * exprlist, int n);
Node *new_NewArrayNode(Coll * cp);

Node *new_MethodNode(Node * obj, char *name, Coll * argv, int rest);
Node *new_GetNode(Node * obj, char *name);
Node *new_SetNode(Node * obj, char *name, Node * expr);

Node *new_CodeNode(VarColl * params);
Node *new_ReturnNode(Node * expr, int isExprList);

Node *new_LangNode(char *ctext);
Node *new_ArrElNode(Node * arr, Node * expr, int op);

Node *new_MacroNode(Node * expr, int isexpr);

Node *new_PcountNode();
Node *new_PshiftNode();
Node *new_ParnNode(Node * expr);
Node *new_PallNode();

Node *new_IncrNode(Node * expr, int isIncr, int isPost);

Node *new_OpNode(Node * expr1, Node * expr2, int op);
Node *new_AndNode(Node * expr1, Node * expr2);
Node *new_OrNode(Node * expr1, Node * expr2);
Node *new_NotNode(Node * expr);
Node *new_MinusNode(Node * expr);

Node *new_IfNode(Coll * elseifs, Node * elselist);
Node *new_WhileNode(Node * expr, Node * list);
Node *new_LoopExitNode(int isLoop);
Node *new_ForNode(Node * var, Node * from, Node * to, Node * step, Node * list);
Node *new_ForeachNode(Node * var, Node * expr, Node * list, int keys);

Node *new_SeqNode(Node * list, Node * using, Node * recover, int seqNo);
Node *new_BreakNode(Node * expr, int isOper);

Node *new_NamespaceDefNode(char *name, VarColl * cp);

Node *new_NewArrNode(Node * exprlist);

Node *new_HashConstNode(char *name);
Node *new_AssignFmemvarNode(Node * var, Node * expr);

Node *new_SwapNode(Node * expr1, Node * expr2);

Node *new_CodestrNode(Node * expr, int block, VarColl *params);
Node *new_QuotNode(Node * expr);

Node *new_SwitchNode(Node *expr, Coll *cases, Node *otherwise);

Node *new_CGetNode(Coll * argv);

#endif
