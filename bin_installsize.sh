#!/bin/bash

TOTAL_SIZE=0
for directory in $(dir -Cw1 / | grep -v 'proc' | grep -v 'tmp' | grep -v 'run' | grep -v 'home' | grep -v 'media' | grep -v 'snap' | grep -v 'var' | grep -v 'swapfile'); do
    DIR_SIZE=$(sudo du -b --max-depth=0 "/$directory" | cut -f1 -d'/' | tr -d '[:blank:]')
    echo "$directory - $DIR_SIZE bytes"
    TOTAL_SIZE=$(($TOTAL_SIZE+$DIR_SIZE))
done
KB_SIZE=$(($TOTAL_SIZE/1024))
MB_SIZE=$(($KB_SIZE/1024))
GB_SIZE=$(($MB_SIZE/1024))
echo
printf '%s\n' "Total Install Size:
Bytes:       $TOTAL_SIZE
KiBs:        $KB_SIZE
MiBs:        $MB_SIZE
GiBs:        $GB_SIZE"
