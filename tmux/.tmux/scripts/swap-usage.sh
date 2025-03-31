#!/bin/bash

# Takes the total swap size and the used swap, then make a percentage.
sysctl vm.swapusage | awk '{
    gsub(/M/, "", $7);
    $7=$7/1000;
    color="";
    if($7 >= 1.5) {
        color="#[fg=red]";
    } else if($7 >= 1) {
        color="#[fg=#ffee66]";
    }
    printf("%s%.1fG#[gf=#{@thm_bg}]\n", color, $7);
}'
