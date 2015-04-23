#! /bin/bash

if [ $# -lt 2 ]; then
  echo "Usage: get_from_titan.sh <remote-file> <local-file>"
  exit
fi

/usr/local/globus-5.2.3/bin/globus-url-copy -tcp-bs 12M -bs 12M -p 4 -v -vb sshftp://dtn01.ccs.ornl.gov/ccs/home/erlend/${1} file:${PWD}/${2} 

