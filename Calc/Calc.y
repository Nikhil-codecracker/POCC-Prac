%{
#include<stdio.h>

int regs[26];
int base;

%}

%start list

%token NUMBER

%left '|'
%left '&'
%left '+' '-'
%left '*' '/' '%'

%%                   

list:                      
         |
        list stat '\n'
         |
        list error '\n' {yyerrok;}
         ;
stat:    expr {printf("%d\n",$1);}
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
         NUMBER
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