%{
    #include <stdio.h>
	#include "symtab.h"

    int yylex();
    void yyerror(const char*);
    void gen_code(const char*, struct symtab [], int);

    int nesting = 1;
    bool innermost = true;
%}
%union{
	struct symtab* symp;
}
%token <symp> SELECT FROM WHERE ID NUM JOIN ON IN EXPR
%type <symp> src
%type <symp> linq
%type <symp> join
%%
stmt:
    stmt linq
    | stmt join
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
    | '(' join ')'  {
                        sprintf($2->name, "s%d", nesting);
                        /*Do not omit this line. Yacc will not be able to perform default action otherwise.*/
                        $$=$2;
                        ++nesting;
                    }
    ;
linq:
    FROM ID IN src WHERE EXPR SELECT ID {
                                            char var[10];
                                            sprintf(var, "s%d", nesting);

                                            if(!innermost)
                                                sprintf($4->name, "s%d", nesting-1);

                                            innermost = false;
                                            struct symtab args[]=
                                                                {
                                                                    {$2->name, $2->lineno},
                                                                    {$4->name, $4->lineno},
                                                                    {$6->name, $6->lineno},
                                                                    {$8->name, $8->lineno}
                                                                };
                                            int len=sizeof(args)/sizeof(struct symtab);
                                            printf("var %s=", var);
                                            gen_code("./templates/template.dat", args, len);
                                        }
    | FROM ID IN src SELECT ID  {
                                    // In this production, the 'where' clause is optional.
                                    char var[10];
                                    sprintf(var, "s%d", nesting);

                                    if(!innermost)
                                        sprintf($4->name, "s%d", nesting-1);

                                    innermost = false;
                                    // Dummy true, since we could reuse the same template file.
                                    char dummy_true[] = "true";
                                    struct symtab args[]=
                                                        {
                                                            {$2->name, $2->lineno},
                                                            {$4->name, $4->lineno},
                                                            {dummy_true, -1},
                                                            {$6->name, $6->lineno}
                                                        };

                                    int len=sizeof(args)/sizeof(struct symtab);
                                    printf("var %s=", var);
                                    gen_code("./templates/template.dat", args, len);
                                }
    ;
join:
    FROM src JOIN src ON src WHERE EXPR SELECT ID   {
                                                    char var[10];
                                                    sprintf(var, "s%d", nesting);

                                                    if(!innermost)
                                                        sprintf($4->name, "s%d", nesting-1);

                                                    innermost = false;

                                                    struct symtab args[]=
                                                                        {
                                                                            {$2->name, $2->lineno},
                                                                            {$4->name, $4->lineno},
                                                                            {$6->name, $6->lineno},
                                                                            {$8->name, $8->lineno},
                                                                            {$10->name, $10->lineno}
                                                                        };
                                                    int len=sizeof(args)/sizeof(struct symtab);
                                                    printf("var %s=", var);
                                                    gen_code("./templates/inner_join.dat", args, len);
                                                }
%%
extern FILE* yyin;

void yyerror(const char* s)
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