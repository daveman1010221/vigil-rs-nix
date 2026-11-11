# vigil-rs-nix/package.nix
#
# Builds selected binaries from the vigil-rs workspace.
#
# Parameters:
#   bins — list of binary names to build (default: vigild + vigil)
#          valid values: "vigild", "vigil", "vigil-log-relay"

{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, bins ? [ "vigild" "vigil" ]
}:

rustPlatform.buildRustPackage {
  pname   = "vigil-rs";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "git001";
    repo  = "vigil-rs";
    rev   = "v4.0.1";
    hash  = "sha256-O5cRB1e0/Oixm2/3/PllW4FKvyIgL68IKkEhd8UONbc=";
  };

  cargoHash = "sha256-/Bqg6d9g1Kx5w9svmSGSULH8IzLtSEw8E/6FRVy6OAU=";


  nativeBuildInputs = [ pkg-config ];
  buildInputs       = [ openssl ];

  cargoBuildFlags = lib.concatMap (bin: [ "--bin" bin ]) bins;

  doCheck = false;

  meta = {
    description = "PID 1 container init daemon and service supervisor in Rust";
    homepage    = "https://github.com/git001/vigil-rs";
    license     = lib.licenses.agpl3Only;
    platforms   = lib.platforms.linux;
    mainProgram = "vigild";
  };
}
