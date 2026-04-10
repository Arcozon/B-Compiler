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
%token IF ELSE
%right IF ELSE
%token WHILE
%token SWITCH CASE
%token GOTO
%token RETURN

%token INC DEC

/* %token L_SHIFT R_SHIFT MULT DIV MODULO ADD SUB OR AND EQUAL XOR NOT_EQUAL INF INF_EQUAL SUP SUP_EQUAL */
%left L_SHIFT R_SHIFT MULT DIV MODULO ADD SUB OR AND XOR EQUAL NOT_EQUAL INF INF_EQUAL SUP SUP_EQUAL
/* %token ASSIGN ASSIGN_L_SHIFT ASSIGN_R_SHIFT ASSIGN_MULT ASSIGN_DIV ASSIGN_MODULO ASSIGN_ADD ASSIGN_SUB ASSIGN_OR ASSIGN_AND ASSIGN_XOR ASSIGN_EQUAL ASSIGN_NOT_EQUAL ASSIGN_INF ASSIGN_INF_EQUAL ASSIGN_SUP ASSIGN_SUP_EQUAL */
%left ASSIGN ASSIGN_L_SHIFT ASSIGN_R_SHIFT ASSIGN_MULT ASSIGN_DIV ASSIGN_MODULO ASSIGN_ADD ASSIGN_SUB ASSIGN_OR ASSIGN_AND ASSIGN_XOR ASSIGN_EQUAL ASSIGN_NOT_EQUAL ASSIGN_INF ASSIGN_INF_EQUAL ASSIGN_SUP ASSIGN_SUP_EQUAL



/* %type <sval> string */
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
	|	NAME '[' constant_list_0_1 ']' ival_list_0_
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
ival_list_0_:
		// Empty
	|	ival_list_1_
	;
ival_list_1_:
		ival
	|	ival ',' ival_list_1_ 
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
	|	IF '(' rvalue ')' statement
	|	IF '(' rvalue ')' statement ELSE statement
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

	;

rvalue:
		'(' rvalue ')'
	|	lvalue
	|	constant
	|	lvalue assign rvalue
	|	inc_dec lvalue
	|	lvalue inc_dec
	|	'&' lvalue
	|	'-' rvalue
	|	'~' rvalue
	|	rvalue binary rvalue
	|	rvalue '?' rvalue ':' rvalue
	;
rvalue_0_1:
		// Empty
	|	rvalue
	;

lvalue:
		NAME
	|	'*' rvalue			%prec '*'
	|	rvalue '[' rvalue ']'
	;

assign:
		ASSIGN
	|	ASSIGN_L_SHIFT
	|	ASSIGN_R_SHIFT
	|	ASSIGN_MULT
	|	ASSIGN_DIV
	|	ASSIGN_MODULO
	|	ASSIGN_ADD
	|	ASSIGN_SUB
	|	ASSIGN_OR
	|	ASSIGN_AND
	|	ASSIGN_EQUAL
	|	ASSIGN_NOT_EQUAL
	|	ASSIGN_INF
	|	ASSIGN_INF_EQUAL
	|	ASSIGN_SUP
	|	ASSIGN_SUP_EQUAL
	;

inc_dec:
		INC
	|	DEC
	;
binary:
		L_SHIFT
	|	R_SHIFT
	|	MULT
	|	DIV
	|	MODULO
	|	ADD
	|	SUB
	|	OR
	|	AND
	|	EQUAL
	|	NOT_EQUAL
	|	INF
	|	INF_EQUAL
	|	SUP
	|	SUP_EQUAL
	;

%%

int main(void) {
	yyparse();
}
