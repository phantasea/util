#!/bin/bash

for file in ./* ; do
    #mogrify -resize ${ratio:-80}% "$file"
    pio "$file" --quality ${ratio:-80} --output $file.webp > /dev/null 2>&1
    sleep 3s
done
