/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   var_type.h                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gaeudes <gaeudes@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/04/10 12:15:32 by gaeudes           #+#    #+#             */
/*   Updated: 2026/04/10 12:23:01 by gaeudes          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef BCOMPILER_H
# define BCOMPILER_H

# include <stdio.h>
# include <stdlib.h>
# include <stdarg.h>

# include "binaryOperation.h"
# include "type.h"

# define BOLD	"\e[1m"
# define ITALIC	"\e[13m"
# define RED	"\e[31m"
# define BLUE	"\e[34m"
# define GREEN	"\e[32m"
# define CYAN	"\e[36m"
# define YELLOW	"\e[33m"
# define MAGENTA	"\e[35m"
# define RESET	"\e[0m"

# define IN_COMMENT				(GET_BIT(parsData.flags, E_COMMENT))
# define RETURN_COMMENT(token)	do {									\
									if (!IN_COMMENT) {					\
									/*	DEBUG(GREEN BOLD "%s" RESET" ["ITALIC BLUE"%.10s" RESET "]"RESET, #token, yytext);	*/\
										return (token);					\
									}									\
								} while (0);

# define DEBUG(str, ...)	{ fprintf(stderr, str, ##__VA_ARGS__); fprintf(stderr, "\n"); }


// typedef struct {
//	// Var locales
//	// Var extern
//	// Labels
// 	uint32_t	hash;
// 	uint32_t	nArg;
// }	fnc_t;

enum {
	E_COMMENT,
};
typedef enum {
	SCT_NONE,
	SCT_TEXT,
	SCT_DATA,
	SCT_BSS,
	SCT_MAX = SCT_BSS
}	e_section;

typedef struct {
	// fnc
	// globals

	// stack ?
	// locals ?
	uint64_t	flags;
	e_section	section;
}	data_t;

extern data_t	parsData;

void	yyerror(const char s[]);
int	yylex(void);

void	writeText(const char _format[], ...)	__attribute__((format(printf, 1, 2)));
void	writeData(const char _format[], ...)	__attribute__((format(printf, 1, 2)));
void	writeBss(const char _format[], ...)	__attribute__((format(printf, 1, 2)));

#endif
