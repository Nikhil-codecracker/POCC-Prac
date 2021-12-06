%{
    #include <stdio.h>
    #include <stdlib.h>
    int yyerror(char *msg);
    extern int yylex();
    int flag = 1;
%}

%token HEADER TYPE FOR WHILE IF ELSE 
%token NUM ID PRINTF RETURN 
%token LEQ GEQ EQ NEQ LT GT

%right '='
%left '<' '>' LEQ GEQ EQ NEQ LT GT

%%

start:           Header start
	            | Function start
	            | Declaration start
                | Function
                | Declaration
	            ;

Header:         HEADER Header
                | HEADER
                ;

Function:       TYPE ID '(' ParamList ')' CompoundStatement 
	            ;

ParamList:      ParamList ',' Param
	            | Param
	            ;

Param:	        TYPE ID
                |
	            ;
                
CompoundStatement:	'{' StatementList '}'               
	                ;

StatementList:	StatementList Statements
	            | Statements 
	            ;

Statements:	    Declaration
	            | WhileStatement
	            | ForStatement
	            | IfStatement
	            | PrintFunc
                | ReturnStatement
                | ';'
	            ;

ReturnStatement:   RETURN ';'
                | RETURN ID ';'
                | RETURN NUM ';'
                | RETURN FunctionCall';'

WhileStatement: WHILE '('Exp')' CompoundStatement 
	            ;


ForStatement:   FOR '(' Exp ';' Exp ';' Exp ')' CompoundStatement 
	            ;


IfStatement :   IF '(' Exp ')' CompoundStatement
	            ;

PrintFunc :     PRINTF '(' Exp ')' ';'
	            ;

Declaration:    TYPE Exp ';' 
	            | Exp ';'  	
	            | FunctionCall ';' 	 	
	            | error	
	            ;

FunctionCall :  ID'('')'
	            | ID'('CallParams')'
	            ;

CallParams:     ID ',' Exp
                | NUM ',' Exp
                ;

Exp:            ID '=' Exp
	            | ID '=' FunctionCall
	            | Exp '+' Exp
	            | Exp '-' Exp
	            | Exp '*' Exp
	            | Exp '/' Exp	
	            | Exp LEQ Exp 
	            | Exp GEQ Exp
	            | Exp NEQ Exp
	            | Exp EQ Exp
	            | Exp GT Exp
	            | Exp LT Exp
	            | ID
                | NUM
	            ;
%%

int main(int argc, char *argv[]){
	yyparse();
    if(flag)
    	printf("Parsing Successful\n");
    return 0;
}
         
int yyerror(char *msg) {
    extern int yylineno;
	printf("Parsing Failed\nLine Number: %d %s\n",yylineno,msg);
	flag = 0;
	exit(1);
}