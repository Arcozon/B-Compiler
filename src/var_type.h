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

#ifndef VAR_TYPE_H
# define VAR_TYPE_H

// # include <stddef.h>
# include <stdint.h>

typedef struct y_type	y_type;
struct y_type {
	enum {
		T_INT,
		T_FLOAT,
		T_STR,
		T_PTR
	}	type;
	union {
		uint32_t	rdata;
		int32_t		idata;
		float	fdata;
		char	*sdata;
		void	*pdata;
	};
};

#endif
