#ifndef SYMTAB_H
#define SYMTAB_H

#define NSYMS 200

struct symtab
{
	char* name;
	int lineno;
	char* metadata;
};

struct symtab* symlook(const char*);

#endif