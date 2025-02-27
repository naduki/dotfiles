{ lib, ... }:
let
  virtualisations = false;
  xremap = false;
in {
  imports = [
    ./security.nix
  ]
  ++ lib.optional virtualisations ./virtualisation.nix
  ++ lib.optional xremap ./xremap.nix;
}
