{ lib, ... }:
let
  virtualisations = false;
  xremap = false;
in {
  imports = [
    ./security.nix
    ./hyprland.nix
  ]
  ++ lib.optional virtualisations ./virtualisation.nix
  ++ lib.optional xremap ./xremap.nix;

  system.rebuild.enableNg = true; # Enable NixOS rebuildng command

  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize =  2048; # Use 2048MiB memory.
      cores = 2;
    };         
  };
}
