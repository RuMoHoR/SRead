%option nounistd
%option noinput
%option nounput

%{
#include <stdio.h>
#include <string.h>
#include "sread.h"
#include "sread.tab.h"
//#include "sread.lex.h"

//main			return KEYWORD_main;
//general			return KEYWORD_general;
//zoom			return KEYWORD_zoom;
//\"			return QUOTE;


%}

%%

\(			printf("SREC-START\n"); return OPEN_BRACE;
\)			printf("SREC-END\n"); return CLOSE_BRACE;

\".*\"			/*yylval.str = strdup(yytext);*/ printf("STR[%s]\n", yytext); return STRING;

[a-zA-Z0-9-]+		/*sread_lval.str = strdup(yytext);*/ printf("NAM[%s]\n", yytext); return NAME;

\n			/* ignore end of line */;
[ \t]+			/* ignore whitespace */;

%%
