%pure_parser

%{
#include <stdio.h>
#include "sread.h"
#include "sread.tab.h"
#include "sread.lex.h"

#define	YYERROR_VERBOSE

//#define YYPARSE_PARAM parm
//#define YYLEX_PARAM parm

void sread_error(const char *str);
void sread_error(const char *str)
{
	printf("error: %s\nLine: %d\n", str, sread_lineno);
}

int sread_wrap()
{
	printf("Wrap\n");
        return 1;
}

%}

%token	OPEN_BRACE CLOSE_BRACE
//%token	QUOTE


//%union
//{
//	int number;
//	char *str;
//}

//%token <str> NAME
//%token <str> STRING



//%token	KEYWORD_main
//%token	KEYWORD_general
//%token	KEYWORD_zoom

%token	NAME
%token	STRING

%%

sexps:
	sexp
	|
	sexps
	sexp
	;

sexp:
	OPEN_BRACE
	{
//		printf("Section-s\n");
	}
	NAME
	{
//		printf("Section-n\n");
	}
	sexp_params
	{
//		printf("Section-m\n");
	}
	CLOSE_BRACE
	{
//		printf("Section-e\n");
	}
	;

sexp_params:
	sexp_param
	|
	sexp_params
	sexp_param
	;

sexp_param:
	NAME
	{
//		printf("Prm-n[%s]\n", "1");
	}
	|
//	quoted_name
//	{
//		printf("Prm-q\n");
//	}
//	|
	STRING
	{
//		printf("Prm-t[%s]\n", "1");
	}
	|
	sexps
	{
//		printf("Prm-s\n");
	}
	;

//sexp_name:
//	quoted_name
//	{
//		printf("S-name\n");
//	}
//	;
/*
quoted_name:
	QUOTE NAME QUOTE
	{
		printf("Q-name\n");
	}
	;
*/
