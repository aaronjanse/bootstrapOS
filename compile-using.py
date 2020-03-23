#!/usr/bin/env python3

import sys
from subprocess import Popen, PIPE, STDOUT
import os
import tempfile

# read input file into temp file to bypass qemu bash <() syntax buf

with open(sys.argv[1], "rb") as f:
  kernel = f.read()

tmp_fd, tmp_path = tempfile.mkstemp()

with os.fdopen(tmp_fd, 'wb') as tmp:
  tmp.write(kernel)

cmd = [
  "qemu-system-aarch64",
  "-M", "raspi4",
  "-nographic",

  "-serial", "mon:stdio",
  "-monitor", "telnet::45454,server,nowait",

  # "-monitor", "none",
  "-kernel", tmp_path]

p = Popen(cmd, stdout=PIPE, stdin=PIPE, stderr=STDOUT) 
p.stdin.write((''.join(sys.stdin.readlines()).rstrip() + '\n\x00').encode())
p.stdin.close()

num_bytes = 0
num_bytes = (num_bytes << 8) + ord(p.stdout.read(1))
num_bytes = (num_bytes << 8) + ord(p.stdout.read(1))
num_bytes = (num_bytes << 8) + ord(p.stdout.read(1))
num_bytes = (num_bytes << 8) + ord(p.stdout.read(1))

for _ in range(num_bytes):
  sys.stdout.buffer.write(p.stdout.read(1))

p.terminate()

os.remove(tmp_path)