#include "bCompiler.h"
#include ".B_parser.h"


static const char	_baseOct[] = "0123456789"; 
static const char	_baseHex[] = "0123456789abcdef";

uint32_t	lex_octToInt(const char *_str) {
	const char	*index = strchr(_baseOct, _str[0]);
	uint32_t	res = 0;

	for (uint8_t j = 0; (index != NULL) && _str[j]; ++j) {
		res *= 8;
		res += (index - _baseOct);
		index = strchr(_baseOct, _str[j + 1]);
	}
	//DEBUG("\nOct: %d\n", res);
	return (res);
}

uint32_t	lex_charToI32(const char *_strQuote) {

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
				res *= 8;
				res += (index - _baseOct);
				++s;

				index = strchr(_baseOct, *s);
			}
		//	DEBUG("\nOct: %d\n", res);
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
# endif
		res <<= 8;
		res |= i32[i];
	}
//	DEBUG("%u", res);
	return (res);
}
