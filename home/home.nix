{ lib, names, ... }:
{
  imports = [
    ./fonts.nix
    ./hyprland.nix
    ./nvim.nix
    ./programs.nix
    ./vscode.nix
    ./xdg-user-dirs.nix
    # ./xresource.nix    
    ./zed-editor.nix
  ];

  home = rec {
    username = "${names.user}";
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
    activation = {
      # Make Brave's cache directory a symlink to /tmp
      makeBraveSymbolic = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ln -fns /tmp ${homeDirectory}/.cache/BraveSoftware
      '';
      # Create a symbolic link for Hyprland's custom directory
      makeHyprSymbolic = lib.hm.dag.entryAfter [ "makeBraveSymbolic" ] ''
        run ln -fns ${homeDirectory}/.config/.dotfiles/home/hypr_custom ${homeDirectory}/.config/hypr/custom
      '';
      ## This is effectively an --impure state
    };
  };
  news.display = "silent";  # Disable home-manager news notifications on switch
  programs.home-manager.enable = true;  # Enable home-manager itself
}
