%{
/**********************************************************************
 *  Interface to the scanner module for CSC467 course project
 **********************************************************************/


#include "common.h"
#include "parser.tab.h"
#include "string.h"


#define YY_USER_INIT { yyin = inputFile; }
#define	yyinput      input
#define yTRACE(x)    { if (traceScanner) fprintf(traceFile, "TOKEN %3d : %s\n", x, yytext); }
#define yERROR(x)    { fprintf(errorFile, "\nLEXICAL ERROR, LINE %d: %s\n", yyline, x); errorOccurred = TRUE; yyterminate(); }

int CheckInt(void);
int yyline = 1;
// helper functions for converting yytext to corresponding type
int parseInt(void);
int parseFloat(void);
int parseName(void);
int parseComment(void);

enum {
    SUCCESS = 1,
    ERROR = 0,
    MAX_INT = 10,
    MIN_INT = -MAX_INT
};

%}
%option noyywrap

WS          [ \t]+
NEWLINE     \r?\n
STRING      \"[^\n"]+\"
DIGIT       [0-9]
ID          [a-zA-Z_][a-zA-Z0-9_]*
INTEGER     [-+]?{DIGIT}+

%%
"/*"        { yERROR("Change this - comment unimplemented."); }

{WS}          { } // eat all whitespace

{ID}        { if( parseName() ){ yTRACE(ID); } }

{INTEGER}   { if( parseInt() ){ yTRACE(INT_C); } }


{NEWLINE}   { yyline++; }
.           { yERROR("Unknown token"); }

%%

/* helper functions for parsing */
int parseName(void){
    char *name = (char *) calloc (yyleng+1,sizeof(char));
    memcpy(name,yytext,yyleng);
    yylval.as_str = name;
    return SUCCESS;
}

int parseInt(void){
    //TODO: handle long and long limit
    long integer = atol(yytext);
    
    if(MAX_INT < integer || MIN_INT > integer ){
        yERROR("Integer out of range\n");
        return ERROR;
    }
    
    yylval.as_int = (int) integer;
    return SUCCESS;
    
}
