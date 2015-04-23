#!/usr/bin/awk -f

# (c) by alex, no support
# some issues with many different atom types
# writes an xyz-file on stdout, which is useful for molden or xmol
# it duplicates the cell in a and b direction, not c (useful for surfaces)

BEGIN {

i = 0


# tag for lattice vector reading: read from lattice_read = 1 up to 3
lattice_read = 0
lattice = 0


# tag for atomic position reading
pos_read = 0
position = 0

# tag for opt-cycle
cycle = 0
# tag for finished optcycle (Version 4.5+ only)
optcycle_finished = 0

# tag for ion types
type = 0
number = 0
# initialize
total = 0

}



# READ DATA

{

# collect ions per type from output
# ions per type = 2 4
if ($1 == "ions" && $2 == "per" && $3 == "type") {
for ( j = 1 ; j <= (NF-4) ; j++ ){
ij = 4+j
number++
ionnumber[j]=$ij
# print("number ",number, ionnumber[j])
}
}

# collect ion types from output
if ($1 == "POTCAR:") {
type++
iontype[type]=$3
# print ("type ",type,iontype[type] )
}


# number of dos NEDOS = 301 number of ions NIONS = 68
# read number of ions

if (NF == 12 && $10 == "NIONS") {
nions = $12
}

optcycle_finished++

# FREE ENERGIE OF THE ION-ELECTRON SYSTEM (eV)
# ---------------------------------------------------
if (NF == 7 && $1 == "FREE" && $2 == "ENERGIE" && $3 == "OF" && $4 == "THE" ) {
optcycle_finished = -2
}


# free energy TOTEN = -593.169883 eV
# read total energy after complete SCF

if (NF == 6 && $3 == "TOTEN" && optcycle_finished == 0) {
cycle++
energy[cycle] = $5
}



# read lattice vector in direct coordinates
# for this we have to read three lines after "direct lattice vectors"

if (lattice_read == 1 ){
a[cycle,lattice,1] = $1
a[cycle,lattice,2] = $2
a[cycle,lattice,3] = $3
# print(a[cycle,lattice,1],a[cycle,lattice,2],a[cycle,lattice,3])

lattice++

if (4==lattice) {
lattice_read = 0
lattice = 0
}
}

if (NF == 6 && $1 == "direct" && $2 == "lattice" && $3 == "vectors"){
lattice_read = 1
lattice = 1
}





# read atomic in cartesian coordinates
# for this we have to read three lines after "direct lattice vectors"

if (pos_read == 1 ){
b[cycle,position-1,1] = $1
b[cycle,position-1,2] = $2
b[cycle,position-1,3] = $3
# print(b[cycle,position,1],b[cycle,position,2],b[cycle,position,3])

position++

if ((position-2) == nions) {
pos_read = 0
position = 0
}
}

if (NF == 3 && $1 == "POSITION" && $2 == "TOTAL-FORCE" && $3 == "(eV/Angst)"){
pos_read = 1
position = 1
}
}



END {



# generate type/number pairs (easier to handle during printing)
for ( k = 1 ; k <= number ; k++ ){
for ( j = 1 ; j <= ionnumber[k] ; j++ ){
total++
ion[total] = iontype[k]
# print(total, ion[total], k,j,iontype[k])
}
}


# print all information per cycle

for (cyc = 1 ; cyc <= cycle-1 ; cyc++) {

# print number of ions
print nions

# print cycle & energy
printf("ene:%8i%15.6f%s\n", cyc, energy[cyc], " eV")


# print ionposition in cartesian coordinates
for ( j = 1 ; j <= nions ; j++ ){
printf("%s %10.5f%10.5f%10.5f\n", ion[j], b[cyc,j,1], b[cyc,j,2], b[cyc,j,3])
}
}

} 
