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


/* %right INC DEC */
%nonassoc INC DEC 
/* %right PRE_INC_DEC */

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
	|	rvalue '[' rvalue ']'
	|	MULT rvalue
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
		rvalue_1
	;
rvalue_1:
		lvalue INC						%prec INC
	|	lvalue DEC						%prec INC
	|	rvalue '(' rvalue_list_0_')'
	|	rvalue_2
	;
rvalue_2:
		INC lvalue
	|	DEC lvalue
	|	ADD rvalue
	|	SUB rvalue
	|	NOT rvalue
	|	TILDE lvalue
	|	AND lvalue
	|	rvalue_3
	;
rvalue_3:
		rvalue MULT rvalue
	|	rvalue DIV rvalue
	|	rvalue MODULO rvalue
	|	rvalue_4
rvalue_4:
		rvalue ADD rvalue
	|	rvalue SUB rvalue
	|	rvalue_5
	;
rvalue_5:
		rvalue L_SHIFT rvalue
	|	rvalue R_SHIFT rvalue
	|	rvalue_6
	;
rvalue_6:
		rvalue INF rvalue
	|	rvalue INF_EQUAL rvalue
	|	rvalue SUP rvalue
	|	rvalue SUP_EQUAL rvalue
	|	rvalue_7
	;
rvalue_7:
		 EQUAL rvalue
	|	rvalue NOT_EQUAL rvalue
	|	rvalue_8
	;
rvalue_8:
		rvalue AND rvalue
	|	rvalue_9
	;
rvalue_9:
		rvalue XOR rvalue
	|	rvalue_10
	;
rvalue_10:
		rvalue OR rvalue
	|	rvalue_11
	;
rvalue_11:
		rvalue_12	// LOGIC_AND && LOGIC_OR ||
	;
rvalue_12:
		rvalue '?' rvalue ':' rvalue
	|	lvalue ASSIGN rvalue
	|	lvalue ASSIGN_ADD rvalue
	|	lvalue ASSIGN_SUB rvalue
	|	lvalue ASSIGN_MULT rvalue
	|	lvalue ASSIGN_DIV rvalue
	|	lvalue ASSIGN_MODULO rvalue
	|	lvalue ASSIGN_L_SHIFT rvalue
	|	lvalue ASSIGN_R_SHIFT rvalue
	|	lvalue ASSIGN_INF rvalue
	|	lvalue ASSIGN_INF_EQUAL rvalue
	|	lvalue ASSIGN_SUP_EQUAL rvalue
	|	lvalue ASSIGN_EQUAL rvalue
	|	lvalue ASSIGN_NOT_EQUAL rvalue
	|	lvalue ASSIGN_AND rvalue
	|	lvalue ASSIGN_XOR rvalue
	|	lvalue ASSIGN_OR rvalue
	|	'(' rvalue ')'
	|	lvalue
	|	constant
	;

%%

int main(void) {
	yyparse();
}
