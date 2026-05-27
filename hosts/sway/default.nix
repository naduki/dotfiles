{ config, lib, pkgs, ... }:
{
  # Enable Sway
  programs.sway = {
    enable = true;
    extraOptions = [
      "--unsupported-gpu"
    ];
    extraPackages = [
      # pkgs.brightnessctl
      # pkgs.ghostty
      pkgs.polkit_gnome
    ];
    wrapperFeatures.gtk = true; # Optimize GTK application behavior
  };

  # Run Electron apps etc. natively on Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
