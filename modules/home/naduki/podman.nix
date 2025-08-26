{ pkgs, ... }:
{
  home.packages = with pkgs; [
    podman-desktop
  ];

  programs.bash.shellAliases = {
    pcs = "podman container start ";
    pce = "podman container exec -it ";
    pceu = "podman container exec -itu ";
    pck = "podman container stop ";
  };

  services.podman.enable = true;
}
