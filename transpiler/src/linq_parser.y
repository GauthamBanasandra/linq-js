%{
    // TODO : Major bug fix needed - syntax error if alias length is 1.
    // TODO : Handle orderby in group by.
    // TODO : Handle LINQ statements inside comments and strings.
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
%token <symp> SELECT FROM WHERE ID NUM JOIN ON IN EXPR E_ID ASC DSC ORDERBY GROUP BY INTO EQUALS
%type <symp> src
%type <symp> linq
%type <symp> sel_clause
%type <symp> where
%type <symp> orderby
%type <symp> join
%type <symp> groupby
%type <symp> id
%%
linq:
    FROM ID IN src orderby join where groupby SELECT sel_clause  {
        bool sel_exec = true;
        struct symtab *id = $2,
                    *src = $4,
                    *orderby = $5,
                    *join = $6,
                    *where = $7,
                    *groupby = $8,
                    *sel_clause = $10;
        char var[10];
        sprintf(var, "s%d", nesting);

        if(!innermost)
            sprintf(src->name, "s%d", nesting-1);
        innermost = false;

        char dummy_true[] = "true";

        if(join) {
            sel_exec = false;
            struct symtab args[] = {
                {join->j_meta->alias, -1},
                {id->name, -1},
                {join->j_meta->src, -1},
                {src->name, -1},
                {join->j_meta->cond1, -1},
                {join->j_meta->cond2, -1},
                {where ? where->name : dummy_true, where ? where->lineno: -1},
                {sel_clause->name, sel_clause->lineno}
            };
            int len = sizeof(args)/sizeof(struct symtab);

            // debug.
            // cout << join->j_meta->alias << endl;
            // cout << id->name << endl;
            // cout << join->j_meta->src << endl;
            // cout << src->name << endl;
            // cout << join->j_meta->cond1 << endl;
            // cout << join->j_meta->cond2 << endl;
            // cout << (where ? where->name : dummy_true) << endl;
            // cout << sel_clause->name << endl;
            printf("var %s=", var);
            gen_code("./templates/join.dat", args, len);
        }

        if(groupby) {
        sel_exec = false;
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
        }

        if(sel_exec) {
            struct symtab args[]= {
                {id->name, id->lineno},
                {src->name, src->lineno},
                {where ? where->name : dummy_true, where ? where->lineno: -1},
                {sel_clause->name, sel_clause->lineno}
            };
            int len = sizeof(args)/sizeof(struct symtab);
            printf("var %s=", var);
            gen_code("./templates/template.dat", args, len);
        }

        if (orderby) {
            struct symtab ob_args[]= {
                {orderby->o_meta->order, -1},
                {orderby->o_meta->prop, orderby->lineno},
                {id->name, id->lineno},
                {src->name, src->lineno},
                {var, -1}
            };
            int ob_len=sizeof(ob_args)/sizeof(struct symtab);
            gen_code("./templates/orderby.dat", ob_args, ob_len);
        }
    }
    | {$$ = NULL;}
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
    | E_ID
    | EXPR
    ;
where:
    WHERE EXPR    {$$ = $2;}
    |   {$$ = NULL;}
    ;
orderby:
    ORDERBY id  {
        struct o_meta_struct meta;
        meta.prop = $2->name;
        meta.order = strdup("ascending");

        $$->o_meta = &meta;
    }
    | ORDERBY id ASC    {
        struct o_meta_struct meta;
        meta.prop = $2->name;
        meta.order = strdup("ascending");

        $$->o_meta = &meta;
    }
    | ORDERBY id DSC {
        struct o_meta_struct meta;
        meta.prop = $2->name;
        meta.order = strdup("descending");

        $$->o_meta = &meta;
    }
    |   {$$ = NULL;}
    ;
join:
    JOIN ID IN ID ON E_ID EQUALS E_ID {
        struct j_meta_struct meta;
        meta.alias = $2->name;
        meta.src = $4->name;
        meta.cond1 = $6->name;
        meta.cond2 = $8->name;

        $$->j_meta = &meta;
    }
    |   {$$ = NULL;}
    ;
id:
    ID
    | E_ID
    ;
%%
extern FILE* yyin;

void yyerror(const char* s)
{
    fprintf(stderr, "%s", s);
}

int main(int argc, char *argv[])
{
     //"../inputs/input_join.txt"
//    yyin=fopen(argv[1], "r");
    yyin=fopen("../inputs/input_groupby.txt", "r");
    while(!feof(yyin))
        yyparse();
    fclose(yyin);

    return 0;
}