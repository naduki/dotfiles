{ user, ... }:
# Host-specific settings for "kokona"
# (shared by all desktop environments: Sway, Cinnamon)
{
  imports = [
    ../../hardware-configuration.nix
    ../../modules/nixos

    ../../modules/nixos/hardware/disable_PTXH.nix
    ../../modules/nixos/hardware/kanata.nix
    ../../modules/nixos/hardware/nvidia.nix
  ];

  # Enable AMD P-State driver and disable MSI Modern MD272QPW Storage
  boot.kernelParams = [
    "amd_pstate=active"
    "usb-storage.quirks=1462:3fa4:i"
  ];

  networking.hostName = "${user.hosts}-${user.env}";

  services = {
    # GPU Driver
    xserver.videoDrivers = [ "nvidia" ];
  };

  # user settings
  users.users.${user.name} = {
    isNormalUser = true;
    description = "${user.name}_nixos";
    extraGroups = [ "networkmanager" "wheel" "video" ];
  };

  # Password for `nixos-rebuild build-vm` only (not applied to the real system)
  virtualisation.vmVariant.users.users.${user.name}.initialHashedPassword =
    "$y$j9T$DvGj7T6HlYCo2M4jtp5ZK1$ykxX0xXUjLvz.7ZEKx/tXIo7hEOJY6MYJoEhI/Dud2.";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
