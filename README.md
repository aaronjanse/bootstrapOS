<!--
I personally dislike markdown for complex documents, but I think we should use it until we have some actual progress under our belts. Otherwise, we might waste all our time on documenation syntax without writing any actual content.

Same goes for organization; I think it'd be best if all documentation goes in the same file until it's unmanageable.

Regarding git commit messages: I wouldn't worry right now. We'll be making tons of changes, so at this point, git is more useful as sync-and-backup than version control. 
-->

## TODO
- Add nix expression for patched qemu-raspi4 to repo

## Intro

<!-- sources not yet linked to in this section:
https://www.bell-labs.com/usr/dmr/www/chist.html
-->

[Analogy of some yogurt fermentation process where old material is used to make new material].

Fermentation is similar to building compilers. New languages are written with old languages.

1. [Algol 60 was extended][algol-to-aed] to create the language AED.
2. [AED was used][aed-to-bcpl] to write the first BCPL compiler.
3. BCPL was used to create the first B compiler
4. B was used to re-implement the B compiler
   <!-- ^we need a footnote to clarify this bullet -->
5. The B compiler/langauge was iteratively transformed into the C language/compiler.

[algol-to-aed]: http://foldoc.org/Automated%20Engineering%20Design
[aed-to-bcpl]: http://foldoc.org/Automated%20Engineering%20Design

The typical "hello world" operating system starts with the C language, the fancy yogurt. We plan to create our yogurt from scratch.

**Goals**
- continue the "expanding toolset" feeling of nand2tetris
- provide readers with plenty of documentation
- leave non-frustrating exercises to the reader 

**Anti-Goals**
- accurately recreating the historical path to contemporary OSes
- re-implementing existing languages 

## The Plan

**What we'll do**
- setup hardware/software
- manually write kernel8.img file that sends "x" to UART
- implement echoing user input
- 

**User Features**
- ethernet
- netcat io <!-- instead of UART -->
- tls
  - v1.3
  - chacha20
  - poly1305
  - sha256
- gemini client
- gemini server

## Setting up Software

Use Nix.

## Machine Code

<!--
As far as I can tell, the kernel8.img file that RPis boot from is simply raw machine code with the following transformations:
1. Prefixed with a ton of zeros (0x80000 bytes, to be exact [1])
2. Appended with 0 < x <= 8 bytes of 0x00 to align to the nearest 8 bytes
3. Appended with `00 00 10 00 00 00 00 00 00 10 10 00 00 00 00 00` (although qemu seems to not fuss if these bytes are removed).

[1] number matches linker script at https://wiki.osdev.org/Raspberry_Pi_Bare_Bones#Linking_the_Kernel
-->

Machine code: the binary 1s and 0s seen flying across monitors in movies.

### Hello World




## Other Resources


https://web.archive.org/web/20140130143820/http://www.robinhoksbergen.com/papers/howto_elf.html

- [USB-to-UART](https://www.cpmspectrepi.uk/raspberry_pi/MoinMoinExport/USBtoTtlSerialAdapters.html#fndef-b76b0bf6b182dd6b0754e0434aae68695bf7b03f-0)
- [Netboot](https://brennan.io/2019/12/04/rpi4b-netboot/)


https://www.raspberrypi.org/forums/viewtopic.php?t=244479
https://elinux.org/RPi_Low-level_peripherals
https://cs140e.sergio.bz/docs/BCM2837-ARM-Peripherals.pdf
https://www.raspberrypi.org/documentation/hardware/raspberrypi/
https://www.elinux.org/RPi_Low-level_peripherals
https://raspberrypi.kavadocs.com/hardware/raspberrypi/bcm2711
https://www.raspberrypi.org/documentation/hardware/raspberrypi/bcm2711/README.md
https://github.com/rsta2/uspi
https://github.com/Chadderz121/csud



https://github.com/rsta2/circle/blob/master/lib/bcm54213.cpp
https://en.wikipedia.org/wiki/Media-independent_interface#Reduced_gigabit_media-independent_interface
