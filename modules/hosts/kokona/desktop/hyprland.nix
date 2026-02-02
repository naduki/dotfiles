{ config, lib, myconf, pkgs, ... }:
lib.mkMerge [
  {
    # Enable Hyprland desktop environment.
    programs.hyprland.enable = true;
    # Enable Hyprlock to unlock from Home-manager
    security.pam.services.hyprlock = { };
  }

  (lib.mkIf (lib.lists.elem "danklinux" myconf.rice) {
    programs.dms-shell = {
      enable = true;
      enableSystemMonitoring = true;
      enableDynamicTheming = true;
    };
    services.displayManager.dms-greeter = {
      enable = false;
      compositor.name = "hyprland";
    };
  })

  (lib.mkIf (! (lib.lists.elem "Cinnamon" myconf.environment)) {
    # Settings enabled on other desktops (Cinnamon, ...)
    # gcr-ssh-agent setting (for cinnamon)
    environment.extraInit = lib.optionalString config.services.gnome.gcr-ssh-agent.enable ''
      if [ -z "$SSH_AUTH_SOCK" ] && [ -n "$XDG_RUNTIME_DIR" ]; then
        export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
      fi
    '';
    environment.sessionVariables.NIX_GSETTINGS_OVERRIDES_DIR = lib.mkDefault "${pkgs.cinnamon-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";
    # Enable Bluetooth support
    hardware.bluetooth.enable = true;
    # Enable dconf
    programs.dconf.enable = true;
    # Security
    security = {
      polkit.enable = true;
      pam.services.login.enableGnomeKeyring = true;
    };
    # Services
    services = {
      # blueman.enable = true;
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
  })
]
