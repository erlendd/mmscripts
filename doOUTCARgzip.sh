#! /bin/bash

echo $1
if [ ! -f "$1.gz" ]; then
  size=`du -sh "${1}" | awk '{print $1}'`
  echo "    Original size: ${size}"

  echo "    Compressing $1..."
  gzip -9 "$1"
  echo "    Done."
  size=`du -sh "$1.gz" | awk '{print $1}'`
  echo "    Compressed size: ${size}"
fi

