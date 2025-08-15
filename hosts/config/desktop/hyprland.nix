{ pkgs, ... }:{
  # Enable Hyprland desktop environment.
  programs.hyprland.enable = true;

  services = {
    # Enable Cinnamon desktop environment (Wayland only)
    xserver.desktopManager.cinnamon.enable = true;
    # Disable Cinnamon apps
    cinnamon.apps.enable = false;
    # Enable ly display manager
    displayManager.ly = {
      enable = true;
      x11Support = false; # Use Wayland only
    };
  };
  # Enable Hyprlock to unlock from Home-manager
  security.pam.services.hyprlock = {};

  environment = {
    # Exclude some Cinnamon packages
    cinnamon.excludePackages = with pkgs; [
      onboard
      sound-theme-freedesktop
      nixos-artwork.wallpapers.simple-dark-gray
      mint-artwork
      mint-cursor-themes
      mint-l-icons
      mint-l-theme
      mint-themes
      mint-x-icons
    ];
    systemPackages = with pkgs; [
      rose-pine-cursor
    ];
  };

  ## Enable these if services.xserver.desktopManager.cinnamon.enable is false
  ## gcr-ssh-agent setting (for cinnamon)
  # environment.extraInit = lib.optionalString config.services.gnome.gcr-ssh-agent.enable ''
  #   # Hack: https://bugzilla.redhat.com/show_bug.cgi?id=2250704 still
  #   # applies to sessions not managed by systemd.
  #   if [ -z "$SSH_AUTH_SOCK" ] && [ -n "$XDG_RUNTIME_DIR" ]; then
  #     export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
  #   fi
  # '';
  ## Enable Bluetooth support
  # hardware.bluetooth.enable = true;
  ## Enable dconf
  # programs.dconf.enable = true;
  ## Security
  # security = {
  #   polkit.enable = true;
  #   pam.services.hyprland.enableGnomeKeyring = true;
  # };
  ## Services
  # services = {
  #   blueman.enable = true;
  #   dbus.enable = true;
  #   gnome.gnome-keyring.enable = true;
  #   gvfs.enable = true;
  # };
}
