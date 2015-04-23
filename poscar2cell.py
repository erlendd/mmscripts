#! /usr/bin/python

import sys
import os
import re

if len(sys.argv) < 1:
    print "Usage: "+sys.argv[0]+" <POSCAR> > {file}.cell"
    sys.exit(1)

file = sys.argv[1]

infile = open(file,"r",0)

space = re.compile(r'\s+')

lattice=[]
positions=[]

n = 0
while infile:
    n = n + 1 # count the line number
    if n == 1:
        comment = infile.readline().strip()

    if n == 2:
        latticeparam = float(infile.readline())

    # the lattice consists of three lines
    # where each line has three elements
    # lattice[linenum][xyz].
    if n > 2 and n < 6:
        lattice_line_tmp =  space.split(infile.readline().strip())
        lattice.append([])
        for i in range(0,3):
            lattice[n-3].append( latticeparam * float( lattice_line_tmp[i] ) )

    if n == 6:
        species_line = infile.readline().strip()
        n_species = space.split(species_line) # number of each species

    if n == 7:
        type_of_dynamics = infile.readline().strip()

    if n == 8:
        frac_or_abs = infile.readline().strip()

    if n > 8: # the rest is just positions (get rid of the T/F at the end)
        line = infile.readline().strip()
        if not line: break; # no more to read?
        lineAr = space.split(line)
        positions.append([]) # positions is a 2-d list
        for i in range(0,len(lineAr)):
            # i=0 to 2 : positions
            # i=3 to 6 : constraints (if present)
            positions[n-9].append( lineAr[i] )
        

#####
## Now print all this in the format of a CASTEP .cell file

print "%BLOCK lattice_cart",
for i in range(0,3):
    print
    for j in range(0,3):
         print '{0:.16f}'.format( lattice[i][j] ),
print
print "%ENDBLOCK lattice_cart"
print

print "%BLOCK positions_frac"
offset = 0
for i in range(0,len(n_species)): # for each type of species...
    thisSpecies = space.split(comment)[i]
    for j in range(0, int(n_species[i]) ): # for each of that species...
        print " ",thisSpecies,"  ",positions[offset+j][0]," ",positions[offset+j][1]," ",positions[offset+j][2]
    offset = offset + int(n_species[i])
print "%ENDBLOCK positions_frac"
print

# we do some work to get the kpoints from the KPOINTS file
# basically kpoints are usually the 4-th line of the KPOINTS file...
kpinfile = open("KPOINTS","r",0)
for i in range(0,4):
    kpline = kpinfile.readline().strip()

print "KPOINTS_MP_GRID",kpline
print

# for the PSPs we guess the standard {species}_00PBE.usp are being used
print "%BLOCK SPECIES_POT"
for i in range(0,len(n_species)): # for each type of species...
    thisSpecies = space.split(comment)[i]
    print " ",thisSpecies,thisSpecies+"_00PBE.usp"
print "%ENDBLOCK SPECIES_POT"
print

print "FIX_ALL_CELL : true"
print "FIX_COM : false"
print

# now the constraints
print "%BLOCK IONIC_CONSTRAINTS"
offset = 0
globalConstraintNum = 0
for i in range(0,len(n_species)): # for each type of species...
    thisSpecies = space.split(comment)[i]
    for j in range(0, int(n_species[i]) ): # for each of that species...
        thisConstraintNum = offset + j
        if positions[offset+j][3] == 'F':
            globalConstraintNum = globalConstraintNum + 1
            print " ",globalConstraintNum,thisSpecies,thisConstraintNum," ","1 0 0"
        if positions[offset+j][4] == 'F':
            globalConstraintNum = globalConstraintNum + 1
            print " ",globalConstraintNum,thisSpecies,thisConstraintNum," ","0 1 0"        
        if positions[offset+j][5] == 'F':
            globalConstraintNum = globalConstraintNum + 1
            print " ",globalConstraintNum,thisSpecies,thisConstraintNum," ","0 0 1"
        

    offset = offset + int(n_species[i])
print "%ENDBLOCK IONIC_CONSTRAINTS"
print

