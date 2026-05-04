%{
	#include <ctype.h>
	#include "B_parser.h"
	#include "var_type.h"

	uint32_t	ft_charToI32(const char *str);
	#define DEBUG(str, ...)	{ fprintf(stderr, str, ##__VA_ARGS__); fprintf(stderr, "\n"); }
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

"return"	{return RETURN;}
"give"		{return GIVE;}

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
"=/"		{return ASSIGN_DIV;}
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

"++."		{return FLOAT_INC;}
"--."		{return FLOAT_DEC;}

"*."		{return FLOAT_MULT;}
"/."		{return FLOAT_DIV;}
"+."		{return FLOAT_ADD;}
"-."		{return FLOAT_SUB;}
"==."		{return FLOAT_EQUAL;}		// {return EQUAL;}
"!=."		{return FLOAT_NOT_EQUAL;}	// {return NOT_EQUAL;}
"<."		{return FLOAT_INF;}
"<=."		{return FLOAT_INF_EQUAL;}
">."		{return FLOAT_SUP;}
">=."		{return FLOAT_SUP_EQUAL;}

"=*."		{return FLOAT_ASSIGN_MULT;}
"=/."		{return FLOAT_ASSIGN_DIV;}
"=+."		{return FLOAT_ASSIGN_ADD;}
"=-."		{return FLOAT_ASSIGN_SUB;}
"===."		{return FLOAT_ASSIGN_EQUAL;}
"=!=."		{return FLOAT_ASSIGN_NOT_EQUAL;}
"=<."		{return FLOAT_ASSIGN_INF;}
"=<=."		{return FLOAT_ASSIGN_INF_EQUAL;}
"=>."		{return FLOAT_ASSIGN_SUP;}
"=>=."		{return FLOAT_ASSIGN_SUP_EQUAL;}

[A-Za-z_][A-Za-z0-9_]*		{ yylval.sval = strdup(yytext);		return NAME;}

0b[0-1]+		{	yylval.ival = strtol(yytext + 2, NULL, 2);	return INTEGER;}
0[0-7]+			{	yylval.ival = strtol(yytext + 1, NULL, 8);	return INTEGER;}
0x[0-9a-fA-F]+	{	yylval.ival = strtol(yytext + 2, NULL, 16);	return INTEGER;}
[0-9]+			{	yylval.ival = strtol(yytext, NULL, 10);		return INTEGER;}
[0-9]+\.[0-9]+?	{	yylval.fval = strtod(yytext, NULL);			return FLOAT;} // 3.   1.e6   5.982e-4


'(\\([abetnvfr\\'"?]{1}|[0-7]{1,3}|x[0-9a-fA-F]{1,2})|[^\\']){1,4}'		{	yylval.ival = ft_charToI32(yytext); return INTEGER;} // Char

\"(\\([abetnvfr\\'\"?]{1}|[0-7]{1,3}|x[0-9a-fA-F]{1,2})|[^\\\"])*\"		{	return STRING;} // Char



\/\*				{printf("Multiline comment start\n"); return MULT_LINE_CMT_START;}; // Mulit line Commemts
*\/					{printf("Multiline comment end\n"); return MULT_LINE_CMT_END;}; // Mulit line Commemts
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
