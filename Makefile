NAME = B

D_SRC	 =  src/
YACC_SRC =  B_parser.y
LEX_SRC	 =  B_lexer.l

D_GEN	   =  gen/
YACC_C_GEN =  $(D_GEN)$(YACC_SRC:.y=.c)
LEX_C_GEN  =  $(D_GEN)$(LEX_SRC:.l=.c)
INC_GEN	   =  $(YACC_C_GEN:.c=.h) 


RM = rm -rf

YACC	=  bison -d
# YACC	=  bison -d -Wcounterexamples -Wconflicts-rr -Wconflicts-sr
LEX	=  flex

all: $(NAME)
	./$(NAME)

$(NAME):	$(YACC_C_GEN)	$(LEX_C_GEN)
	cc $^ -I$(D_GEN) -I$(D_SRC) -o $@

$(YACC_C_GEN): $(D_SRC)$(YACC_SRC)
	@mkdir -p $(@D)
	 $(YACC) -o$@ -- $<

$(LEX_C_GEN): $(D_SRC)$(LEX_SRC) $(INC_GEN)
	@mkdir -p $(@D)
	$(LEX) -o$@ $<

clean:
	$(RM) $(D_GEN)

fclean:	clean
	$(RM) $(NAME)

re:	fclean
	@clear
	@$(MAKE) --no-print-directory all

.PHONY:	re fclean all clean
