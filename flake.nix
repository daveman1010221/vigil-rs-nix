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

        # vigild + vigil CLI (default — both binaries)
        vigil-all = pkgs.callPackage ./package.nix {};

        # vigild only — daemon for container images (smaller closure in Core layer)
        vigild-only = pkgs.callPackage ./package.nix { bins = [ "vigild" ]; };

        # vigil CLI only — for interactive use in Dev containers
        vigil-cli = pkgs.callPackage ./package.nix { bins = [ "vigil" ]; };

        # vigild + vigil + vigil-log-relay
        vigil-with-relay = pkgs.callPackage ./package.nix {
          bins = [ "vigild" "vigil" "vigil-log-relay" ];
        };
      in {
        packages.default        = vigil-all;
        packages.vigild         = vigild-only;
        packages.vigil          = vigil-cli;
        packages.vigil-with-relay = vigil-with-relay;
      }
    );
}
