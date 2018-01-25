import sys

try:
    from builtins import chr
except ImportError:
    pass

py_2 = False
if sys.version_info[0] == 2:
    py_2 = True

if py_2:
    chr = unichr

def convert(the_string):
    return the_string.encode('utf8')

def prepare_string(the_string):
    if py_2 and isinstance(the_string, unicode):
        return the_string.encode('utf8')
    elif not py_2 and isinstance(the_string, str):
        return the_string.encode('utf8')
    return the_string