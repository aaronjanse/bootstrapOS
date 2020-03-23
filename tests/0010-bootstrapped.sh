#!/usr/bin/env bash

function compile-machine-code() {
  { # replace leading whitespace
    sed 's/[ \t]\+//g' } |
  { # skip lines that start with a semicolon
    grep -v '^;' } |
  { # replace newlines with spaces
    tr '\n' ' ' } |
  { # delete spaces
    sed 's/ //g' } |
  { # capture four groups of eight bits, print the groups out backwards
    sed 's/\([01]\{8\}\)\([01]\{8\}\)\([01]\{8\}\)\([01]\{8\}\)/\4\3\2\1/g' } |
  ( # print a statement that tells `bc` to convert binary to hex
    echo 'obase=16;ibase=2' ;
    # print out bits in groups of four on their own lines with semicolons
    sed -Ee 's/[01]{4}/;\0\n/g' |
    # add another newline to the end
    xargs echo ) |
  { # pipe everything into basic calculator
    bc } |
  { # replace newlines with spaces
    tr '\n' ' ' } |
  { # delete spaces
    sed 's/ //g' } |
  { # format lines with one hex char each into "\xff"-like representation
    sed 's/\([0-9A-F]\{2\}\)/\\\\x\1/gI'
  } |
  { # provide all this as an argument of `printf`
    xargs printf
  }
}


function compile-machine-code() {
  sed 's/[ \t]\+//g' | grep -v '^;' |
  tr '\n' ' ' | sed 's/ //g' |
  sed 's/\([01]\{8\}\)\([01]\{8\}\)\([01]\{8\}\)\([01]\{8\}\)/\4\3\2\1/g' |
  ( echo 'obase=16;ibase=2' ;
    sed -Ee 's/[01]{4}/;\0\n/g' |
    xargs echo ) | bc |
  tr '\n' ' ' | sed 's/ //g' |
  sed 's/\([0-9A-F]\{2\}\)/\\\\x\1/gI' | xargs printf
}

kernel_file=$(mktemp)
cat "$1" | compile-machine-code > $kernel_file

compiled_kernel=$(cat "$1" | python3 compile-using.py $kernel_file)

cat $kernel_file | hexyl | head -5
echo "$compiled_kernel" | hexyl | head -5

