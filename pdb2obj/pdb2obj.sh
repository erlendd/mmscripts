#! /bin/bash
# pdb2obj.sh                                         tammy@cs.duke.edu
# --------------------------------------------------------------------
# generate interface surface from pdb file and save in OBJ format
# usage:  ./pdb2is.sh pdbid.pdb -C <chains>
# output: pdbid.is.obj       - faces as triangles
#         pdbid.is.poly.obj  - faces as voronoi polygons
# --------------------------------------------------------------------

SCRIPT=pdb2obj.sh

if [ $# -lt 1 ]; then  # check for command-line args
    echo ""
    echo "usage:  ./$SCRIPT pdbid.pdb -C <chains>"
    echo ""
    exit 0
fi

# set directory paths, change as necessary
DATA_DIR=.
#DATA_DIR=/usr/project/biogeo0/public_html/research/jefftammy/data
BIN_DIR=/home/erlend/scripts/bin/pdb2obj
OBJ_DIR=$DATA_DIR/obj
ARB_DIR=$DATA_DIR/arb
PDB_DIR=$DATA_DIR
NEKO_DIR=$DATA_DIR/neko

# variables
ARBV=is.vertices.arb
ARBT=0.triangles.arb
ARBP=0.vorPoly.arb
#PDBID=${1:0:4}
PDBID=$1
ARGS=${*%$1}

# check if we have pdb file already - if not, try to get it 
#[ -f $PDB_DIR/$PDBID.pdb  ] || $BIN_DIR/getpdb.sh $PDBID

# compare pdb chains to those specified by input args 
CHAINS=`$BIN_DIR/chains.pl $PDBID`
CHAINS=${CHAINS:5}
for CHAIN in ${ARGS#*-C}
do
    if [ `expr index "$CHAIN" "$CHAINS"` -eq 0 ]; then
        echo ""
        echo " ---> $SCRIPT: no such chain $CHAIN" 
        echo " --->" all chains for $PDBID: $CHAINS
        echo ""
        exit 0;
    fi
done

echo "wants file $PDB_DIR/$PDBID ... "
if [ -f $PDB_DIR/$PDBID ]; then

    for file in $( find $PDB_DIR/ -type f -name $PDBID.pdb -user $USER )
    do
        chmod 664 $file
    done

    if [ "$ARGS" ]; then 

        # check if we have already created neko file 
        if [ -f $NEKO_DIR/$PDBID.neko ]; then

            # compare neko chains to those specified by input args 
            CHAINS=`$BIN_DIR/neko-chains.sh $PDBID`
            for CHAIN in ${ARGS#*-C}
            do
                if [ `expr index "$CHAIN" "$CHAINS"` -eq 0 ]; then
                    $BIN_DIR/surface.sh $PDB_DIR/$PDBID.pdb $ARGS
                    break
                fi
            done
        else
            $BIN_DIR/surface.sh $PDB_DIR/$PDBID.pdb $ARGS
        fi
        if [ -f $PDBID.neko ]; then
            mv $PDBID.neko $NEKO_DIR
        fi

    else
        if [ -f $NEKO_DIR/$PDBID.neko ]; then
            CHAINS=`$BIN_DIR/neko-chains.sh $PDBID`
            echo ""
            echo " ---> $SCRIPT: '$PDBID.neko' generated with chains $CHAINS" 
            echo " --->"         using chains $CHAINS for OBJ output
            echo " --->"         all chains for $PDBID: $CHAINS
            echo ""
        else
            CHAINS=`$BIN_DIR/chains.pl $PDBID`
            echo ""
            echo "usage: ./$SCRIPT pdbid.pdb -C <chains>"
            echo " ---> $SCRIPT: no chains specified!" 
            echo " --->" all chains for $CHAINS
            echo ""
            exit 0
        fi
    fi

    if [ -f $NEKO_DIR/$PDBID.neko ]; then

        for file in $( find $NEKO_DIR/ -type f -name $PDBID.neko -user $USER )
        do
            chmod 664 $file
        done

        # export interface surface vertices and faces from neko file
        cd $NEKO_DIR
        $BIN_DIR/export.sh $PDBID.neko $ARGS -vertices -vorPoly 

        if [ -f $PDBID.$ARBV ]; then
            mv $PDBID.$ARBV $ARB_DIR
        else
            exit 0
        fi
        if [ -f $PDBID.$ARBP ]; then
            mv $PDBID.$ARBP $ARB_DIR
        else
            exit 0
        fi
  
        # convert arb file format to obj file format  
        cd $ARB_DIR

        for file in $( find $ARB_DIR/ -type f -name $PDBID'.*' -user $USER )
        do
            chmod 664 $file
        done

        if [ -f $PDBID.$ARBV ]; then
            if [ -f $PDBID.$ARBP ]; then
                $BIN_DIR/poly2tobj.pl $PDBID.$ARBV $PDBID.$ARBP
            else
                exit 0
            fi
        else
            exit 0
        fi

        for file in $( find $OBJ_DIR/ -type f -name $PDBID.'*' -user $USER )
        do
            chmod 664 $file
        done
    
    else
        echo ""
        echo "---> $SCRIPT: no such file '$PDBID.neko'"
        echo ""
        exit 0
    fi
else
    echo "" 
    echo "---> $SCRIPT: no such pdb '$PDBID'" 
    echo ""
    exit 0
fi

echo ""
echo "goodbye!"
echo ""
exit 0
