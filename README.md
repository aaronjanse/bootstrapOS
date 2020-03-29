# bootstrapOS

Many OS tutorials start in assembly or C++. We start in machine code.

In this Raspberry Pi 4 tutorial, we'll write a self-hosted assembler in machine code. We'll then evolve that compiler (by implementing new features then using those features in the compiler source code) into something capable of wrangling a high-level language. Finally, in our high-level language, where most tutorials start, we'll write a simple web server to one day host the tutorial's own documentation.

### Progress

**Milestone: bootstrap machine code 🎉**
- [x] print to qemu uart
- [x] properly setup uart, wait for write, print 'x'
- [x] wait for read, read, print uart input
- [x] write all to memory then dump memory in
- [x] copy mem_in to mem_out then modify above code to print mem_out
- [x] use bytes to indicate length of output
- [x] routine to read a certain number of bits to memory, use it to copy machine code
- [x] remove leading whitespace, `;` command for comments
- [x] print raw binary

**Milestone: big-endian machine code 🎉**
- [x] print binary in little-endian form
- [x] rewrite codebase in big-endian form (ehh, leave most formatting for later)

**Milestone: labeled goto 🎉**
- [x] `J`: relative branch with binary
- [x] `L`: label for goto (read into memory tape with scheme `pos4 name \0`)
- [x] `GOTO`: goto label
- [x] rewrite codebase using labeled GOTOs 

**Milestone: conditional goto**
- [ ] `GOEQ`
- [ ] `GONE`
- [ ] `GOGT`
- [ ] rewrite codebase using conditional goto

**Milestone: labeled functions**
- [ ] `CALL`: "goto" but with linked branching
- [ ] rewrite codebase to use functions
- [ ] `RET`: return after function call; rewrite codebase

**Milestone: easy for compiler phase to output string**
- [ ] `OUT`: copy verbatim the rest of the line to out
- [ ] `OUTLN`: output newline
- [ ] `UW`: wait for uart writing to be ready
- [ ] `UR`: wait for uart reading to be ready

**Milestone: bootstrap assembly**
- [ ] `SET reg value`: set the value of a register
- [ ] parse chars (e.g. `'!'`)
- [ ] `ADD reg reg value`: set the value of a register
- [ ] `SUB reg reg value`: set the value of a register
- [ ] `COPY reg reg`: copy the value of one register to another
- [ ] `LDBR reg reg_mem`: load a byte
- [ ] `STBR reg reg_mem`: store a byte
- [ ] `ORR reg reg (reg >>/<< value)`
