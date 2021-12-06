%{
#include<stdio.h>

int regs[26];
int base;

%}

%start list

%token DIGIT LETTER IF THEN ELSE
%token GEQ LEQ EQ NOTEQ OR AND

%left '|'
%left '&'
%left '+' '-'
%left '*' '/' '%'
%left UMINUS  /*supplies precedence for unary minus */

%%                   /* beginning of rules section */

list:                       /*empty */
         |
        list stat '\n'
         |
        list error '\n' {yyerrok;}
         ;
stat:    expr {printf("%d\n",$1);}
         | IF '(' cond_expr ')' THEN expr';' {if($3){printf("%d\n",$6);}}
         | IF '(' cond_expr ')' THEN expr';' ELSE expr';' {if($3){printf("%d\n",$6);}else{printf("%d\n",$9);}}
         | LETTER {printf("letter\n");}
         ;

expr:    '(' expr ')'  {$$ = $2;}
         |
         expr '*' expr {$$ = $1 * $3; }
         |
         expr '/' expr {$$ = $1 / $3;}
         |
         expr '%' expr {$$ = $1 % $3;}
         |
         expr '+' expr {$$ = $1 + $3;}
         |
         expr '-' expr {$$ = $1 - $3;}
         |
         expr '&' expr {$$ = $1 & $3;}
         |
         expr '|' expr {$$ = $1 | $3;}
         |
        '-' expr %prec UMINUS {$$ = -$2;}
         |
         DIGIT
         ;
cond_expr: expr EQ expr  {$$ = $1 == $3;}
           |
           expr LEQ expr {$$ = $1 <= $3;}
           |
           expr GEQ expr {$$ = $1 >= $3;}
           |
           expr NOTEQ expr {$$ = $1 != $3;}
           |
           expr OR expr {$$ = $1 || $3;}
           |
           expr AND expr {$$ = $1 && $3;}
           ; 


%%
main()
{
 return(yyparse());
}

yyerror(s)
char *s;
{
  fprintf(stderr, "%s\n",s);
}

yywrap()
{
  return(1);
}