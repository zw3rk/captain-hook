{ pkgs ? import <nixpkgs> {}, compiler ? "ghc822" }:
pkgs.haskell.packages.${compiler}.callPackage ./captain-hook.nix { inherit pkgs; }
