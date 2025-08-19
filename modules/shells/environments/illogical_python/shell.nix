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
    python312
    python312Packages.kde-material-you-colors
    python312Packages.opencv4
    python312Packages.build
    python312Packages.pillow
    python312Packages.setuptools_scm
    python312Packages.wheel
    python312Packages.pywayland
    python312Packages.psutil
    python312Packages.materialyoucolor
    python312Packages.libsass
    python312Packages.material-color-utilities
    python312Packages.setproctitle
  ]);

  shellHook = ''
    ${baseShell.shellHook}
  '';
}
