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
  # Enable NixOS rebuildng command
  system.rebuild.enableNg = true;
  # following configuration is added only when building VM with build-vm
  virtualisation.vmVariant.virtualisation = {
    memorySize = 2048;
    cores = 2;
  };
}
