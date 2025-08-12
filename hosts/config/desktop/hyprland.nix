{ pkgs, ... }:{
  # Enable Hyprland desktop environment.
  programs.hyprland.enable = true;

  services = {
    # Enable Cinnamon desktop environment (Wayland only)
    xserver.desktopManager.cinnamon.enable = true;
    # Disable Cinnamon apps
    cinnamon.apps.enable = false;
    # Enable ly display manager
    displayManager.ly.enable = true;
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
    # systemPackages = [ ];
  };

  # Enable these if services.xserver.desktopManager.cinnamon.enable is false
  # Enable Bluetooth support
  # hardware.bluetooth.enable = true;
  # Security
  # security = {
  #   polkit.enable = true;
  #   pam.services.hyprland.enableGnomeKeyring = true;
  # };
  # Services
  # services = {
  #   blueman.enable = true;
  #   dbus.enable = true;
  #   gnome.gnome-keyring.enable = true;
  #   gvfs.enable = true;
  # };
}
