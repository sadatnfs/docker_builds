#!/bin/bash

INSTR_SETS="(sse|avx|fma)[^ ]*"

node=$(hostname -s)
pi=$(cat /proc/cpuinfo)
eg=$(echo "$pi" | egrep -o -m 1 "$INSTR_SETS")
ta=$(echo "$eg" | tr '\n' ',')
instr_sets=$(echo "$ta" | sed 's/,$//')

#instr_sets=$(cat /proc/cpuinfo | egrep -o -m 1 "$INSTR_SETS" | tr '\n' ',' | sed 's/,$//')

echo "$node,$instr_sets"
