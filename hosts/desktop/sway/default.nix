{ lib, pkgs, ... }:
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
    ];
    wrapperFeatures.gtk = true; # Optimize GTK application behavior
  };

  # Run Electron apps etc. natively on Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable Bluetooth support
  hardware.bluetooth.enable = true;

  # Enable Polkit
  security.polkit.enable = true;

  # Enable gnome-keyring and GVFS
  services = {
    gnome = {
      gnome-keyring.enable = true;
      # Conflict with ssh-agent
      gcr-ssh-agent.enable = lib.mkForce false;
    };
    gvfs.enable = true;
  };

  # Portal settings for screen sharing etc.
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-xapp xdg-desktop-portal-gtk ];
  };
}
