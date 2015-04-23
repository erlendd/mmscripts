#! /bin/bash

# remove the /home/erlend bit and replace spaces with underscores
DIR=`echo $PWD | cut -d'/' -f4- | sed -e 's/ /_/g'`
echo "Remote directory: "
echo ${DIR}

echo "Copying files to mithras..."
#scp -C -p2222 INCAR KOINTS POSCAR POTCAR script ermd@localhost:${DIR}/
mkdir -p /mnt/mithras/jobs/${DIR}
cp INCAR KPOINTS POSCAR POTCAR script /mnt/mithras/jobs/${DIR}/

echo "Logging on to mithras..."
JOBSUB=`ssh -p2222 ermd@localhost "cd jobs/${DIR};qsub script"`

echo $JOBSUB
ID=`echo ${JOBSUB} | cut -d' ' -f3`
echo ${DIR} >> mithras${ID}

echo "Job submitted to mithras!"

