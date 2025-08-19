{ pkgs ? (import <nixpkgs> { config.allowUnfree = true; }), ... }:

let
  # 共通の設定を読み込む
  baseShell = import ../../shell.nix { inherit pkgs; };
in
pkgs.mkShell {
  # 基本シェルから設定を継承
  inherit (baseShell) pure;

  # 基本シェルから buildInputs を継承
  buildInputs = baseShell.buildInputs ++ (with pkgs; [
    # cudaPackages.cudatoolkit  # all
    cudaPackages.cuda_cudart    # runtime
    cudaPackages.cuda_nvcc      # compiler
    ncurses5
  ]);

  shellHook = ''
    ${baseShell.shellHook}
    echo "CUDA development environment activated "
    # nvcc -V
    export CUDA_PATH=${pkgs.cudaPackages.cuda_nvcc}
    export LD_LIBRARY_PATH=/usr/lib/wsl/lib:${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.ncurses5}/lib
    export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
    export EXTRA_CCFLAGS="-I/usr/include"
  '';
}
