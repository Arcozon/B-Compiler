#include <stdarg.h>
#include "bCompiler.h"

static e_section	currSection = SCT_NONE;

static inline
void	_annonceSection(const e_section nSection) {
	static const char *sctStr[] = {"text", "data", "bss"};

	if (nSection == SCT_NONE || nSection > SCT_MAX) {
		exit(255);
	} 
	else if (nSection != currSection) {
		currSection = nSection;
		printf("section .%s\n", sctStr[nSection - SCT_TEXT]);
	}
}

static inline void	_writeToSection(const e_section _nSection, const char _format[], va_list vp) {
	_annonceSection(_nSection);
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
	_writeToSection(SCT_DATA, _format, vp);
	va_end(vp);
}

__attribute__((format(printf, 1, 2)))
void	writeBss(const char _format[], ...) {
	va_list	 vp;
	va_start(vp, _format);
	_writeToSection(SCT_BSS, _format, vp);
	va_end(vp);
}
