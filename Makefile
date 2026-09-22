NAME = B

YACC_Y	 =  B_parser.y
LEX_L	 =  B_lexer.l

S_SRC	 =  lex_constant.c
S_YACC	 =  $(addprefix $(D_SRC), $(YACC_Y:.y=.c))
S_LEX	 =  $(addprefix $(D_SRC), $(LEX_L:.l=.c))
D_SRC	 =  src/
SRC		 =  $(addprefix $(D_SRC), $(S_SRC))  $(S_YACC)  $(S_LEX)

OBJ		 =  $(patsubst $(D_SRC)%.c, $(D_OBJ)%.o, $(SRC))
D_OBJ	 =  .build/

INC_GEN	 =  $(S_YACC:.c=.h)
D_INC	 =  inc/

RM = rm -rf

YACC	=  bison -d #-Wother -Wconflicts-rr -Wconflicts-sr -Wcounterexamples 
LEX	=  flex

CC	   = cc
CFLAGS = -Wall -Wextra -Werror -Wno-unused-function
IFLAGS = $(addprefix -I, $(D_INC) $(D_SRC))

# print:
# 	@echo $(OBJ)

all: $(NAME)
#	./$(NAME)

$(NAME):	$(OBJ)
	$(CC) $(CFLAGS) $^ -o$@

$(S_YACC): $(D_SRC)$(YACC_Y)
	$(YACC) -o$@ -- $<

$(S_LEC): $(D_SRC)$(S_LEX) $(INC_GEN)
	$(LEX) -o$@ $<

$(OBJ):	$(D_OBJ)%.o:	$(D_SRC)%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) $(IFLAGS) -c $< -o$@

clean:
	$(RM) $(D_GEN)

fclean:	clean
	$(RM) $(NAME)

re:	fclean
	@clear
	@$(MAKE) --no-print-directory all

.PHONY:	re fclean all clean
