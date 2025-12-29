{ lib, myconf, pkgs-stable, ... }:
{
  imports = [
    ./fonts.nix
    ./editor
    ./programs.nix
    ./xdg-user-dirs.nix
  ]
  ++ lib.optional (myconf.naduki_Initial or false) ../activation
  ++ lib.optional (builtins.elem "Cinnamon" (myconf.environment or [ ])) ./xresource.nix
  ++ lib.optional (builtins.elem "Hyprland" (myconf.environment or [ ])) ./gtk-theme.nix
  ++ lib.optional (builtins.elem "Sway" (myconf.environment or [ ])) ./sway-settings.nix
  ++ lib.optional (builtins.elem "illogical-impulse" (myconf.rice or [ ])) ./illogical-impulse.nix
  ++ lib.optional (builtins.elem "danklinux" (myconf.rice or [ ])) ./danklinux.nix;

  # Disable home-manager news notifications on switch
  news.display = "silent";
  # Add Blender (CUDA Support)
  home.packages = [
    (pkgs-stable.blender.override { cudaSupport = true; })
  ];
  programs = {
    # Editor
    micro.enable = false;

    helix.enable = true;
    neovim.enable = false;

    vscode.enable = false;
    zed-editor.enable = false;
    # Browser
    chromium.enable = true;
    # Browser (alternative)
    floorp.enable = false;
    # Terminal
    wezterm.enable = true;
    # Other
    gemini-cli.enable = false;
    htop.enable = false;
  };
  # Enable Podman
  services.podman.enable = true;
}
