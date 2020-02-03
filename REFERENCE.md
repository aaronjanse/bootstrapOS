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

## Instructions

[ARMv8 Manual, Page 223](https://static.docs.arm.com/ddi0487/ca/DDI0487C_a_armv8_arm.pdf#page=223&zoom=auto,-4,576)

### Misc

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
