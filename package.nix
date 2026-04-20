# vigil-rs-nix/package.nix
#
# Builds vigild (daemon) and vigil (CLI) from the vigil-rs workspace.
# vigil-log-relay is optional — pass buildLogRelay = true to include it.
#
# vigil-rs is a PID 1 / container init daemon written in Rust.
# https://github.com/git001/vigil-rs

{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, buildLogRelay ? false
}:

rustPlatform.buildRustPackage {
  pname   = "vigil-rs";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "git001";
    repo  = "vigil-rs";
    rev   = "v3.1.2";
    hash  = "sha256-Pd9Av0RD1JaptQ3qQ10jnrScZvfQHS1+3P1jBQgBu+Y=";
  };

  cargoHash = "sha256-4oaypPT4iPHLz6pRiOx5iKNKpXW9MpiwY793sX1b0AE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs       = [ openssl ];

  cargoBuildFlags = [
    "--bin" "vigild"
    "--bin" "vigil"
  ] ++ lib.optionals buildLogRelay [
    "--bin" "vigil-log-relay"
  ];

  doCheck = false;

  meta = {
    description = "PID 1 container init daemon and service supervisor in Rust";
    homepage    = "https://github.com/git001/vigil-rs";
    license     = lib.licenses.agpl3Only;
    platforms   = lib.platforms.linux;
    mainProgram = "vigild";
  };
}
