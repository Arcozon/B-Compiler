%{
	#include "bCompiler.h"
%}

%union {
	int	ival;
	float	fval;
	char	*sval;
}

%start program

%token ERROR

%token INTEGER STRING CHAR FLOAT
%token NAME

%token AUTO EXTERN
%token IF ELSE

%token WHILE
%token BREAK CONTINUE

%token SWITCH CASE DEFAULT

%token GOTO
%token DROP PICK
%token RETURN

%token INC DEC
%token	INT_TO_FLOAT FLOAT_TO_INT

%token LOGICAL_AND LOGICAL_OR

%token L_SHIFT R_SHIFT MULT DIV MODULO ADD SUB OR AND EQUAL XOR NOT_EQUAL INF INF_EQUAL SUP SUP_EQUAL
%token ASSIGN ASSIGN_L_SHIFT ASSIGN_R_SHIFT ASSIGN_MULT ASSIGN_DIV ASSIGN_MODULO ASSIGN_ADD ASSIGN_SUB ASSIGN_OR ASSIGN_AND ASSIGN_XOR ASSIGN_EQUAL ASSIGN_NOT_EQUAL ASSIGN_INF ASSIGN_INF_EQUAL ASSIGN_SUP ASSIGN_SUP_EQUAL

%token FLOAT_INC FLOAT_DEC 
%token FLOAT_MULT FLOAT_DIV FLOAT_ADD FLOAT_SUB FLOAT_EQUAL FLOAT_NOT_EQUAL FLOAT_INF FLOAT_INF_EQUAL FLOAT_SUP FLOAT_SUP_EQUAL 
%token FLOAT_ASSIGN_MULT FLOAT_ASSIGN_DIV FLOAT_ASSIGN_ADD FLOAT_ASSIGN_SUB FLOAT_ASSIGN_EQUAL FLOAT_ASSIGN_NOT_EQUAL FLOAT_ASSIGN_INF FLOAT_ASSIGN_INF_EQUAL FLOAT_ASSIGN_SUP FLOAT_ASSIGN_SUP_EQUAL %token NOT TILDE

%token MULTI_LINE_CMT_END
%token UNKNOWN

%left INC SUB FLOAT_INC FLOAT_SUB

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

statement_0_:	/* Empty */	|	statement statement_0_	;

rvalue_0_1: /* Empty */ | rvalue
rvalue_0_: /* Empty */ | rvalue_1_
rvalue_1_: rvalue | rvalue ',' rvalue_1_

/*	██████╗ ██████╗  ██████╗  ██████╗ ██████╗  █████╗ ███╗   ███╗
	██╔══██╗██╔══██╗██╔═══██╗██╔════╝ ██╔══██╗██╔══██╗████╗ ████║
	██████╔╝██████╔╝██║   ██║██║  ███╗██████╔╝███████║██╔████╔██║
	██╔═══╝ ██╔══██╗██║   ██║██║   ██║██╔══██╗██╔══██║██║╚██╔╝██║
	██║     ██║  ██║╚██████╔╝╚██████╔╝██║  ██║██║  ██║██║ ╚═╝ ██║
	╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝*/

program:
	|	definition program

definition:
		global_var_definition ';'
	|	function
	;

global_var_definition:
		NAME
		{
			printf("%s\n", yylval.sval);
		}
	|	NAME '[' constant_0_1 ']' ival_0_
	;

constant:	INTEGER	|	STRING	|	CHAR	|	FLOAT	;
ival:		NAME	|	constant	;

/*	███████╗██╗   ██╗███╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗
	██╔════╝██║   ██║████╗  ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║
	█████╗  ██║   ██║██╔██╗ ██║██║        ██║   ██║██║   ██║██╔██╗ ██║
	██╔══╝  ██║   ██║██║╚██╗██║██║        ██║   ██║██║   ██║██║╚██╗██║
	██║     ╚██████╔╝██║ ╚████║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║
	╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝*/

function:
	function_definition statement
	;

function_definition:
		NAME '(' name_0_ ')'
			{DEBUG("Function prototype")}
	;

/*	██╗      █████╗ ███╗   ███╗██████╗ ██████╗  █████╗ 
	██║     ██╔══██╗████╗ ████║██╔══██╗██╔══██╗██╔══██╗
	██║     ███████║██╔████╔██║██████╔╝██║  ██║███████║
	██║     ██╔══██║██║╚██╔╝██║██╔══██╗██║  ██║██╔══██║
	███████╗██║  ██║██║ ╚═╝ ██║██████╔╝██████╔╝██║  ██║
	╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═════╝ ╚═════╝ ╚═╝  ╚═╝*/

lambda_declaration:
		 lambda_prototype scope
			{DEBUG("Lambda_declaration")}
	;

lambda_prototype:
		'(' name_0_ ')'
			{DEBUG("Lambda_proto")}
	;

