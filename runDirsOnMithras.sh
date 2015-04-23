#! /bin/bash

if [ -z $1 ]; then
  NPROCS=8
else
  NPROCS=$1
fi

if [ -z $2 ]; then
  NAME="test"
else
  NAME=$2
fi

# remove the /home/erlend bit and replace spaces with underscores
DIR=`echo $PWD | cut -d'/' -f4- | sed -e 's/ /_/g'`
echo "Remote directory: "
echo ${DIR}

echo "Copying files to mithras..."
mkdir -p /mnt/mithras/jobs/${DIR}
sed -e "s/_PE_/$NPROCS/g" /home/erlend/scripts/clusterscripts/mithras_multivasp > script
cp dirs script /mnt/mithras/jobs/${DIR}
for subDir in $(cat ./dirs); do
  cp -a ${subDir} /mnt/mithras/jobs/${DIR}/
done

echo "Logging on to mithras..."
JOBSUB=`ssh -p2222 ermd@localhost "cd jobs/${DIR};qsub script"`

echo $JOBSUB
ID=`echo ${JOBSUB} | cut -d' ' -f3`
echo ${DIR} >> mithras${ID}

echo "Job submitted to mithras!"
