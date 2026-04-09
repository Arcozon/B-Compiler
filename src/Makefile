NAME = B

Y_SRC = B_parser.y
L_SRC = B_lexer.l
# C_SRC = $(Y_SRC:.y=.c) $(L_SRC:.l=.c)
C_SRC = y.tab.c  lex.yy.c

RM = rm -rf

all: $(NAME)

$(NAME): $(C_SRC) 
	cc $^ -o $@

y.tab.c: $(Y_SRC)
	yacc -d $^

lex.yy.c: $(L_SRC)
	lex $^


clean:
	$(RM) $(C_SRC) y.tab.h

fclean:
	$(RM) $(NAME)
