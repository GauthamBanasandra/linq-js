#!/usr/bin/env bash
lex linq_lexer.l
gcc lex.yy.c -ll
./a.out