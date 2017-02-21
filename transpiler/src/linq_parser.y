%{
    #include <stdio.h>
	#include "symtab.h"

    int yylex();
    void yyerror(char*);
    void gen_code(char*, struct symtab [], int);

    int first_parser=1, nesting=1, count=0;
%}
%union{
	struct symtab* symp;
}
%token <symp> SELECT FROM WHERE ID NUM JOIN ON
%type <symp> src
%type <symp> linq
%%
stmt:
    stmt linq
    | stmt SELECT ID FROM ID JOIN ID ON ID WHERE NUM    {
                                                            struct symtab args[]=
					                                                            {
					                                                                {$3->name, $3->lineno},
					                                                                {$5->name, $5->lineno},
					                                                                {$7->name, $7->lineno},
					                                                                {$9->name, $9->lineno},
					                                                                {$11->name, $11->lineno}
					                                                            };
					                                        int len=sizeof(args)/sizeof(struct symtab);
					                                        gen_code("./templates/inner_join.dat", args, len);
                                                        }
    |
    ;
src:
    ID
    | '(' linq ')'  {
                        sprintf($2->name, "s%d", nesting);
                        /*Do not omit this line. Yacc will not be able to perform default action otherwise.*/
                        $$=$2;
                        ++nesting;
                    }
    ;
linq:
    SELECT ID FROM src WHERE NUM    {
                                        char var[10];
                                        sprintf(var, "s%d", nesting);

                                        if(!first_parser)
                                            sprintf($4->name, "s%d", nesting-1);

                                        first_parser=0;
                                        struct symtab args[]=
                                                            {
                                                                {$2->name, $2->lineno},
                                                                {$4->name, $4->lineno},
                                                                {$6->name, $6->lineno}
                                                            };
                                        int len=sizeof(args)/sizeof(struct symtab);
                                        printf("var %s=", var);
                                        gen_code("./templates/template.dat", args, len);
                                    }
    ;
%%
extern FILE* yyin;

void yyerror(char* s)
{
    fprintf(stderr, "%s", s);
}

int main()
{
    yyin=fopen("../inputs/input_recursive.txt", "r");
    while(!feof(yyin))
        yyparse();
    fclose(yyin);

    return 0;
}