{ pkgs, ... }:{
  # Hyprland Desktop Environment.
  programs.hyprland.enable = true;

  environment.systemPackages = [ ];
 
  hardware.bluetooth.enable = true;

  # Security
  security = {
    polkit.enable = true;
    pam.services = {
      hyprland.enableGnomeKeyring = true;
      hyprlock = {};
    };
  };

  # services
  services = {
    xserver.desktopManager.cinnamon.enable = true;
    cinnamon.apps.enable = false;

    displayManager.ly.enable = true;

    blueman.enable = true;
    dbus.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
  };

  environment.cinnamon.excludePackages = with pkgs; [
    onboard
    sound-theme-freedesktop
    nixos-artwork.wallpapers.simple-dark-gray
    mint-artwork
    mint-cursor-themes
    mint-l-icons
    mint-l-theme
    mint-themes
    mint-x-icons
    xapp
  ];
}
