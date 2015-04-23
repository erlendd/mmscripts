#! /bin/bash

machine[0]="hector"
machine[1]="legion"
machine[2]="unity"
machine[3]="ironhill"
machine[4]="galaxy"
machine[5]="iridis"

for m in ${machine[*]}; do
    echo "Checking ${m}..."
    n=`mount | grep -c /mnt/sshfs/${m}`
    if [ $n -lt 1 ]; then
        echo "    needs mounting."
        sshfs -o follow_symlinks ${m}: /mnt/sshfs/${m} &
    fi
done

echo "Waiting for mounts to finish"
wait

echo
echo "The following sshfs mounts are active"
mount | grep /mnt/sshfs | awk '{print $3}'

