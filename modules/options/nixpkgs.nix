{ config, lib, inputs, ... }:
# Shared nixpkgs settings for both NixOS and Home-manager:
# - unfree package allowlists (for pkgs and pkgs.unstable)
# - pkgs.unstable overlay
{
  options = {
    # Custom options (list of strings)
    # List types (listOf) are automatically merged into one even when defined across multiple files
    unfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of unfree package names to allow in pkgs";
    };
    unstableUnfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of unfree package names to allow in pkgs.unstable";
    };
  };

  config.nixpkgs = {
    config = {
      # config.cudaCapabilities = [ "8.9" ];
      # Create a predicate function for all packages based on the merged list from each file
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.unfreePackages;
    };

    overlays = [
      (final: prev: {
        # Expose the package set imported from inputs.unstable under the name "unstable"
        unstable = import inputs.unstable {
          inherit (prev.stdenv.hostPlatform) system;
          # config.cudaCapabilities = [ "8.9" ];
          config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.unstableUnfreePackages;
        };
      })
    ];
  };
}
