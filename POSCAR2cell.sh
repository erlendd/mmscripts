#! /bin/bash

POSCAR=$1
STARTL=$2
ENDL=$3
SPECIES=$4

COUNTER=1
for line in $(tail -$ENDL $POSCAR | head -$STARTL); do
  # rule: read three (positions), skip three (true/false's).
  if [ $COUNTER -lt 4 ]; then
    # these are the positions, in order
    # 1x 1y 1z 2x 2y 2z 3x ...
    echo $line
    if [ $n == 1 ]; then
      cell_line = $SPECIES
    else
      if [ $n > 2 ]; then
      fi
    fi
  fi

  if [ $COUNTER -gt 5 ]; then
   COUNTER=0
  fi
  COUNTER=$((COUNTER+1))  
done

