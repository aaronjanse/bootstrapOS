<!-- DO NOT WRITE IN THIS DOCUMENT ANYMORE -->

# Geneology
<!-- https://www.bell-labs.com/usr/dmr/www/chist.html -->

<!--
Algol X was AFTER AED-0

-->

The Algol language was extended into AED [citation needed]
The first BCPL compiler was written in AED
Ken Thomson used a BCPL compiler to write the B compiler.
He then used the B language to re-implement the B compiler.
The bootstrapped B compiler was gradually transformed into New B, then later C.

Sources:
- AED is based on Algol 60: http://dspace.mit.edu/bitstream/handle/1721.1/755/FR-0351-19563962.pdf?sequence=1 ; http://foldoc.org/Automated%20Engineering%20Design
- AED -> BCPL: https://www.quora.com/C-programs-are-compiled-using-gcc-which-itself-is-written-in-C-so-how-code-for-gcc-is-compiled
- BCPL -> C: https://www.bell-labs.com/usr/dmr/www/chist.html

# Our Plan

- write elf body compiler in elf
- write basic assembler in elf body
- gradually replace elf body with assembly
- evolve into stack language

Stack language notes:
- I could have a `load` command that pops an address off the top of the stack and push the corresponding value in memory. Same applies to `store`, but with two items off the top of the stack.
- needs global variables??
; - or, do a `pop memory` command with a `pop address` command

High-level implementation notes:
- needed stacks:
  - loop end labels (for break statements)
- between each pass, we need to de-fragment memory
  - discard input
  - shift output
  - reset input length indicator
- needs memory access via `base[offset]` which can be read or written to

High-level implementation passes:
- remove comments
- rename params
- rename local vars, restart counter at end of each function

High-level function 

Initial high-level language limitations:
- no variable name shadowing
- assumption that user identifiers won't collide with generated identifiers (maybe?)

```
; fn multiply a b {
fn multiply 2

;   var out = 0;
push constant 0
pop local 0

;   var count = b;
push param 1
pop local 1

;   while {
label whileStart

;     out = out + a;
push local 0 ; push *(fn_base_sp+0)
push param 0
add?
pop local 0

;     count = count - 1;
push local 1
push constant 1
sub?
pop local 1

;     if count < 0 {
push local 1
push constant 0
lt?

not?
if-goto ifEnd

;       break
goto whileEnd

;     }
label ifEnd

;   }
label whileEnd

;   return out


; }
```

```

```

```
0[]
```

# Sourdough
<!-- https://en.wikipedia.org/wiki/Sourdough#Starter -->


