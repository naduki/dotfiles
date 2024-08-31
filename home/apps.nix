{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # bitwarden
    blender
    brave
    # gnome.gnome-system-monitor
    # krita
    # prismlauncher # minecraft alternative launcher
    # unityhub
    simplescreenrecorder
    # virt-manager
  ];
  # i18n.inputMethod = {
  #   enabled = "fcitx5";
  #   fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-gtk ];
  # };
}
