%{
    #include <string.h>

    #include "symtab.h"
    #include "y.tab.h"

    void yyerror(char*);
    int lineno=1, first=1;
%}
letters [a-zA-Z_$]
%s SEL
%%
\n  {
		++lineno;
		ECHO;
	}
select  {
			BEGIN SEL;
			yylval.symp=symlook(yytext);
			if(first)
			{
			    printf("(function(){\n");
			    first=0;
			}
			return SELECT;
		}
<SEL>from   {return FROM;}
<SEL>where  {return WHERE;}
<SEL>join   {return JOIN;}
<SEL>on {return ON;}
<SEL>"("    {return yytext[0];}
<SEL>")"    {return yytext[0];}
<SEL>{letters}[a-zA-Z0-9_$]+    {
									yylval.symp=symlook(yytext);
									return ID;
								}
<SEL>[0-9]+ {
				yylval.symp=symlook(yytext);
				return NUM;
			}
<SEL>"."    {return yytext[0];}
<SEL>";"    {
                BEGIN INITIAL;
                printf("return s1;\n})();\n");
            }
EOF {return 0;}
.   ECHO;
%%
int yywrap()
{
    return 1;
}

struct symtab* symlook(char* s)
{
    struct symtab* sp;

    for(sp=symtab; sp<&symtab[NSYMS]; sp++)
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

	yyerror("symbol table out of memory");
	exit(1);

    return 0;
}
