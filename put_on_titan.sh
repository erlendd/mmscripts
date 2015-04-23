#! /bin/bash

if [ $# -lt 2 ]; then
  echo "Usage: put_on_titan.sh <local-file> <remote-file>"
  exit
fi

/usr/local/globus-5.2.3/bin/globus-url-copy -tcp-bs 12M -bs 12M -p 4 -v -vb file:${PWD}/${1} sshftp://dtn01.ccs.ornl.gov/ccs/home/erlend/${2}

