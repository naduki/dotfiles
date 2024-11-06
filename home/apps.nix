{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # bitwarden
    # blender
    brave
    # gnome.gnome-system-monitor
    # krita
    # prismlauncher # minecraft alternative launcher
    # unityhub
    simplescreenrecorder
    # virt-manager
  ];
}
