#lang pollen

NOTES:
- all stack commands should be prefixed with a period
- entire codebase must be stack commands before we begin high-level language implementation
- when searching for curly braces, make sure they are simply not prefixed with a single quote (`'`)

◊section[1 null]{Plan}

DO THIS FOR STACK:
- implement `#def` macros

DO THIS FOR HL:
- build naive allocator

- scan for global var declarations, store indicies in tape

- actually parse stuff...
- integers
- chars
- unary expressions
- binomial expressions

- for each function...
- store parameter indicies in tape
- store local variable indicies in tape
- generate function declaration translated wrapper
- call `main` at end of codebase

