#!/bin/bash

# MacOS only, returns "how much" is the memory used.
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
