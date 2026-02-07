{ config, lib, pkgs, ...}:
let
  fhsPackages = import ./fhs-packages.nix;
in
{
  config = lib.mkIf (config.modules.editors.vscode.variant == "antigravity") {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
      "antigravity"
    ];
    programs.vscode.package = pkgs.antigravity.fhsWithPackages fhsPackages;
  };
}

