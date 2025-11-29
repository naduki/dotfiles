{
  description = "NixOS and Home-manager configuration";

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/release-25.11";
    package.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager"; # unstable
      # url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # flake-parts
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    # Rust
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "package";
    };
    # Hyprland and Quickshell base configuration
    # illogical-impulse-dotfiles = {
    #   # url = "github:end-4/dots-hyprland/38c76fe86b74a6ec01e9ddaa4c2240ca032b8ae0";
    #   url = "github:naduki/dots-hyprland/mynixos";
    #   flake = false;
    # };
    # quickshell = {
    #   url = "github:quickshell-mirror/quickshell/fc704e6b5d445899a1565955268c91942a4f263f";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # VSCode marketplace
    # nix-vscode-extensions = {
    #   url = "github:nix-community/nix-vscode-extensions";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   # flake-compat flake-utils
    # };
    # NixOS-WSL
    # nixos-wsl = {
    #   url = "github:nix-community/NixOS-WSL";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   # flake-compat flake-utils
    # };
    # VScode Server
    # vscode-server = {
    #   url = "github:nix-community/nixos-vscode-server";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   # flake-utils
    # };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule
        ./modules/devshells.nix
        ./modules/home-manager.nix
        ./modules/nixos-configs.nix
      ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
    };
}
