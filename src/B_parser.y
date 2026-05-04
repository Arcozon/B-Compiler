%{
	#include "bCompiler.h"
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

%token WHILE
%token BREAK CONTINUE

%token SWITCH CASE DEFAULT

%token GOTO
%token RETURN DROP

%token INC DEC

%token L_SHIFT R_SHIFT MULT DIV MODULO ADD SUB OR AND EQUAL XOR NOT_EQUAL INF INF_EQUAL SUP SUP_EQUAL
%token ASSIGN ASSIGN_L_SHIFT ASSIGN_R_SHIFT ASSIGN_MULT ASSIGN_DIV ASSIGN_MODULO ASSIGN_ADD ASSIGN_SUB ASSIGN_OR ASSIGN_AND ASSIGN_XOR ASSIGN_EQUAL ASSIGN_NOT_EQUAL ASSIGN_INF ASSIGN_INF_EQUAL ASSIGN_SUP ASSIGN_SUP_EQUAL

%token FLOAT_INC FLOAT_DEC 
%token FLOAT_MULT FLOAT_DIV FLOAT_ADD FLOAT_SUB FLOAT_EQUAL FLOAT_NOT_EQUAL FLOAT_INF FLOAT_INF_EQUAL FLOAT_SUP FLOAT_SUP_EQUAL 
%token FLOAT_ASSIGN_MULT FLOAT_ASSIGN_DIV FLOAT_ASSIGN_ADD FLOAT_ASSIGN_SUB FLOAT_ASSIGN_EQUAL FLOAT_ASSIGN_NOT_EQUAL FLOAT_ASSIGN_INF FLOAT_ASSIGN_INF_EQUAL FLOAT_ASSIGN_SUP FLOAT_ASSIGN_SUP_EQUAL %token NOT TILDE

%token MULTI_LINE_CMT_END
%token UNKNOWN

%%


/*	██╗     ██╗███████╗████████╗
	██║     ██║██╔════╝╚══██╔══╝
	██║     ██║███████╗   ██║   
	██║     ██║╚════██║   ██║   
	███████╗██║███████║   ██║   
	╚══════╝╚═╝╚══════╝   ╚═╝   */

name_0_:	/* Empty */	|	name_1_	;
name_1_:	NAME	|	NAME ',' name_1_	;

constant_0_1:	/* Empty */	|	constant	;

name-constant_0_1:	NAME constant_0_1	;
name-constant_0_1_--1_:	name-constant_0_1	|	name-constant_0_1 ',' name-constant_0_1_--1_	;

ival_0_:	/* Empty */	|	ival_1_	;
ival_1_:	ival	|	ival ',' ival_1_	;

auto_extern_0_:		/* Empty */	|	auto auto_extern_0_	|	extern auto_extern_0_	;

statement_0_:	/* Empty */	|	statement statement_0_	;

rvalue_0_: /* Empty */ | rvalue_1_
rvalue_1_: rvalue | rvalue ',' rvalue_1_

/*	██████╗ ██████╗  ██████╗  ██████╗ ██████╗  █████╗ ███╗   ███╗
	██╔══██╗██╔══██╗██╔═══██╗██╔════╝ ██╔══██╗██╔══██╗████╗ ████║
	██████╔╝██████╔╝██║   ██║██║  ███╗██████╔╝███████║██╔████╔██║
	██╔═══╝ ██╔══██╗██║   ██║██║   ██║██╔══██╗██╔══██║██║╚██╔╝██║
	██║     ██║  ██║╚██████╔╝╚██████╔╝██║  ██║██║  ██║██║ ╚═╝ ██║
	╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝*/

program:
		 /* Empty */	{DEBUG("Found empty prog");}
	|	definition

definition:
		global_var_definition ';'
	|	function
			{DEBUG("Found function");}
	;

global_var_definition:
		NAME
			{DEBUG("Found global def simple def");}
	|	NAME '[' constant_0_1 ']' ival_0_
			{DEBUG("Found global def");}
	;

constant:	INTEGER	|	STRING	|	CHAR	|	FLOAT	;
ival:	NAME	|	constant	;


/*	███████╗██╗   ██╗███╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗
	██╔════╝██║   ██║████╗  ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║
	█████╗  ██║   ██║██╔██╗ ██║██║        ██║   ██║██║   ██║██╔██╗ ██║
	██╔══╝  ██║   ██║██║╚██╗██║██║        ██║   ██║██║   ██║██║╚██╗██║
	██║     ╚██████╔╝██║ ╚████║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║
	╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝*/

function:
	function_definition function_declaration
	;

function_definition:
		NAME '(' name_0_ ')'
			{DEBUG("Function prototype")}
	;

function_declaration:
		auto_extern_0_ statement	// Some weirdo can do that btw
			{}
	|	'{' auto_extern_0_ statement'}'
			{}
	;


/*	 █████╗ ██╗   ██╗████████╗ ██████╗       ███████╗██╗  ██╗████████╗██████╗ ███╗   ██╗
	██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗      ██╔════╝╚██╗██╔╝╚══██╔══╝██╔══██╗████╗  ██║
	███████║██║   ██║   ██║   ██║   ██║█████╗█████╗   ╚███╔╝    ██║   ██████╔╝██╔██╗ ██║
	██╔══██║██║   ██║   ██║   ██║   ██║╚════╝██╔══╝   ██╔██╗    ██║   ██╔══██╗██║╚██╗██║
	██║  ██║╚██████╔╝   ██║   ╚██████╔╝      ███████╗██╔╝ ██╗   ██║   ██║  ██║██║ ╚████║
	╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝       ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝*/

auto:
		AUTO name-constant_0_1_--1_ ';'
			{DEBUG("Auto declaration")}
	;

extern:
		EXTERN name_1_ ';'
			{DEBUG("Extern declaration")}
	;


/*	███████╗████████╗ █████╗ ████████╗███████╗███╗   ███╗███████╗███╗   ██╗████████╗
	██╔════╝╚══██╔══╝██╔══██╗╚══██╔══╝██╔════╝████╗ ████║██╔════╝████╗  ██║╚══██╔══╝
	███████╗   ██║   ███████║   ██║   █████╗  ██╔████╔██║█████╗  ██╔██╗ ██║   ██║   
	╚════██║   ██║   ██╔══██║   ██║   ██╔══╝  ██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║   
	███████║   ██║   ██║  ██║   ██║   ███████╗██║ ╚═╝ ██║███████╗██║ ╚████║   ██║   
	╚══════╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   */

statement:
		label
	|	CASE constant ':' statement
	|	DEFAULT ':' statement
	|	'{' statement_0_ '}'
	|	IF '(' rvalue ')' statement
	|	IF '(' rvalue ')' statement ELSE statement
	|	WHILE '(' rvalue ')' statement
	|	SWITCH rvalue statement
	|	CONTINUE ';'
	|	BREAK ';'
	|	GOTO rvalue;
	|	return ';'
	|	drop ';'
	|	rvalue_0_ ';'
	;

label: NAME ':' statement
	{DEBUG("Label declaration")}
;

return:
		RETURN
	|	RETURN rvalue
	;

drop:
		DROP
	|	DROP rvalue
	;

rvalue:
		'(' rvalue_1_ ')'
	/* |	LAMBDA */
	|	lvalue
	|	constant
	|	lvalue ASSIGN rvalue
	|	pre-inc_dec
	|	post-inc_dec
	|	unary-rvalue
	|	AND lvalue
	|	rvalue-binary-rvalue
	|	ternary
	|	function_call
	;

pre-inc_dec:
		INC lvalue
	|	DEC lvalue
	;

post-inc_dec:
		lvalue INC 
	|	lvalue DEC 
	;

unary-rvalue:
		SUB rvalue
	|	NOT rvalue
	|	TILDE rvalue
	;

ternary:
	rvalue '?' rvalue ':' rvalue
	;

rvalue-binary-rvalue:
	;	// LONG

lvalue:
		NAME
	|	MULT rvalue
	|	rvalue '[' rvalue ']'
	;

function_call:
	rvalue '(' rvalue_0_ ')'
	;

%%

void	yyerror (char const s[]) {
	fprintf (stderr, "%s\n", s);
}


data_t	parsData;

int main(void) {
	yyparse();
}

