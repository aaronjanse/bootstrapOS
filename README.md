# bootstrapOS

Many OS tutorials start in assembly or C++. Weak sauce.

In this Raspberry Pi 4 tutorial, we write a self-hosted compiler in machine code. We then evolve that compiler (by implementing new features then using those features in the compiler source code) into something capable of wrangling a high-level language. Finally, in our high-level language, where most tutorials start, we write a simple web server to one day host the tutorial's own documentation.

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

**Milestone: big-endian machine code**
- [x] print binary in little-endian form
- [ ] rewrite codebase in big-endian form

**Milestone: labeled functions and goto (labeled, linked branching)**
- [ ] var-length binifying
- [ ] decimal parsing (with negatives; slurp trailing whitespace)
- [ ] `JUMP`: relative branch with decimal
- [ ] `FN`: function labels (read into memory tape with scheme `pos4 name \0`)
- [ ] `CALL`: abs-pos linking branch with label (keep track of current instruction number)
- [ ] rewrite codebase to use functions
- [ ] `L`: label for goto
- [ ] `GOTO`: goto label
- [ ] rewrite codebase to use labeled goto

**Milestone: easy for compiler phase to output string**
- [ ] `OUT`: copy verbatim the rest of the line to out
- [ ] `OUTLN`: output newline
- [ ] `UW`: wait for uart writing to be ready
- [ ] `UR`: wait for uart reading to be ready

**Milestone: conditional jumping**
- [ ] `JEQ`
- [ ] `JNE`
- [ ] `JGT`
- [ ] `CMP`
- [ ] register names

**Milestone: bootstrap assembly**
- [ ] `SET reg value`: set the value of a register
- [ ] parse chars (e.g. `'!'`)
- [ ] `ADD reg reg value`: set the value of a register
- [ ] `SUB reg reg value`: set the value of a register
- [ ] `COPY reg reg`: copy the value of one register to another
- [ ] `LDBR reg reg_mem`: load a byte
- [ ] `STBR reg reg_mem`: store a byte
- [ ] `ORR reg reg (reg >>/<< value)`
