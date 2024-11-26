# This is the script that generates the set.mbt file.

import os
import sys

script_dir = os.path.dirname(__file__)
output_dir = sys.argv[1]

with open(script_dir + '/set.txt', 'r') as src_file:
    source_content = src_file.read()

with open(output_dir + '/set.mbt', 'w') as dst_file:
    dst_file.write(source_content)
