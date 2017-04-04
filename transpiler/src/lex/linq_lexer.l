%{
    #include <iostream>
    #include <string>
    #include <string.h>

    #include "symtab.h"
    #include "y.tab.h"

    using namespace std;

    extern int nesting;
    void yyerror(const char*);

    bool cat = false, first = true;
    int lineno = 1;
    struct symtab symtab[2000];
    string expr_str;
%}
%x LINQ IN_WHERE
%%
\n  {
		++lineno;
		ECHO;
	}
from  {
            // debug.
//            cout << "from" << endl;
			BEGIN LINQ;
			yylval.symp=symlook(yytext);
			if(first)
			{
			    printf("(function(){\n");
			    first=false;
			}
			return FROM;
		}
<LINQ>select    {return SELECT;}
<LINQ>where  {
                BEGIN IN_WHERE;
                return WHERE;
             }
<IN_WHERE>.  {
                if(yytext[0]=='}')
                {
                    cat = false;
                    // debug.
//                    cout << expr_str << endl;
                    BEGIN LINQ;
                    yylval.symp = symlook(expr_str.c_str());
                    expr_str = "";
                    return EXPR;
                }

                if(cat)
                {
                    expr_str += yytext[0];
                }

                if(yytext[0]=='{')
                {
                    cat = true;
                }
            }
<LINQ>join   {return JOIN;}
<LINQ>on {return ON;}
<LINQ>in {return IN;}
<LINQ>ascending {return ASC;}
<LINQ>descending    {return DSC;}
<LINQ>orderby   {return ORDERBY;}
<LINQ>"("   {
                BEGIN INITIAL;
                // debug.
//                cout << "begin inner" << endl;
                return yytext[0];
            }
<LINQ>")"    {return yytext[0];}
<LINQ>[a-zA-Z_$][a-zA-Z0-9_$]+    {
                                    // debug.
//                                    cout << "id " << yytext << endl;
									yylval.symp=symlook(yytext);
									return ID;
								}
<LINQ>[a-zA-Z_$][a-zA-Z0-9_$().]+   {
                                        yylval.symp = symlook(yytext);
                                        // debug.
//                                        cout << "e_id " << yytext << endl;
                                        return E_ID;
                                    }
<LINQ>[0-9]+    {
                    yylval.symp=symlook(yytext);
                    return NUM;
                }
<LINQ>"."    {return yytext[0];}
<LINQ>";"   {
                BEGIN INITIAL;
                first = true;
                cout << "return s" << nesting << ";\n})();" << endl;
            }
EOF {return 0;}
.   ECHO;
%%
int yywrap()
{
    return 1;
}

struct symtab* symlook(const char* s)
{
    struct symtab* sp;

    for(sp=symtab; sp<&symtab[2000]; sp++)
    {
        if(sp->name && !strcmp(sp->name, s))
        {
            sp->lineno=lineno;
            return sp;
        }

        if(!sp->name)
        {
            sp->name=strdup(s);
            sp->lineno=lineno;
            return sp;
        }
    }

    cout << "symbol table out of memory" << endl;
	exit(1);

    return 0;
}
