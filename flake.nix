{
  description = "Nix flake for vigil-rs — PID 1 container init daemon and service supervisor";

  inputs = {
    nixpkgs.url    = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        vigil = pkgs.callPackage ./package.nix {};
        vigil-with-relay = pkgs.callPackage ./package.nix { buildLogRelay = true; };
      in {
        packages.default        = vigil;
        packages.vigil          = vigil;
        packages.vigil-with-relay = vigil-with-relay;

        overlays.default = final: prev: {
          vigild = vigil;
          vigil  = vigil;
        };
      }
    );
}
