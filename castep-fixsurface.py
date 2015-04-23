#! /usr/bin/python

import sys
import os
import re
from math import sqrt, cos, tan, sin, radians

current_ion_num = 1
nions = 36
constraint_counter = 3
species = "Cu"

fix=1
free=0

for i in range(1,nions):
  print "   ",constraint_counter,species,"   ",i," ",fix," ",free," ",free
  constraint_counter = constraint_counter+1
  print "   ",constraint_counter,species,"   ",i," ",free," ",fix," ",free
  constraint_counter = constraint_counter+1
  print "   ",constraint_counter,species,"   ",i," ",free," ",free," ",fix
  constraint_counter = constraint_counter+1



