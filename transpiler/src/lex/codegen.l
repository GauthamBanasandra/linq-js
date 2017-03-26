%{
    #include <string.h>

	#include "symtab.h"

	struct symtab* lookup_var(char*);
	void extract_name_prop(char*, char*, char*);

	int NVARS_MEMCP=10, nvars=0;
	char** vars;
	struct symtab* values;
%}
%s VAR
%s GEN
%%
@var    {
			vars=(char**)calloc(NVARS_MEMCP, sizeof(char*));
			BEGIN VAR;
		}
<VAR>$[a-zA-Z]+ {
					if(nvars+1>=NVARS_MEMCP)
					{
						NVARS_MEMCP+=10;
						vars=(char **)realloc(vars, NVARS_MEMCP*sizeof(char*));
					}
					vars[nvars++]=strdup(yytext);
				}
<VAR>@code  {
				BEGIN INITIAL;
				BEGIN GEN;

				NVARS_MEMCP=nvars;
                vars=(char **)realloc(vars, nvars*sizeof(char*));
			}
<GEN>$[a-zA-Z]+ {
					struct symtab* sym=lookup_var(yytext);

					if(sym!=NULL)
						printf("%s", sym->name);
					else
					{
						printf("\"%s undeclared\"\n", yytext);
						exit(1);
					}
				}
<GEN>$[a-zA-Z]+#[a-zA-Z]+   {
								char name[100];
                                char prop[100];

								extract_name_prop(yytext, name, prop);

								printf("%d", lookup_var(name)->lineno);
							}
<GEN>.  ECHO;
%%
extern FILE* yyin;

void extract_name_prop(char* text, char* name, char* prop)
{
	int i=0, j=0;
    for(i=0; text[i]!='#';++i)
        name[i]=text[i];

    for(++i, j=0; text[i];++i, ++j)
        prop[j]=text[i];

    name[i]=prop[j]='\0';
}

struct symtab* lookup_var(char* text)
{
	int i=0;
    for(i=0; i<NVARS_MEMCP; ++i)
        if(!strcmp(text, vars[i]))
            return &values[i];

    return NULL;
}

void gen_code(const char* _template, struct symtab args[], int len)
{
	values=args;
	yyin=fopen(_template, "r");
	yylex();
	fclose(yyin);
	free(vars);

	NVARS_MEMCP=10;
	nvars=0;
}