with import <nixpkgs> {};

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
  ];
  shellHook = ''
    alias binify="( echo 'obase=16;ibase=2' ; tr '\n' ' ' | sed 's/ //g' | sed -Ee 's/[01]{4}/;\0\n/g' ; echo ) | bc | tr '\n' ' ' | sed 's/ //g' | sed 's/\([0-9A-F]\{2\}\)/\\\\\\\\\\x\1/gI' | xargs printf"
    alias cheater-binify="sed 's/[ \t]\+//g' | grep -v '^;' | binify"
  	alias emulate="qemu-system-aarch64 -M raspi4 -nographic -monitor none -kernel"
    alias read-uart="${stdenv.mkDerivation {
      name = "hello-2.1.221";
      src = ./read-uart;
      buildPhase = ''
        gcc main.c -o read-uart
      '';
      installPhase = ''
        mkdir -p $out/bin
        cp read-uart $out/bin
      '';
    }}/bin/read-uart"
    alias deasm="aarch64-none-elf-objdump -D -maarch64 -b binary"
  '';

  TEST="";
}
