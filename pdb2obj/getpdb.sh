#!/bin/sh

#  getpdb.sh

#  get pdb file from protein databank ftp server. file is automatically 
#  extracted to directory specified by DATA_DIR and extension changed to '.pdb' 
#  usage: getpdb.sh <pdbid>
#    <pdbid> is lowercase, can be 4 letter code only or have .pdb extension
#  tammy@cs.duke.edu

PDBID=`basename $1 .pdb`  
ENTRY=pdb$PDBID.ent.Z
DATA_DIR=/usr/project/biogeo0/public_html/research/jefftammy/data/pdb/

wget ftp://ftp.rcsb.org/pub/pdb/data/structures/all/pdb/$ENTRY

if [ -f $ENTRY ]; then
    gunzip -c $ENTRY > $DATA_DIR/$PDBID.pdb
    rm -rf $ENTRY
fi

