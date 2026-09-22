%{
	#include <ctype.h>
	#include ".B_parser.h"
	#include "bCompiler.h"
%}

%%

"auto"		{RETURN_COMMENT(AUTO);}
"extrn"		{RETURN_COMMENT(EXTERN);}

"goto"		{RETURN_COMMENT(GOTO);}

"while"		{RETURN_COMMENT(WHILE);}
"break"		{RETURN_COMMENT(BREAK);}
"continue"	{RETURN_COMMENT(CONTINUE);}
"next"		{RETURN_COMMENT(CONTINUE);}

"switch"	{RETURN_COMMENT(SWITCH);}
"case"		{RETURN_COMMENT(CASE);}
"default"	{RETURN_COMMENT(DEFAULT);}


"if"		{RETURN_COMMENT(IF);}
"else"		{RETURN_COMMENT(ELSE);}

"pick"		{RETURN_COMMENT(PICK);}
"drop"		{RETURN_COMMENT(DROP);}

"return"	{RETURN_COMMENT(RETURN);}

"++"		{RETURN_COMMENT(INC);}
"--"		{RETURN_COMMENT(DEC);}

"!"		{RETURN_COMMENT(NOT);}
"~"		{RETURN_COMMENT(TILDE);}

"#"		{RETURN_COMMENT(INT_TO_FLOAT)};
"##"		{RETURN_COMMENT(FLOAT_TO_INT)};

"&&"		{RETURN_COMMENT(LOGICAL_AND);}
"||"		{RETURN_COMMENT(LOGICAL_OR);}

"<<"		{RETURN_COMMENT(L_SHIFT);}
">>"		{RETURN_COMMENT(R_SHIFT);}
"*"		{RETURN_COMMENT(MULT);}
"/"		{RETURN_COMMENT(DIV);}
"%"		{RETURN_COMMENT(MODULO);}
"+"		{RETURN_COMMENT(ADD);}
"-"		{RETURN_COMMENT(SUB);} 
"|"		{RETURN_COMMENT(OR);}
"&"		{RETURN_COMMENT(AND);}
"^"		{RETURN_COMMENT(XOR);}
"=="		{RETURN_COMMENT(EQUAL);}
"!="		{RETURN_COMMENT(NOT_EQUAL);}
"<"		{RETURN_COMMENT(INF);}
"<="		{RETURN_COMMENT(INF_EQUAL);}
">"		{RETURN_COMMENT(SUP);}
">="		{RETURN_COMMENT(SUP_EQUAL);}

"="		{RETURN_COMMENT(ASSIGN);}
"=<<"		{RETURN_COMMENT(ASSIGN_L_SHIFT);}
"=>>"		{RETURN_COMMENT(ASSIGN_R_SHIFT);}
"=*"		{RETURN_COMMENT(ASSIGN_MULT);}
"=/"		{RETURN_COMMENT(ASSIGN_DIV);}
"=%"		{RETURN_COMMENT(ASSIGN_MODULO);}
"=+"		{RETURN_COMMENT(ASSIGN_ADD);}
"=-"		{RETURN_COMMENT(ASSIGN_SUB);}
"=|"		{RETURN_COMMENT(ASSIGN_OR);}
"=&"		{RETURN_COMMENT(ASSIGN_AND);}
"=^"		{RETURN_COMMENT(ASSIGN_XOR);}
"==="		{RETURN_COMMENT(ASSIGN_EQUAL);}
"=!="		{RETURN_COMMENT(ASSIGN_NOT_EQUAL);}
"=<"		{RETURN_COMMENT(ASSIGN_INF);}
"=<="		{RETURN_COMMENT(ASSIGN_INF_EQUAL);}
"=>"		{RETURN_COMMENT(ASSIGN_SUP);}
"=>="		{RETURN_COMMENT(ASSIGN_SUP_EQUAL);}

"#++"		{RETURN_COMMENT(FLOAT_INC);}
"#--"		{RETURN_COMMENT(FLOAT_DEC);}

