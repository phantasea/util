#!/bin/bash
#

for filename in ./*.mp3; do
    echo $filename
    audconv "$filename"
    sleep 25s
done
