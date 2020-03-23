{ nixpkgs ? import ./nix/nixpkgs.nix }:

with import nixpkgs {};

stdenv.mkDerivation {
  name = "os-book-shell";
  buildInputs = with pkgs; [
    pkgsCross.aarch64-embedded.stdenv.cc
    racket
    (callPackage ./nix/qemu {
      inherit (darwin.apple_sdk.frameworks) CoreServices Cocoa Hypervisor;
      inherit (darwin.stubs) rez setfile;
      python = python3;
    })
    (stdenv.mkDerivation {
      name = "read-uart";
      version = "1.1.2";
      src = ./read-uart;
      buildPhase = ''
        mkdir build
        gcc decode.c -o build/decode
        gcc compile-using.c -g -o build/compile-using
      '';
      installPhase = ''
        mkdir -p $out/bin
        cp build/* $out/bin
      '';
    })
  ];
  shellHook = ''
    alias binify="( echo 'obase=16;ibase=2' ; tr '\n' ' ' | sed 's/ //g' | sed -Ee 's/[01]{4}/;\0\n/g' ; echo ) | bc | tr '\n' ' ' | sed 's/ //g' | sed 's/\([0-9A-F]\{2\}\)/\\\\\\\\\\x\1/gI' | xargs printf"
    alias compile-machine-code="sed 's/[ \t]\+//g' | grep -v '^;' | sed 's/\([01]\{8\}\)\([01]\{8\}\)\([01]\{8\}\)\([01]\{8\}\)/\4\3\2\1/g' | binify"
    alias emulate-debug="qemu-system-aarch64 -M raspi4 -nographic -serial mon:stdio -monitor telnet::45454,server,nowait -kernel"
  	alias emulate="qemu-system-aarch64 -M raspi4 -nographic -monitor none -kernel"
    alias deasm="aarch64-none-elf-objdump -D -maarch64 -b binary"
  '';

  TEST="";
}
