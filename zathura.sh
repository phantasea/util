#!/bin/bash

# This script is for launching zathura in a tabbed enviornment,
# and placing every subsequent instance of zathura in that enviornment.

# Focus zathura on opening a new file
focus=1
xid_file="$HOME/.config/zathura/xid"

# Open tabbed if necessary
if ! ps -e | grep 'zathura$'; then
    [ $focus ] && num_wins=$(wmctrl -l | wc -l)
    tabbed -cd zathura "$1" -e 1>$xid_file 2>/dev/null &
    if [ $focus ]; then
        while [ $num_wins -eq $(wmctrl -l | wc -l) ]; do
            sleep 0.0001
        done
        read xid < $xid_file
        wmctrl -ir $xid -b add,maximized_vert,maximized_horz
    fi

    shift
fi

# Open the rest of the files into tabbed
if [ "$#" -gt 0 ]; then
    read xid < $xid_file
    zathura -e $xid "$@" 2>/dev/null &
    if [ $focus ]; then
        wmctrl -ir $xid -b add,above
        wmctrl -ir $xid -b remove,above
    fi
fi

# Switch to i3 "misc" workspace
i3-msg workspace "misc" >/dev/null
