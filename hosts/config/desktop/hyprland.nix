{pkgs, ...}:
{
  programs = {
    hyprland = {
      enable = true;
      withUWSM  = true;
    };
  };
  programs.uwsm.enable = true;
  security.pam.services = {
    login.kwallet = {
      enable = true;
      package = pkgs.kdePackages.kwallet-pam;
    };
    hyprlock = {};
  };
  # Optional, hint Electron apps to use Wayland:
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
}