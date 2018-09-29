#!/usr/bin/env python

lines = []
with open('chorst.instr_set.log', 'r') as f:
    for line in f:
        if line.startswith(' '):
            line = line.strip().split(',')
            line = line[1:]
            line = ','.join(line)
            lines.append(line)

unique_sets = list(set(lines))

print('\n'.join(unique_sets))
