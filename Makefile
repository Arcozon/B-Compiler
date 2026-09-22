NAME = B

YACC_Y	 =  B_parser.y
LEX_L	 =  B_lexer.l

S_SRC	 =  lex_constant.c  print_asm.c
S_YACC	 =  $(addprefix $(D_SRC), $(YACC_Y:.y=.c))
S_LEX	 =  $(addprefix $(D_SRC), $(LEX_L:.l=.c))
D_SRC	 =  src/
SRC		 =  $(addprefix $(D_SRC), $(S_SRC))  $(S_YACC)  $(S_LEX)

OBJ		 =  $(patsubst $(D_SRC)%.c, $(D_OBJ)%.o, $(SRC))
D_OBJ	 =  .build/

INC_YACC =  $(S_YACC:.c=.h)
D_INC	 =  inc/

RM = rm -rf

YACC	=  bison -d #-Wother -Wconflicts-rr -Wconflicts-sr -Wcounterexamples 
LEX	=  flex

CC	   = cc
CFLAGS = -Wall -Wextra -Werror -Wno-unused-function
IFLAGS = $(addprefix -I, $(D_INC) $(dir $(INC_YACC)))

$(MAKE)	+= --no-print-directory
.DEFAULT_GOAL = all
.DEFAULT_GOAL = test_syntax

all: $(NAME)

test_syntax:	$(NAME)
	@./testSyntax.sh

$(NAME):	$(OBJ)
	$(CC) $(CFLAGS) $^ -o$@

$(S_YACC): $(D_SRC)$(YACC_Y)
	$(YACC) -o$@ -- $<

$(S_LEC): $(D_SRC)$(S_LEX) $(INC_YACC)
	$(LEX) -o$@ $<

$(OBJ):	$(D_OBJ)%.o:	$(D_SRC)%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) $(IFLAGS) -c $< -o$@

clean:
	$(RM) $(D_OBJ)  $(S_YACC)  $(S_LEX)  $(INC_YACC)

fclean:	clean
	$(RM) $(NAME)

re:	fclean
	@clear
	@$(MAKE) all

.PHONY:	re fclean all clean
