%{
    #include <stdio.h>
    #include <iostream>
	#include "symtab.h"

    int yylex();
    void yyerror(const char*);
    void gen_code(const char*, struct symtab [], int);

    int nesting = 1;
    bool innermost = true;
    using namespace std;
%}
%union{
	struct symtab* symp;
}
%token <symp> SELECT FROM WHERE ID NUM JOIN ON IN EXPR E_ID ASC DSC ORDERBY
%type <symp> src
%type <symp> linq
%type <symp> join
%type <symp> sel_clause
%type <symp> where
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
    FROM ID IN src WHERE EXPR SELECT sel_clause {
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
    | FROM ID IN src ORDERBY E_ID where SELECT sel_clause {
                                                  char var[10];
                                                  sprintf(var, "s%d", nesting);

                                                  if(!innermost)
                                                      sprintf($4->name, "s%d", nesting-1);

                                                  innermost = false;
                                                  char dummy_true[] = "true";
                                                  struct symtab args[]=
                                                                      {
                                                                          {$2->name, $2->lineno},
                                                                          {$4->name, $4->lineno},
                                                                          {$7 ? $7->name : dummy_true, $7 ? $7->lineno: -1},
                                                                          {$9->name, $9->lineno}
                                                                      };
                                                  int len=sizeof(args)/sizeof(struct symtab);
                                                  printf("var %s=", var);
                                                  gen_code("./templates/template.dat", args, len);

                                                  char temp[]="ascending";
                                                  struct symtab ob_args[]=
                                                                        {
                                                                            {temp, -1},
                                                                            {$6->name, $6->lineno},
                                                                            {$2->name, $2->lineno},
                                                                            {$4->name, $4->lineno},
                                                                            {var, -1}
                                                                        };
                                                  int ob_len=sizeof(ob_args)/sizeof(struct symtab);
                                                  gen_code("./templates/orderby.dat", ob_args, ob_len);
                                              }
    | FROM ID IN src SELECT sel_clause  {
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
sel_clause:
    ID
    | E_ID;
where:
    WHERE EXPR    {$$ = $2;}
    |   {$$ = NULL;}
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
    yyin=fopen("../inputs/input_orderby.txt", "r");
    while(!feof(yyin))
        yyparse();
    fclose(yyin);

    return 0;
}