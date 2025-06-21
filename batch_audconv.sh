#!/bin/bash
#
cd ~/temp
for filename in ./*.mp3; do
    audconv $filename
    sleep 45s
done
