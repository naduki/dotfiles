{ config, lib, ... }:
# Common NixOS settings (host-specific settings live in hosts/<host>)
{
  imports = [
    ./core/boot.nix
    ./core/locale_jp.nix
    ./core/security.nix
    ./core/system.nix

    ./desktop/fonts.nix
    ./desktop/sound.nix

    ../options/nixpkgs.nix
  ];

  # Allow unfree packages
  unfreePackages = []
    ++ lib.optionals (lib.elem "nvidia" config.services.xserver.videoDrivers) [ "nvidia-x11" ]  # When using the NVIDIA driver
    ++ lib.optionals config.hardware.nvidia.nvidiaSettings [ "nvidia-settings" ]
    ++ lib.optionals config.programs.steam.enable [ "steam" "steam-original" "steam-unwrapped" "steam-run" ];

  documentation = {
    doc.enable = false;
    info.enable = false;
  };

  # Disable Bluetooth on boot
  hardware.bluetooth.powerOnBoot = false;

  networking = {
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
    # File system trim
    fstrim.enable = true;
    # Performance settings
    # auto-cpufreq.enable = false;
    # power-profiles-daemon.enable = false;
    # upower.enable = false;
  };

  # /var/lib/systemd/coredump limitations
  systemd.coredump.settings.Coredump = {
    MaxUse = "800M";
    MaxRetention = "1day";
  };

  environment.systemPackages = [
      # pkgs.wget
  ];

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
}