"#*"		{RETURN_COMMENT(FLOAT_MULT);}
"#/"		{RETURN_COMMENT(FLOAT_DIV);}
"#+"		{RETURN_COMMENT(FLOAT_ADD);}
"#-"		{RETURN_COMMENT(FLOAT_SUB);}
"#=="		{RETURN_COMMENT(FLOAT_EQUAL);}		// {RETURN_COMMENT(EQUAL);}
"#!="		{RETURN_COMMENT(FLOAT_NOT_EQUAL);}	// {RETURN_COMMENT(NOT_EQUAL);}
"#<"		{RETURN_COMMENT(FLOAT_INF);}
"#<="		{RETURN_COMMENT(FLOAT_INF_EQUAL);}
"#>"		{RETURN_COMMENT(FLOAT_SUP);}
"#>="		{RETURN_COMMENT(FLOAT_SUP_EQUAL);}

"=#*"		{RETURN_COMMENT(FLOAT_ASSIGN_MULT);}
"=#/"		{RETURN_COMMENT(FLOAT_ASSIGN_DIV);}
"=#+"		{RETURN_COMMENT(FLOAT_ASSIGN_ADD);}
"=#-"		{RETURN_COMMENT(FLOAT_ASSIGN_SUB);}
"=#=="		{RETURN_COMMENT(FLOAT_ASSIGN_EQUAL);}
"=#!="		{RETURN_COMMENT(FLOAT_ASSIGN_NOT_EQUAL);}
"=#<"		{RETURN_COMMENT(FLOAT_ASSIGN_INF);}
"=#<="		{RETURN_COMMENT(FLOAT_ASSIGN_INF_EQUAL);}
"=#>"		{RETURN_COMMENT(FLOAT_ASSIGN_SUP);}
"=#>="		{RETURN_COMMENT(FLOAT_ASSIGN_SUP_EQUAL);}

[A-Za-z_][A-Za-z0-9_]*		{ yylval.strval = strdup(yytext);		RETURN_COMMENT(NAME);}

0b[0-1]+		{	yylval.intval = strtol(yytext + 2, NULL, 2);	RETURN_COMMENT(INTEGER);}
0[0-9]+			{	yylval.intval = lex_octToInt(yytext+ 1);		RETURN_COMMENT(INTEGER);}	// Mdr 09 c est 011 les enculer trkl a pars en fait, comme b10 mais * 8 au lieu de * 10
0x[0-9a-fA-F]+		{	yylval.intval = strtol(yytext + 2, NULL, 16);	RETURN_COMMENT(INTEGER);}
[0-9]+			{	yylval.intval = strtol(yytext, NULL, 10);		RETURN_COMMENT(INTEGER);}
[0-9]+\.[0-9]+?		{	yylval.floatval = strtod(yytext, NULL);		RETURN_COMMENT(FLOAT);} // 3.   1.e6   5.982e-4

";" 	{RETURN_COMMENT(';');}
"," 	{RETURN_COMMENT(',');}
"?" 	{RETURN_COMMENT('?');}
":" 	{RETURN_COMMENT(':');}
"{" 	{RETURN_COMMENT('{');}
"}" 	{RETURN_COMMENT('}');}
"[" 	{RETURN_COMMENT('[');}
"]" 	{RETURN_COMMENT(']');}
"(" 	{RETURN_COMMENT('(');}
")" 	{RETURN_COMMENT(')');}

'(\\([abetnvfr\\'"?]{1}|[0-7]{1,3}|x[0-9a-fA-F]{1,2})|[^\\']){1,4}'	 {	// Char
	yylval.intval = lex_charToI32(yytext);
	RETURN_COMMENT(INTEGER);
}

\"(\\([abetnvfr\\'\"?]{1}|[0-7]{1,3}|x[0-9a-fA-F]{1,2})|[^\\\"])*\"	{
	RETURN_COMMENT(STRING);
	// TODO: Pars sring
}

\/\*	{	 // Multi line Comment Start
	SET_BIT(parsData.flags, E_COMMENT);
}

\*\/	{	 // Multi line Comment End
	if (!IN_COMMENT) {
		yyerror("Comment end mark with comment start\n");
		return (MULTI_LINE_CMT_END);
	} else {
		UNSET_BIT(parsData.flags, E_COMMENT);
	}
}

\/\/.*			{DEBUG("Simple line comment");}; // Simple line cmd


[ \n\t]	{}

.	{RETURN_COMMENT(ERROR);}

%%

int yywrap(void) { return 1; }
