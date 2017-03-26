import random
import sys

import re

duplicate_symbols = eval(
    r'''['yy_switch_to_buffer', 'yypush_buffer_state', 'yypop_buffer_state', 'yy_delete_buffer', 'yy_create_buffer',
     'yy_flush_buffer', 'yy_scan_buffer', 'yy_scan_string', 'yylex_destroy', 'yy_scan_bytes', 'yy_flex_debug',
     'yyset_lineno', 'yyget_lineno', 'yyset_debug', 'yyget_debug', 'yyget_text', 'yyget_leng', 'yyset_out', 'yyget_out',
     'yyrestart', 'yyrealloc', 'yylineno', 'yyset_in', 'yyget_in', 'yyalloc', 'yyfree', 'yylex', 'yyout', 'yyin', 'yy_load_buffer_state', 'yy_init_buffer', 'yyleng', 'yytext']''')

rand_nums = random.sample(range(int(sys.argv[2]), int(sys.argv[3])), len(duplicate_symbols))

with open(sys.argv[1], 'r') as src_file:
    src = src_file.read()
    for symbol, sub in zip(duplicate_symbols, rand_nums):
        src = re.sub(symbol, '_' + str(sub), src)

with open(sys.argv[1], 'w') as tgt_file:
    tgt_file.write(src)