/*	███████╗ ██████╗ ██████╗ ██████╗ ███████╗
	██╔════╝██╔════╝██╔═══██╗██╔══██╗██╔════╝
	███████╗██║     ██║   ██║██████╔╝█████╗  
	╚════██║██║     ██║   ██║██╔═══╝ ██╔══╝  
	███████║╚██████╗╚██████╔╝██║     ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚══════╝

	 █████╗ ██╗   ██╗████████╗ ██████╗       ███████╗██╗  ██╗████████╗██████╗ ███╗   ██╗
	██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗      ██╔════╝╚██╗██╔╝╚══██╔══╝██╔══██╗████╗  ██║
	███████║██║   ██║   ██║   ██║   ██║█████╗█████╗   ╚███╔╝    ██║   ██████╔╝██╔██╗ ██║
	██╔══██║██║   ██║   ██║   ██║   ██║╚════╝██╔══╝   ██╔██╗    ██║   ██╔══██╗██║╚██╗██║
	██║  ██║╚██████╔╝   ██║   ╚██████╔╝      ███████╗██╔╝ ██╗   ██║   ██║  ██║██║ ╚████║
	╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝       ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝*/

auto:
		AUTO name-constant_0_1_--1_
			{DEBUG("Auto declaration")}
	;

extern:
		EXTERN name_1_
			{DEBUG("Extern declaration")}
	;

scope:
     	'{'	statement_0_	'}'
     ;



/*	███████╗████████╗ █████╗ ████████╗███████╗███╗   ███╗███████╗███╗   ██╗████████╗
	██╔════╝╚══██╔══╝██╔══██╗╚══██╔══╝██╔════╝████╗ ████║██╔════╝████╗  ██║╚══██╔══╝
	███████╗   ██║   ███████║   ██║   █████╗  ██╔████╔██║█████╗  ██╔██╗ ██║   ██║   
	╚════██║   ██║   ██╔══██║   ██║   ██╔══╝  ██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║   
	███████║   ██║   ██║  ██║   ██║   ███████╗██║ ╚═╝ ██║███████╗██║ ╚████║   ██║   
	╚══════╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   */

statement:
	 	auto ';' statement
	| 	extern ';' statement
	|	label statement
	|	SWITCH rvalue statement
	|	CASE constant ':' statement
	|	DEFAULT ':' statement
	|	IF '(' rvalue ')' statement
	|	IF '(' rvalue ')' statement ELSE statement
	|	WHILE '(' rvalue ')' statement
	|	CONTINUE ';'
	|	BREAK ';'
	|	GOTO rvalue ';'
	|	return ';'
	|	drop ';'
	|	scope
	|	rvalue_0_1 ';'
	;

label:
    		 NAME ':' 
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


/*	██████╗       ██╗   ██╗ █████╗ ██╗     ██╗   ██╗███████╗
	██╔══██╗      ██║   ██║██╔══██╗██║     ██║   ██║██╔════╝
	██████╔╝█████╗██║   ██║███████║██║     ██║   ██║█████╗  
	██╔══██╗╚════╝╚██╗ ██╔╝██╔══██║██║     ██║   ██║██╔══╝  
	██║  ██║       ╚████╔╝ ██║  ██║███████╗╚██████╔╝███████╗
	╚═╝  ╚═╝        ╚═══╝  ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚══════╝*/

rvalue:
		rvalue12
	;

rvalue0:
		lvalue
			{}
	|	constant
			{}
	|	lambda_declaration
			{}
	|	function_call
			{DEBUG("Function Call");}
	|	'(' rvalue ')'
			{}
	|	PICK scope
			{}
	;

rvalue1:
		pre-inc_dec
			{}
	|	post-inc_dec
			{}
	|	AND lvalue
			{}
	|	MULT rvalue1
			{}
	|	SUB rvalue1
		 	{}
	|	NOT rvalue1
			{}
	|	TILDE rvalue1
			{}
	|	FLOAT_SUB rvalue1
			{}
	|	INT_TO_FLOAT rvalue1
			{}
	|	FLOAT_TO_INT rvalue1
			{}
	|	rvalue0
	;

rvalue2:
		rvalue2 R_SHIFT rvalue1
			{}
	|	rvalue2 L_SHIFT rvalue1
			{}
	|	rvalue1
	;

rvalue3:
		rvalue3 AND rvalue2
			{}
	|	rvalue2
	;

rvalue4:
		rvalue4 XOR rvalue3
			{}
	|	rvalue3
	;

rvalue5:
		rvalue5 OR rvalue4
			{}
	|	rvalue4
	;

rvalue6:
		rvalue6 MULT rvalue5
			{}
	|	rvalue6 DIV rvalue5
			{}
	|	rvalue6 MODULO rvalue5
			{}
	|	rvalue6 FLOAT_MULT rvalue5
			{}
	|	rvalue6 FLOAT_DIV rvalue5
			{}
	|	rvalue5
	;

