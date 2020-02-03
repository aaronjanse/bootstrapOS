with import <nixpkgs> {};

mkShell {
  buildInputs = with pkgs; [
    pkgsCross.aarch64-embedded.stdenv.cc
    (callPackage ./nix/qemu {
      inherit (darwin.apple_sdk.frameworks) CoreServices Cocoa Hypervisor;
      inherit (darwin.stubs) rez setfile;
      python = python3;
    })
  ];
}

