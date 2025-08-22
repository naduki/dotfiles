{ config, lib, myconf, ... }:
{
  # Load additional settings only when Hyprland is the sole environment
  # Given the condition under which this file is imported,
  # myconf.environmenthaving length 1 indicates Hyprland is the only environment.
  imports = lib.optionals (builtins.length myconf.environment == 1) [ ./hypr-opt.nix ];

  # Enable Hyprland desktop environment.
  programs.hyprland.enable = true;
  # Enable Hyprlock to unlock from Home-manager
  security.pam.services.hyprlock = {};
  # Fix Suspend/wakeup issues with Hyprland
  hardware.nvidia.powerManagement.enable = (lib.lists.elem "nvidia" config.services.xserver.videoDrivers);

  environment.systemPackages = [
    # pkgs.kitty   # If you don't have a terminal, be sure to install it
  ];
}
