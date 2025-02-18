{ inputs, config, lib, pkgs, names, ... }:
{
  # 分割した設定ファイルとnixos-hardwareのインポート
  imports = [
    ./extra
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  boot = {
    loader = {
      # Use systemd-boot
      systemd-boot.enable = true;
      # 起動時のEFI変数の書き換えの許可?
      # efi.canTouchEfiVariables = true;
      # GPUドライバー使用中に、CUIの解像度を最適な値にする
      systemd-boot.consoleMode = "max";
      timeout = 10;
    };
  };

  # Allow unfree packages Nvidia Driver と Steam を許可する
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11" "nvidia-settings" "nvidia-persistenced"
    "steam" "steam-original" "steam-unwrapped" "steam-run"
  ];

  hardware = {
    # Wineでまいてつ Last Run!!をやるときに使うはず
    # graphics.enable32Bit = true;
    nvidia = {
      # Recommended -> stable, feature -> latest, beta -> beta
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      # NvidiaGPUのオープンソースドライバーにする
      open = true;
    };
  };

  networking = {
    hostName = "${names.host}";
    # Enable networking
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  location = {
    # Japan ( use redshift )
    latitude = 33.2;
    longitude = 133.1;
  };

  i18n = {
    # Select internationalisation properties.
    defaultLocale = "ja_JP.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "ja_JP.UTF-8";
      LC_IDENTIFICATION = "ja_JP.UTF-8";
      LC_MEASUREMENT = "ja_JP.UTF-8";
      LC_MONETARY = "ja_JP.UTF-8";
      LC_NAME = "ja_JP.UTF-8";
      LC_NUMERIC = "ja_JP.UTF-8";
      LC_PAPER = "ja_JP.UTF-8";
      LC_TELEPHONE = "ja_JP.UTF-8";
      LC_TIME = "ja_JP.UTF-8";
    };
    # Japanese input
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-gtk ];
    };
  };

  services = {
    # X11 settings
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      # GPU Driver
      videoDrivers = [ "nvidia" ];
      # Enable the Cinnamon Desktop Environment.
      displayManager.lightdm.enable = true;
      desktopManager.cinnamon.enable = true;
      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    # Disable CUPS to print documents.
    printing.enable = false;
    # Enable sound with pipewire.
    pulseaudio.enable = false;
  };

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.${names.user} = {
    isNormalUser = true;
    description = "${names.user}_nixos";
    extraGroups = [ "networkmanager" "wheel" ]  # 必須のグループ
      # 追加のグループ  USERNAME があるのでここで設定してる
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
      # pkgs.wineWowPackages.stable
      # pkgs.wineWowPackages.wayland
    ];
  };

  # プログラム個別設定
  programs = {
    gnome-terminal.enable = false;  # gnome-terminalを消す(問題発生時はttyかxtermで対応)
    steam = {
      enable = true;
      # fontPackages = with pkgs; [ migu ]; # fontを変える?
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Nix Setting
  nix = {
    # nixversion -> nix , latest , git , lix
    package = pkgs.nixVersions.latest;
    settings = {
      auto-optimise-store = true; # Nix storeの最適化
      experimental-features = [ "nix-command" "flakes" ]; # 実験機能 (Flakeを有効化)
      warn-dirty = false; # Git の dirty を抑止
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

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
