#! /bin/bash

INFILE=$1
STARTL=$2
ENDL=$3 # not used yet.

mv $INFILE $INFILE.fdbak

# Taken from:
#  http://www.linuxtopia.org/online_books/\
#  linux_tool_guides/the_sed_faq/sedfaq3_006.html
sed -e "$STARTL,$ENDL{:a;N;s/T/F/g;}" $INFILE.fdbak > $INFILE


