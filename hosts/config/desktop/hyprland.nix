{
  programs = {
    hyprland = {
      enable = true;
      withUWSM  = true;
    };
  };
  services.gnome.gnome-keyring.enable = true;
  security.pam.services = {
    hyprlock = {};
  };
  # Optional, hint Electron apps to use Wayland:
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
}