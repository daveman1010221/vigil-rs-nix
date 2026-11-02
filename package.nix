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
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "git001";
    repo  = "vigil-rs";
    rev   = "v3.2.2";
    hash  = "sha256-4xAtH5gaBeyqMUoBiWsV9wIe8Pq9474tjzKONruSI18=";
  };

  cargoHash = "sha256-p7pgqRVYJTWr8IvD2lJaclbAudLtxPX1kttHtqzgABk=";


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
