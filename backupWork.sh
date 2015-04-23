#! /bin/bash

# destination directory
DIR=/mnt/sshfs/ice
# name of the backup
FILE=${DIR}/`/bin/date -I`_work
# previous backup (PREV is without the extension and slice number)
PREV_=`/bin/ls $DIR/*.dar|/usr/bin/tail -n 1`
PREV=${PREV_%%.*}

# the initial backup:
#echo "Initial backup..."
#time sudo dar -v -c ${FILE} -z1 \
#              -Z "*.gz" -Z "*.bz2" -Z "*.rar" -Z "*.check" \
#              -Z "*.png" -Z "*.jpg" -Z "*.mpg" -Z "*.mp4" \
#              -Z "*.zip" -Z "*.ogg" -Z "*.mpeg" \
#              -Z "*.check_bak" -Z "*.7z" \
#              -X "wavecars.7z" -X "WAVECAR" -X "*.check*" -X "CHGCAR" \
#              -X "CHG" -X "d2phidk2.qcut10.30.dat" -X "phik.qcut10.30.dat" \
#              -R /mnt/mybook -g work
              
# the differential backup:
echo "Differential backup"
echo "Backing to up ${DIR}, using previous backups ${PREV}..."
echo
time sudo dar -v -c ${FILE} -z1 \
              -Z "*.gz" -Z "*.bz2" -Z "*.rar" -Z "*.check" \
              -Z "*.png" -Z "*.jpg" -Z "*.mpg" -Z "*.mp4" \
              -Z "*.zip" -Z "*.ogg" -Z "*.mpeg" \
              -Z "*.check_bak" -Z "*.7z" \
              -X "wavecars.7z" -X "WAVECAR" -X "*.check*" -X "CHGCAR" \
              -X "CHG" -X "d2phidk2.qcut10.30.dat" -X "phik.qcut10.30.dat" \
              -D -A ${PREV} \
              -R /mnt/mybook -g work


#time sudo dar -v -c /mnt/ice/dar_work_backup5 -z1 \
#              -Z "*.gz" -Z "*.bz2" -Z "*.rar" -Z "*.check" \
#              -Z "*.png" -Z "*.jpg" -Z "*.mpg" -Z "*.mp4" \
#              -Z "*.check_bak" -Z "*.7z" \
#              -P "wavecars.7z" -P "WAVECAR" -P "*.check*" -P "CHGCAR" \
#              -P "CHG" -P "d2phidk2.qcut10.30.dat" -P "phik.qcut10.30.dat" \
#              -D -A /mnt/ice/dar_work_backup4 \
#              -R /mnt/mybook -g work

