#!/bin/bash

# MacOS only, returns "how much" is the memory used.
memory_pressure | grep perc | awk '{print $NF}'
