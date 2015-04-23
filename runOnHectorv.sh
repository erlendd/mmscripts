#! /bin/bash

# remove the /home/erlend bit and replace spaces with underscores
DIR=`echo $PWD | cut -d'/' -f5- | sed -e 's/ /_/g'`
echo "Remote directory: "
echo ${DIR}

echo "Copying files to hector..."
#scp -C INCAR KOINTS POSCAR POTCAR script uccaeda@legion.rc.ucl.ac.uk:${DIR}/
mkdir -p /mnt/hectorxt6/work/jobs/${DIR}
cp * /mnt/hectorxt6/work/jobs/${DIR}/

echo "Logging on to hector..."
#JOBSUB=`ssh uccaeda@legion.rc.ucl.ac.uk "cd jobs/${DIR};qsub script"`
JOBSUB=`ssh erlend@phase2a.hector.ac.uk "cd work/jobs/${DIR};qsub script_hector"`

echo $JOBSUB
ID=${JOBSUB}
echo ${DIR} >> hectorv${ID}
echo ${ID}:/mnt/hector/work/jobs/${DIR} >> ~/.remoteJobs.dat

echo "Job submitted to hector (vector)!"

