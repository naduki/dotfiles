{ lib, myconf, ... }:
{
  # home.activation Settings
  ## This is effectively an --impure state
  imports = [
    ./brave-cache.nix
  ]
  ++ lib.optional (builtins.elem "Hyprland" (myconf.environment or [ ])) ./hypr-custom.nix;
}
