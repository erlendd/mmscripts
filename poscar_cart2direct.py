#!/usr/bin/env python
import os
import time
import sys
import re
from p4vasp.Structure import *

if len(sys.argv) < 2:
    print "Usage: "+sys.argv[0]+" <poscar file>"
    print "           outputs the direct coords to stdout"
    sys.exit(1)

space = re.compile(r'\s+')

file = sys.argv[1]

p=Structure(file)
p.setDirect()
p.write(sys.stdout)

