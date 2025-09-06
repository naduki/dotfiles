{ config, lib, myconf, pkgs-stable, ... }:
{
  home = {
    packages = with pkgs-stable; ([
      # prismlauncher # minecraft alternative launcher
      # unityhub
      # virt-manager
    ]
    ++ lib.optionals (! myconf.naduki_initialSetup) [
      (blender.override { cudaSupport = true; })
    ]
    # Only install when Cinnamon is not enabled
    ++ lib.optionals (! lib.lists.elem "cinnamon" (myconf.environment or [ ])) [
      bulky
      celluloid
      cinnamon-translations
      file-roller
      glib # for trash
      nemo-with-extensions
      networkmanagerapplet
      xapp
      xviewer
      xreader
      xed-editor
    ]);
    sessionVariables.EDITOR = "micro";
  };
  programs = {
    # Editor
    neovim.enable = false;
    vscode.enable = false;
    zed-editor.enable = true;
    # Shell
    bash = {
      enable = true;
      shellAliases = {
        sudo = "sudo -k ";
        thmcl = "rm -r ${config.home.homeDirectory}/.cache/thumbnails/*";
        dur = "du --max-depth=1 -h | sort -hr";

        nix-update = "${myconf.flakeRoot}/update.sh";
        os-list = "nixos-rebuild list-generations ";
        os-wipe = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than ";

        # xeyes = "nix run nixpkgs#xorg.xeyes";
        # dconf-editor = "nix run nixpkgs#dconf-editor";
        # neofetch = "nix run nixpkgs#neofetch";
        # mission-center = "nix run nixpkgs#mission-center";

        ga = "git add .";
        gb = "git branch ";
        gc = "git commit ";
        gp = "git push ";
        gf = "git fetch ";
        gs = "git stash ";
        gg = "git gc";
        gac = "git add . && git commit ";
      };
      historyIgnore = [
        # Commands not recorded in history
        "ls"
        "cd"
        "alias"
        "exit"
      ];
      # Set LANG=C on virtual consoles
      initExtra = lib.mkDefault ''
        [ -z "$DISPLAY" ] && export LANG=C
      '';
    };
    # Browser
    chromium = {
      enable = true;
      package = pkgs-stable.brave;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    gemini-cli.enable = false;
    git = {
      enable = true;
      userName = "naduki";
      userEmail = "68984205+naduki@users.noreply.github.com";
      extraConfig = {
        init.defaultBranch = "main";
        safe.directory = "${myconf.flakeRoot}";
      };
      signing = {
        format = "ssh";
        key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        signByDefault = true;
      };
    };
    # Browser (alternative)
    floorp = {
      enable = false;
      package = pkgs-stable.floorp;
      languagePacks = [ "ja" ];
    };
    htop.enable = true;
    micro = {
      enable = true;
      package = lib.mkDefault pkgs-stable.micro;
    };
    # Terminal
    wezterm = {
      enable = true;
      extraConfig = builtins.readFile ../../../config/wezterm/wezterm.lua;
    };
  };
}
