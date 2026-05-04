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

%token  MULT_LINE_CMT_END

%start program

%%

/*	██╗     ██╗███████╗████████╗
	██║     ██║██╔════╝╚══██╔══╝
	██║     ██║███████╗   ██║   
	██║     ██║╚════██║   ██║   
	███████╗██║███████║   ██║   
	╚══════╝╚═╝╚══════╝   ╚═╝   */

name_0_:	/* Empty */	|	name_1_	;
name_1_:	NAME	|	NAME ',' name_1_	;

name_constant_0_1:	NAME constant_0_1	;
name_constant_0_1_-_1_:	name_constant_0_1	|	name_constant_0_1 ',' name_constant_0_1_-_1_	;

constant_0_1:	/* Empty */	|	constant	;

ival_0_:	/* Empty */	|	ival_1_	;
ival_1_:	ival	|	ival ',' ival_1_	;

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
	|	function_definition
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

%%

void	yyerror (char const s[]) {
  fprintf (stderr, "%s\n", s);
}


data_t	parsData;

int main(void) {
	yyparse();
}
