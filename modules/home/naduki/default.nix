{ lib, myconf, pkgs-stable, ... }:
let
  isHyprland = builtins.elem "Hyprland" (myconf.environment or [ ]);
in
{
  imports = [
    ./editor
    ./fonts.nix
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

  home.shellAliases = {
    rmxmod = "find . -type f -exec chmod -x {} +";
    dur = "du --max-depth=1 -h | sort -hr";

    nix-update = "${myconf.flakeRoot}/update.sh";

    # xeyes = "nix run nixpkgs#xorg.xeyes";
    # dconf-editor = "nix run nixpkgs#dconf-editor";
    # neofetch = "nix run nixpkgs#neofetch";
    # mission-center = "nix run nixpkgs#mission-center";
  };

  programs = {
    # Editor
    helix.enable = false;
    neovim.enable = true;

    vscode.enable = true;
    zed-editor.enable = false;
    # Browser
    chromium.enable = true;
    # Browser (alternative)
    floorp.enable = false;
    # Terminal
    ghostty.enable = false;
    wezterm.enable = true;
    # Other
    gemini-cli.enable = true;
  };
  modules.editors.vscode.variant = "antigravity";

  # Enable Podman
  services.podman.enable = true;
}
