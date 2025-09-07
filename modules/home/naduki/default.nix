{ lib, myconf, pkgs-stable, ... }:
{
  imports = [
    ./fonts.nix
    ./editor
    ./programs.nix
    ./xdg-user-dirs.nix
  ]
  ++ lib.optional (myconf.naduki_Initial or false) ../activation
  ++ lib.optional (builtins.elem "cinnamon" (myconf.environment or [ ])) ./xresource.nix
  ++ (lib.optionals (builtins.elem "Hyprland" (myconf.environment or [ ])) [
    ./gtk-theme.nix
    ./illogical-impulse.nix
  ]);

  # Disable home-manager news notifications on switch
  news.display = "silent";
  # Add Blender (CUDA Support)
  home.packages = [
    (pkgs-stable.blender.override { cudaSupport = true; })
  ];
  programs = {
    # Editor
    micro.enable = true;
    neovim.enable = false;
    vscode.enable = false;
    zed-editor.enable = true;
    # Browser
    chromium.enable = true;
    # Browser (alternative)
    floorp.enable = false;
    # Terminal
    wezterm.enable = true;
    # Other
    gemini-cli.enable = false;
    htop.enable = true;
  };
  # Enable Podman
  services.podman.enable = true;
}
