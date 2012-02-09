#include <stdio.h>
//#include <sys/types.h>
//#include <sys/stat.h>
//#include <sys/mman.h>
//#include <fcntl.h>
//#include <unistd.h>
//#include <malloc.h>

#include "sread.tab.h"
#include "sread.lex.h"


void
sread_parse( void );

int main(
	int argc,
	char *argv[] )
{
	FILE	*frec;

	if ( argc < 2 ) {
		printf("Usage: %s srec\n", argv[ 0 ] );
		return 1;
	} else { /* args ok */
		frec = fopen( argv[ 1 ], "r" );
		if ( !frec ) {
			printf( "Can't open '%s'!\n", argv[ 1 ] );
			return 2;
		} else { /* open ok */
			sread_set_in( frec );
			sread_parse();
			fclose( frec );
		} /* open ok? */
	} /* args ok? */
	return 0;
}
