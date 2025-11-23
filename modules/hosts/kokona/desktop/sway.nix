{ config, pkgs, lib, ... }:

{
  # Swayの有効化
  programs.sway = {
    enable = true;
    extraOptions = [
      "--unsupported-gpu"
    ];
    wrapperFeatures.gtk = true; # GTKアプリケーションの動作を最適化します
  };

  # 必要なパッケージのインストール
  environment.systemPackages = with pkgs; [
    # --- 必須ツール ---
    wofi          # ランチャー
    swaylock      # 画面ロック
    swayidle      # アイドル管理
    mako          # 通知
    
    # --- ユーティリティ ---
    wl-clipboard  # クリップボード操作
    grim          # スクリーンショット
    slurp         # 範囲選択
    
    # --- ステータスバー ---
    waybar
  ];
  
  # 画面共有などを動作させるためのポータル設定
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Nvidia GPU向けの環境変数設定
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # ElectronアプリなどをWaylandネイティブで動作させる
  };
}