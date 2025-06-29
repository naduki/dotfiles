{pkgs, ...}:
{
  programs.hyprpanel.enable = true;
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };
}