{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, aeson, base, bytestring, esqueleto, hedis
      , hspec, http-client, http-client-tls, lib, monad-logger, mtl
      , persistent, persistent-postgresql, persistent-template, servant
      , servant-client, servant-server, text, time, transformers, warp
      }:
      mkDerivation {
        pname = "RealWorldHaskell";
        version = "0.1.0.0";
        src = ./.;
        isLibrary = true;
        isExecutable = true;
        libraryHaskellDepends = [
          aeson base bytestring esqueleto hedis monad-logger mtl persistent
          persistent-postgresql persistent-template servant servant-client
          servant-server text time transformers warp
        ];
        executableHaskellDepends = [ base ];
        testHaskellDepends = [
          base hspec http-client http-client-tls monad-logger mtl
          persistent-postgresql servant-client
        ];
        homepage = "https://github.com/MondayMorningHaskell/RealWorldHaskell#readme";
        license = lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
