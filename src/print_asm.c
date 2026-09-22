#include "bCompiler.h"

void	_annonceSection(void) {
	const e_section sct = parsData.section;
	static const char *sctStr[] = {"text", "data", "bss"};

	if (sct == SCT_NONE || sct > SCT_MAX) {
		exit(255);
	}
	printf("section .%s\n", sctStr[sct - SCT_TEXT]);
}

//__attribute__((format(printf(2, 3))))
static inline void	_writeToSection(const e_section _nSection, const char _format[], va_list vp) {
	if (_nSection != parsData.section) {
		parsData.section = _nSection;
		_annonceSection();
	}
	vprintf(_format, vp);
}

__attribute__((format(printf, 1, 2)))
void	writeText(const char _format[], ...) {
	va_list	 vp;
	va_start(vp, _format);
	_writeToSection(SCT_TEXT, _format, vp);
	va_end(vp);
}

__attribute__((format(printf, 1, 2)))
void	writeData(const char _format[], ...) {
	va_list	 vp;
	va_start(vp, _format);
	_writeToSection(SCT_TEXT, _format, vp);
	va_end(vp);
}

__attribute__((format(printf, 1, 2)))
void	writeBss(const char _format[], ...) {
	va_list	 vp;
	va_start(vp, _format);
	_writeToSection(SCT_TEXT, _format, vp);
	va_end(vp);
}
