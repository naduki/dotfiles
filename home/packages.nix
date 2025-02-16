{ pkgs-stable, ... }:
{
  home.packages = with pkgs-stable; [
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
