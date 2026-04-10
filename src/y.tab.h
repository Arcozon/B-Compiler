/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    INTEGER = 258,                 /* INTEGER  */
    STRING = 259,                  /* STRING  */
    CHAR = 260,                    /* CHAR  */
    FLOAT = 261,                   /* FLOAT  */
    NAME = 262,                    /* NAME  */
    AUTO = 263,                    /* AUTO  */
    EXTERN = 264,                  /* EXTERN  */
    IF = 265,                      /* IF  */
    ELSE = 266,                    /* ELSE  */
    WHILE = 267,                   /* WHILE  */
    SWITCH = 268,                  /* SWITCH  */
    CASE = 269,                    /* CASE  */
    GOTO = 270,                    /* GOTO  */
    RETURN = 271,                  /* RETURN  */
    INC = 272,                     /* INC  */
    DEC = 273,                     /* DEC  */
    ASSIGN = 274,                  /* ASSIGN  */
    ASSIGN_L_SHIFT = 275,          /* ASSIGN_L_SHIFT  */
    ASSIGN_R_SHIFT = 276,          /* ASSIGN_R_SHIFT  */
    ASSIGN_MULT = 277,             /* ASSIGN_MULT  */
    ASSIGN_DIV = 278,              /* ASSIGN_DIV  */
    ASSIGN_MODULO = 279,           /* ASSIGN_MODULO  */
    ASSIGN_ADD = 280,              /* ASSIGN_ADD  */
    ASSIGN_SUB = 281,              /* ASSIGN_SUB  */
    ASSIGN_OR = 282,               /* ASSIGN_OR  */
    ASSIGN_AND = 283,              /* ASSIGN_AND  */
    ASSIGN_XOR = 284,              /* ASSIGN_XOR  */
    ASSIGN_EQUAL = 285,            /* ASSIGN_EQUAL  */
    ASSIGN_NOT_EQUAL = 286,        /* ASSIGN_NOT_EQUAL  */
    ASSIGN_INF = 287,              /* ASSIGN_INF  */
    ASSIGN_INF_EQUAL = 288,        /* ASSIGN_INF_EQUAL  */
    ASSIGN_SUP = 289,              /* ASSIGN_SUP  */
    ASSIGN_SUP_EQUAL = 290,        /* ASSIGN_SUP_EQUAL  */
    OR = 291,                      /* OR  */
    AND = 292,                     /* AND  */
    XOR = 293,                     /* XOR  */
    EQUAL = 294,                   /* EQUAL  */
    NOT_EQUAL = 295,               /* NOT_EQUAL  */
    INF = 296,                     /* INF  */
    INF_EQUAL = 297,               /* INF_EQUAL  */
    SUP = 298,                     /* SUP  */
    SUP_EQUAL = 299,               /* SUP_EQUAL  */
    L_SHIFT = 300,                 /* L_SHIFT  */
    R_SHIFT = 301,                 /* R_SHIFT  */
    ADD = 302,                     /* ADD  */
    SUB = 303,                     /* SUB  */
    MULT = 304,                    /* MULT  */
    DIV = 305,                     /* DIV  */
    MODULO = 306,                  /* MODULO  */
    POST_INC_DEC = 307,            /* POST_INC_DEC  */
    PRE_INC_DEC = 308,             /* PRE_INC_DEC  */
    NOT = 309,                     /* NOT  */
    TILDE = 310,                   /* TILDE  */
    DEREF = 311                    /* DEREF  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define INTEGER 258
#define STRING 259
#define CHAR 260
#define FLOAT 261
#define NAME 262
#define AUTO 263
#define EXTERN 264
#define IF 265
#define ELSE 266
#define WHILE 267
#define SWITCH 268
#define CASE 269
#define GOTO 270
#define RETURN 271
#define INC 272
#define DEC 273
#define ASSIGN 274
#define ASSIGN_L_SHIFT 275
#define ASSIGN_R_SHIFT 276
#define ASSIGN_MULT 277
#define ASSIGN_DIV 278
#define ASSIGN_MODULO 279
#define ASSIGN_ADD 280
#define ASSIGN_SUB 281
#define ASSIGN_OR 282
#define ASSIGN_AND 283
#define ASSIGN_XOR 284
#define ASSIGN_EQUAL 285
#define ASSIGN_NOT_EQUAL 286
#define ASSIGN_INF 287
#define ASSIGN_INF_EQUAL 288
#define ASSIGN_SUP 289
#define ASSIGN_SUP_EQUAL 290
#define OR 291
#define AND 292
#define XOR 293
#define EQUAL 294
#define NOT_EQUAL 295
#define INF 296
#define INF_EQUAL 297
#define SUP 298
#define SUP_EQUAL 299
#define L_SHIFT 300
#define R_SHIFT 301
#define ADD 302
#define SUB 303
#define MULT 304
#define DIV 305
#define MODULO 306
#define POST_INC_DEC 307
#define PRE_INC_DEC 308
#define NOT 309
#define TILDE 310
#define DEREF 311

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 9 "B_parser.y"

	int		ival;
	float	fval;
	char	*sval;

#line 185 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
