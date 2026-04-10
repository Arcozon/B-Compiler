%{
	#include "y.tab.h"
	#include "var_type.h"
%}

%%

"auto"		{return AUTO;}
"extern"	{return EXTERN;}

"goto"		{return GOTO;}

"switch"	{return SWITCH;}
"case"		{return CASE;}

"while"		{return WHILE;}

"if"		{return IF;}
"else"		{return ELSE;}
"elif"		{return ELIF;}

"return"	{return RETURN;}

"++"		{return INC;}
"--"		{return DEC;}

"!"			{return NOT;}
"~"			{return TILDE;}

"<<"		{return L_SHIFT;}
">>"		{return R_SHIFT;}
"*"			{return MULT;}
"/"			{return DIV;}
"%"			{return MODULO;}
"+"			{return ADD;}
"-"			{return SUB;}
"|"			{return OR;}
"&"			{return AND;}
"^"			{return XOR;}
"=="		{return EQUAL;}
"!="		{return NOT_EQUAL;}
"<"			{return INF;}
"<="		{return INF_EQUAL;}
">"			{return SUP;}
">="		{return SUP_EQUAL;}

"="			{return ASSIGN;}
"=<<"		{return ASSIGN_L_SHIFT;}
"=>>"		{return ASSIGN_R_SHIFT;}
"=*"		{return ASSIGN_MULT;}
"=/"		{return ASSIGN_DIVI;}
"=%"		{return ASSIGN_MODULO;}
"=+"		{return ASSIGN_ADD;}
"=-"		{return ASSIGN_SUB;}
"=|"		{return ASSIGN_OR;}
"=&"		{return ASSIGN_AND;}
"=^"		{return ASSIGN_XOR;}
"==="		{return ASSIGN_EQUAL;}
"=!="		{return ASSIGN_NOT_EQUAL;}
"=<"		{return ASSIGN_INF;}
"=<="		{return ASSIGN_INF_EQUAL;}
"=>"		{return ASSIGN_SUP;}
"=>="		{return ASSIGN_SUP_EQUAL;}

0b[0-1]+		{	yylval.ival = strtol(yytext + 2, NULL, 2);	return INTEGER;}
0[0-7]+			{	yylval.ival = strtol(yytext + 1, NULL, 8);	return INTEGER;}
0x[0-9a-fA-F]+	{	yylval.ival = strtol(yytext + 2, NULL, 16);	return INTEGER;}
[0-9]+			{	yylval.ival = strtol(yytext, NULL, 10);		return INTEGER;}
[0-9]+\.[0-9]+?	{	yylval.fval = strtod(yytext, NULL);			return FLOAT;}

[A-Za-z][A-Za-z0-9]*		{ yylval.sval = strdup(yytext);		return NAME;}

'[^*]'			{	yylval.ival = yytext[2]; return INTEGER;}
'*[0e()t'"n]'	{	yylval.ival = unescape_asterix(yytext[2]); return integer}

[ \n\t]	{}

%%
int	unescape_asterix(char c) {
	switch (c) {
		case '0':	return ('\0');
		case 'e':	return (EOT);
		case '(':	return ('{');
		case ')':	return ('}');
		case 't':	return ('\t');
		case '\'':	return ('\'');
		case '"':	return ('"');
		case 'n':	return ('\n');
		default:	{
			fprintf("Error escape *: '%c'(%d) Unkown escape", c, (int)c);
			return ('');
		}
	}
}

int yywrap(void) { return 1; }
