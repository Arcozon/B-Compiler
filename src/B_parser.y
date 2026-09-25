%{
	#include "bCompiler.h"
%}

%union {
	int	intval;
	float	floatval;
	char	*strval;
	struct {
		char		**sstr;
		uint64_t	len;
	}	sstrval;
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

%token	INC DEC
%token	INT_TO_FLOAT FLOAT_TO_INT

%token LOGICAL_AND LOGICAL_OR

%token L_SHIFT R_SHIFT MULT DIV MODULO ADD SUB OR AND  XOR EQUAL NOT_EQUAL INF INF_EQUAL SUP SUP_EQUAL
%token ASSIGN ASSIGN_L_SHIFT ASSIGN_R_SHIFT ASSIGN_MULT ASSIGN_DIV ASSIGN_MODULO ASSIGN_ADD ASSIGN_SUB ASSIGN_OR ASSIGN_AND ASSIGN_XOR ASSIGN_EQUAL ASSIGN_NOT_EQUAL ASSIGN_INF ASSIGN_INF_EQUAL ASSIGN_SUP ASSIGN_SUP_EQUAL

%token FLOAT_INC FLOAT_DEC 
%token FLOAT_MULT FLOAT_DIV FLOAT_ADD FLOAT_SUB FLOAT_EQUAL FLOAT_NOT_EQUAL FLOAT_INF FLOAT_INF_EQUAL FLOAT_SUP FLOAT_SUP_EQUAL 
%token FLOAT_ASSIGN_MULT FLOAT_ASSIGN_DIV FLOAT_ASSIGN_ADD FLOAT_ASSIGN_SUB FLOAT_ASSIGN_EQUAL FLOAT_ASSIGN_NOT_EQUAL FLOAT_ASSIGN_INF FLOAT_ASSIGN_INF_EQUAL FLOAT_ASSIGN_SUP FLOAT_ASSIGN_SUP_EQUAL
%token NOT TILDE

%token MULTI_LINE_CMT_END
/* %token UNKNOWN */


%right ASSIGN ASSIGN_L_SHIFT ASSIGN_R_SHIFT ASSIGN_MULT ASSIGN_DIV ASSIGN_MODULO ASSIGN_ADD ASSIGN_SUB ASSIGN_OR ASSIGN_AND ASSIGN_XOR ASSIGN_EQUAL ASSIGN_NOT_EQUAL ASSIGN_INF ASSIGN_INF_EQUAL ASSIGN_SUP ASSIGN_SUP_EQUAL
%right FLOAT_ASSIGN_MULT FLOAT_ASSIGN_DIV FLOAT_ASSIGN_ADD FLOAT_ASSIGN_SUB FLOAT_ASSIGN_EQUAL FLOAT_ASSIGN_NOT_EQUAL FLOAT_ASSIGN_INF FLOAT_ASSIGN_INF_EQUAL FLOAT_ASSIGN_SUP FLOAT_ASSIGN_SUP_EQUAL

%left INC SUB FLOAT_INC FLOAT_SUB 

// comparaison cannot be chained
%nonassoc EQUAL NOT_EQUAL INF INF_EQUAL SUP SUP_EQUAL FLOAT_EQUAL FLOAT_NOT_EQUAL FLOAT_INF FLOAT_INF_EQUAL FLOAT_SUP FLOAT_SUP_EQUAL

%left _FCT_CALL
%right _DEREF_PTR
%left _DEREF_ARR '['
%nonassoc _LVALUE
%right _IF_NO_ELSE
/* %right ELSE */

%type <strval> name

%%


/*	██╗     ██╗███████╗████████╗
	██║     ██║██╔════╝╚══██╔══╝
	██║     ██║███████╗   ██║   
	██║     ██║╚════██║   ██║   
	███████╗██║███████║   ██║   
	╚══════╝╚═╝╚══════╝   ╚═╝   */

name:	NAME	{
    $$ = yylval.strval;
    DEBUG("Name: [%s]", yylval.strval);
}
	;

name_0_:	/* Empty */	|	name_1_	;
name_1_:	name	|	NAME ',' name_1_	;

constant_0_1:	/* Empty */	|	constant	;

name-constant_0_1:	name constant_0_1	;
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
		{} // Nothing
	|	definition program

definition:
		global_var_definition ';'
	|	function
	;

global_var_definition:
		name
		{
			writeBss($1);	
		}
	|	name '[' constant_0_1 ']' ival_0_
	;

constant:	INTEGER	|	STRING	|	CHAR	|	FLOAT	;
ival:		name	|	constant	;

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
		name '(' name_0_ ')'
		{
			printf("Function : %s\n", $1);
		}
	;

/*	██╗      █████╗ ███╗   ███╗██████╗ ██████╗  █████╗ 
	██║     ██╔══██╗████╗ ████║██╔══██╗██╔══██╗██╔══██╗
	██║     ███████║██╔████╔██║██████╔╝██║  ██║███████║
	██║     ██╔══██║██║╚██╔╝██║██╔══██╗██║  ██║██╔══██║
	███████╗██║  ██║██║ ╚═╝ ██║██████╔╝██████╔╝██║  ██║
	╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═════╝ ╚═════╝ ╚═╝  ╚═╝*/

lambda_declaration:
		'(' name_0_ ')'
			{DEBUG("Lambda_proto")}
		scope
			{DEBUG("Lambda_declaration")}
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
	|	switch_statement
	|	CASE constant ':' statement
	|	DEFAULT ':' statement
	|	if_statement
	|	WHILE '(' rvalue ')' statement
	|	CONTINUE ';'
	|	BREAK ';'
	|	GOTO rvalue ';'
	|	return ';'
	|	drop ';'
	|	scope
	|	rvalue_0_1 ';'
	;

if_statement:
		IF '(' rvalue ')' statement						%prec _IF_NO_ELSE
	|	IF '(' rvalue ')' statement ELSE statement
	;

switch_statement:
		SWITCH '(' rvalue  ')' '{'statement_0_ '}'
	;

label:
		name ':' 
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
		rvalue13
	;

lvalue:
	 	name
	|	MULT rvalue2
	|   rvalue0 '[' rvalue ']'
	;

rvalue0:
	 	name
	|	MULT rvalue2
	|   rvalue0 '[' rvalue ']'
			{}
	|	constant
			{}
	|	lambda_declaration
			{}
	|	function_call	%prec _FCT_CALL
			{DEBUG("Function Call");}
	|	'(' rvalue_1_ ')'
			{}
	|	PICK scope
			{}
	;

rvalue1:
		pre-inc_dec	
			{}
	|	post-inc_dec
			{}

rvalue2:
		AND lvalue	
			{}
	|	SUB rvalue2
		 	{}
	|	NOT rvalue2
			{}
	|	TILDE rvalue2
			{}
	|	FLOAT_SUB rvalue2
			{}
	|	INT_TO_FLOAT rvalue2
			{}
	|	FLOAT_TO_INT rvalue2
			{}
	|	rvalue1	
	;

rvalue3:
		rvalue3 R_SHIFT rvalue2
			{}
	|	rvalue3 L_SHIFT rvalue2
			{}
	|	rvalue2
	;

rvalue4:
		rvalue4 AND rvalue3
			{}
	|	rvalue3
	;

rvalue5:
		rvalue5 XOR rvalue4
			{}
	|	rvalue4
	;

rvalue6:
		rvalue6 OR rvalue5
			{}
	|	rvalue5
	;

rvalue7:
		rvalue7 MULT rvalue6
			{}
	|	rvalue7 DIV rvalue6
			{}
	|	rvalue7 MODULO rvalue6
			{}
	|	rvalue7 FLOAT_MULT rvalue6
			{}
	|	rvalue7 FLOAT_DIV rvalue6
			{}
	|	rvalue6
	;

rvalue8:
		rvalue8 ADD rvalue7
			{}
	|	rvalue8 SUB rvalue7
			{}
	|	rvalue8 FLOAT_SUB rvalue7
			{}
	|	rvalue8 FLOAT_ADD rvalue7
			{}
	|	rvalue7
	;

rvalue9:
		rvalue9 EQUAL rvalue8
			{}
	|	rvalue9 NOT_EQUAL rvalue8
			{}
	|	rvalue9 SUP rvalue8
			{}
	|	rvalue9 INF rvalue8
			{}
	|	rvalue9 SUP_EQUAL rvalue8
			{}
	|	rvalue9 INF_EQUAL rvalue8
			{}
	|	rvalue9 FLOAT_EQUAL rvalue8
			{}
	|	rvalue9 FLOAT_NOT_EQUAL rvalue8
			{}
	|	rvalue9 FLOAT_SUP rvalue8
			{}
	|	rvalue9 FLOAT_INF rvalue8
			{}
	|	rvalue9 FLOAT_SUP_EQUAL rvalue8
			{}
	|	rvalue9 FLOAT_INF_EQUAL rvalue8
			{}
	|	rvalue8
	;

rvalue10:
		rvalue10 LOGICAL_AND rvalue9
			{}
	|	rvalue9
	;

rvalue11:
		rvalue11 LOGICAL_OR rvalue10
			{}
	|	rvalue10
	;

rvalue12:
		rvalue11 '?' rvalue12 ':' rvalue12
			{}
	|	rvalue11
	;

rvalue13:
		assignment
			{}
	|	rvalue12
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

/* deref_array:
		rvalue0 '[' rvalue ']' 	%prec PREC_DEREF_ARRAY
			{}
	; */

function_call:
		rvalue0 '(' rvalue_0_ ')' 	%prec _FCT_CALL
	;


/*	 █████╗ ███████╗███████╗██╗ ██████╗ ███╗   ██╗███████╗███╗   ███╗███████╗███╗   ██╗████████╗
	██╔══██╗██╔════╝██╔════╝██║██╔════╝ ████╗  ██║██╔════╝████╗ ████║██╔════╝████╗  ██║╚══██╔══╝
	███████║███████╗███████╗██║██║  ███╗██╔██╗ ██║█████╗  ██╔████╔██║█████╗  ██╔██╗ ██║   ██║   
	██╔══██║╚════██║╚════██║██║██║   ██║██║╚██╗██║██╔══╝  ██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║   
	██║  ██║███████║███████║██║╚██████╔╝██║ ╚████║███████╗██║ ╚═╝ ██║███████╗██║ ╚████║   ██║   
	╚═╝  ╚═╝╚══════╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   */

assignment:
	   lvalue assign_opp rvalue13;


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

data_t	parsData =  {0};

int main(void) {
	/* printf(".intel_syntax noprefix\n"); */
	yyparse();
}
