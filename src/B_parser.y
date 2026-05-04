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
%token RETURN GIVE

%token INC DEC

%token L_SHIFT R_SHIFT MULT DIV MODULO ADD SUB OR AND EQUAL XOR NOT_EQUAL INF INF_EQUAL SUP SUP_EQUAL
%token ASSIGN ASSIGN_L_SHIFT ASSIGN_R_SHIFT ASSIGN_MULT ASSIGN_DIV ASSIGN_MODULO ASSIGN_ADD ASSIGN_SUB ASSIGN_OR ASSIGN_AND ASSIGN_XOR ASSIGN_EQUAL ASSIGN_NOT_EQUAL ASSIGN_INF ASSIGN_INF_EQUAL ASSIGN_SUP ASSIGN_SUP_EQUAL

%token FLOAT_INC FLOAT_DEC 
%token FLOAT_MULT FLOAT_DIV FLOAT_ADD FLOAT_SUB FLOAT_EQUAL FLOAT_NOT_EQUAL FLOAT_INF FLOAT_INF_EQUAL FLOAT_SUP FLOAT_SUP_EQUAL 
%token FLOAT_ASSIGN_MULT FLOAT_ASSIGN_DIV FLOAT_ASSIGN_ADD FLOAT_ASSIGN_SUB FLOAT_ASSIGN_EQUAL FLOAT_ASSIGN_NOT_EQUAL FLOAT_ASSIGN_INF FLOAT_ASSIGN_INF_EQUAL FLOAT_ASSIGN_SUP FLOAT_ASSIGN_SUP_EQUAL %token NOT TILDE

%token MULT_LINE_CMT_START MULT_LINE_CMT_CORE MULT_LINE_CMT_END

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
	|	FLOAT
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
	NAME '(' name_list_0_ ')' simple_statement
	NAME '(' name_list_0_ ')' '{' statement '}'
	;
simple_statement:
		RETURN rvalue_list_0_1 ';'
	|	GIVE rvalue_list_0_1 ';'
	|	rvalue ';'
	|	';'
; 
statement:
		AUTO name_constant_0_1_list_1_ ';'
	|	EXTERN name_list_1_ ';'
	|	NAME ':'
	/* |	CASE constant ':' statement */
	|	'{' statement_list_0_ '}'
	|	IF '(' rvalue ')' statement
	|	IF '(' rvalue ')' statement ELSE statement
	|	WHILE '(' rvalue ')' statement
	|	SWITCH rvalue statement
	|	GOTO rvalue ';'
	|	RETURN rvalue_list_0_1 ';'
	|	rvalue ';'
	|	';'
	;

statement_list_0_:
		// Empty
	|	statement statement_list_0_
	;

lvalue:
		NAME
	|	rvalue_postfix '[' rvalue ']'
	|	MULT rvalue_unary
	;
rvalue_list_0_1:
		// Empty
	|	rvalue
	;
rvalue_list_1_:
		rvalue
	|	rvalue ',' rvalue_list_1_
	;

rvalue_list_0_:
		// Empty
	|	rvalue_list_1_
	;
rvalue:
		rvalue_assign
	;

rvalue_assign:
		lvalue ASSIGN rvalue_assign
	|	lvalue ASSIGN_ADD rvalue_assign
	|	lvalue ASSIGN_SUB rvalue_assign
	|	lvalue ASSIGN_MULT rvalue_assign
	|	lvalue ASSIGN_DIV rvalue_assign
	|	lvalue ASSIGN_MODULO rvalue_assign
	|	lvalue ASSIGN_L_SHIFT rvalue_assign
	|	lvalue ASSIGN_R_SHIFT rvalue_assign
	|	lvalue ASSIGN_INF rvalue_assign
	|	lvalue ASSIGN_INF_EQUAL rvalue_assign
	|	lvalue ASSIGN_SUP rvalue_assign
	|	lvalue ASSIGN_SUP_EQUAL rvalue_assign
	|	lvalue ASSIGN_EQUAL rvalue_assign
	|	lvalue ASSIGN_NOT_EQUAL rvalue_assign
	|	lvalue ASSIGN_AND rvalue_assign
	|	lvalue ASSIGN_XOR rvalue_assign
	|	lvalue ASSIGN_OR rvalue_assign
	|	rvalue_ternary
	;

rvalue_ternary:
		rvalue_or '?' rvalue_ternary ':' rvalue_ternary
	|	rvalue_or
	;

rvalue_or:
		rvalue_or OR rvalue_and
	|	rvalue_and
	;

rvalue_and:
		rvalue_and AND rvalue_xor
	|	rvalue_xor
	;

rvalue_xor:
		rvalue_xor XOR rvalue_equal
	|	rvalue_equal
	;

rvalue_equal:
		rvalue_equal EQUAL rvalue_cmp
	|	rvalue_equal NOT_EQUAL rvalue_cmp
	|	rvalue_cmp
	;

rvalue_cmp:
		rvalue_cmp INF rvalue_shift
	|	rvalue_cmp INF_EQUAL rvalue_shift
	|	rvalue_cmp SUP rvalue_shift
	|	rvalue_cmp SUP_EQUAL rvalue_shift
	|	rvalue_shift
	;

rvalue_shift:
		rvalue_shift L_SHIFT rvalue_add
	|	rvalue_shift R_SHIFT rvalue_add
	|	rvalue_add
	;

rvalue_add:
		rvalue_add ADD rvalue_mul
	|	rvalue_add SUB rvalue_mul
	|	rvalue_mul
	;

rvalue_mul:
		rvalue_mul MULT rvalue_unary
	|	rvalue_mul DIV rvalue_unary
	|	rvalue_mul MODULO rvalue_unary
	|	rvalue_prefix
	;

rvalue_prefix:
		INC lvalue
	|	DEC lvalue
	|	rvalue_unary
	;

rvalue_unary:
		ADD rvalue_unary
	|	SUB rvalue_unary
	|	NOT rvalue_unary
	|	TILDE rvalue_unary
	|	AND lvalue
	|	rvalue_postfix
	;

rvalue_postfix:
		rvalue_postfix INC
	|	rvalue_postfix DEC
	|	rvalue_postfix '(' rvalue_list_0_ ')'
	|	'(' rvalue ')'
	|	constant
	|	rvalue_postfix '[' rvalue ']'
	|	NAME
	/* |	MULT rvalue_unary */
	;

%%

int main(void) {
	yyparse();
}
