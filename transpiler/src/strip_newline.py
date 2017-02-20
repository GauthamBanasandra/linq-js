import sys

import re

with open(sys.argv[1], 'r') as src_file:
    src = src_file.read()
with open(sys.argv[1], 'w') as tgt_file:
    src = re.sub(r'(\n+)', '\n', src)
    print src
    tgt_file.write(src)
