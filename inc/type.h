#ifndef B_COMP_TYPE_H
# define B_COMP_TYPE_H

# include <stdint.h>
# include <stddef.h>

typedef struct sstr_s sstr_t;
struct sstr_s {
	char		**sstr;
	uint64_t	len;
};

#endif
