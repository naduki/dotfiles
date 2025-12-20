{ pkgs, ... }:

let
  # Load common settings
  baseShell = import ../../shell.nix { inherit pkgs; };
in
pkgs.mkShell {
  # Inherit settings from base shell
  inherit (baseShell) pure;

  # Inherit buildInputs from base shell
  nativeBuildInputs = (baseShell.nativeBuildInputs or []) ++ (with pkgs; [
    pkg-config
    # rust-bin.stable.latest.default
    (rust-bin.stable.latest.default.override { extensions = [ "rust-src" ]; })
  ]);

  # Inherit buildInputs from base shell
  buildInputs = (baseShell.buildInputs or []) ++ (with pkgs; [
    openssl
  ]);

  shellHook = ''
    ${baseShell.shellHook}
    echo "Rust development environment activated "
    # echo "Rust version: $(rustc --version)"
  '';
}
