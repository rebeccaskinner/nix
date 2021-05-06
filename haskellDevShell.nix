{ pkgs ? import <nixpkgs> {}, compiler ? "default" }:

let
  hsEnv = if compiler == "default"
          then pkgs.haskellPackages
          else pkgs.haskell.packages.${compiler};

  hsTools = hsEnv.ghcWithPackages(p: with p; [
    cabal-install
    cabal2nix
    stylish-haskell
    ghcide
    hoogle
    threadscope
  ]);

  hsLibs = hsEnv.ghcWithPackages(p: with p; [
    stm
    bytestring
    text
    containers
    vector
    time
    unix
    mtl
    transformers
    aeson
    lens
    conduit
  ]);

  nativeTools = (with pkgs; [
    gdb
    binutils
    elfutils
    strace
    ltrace
  ]);

in

pkgs.mkShell {
  nativeBuildInputs = [hsTools hsLibs nativeTools];
}
