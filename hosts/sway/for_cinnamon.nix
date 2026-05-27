{ lib, pkgs, ... }:
{
  # Settings that should NOT be enabled when Cinnamon is active
  # (Cinnamon manages these services itself)

  environment.sessionVariables.NIX_GSETTINGS_OVERRIDES_DIR = lib.mkDefault
    "${pkgs.cinnamon-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";

  # Enable Bluetooth support
  hardware.bluetooth.enable = true;
  # Security
  security.polkit.enable = true;
  # Services
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