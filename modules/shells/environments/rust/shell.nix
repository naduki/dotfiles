{ pkgs, ... }:

let
  # 共通の設定を読み込む
  baseShell = import ../../shell.nix { inherit pkgs; };
in
pkgs.mkShell {
  # 基本シェルから設定を継承
  inherit (baseShell) pure;

  # 基本シェルから buildInputs を継承
  buildInputs = baseShell.buildInputs ++ (with pkgs; [
    openssl
    pkg-config
    # rust-bin.stable.latest.default
    (rust-bin.stable.latest.default.override { extensions = [ "rust-src" ]; })
  ]);

  shellHook = ''
    ${baseShell.shellHook}
    echo "Rust development environment activated "
    # echo "Rust version: $(rustc --version)"
  '';
}
