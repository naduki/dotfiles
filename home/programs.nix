{ names, ...}:
let
  flakedir = "/home/${names.user}/.config/.dotfiles";
in
{
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
        flake = "cd ${flakedir}";
        thmcl = "rm -r /home/${names.user}/.cache/thumbnails/*";
        dur = "du --max-depth=1 -h | sort -hr";
        # wine32 = "env WINEPREFIX=$WINE32_HOME WINEARCH=win32 wine ";

        os-switch = "nixos-rebuild switch --sudo --flake ${flakedir}#${names.user}@${names.host}";
        os-test   = "nixos-rebuild test --flake ${flakedir}#${names.user}@${names.host}";
        os-vm     = "nixos-rebuild build-vm --flake ${flakedir}#${names.user}@${names.host}";  # ./result/bin/run-\*-vm
        # os-listgen = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations"; # old (not nix-command)
        os-list  = "nix profile history --profile /nix/var/nix/profiles/system";
        os-wipe  = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than ";

        hm-switch = "home-manager switch --flake ${flakedir}#${names.user}";
        hm-act    = "nix run flake:home-manager -- switch --flake ${flakedir}#${names.user}"; # standalone home-manager activation

        nix-update = "nix flake update --flake ${flakedir} --commit-lock-file ";

        g   = "git";
        ga  = "git add .";
        gb  = "git branch";
        gc  = "git commit";
        gp  = "git push";
        gf  = "git fetch";
        gs  = "git stash";
        gg  = "git gc";
        gac = "git add . && git commit";
        gacp = "git add . && git commit && git push";
        gco = "git checkout";

        # neofetch = "nix run nixpkgs#neofetch";
        # pcs = "podman container start ";
        # pce = "podman container exec -it ";
        # pceu = "podman container exec -itu ";
        # pck = "podman container stop ";
      };
      historyIgnore = [
        # historyに記録されなくなる
        "ls"
        "cd"
        "alias"
        "exit"
        "flake"
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
    floorp = {
      enable = false;
      languagePacks = [ "ja" ];
    };
    htop.enable = true;
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
