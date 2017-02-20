@ECHO OFF
flex linq_lexer.l
ren lex.yy.c linq_lexer.c
flex codegen.l
ren lex.yy.c codegen.c
python name_mangler.py codegen.c 1000 10000
bison -dy linq_parser.y
ren y.tab.c linq_parser.c
gcc linq_lexer.c linq_parser.c codegen.c
a.exe > plain.js
python strip_newline.py plain.js
js-beautify plain.js | node
del *.c *.h