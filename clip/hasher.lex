%{
#include "cliphash.h"
%}

ID      [A-Za-z_][A-Za-z0-9_]*

%%

[^H\n]+		/*ECHO;*/
"HASH_"{ID}     printf( "#define\t%-32s\t0x%lx /*%d,%ld*/\n", yytext, (clip_hash_t) _clip_casehashstr(yytext+5), (int)_clip_casehashstr(yytext+5),(long)_clip_casehashstr(yytext+5)); 
.|\n		/*ECHO;*/

%%

int Argc;
char **Argv;

int
main( int argc, char **argv )
{
	Argv=++argv+1;
	Argc=--argc-1;
	if ( argc > 0 )
	{
		yyin = fopen( argv[0], "rt" );
		if (!yyin)
		{
			fprintf(stderr, "cannot open file %s\n", argv[0]);
			exit(2);
		}
	}
	else
		yyin = stdin;

	yylex();
	return 0;
}

int
hashwrap()
{
	if (Argc>0)
	{
		fclose(yyin);
		yyin = fopen( Argv[0], "rt" );
		if (!yyin)
		{
			fprintf(stderr, "cannot open file %s\n", Argv[0]);
			exit(2);
		}
		Argc--;
		Argv++;
		return 0;
	}
	return 1;
}


