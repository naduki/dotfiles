{ config, pkgs, lib, myconf, ... }:

{
  # Enable Sway
  programs.sway = {
    enable = true;
    extraOptions = [
      "--unsupported-gpu"
    ];
    wrapperFeatures.gtk = true; # Optimize GTK application behavior
  };

  # Environment variable settings for Nvidia GPU
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Run Electron apps etc. natively on Wayland
  };
} // lib.optionalAttrs (!builtins.elem "Cinnamon" (myconf.environment or [])) {
  # Settings that should NOT be enabled when Cinnamon is active
  # (Cinnamon manages these services itself)

  # gcr-ssh-agent setting (for cinnamon)
  environment.extraInit = lib.optionalString config.services.gnome.gcr-ssh-agent.enable ''
    if [ -z "$SSH_AUTH_SOCK" ] && [ -n "$XDG_RUNTIME_DIR" ]; then
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
    fi
  '';
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
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}