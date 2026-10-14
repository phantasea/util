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
    bitrate=$(mediainfo "$filename" | grep 'Bit rate  ' | cut -d: -f2 | sed -e 's/\s//g')
    if [[ $bitrate =~ ^(64|96)\.[0-9]kb/s ]]; then
        echo $bitrate [skip]
        continue
    fi
    echo $filename [$bitrate]
    audconv -r${rate} "$filename"
    sleep 30s
done
