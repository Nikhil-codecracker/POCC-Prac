%option yylineno

%{
	#include<stdio.h>
	#include"y.tab.h"
	#include<math.h>
%}

alpha [a-zA-Z]
digit [0-9]

%%
[ \t]		;
[ \n]   { yylineno = yylineno + 1;}
"void"|"char"|"int"|"float"|"double"	                        {return TYPE;}
"for" 	                                                        {return FOR;}
"while"	                                                        {return WHILE;}
"if"	                                                        {return IF;}
"else"	                                                        {return ELSE;}
"printf"                                                        {return PRINTF;}
"return"                                                        {return RETURN;}
"#include"([ ]+)?((<(\\.|[^>])+>)|(\"(\\.|[^"])+\"))            {return HEADER;}
{digit}+                                                        {return NUM;}
{alpha}({alpha}|{digit})*                                       {return ID;}
"<="                                                            {return LEQ;}
">="                                                            {return GEQ;}
"=="                                                            {return EQ;}
"!="                                                            {return NEQ;}
">"	                                                            {return GT;}
"<"	                                                            {return LT;}

\/\/.* ;
\/\*(.*\n)*.*\*\/ ;
.                                                               {return yytext[0];}
%%

int yywrap(){return -1;}