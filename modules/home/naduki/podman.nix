{ pkgs, ... }:
{
  home.packages = [
    pkgs.podman-desktop
  ];
  services.podman.enable = true;
}
