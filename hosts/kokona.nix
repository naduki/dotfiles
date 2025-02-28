{ config, lib, pkgs, names, ... }:
{
  imports = [
    ./config
    ./extras
    ./hardware-configuration.nix
  ];

  # Allow unfree packages Nvidia Driver と Steam を許可する
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11" "nvidia-settings" "nvidia-persistenced"
    "steam" "steam-original" "steam-unwrapped" "steam-run"
  ];

  networking = {
    hostName = "${names.host}";
    # Enable networking
    networkmanager.enable = true;
  };

  # user settings
  users.users.${names.user} = {
    isNormalUser = true;
    description = "${names.user}_nixos";
    extraGroups = [ "networkmanager" "wheel" ]  # 必須のグループ
      # Additional Groups
      ++ lib.optional config.virtualisation.libvirtd.enable "libvirtd"  # KVM and QEMU rootless
      ++ lib.optional config.virtualisation.incus.enable "incus-admin"; # incus rootless
  };

  environment = {
    cinnamon.excludePackages = [ pkgs.warpinator ];
    # システム全体に導入するパッケージ
    systemPackages = [
      # pkgs.wget  # curlが使えてるので誤魔化す(かdevshellで一時的に...)
      # pkgs.git   # home-manager で有効化中
      # pkgs.networkmanager-l2tp   # L2TP VPN
      # pkgs.wineWowPackages.stable # wine-stable
      # pkgs.wineWowPackages.wayland
    ];
  };

  # プログラム個別設定
  programs = {
    gnome-terminal.enable = false;  # gnome-terminalを消す(問題発生時はttyかxtermで対応)
    steam.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
