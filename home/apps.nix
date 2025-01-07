{ pkgs, ... }:
{
  home.packages = with pkgs; [
    blender
    brave
    # mission-center
    # krita
    # prismlauncher # minecraft alternative launcher
    # unityhub
    simplescreenrecorder
    # virt-manager
  ];
}
