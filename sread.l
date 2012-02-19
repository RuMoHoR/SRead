%option nodefault
%option nounistd
%option noinput
%option nounput

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sread.h"
#include "sread.tab.h"

%}

%%

\(			{
//				printf("SREC-START\n");
				return OPEN_BRACE;
			}

\)			{
//				printf("SREC-END\n");
				return CLOSE_BRACE;
			}

\"([^\\"]|\\.)*\"	{
//				printf("STR[%s]\n", yytext );
				yylval->str = strndup( &( yytext[ 1 ] ), yyleng - 2 );
				return STRING;
			}

-?[0-9]*\.[0-9]+	{
//				printf("FLOAT[%s]\n", yytext);
				yylval->dec = atof(yytext);
				return NUM_FLOAT;
			}

[0-9]+			{
//				printf("INT[%s]\n", yytext);
				yylval->num = atoi(yytext);
				return NUM_INT;
			}

0x[0-9a-fA-F]+		{
//				printf("HEX[%s]\n", yytext);
				yylval->num = strtol( yytext, NULL, 16 );
				return NUM_HEX;
			}

[a-zA-Z][a-zA-Z0-9_-]*	{
//				printf("NAM[%s]\n", yytext);
				yylval->str = strdup( yytext );
				return NAME;
			}

\r			/* ignore end of line */;
\n			/* ignore end of line */;
[ \t]+			/* ignore whitespace */;

.			printf( "bad input character '%s' at line %d\n", yytext, yylineno );

%%
