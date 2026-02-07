{ lib, myconf, pkgs-stable, ... }:
let
  isHyprland = builtins.elem "Hyprland" (myconf.environment or [ ]);
in
{
  imports = [
    ./fonts.nix
    ./editor
    ./programs.nix
    ./tmpfs.nix
    ./xdg-user-dirs.nix
  ]
  ++ lib.optional (builtins.elem "Cinnamon" (myconf.environment or [ ])) ./xresource.nix
  ++ lib.optional (builtins.elem "Sway" (myconf.environment or [ ])) ./sway-settings.nix
  ++ lib.optional (isHyprland && builtins.elem "danklinux" (myconf.rice or [ ])) ./danklinux.nix
  ++ lib.optional (isHyprland && builtins.elem "illogical-impulse" (myconf.rice or [ ])) ./illogical-impulse.nix;

  # Disable home-manager news notifications on switch
  news.display = "silent";

  # Add Blender (CUDA Support)
  home.packages = [
    (pkgs-stable.blender.override { cudaSupport = true; })
  ];

  programs = {
    # Editor
    helix.enable = true;
    neovim.enable = false;

    vscode.enable = true;
    zed-editor.enable = false;
    # Browser
    chromium.enable = true;
    # Browser (alternative)
    floorp.enable = false;
    # Terminal
    wezterm.enable = true;
    # Other
    gemini-cli.enable = false;
  };
  modules.editors.vscode.variant = "antigravity";

  # Enable Podman
  services.podman.enable = true;
}
