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

%token <ival> INTEGER
%token <fval> FLOAT
%token <sval> NAME

%%

program:
	| program statement
	;

statement:
	|	NAME	{printf("Found Name [%s]\n", $1);}
	|	number
	;

number:
		INTEGER	{
			printf("Found Number [%d]\n", $1);
		}
	|	FLOAT {
			printf("Found Float [%f]\n", $1);
		}
	;

%%

int main(void) {
	yyparse();
}
