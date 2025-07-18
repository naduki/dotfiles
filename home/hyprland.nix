{pkgs-stable, ...}:
{
  programs = {
    quickshell = {
      enable = true;
      # package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
    hyprlock = {
      enable = true;
      # package = inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };
  services = {
    hypridle = {
      enable = true;
      # package = inputs.hypridle.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
    hyprshell = {
      enable = true;
      systemd.enable = false;
      # package = inputs.hyprshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };

  home.packages = with pkgs-stable; [
    gnome-calculator

    hyprshot
    slurp
    wl-screenrec

    swaynotificationcenter
    
    mint-y-icons
    nemo-with-extensions
    xed-editor
  ];
}