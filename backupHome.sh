#! /bin/bash

time sudo dar -v -c /mnt/ice/dar_home_backup -z1 \
              -Z "*.gz" -Z "*.rar" -Z "*.check" \
              -P MOVED_TO_MYBOOK \
              -P Music \
              -P .VirtualBox \
              -P .nw \
              -P .cache -P .wine -P Dropbox -P .thumbnails \
              -K: -g ./

