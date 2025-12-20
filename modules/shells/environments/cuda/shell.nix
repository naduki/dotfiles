{ pkgs ? (import <nixpkgs> { config.allowUnfree = true; config.cudaSupport = true; }), ... }:

let
  # Load common settings
  baseShell = import ../../shell.nix { inherit pkgs; };
in
pkgs.mkShell {
  # Inherit settings from base shell
  inherit (baseShell) pure;

  # Inherit buildInputs from base shell
  nativeBuildInputs = (baseShell.nativeBuildInputs or []) ++ (with pkgs; [
    cudaPackages.cuda_nvcc      # compiler
    cmake pkg-config
  ]);

  # Inherit buildInputs from base shell
  buildInputs = (baseShell.buildInputs or []) ++ (with pkgs; [
    cudaPackages.cuda_cudart    # runtime
  ]);

  shellHook = ''
    ${baseShell.shellHook}
    echo "CUDA development environment activated "
    # nvcc -V
    export CUDA_PATH=${pkgs.cudaPackages.cuda_nvcc}
    export LD_LIBRARY_PATH=/usr/lib/wsl/lib:${pkgs.linuxPackages.nvidia_x11}/lib
    export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
    export EXTRA_CCFLAGS="-I/usr/include"
  '';
}
