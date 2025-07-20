{ pkgs, ...}:
{
  # Hyprland Desktop Environment.
  programs = {
    hyprland = {
      enable = true;
      withUWSM  = true;
    };
  };
  # services
  services = {
    blueman.enable = true;
    displayManager.cosmic-greeter.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
  };
  hardware.bluetooth.enable = true;
  # Security
  security = {
    polkit.enable = true;
    pam.services = {
      login.enableGnomeKeyring = true;
      hyprlock = {};
    };
  };
  # Environment
  # xdg.icons.enable = true;
  environment.systemPackages = with pkgs; [
    networkmanager_dmenu
  ];

  # Optional, hint Electron apps to use Wayland:
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
