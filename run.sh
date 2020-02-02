#!/usr/bin/env bash

aarch64-none-elf-as -c boot.S -o boot.o
# aarch64-none-elf-gcc -ffreestanding -c kernel.c -o kernel.o -O2 -Wall -Wextra
# had kernel.o:
aarch64-none-elf-gcc -T linker.ld -o myos.elf -ffreestanding -O2 -nostdlib boot.o -lgcc
# https://forum.osdev.org/viewtopic.php?t=33838
aarch64-none-elf-objcopy myos.elf -O binary kernel8.img
qemu-system-aarch64 -M raspi4 -nographic -monitor none -kernel myos.elf
#myos.elf
