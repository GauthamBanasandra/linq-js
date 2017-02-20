#define NSYMS 200

struct symtab
{
	char* name;
	int lineno;
} symtab[NSYMS];

struct symtab* symlook(char*);