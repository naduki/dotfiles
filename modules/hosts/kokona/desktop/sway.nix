{ config, pkgs, lib, myconf, ... }:

{
  # Enable Sway
  programs.sway = {
    enable = true;
    extraOptions = [
      "--unsupported-gpu"
    ];
    extraPackages = [];
    wrapperFeatures.gtk = true; # Optimize GTK application behavior
  };

  # Run Electron apps etc. natively on Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

} // lib.optionalAttrs (!builtins.elem "Cinnamon" (myconf.environment or [])) {
  # Settings that should NOT be enabled when Cinnamon is active
  # (Cinnamon manages these services itself)

  # gcr-ssh-agent setting (for cinnamon)
  environment.extraInit = lib.optionalString config.services.gnome.gcr-ssh-agent.enable ''
    if [ -z "$SSH_AUTH_SOCK" ] && [ -n "$XDG_RUNTIME_DIR" ]; then
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
    fi
  '';

  environment.sessionVariables.NIX_GSETTINGS_OVERRIDES_DIR = lib.mkDefault
    "${pkgs.cinnamon-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";
  # Enable Bluetooth support
  hardware.bluetooth.enable = true;
  # Security
  security = {
    polkit.enable = true;
    pam.services.login.enableGnomeKeyring = true;
  };
  # Services
  services = {
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
  };
  # Portal settings for screen sharing etc.
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-xapp xdg-desktop-portal-gtk ];
  };
}