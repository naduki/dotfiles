{ pkgs, ... }:
{
  # Nix configuration
  nix = {
    # nix_version -> nix , latest , git , lix
    package = pkgs.nixVersions.latest;
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ]; # Enable experimental features (Flakes)
      warn-dirty = false; # Suppress Git dirty warnings
      # Cachix Settings
      substituters = [
        "https://nix-community.cachix.org"  # for CUDA
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # Fix for KVM switch (e.g., MSI Modern MD272QPW) preventing sleep.
  # PTXH must be disabled in /proc/acpi/wakeup to allow the system to suspend properly.
  systemd.services.disable-acpi-wakeup-PTXH = {
    description = "Disable PTXH in /proc/acpi/wakeup for KVM switch compatibility";
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'if grep -q \"PTXH.*enabled\" /proc/acpi/wakeup; then echo PTXH > /proc/acpi/wakeup; fi'";
      RemainAfterExit = "yes";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # following configuration is added only when building VM with build-vm
  virtualisation.vmVariant.virtualisation = {
    memorySize = 2048;
    cores = 2;
  };
}
