{ config, lib, pkgs, ... }:{
  # Enable Hyprland desktop environment.
  programs.hyprland.enable = true;
  # Enable Hyprlock to unlock from Home-manager
  security.pam.services.hyprlock = {};
  # Fix Suspend/wakeup issues with Hyprland
  # Because this uses open drivers, this may not resolve the issue.
  hardware.nvidia.powerManagement.enable = true;

  environment.systemPackages = with pkgs; [
    # kitty   # If you don't have a terminal, be sure to install it
    rose-pine-cursor
  ];

  # Enable these if services.xserver.desktopManager.cinnamon.enable is false
  # gcr-ssh-agent setting (for cinnamon)
  environment.extraInit = lib.optionalString config.services.gnome.gcr-ssh-agent.enable ''
    # Hack: https://bugzilla.redhat.com/show_bug.cgi?id=2250704 still
    # applies to sessions not managed by systemd.
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
}
