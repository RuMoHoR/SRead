#ifndef SREAD_NODE_H_INCLUDED
#define SREAD_NODE_H_INCLUDED

enum sread_node_param_type_t {
	SREAD_NODEPARAM_TYPE_EMPTY = 0,
	SREAD_NODEPARAM_TYPE_NODE,
	SREAD_NODEPARAM_TYPE_NAME,
	SREAD_NODEPARAM_TYPE_NUMBER,
	SREAD_NODEPARAM_TYPE_STRING
};

struct sread_node_t;

struct sread_node_param_t {
	enum sread_node_param_type_t	type;
	union {
		struct sread_node_t	*node;
		char	*name;
		long int	number;
		char	*str;
	} value;
	struct sread_node_param_t	*next;
};

struct sread_node_t {
	char	*name;
	unsigned int	id;
	struct sread_node_param_t	*param;
};



struct sread_node_t *
sread_node_init(
	const char * const name,
	struct sread_node_param_t * const param );

void
sread_node_dump(
	const struct sread_node_t * const node );


struct sread_node_param_t *
sread_node_param_next(
	struct sread_node_param_t * const param,
	struct sread_node_param_t * next );


struct sread_node_param_t *
sread_node_param_add_empty( void );

struct sread_node_param_t *
sread_node_param_add_node(
	struct sread_node_t * const node );

struct sread_node_param_t *
sread_node_param_add_name(
	char * const name );

struct sread_node_param_t *
sread_node_param_add_number(
	const long int number );

struct sread_node_param_t *
sread_node_param_add_string(
	const char * const str );

#endif
