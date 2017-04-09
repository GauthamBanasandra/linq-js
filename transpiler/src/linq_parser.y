%{
    // TODO : Major bug fix needed - syntax error if alias length is 1.
    #include <stdio.h>
    #include <string.h>
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
%token <symp> SELECT FROM WHERE ID NUM JOIN ON IN EXPR E_ID ASC DSC ORDERBY GROUP BY INTO
%type <symp> src
%type <symp> linq
%type <symp> join
%type <symp> sel_clause
%type <symp> where
%type <symp> orderby
%type <symp> groupby
%type <symp> id
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
    FROM ID IN src orderby where groupby SELECT sel_clause  {
        struct symtab *id = $2,
                    *src = $4,
                    *orderby = $5,
                    *where = $6,
                    *groupby = $7,
                    *sel_clause = $9;
        char var[10];
        sprintf(var, "s%d", nesting);

        if(!innermost)
            sprintf(src->name, "s%d", nesting-1);
        innermost = false;

        char dummy_true[] = "true";

        if(groupby) {
        // debug.
        // cout << "group by meta: " << groupby->gp_meta->alias << '\n';
        // cout << "group by meta: " << groupby->gp_meta->gp_prop << '\n';
        // cout << "group by meta: " << groupby->gp_meta->target << '\n';
            struct symtab args[] = {
                {groupby->gp_meta->alias, groupby->lineno},
                {src->name, src->lineno},
                {where ? where->name : dummy_true, where ? where->lineno: -1},
                {groupby->gp_meta->gp_prop, groupby->lineno},
                {groupby->gp_meta->target, groupby->lineno}
            };
            int len = sizeof(args)/sizeof(struct symtab);
            printf("var %s=", var);
            gen_code("./templates/groupby.dat", args, len);
        } else {
            struct symtab args[]=
                              {
                                  {id->name, id->lineno},
                                  {src->name, src->lineno},
                                  {where ? where->name : dummy_true, where ? where->lineno: -1},
                                  {sel_clause->name, sel_clause->lineno}
                              };
            int len = sizeof(args)/sizeof(struct symtab);
            printf("var %s=", var);
            gen_code("./templates/template.dat", args, len);

            if (orderby) {
                struct symtab ob_args[]=
                                    {
                                        {orderby->metadata, -1},
                                        {orderby->name, orderby->lineno},
                                        {id->name, id->lineno},
                                        {src->name, src->lineno},
                                        {var, -1}
                                    };
                int ob_len=sizeof(ob_args)/sizeof(struct symtab);
                gen_code("./templates/orderby.dat", ob_args, ob_len);
            }
        }
    }
    ;
groupby:
    GROUP ID BY E_ID INTO ID    {
        struct gp_meta_struct meta;
        meta.alias = strdup($2->name);
        meta.gp_prop = strdup($4->name);
        meta.target = strdup($6->name);

        $$->gp_meta = &meta;
    }
    |   {$$ = NULL;}
    ;
sel_clause:
    ID
    | E_ID;
where:
    WHERE EXPR    {$$ = $2;}
    |   {$$ = NULL;}
    ;
orderby:
    ORDERBY id  {$$ = $2;}
    | ORDERBY id ASC    {
        $$ = $2;
        char asc[] = "ascending";
        $$->metadata = asc;
    }
    | ORDERBY id DSC {
        $$ = $2;
        char dsc[] = "descending";
        $$->metadata = dsc;
    }
    |   {$$ = NULL;}
    ;
id:
    ID
    | E_ID
    ;
join:
    FROM src JOIN src ON src WHERE EXPR SELECT ID   {
      /*                                                              struct symtab *id = $2,
                                                                    *src = src,
                                                                    *orderby = $5,
                                                                    *where = $6,
                                                                    *sel_clause = $8;
                                                    char var[10];
                                                    sprintf(var, "s%d", nesting);

                                                    if(!innermost)
                                                        sprintf(src->name, "s%d", nesting-1);

                                                    innermost = false;

                                                    struct symtab args[]=
                                                                        {
                                                                            {id->name, id->lineno},
                                                                            {src->name, src->lineno},
                                                                            {$6->name, $6->lineno},
                                                                            {$8->name, $8->lineno},
                                                                            {$10->name, $10->lineno}
                                                                        };
                                                    int len=sizeof(args)/sizeof(struct symtab);
                                                    printf("var %s=", var);
                                                    gen_code("./templates/inner_join.dat", args, len);*/
                                                }
%%
extern FILE* yyin;

void yyerror(const char* s)
{
    fprintf(stderr, "%s", s);
}

int main()
{
    yyin=fopen("../inputs/input_groupby.txt", "r");
    while(!feof(yyin))
        yyparse();
    fclose(yyin);

    return 0;
}