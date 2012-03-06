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

#define	SREAD_PARSE_STRING_BUF_SIZE	20

static
void
sread_parse_error(
	const char * const message,
	... )
{
	printf( "Error at line %d: %s\n", yylineno, message );
}

#define	SREAD_PARSE_STRING_BUF_ADD( x )	{ \
		if ( sread_parse_string_buf_pos < SREAD_PARSE_STRING_BUF_SIZE ) {	\
			sread_parse_string_buf[ sread_parse_string_buf_pos ] = x;	\
			sread_parse_string_buf_pos++;			\
		} else { /* string overflow */				\
			sread_parse_error( "string too long" );		\
			BEGIN( INITIAL );				\
			return 0;					\
		} /* enouth space in string buffer? */			\
	}
%}

%x SREAD_CONTEXT_COMMENT SREAD_CONTEXT_STRING

%%
		char	sread_parse_string_buf[ SREAD_PARSE_STRING_BUF_SIZE ];
		int	sread_parse_string_buf_pos;

		sread_parse_string_buf_pos = 0;

"/*"			{
//				printf( "Begin comment\n" );
				BEGIN( SREAD_CONTEXT_COMMENT );
			}

<SREAD_CONTEXT_COMMENT>{
	[^*\n]*		/* eat anything that's not a '*' */

	"*"+[^*/\n]*	/* eat up '*'s not followed by '/'s */

	\n

	"*"+"/"		{
//				printf( "Stop comment\n" );
				BEGIN( INITIAL );
			}

} /* comment context */



\"			{
				sread_parse_string_buf_pos = 0;
				BEGIN( SREAD_CONTEXT_STRING );
			}

<SREAD_CONTEXT_STRING>{
	\"		{ /* saw closing quote - all done */
				BEGIN( INITIAL );
				SREAD_PARSE_STRING_BUF_ADD( '\0' );
				yylval->str = strdup( &( sread_parse_string_buf[ 0 ] ) );
				return STRING;
			}

	\n		{
				sread_parse_error( "unterminated string" );
//				BEGIN( INITIAL );
//				SREAD_PARSE_STRING_BUF_ADD( '\0' );
//				yylval->str = strdup( &( sread_parse_string_buf[ 0 ] ) );
//				return STRING;
			}

	\\x[0-9A-Fa-f]{2}	{
				char z;
				 /* hex escape sequence */
				z = strtol( &( yytext[ 2 ] ), NULL, 16 );
				SREAD_PARSE_STRING_BUF_ADD( z );
			}

	\\n		{
				SREAD_PARSE_STRING_BUF_ADD( '\n' );
			}

	\\t		{
				SREAD_PARSE_STRING_BUF_ADD( '\t' );
			}

	\\\"		{
				SREAD_PARSE_STRING_BUF_ADD( '"' );
			}

	\\\n		/* skip eol-escape */

	\\.		{
				sread_parse_error( "bad escape %02X", yytext[ 1 ] );
			}

	[^\\\n\"]+	{
				char *yptr = yytext;

				while ( *yptr ) {
					SREAD_PARSE_STRING_BUF_ADD( *yptr++ );
				}
			}
} /* string context */


\(			{
//				printf("SREC-START\n");
				return OPEN_BRACE;
			}

\)			{
//				printf("SREC-END\n");
				return CLOSE_BRACE;
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

.			sread_parse_error( "bad input character '%02X'", yytext[ 0 ] );

%%
