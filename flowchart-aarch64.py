#!/usr/bin/env python3

import sys
import re

print("digraph g {")

branchPattern = re.compile(r"^b(?:\...)? 0x([0-9a-f]+)")

lines = [line.strip() for line in sys.stdin]

# the split is the index of the last item
splits = []

pos = 0
for line in lines:
  match = branchPattern.match(line)
  if match:
    destPos = match.group(0).split(' ')[1]
    destPos = int(destPos, 16)//4
    splits.append(pos)
    splits.append(destPos-1)
  pos += 1

splits.sort()

blocks = []
currentBlock = []

for i, line in enumerate(lines):
  currentBlock.append(line)
  if i in splits:
    blocks.append(currentBlock)
    currentBlock = []

if len(currentBlock) > 0:
  blocks.append(currentBlock)

for i, block in enumerate(blocks):
  label = '\\n'.join(block)
  print('a{} [label="{}", shape=box]'.format(i, label))

  match = branchPattern.match(block[-1])
  if match:
    if i < len(blocks) - 1 and match.group(0).startswith('b.'):
      print("a{} -> a{}".format(i, i+1))

    destPos = match.group(0).split(' ')[1]
    destPos = int(destPos, 16)//4

    destBlockIdx = 0
    currentDestPos = 0
    for di, b in enumerate(blocks):
      if currentDestPos + len(b) < destPos:
        destBlockIdx += 1
        currentDestPos += len(b)
      else:
        print("a{} -> a{} [color=blue]".format(i, destBlockIdx+1))
        break
  elif i < len(blocks) - 1:
    print("a{} -> a{}".format(i, i+1))



print("}")
