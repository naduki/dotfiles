{ pkgs-stable, ... }:
{
  home.packages = with pkgs-stable; [
    blender
    brave
    gemini-cli
    # mission-center
    # krita
    # prismlauncher # minecraft alternative launcher
    # unityhub
    simplescreenrecorder
    # virt-manager
  ];
}
