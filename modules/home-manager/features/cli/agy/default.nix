{ pkgs, ... }:
{
  imports = [ ../../../../options/nixpkgs.nix ];

  unstableUnfreePackages = [ "antigravity-cli" ];

  programs.antigravity-cli = {
    enable = true;
    package = pkgs.unstable.antigravity-cli;
  };
}
