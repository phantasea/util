#!/bin/bash

[[ $# != 1 ]]   && exit 1
[[ ! -d "$1" ]] && exit 1

abspath=$(realpath "$1")
cd "$abspath"

for filename in ./*.mp3; do
    echo $filename
    audconv "$filename"
    sleep 25s
done
