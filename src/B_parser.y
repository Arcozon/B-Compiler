%{
	#include <stdio.h>
	#include <stdlib.h>

	# define EOT '\0x04'

	void yyerror(const char *s) { fprintf(stderr, "Error: %s\n", s); }
	int yylex(void);
%}

%union {
	int		ival;
	float	fval;
	char	*sval;
}

%start program

%token INTEGER STRING CHAR
%token NAME

%token AUTO EXTERN
%token IF ELSE ELIF
%right IF
%token WHILE
%token SWITCH CASE
%token GOTO
%token RETURN

%token INC DEC
%right INC DEC
%token EQUAL NOT_EQUAL INF_EQUAL SUP_EQUAL
%token L_SHIFT R_SHIFT

/* %type <sval> string */
/* NAME '(' name_list_0_ ')' IF '(' rvalue ')' if_bloc . ELIF '(' rvalue ')' statement elif_bloc_0_ else_bloc_0_1 elif_bloc_0_ else_bloc_0_1 $end */
%%

program:
		// Empty
	|	definition

definition:
		global_definition ';'
	|	function_definition
	;

global_definition:
		NAME
	|	NAME '[' constant_list_0_1 ']' constant_list_0_
	;

constant:
		INTEGER
	|	STRING
	|	CHAR
	;
constant_list_0_1:
		// Empty
	|	constant
	;
constant_list_0_:
		// Empty
	|	constant_list_1_
	;
constant_list_1_:
		constant
	|	constant ',' constant_list_1_
	;

name_list_0_:
		// Empty
	|	name_list_1_
	;
name_list_1_:
		NAME
	|	NAME ',' name_list_1_ 
	;

name_constant_0_1:
		NAME constant_list_0_1
	;
name_constant_0_1_list_1_:
		name_constant_0_1
	|	name_constant_0_1 ',' name_constant_0_1_list_1_
	;

ival:
		NAME
	|	constant
	;

function_definition:
	NAME '(' name_list_0_ ')' statement
	;

statement:
		AUTO name_constant_0_1_list_1_ ';' statement
	|	EXTERN name_list_1_ ';' statement
	|	NAME ':' statement
	|	CASE constant ':' statement
	|	'{' statement_list_0_ '}'
	/* |	if_elif_else_bloc */
	|	if_bloc else_bloc_0_1
	|	WHILE '(' rvalue ')' statement
	|	SWITCH rvalue statement
	|	GOTO rvalue ';'
	|	RETURN rvalue_0_1 ';'
	|	rvalue_0_1 ';'
	;

statement_list_0_:
		// Empty
	|	statement statement_list_0_
	;

if_bloc:
		IF '(' rvalue ')' statement
	;
elif:
		ELIF
	|	ELSE IF
	;
elif_bloc:
		elif '(' rvalue ')' statement
	;
elif_bloc_0_:
		// Empty
	|	elif_bloc elif_bloc_0_
	;

else_bloc_0_1:
		// Empty
	|	ELSE statement
	;
if_elif_else_bloc:
		if_bloc elif_bloc_0_ else_bloc_0_1
	;

rvalue:
		'(' rvalue ')'
	|	lvalue
	|	constant
	|	lvalue assign rvalue
	|	inc_dec lvalue
	|	lvalue inc_dec
	|	unary rvalue
	|	'&' lvalue
	|	rvalue binary rvalue
	|	rvalue '?' rvalue ':' rvalue
	;
rvalue_0_1:
		// Empty
	|	rvalue
	;

lvalue:
		NAME
	|	'*' rvalue
	|	rvalue '[' rvalue ']'
	;

assign:
		'='
	|	'=' binary
	;
inc_dec:
		INC
	|	DEC
	;
binary:
		'|'
	|	'&'
	|	EQUAL
	|	NOT_EQUAL
	|	'<'
	|	INF_EQUAL
	|	'>'
	|	SUP_EQUAL
	|	L_SHIFT
	|	R_SHIFT
	|	'+'
	|	'-'
	|	'*'
	|	'/'
	|	'%'
	;
unary:
		'-'
	|	'!'
	|	'~'
	;

%%

int main(void) {
	yyparse();
}
