{ pkgs-stable, ... }:
{
  home.packages = with pkgs-stable; [
    blender
    gemini-cli
    # mission-center
    # krita
    # prismlauncher # minecraft alternative launcher
    # unityhub
    # simplescreenrecorder  # x11 only
    # virt-manager
  ];
}
