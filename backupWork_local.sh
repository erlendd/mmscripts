#! /bin/bash

# destination directory
DIR='/media/1TB FreeAgent/Backups'
# name of the backup
FILE="${DIR}"/`/bin/date -I`_work
# previous backup (PREV is without the extension and slice number)
PREV_=`/bin/ls "$DIR"/*.dar|/usr/bin/tail -n 1`
PREV=${PREV_%%.*}

# the initial backup:
echo "Initial backup"
echo "Backing to up ${DIR}"
echo "This backup will be ${FILE} ..."
echo 
time sudo dar -v -c "${FILE}" -z1 \
              -Z "*.gz" -Z "*.bz2" -Z "*.rar" -Z "*.check" \
              -Z "*.png" -Z "*.jpg" -Z "*.mpg" -Z "*.mp4" \
              -Z "*.zip" -Z "*.ogg" -Z "*.mpeg" \
              -Z "*.check_bak" -Z "*.7z" \
              -X "CHG" -X "d2phidk2.qcut10.30.dat" -X "phik.qcut10.30.dat" \
              -R /mnt/mybook -g work
              
## the differential backup:
#echo "Differential backup"
#echo "Backing to up ${DIR}, using previous backups ${PREV}."
#echo "Last backup was ${PREV_}."
#echo "This backup will be ${FILE} ..."
#echo
#time sudo dar -v -c "${FILE}" -z1 \
#              -Z "*.gz" -Z "*.bz2" -Z "*.rar" -Z "*.check" \
#              -Z "*.png" -Z "*.jpg" -Z "*.mpg" -Z "*.mp4" \
#              -Z "*.zip" -Z "*.ogg" -Z "*.mpeg" \
#              -Z "*.check_bak" -Z "*.7z" \
#	      -X "CHG" -X "d2phidk2.qcut10.30.dat" -X "phik.qcut10.30.dat" \
#              -D -A "${PREV}" \
#              -R /mnt/mybook -g work

