{ config, lib, pkgs, user, ... }:
{
  imports = [
    ./core/boot.nix
    ./core/locale_jp.nix
    ./core/security.nix
    ./core/system.nix

    ./desktop/fonts.nix
    ./desktop/sound.nix

    ./hardware/disable_PTXH.nix
    ./hardware/nvidia.nix

    ../options/unfree.nix
  ];

  # Allow unfree packages
  unfreePackages = []
    ++ lib.optionals (lib.lists.elem "nvidia" (config.services.xserver.videoDrivers or [ ])) [ "nvidia-x11" ]  # When using the NVIDIA driver
    ++ lib.optionals (config.hardware.nvidia.nvidiaSettings.enable or false) [ "nvidia-settings" ]
    ++ lib.optionals (config.programs.steam.enable or false) [ "steam" "steam-original" "steam-unwrapped" "steam-run" ];

  # Enable AMD P-State driver and disable MSI Modern MD272QPW Storage
  boot.kernelParams = [
    "amd_pstate=active"
    "usb-storage.quirks=1462:3fa4:i"
  ];

  documentation = {
    doc.enable = false;
    info.enable = false;
  };

  # Disable Bluetooth on boot
  hardware.bluetooth.powerOnBoot = false;

  networking = {
    hostName = "${user.hosts}_${user.env}";
    # Enable networking
    networkmanager.enable = true;
  };

  # Install Steam
  # programs.steam.enable = true;

  # Enable Sudo-rs
  security = {
    sudo-rs.enable = true;
    sudo.enable = lib.mkForce (!(config.security.sudo-rs.enable));
    sudo-rs.extraConfig = ''
      Defaults timestamp_timeout=1
    '';
  };

  services = {
    # GPU Driver
    xserver.videoDrivers = [ "nvidia" ];
    # File system trim
    fstrim.enable = true;
  };

  # /var/lib/systemd/coredump limitations
  systemd.coredump.settings.Coredump = {
    MaxUse = "800M";
    MaxRetention = "1day";
  };

  # user settings
  users.users.${user.name} = {
    isNormalUser = true;
    initialHashedPassword = "$y$j9T$DvGj7T6HlYCo2M4jtp5ZK1$ykxX0xXUjLvz.7ZEKx/tXIo7hEOJY6MYJoEhI/Dud2.";
    description = "${user.name}_nixos";
    extraGroups = [ "networkmanager" "wheel" "video" ];
  };

  environment = {
    shellAliases = {
      os-list = "nixos-rebuild list-generations";
      os-wipe = "pkexec nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than ";
    };
    systemPackages = [
      # pkgs.wget
      pkgs.wineWow64Packages.stable
    ];
  };

  # programs.git.enable = true;
  # programs.firefox = {
  #   enable = true;
  #   package = pkgs.floorp-bin;
  # };

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
  system.stateVersion = "24.05"; # Did you read the comment?
}
