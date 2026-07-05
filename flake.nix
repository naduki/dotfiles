{
  description = "NixOS and Home-manager configuration";

  inputs = {
    # nixpkgs
    stable.url = "github:NixOS/nixpkgs/release-26.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    package.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.follows = "unstable";
    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # flake-parts
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    # NixOS-WSL
    # nixos-wsl = {
    #   url = "github:nix-community/NixOS-WSL";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   # flake-compat flake-utils
    # };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule
        ./hosts/devshells.nix
        ./hosts/home-manager.nix
        ./hosts/nixos-configs.nix
      ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      # Set Profile Name
      _module.args = {
        user = {
          # UserName, Home-manager Profile
          name = "naduki";
          # HostName
          hosts = "kokona";
          # Desktop Environment
          env = "Sway";
        };
      };
    };
}
