%{
	#include <ctype.h>
	#include "B_parser.h"
	#include "bCompiler.h"

	uint32_t	ft_charToI32(const char *str);
%}

%%

"auto"		{RETURN_COMMENT(AUTO);}
"extrn"	{RETURN_COMMENT(EXTERN);}

"goto"		{RETURN_COMMENT(GOTO);}

"while"		{RETURN_COMMENT(WHILE);}
"break"		{RETURN_COMMENT(BREAK);}
"continue"	{RETURN_COMMENT(CONTINUE);}

"switch"	{RETURN_COMMENT(SWITCH);}
"case"		{RETURN_COMMENT(CASE);}
"default"	{RETURN_COMMENT(DEFAULT);}


"if"		{RETURN_COMMENT(IF);}
"else"		{RETURN_COMMENT(ELSE);}

"return"	{RETURN_COMMENT(RETURN);}
"drop"		{RETURN_COMMENT(DROP);}

"++"		{RETURN_COMMENT(INC);}
"--"		{RETURN_COMMENT(DEC);}

"!"			{RETURN_COMMENT(NOT);}
"~"			{RETURN_COMMENT(TILDE);}

"<<"		{RETURN_COMMENT(L_SHIFT);}
">>"		{RETURN_COMMENT(R_SHIFT);}
"*"			{RETURN_COMMENT(MULT);}
"/"			{RETURN_COMMENT(DIV);}
"%"			{RETURN_COMMENT(MODULO);}
"+"			{RETURN_COMMENT(ADD);}
"-"			{RETURN_COMMENT(SUB);}
"|"			{RETURN_COMMENT(OR);}
"&"			{RETURN_COMMENT(AND);}
"^"			{RETURN_COMMENT(XOR);}
"=="		{RETURN_COMMENT(EQUAL);}
"!="		{RETURN_COMMENT(NOT_EQUAL);}
"<"			{RETURN_COMMENT(INF);}
"<="		{RETURN_COMMENT(INF_EQUAL);}
">"			{RETURN_COMMENT(SUP);}
">="		{RETURN_COMMENT(SUP_EQUAL);}

"="			{RETURN_COMMENT(ASSIGN);}
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

"++."		{RETURN_COMMENT(FLOAT_INC);}
"--."		{RETURN_COMMENT(FLOAT_DEC);}

"*."		{RETURN_COMMENT(FLOAT_MULT);}
"/."		{RETURN_COMMENT(FLOAT_DIV);}
"+."		{RETURN_COMMENT(FLOAT_ADD);}
"-."		{RETURN_COMMENT(FLOAT_SUB);}
"==."		{RETURN_COMMENT(FLOAT_EQUAL);}		// {RETURN_COMMENT(EQUAL);}
"!=."		{RETURN_COMMENT(FLOAT_NOT_EQUAL);}	// {RETURN_COMMENT(NOT_EQUAL);}
"<."		{RETURN_COMMENT(FLOAT_INF);}
"<=."		{RETURN_COMMENT(FLOAT_INF_EQUAL);}
">."		{RETURN_COMMENT(FLOAT_SUP);}
">=."		{RETURN_COMMENT(FLOAT_SUP_EQUAL);}

"=*."		{RETURN_COMMENT(FLOAT_ASSIGN_MULT);}
"=/."		{RETURN_COMMENT(FLOAT_ASSIGN_DIV);}
"=+."		{RETURN_COMMENT(FLOAT_ASSIGN_ADD);}
"=-."		{RETURN_COMMENT(FLOAT_ASSIGN_SUB);}
"===."		{RETURN_COMMENT(FLOAT_ASSIGN_EQUAL);}
"=!=."		{RETURN_COMMENT(FLOAT_ASSIGN_NOT_EQUAL);}
"=<."		{RETURN_COMMENT(FLOAT_ASSIGN_INF);}
"=<=."		{RETURN_COMMENT(FLOAT_ASSIGN_INF_EQUAL);}
"=>."		{RETURN_COMMENT(FLOAT_ASSIGN_SUP);}
"=>=."		{RETURN_COMMENT(FLOAT_ASSIGN_SUP_EQUAL);}

[A-Za-z_][A-Za-z0-9_]*		{ yylval.sval = strdup(yytext);		RETURN_COMMENT(NAME);}

0b[0-1]+		{	yylval.ival = strtol(yytext + 2, NULL, 2);	RETURN_COMMENT(INTEGER);}
0[0-7]+			{	yylval.ival = strtol(yytext + 1, NULL, 8);	RETURN_COMMENT(INTEGER);}	// Mdr 09 c est 011 les enculer trkl a pars en fait, comme b10 mais * 8 au lieu de * 10
0x[0-9a-fA-F]+	{	yylval.ival = strtol(yytext + 2, NULL, 16);	RETURN_COMMENT(INTEGER);}
[0-9]+			{	yylval.ival = strtol(yytext, NULL, 10);		RETURN_COMMENT(INTEGER);}
[0-9]+\.[0-9]+?	{	yylval.fval = strtod(yytext, NULL);			RETURN_COMMENT(FLOAT);} // 3.   1.e6   5.982e-4

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
	yylval.ival = ft_charToI32(yytext);
	RETURN_COMMENT(INTEGER);
}

\"(\\([abetnvfr\\'\"?]{1}|[0-7]{1,3}|x[0-9a-fA-F]{1,2})|[^\\\"])*\"	{
	RETURN_COMMENT(STRING);
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
# 	error "TF ARE WE DOING NO LSB NO MSB ?"
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
