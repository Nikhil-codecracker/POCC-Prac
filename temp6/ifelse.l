%{

#include <stdio.h>
#include "y.tab.h"
int c;
%}
%%
" "       ;
"if"        {return IF;}
"then"      {return THEN;}
"else"      {return ELSE;}
[a-z]     {
            return(LETTER);
          }
[0-9]+     {
            yylval = atoi(yytext);
            return(DIGIT);
          }
[^a-z0-9\b]    {
                 c = yytext[0];
                 return(c);
              }
"<="        {return LEQ;}
">="        {return GEQ;}
"=="        {return EQ;}
"!="        {return NOTEQ;}
"||"        {return OR;}
"&&"        {return AND;}

%%