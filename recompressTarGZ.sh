#! /bin/bash

# clean start
rm -r /tmp/recompress.e >/dev/null
rm /tmp/targz.log >/dev/null
rm /tmp/torecompress.log >/dev/null

# list of .tar.gz files:
find . -name "*.tar.gz" -exec echo '{}' >> /tmp/targz.log \;

# remove duplicates:
sort -u /tmp/targz.log > /tmp/utargz.log

# check while ones have CHG/CHGCAR/WAVECAR:
for x in $(cat /tmp/utargz.log); do
  echo "Checking contents of $x ..."
  tar -tvzf $x > /tmp/tarlist.txt 2>/dev/null
  nW=`grep -c WAVECAR /tmp/tarlist.txt` # WAVECAR
  nC=`grep -c CHGCAR /tmp/tarlist.txt`  # CHGCAR
  nH=`grep -c CHG /tmp/tarlist.txt`     # CHG
  n=$((nH+nC+hW))
  if [ $n -gt "0" ]; then
    echo "** File $x contains CHG/CHGCAR/WAVECAR files. **"
    echo $x >> /tmp/torecompress.log
  fi
done

# go through each one, extract it clean/compress and then retar it:
mkdir /tmp/recompress.e
rundir=$PWD
for x in $(cat /tmp/torecompress.log); do
  echo "Recompressing $x ..."
  fn=`basename $x`
  tar xvzf $x -C /tmp/recompress.e #>/dev/null
  cd /tmp/recompress.e
  # get rid of the CHG files
  find -name CHG -exec du -sh '{}' \;
  find -name CHG -exec rm '{}' \;
  # 7zip the CHGCAR/WAVECARS
  vasp-compressWAVECAR.sh #>/dev/null
  # recompress it
  echo $PWD
  tar cvzf $fn . #>/dev/null
done

