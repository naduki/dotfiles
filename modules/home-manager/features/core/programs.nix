{ lib, ... }:
{
  programs = {
    # Shell
    bash = {
      enable = true;
      # Set LANG=C on virtual consoles
      initExtra = lib.mkDefault ''
        [ -z "$DISPLAY" ] && export LANG=C
      '';
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
    };
    git.enable = true;
  };
}
