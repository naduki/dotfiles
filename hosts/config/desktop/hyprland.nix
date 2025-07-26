{
  imports = [ ../../extras/hypr_regreet.nix ];

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
    blueman.enable = true;
    dbus.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
  };
}
