{ pkgs ? import <nixpkgs> {}, ... }:

let
  # 共通の設定を読み込む
  baseShell = import ../../shell.nix { inherit pkgs; };
in
pkgs.mkShell rec{
  # 基本シェルから設定を継承
  # inherit (baseShell) pure;

  # 基本シェルから buildInputs を継承
  buildInputs = baseShell.buildInputs ++ (with pkgs; [
    # python
    python310
    # Nvidia
    linuxPackages.nvidia_x11_latest_open
    cudaPackages.cudatoolkit
    # 他の必須パッケージ
    stdenv.cc.cc.lib
    stdenv.cc
    libGLU libGL
    glib
    # 無くても動くけどエラーが出る
    freeglut
    util-linux
  ]);
  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;

  shellHook = ''
    ${baseShell.shellHook}
    echo "Welcome to the AUTOMATIC1111/stable-diffusion-webui environment."
  '';
}
