#! /bin/bash

for x in $(ls *.tar.gz); do
  echo ${x}...
  mkdir -p recompressWAVECAR.tmp
  echo -n "Uncompressing original... "
  tar xzf ${x} -C recompressWAVECAR.tmp
  echo " done"
  cd recompressWAVECAR.tmp
  echo -n "Removing CHG files... "
  find -name CHG -exec rm '{}' \;
  echo " done"
  echo -n "Compressing CHGCAR/WAVECAR files... "
  vasp-compressWAVECAR.sh
  echo " done"
  thisdirectory=`basename ${x} .tar.gz`
  echo -n "Recompressing to ${x}... "
  tar czf ${x} ${thisdirectory}
  echo " done"
  cd ..
  sleep 7200
done

