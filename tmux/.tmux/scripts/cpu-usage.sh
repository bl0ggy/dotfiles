#!/bin/bash

# Sums all percentages and print the result.
# Not accurate at all, can go above 200% (what?).
# Quite slow.
# ps -A -o %cpu | awk '{s+=$1} END {print s "%"}'

if [ -n "$ZSH_VERSION" ]; then
    # Much faster with average over 1min
    cores=$(sysctl hw.logicalcpu | awk '{ print $2 }')
    load1min=$(sysctl vm.loadavg | awk '{ print $3 }')
    echo "$cores $load1min" | awk '{ printf("%d%%", $2/$1*100) }'
else
    awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else print ($2+$4-u1) * 100 / (t-t1) "%"; }' <(grep 'cpu ' /proc/stat) <(sleep 1;grep 'cpu ' /proc/stat) | awk '{ printf("%d%%", $1) }'
fi
