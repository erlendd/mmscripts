#! /usr/bin/env python

import os
import time
import sys
import re
from math import sqrt
from math import atan
from math import sin
from math import cos
from math import degrees


data = sys.stdin.readlines()
print "Counted", len(data), "lines."

l = 0 # length
# python for loops non-inclusive of the upper bound
for i in range(0,3):
#  print float(data[i+3]) - float(data[i])
  l = l + ( float(data[i+3]) - float(data[i]) )**2

print sqrt(l)

