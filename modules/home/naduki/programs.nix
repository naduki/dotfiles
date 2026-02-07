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
      shellAliases = {
        sudo = "sudo -k ";
        thmcl = "rm -r ${config.home.homeDirectory}/.cache/thumbnails/*";
        dur = "du --max-depth=1 -h | sort -hr";

        nix-update = "${myconf.flakeRoot}/update.sh";
        os-list = "nixos-rebuild list-generations";
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
      # Set LANG=C on virtual consoles
      initExtra = lib.mkDefault ''
        [ -z "$DISPLAY" ] && export LANG=C
      '';
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
  };
}
