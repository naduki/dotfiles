{ pkgs, ... }:

{
  imports = [
    ./gtk-theme.nix
  ];

  programs = {
    # Automatically start Sway on tty1. If it fails or is run on another virtual terminal, set LANG=C.
    bash.initExtra = ''
      [ -z "$DISPLAY" ] && { [ "''${XDG_VTNR:-0}" -eq 1 ] && exec sway || export LANG=C; }
    '';
  };

  # --- Cursor Theme Settings ---
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "catppuccin-mocha-teal-cursors";
    package = pkgs.catppuccin-cursors.mochaTeal;
    size = 24;
  };

  # --- Qt Theme Settings ---
  qt = {
    enable = true;
    platformTheme.name = "gtk"; # QtアプリもGTKテーマに合わせる
    style.name = "gtk2";
  };

  # --- Essential Packages (from illogical-impulse.nix & sway.nix) ---
  home.packages = with pkgs; [
    # GUI Tools
    pavucontrol
    
    # Sway Essentials
    wofi          # ランチャー
    swaylock      # 画面ロック
    swayidle      # アイドル管理
    mako          # 通知
    wlogout       # ログアウトメニュー
    waybar        # ステータスバー
    
    # Utilities
    libnotify
    wl-clipboard
    grim          # スクリーンショット
    slurp         # 範囲選択
    playerctl     # メディアキー制御
  ];
}