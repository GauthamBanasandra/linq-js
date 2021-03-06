#ifndef SYMTAB_H
#define SYMTAB_H

#define NSYMS 200

struct symtab {
	char *name;
	int lineno;
	struct o_meta_struct *o_meta;
	struct gp_meta_struct *gp_meta;
	struct j_meta_struct *j_meta;
};

struct gp_meta_struct {
    char *alias;
    char *gp_prop;
    char *target;
};

struct o_meta_struct {
    char *prop;
    char *order;
};

struct j_meta_struct {
    char *alias;
    char *src;
    char *cond1;
    char *cond2;
};

struct symtab* symlook(const char*);

#endif