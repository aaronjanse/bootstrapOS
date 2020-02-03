Almost everything you'll need is in the [ARMv8 Architecture Reference Manual][armv8-arm] and [Cortex-72A Processor Technical Reference Manual][cortex72a-trm]. I highly recommend downloading a copy of each PDF. Some of their contents are reproduced below.

[armv8-arm]: https://static.docs.arm.com/ddi0487/ca/DDI0487C_a_armv8_arm.pdf
[cortex72a-trm]: https://static.docs.arm.com/100095/0003/cortex_a72_mpcore_trm_100095_0003_05_en.pdf 

## Search Terms

| Term | Definition
|------|------------
| cortex-72a | the processor used by the Raspberry Pi 4
| broadcom bcm2711 | same as above (???)
| instruction encoding | the encoding for translating assembly into machine code

## Registers

[Cortex-72A Manual, Page 75](https://static.docs.arm.com/100095/0003/cortex_a72_mpcore_trm_100095_0003_05_en.pdf#page=75&zoom=auto,-12,749)

This is the fastest place to store data.

| Register | Description
|----------|-------------
| [MPIDR_EL1](https://static.docs.arm.com/100095/0003/cortex_a72_mpcore_trm_100095_0003_05_en.pdf#page=90&zoom=auto,-12,258) | This read-only identification register, among other things, provides a core identification number ([how to access](https://static.docs.arm.com/ddi0487/ca/DDI0487C_a_armv8_arm.pdf#page=2620&zoom=110,-33,627))
| r0-15 | General-purpose registers. Because we're writing our own assembly language, feel free to use these however you want

## Memory-mapped functionality

Many peripherals (external io stuff) are accessible through special memory addresses. The Raspberry Pi 4's peripherals document has not yet been released, so for now we'll use the RPi 3's [BCM2835 ARM Peripherals Manual](https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf).

### UART

[BCM2835 ARM Peripherals, Page 175](https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf#page=175&zoom=110,-110,807)  
[PrimeCell UART Technical Reference Manual](http://infocenter.arm.com/help/topic/com.arm.doc.ddi0183g/DDI0183G_uart_pl011_r1p5_trm.pdf#page=47&zoom=auto,-29,502)

[Register addresses](https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf#page=177&zoom=110,-110,280), with offset `0xFE201000` on raspi4

On QEMU, UART data can be sent/received by simply writing to/from `0xFE201000+0`, but on real hardware, you'll need to do some setup first.

For the following setup steps, use the BCM2836 Peripheral Manual's [GPIO address section](https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf#page=90&zoom=110,-110,652), replacing `0x7E20` with `0xFE20` for the raspi4.  Also see the manual's [UART address section](https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf#page=177&zoom=110,-110,280).
1. disable UART using the [UART control register](https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf#page=185&zoom=110,-110,325)
2. disable GPIO pin pull up/down
3. delay for 150 cycles (create a loop with a countdown)
4. disable GPIO pin pull up/down clock 0
5. delay for 150 cycles
6. disable GPIO pin pull up/down clock 0 (yeah, again; idk why)
7. clear all pending interrupts using the [UART interrupt clear register](https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf#page=192&zoom=110,-70,735) (write zero to the bits representing each interrupt you want to clear)
8. set baud rate to 115200 given a 3 Mhz clock (follow the PrimeCell UART Manual's [baud rate calculation example](http://infocenter.arm.com/help/topic/com.arm.doc.ddi0183g/DDI0183G_uart_pl011_r1p5_trm.pdf#page=56&zoom=auto,-29,199))
   1. write the baud rate divisor integer (BDR_I) to the [UART integer baud rate divisor register](https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf#page=183&zoom=110,-70,479)
   2. write the calculated fractional part (m) to the [UART fractional baud rate divisor register](https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf#page=183&zoom=110,-110,255)
9. enable FIFO and 8-bit data transmission using the [UART line control register](https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf#page=184&zoom=110,-70,645)
10. mask all interrupts using the [TODO...]


## Instructions

[ARMv8 Manual, Page 223](https://static.docs.arm.com/ddi0487/ca/DDI0487C_a_armv8_arm.pdf#page=223&zoom=auto,-4,576)

### Misc

#### Constants ("immediate" values)

The aarch64 instruction encoding is 32 bits wide, so we cannot store large constants into registers in a single command.

#### Logic Instructions (and/or/xor/etc)

[ARMv8 Manual, Page 6](https://static.docs.arm.com/ddi0487/ca/DDI0487C_a_armv8_arm.pdf#page=226)

#### Move System Register (MSR)

[ARMv8 Manual, Page 802](https://static.docs.arm.com/ddi0487/ca/DDI0487C_a_armv8_arm.pdf#page=802)

See the register summaries above for the parameters needed to access a specific system register.

### Load/Store
> [Rose Lowe cs2310 Slideshow](https://people.cs.clemson.edu/~rlowe/cs2310/notes/ln_arm_load_store.pdf)

#### Store, Pre-Index

[ARMv8 Manual, Page 901](https://static.docs.arm.com/ddi0487/ca/DDI0487C_a_armv8_arm.pdf#page=901&zoom=auto,-4,387)

```
31                  21 20             12 11 10 9     6           0
vv                   v v               v     v     vv          vv
'F'E'D'C'B'A'9'8'7'6'5'4'3'2'1'0 F E D C B A 9 8 7 6 5 4 3 2 1 0

 1 1 1 1 1 0 0 0 0 0 0 [ imm          9] 1 1 [ Rn   5][ Rt    5]
```

Reads the address `Rn + imm` from memory and stores it into `Rt`.

```
Rt <- *(Rn + imm)
```

#### Store, Post-Index
> [ARMv8 Manual, Page 901](https://static.docs.arm.com/ddi0487/ca/DDI0487C_a_armv8_arm.pdf#page=901&zoom=auto,-4,655)


Reads the address `Rn` from memory stores it into `Rt`, then updates `Rn` to `Rn + imm`.

```
Rt <- *Rn
Rn <- Rn + imm
```
