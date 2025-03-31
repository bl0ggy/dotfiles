#!/bin/bash

# Sums all percentages and print the result.
# Not accurate at all, can go above 200% (what?).
# Quite slow.
# ps -A -o %cpu | awk '{s+=$1} END {print s "%"}'

# Much faster with average over 1min
cores=$(sysctl hw.logicalcpu | awk '{ print $2 }')
load1min=$(sysctl vm.loadavg | awk '{ print $3 }')
echo "$cores $load1min" | awk '{ printf("%d%%", $2/$1*100) }'
