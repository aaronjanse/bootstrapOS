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
> [Cortex-72A Manual, Page 75](https://static.docs.arm.com/100095/0003/cortex_a72_mpcore_trm_100095_0003_05_en.pdf#page=75&zoom=auto,-12,749)

This is the fastest place to store data.

## Instructions
> [ARMv8 Manual, Page 223](https://static.docs.arm.com/ddi0487/ca/DDI0487C_a_armv8_arm.pdf#page=223&zoom=auto,-4,576)

### Load/Store
> [Rose Lowe cs2310 Slideshow](https://people.cs.clemson.edu/~rlowe/cs2310/notes/ln_arm_load_store.pdf)

#### Store, Pre-Index
> [ARMv8 Manual, Page 901](https://static.docs.arm.com/ddi0487/ca/DDI0487C_a_armv8_arm.pdf#page=901&zoom=auto,-4,387)

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
