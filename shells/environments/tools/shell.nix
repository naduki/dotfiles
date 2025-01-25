{ pkgs ? import <nixpkgs> {}, ... }:

let
  # 共通の設定を読み込む
  baseShell = import ../../shell.nix { inherit pkgs; };
in
pkgs.mkShell {
  # 基本シェルから設定を継承
  inherit (baseShell) pure;

  # 基本シェルから buildInputs を継承
  buildInputs = baseShell.buildInputs ++ (with pkgs; [
    poppler_utils
    gcc gnuplot
    jq unzip
    nkf veracrypt
    pcl meshlab
    libreoffice
    protontricks # winetricks
  ]);

  shellHook = ''
    ${baseShell.shellHook}
    alias nkfsj='nkf -w --overwrite'
    WXSUPPRESS_SIZER_FLAGS_CHECK=1
  '';
}
