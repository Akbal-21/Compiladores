%{
    /*definiciones*/
    #include <stdio.h>
    #include <math.h>
    extern int yylex(void);
    extern char *yytext;
    extern FILE *yyin;
    int yyerror(char *s);
    double moddouble(double a, double b);
%}

%union {
    int entero;
    double real;
    char sym;
}

%token EOL

%token <entero> TOK_ENTERO
%type <entero> exp_entera

%token <real> TOK_REAL
%type <real> exp_real


%token MOD

%left '+''-'
%left '*''/' MOD
%left NEG
%left '^'



/*rules*/
%%
input: 
    |line input
;

line:
    exp_entera EOL {printf("%d\n", $1);}
    | exp_real EOL {printf("%lf\n", $1);}
    | EOL
;

exp_entera: 
    TOK_ENTERO {$$ = $1; printf("NUMERO ENTERO %d\n", $$);}
    |exp_entera '+' exp_entera {$$ = $1 + $3; printf("%d = %d + %d\n", $$, $1, $3);}
    |exp_entera '-' exp_entera {$$ = $1 - $3; printf("%d = %d - %d\n", $$, $1, $3);}
    |exp_entera '*' exp_entera {$$ = $1 * $3; printf("%d = %d * %d\n", $$, $1, $3);}
    |exp_entera '/' exp_entera  {$$ = $1 / $3; printf("%d = %d / %d\n", $$, $1, $3);}
    |MOD '('exp_entera','exp_entera')' {$$ = $3 % $5; printf("%d = MOD( %d, %d)\n", $$, $3, $5);}
    |'-' exp_entera %prec NEG {$$ = -$2; printf("NUMERO NEGATIVO ENTERO %d\n", $$);}
    |exp_entera '^' exp_entera {$$ = pow($1, $3); printf("%d = %d ^ %d\n", $$, $1, $3);}
;

exp_real:
    TOK_REAL {$$ = $1; printf("NUMERO REAL %lf\n", $$);}
    |exp_real '+' exp_real {$$ = $1 + $3; printf("%lf = %lf + %lf\n", $$, $1, $3);}
    |exp_entera '+' exp_real {$$ = $1 + $3; printf("%lf = %d + %lf\n", $$, $1, $3);}
    |exp_real '+' exp_entera {$$ = $1 + $3; printf("%lf = %lf + %d\n", $$, $1, $3);}
    |exp_real '-' exp_real {$$ = $1 - $3; printf("%lf = %lf - %lf\n", $$, $1, $3);}
    |exp_entera '-' exp_real {$$ = $1 - $3; printf("%lf = %d + %lf\n", $$, $1, $3);}
    |exp_real '-' exp_entera {$$ = $1 - $3; printf("%lf = %lf + %d\n", $$, $1, $3);}
    |exp_real '*' exp_real {$$ = $1 * $3; printf("%lf = %lf * %lf\n", $$, $1, $3);}
    |exp_entera '*' exp_real {$$ = $1 * $3; printf("%lf = %d + %lf\n", $$, $1, $3);}
    |exp_real '*' exp_entera {$$ = $1 * $3; printf("%lf = %lf + %d\n", $$, $1, $3);}
    |exp_real '/' exp_real  {if ($3) $$ = $1 / $3;
                            else $$ = $1; printf("%lf = %lf '/' %lf\n", $$, $1, $3);}
    |exp_entera '/' exp_real  {if ($3) $$ = $1 / $3;
                            else $$ = $1; printf("%lf = %d '/' %lf\n", $$, $1, $3);}
    |exp_real '/' exp_entera  {if ($3) $$ = $1 / $3;
                            else $$ = $1; printf("%lf = %lf '/' %d\n", $$, $1, $3);}
    |MOD '('exp_real','exp_real')' {$$ = moddouble($3, $5); printf("%lf = MOD( %lf, %lf)\n", $$, $3, $5);}
    |MOD'('exp_entera ',' exp_real')' {$$ = moddouble((double)$3, $5); printf("%lf = MOD( %d, %lf)\n", $$, $3, $5);}
    |MOD'('exp_real ',' exp_entera')' {$$ = moddouble($3, (double)$5); printf("%lf = MOD( %lf, %d)\n", $$, $3, $5);}
    |'-' exp_real %prec NEG {$$ = -$2; printf("NUMERO NEGATIVO REAL, %lf\n", $$);}
    |exp_real '^' exp_real {$$ = pow($1, $3); printf("%lf = %lf ^ %lf\n", $$, $1, $3);}
    |exp_entera '^' exp_real {$$ = pow($1, $3); printf("%lf = %d ^ %lf\n", $$, $1, $3);}
    |exp_real '^' exp_entera {$$ = pow($1, $3); printf("%lf = %lf ^ %d\n", $$, $1, $3);}
;


%%


double moddouble(double a, double b) {
    double result;
    if (a < 0){
        result = -a;
    }else {
        result = a;
    }
    if (b < 0){
        result = -b;
    }
    while (result >= b){
        result = result - b;
    }
    if (a < 0){
        return (-result);
    }
    return (result);
}

int main() {
    return(yyparse());
}

int yyerror(char *s)  {
    printf("Error: %s\n", s);
    return 0;
}

int yywrap()
{
    return 1;
}