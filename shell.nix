with import <nixpkgs> {
  crossSystem = {
    config = "aarch64-none-elf";
    libc = "newlib";
  };
};

mkShell {
  buildInputs = [ ];
}

