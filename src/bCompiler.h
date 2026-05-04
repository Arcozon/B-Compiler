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
# include <stdint.h>

# include "binaryOperation.h"

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
# define RETURN_TRASH(token)	do {									\
									if (!IN_COMMENT) {					\
										DEBUG(GREEN BOLD "%s" RESET" ["ITALIC BLUE"%.10s" RESET "]"RESET, #token, yytext);	\
										return (token);					\
									}									\
								} while (0);

# define DEBUG(str, ...)	{ fprintf(stderr, str, ##__VA_ARGS__); fprintf(stderr, "\n"); }



// typedef struct {
// 	char		fName[];
//	// Var locales
//	// Var extern
// 	uint32_t	hash;
// 	uint32_t	nArg;
// }	fnc_t;

enum {
	E_COMMENT,
};

typedef struct {
	// fnc
	// labels
	// globals
	// stack ?
	// locals ?
	uint64_t	flags;
}	data_t;

extern data_t	parsData;

void	yyerror(const char s[]);
int		yylex(void);


#endif
