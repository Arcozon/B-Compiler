%{
	#include <ctype.h>
	#include "B_parser.h"
	#include "bCompiler.h"

	uint32_t	ft_charToI32(const char *str);
	#define DEBUG(str, ...)	{ fprintf(stderr, str, ##__VA_ARGS__); fprintf(stderr, "\n"); }
%}

%%

"auto"		{RETURN_TRASH(AUTO);}
"extern"	{RETURN_TRASH(EXTERN);}

"goto"		{RETURN_TRASH(GOTO);}

"switch"	{RETURN_TRASH(SWITCH);}
"case"		{RETURN_TRASH(CASE);}

"while"		{RETURN_TRASH(WHILE);}

"if"		{RETURN_TRASH(IF);}
"else"		{RETURN_TRASH(ELSE);}

"return"	{RETURN_TRASH(RETURN);}
"give"		{RETURN_TRASH(GIVE);}

"++"		{RETURN_TRASH(INC);}
"--"		{RETURN_TRASH(DEC);}

"!"			{RETURN_TRASH(NOT);}
"~"			{RETURN_TRASH(TILDE);}

"<<"		{RETURN_TRASH(L_SHIFT);}
">>"		{RETURN_TRASH(R_SHIFT);}
"*"			{RETURN_TRASH(MULT);}
"/"			{RETURN_TRASH(DIV);}
"%"			{RETURN_TRASH(MODULO);}
"+"			{RETURN_TRASH(ADD);}
"-"			{RETURN_TRASH(SUB);}
"|"			{RETURN_TRASH(OR);}
"&"			{RETURN_TRASH(AND);}
"^"			{RETURN_TRASH(XOR);}
"=="		{RETURN_TRASH(EQUAL);}
"!="		{RETURN_TRASH(NOT_EQUAL);}
"<"			{RETURN_TRASH(INF);}
"<="		{RETURN_TRASH(INF_EQUAL);}
">"			{RETURN_TRASH(SUP);}
">="		{RETURN_TRASH(SUP_EQUAL);}

"="			{RETURN_TRASH(ASSIGN);}
"=<<"		{RETURN_TRASH(ASSIGN_L_SHIFT);}
"=>>"		{RETURN_TRASH(ASSIGN_R_SHIFT);}
"=*"		{RETURN_TRASH(ASSIGN_MULT);}
"=/"		{RETURN_TRASH(ASSIGN_DIV);}
"=%"		{RETURN_TRASH(ASSIGN_MODULO);}
"=+"		{RETURN_TRASH(ASSIGN_ADD);}
"=-"		{RETURN_TRASH(ASSIGN_SUB);}
"=|"		{RETURN_TRASH(ASSIGN_OR);}
"=&"		{RETURN_TRASH(ASSIGN_AND);}
"=^"		{RETURN_TRASH(ASSIGN_XOR);}
"==="		{RETURN_TRASH(ASSIGN_EQUAL);}
"=!="		{RETURN_TRASH(ASSIGN_NOT_EQUAL);}
"=<"		{RETURN_TRASH(ASSIGN_INF);}
"=<="		{RETURN_TRASH(ASSIGN_INF_EQUAL);}
"=>"		{RETURN_TRASH(ASSIGN_SUP);}
"=>="		{RETURN_TRASH(ASSIGN_SUP_EQUAL);}

"++."		{RETURN_TRASH(FLOAT_INC);}
"--."		{RETURN_TRASH(FLOAT_DEC);}

"*."		{RETURN_TRASH(FLOAT_MULT);}
"/."		{RETURN_TRASH(FLOAT_DIV);}
"+."		{RETURN_TRASH(FLOAT_ADD);}
"-."		{RETURN_TRASH(FLOAT_SUB);}
"==."		{RETURN_TRASH(FLOAT_EQUAL);}		// {RETURN_TRASH(EQUAL);}
"!=."		{RETURN_TRASH(FLOAT_NOT_EQUAL);}	// {RETURN_TRASH(NOT_EQUAL);}
"<."		{RETURN_TRASH(FLOAT_INF);}
"<=."		{RETURN_TRASH(FLOAT_INF_EQUAL);}
">."		{RETURN_TRASH(FLOAT_SUP);}
">=."		{RETURN_TRASH(FLOAT_SUP_EQUAL);}

"=*."		{RETURN_TRASH(FLOAT_ASSIGN_MULT);}
"=/."		{RETURN_TRASH(FLOAT_ASSIGN_DIV);}
"=+."		{RETURN_TRASH(FLOAT_ASSIGN_ADD);}
"=-."		{RETURN_TRASH(FLOAT_ASSIGN_SUB);}
"===."		{RETURN_TRASH(FLOAT_ASSIGN_EQUAL);}
"=!=."		{RETURN_TRASH(FLOAT_ASSIGN_NOT_EQUAL);}
"=<."		{RETURN_TRASH(FLOAT_ASSIGN_INF);}
"=<=."		{RETURN_TRASH(FLOAT_ASSIGN_INF_EQUAL);}
"=>."		{RETURN_TRASH(FLOAT_ASSIGN_SUP);}
"=>=."		{RETURN_TRASH(FLOAT_ASSIGN_SUP_EQUAL);}

