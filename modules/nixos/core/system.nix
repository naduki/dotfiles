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
      # Keep build dependencies of GC roots (e.g. nix-direnv shells)
      keep-outputs = true;
      keep-derivations = true;
      # Cachix Settings
      # substituters = [
      #   "https://cache.nixos-cuda.org"
      # ];
      # trusted-public-keys = [
      #   "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      # ];
    };
  };
  # following configuration is added only when building VM with build-vm
  virtualisation.vmVariant.virtualisation = {
    memorySize = 2048;
    cores = 2;
  };
}
