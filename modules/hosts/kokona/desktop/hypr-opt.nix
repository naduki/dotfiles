{ config, lib, pkgs, ... }:
{
  # Settings enabled on other desktops (Cinnamon, ...)
  # gcr-ssh-agent setting (for cinnamon)
  environment.extraInit = lib.optionalString config.services.gnome.gcr-ssh-agent.enable ''
    if [ -z "$SSH_AUTH_SOCK" ] && [ -n "$XDG_RUNTIME_DIR" ]; then
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
    fi
  '';
  # Enable Bluetooth support
  hardware.bluetooth.enable = true;
  # Enable dconf
  programs.dconf.enable = true;
  # Security
  security = {
    polkit.enable = true;
    pam.services.hyprland.enableGnomeKeyring = true;
  };
  # Services
  services = {
    blueman.enable = true;
    dbus.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
  };
  # xdg.portal
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-xapp
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      hyprland = {
        default = [
          "hyprland"
          "xapp"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Secret" = [
          "xapp-gnome-keyring"
        ];
      };
    };
  };
}
