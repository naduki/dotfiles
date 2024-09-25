{
  programs = {
    bash = {
      enable = true;
      shellAliases = {
        sudo = "sudo -k ";
        flake = "cd $FLAKE";
        clc = "rm -r $HOME/.cache/thumbnails/*";
        dur = "du --max-depth=1 -h | sort -hr";
        # wine32 = "env WINEPREFIX=$WINE32_HOME WINEARCH=win32 wine ";

        hm = "home-manager ";
        os-switch = "sudo nixos-rebuild switch --flake .#myNixOS";
        os-dbuild = "sudo nixos-rebuild dry-build --flake .#myNixOS";
        hm-switch = "home-manager switch --flake .#kokona";
        hm-act = "nix run flake:home-manager -- switch --flake .#kokona";
        os-listgen = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
        nix-clean = "nix-collect-garbage --delete-older-than 2d";
        nix-update = "nix flake update ";
        # nix-edit  = "codium --locale=ja $FLAKE";
        # hm-listgen = "home-manager generations";
        # hm-rmgen = "home-manager remove-generations ";

        g = "git";
        ga = "git add .";
        gb = "git branch";
        gc = "git commit";
        gf = "git fetch";
        gs = "git stash";
        gg = "git gc";
        gac = "git add . && git commit";
        gacp = "git add . && git commit && git push";
        gco = "git checkout";

        dcs = "docker container start ";
        dce = "docker container exec -it ";
        dceu = "docker container exec -itu ";
        dck = "docker container stop ";

        # vi = "nvim";
        # vim = "nvim";
      };
      historyIgnore = [
        # historyに記録されなくなる
        "ls"
        "cd"
        "alias"
        "du"
        "df"
        "exit"
        "flake"
        "nvim"
        "top"
        "git merge main"
      ];
      # shellの初期化のときに実行される(tty1~6のときは日本語じゃないようにする)
      initExtra = ''(tty|fgrep -q 'tty') && export LANG=C'';
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
    };
    alacritty = { # Weztermの代替
      enable = true;
      # package = pkgs.aracritty;
      # settings = builtins.readFile ./alacritty.toml;
    };
    wezterm = {
      enable = false; # unstable + nvidia opendriverで文字が四角になって死んだ
      # package = pkgs.wezterm;
      # バージョンアップとかで挙動が変わったら無効化して~/.config/wezterm/wezterm.luaでデバッグ
      extraConfig = builtins.readFile ./wezterm.lua;
    };
  };
}
