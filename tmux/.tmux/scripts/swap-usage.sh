#!/bin/bash

# Takes the total swap size and the used swap, then make a percentage.
sysctl vm.swapusage | awk '{gsub(/M/, "", $4); gsub(/M/, "", $7); printf("%d%%\n", $7/$4*100)}'
