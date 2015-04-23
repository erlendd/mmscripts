#! /usr/bin/python
import re

space = re.compile('\s+')

POTCARDIR="/home/e304/e304/erlend/src/vasp/potpaw_PBE.52/"

POSCAR="POSCAR"

infile = open(POSCAR,'r')

for i in range(6):
  line = infile.readline()

speciesline = line.strip()

species = space.split(speciesline)

full_potcar = ""
for element in species:
  element_potcar = POTCARDIR+element+'/POTCAR'
  inpotcar = open(element_potcar, 'r')
  full_potcar = full_potcar+inpotcar.read()

print full_potcar
