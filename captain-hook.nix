{ pkgs ? import <nixpkgs> { }, mkDerivation, aeson, base, servant-server, stdenv, wai, warp, shelly, text }:

with pkgs.haskell.lib;

mkDerivation {
  pname = "captain-hook";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  libraryHaskellDepends = [ aeson base servant-server wai warp (dontCheck shelly) text ];
  executableHaskellDepends = [ base ];
  description = "webhook handler";
  license = stdenv.lib.licenses.bsd3;
  enableSharedExecutables = false;
  enableSharedLibraries = false;
  configureFlags = [
    "--ghc-option=-optl=-static"
    "--ghc-option=-optl=-L${pkgs.glibc.static}/lib"
    "--ghc-option=-optl=-L${pkgs.gmp5.static}/lib"
    "--ghc-option=-optl=-L${pkgs.zlib.static}/lib"
  ];
}
