{ config, pkgs, ...}:
{
  # Japanese input
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = (config.programs.hyprland.enable or config.services.desktopManager.cosmic.enable);
      addons = with pkgs; [ fcitx5-mozc ];
    };
  };
}
