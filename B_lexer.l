%{
	#include "y.tab.h"
}%

%%

"auto"
"extern"

"++"
"--"

"|"
"&"

"=="
"!="
"<"
"<="
">"
">="
"<<"
">>"
"+"
"-"
"%"
"*"
"/"

"!"


0b[0-1]+		{printf("Binary Number\n");	return NUMBER;}
0[0-7]+			{printf("Octal Number\n");	return NUMBER;}
0x[0-9a-fA-F]+	{printf("Hex Number\n");	return NUMBER;}
[0-9]+			{printf("Decimal Number\n");return NUMBER;}
[0-9]+\.[0-9]+?	{printf("Float Number\n");	return NUMBER;}

[A-Za-z_][A-Za-z0-9_]+					{return NAME;}

// do comments
%%
