{ config, lib, myconf, ... }:
{
  imports = [
    ./fonts.nix
    ./nvim.nix
    ./programs.nix
    ./vscode.nix
    ./xdg-user-dirs.nix
    ./zed-editor.nix
  ]
  ++ lib.optional myconf.enablePodman ./podman.nix
  ++ lib.optional (builtins.elem "cinnamon" (myconf.environment or [ ])) ./xresource.nix
  ++ (lib.optionals (builtins.elem "Hyprland" (myconf.environment or [ ])) [
    ./gtk-theme.nix
    ./illogical-impulse.nix
  ]);

  home = {
    activation = {
      # Make Brave's cache directory a symlink to /tmp
      makeBraveSymbolic = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ln -fns /tmp ${config.home.homeDirectory}/.cache/BraveSoftware
      '';
      # Create a symbolic link for Hyprland's custom directory
      makeHyprSymbolic = lib.hm.dag.entryAfter [ "makeBraveSymbolic" ] ''
        run ln -fns ${config.home.homeDirectory}/.config/.dotfiles/config/hypr/custom ${config.home.homeDirectory}/.config/hypr/custom
      '';
      ## This is effectively an --impure state
    };
  };
  news.display = "silent"; # Disable home-manager news notifications on switch
  wayland.windowManager.hyprland.enable = builtins.elem "Hyprland" (myconf.environment or [ ]); # Enable Hyprland if configured
}
