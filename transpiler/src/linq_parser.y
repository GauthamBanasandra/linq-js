%{
    #include <stdio.h>
	#include "symtab.h"

    int yylex();
    void yyerror(char*);
    void gen_code(char*, struct symtab [], int);
%}
%union{
	struct symtab* symp;
}
%token <symp> SELECT FROM WHERE ID NUM JOIN ON
%%
stmt:
    stmt SELECT ID FROM ID WHERE NUM    {
                                                struct symtab args[]=
                                                                    {
                                                                        {$3->name, $3->lineno},
                                                                        {$5->name, $5->lineno},
                                                                        {$7->name, $7->lineno}
                                                                    };
                                                int len=sizeof(args)/sizeof(struct symtab);
                                                gen_code("template.dat", args, len);
                                        }
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
					                                        gen_code("inner_join.dat", args, len);
                                                        }
    |
    ;
%%
extern FILE* yyin;

void yyerror(char* s)
{
    fprintf(stderr, "%s", s);
}

int main()
{
    yyin=fopen("input.txt", "r");
    while(!feof(yyin))
        yyparse();
    fclose(yyin);

    return 0;
}