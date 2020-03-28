#!/usr/bin/env python3

import sys, re

for line in sys.stdin:
  # remove whitespace
  line = re.sub(r'[\s\n]', '', line)

  # ignore lines that are empty or start with semicolon
  if len(line) < 1 or line[0] == ';':
    continue

  # get four groups of eight bits
  bytes_ = [line[i:i+8] for i in range(0,32,8)]

  # reverse the order of the groups
  bytes_.reverse()

  # decode ascii bits into raw bytes
  bytes_ = bytes([int(b, 2) for b in bytes_])

  # print the decoded instruction
  sys.stdout.buffer.write(bytes_)
