NAME = B

D_SRC	 =  src/
YACC_SRC =  B_parser.y
LEX_SRC	 =  B_lexer.l

D_GEN	   =  gen/
YACC_C_GEN =  $(D_GEN)$(YACC_SRC:.y=.c)
LEX_C_GEN  =  $(D_GEN)$(LEX_SRC:.l=.c)
C_GEN	   = 


RM = rm -rf

YACC	=  bison -d -Wcounterexamples -Wconflicts-rr -Wconflicts-sr
LEX	=  flex

all: $(NAME)

$(NAME):	$(YACC_C_GEN)	$(LEX_C_GEN)
	cc $^ -o $@

$(YACC_C_GEN): $(D_SRC)$(YACC_SRC)	| $(D_GEN)
	 $(YACC) -o$@ -- $<

$(LEX_C_GEN): $(D_SRC)$(LEX_SRC)	| $(D_GEN)
	$(LEX) -o$@

$(D_GEN):
	mkdir -p $@

clean:
	$(RM) $(D_GEN)

fclean:	clean
	$(RM) $(NAME)

re:	fclean
	$(MAKE) --no-print-directory all

.PHONY:	re fclean all clean
