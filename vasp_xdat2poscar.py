#! /usr/bin/python

import re

space = re.compile('\s+')

xdatstride = 100

pos_infile = open('POSCAR','r')
infile = open('XDATCAR','r')

def writePOSCAR(fn, metadata, positions, seldyn=None):
  outfile = file(fn, 'w')
  for i in range(len(metadata)):
    outfile.write( metadata[i]+'\n' )
  
  for i in range(len(positions)):
    outfile.write( positions[i] )
    if seldyn:
      outfile.write( ' '+seldyn[i] )
    outfile.write( '\n' )

  outfile.close()

def fixATOMS(seldyn, atoms_relax_idx):
  for i in range(len(seldyn)):
    if not i in atoms_relax_idx:
      seldyn[i] = 'F  F  F'

def createFS(metadata, positions, seldyn=None):
  # custom changes we can make to the three lists above...
  # first we need to fix the surface
  fixATOMS(seldyn, [4])
  # then bump the 5th H down to near the FS
  positions[4] = '0.2500000000000000  0.0000000000000000  0.3877881389821454'

# read the headers from the POSCAR
metadata = []
for i in range(9):
  line = pos_infile.readline()
  metadata.append( line.strip() )

n_each_species = [int(x) for x in space.split( metadata[6].strip() )]
natoms = sum(n_each_species)
print 'Found',natoms,' atoms'

# read the selective dynamic info from POSCAR
seldyn = []
for i in range(natoms):
  line = pos_infile.readline()
  dat = space.split( line.strip() )
  seldyn.append( ' '.join(dat[3:6]) )


# move to the right part of the XDATCAR file
for i in range(7):
  discard_this_line = infile.readline()

eof = False
poscount = 0

while True:
  poscount = poscount + 1
  discard_this_line = infile.readline()
  thispositions = []
  for i in range(natoms):
     pos = infile.readline().strip() 
     if not pos: 
       eof = True
       break;
     thispositions.append( pos )

  if eof: break;
  if not poscount%xdatstride == 0:
    print '  skipping idx '+str(poscount)+' from XDATCAR'
  else:
    print '* writing idx '+str(poscount)+' from XDATCAR'
    fixATOMS(seldyn, [4])
    writePOSCAR('POSCAR_4010_extracted_'+str(poscount), metadata, thispositions, seldyn)
    createFS(metadata, thispositions, seldyn)
    writePOSCAR('POSCAR_4001_projected_'+str(poscount), metadata, thispositions, seldyn)
