#include <stdio.h>
#include <string.h>

#include "sread.h"
#include "sreadnode.h"

static inline
struct sread_node_t *
sread_node_alloc( void )
{
	struct sread_node_t *node;

//	printf( "Node-Alloc\n" );

	node = malloc( sizeof( struct sread_node_t ) );

	if ( node ) {
		node->param = NULL;
	} /* alloc ok? */

	return node;
}

static inline
struct sread_node_param_t *
sread_node_param_alloc( void )
{
	struct sread_node_param_t *param;

//	printf( "Node-Param-Alloc\n" );

	param = malloc( sizeof( struct sread_node_param_t ) );

	if ( param ) {
		param->type = SREAD_NODEPARAM_TYPE_EMPTY;
		param->next = NULL;
	} /* alloc ok? */

	return param;
}

struct sread_node_t*
sread_node_init(
	const char * const name,
	struct sread_node_param_t * const param )
{
	struct sread_node_t *node;

//	printf( "Node-Init[%s][%p]\n", name, param );

	node = sread_node_alloc();
	if ( node ) {
		node->name = strdup( name );
		node->param = param;
	} /* alloc ok? */

//	printf( "Node-Inited[%p]\n", node );
	return node;
}

struct sread_node_param_t *
sread_node_param_next(
	struct sread_node_param_t * const param,
	struct sread_node_param_t * next )
{
//	printf( "Node-Param-Next[%p][%p]\n", param, next );

	if ( !param ) {
		return next;
	} else { /* valid */
		param->next = next;
		return param;
	} /* valid first? */
}


struct sread_node_param_t *
sread_node_param_add_empty( void )
{
	return NULL;
}

struct sread_node_param_t*
sread_node_param_add_node(
	struct sread_node_t * const node )
{
	struct sread_node_param_t *param;

//	printf( "Node-Add-Node\n" );

	param = sread_node_param_alloc();

	if ( param ) {
		param->type = SREAD_NODEPARAM_TYPE_NODE;
		param->value.node = node;
	} /* alloc ok? */

//	printf( "Node-Param-AddedN[%p]\n", param );
	return param;
}

struct sread_node_param_t *
sread_node_param_add_name(
	char * const name )
{
	struct sread_node_param_t *param;

//	printf( "Node-Add-NAme[%s]\n", name );

	param = sread_node_param_alloc();
	if ( param ) {
		param->type = SREAD_NODEPARAM_TYPE_NAME;
		param->value.name = strdup( name );
	} /* alloc ok? */

//	printf( "Node-Param-AddedS[%p]\n", param );
	return param;
}

struct sread_node_param_t *
sread_node_param_add_number(
	const long int number )
{
	struct sread_node_param_t *param;

//	printf( "Node-Add-Num[%ld]\n", number );

	param = sread_node_param_alloc();
	if ( param ) {
		param->type = SREAD_NODEPARAM_TYPE_NUMBER;
		param->value.number = number;
	} /* alloc ok? */

//	printf( "Node-Param-AddedI[%p]\n", param );
	return param;
}

struct sread_node_param_t *
sread_node_param_add_string(
	const char * const str )
{
	struct sread_node_param_t *param;

//	printf( "Node-Add-Str[%s]\n", str );

	param = sread_node_param_alloc();
	if ( param ) {
		param->type = SREAD_NODEPARAM_TYPE_STRING;
		param->value.str = strdup( str );
	} /* alloc ok? */

//	printf( "Node-Param-AddedS[%p]\n", param );
	return param;
}

static
void
sread_node_dump_param(
	const struct sread_node_param_t * const param )
{
//	printf( "PAarm-Dump[%p]\n", param );

	if ( !param ) {
		printf( " " );
		return;
	}

	switch ( param->type ) {
//	printf( "[%s ", node->name );

	case SREAD_NODEPARAM_TYPE_NODE:
		printf( " " );
		sread_node_dump( param->value.node );
		break;

	case SREAD_NODEPARAM_TYPE_NAME:
		printf( " <%s>", param->value.name );
		break;

	case SREAD_NODEPARAM_TYPE_NUMBER:
		printf( " %ld", param->value.number );
		break;

	case SREAD_NODEPARAM_TYPE_STRING:
		printf( " \"%s\"", param->value.str );
		break;

	default:
		printf( " ?=%d=? ", param->type );
		break;
	} /* sw type */

	sread_node_dump_param( param->next );
}

void
sread_node_dump(
	const struct sread_node_t * const node )
{
//	printf( "Node-Dump[%p]\n", node );

	if ( !node ) return;

	printf( "[%s", node->name );

	sread_node_dump_param( node->param );

	printf( "]" );
}
