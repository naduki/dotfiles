{ config, lib, names, ... }:
{
  imports = [
    ./config
    ./extras
    ./hardware-configuration.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11" "nvidia-persistenced" # "nvidia-settings"
    "steam" "steam-original" "steam-unwrapped" "steam-run"
  ];

  networking = {
    hostName = "${names.host}";
    # Enable networking
    networkmanager.enable = true;
    # Enable L2TP VPN
    # networkmanager.plugins = [ pkgs.networkmanager-l2tp ];
  };

  # user settings
  users.users.${names.user} = {
    isNormalUser = true;
    initialHashedPassword = "$y$j9T$DvGj7T6HlYCo2M4jtp5ZK1$ykxX0xXUjLvz.7ZEKx/tXIo7hEOJY6MYJoEhI/Dud2.";
    description = "${names.user}_nixos";
    extraGroups = [ "networkmanager" "wheel" ]
      # Additional Groups
      ++ lib.optional config.virtualisation.libvirtd.enable "libvirtd"  # KVM and QEMU rootless
      ++ lib.optional config.virtualisation.incus.enable "incus-admin"; # incus rootless
  };

  environment = {
    systemPackages = [
      # pkgs.wget
      # pkgs.git
      # pkgs.wineWowPackages.stable
      # pkgs.wineWowPackages.wayland
      # pkgs.floorp
    ];
  };

  # Install steam
  programs.steam.enable = true;

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
