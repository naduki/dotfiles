{ config, lib, inputs, ... }: {
  options = {
    # Define a custom option "unfreePackages_unstable" (list of strings)
    # List types (listOf) are automatically merged into one even when defined across multiple files
    unfreePackages_unstable = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of unfree package names to allow";
    };
  };

  config.nixpkgs.overlays = [
    (final: prev: {
      # Expose the package set imported from inputs.unstable under the name "unstable"
      unstable = import inputs.unstable {
        inherit (prev.stdenv.hostPlatform) system;
        # config.cudaCapabilities = [ "8.9" ];
        # Create a predicate function for all packages based on the merged list from each file
        config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.unfreePackages_unstable;
      };
    })
  ];
}
