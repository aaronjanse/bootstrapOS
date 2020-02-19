with import <nixpkgs> {};

mkShell {
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
    alias binify="( echo 'obase=16;ibase=2' ; tr '\n' ' ' | sed 's/ //g' | sed -Ee 's/[01]{4}/;\0\n/g' ; echo ) | bc | xxd -r -p"
  	alias emulate="qemu-system-aarch64 -M raspi4 -nographic -monitor none -kernel"
  '';
}
