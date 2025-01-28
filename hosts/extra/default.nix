{ lib, ... }:
let
  virtualisations = false;
  xremap = false;
in {
  imports = [
    ./fonts.nix
    ./hardware-configuration.nix
    ./security.nix
  ]
  ++ lib.optional virtualisations ./virtualisation.nix
  ++ lib.optional xremap ./xremap.nix;
}
