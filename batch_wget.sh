#!/bin/bash

#for i in {00..29}
for i in $(seq -w 315 746)
do
    wget -q --no-use-server-timestamps \
        "http://aastory.space/read-178$i.html" \
        --referer="http://aastory.space/"
done
