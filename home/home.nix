{ lib, names, ... }:
{
  imports = [
    ./fonts.nix
    ./packages.nix
    ./programs.nix
    ./xdg-user-dirs.nix
    ./nvim.nix
    ./vscode.nix
    ./zed-editor.nix
  ];

  home = rec {
    # recでAttribute Set内で他の値を参照できるようにする
    username = "${names.user}";
    homeDirectory = "/home/${username}"; # 文字列に値を埋め込む
    stateVersion = "25.05";
    activation = {
      # ブラウザのキャッシュの格納場所をRAMにする
      # ln -fns ${homeDirectory}/Pictures /home/game/KISS/COM3D2/ScreenShot
      makeSymbolic = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ln -fns /tmp ${homeDirectory}/.cache/BraveSoftware
      '';
    };
  };
  news.display = "silent"; # home-manager news の通知が switch 時に無くなる
  programs.home-manager.enable = true; # home-manager自身でhome-managerを有効化
}
