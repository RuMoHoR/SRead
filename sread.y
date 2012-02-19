%pure_parser

%{
#include <stdio.h>
#include "sread.h"
#include "sreadnode.h"
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

%union
{
	long int	num;
	float	dec;
	char	*str;
	struct sread_node_t	*node;
	struct sread_node_param_t	*param;
}

%token	<str>	NAME
%token	<num>	NUM_INT
%token	<num>	NUM_HEX
%token	<dec>	NUM_FLOAT
%token	<str>	STRING

/*
%token	NAME
%token	NUM_INT
%token	NUM_HEX
%token	STRING
*/

%type	<node>	sexp
%type	<node>	sexps
%type	<param>	sexp_param
%type	<param>	sexp_params

%start	sexproot

%%

sexproot:
	{
		printf("Root-start\n");
	}
	sexps
	{
		printf("Root-end\n");
	}

sexps:
	{}
	|
	sexps
	sexp
	{
//		printf("SEXP+\n" );
		$$ = $1;
		sread_node_dump( $2 );
		printf( "\n" );
//		$$ = sread_node_param_add( $1, $2 );
//		printf("SEXP-\n" );
	}
	;

sexp:
	OPEN_BRACE NAME sexp_params CLOSE_BRACE
	{
//		printf("Section-n[%s]+\n", $2 );
		$$ = sread_node_init( $2, $3 );
//		printf("Section-n[%s]-\n", $2 );
	}
	;

sexp_params:
	sexp_param
	{
		$$ = $1;
	}
	|
	sexp_param
	sexp_params
	{
		$$ = sread_node_param_next( $1, $2 );
	}
	;

sexp_param:
	{
//		printf("Prm-empty[%s]\n", "empty");
		$$ = sread_node_param_add_empty( );
	}
	|
	NAME
	{
//		printf("Prm-name[%s]\n", $1 );
		$$ = sread_node_param_add_name( $1 );
	}
	|
	NUM_INT
	{
//		printf("Prm-num-int[%ld]\n", $1 );
		$$ = sread_node_param_add_number( $1 );
	}
	|
	NUM_HEX
	{
//		printf("Prm-num-hex[%04lx]\n", $1 );
		$$ = sread_node_param_add_number( $1 );
	}
	|
	NUM_FLOAT
	{
//		printf("Prm-num-float[%8.4f]\n", $1 );
		$$ = sread_node_param_add_float( $1 );
	}
	|
	STRING
	{
//		printf("Prm-str[%s]\n", $1 );
		$$ = sread_node_param_add_string( $1 );
	}
	|
	sexp
	{
//		printf("Prm-s\n");
		$$ = sread_node_param_add_node( $1 );
	}
	;
