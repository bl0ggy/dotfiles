#!/bin/bash

# MacOS only, returns "how much" is the memory used.
if [ -n "$ZSH_VERSION" ]; then
    memory_pressure | grep perc | awk '{
        gsub(/%/, "", $NF);
        $NF=100-$NF;
        color="";
        if($NF >= 75) {
            color="#[fg=red]";
        } else if($NF >= 50) {
            color="#[fg=#ffee66]";
        }
        printf("%s%d%%#[fg=#{@thm_bg}]\n", color, $NF);
    }'
else
  free --kilo | awk '/Mem:/ {mem=$3/$2*100} END {printf("%.2f%%", mem)}'
fi
