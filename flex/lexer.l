%{
    /*definiciones*/
    #include <stdlib.h>
    #include <stdio.h>
    #include <math.h>
    #include "parser.tab.h"
    #define TOK_ERROR -1
%}

ENTERO [0-9]+
REAL [0-9]*"."{ENTERO}
MODULE [Mm][oO][Dd]
%%
{ENTERO} {yylval.entero = atoi(yytext);
	    return (TOK_ENTERO);}

{REAL} {yylval.real = atof(yytext);
        return (TOK_REAL);}


{MODULE} {return (MOD);}

"+" {printf("SUMA\n"); return (yytext[0]);}
"-" {printf("RESTA\n"); return (yytext[0]);}
"*" {printf("MULTIPLICACION\n"); return (yytext[0]);}
"/" {printf("DIVISION\n"); return (yytext[0]);}
"^" {printf("POTENCIA\n"); return (yytext[0]);}

"("|")" {return (yytext[0]);}
"," {return (yytext[0]);}
\n {return (EOL);}

. {printf("Error lexico\n");return (TOK_ERROR);}
%%