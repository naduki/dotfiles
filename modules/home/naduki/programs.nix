{ config, lib, myconf, pkgs, pkgs-stable, ... }:
{
  home = {
    packages = with pkgs-stable; (
      [
        # prismlauncher # minecraft alternative launcher
        # unityhub
        # virt-manager
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
      ]
    ) ++ lib.optionals (config.services.podman.enable or false) [
      pkgs.podman-desktop
    ];

  };
  programs = {
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
      # Do not save lines that start with a space or duplicate lines to history
      historyControl = [ "ignoreboth" "erasedups" ];
      # Set LANG=C on virtual consoles
      initExtra = lib.mkDefault ''
        [ -z "$DISPLAY" ] && export LANG=C
      '';
    };
    # Browser
    chromium.package = pkgs-stable.brave;
    # Browser (alternative)
    floorp = {
      package = pkgs-stable.floorp;
      languagePacks = [ "ja" ];
    };
    # Terminal
    wezterm.extraConfig = builtins.readFile ../../../config/wezterm/wezterm.lua;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
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
    micro.package = lib.mkDefault pkgs-stable.micro;
  };
}
