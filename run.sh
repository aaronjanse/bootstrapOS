#!/usr/bin/env bash

aarch64-none-elf-as -c boot.S -o /tmp/boot.o
# aarch64-none-elf-gcc -ffreestanding -c kernel.c -o kernel.o -O2 -Wall -Wextra
# had kernel.o:
aarch64-none-elf-gcc -T linker.ld -o /tmp/myos.elf -ffreestanding -O2 -nostdlib /tmp/boot.o -lgcc
# https://forum.osdev.org/viewtopic.php?t=33838
aarch64-none-elf-objcopy /tmp/myos.elf -O binary /tmp/kernel8.img
qemu-system-aarch64 -M raspi4 -nographic -monitor none -kernel /tmp/kernel8.img
#  -monitor none
#/tmp/myos.elf
#myos.elf
