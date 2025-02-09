{ lib, user, ... }:
let
  editor_nvim = false;
  editor_vscode = true;
  editor_zed = false;
in{
  imports = [
    ./apps.nix
    ./cli.nix
    ./xdg-user-dirs.nix
  ]
  ++ lib.optional editor_nvim ./nvim.nix
  ++ lib.optional editor_vscode ./vscode.nix
  ++ lib.optional editor_zed ./zed-editor.nix;

  home = rec {
    # recでAttribute Set内で他の値を参照できるようにする
    username = "${user.name}";
    homeDirectory = "/home/${username}"; # 文字列に値を埋め込む
    stateVersion = "25.05";
    activation = {
      # ブラウザのキャッシュの格納場所をRAMにする
      # Custom Order Maid 3D2 のスクショの保存先を変える
      # VSCodeのキャッシュもRAMにする? → /home/naduki/.config/VSCodium/Cache, CachedData
      myActivationAction = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run \
          ln -fns /tmp ${homeDirectory}/.cache/BraveSoftware; \
          # ln -fns ${homeDirectory}/Pictures /home/game/KISS/COM3D2/ScreenShot
      '';
    };
    sessionVariables = {
      # ユーザ環境変数
      FLAKE = "${homeDirectory}/.config/.dotfiles";
      # WINE_HOME = "${homeDirectory}/.wine";
      # WINE32_HOME = "${homeDirectory}/.local/share/wineprefixes/wine32";
    };
    # ファイルのリンク張り
    # Nix関連のディレクトリ内でステージ上にあること
    file = {
      # 壁紙?
      # "wallpaper.png" = {
      #   target = "Wallpaper/wallpaper.png"; # ~/Wallpaper/wallpaper.pngに配置
      #   source = ./wallpaper.png; # 配置するファイル
      # };
      # "alacritty.toml" = {
      #   target = "${homeDirectory}/.config/alacritty/alacritty.toml";
      #   source = ./alacritty.toml;
      # };
    };
  };
  news.display = "silent"; # home-manager news の通知が switch 時に無くなる
  programs.home-manager.enable = true; # home-manager自身でhome-managerを有効化
}
