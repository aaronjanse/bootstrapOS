#lang pollen

Almost everything you'll need is in the ◊armv8-arm[1 null]{ARMv8 Architecture Reference Manual} and ◊cortex[1 null]{Cortex-72A Processor Technical Reference Manual}. I highly recommend downloading a copy of each PDF. Some of their contents are reproduced below.

◊section[1 null]{Plan}


◊b{Milestone: bootstrap machine code 🎉}
◊check[#true]{print to qemu uart}
◊check[#true]{properly setup uart, wait for write, print 'x'}
◊check[#true]{wait for read, read, print uart input}
◊check[#true]{write all to memory then dump memory in}
◊check[#true]{copy mem_in to mem_out then modify above code to print mem_out}
◊check[#true]{use bytes to indicate length of output}
◊check[#true]{routine to read a certain number of bits to memory, use it to copy machine code}
◊check[#true]{remove leading whitespace, `;` command for comments}
◊check[#true]{print raw binary}

◊b{Milestone: big-endian machine code}
◊check[#false]{print binary in little-endian form}
◊check[#false]{rewrite code in big-endian form}

◊b{Milestone: assembly functions (labeled, linked branching)}
◊check[#false]{var-length binifying}
◊check[#false]{decimal parsing (with negatives; slurp trailing whitespace)}
◊check[#false]{`JUMP`: relative branch with decimal}
◊check[#false]{`L`: function labels (read into memory tape with scheme `pos4 name \0`)}
◊check[#false]{`call`: abs-pos linking branch with label (keep track of current instruction number)}
◊check[#false]{rewrite above routines into functions}

◊check[#false]{register names}
◊check[#false]{conditional jump}

◊section[1 null]{Terminology}

These are the search terms you're looking for.

◊table{
	◊tr{
		◊th{Term}
		◊th{Definition}
	}
	◊tr{
		◊td{cortex-72a}
		◊td{the processor used by the Raspberry Pi 4}
	}
	◊tr{
		◊td{broadcom bcm2711}
		◊td{same as above, for our purposes (???)}
	}
	◊tr{
		◊td{instruction encoding}
		◊td{the encoding for translating assembly into machine code}
	}
}

◊section[1 null]{Peripherals}

Many peripherals (external io stuff) are accessible through special memory addresses. The Raspberry Pi 4's peripherals document has not yet been released, so for now we'll use the RPi 3's ◊armv8-arm[1 null]{BCM2835 ARM Peripherals Manual}.

◊section[2 null]{UART}

◊section[3 null]{External Documentation}

◊ul{
	◊li{
		◊link["http://infocenter.arm.com/help/topic/com.arm.doc.ddi0183g/DDI0183G_uart_pl011_r1p5_trm.pdf#page=47&zoom=auto,-29,502"]{PrimeCell UART Technical Reference Manual}
	}
	◊li{
		◊armv8-arm[175 "110,-110,807"]{BCM2835 ARM Peripherals, Page 175}
	}
	◊li{
		◊arm-periph[177 "110,-110,280"]{UART Register addresses}, with offset ◊mono{0xFE201000} on raspi4
	}
}






◊section[3 null]{Setup Procedure}

This can be skipped on QEMU, but I recommend implementing the hardware setup procedure as promptly as possible.

For the following setup steps, use the BCM2836 Peripheral Manual's ◊arm-periph[90 "110,-110,652"]{GPIO address section}, replacing ◊mono{0x7E20} with ◊mono{0xFE20} for raspi4.  Also see the manual's ◊arm-periph[177 "110,-110,280"]{UART address section}.

◊ol{
	◊li{
		disable UART using the ◊arm-periph[185 "110,-110,325"]{UART control register}
	}
	◊li{
		disable GPIO pin pull up/down
	}
	◊li{
		delay for 150 cycles (create a loop with a countdown)
	}
	◊li{
		disable GPIO pin pull up/down clock 0
	}
	◊li{
		delay for 150 cycles
	}
	◊li{
		disable GPIO pin pull up/down clock 0 (yeah, again; idk why)
	}
	◊li{
		clear all pending interrupts using the ◊arm-periph[192 "110,-70,735"]{UART interrupt clear register}
	}
	◊li{
		set baud rate to 115200 given a 3 Mhz clock (follow the PrimeCell UART Manual's ◊link["http://infocenter.arm.com/help/topic/com.arm.doc.ddi0183g/DDI0183G_uart_pl011_r1p5_trm.pdf#page=56&zoom=auto,-29,199"]{baud rate calculation example})
		◊ul{
			◊li{
write the baud rate divisor integer (◊mono{BDR_I}) to the ◊arm-periph[183 "110,-70,479"]{UART integer baud rate divisor register}
			}
			◊li{
				write the calculated fractional part (◊mono{m}) to the ◊arm-periph[183 "110,-110,255"]{UART fractional baud rate divisor register}
			}
		}
	}
	◊li{
		enable FIFO and 8-bit data transmission using the ◊arm-periph[184 "110,-70,645"]{UART line control register}
	}
	◊li{
		mask all interrupts using the ◊arm-periph[188 "110,-70,603"]{interrupt mask set/clear register}
	}
	◊li{
		enable UART, transfer, and receive using the ◊arm-periph[185 "110,-110,325"]{UART control register}
	}
}

◊section[3 null]{Writing}

UART data can be sent by storing ASCII-encoded text in ◊mono{0xFE201000}.

On real hardware, you'll want to first wait until the ◊arm-periph[181 "110,-70,329"]{UART flag register} says that the transmit FIFO isn't full.

◊section[3 null]{Reading}

◊section[1 null]{Memory Allocation}

Efficiently allocating memory can be a beast to write in machine code, so we'll put that off until we have a higher-level language to work with. In the mean time, this is the gist of the memory scheme we'll be using on the Raspberry Pi 4: 

◊table{
	◊tr{
		◊th{Memory Address(es)}
		◊th{Usage}
	}
	◊tr{
		◊td{◊code{0x00000-0x80000}}
		◊td{System stack}
	}
	◊tr{
		◊td{◊code{0x80000-0x300000}}
		◊td{Machine code}
	}
	◊tr{
		◊td{◊code{0x300000-0x3b3fffff}}
		◊td{0.99 GB of memory to be used by our machine code}
	}
}

◊section[1 null]{Machine Code Overview}

◊section[2 ◊armv8-arm[223 "auto,-4,576"]{pg 223}]{Encoding}

See the machine code tutorial.

◊section[2 ◊cortex[75 "auto,-12,749"]{pg 75}]{Registers}

These are the fastest place to store data. Most machine code instructions involve registers and moving data to/from/between them.

◊table{
	◊tr{
		◊th{
			Register
		}
		◊th{Description}
	}
	◊tr{
		◊td{
			◊cortex[90 "auto,-12,258"]{◊code{MPIDR_EL1}}
		}
		◊td{
			This read-only identification register, among other things, provides a core identification number (◊armv8-arm[2620 "110,-33,627"]{how to access})
		}
	}
	◊tr{
		◊td{
			◊code{r0} to ◊code{r15}
		}
		◊td{
			General-purpose registers. Because we're writing our own assembly language, feel free to use these however you want
		}
	}
	◊tr{
		◊td{
			◊code{r31} or ◊code{SP}
		}
		◊td{
			Depending on the instruction, this is either the stack pointer or a register that always reads zero and discards data when written
		}
	}
}


◊section[2 "\"immediate\" values"]{Constants}

The aarch64 instruction encoding is 32 bits wide, so we cannot store large constants into registers in a single command. Instead, we use multiple commands to store the constant, such as ◊mono{mov} with a bit shift followed by one or more ◊mono{add} instructions.


◊section[1 ◊armv8-arm[224 "auto,-4,745"]{pg 224}]{Machine Code Operations}

Every operation that you'll need should be in this document. There are plenty more operations out there, but for the purposes of this book, we'll only learn the basics. This is a tradeoff of efficiency (using the minimal number of instructions) verus simplicity.

◊table{
	◊tr{
		◊th{Term}
		◊th{Definition}
	}
	◊tr{
		◊td{immediate}
		◊td{constant}
	}
	◊tr{
		◊td{◊code{imm}}
		◊td{signed immediate}
	}
	◊tr{
		◊td{◊code{uimm}}
		◊td{unsigned immediate}
	}
}

◊section[2 null]{Register Movement}

This instruction family copies into a register either a constant or the value of another register.

◊section[3 ◊armv8-arm[226 "auto,-4,435"]{pg 226}]{From Constant}

◊instr{
1 1 0 1 0 0 1 0 1 hw2 imm16 Rd5
Rd <= imm << hw*16
}

◊section[3 ◊armv8-arm[723 "auto,-4,723"]{pg 723}]{From Register}

◊codeblock{
1 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 Rn5 Rd5
(Rd or *SP) <= (Rn or *SP)
}

◊section[3 ◊armv8-arm[802 null]{pg 802}]{From System Register}

◊codeblock{
1 1 0 1 0 1 0 1 0 0 1 SRn16 Rt5
Rt <- SRn
}

◊table{
	◊tr{
		◊th{System Register}
		◊th{SRn}
	}
	◊tr{
		◊td{◊cortex[90 "auto,-12,258"]{◊code{MPIDR_EL1}}}
		◊td{◊armv8-arm[2620 "110,-33,627"]{◊code{1100 0000 0000 0101}}}
	}
}

◊section[2 ◊armv8-arm[270 "auto,-4,358"]{pg 270}]{Logical Operations}

Using constants in logical aarch64 operations can be ◊link["https://news.ycombinator.com/item?id=16272350"]{surprisingly complex}, so we'll only use logical operations between registers.

I won't explain all of these here, but know that ◊code{xor} is also known as ◊code{eor}.

◊codeblock{
1 opc2 0 1 0 1 0 0 shift1 0 Rm5 uimm6 Rn5 Rd5
out = Rn # Rm
Rd <= shift ? (out >> uimm) : (out << uimm)
}

◊table{
	◊tr{
		◊th{opc}
		◊th{instruction}
	}
	◊tr{
		◊td{◊code{00}}
		◊td{AND}
	}
	◊tr{
		◊td{◊code{01}}
		◊td{OR}
	}
	◊tr{
		◊td{◊code{10}}
		◊td{XOR}
	}
}

◊section[3 null]{Register-based}

◊section[3 null]{And, immediate}
◊section[3 null]{Or}

◊section[3 null]{Xor}

◊section[2 null]{Arithmetic Operations}

◊section[3 ◊armv8-arm[533 "auto,-4,733"]{pg 533}]{Add}

◊section[3 ◊armv8-arm[531 "auto,-4,730"]{pg 531}]{Add, immediate}

◊codeblock{
1 0 0 1 0 0 0 1 0 shift1 uimm12 Rn5 Rd5
Rd <= Rn + (uimm << (shift ? 12 : 0))
}

◊table{
	◊tr{
		◊td{shift}
		◊td{If one, ◊code{uimm} is shifted 12 bits to the left}
	}
	◊tr{
		◊td{uimm}
		◊td{Unsigned constant integer}
	}
}


◊section[3 ◊armv8-arm[961 "auto,-4,723"]{pg 961}]{Sub}

◊codeblock{
1 1 0 0 1 0 1 1 shift2 0 Rm5 uimm6 Rn5 Rd5
1 1 0 0 1 0 1 1 00 0 Rm5 000000 Rn5 Rd5
Rd <= Rn - Rm
}


◊section[3 null]{Sub, immediate}

◊codeblock{
1 1 0 1 0 0 0 1 0 shift1 uimm12 Rn5 Rd5
Rd <= Rn - (uimm << (shift ? 12 : 0))
}

◊section[2 null]{Memory Operations}

◊link["https://people.cs.clemson.edu/~rlowe/cs2310/notes/ln_arm_load_store.pdf"]{Rose Lowe cs2310 Slideshow}


◊section[3 ◊armv8-arm[901 "auto,-4,387"]{pg ???}]{Store}

◊codeblock{
1 0 1 1 1 0 0 0 0 0 0 imm9 0 0 Rn5 Rt5
*(Rn + imm) <= (Rt or SP)
}

◊section[3 ◊armv8-arm[702 "auto,-4,295"]{pg 702}]{Store Byte}

◊codeblock{
0 0 1 1 1 0 0 1 0 0 imm12 Rn5 Rt5
Rt <= *(Rn + imm)
}

◊delete{

	◊section[3 ◊armv8-arm[901 "auto,-4,655"]{pg 901}]{Store, Post-Index}

	Reads the address `Rn` from memory stores it into the address `Rt`, then updates `Rn` to `Rn + imm`.

	```
	*Rt <- *Rn
	Rn <- Rn + imm
	```
}

LOAD BYTE https://static.docs.arm.com/ddi0487/ca/DDI0487C_a_armv8_arm.pdf#page=704&zoom=auto,-4,732

◊section[3 ◊armv8-arm[702 "auto,-4,295"]{pg 702}]{Load Byte}

◊codeblock{
0 0 1 1 1 0 0 1 0 1 imm12 Rn5 Rt5
Rt <= *(Rn + imm)
}

◊section[3 ◊armv8-arm[769 "auto,-4,731"]{pg 769}]{Load}


◊codeblock{
1 1 1 1 1 0 0 0 0 1 0 imm9 0 0 Rn5 Rt5
Rt <= *(Rn + imm)
}

Reads `Rn` and stores it into the memory address `Rt + imm`.

◊section[2 ◊armv8-arm[228 "auto,-4,723"]{pg 228}]{Branching}

This is how you'll jump around the source code, which allows us to implement functions, if statements, and more.

◊section[3 ◊armv8-arm[233 "auto,-4,495"]{pg 233}]{Unconditional Jump}

◊codeblock{
0 0 0 1 0 1 imm26
}

◊code{imm} is a signed constant that specificies how many instructions forward/backwards the processor should jump.

◊delete{
	CCMP immediate: https://static.docs.arm.com/ddi0487/ca/DDI0487C_a_armv8_arm.pdf#page=593&zoom=auto,-4,730
}

◊section[3 ◊armv8-arm[594 "auto,-4,730"]{pg 594}]{Compare}

◊codeblock{
1 1 1 1 1 0 1 0 0 1 0 Rm5 1 1 1 1 0 0 Rn5 0 0 0 0 0
Rn ? Rm
}

Compares Rn to Rm. Used before a conditional jump.

◊section[3 ◊armv8-arm[228 "auto,-4,317"]{pg 228}]{Conditional Jump}

◊codeblock{
0 1 0 1 0 1 0 0 imm19 0 cond4
}

◊code{imm} is a signed constant that specificies how many instructions forward/backwards the processor should jump.

◊table{
	◊tr{
		◊th{cond}
		◊th{◊link["https://www.element14.com/community/servlet/JiveServlet/previewBody/41836-102-1-229511/ARM.Reference_Manual.pdf#page=16&zoom=auto,-61,568"]{description}}
	}
	◊tr{
		◊td{◊code{0000}}
		◊td{Equal}
	}
	◊tr{
		◊td{◊code{0001}}
		◊td{Not Equal}
	}
	◊tr{
		◊td{◊code{1011}}
		◊td{Less Than}
	}
	◊tr{
		◊td{◊code{1101}}
		◊td{Less Than or Equal}
	}
	◊tr{
		◊td{◊code{1100}}
		◊td{Greater Than}
	}
	◊tr{
		◊td{◊code{1010}}
		◊td{Greater Than or Equal}
	}
}

◊code{imm} is a signed constant that specificies how many instructions forward/backwards the processor should jump.

◊section[2 null]{Miscellaneous}

◊section[3 ◊armv8-arm[1000 "auto,-4,730"]{pg 1000}]{Enter Sleep State}

◊codeblock{
1101 0101 0000 0011 0010 0000 0101 1111
}

You'll want to loop this instruction.

◊hr{}

◊b{Is something confusing? Email us!}
We'd love a chance to help out and improve our documentation.
Our addresses are listed on our GitHub accounts ◊code{@aaronjanse} and ◊code{@rohantib}.