#!/bin/bash

# Sums all percentages and print the result.
# Not accurate at all, can go above 200% (what?).
# Quite slow.
ps -A -o %cpu | awk '{s+=$1} END {print s "%"}'
