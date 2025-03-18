#!/bin/bash

# Sums all percentages and print the result.
# Not very accurate, quite slow.
ps -A -o %cpu | awk '{s+=$1} END {print s "%"}'
