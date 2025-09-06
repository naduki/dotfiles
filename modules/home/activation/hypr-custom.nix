{ config, lib, myconf, ... }:
{
  # Create a symbolic link for Hyprland's custom directory
  home.activation.makeHyprSymbolic = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ln -fns ${myconf.flakeRoot}/config/hypr/custom ${config.home.homeDirectory}/.config/hypr/custom
  '';
}
