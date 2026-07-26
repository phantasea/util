#!/bin/bash

dir=""
if [ $# == 1 ]; then
    [[ ! -d "$1" ]] && exit 1
    dir="$1"
elif [ $# == 2 ]; then
    [[ ! -d "$2" ]] && exit 1
    dir="$2"
else
    exit 1
fi

abspath=$(realpath $dir)
cd "$abspath"

rate=96
while getopts "r:" opt; do
    case $opt in
        r)
           rate="$OPTARG"
           ;;

        ?) echo 'Usage: batch_audconv [-r rate] <file>'
           exit 1;;
    esac
done

for filename in ./*.mp3; do
    echo $filename
    audconv -r${rate} "$filename"
    sleep 25s
done
