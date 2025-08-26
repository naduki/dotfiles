{ config, lib, myconf, pkgs-stable, ... }:
{
  home = {
    packages = with pkgs-stable; [
      (blender.override {
        cudaSupport = true;
      })
      gemini-cli
      # prismlauncher # minecraft alternative launcher
      # unityhub
      # virt-manager
    ];
    sessionVariables.EDITOR = "micro";
  };
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
        thmcl = "rm -r ${config.home.homeDirectory}/.cache/thumbnails/*";
        dur = "du --max-depth=1 -h | sort -hr";

        nix-update = "nix-shell -p newt --command 'bash ${config.home.homeDirectory}/${myconf.flakeRoot}/update.sh'";
        os-list = "nix profile history --profile /nix/var/nix/profiles/system";
        os-wipe = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than ";

        xeyes = "nix run nixpkgs#xorg.xeyes";
        dconf-editor = "nix run nixpkgs#dconf-editor";
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
    chromium = {
      enable = true;
      package = pkgs-stable.brave;
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
    micro = {
      enable = true;
      package = lib.mkDefault pkgs-stable.micro;
    };
    wezterm = {
      enable = true;
      extraConfig = builtins.readFile ../../../config/wezterm/wezterm.lua;
    };
  };
}
