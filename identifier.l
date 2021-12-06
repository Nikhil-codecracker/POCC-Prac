%{
    #include<stdio.h>
    #include<string.h>
    int c=0;
%} 

%%

int|char|if|else|for|while|double|static|float|switch|do|case|default|long|break|continue|return|struct     {printf("Keyword %s\n\n",yytext);}

"<="|"=="|"="|">="|"++"|"+"|"-"|"*"|"--"|"|"|"%"    {printf("Operator %s\n\n",yytext);}

[a-zA-Z_][a-zA-Z0-9_]*  {c++;printf("Identifier %s \n\n",yytext);}

[$|#|&|!|\\|/|?|~]  {printf("Special Character %s\n\n",yytext);}

[$|#|&|!|\\|/|?|~]+[a-z A-Z _][a-z A-Z 0-9 _]*  {printf("Invalid identifier %s\n\n",yytext);}

[0-9]+[a-zA-Z_][a-zA-Z0-9_]*     {printf("Invalid identifier %s\n\n",yytext);}

[" "]+ {}

[0-9]+"."[0-9]+     {printf("Float %s\n\n",yytext);}

[0-9]+  {printf("Integer %s\n\n",yytext);}

%%

int yywrap(){}
int main(){ 

    yylex();
    return 0;
}
