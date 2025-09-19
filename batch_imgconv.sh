#!/bin/bash

ratio=${1:-60}
for filename in ./* ; do
    mogrify -resize ${ratio}% "$filename"
    sleep 5s
done
