{ config, lib, myconf, pkgs-stable, ... }:
{
  home = {
    packages = with pkgs-stable; (
      [
        # unityhub
        # virt-manager
      ]
      # Only install when Cinnamon is not enabled
      ++ lib.optionals (! lib.lists.elem "Cinnamon" (myconf.environment or [ ])) [
        celluloid
        file-roller
        glib # for trash
        nemo-with-extensions
        xviewer
        xreader
        xed-editor
      ]);
  };
  programs = {
    # Shell
    bash = {
      enable = true;
      historyIgnore = [ "ls" "l" "ll" "cd" "exit" "reboot" "poweroff" "nix-update" ];
      # Set LANG=C on virtual consoles
      initExtra = lib.mkDefault ''
        [ -z "$DISPLAY" ] && export LANG=C
      '';
    };
    fish = {
      enable = true;
      functions = {
        fish_greeting = "echo";
      };
    };
    # Browser
    chromium.package = pkgs-stable.brave;
    # Browser (alternative)
    floorp = {
      package = pkgs-stable.floorp-bin;
      languagePacks = [ "ja" ];
    };
    # Terminal
    wezterm.extraConfig = builtins.readFile ../../../config/wezterm/wezterm.lua;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
      enableFishIntegration = (config.programs.fish.enable);
    };
    git = {
      enable = true;
      settings = {
        init.defaultBranch = "main";
        user = {
          name = "naduki";
          email = "68984205+naduki@users.noreply.github.com";
        };
      };
      signing = {
        format = "ssh";
        key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        signByDefault = true;
      };
    };
    ghostty = {
      # enableFishIntegration = true;
      settings = {
        # command = "fish -C 'set fish_greeting' --login";
        theme = "poimandres";
        font-family = [
          "Moralerspace Radon HW"
          "LXGW WenKai Mono"
          "FreeMono"
          "DejaVu Sans Mono"
          "Noto Color Emoji"
          "Noto Emoji"
        ];
        font-size = 15;
      };
      themes = {
        # github:LucidMach/poimandres-ghostty
        poimandres = {
          background = "1b1e28";
          cursor-color = "e4f0fb";
          foreground = "a6accd";
          palette = [
            "0=#1b1e28"
            "1=#d0679d"
            "2=#5de4c7"
            "3=#fffac2"
            "4=#89ddff"
            "5=#d2a6ff"
            "6=#add7ff"
            "7=#ffffff"
            "8=#6c6f93"
            "9=#d0679d"
            "10=#5de4c7"
            "11=#fffac2"
            "12=#89ddff"
            "13=#d2a6ff"
            "14=#add7ff"
            "15=#ffffff"
          ];
          selection-background = "2a2e3f";
          selection-foreground = "f8f8f2";
        };
      };
    };
  };
}
