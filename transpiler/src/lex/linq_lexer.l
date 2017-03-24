%{
    #include <string.h>

    #include "symtab.h"
    #include "y.tab.h"

    void yyerror(char*);
    int lineno=1, first=1;
%}
letters [a-zA-Z_$]
%s LINQ
%%
\n  {
		++lineno;
		ECHO;
	}
from  {
			BEGIN LINQ;
			yylval.symp=symlook(yytext);
			if(first)
			{
			    printf("(function(){\n");
			    first=0;
			}
			return FROM;
		}
<LINQ>select    {return SELECT;}
<LINQ>where  {return WHERE;}
<LINQ>join   {return JOIN;}
<LINQ>on {return ON;}
<LINQ>"("    {return yytext[0];}
<LINQ>")"    {return yytext[0];}
<LINQ>{letters}[a-zA-Z0-9_$]+    {
									yylval.symp=symlook(yytext);
									return ID;
								}
<LINQ>[0-9]+ {
				yylval.symp=symlook(yytext);
				return NUM;
			}
<LINQ>"."    {return yytext[0];}
<LINQ>";"    {
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
