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

# define IN_COMMENT				(GET_BIT(parsData.flags, E_COMMENT))
# define RETURN_TRASH(token)	do {										\
									if (!IN_COMMENT)	\
										return (token);						\
								} while (0);



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
