#! /bin/bash

if [ `hostname` != "cheme141" ]; then
    exit
fi

echo "tunnel through ice: "
ssh -Nf -C -L 2222:mithras.lcn.ucl.ac.uk:22 ermd@ice.lcn.ucl.ac.uk

echo
echo "mounting remote filesystems..."
echo
echo "ice: "
sshfs -C ermd@ice.lcn.ucl.ac.uk:/storage /mnt/ice
echo "mithras: "
sshfs -p2222 -C ermd@localhost: /mnt/mithras
echo "legion: "
sshfs -C -o follow_symlinks \
         -o cache_stat_timeout=120 \
         -o cache_dir_timeout=120 \
         -o cache_link_timeout=60 \
 uccaeda@legion.rc.ucl.ac.uk: /mnt/legion
echo "cheme140(svn): "
sshfs -C -o follow_symlinks erlend@cheme140.chem.ucl.ac.uk: /mnt/cheme140
echo "cheme136(anna): "
sshfs -C -o follow_symlinks erlend@cheme136.chem.ucl.ac.uk: /mnt/cheme136 
echo "hector: "
sshfs -C -o follow_symlinks erlend@login.hector.ac.uk: /mnt/hector
#echo "hpcx: "
#sshfs -C -o follow_symlinks erlend@login.hpcx.ac.uk: /mnt/hpcx

