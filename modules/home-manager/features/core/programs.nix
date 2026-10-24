{ lib, ... }:
{
  programs = {
    # Shell
    bash = {
      enable = true;
      # Set LANG=C on virtual consoles
      # (check both X11 and Wayland so that it still works when Xwayland is disabled)
      initExtra = lib.mkDefault ''
        [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && export LANG=C
      '';
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    git.enable = true;
  };
}
