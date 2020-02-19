#lang pollen

[Analogy of some yogurt fermentation process where old yogurt is used to make new yogurt].

Fermentation is similar to building compilers. New languages are written with old languages.

◊ol{
	◊li{
		Algol 60 was ◊link["http://foldoc.org/Automated%20Engineering%20Design"]{extended to create} the language AED.
	}
	◊li{
		AED was ◊link["http://foldoc.org/Automated%20Engineering%20Design"]{used to write} the first BCPL compiler.
	}
	◊li{
		BCPL was used to write the first B compiler
	}
	◊li{
		B was used to re-implement the B compiler
	   ◊delete{^we need a footnote to clarify this bullet}
	}
	◊li{
		The B langauge/compiler was ◊link["https://www.bell-labs.com/usr/dmr/www/chist.html"]{iteratively transformed} into the C language/compiler.
	}
}

The typical "hello world" operating system starts with the C language, the fancy yogurt. We plan to create our yogurt from scratch.

◊section[1 null]{Goals}

While asking for advice on how to write this tutorial, my sister provided me with a great analogy for what we're trying to do: build a ship.

Many tutorials walk through which nails to put into which board of woods, explaining what's being built as the ship comes together.

In this tutorial, I hope to teach not just how to build a ship, but how ships are built, similar to what nand2tetris does. I plan to describe what makes a ship float, how a particular ship design fulfils those requirements, and the necessary woodworking skills.

◊ul{
	◊li{
		continue the "expanding self-build toolset" feeling of nand2tetris
	}
	◊li{
		provide readers with plenty of documentation
	}
	◊li{
		create plenty of non-frustrating exercises for the reader 
	}
	◊li{
		don't worry about accurately receating the historical path to contemporary OSes
	}
	◊li{
		don't worry about re-implementing existing languages
	}
}

◊section[1 null]{The Plan}

Earlier, we read that the B language/compiler was iteratively transformed into the C language/compiler. We plan on going through a similar process to elevate ourselves from machine code to a janky high-level language.

Once we implement a hacked-together high-level language, we'll rewrite the language's compiler in itself, adding features such as useful error reporting.

Once we have a non-painful language to work with, we'll begin implementing user-facing code, our end goal being to build a ◊link["https://gopher.tildeverse.org/zaibatsu.circumlunar.space/1/~solderpunk/gemini"]{gemini client & server}.

◊b{Long-term Goals}
◊ul{
	◊li{ethernet}
	◊li{netcat io ◊delete{instead of UART}}
  	◊li{
  		tls
  		◊ul{
	  		◊li{v1.3}
	  		◊li{chacha20}
	  		◊li{poly1305}
	  		◊li{sha256}
	  	}
	}
	◊li{gemini client}
	◊li{gemini server}
}

◊section[1 null]{Setting up our Software}

For the time being, this book is written for users of Linux and macOS. The Windows Subsystem for Linux should also work.

We'll use ◊link["https://nixos.org/nix"]{Nix} to manage our software. Once Nix is installed, download the book's source code repo and run ◊code{nix-shell}.

◊codeblock{
git clone ◊link["https://github.com/aaronjanse/os-book"]{https://github.com/aaronjanse/os-book}
cd os-book
nix-shell
}

You should be put in a bash shell with all the required software installed (in that shell only; none of the rest of your system is dirtied). This shell includes a patched version of qemu, and aliases ◊code{binify} & ◊code{emulate} to make your life easier.


