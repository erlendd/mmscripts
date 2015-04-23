#! /bin/bash

# remove the /home/erlend bit and replace spaces with underscores
DIR=`echo $PWD | cut -d'/' -f4- | sed -e 's/ /_/g'`
echo "Remote directory: "
echo ${DIR}

echo "Copying files to legion..."
#scp -C INCAR KOINTS POSCAR POTCAR script uccaeda@legion.rc.ucl.ac.uk:${DIR}/
mkdir -p /mnt/legion/jobs/${DIR}
cp * /mnt/legion/jobs/${DIR}/

echo "Logging on to legion..."
#JOBSUB=`ssh uccaeda@legion.rc.ucl.ac.uk "cd jobs/${DIR};qsub script"`
JOBSUB=`ssh uccaeda@legion.rc.ucl.ac.uk "cd jobs/${DIR};/cvos/shared/apps/torque/2.2.1/bin/qsub -S /bin/bash script"`

echo $JOBSUB
ID=${JOBSUB}
echo ${DIR} >> legion${ID}
echo ${ID}:/mnt/legion/jobs/${DIR} >> ~/.remoteJobs.dat

echo "Job submitted to legion!"

