{ config, lib, myconf, pkgs-stable, ...}:
{
  home.packages = with pkgs-stable; [
    (blender.override {
      cudaSupport = true;
    })
    gemini-cli
    # mission-center
    # prismlauncher # minecraft alternative launcher
    # unityhub
    # virt-manager
  ];

  programs = {
    # Editor
    neovim.enable = true;
    vscode.enable = true;
    zed-editor.enable = false;
    # Shell
    bash = {
      enable = true;
      shellAliases = {
        sudo = "sudo -k ";
        flake = "cd ${config.home.homeDirectory}/${myconf.flakeRoot}";
        thmcl = "rm -r ${config.home.homeDirectory}/.cache/thumbnails/*";
        dur = "du --max-depth=1 -h | sort -hr";
        # wine32 = "env WINEPREFIX=$WINE32_HOME WINEARCH=win32 wine ";

        os-upd  = "nixos-rebuild --flake ${config.home.homeDirectory}/${myconf.flakeRoot}#${myconf.user}@${myconf.host} --sudo ";
        os-test = "nixos-rebuild test --flake ${config.home.homeDirectory}/${myconf.flakeRoot}#${myconf.user}@${myconf.host}";
        os-vm   = "nixos-rebuild build-vm --flake ${config.home.homeDirectory}/${myconf.flakeRoot}#${myconf.user}@${myconf.host}";  # QEMU_OPTS="-display gtk" ./result/bin/run-\*-vm
        # os-listgen = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations"; # old (not nix-command)
        os-list  = "nix profile history --profile /nix/var/nix/profiles/system";
        os-wipe  = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than ";

        hm-upd  = "home-manager --flake ${config.home.homeDirectory}/${myconf.flakeRoot}#${myconf.user} ";
        hm-act  = "nix run flake:home-manager -- switch --flake ${config.home.homeDirectory}/${myconf.flakeRoot}#${myconf.user}"; # standalone home-manager activation

        nix-update = "nix flake update --flake ${config.home.homeDirectory}/${myconf.flakeRoot} --commit-lock-file";
        xeyes = "nix run nixpkgs#xorg.xeyes";
        dconf-editor = "nix run nixpkgs#dconf-editor";

        g   = "git ";
        ga  = "git add .";
        gb  = "git branch ";
        gc  = "git commit ";
        gp  = "git push ";
        gf  = "git fetch ";
        gs  = "git stash ";
        gg  = "git gc";
        gac = "git add . && git commit ";
        gacp = "git add . && git commit && git push ";
        gco = "git checkout ";

        # neofetch = "nix run nixpkgs#neofetch";
        # pcs = "podman container start ";
        # pce = "podman container exec -it ";
        # pceu = "podman container exec -itu ";
        # pck = "podman container stop ";
      };
      historyIgnore = [
        # Commands not recorded in history
        "ls"
        "cd"
        "alias"
        "exit"
        "flake"
        "top"
      ];
      # Set LANG=C on virtual consoles
      initExtra = lib.mkDefault ''
        [ -z "$DISPLAY" ] && export LANG=C
      '';
    };
    chromium = {
      enable = true;
      package = pkgs-stable.brave;
      # if use wayland, enable the options
      # commandLineArgs = [
      #   "--ozone-platform-hint=auto"
      #   "--enable-wayland-ime"
      # ];
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    git = {
      enable = true;
      userName = "naduki";
      userEmail = "68984205+naduki@users.noreply.github.com";
      extraConfig.init.defaultBranch = "main";
      signing = {
        format = "ssh";
        key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        signByDefault = true;
      };
    };
    floorp = {
      enable = false;
      package = pkgs-stable.floorp;
      languagePacks = [ "ja" ];
    };
    htop.enable = true;
    wezterm = {
      enable = true;
      extraConfig = builtins.readFile ../../../config/wezterm/wezterm.lua;
    };
  };

}
