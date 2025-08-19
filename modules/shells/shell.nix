{ pkgs ? import <nixpkgs> {}, ... }:

pkgs.mkShell {
  # 基本的な開発ツール
  buildInputs = with pkgs; [ git wget ];

  # ホストの環境と完全に分離する
  # この指定がないと、ホスト側の環境を継承するので継承をさせないための設定
  pure = true;

  shellHook = ''
    echo " Welcome to nix development environment!"
  '';
}
