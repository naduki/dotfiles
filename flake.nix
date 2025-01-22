{
  description = " kokona's NixOS configuration";

  inputs = {
    # nixpkgs
    # stable.url = "github:NixOS/nixpkgs/release-24.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    package.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.follows = "unstable";
    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager";  # unstable
      # url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hardware setting
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    # rust
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # vscode marketplace
    # nix-vscode-extensions = {
    #   url = "github:nix-community/nix-vscode-extensions";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   # flake-compat flake-utils
    # };
    # NixOS-WSL
    # nixos-wsl = {
    #   url = "github:nix-community/NixOS-WSL";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.flake-utils.follows = "flake-utils";
    #   # flake-compat
    # };
    # VScode Server
    # vscode-server = {
    #   url = "github:nix-community/nixos-vscode-server";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.flake-utils.follows = "flake-utils";
    # };
    # キー設定を変更するツール xremap waylandで使う
    # xremap = {
    #   url = "github:xremap/nix-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.home-manager.follows = "home-manager";
    #   # devshell hyprland flake-parts crane treefmt-nix
    # };
  };

  outputs = { self, nixpkgs, package, home-manager, rust-overlay, nixos-hardware, ... }@inputs:
  let
    supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
    # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
    forAllSystems = package.lib.genAttrs supportedSystems;
    system = "x86_64-linux";
    specialArgs = { inherit inputs; }; # `inputs = inputs;`と等しい
  in {
    nixosConfigurations = {
      # システム全体の設定
      kokona_OS = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [ ./hosts/kokona.nix ];
      };
      # NixOS-WSLのFlake設定 未検証
      wsl = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [ ./hosts/wsl.nix ];
      };
    };
    homeConfigurations = {
      # ユーザー環境用設定
      kokona = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config = {
            # プロプライエタリなパッケージを許可
            allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
              "blender" "cuda_cudart" "cuda_nvcc" "cuda_cccl"
              # "unityhub" "vscode-extensions.ms-vscode.cpptools"
            ];
            cudaSupport = true; # Blender CUDAを使えるようにするけどpython-openusdとblenderのビルド(40分くらい)が発生する
          };
          overlays = [
            # ( import ./home/codium_overlay.nix )
            # nix-vscode-extensions.overlays.default
          ]; # home-manager内で上書きで導入する場合
        };
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home/home.nix ];
      };
    };
    # nix develop
    devShells = forAllSystems (system:
      let
        pkgs = import package {
          inherit system;
          config.allowUnfree = true;  # Allow all unfree packages
          overlays = [ rust-overlay.overlays.default ]; # 一時シェルにおいて上書きで導入する場合
        };
      in {
        default = import ./shells/shell.nix { inherit pkgs; };
        # $ nix develop .#<name>
        cuda = import ./shells/environments/cuda/shell.nix { inherit pkgs; };
        rust = import ./shells/environments/rust/shell.nix { inherit pkgs; };
        tools = import ./shells/environments/tools/shell.nix { inherit pkgs; };
      }
    );
  };
}
