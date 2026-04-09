%{
	#include "y.tab.h"
%}

%%

"auto"		{}
"extern"		{}

"++"		{}
"--"		{}

"|"		{}
"&"		{}

"=="		{}
"!="		{}
"<"		{}
"<="		{}
">"		{}
">="		{}
"<<"		{}
">>"		{}
"+"		{}
"-"		{}
"%"		{}
"*"		{}
"/"		{}

"!"		{}


0b[0-1]+		{	yylval.ival = strtol(yytext + 2, NULL, 2);	return INTEGER;}
0[0-7]+			{	yylval.ival = strtol(yytext + 1, NULL, 8);	return INTEGER;}
0x[0-9a-fA-F]+	{	yylval.ival = strtol(yytext + 2, NULL, 16);	return INTEGER;}
[0-9]+			{	yylval.ival = strtol(yytext, NULL, 10);		return INTEGER;}
[0-9]+\.[0-9]+?	{	yylval.fval = strtod(yytext, NULL);			return FLOAT;}

[A-Za-z_][A-Za-z0-9_]*		{ yylval.sval = strdup(yytext);		return NAME;}

.				{}


%%

int yywrap(void) { return 1; }
