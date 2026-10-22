{ config, lib, ... }: {
  options = {
    # Define a custom option "unfreePackages" (list of strings)
    # List types (listOf) are automatically merged into one even when defined across multiple files
    unfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of unfree package names to allow";
    };
  };

  config.nixpkgs.config = {
    # config.cudaCapabilities = [ "8.9" ];
    # Create a predicate function for all packages based on the merged list from each file
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.unfreePackages;
  };
}
