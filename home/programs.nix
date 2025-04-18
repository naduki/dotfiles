{ names, ...}:
let
  thumbnauils = "/home/${names.user}/.cache/thumbnails";
  flakedir = "/home/${names.user}/.config/.dotfiles";
in
{
  programs = {
    # Editor
    neovim.enable = false;
    vscode.enable = true;
    zed-editor.enable = false;
    # Shell
    bash = {
      enable = true;
      shellAliases = {
        sudo = "sudo -k ";
        flake = "cd ${flakedir}";
        clc = "rm -r ${thumbnauils}/*";
        dur = "du --max-depth=1 -h | sort -hr";
        # wine32 = "env WINEPREFIX=$WINE32_HOME WINEARCH=win32 wine ";

        os-switch = "sudo nixos-rebuild switch --flake ${flakedir}#${names.user}@${names.host}";
        os-dbuild = "sudo nixos-rebuild dry-build --flake ${flakedir}#${names.user}@${names.host}";
        hm-switch = "home-manager switch --flake ${flakedir}#${names.user}";
        hm-act = "nix run flake:home-manager -- switch --flake ${flakedir}#${names.user}"; # home-manager activation
        os-listgen = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
        nix-clean = "nix-collect-garbage --delete-older-than ";
        nix-update = "nix flake update ";
        nix-updates = "nix flake update --flake ${flakedir} --commit-lock-file ";
        # nix-edit  = "codium --locale=ja $FLAKE";
        # hm-listgen = "home-manager generations";
        # hm-rmgen = "home-manager remove-generations ";

        g = "git";
        ga = "git add .";
        gb = "git branch";
        gc = "git commit";
        gp = "git push";
        gf = "git fetch";
        gs = "git stash";
        gg = "git gc";
        gac = "git add . && git commit";
        gacp = "git add . && git commit && git push";
        gco = "git checkout";

        # dcs = "docker container start ";
        # dce = "docker container exec -it ";
        # dceu = "docker container exec -itu ";
        # dck = "docker container stop ";

        # pcs = "podman container start ";
        # pce = "podman container exec -it ";
        # pceu = "podman container exec -itu ";
        # pck = "podman container stop ";

        # vi = "nvim";
        # vim = "nvim";
      };
      historyIgnore = [
        # historyに記録されなくなる
        "ls"
        "cd"
        "alias"
        "exit"
        "flake"
        "nvim"
        "top"
      ];
      # shellの初期化のときに実行される(X11,Waylandが動いてないときに日本語じゃないようにする)
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
      signing = {
        format = "ssh";
        key = "/home/${names.user}/.ssh/id_ed25519.pub";
        signByDefault = true;
      };
    };
    alacritty = { # Weztermの代替
      enable = false;
      # package = pkgs.aracritty;
      # tomlの形式をNixで書く必要があるのでhome.fileで代用
      # settings = builtins.readFile ./alacritty.toml;
    };
    wezterm = {
      enable = true;
      # package = pkgs.wezterm;
      # バージョンアップとかで挙動が変わったら無効化して~/.config/wezterm/wezterm.luaでデバッグ
      extraConfig = builtins.readFile ./wezterm/wezterm.lua;
    };
  };
  # .Xresourcesの中身 (Xtermの設定)
  xresources.properties = {
    "XTerm*termName" = "xterm-256color";
    "XTerm*locale" = true;
    "XTerm*selectToClipboard" = true;
    "XTerm*saveLines" = 2000;
    "XTerm*faceName" = "Moralerspace Radon HWNF Complete:size=14";
    "XTerm*font" = "4x10";
    "XTerm*reverseVideo" = "on";
  };
}
