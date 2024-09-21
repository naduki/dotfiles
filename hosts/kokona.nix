{
  inputs,
  config
, pkgs
, ...
}: {
  # 分割した設定ファイルのインポート
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
    # Rebuild時に出るようになったWarningを消す(2023/09/15) https://github.com/NixOS/nixpkgs/issues/254807
    swraid.enable = false;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "kokona-hinazuki";
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

  # Wineでまいてつ Last Run!!をやるときに使うはず
  # hardware.graphics.enable32Bit = true;
  # NvidiaGPUのオープンソースドライバーを使う
  hardware.nvidia.open = true;

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
      # enabled = "fcitx5"; # NixOS 24.11から非推奨
      enable = true;
      type = "fcitx5";
      fcitx5.waylandFrontend = true;
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
      excludePackages = with pkgs; [ xterm ];
    };
    # Using RedShift (時間帯で画面を赤くできる)
    redshift = {
      enable = false;
      temperature.day = 6000;
      temperature.night = 4500;
      # executable = "/bin/redshift-gtk";  # Tray icon
      extraOptions = [ "-m randr" ];
    };
    # Enable CUPS to print documents.
    printing.enable = false;
  };

  # Enable sound with pipewire.
  # sound.enable = true; # Removed in NixOS 24.11
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.naduki = {
    isNormalUser = true;
    description = "naduki_nixos";
    extraGroups =
      if config.virtualisation.libvirtd.enable && config.virtualisation.docker.enable then
        [
          "docker" # Docker rootless
          "libvirtd" # KVM and QEMU rootless
          "networkmanager" # Wifi ?
          "wheel" # sudo
        ]
      else if config.virtualisation.libvirtd.enable then [ "libvirtd" "networkmanager" "wheel" ]
      else if config.virtualisation.docker.enable then [ "docker" "networkmanager" "wheel" ]
      else [ "networkmanager" "wheel" ]; # グループ設定...もっといい書き方はないのか
  };

  environment = {
    # システム全体に導入するパッケージ
    systemPackages = with pkgs; [
      unar # Windowsの文字化けを回避して解凍する
      libsForQt5.xp-pen-deco-01-v2-driver
      nemo-python
      # wineWowPackages.stable  # Wine本体(安定版 32bit and 64bit)
      # wineWowPackages.wayland
    ];
    # CinnamonがデフォルトでインストールするソフトからHexChatを除外する(NixOS 24.11からCinnamonで削除)
    # cinnamon.excludePackages = with pkgs; [ hexchat ];
  };

  # プログラム個別設定
  # programs.geary.enable = false; # Geary(メールアプリ)を消す(NixOS 24.11からCinnamonで削除)
  programs.steam.enable = true; # Steamを有効化

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
  system.stateVersion = "24.05"; # Did you read the comment?
}
