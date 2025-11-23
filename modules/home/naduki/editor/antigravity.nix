{ pkgs, ...}:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "antigravity"
  ];

  home.packages = [
    pkgs.antigravity-fhs
  ];
}
