/*
    Copyright (C) 2001  ITK
    Author   : Paul Lasarev <paul@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include <stdio.h>
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
#if !YYDEBUG
#define static
static const char *const yytname[] =
{"$", "error", "$undefined.", "STRING",
 "NUMBER", "NAME", "RETURN", "FUNCTION", "PROCEDURE", "EXTERN", "PARAMETERS", "SFUNCTION",
 "SPROCEDURE", "PUBLIC", "PRIVATE", "STATIC", "LOCAL", "NIL", "END", "TRUE", "FALSE",
 "WHILE", "DO", "ENDDO", "EXIT", "LOOP", "IF", "ENDIF", "ELSE", "ELSEIF", "DOCASE", "CASE",
 "OTHERWISE", "ENDCASE", "FIELD", "MEMVAR", "IN", "RPTR", "ASSIGN", "ADDA", "SUBA", "DIVA",
 "MODA", "MULA", "POWA", "OR", "AND", "'>'", "GE", "'<'", "LE", "EQ", "NE", "'='", "'+'",
 "'-'", "'$'", "'*'", "'/'", "'%'", "POW", "':'", "'['", "INCR", "DECR", "MINUS", "'!'",
 "NOT", "MACRO", "'\\n'", "'('", "')'", "'&'", "'.'", "'{'", "'}'", "'|'", "']'", "','",
 "'@'", "file", "@1", "@2", "function", "procedure", "paramlist", "operlist", "oper",
 "inalias", "expr", "arr", "vardef", "var", "arrlist", "numlist", "param_list", "namelist",
 "varlist", "arglist", "arg", "exprlist", "expr_list", "constant", NULL
};
int yymaxtoken = sizeof(yytname) / sizeof(char *);

#endif
