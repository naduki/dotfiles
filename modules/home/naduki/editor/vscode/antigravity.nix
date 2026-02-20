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
    systemd.user.tmpfiles.rules = [
      "d /tmp/Antigravity/Cache 0700 - - -"
      "L+ %h/.config/Antigravity/Cache - - - - /tmp/Antigravity/Cache"
      "d /tmp/Antigravity/CachedData 0700 - - -"
      "L+ %h/.config/Antigravity/CachedData - - - - /tmp/Antigravity/CachedData"
    ];
  };
}

