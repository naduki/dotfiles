{ config, pkgs, lib, myconf, ... }:

{
  # Swayの有効化
  programs.sway = {
    enable = true;
    extraOptions = [
      "--unsupported-gpu"
    ];
    wrapperFeatures.gtk = true; # GTKアプリケーションの動作を最適化します
  };

  # Nvidia GPU向けの環境変数設定
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # ElectronアプリなどをWaylandネイティブで動作させる
  };
} // lib.optionalAttrs (!builtins.elem "cinnamon" (myconf.environment or [])) {
  # Settings that should NOT be enabled when Cinnamon is active
  # (Cinnamon manages these services itself)

  # gcr-ssh-agent setting (for cinnamon)
  environment.extraInit = lib.optionalString config.services.gnome.gcr-ssh-agent.enable ''
    if [ -z "$SSH_AUTH_SOCK" ] && [ -n "$XDG_RUNTIME_DIR" ]; then
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
    fi
  '';
  # Enable Bluetooth support
  hardware.bluetooth.enable = true;
  # Security
  security = {
    polkit.enable = true;
    pam.services.login.enableGnomeKeyring = true;
  };
  # Services
  services = {
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
  };
  # 画面共有などを動作させるためのポータル設定
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}