rvalue7:
		rvalue7 ADD rvalue6
			{}
	|	rvalue7 SUB rvalue6
			{}
	|	rvalue7 FLOAT_SUB rvalue6
			{}
	|	rvalue7 FLOAT_ADD rvalue6
			{}
	|	rvalue6
	;

rvalue8:
		rvalue8 EQUAL rvalue7
			{}
	|	rvalue8 NOT_EQUAL rvalue7
			{}
	|	rvalue8 SUP rvalue7
			{}
	|	rvalue8 INF rvalue7
			{}
	|	rvalue8 SUP_EQUAL rvalue7
			{}
	|	rvalue8 INF_EQUAL rvalue7
			{}
	|	rvalue8 FLOAT_EQUAL rvalue7
			{}
	|	rvalue8 FLOAT_NOT_EQUAL rvalue7
			{}
	|	rvalue8 FLOAT_SUP rvalue7
			{}
	|	rvalue8 FLOAT_INF rvalue7
			{}
	|	rvalue8 FLOAT_SUP_EQUAL rvalue7
			{}
	|	rvalue8 FLOAT_INF_EQUAL rvalue7
			{}
	|	rvalue7
	;

rvalue9:
		rvalue9 LOGICAL_AND rvalue8
			{}
	|	rvalue8
	;

rvalue10:
		rvalue10 LOGICAL_OR rvalue9
			{}
	|	rvalue9
	;

rvalue11:
		rvalue10 '?' rvalue11 ':' rvalue11
			{}
	|	rvalue10
	;

rvalue12:
		assignment
			{}
	|	rvalue11
	;

pre-inc_dec:
		INC lvalue
	|	DEC lvalue
	|	FLOAT_INC lvalue
	|	FLOAT_DEC lvalue
	;

post-inc_dec:
		lvalue INC 
	|	lvalue DEC 
	|	lvalue FLOAT_INC
	|	lvalue FLOAT_DEC
	;

lvalue:
		NAME
	|	MULT rvalue0
	|	deref_array	
	;

deref_array:
		rvalue0 '[' rvalue ']'
			{}
	;

function_call:
		rvalue0 '(' rvalue_0_ ')'
	;


/*	 █████╗ ███████╗███████╗██╗ ██████╗ ███╗   ██╗███████╗███╗   ███╗███████╗███╗   ██╗████████╗
	██╔══██╗██╔════╝██╔════╝██║██╔════╝ ████╗  ██║██╔════╝████╗ ████║██╔════╝████╗  ██║╚══██╔══╝
	███████║███████╗███████╗██║██║  ███╗██╔██╗ ██║█████╗  ██╔████╔██║█████╗  ██╔██╗ ██║   ██║   
	██╔══██║╚════██║╚════██║██║██║   ██║██║╚██╗██║██╔══╝  ██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║   
	██║  ██║███████║███████║██║╚██████╔╝██║ ╚████║███████╗██║ ╚═╝ ██║███████╗██║ ╚████║   ██║   
	╚═╝  ╚═╝╚══════╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   */

assignment:
	   lvalue assign_opp rvalue12;

assign_opp:
		ASSIGN
			{}
	|	ASSIGN_L_SHIFT
			{}
	|	ASSIGN_R_SHIFT
			{}
	|	ASSIGN_MULT
			{}
	|	ASSIGN_DIV
			{}
	|	ASSIGN_MODULO
			{}
	|	ASSIGN_ADD
			{}
	|	ASSIGN_SUB
			{}
	|	ASSIGN_OR
			{}
	|	ASSIGN_AND
			{}
	|	ASSIGN_XOR
			{}
	|	ASSIGN_EQUAL
			{}
	|	ASSIGN_NOT_EQUAL
			{}
	|	ASSIGN_INF
			{}
	|	ASSIGN_INF_EQUAL
			{}
	|	ASSIGN_SUP
			{}
	|	ASSIGN_SUP_EQUAL
			{}
	|	FLOAT_ASSIGN_MULT
			{}
	|	FLOAT_ASSIGN_DIV
			{}
	|	FLOAT_ASSIGN_ADD
			{}
	|	FLOAT_ASSIGN_SUB
			{}
	|	FLOAT_ASSIGN_EQUAL
			{}
	|	FLOAT_ASSIGN_NOT_EQUAL
			{}
	|	FLOAT_ASSIGN_INF
			{}
	|	FLOAT_ASSIGN_INF_EQUAL
			{}
	|	FLOAT_ASSIGN_SUP
			{}
	|	FLOAT_ASSIGN_SUP_EQUAL
			{}
	;

%%

void	yyerror (char const s[]) {
	fprintf (stderr, "%s\n", s);
}


data_t	parsData;

int main(void) {
	yyparse();
}
