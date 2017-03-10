#!/usr/bin/env bash
lex ./lex/linq_lexer.l &&
mv lex.yy.c linq_lexer.c &&
lex ./lex/codegen.l &&
mv lex.yy.c codegen.c &&
python ./utils/name_mangler.py codegen.c 1000 10000 &&
yacc -d linq_parser.y &&
mv y.tab.c linq_parser.c &&
gcc linq_lexer.c linq_parser.c codegen.c -ll &&
./a.out > plain.js
python ./utils/strip_newline.py plain.js &&
rm *.c y.tab.h a.out
