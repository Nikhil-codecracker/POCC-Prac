%{

#include <stdio.h>
#include "y.tab.h"
int c;
%}
%%
" "       ;
[0-9]+     {
            yylval=atoi(yytext);
            return(NUMBER);
          }
[^0-9\b]    {
              //    c = yytext[0];
              //    return(c);
              // }

%%