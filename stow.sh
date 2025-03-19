#!/bin/bash

# Find all dirs and remove "./"
dirs=$(find . -type d -mindepth 1 -maxdepth 1 | awk '{gsub(/.\//, "", $1); print $1}')
stow -t ~/ ${dirs[@]}
