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

%token AUTO

%type <sval> string
%%

program:
	| program statement
	;

statement:
		declaration
	|	assignation
	;

declaration:
	AUTO NAME	{
		//Add Name to tree
		printf("auto %s\n", $2);}
	| declaration ',' NAME {
		//Add Name to tree
	}
	;

assignation:
		NAME '=' value  ';'	{
			// printf("%s = %d", $1, $3);
		}
	;

value:
		NAME
	|	number
	|	string
	;

string:
		'"' NAME '"' {
			$$ = $2;
			}
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
