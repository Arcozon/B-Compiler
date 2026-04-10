%{
	#include <stdio.h>
	#include <stdlib.h>

	void yyerror(const char *s) { fprintf(stderr, "Error: %s\n", s); }
	int yylex(void);
%}

%union {
	int		ival;
	float	fval;
	char	*sval;
}

%start program

%token INTEGER STRING CHAR FLOAT
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
/* %right L_SHIFT R_SHIFT MULT DIV MODULO ADD SUB OR AND XOR EQUAL NOT_EQUAL INF INF_EQUAL SUP SUP_EQUAL */
/* %token ASSIGN ASSIGN_L_SHIFT ASSIGN_R_SHIFT ASSIGN_MULT ASSIGN_DIV ASSIGN_MODULO ASSIGN_ADD ASSIGN_SUB ASSIGN_OR ASSIGN_AND ASSIGN_XOR ASSIGN_EQUAL ASSIGN_NOT_EQUAL ASSIGN_INF ASSIGN_INF_EQUAL ASSIGN_SUP ASSIGN_SUP_EQUAL */
%right ASSIGN ASSIGN_L_SHIFT ASSIGN_R_SHIFT ASSIGN_MULT ASSIGN_DIV ASSIGN_MODULO ASSIGN_ADD ASSIGN_SUB ASSIGN_OR ASSIGN_AND ASSIGN_XOR ASSIGN_EQUAL ASSIGN_NOT_EQUAL ASSIGN_INF ASSIGN_INF_EQUAL ASSIGN_SUP ASSIGN_SUP_EQUAL

%left OR
%left AND
%left XOR
%left EQUAL NOT_EQUAL
%left INF INF_EQUAL SUP SUP_EQUAL
%left L_SHIFT R_SHIFT
%left ADD SUB
%left MULT DIV MODULO


%right POST_INC_DEC
%right PRE_INC_DEC

%token NOT TILDE
%right DEREF

/* %type <sval> string */
%%

program:
		{printf("Found empty prog");} // Empty
	|	definition

definition:
		global_definition ';'	{printf("Found global def");}
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
	|	rvalue ';'
	|	';'
	;

statement_list_0_:
		// Empty
	|	statement statement_list_0_
	;

	;

rvalue:
		'(' rvalue ')'
	|	lvalue				%prec DEREF
	|	constant
	|	lvalue assign rvalue	%prec ASSIGN
	|	INC lvalue			%prec PRE_INC_DEC	{printf("++a\n");}
	|	DEC lvalue			%prec PRE_INC_DEC	{printf("--a\n");}
	|	lvalue INC			%prec POST_INC_DEC	{printf("a++\n");}
	|	lvalue DEC			%prec POST_INC_DEC	{printf("a--\n");}
	|	AND lvalue			%prec DEREF
	|	SUB rvalue			%prec DEREF
	|	TILDE rvalue			%prec DEREF
	|	rvalue binary rvalue
	|	rvalue MULT rvalue
	|	rvalue '?' rvalue ':' rvalue
	|	rvalue '(' rvalue_0_ ')'
	;
rvalue_0_1:
		// Empty
	|	rvalue
	;
rvalue_0_:
		// Empty
	|	rvalue_1_
	;
rvalue_1_:
		rvalue
	|	rvalue ',' rvalue_1_
	;


lvalue:
		NAME
	|	'*' rvalue				%prec DEREF
	|	rvalue '[' rvalue ']'	%prec DEREF
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
	|	ASSIGN_XOR
	|	ASSIGN_EQUAL
	|	ASSIGN_NOT_EQUAL
	|	ASSIGN_INF
	|	ASSIGN_INF_EQUAL
	|	ASSIGN_SUP
	|	ASSIGN_SUP_EQUAL
	;

/* inc_dec:
		INC
	|	DEC
	; */
binary:
		L_SHIFT
	|	R_SHIFT
	|	DIV
	|	MODULO
	|	ADD
	|	SUB
	|	OR
	|	AND
	|	XOR
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
