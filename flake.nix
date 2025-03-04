{
  description = "kokona's NixOS configuration";

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/release-24.11";
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
    # vscode marketplace
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
      # flake-compat flake-utils
    };
    # rust
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "package";
    };
    # hardware setting
    # nixos-hardware.url = "github:NixOS/nixos-hardware";
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
    # xremap: Tools to change keys used in Wayland
    # xremap = {
    #   url = "github:xremap/nix-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.home-manager.follows = "home-manager";
    #   # devshell hyprland flake-parts crane treefmt-nix
    # };
  };

  outputs = inputs@{ flake-parts, ... }:
    let
      names = { user = "naduki"; host = "kokona"; };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule
      ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same system.
        # Home-manager
        legacyPackages.homeConfigurations =
          let
            # Stable packages
            pkgs-stable = import inputs.stable {
              inherit system;
              config = {
                # Allow unfree packages
                allowUnfreePredicate = pkg: builtins.elem (inputs.stable.lib.getName pkg) [
                  "blender" "cuda_cudart" "cuda_nvcc" "cuda_cccl" # "unityhub"
                ];
                # Blender CUDAを使えるようにするけどpython-openusdとblenderのビルド(Ryzen7 5700Xで40分くらい)が発生する
                cudaSupport = true;
              };
              # overlays = [ ]; # Overlay in home-manager
            };
          in
          {
            ${names.user} = inputs.home-manager.lib.homeManagerConfiguration {
              pkgs = import inputs.nixpkgs {
                inherit system;
                config.allowUnfreePredicate = pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) [
                  "code" "vscode" # "vscode-extensions.ms-vscode.cpptools"
                  "vscode-extension-github-copilot" "vscode-extension-github-copilot-chat"
                ]; # Allow unfree packages
                overlays = [
                  # ( import ./home/codium_overlay.nix )
                  inputs.nix-vscode-extensions.overlays.default
                ]; # Overlay in home-manager
              };
              extraSpecialArgs = { inherit inputs names pkgs-stable; };
              modules = [ ./home/home.nix ];
            };
          };
        # Nix Development Shells
        devShells =
          let
            pkgs = import inputs.package {
              inherit system;
              config.allowUnfree = true; # Allow all unfree packages
              overlays = [ inputs.rust-overlay.overlays.default ]; # Overlay in temporary shells
            };
          in
          {
            default = import ./shells/shell.nix { inherit pkgs; };
            # $ nix develop .#<name>
            cuda = import ./shells/environments/cuda/shell.nix { inherit pkgs; };
            rust = import ./shells/environments/rust/shell.nix { inherit pkgs; };
            tools = import ./shells/environments/tools/shell.nix { inherit pkgs; };
            # sdui = import ./shells/environments/stablediffusion/shell.nix { inherit pkgs; };
            # sdui = import ./shells/environments/stablediffusion/shell-fhs.nix { inherit pkgs; };
          };
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
        nixosConfigurations = {
          # NixOS Configuration
          "${names.user}@${names.host}" = inputs.nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs names; };
            modules = [ ./hosts/${names.host}.nix ];
          };
          # NixOS-WSL Configuration
          "wsl" = inputs.nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [ ./hosts/wsl.nix ];
          };
        };
      };
    };
}