[A-Za-z_][A-Za-z0-9_]*		{ yylval.sval = strdup(yytext);		RETURN_TRASH(NAME);}

0b[0-1]+		{	yylval.ival = strtol(yytext + 2, NULL, 2);	RETURN_TRASH(INTEGER);}
0[0-7]+			{	yylval.ival = strtol(yytext + 1, NULL, 8);	RETURN_TRASH(INTEGER);}
0x[0-9a-fA-F]+	{	yylval.ival = strtol(yytext + 2, NULL, 16);	RETURN_TRASH(INTEGER);}
[0-9]+			{	yylval.ival = strtol(yytext, NULL, 10);		RETURN_TRASH(INTEGER);}
[0-9]+\.[0-9]+?	{	yylval.fval = strtod(yytext, NULL);			RETURN_TRASH(FLOAT);} // 3.   1.e6   5.982e-4


'(\\([abetnvfr\\'"?]{1}|[0-7]{1,3}|x[0-9a-fA-F]{1,2})|[^\\']){1,4}'	 {	// Char
	yylval.ival = ft_charToI32(yytext);
	RETURN_TRASH(INTEGER);
}

\"(\\([abetnvfr\\'\"?]{1}|[0-7]{1,3}|x[0-9a-fA-F]{1,2})|[^\\\"])*\"	{
	RETURN_TRASH(STRING);
}

\/\*	{	 // Multi line Comment Start
	printf("Multiline comment start\n");
	// if (IN_COMMENT)
	// 	return (TRASH);
	SET_BIT(parsData.flags, E_COMMENT);
	// return(MULT_LINE_CMT_START);
}

\*\/	{	 // Multi line Comment End
	printf("Multiline comment end\n");
	if (!IN_COMMENT) {
		yyerror("Comment end mark with comment start\n");
	} else {
		UNSET_BIT(parsData.flags, E_COMMENT);
		// return (MULT_LINE_CMT_END);
	}
}

\/\/.*				{DEBUG("Simple line comment");}; // Simple line cmd

";" 	{return ';';}
"," 	{return ',';}
"?" 	{return '?';}
":" 	{return ':';}
"{" 	{return '{';}
"}" 	{return '}';}
"[" 	{return '[';}
"]" 	{return ']';}
"(" 	{return '(';}
")" 	{return ')';}

[ \n\t]	{}

%%
uint32_t	ft_charToI32(const char *_strQuote) {
	static const char	_baseOct[] = "01234567"; 
	static const char	_baseHex[] = "0123456789abcdef";

	const char	*strEnd = &_strQuote[strlen(_strQuote) - 1] - 1;
	uint8_t	i32[4] = {0, 0, 0, 0};
	uint8_t	iInt32 = 0;

		// DEBUG("s: [%s]", _strQuote)
	for (const char *s = _strQuote + 1; s <= strEnd; ++iInt32) {
		// DEBUG("s: [%c] %p", *s, s)
		if (*s != '\\') {
			i32[iInt32] = *s;
			++s;
			continue;
		}
		++s;
		if (strchr("abetnvfr\\'\"?", *s) != NULL) {
			switch (*s) {
				case 'a':	i32[iInt32] = '\a';	break;
				case 'b':	i32[iInt32] = '\b';	break;
				case 'e':	i32[iInt32] = '\e';	break;
				case 't':	i32[iInt32] = '\t';	break;
				case 'n':	i32[iInt32] = '\n';	break;
				case 'v':	i32[iInt32] = '\v';	break;
				case 'f':	i32[iInt32] = '\f';	break;
				case 'r':	i32[iInt32] = '\r';	break;
				case '\\':	i32[iInt32] = '\\';	break;
				case '\'':	i32[iInt32] = '\'';	break;
				case '\"':	i32[iInt32] = '\"';	break;
				case '?':	i32[iInt32] = '\?';	break;
			}
			++s;
			continue;
		} if (*s != 'x') {
			const char	*index = strchr(_baseOct, *s);
			uint8_t		res = 0;

			for (uint8_t j = 0; (j < 3) && (index != NULL); ++j) {
				res <<= 3;
				res += (index - _baseOct);
				++s;

				index = strchr(_baseOct, *s);
			}
			i32[iInt32] = res;
			continue;
		} else {
			++s;
			const char	*index = strchr(_baseHex, tolower(*s));
			uint8_t		res = 0;

			for (uint8_t j = 0; (j < 2) && (index != NULL); ++j) {
				res <<= 4;
				res += (index - _baseHex);
				++s;
				index = strchr(_baseHex, tolower(*s));
			}
			i32[iInt32] = res;
			continue;
		}
		DEBUG("Que faije la char ");
	}
	uint32_t	res = 0;
# if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
	for (int8_t i = 0; i <= 3; ++i) {
# elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
	for (int8_t i = 3; i >= 0; --i) {
# else
# 	error "TF ARE WE DOING"
	{	int	i = 0;
		yyerror("Pas cool ducoup on est NI LSB NI MSB ????\n");
# endif
		res <<= 8;
		res |= i32[i];
	}
	DEBUG("%u", res);
	return (res);
}


int yywrap(void) { return 1; }
