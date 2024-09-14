{
  description = " kokona's NixOS configuration";

  inputs = {
    # nixpkgs
    stable.url = "github:NixOS/nixpkgs/release-24.05";
    # unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    package.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.follows = "stable";
    # home-manager
    home-manager = {
      # url = "github:nix-community/home-manager";  # unstable
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # rust
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # vscode marketplace
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
      # flake-compat flake-utils
    };
    # hardware setting
    # nixos-hardware.url = "github:NixOS/nixos-hardware";
    # flake-utils
    # systems.url = "github:nix-systems/default";
    # flake-utils = {
    #   url  = "github:numtide/flake-utils";
    #   inputs.systems.follows = "systems";
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
    # キー設定を変更するツール xremap
    # xremap = {
    #   url = "github:xremap/nix-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.home-manager.follows = "home-manager";
    #   # devshell hyprland flake-parts crane treefmt-nix
    # };
  };

  outputs = { self, nixpkgs, package, home-manager, rust-overlay, nix-vscode-extensions, ... }@inputs:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = package.lib.genAttrs supportedSystems;
      system = "x86_64-linux"; # supportedSystemsを使いたいな
      specialArgs = { inherit inputs; }; # `inputs = inputs;`と等しい
    in
    {
      nixosConfigurations = {
        # システム全体の設定
        myNixOS = nixpkgs.lib.nixosSystem {
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
              allowUnfree = true; # プロプライエタリなパッケージを許可
              cudaSupport = true; # Blender CUDAを使えるようにするけどpython-openusdとblenderのビルド(40分くらい)が発生する
            };
            overlays = [ nix-vscode-extensions.overlays.default ];  # home-manager内で上書きで導入する場合
          };
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home/home.nix ];
        };
      };
      # nix develop を使えるようにする -> ここのsystemはどうなってる？
      devShells = forAllSystems (system:
        let
          pkgs = import package {
            inherit system;
            config.allowUnfree = true;
            overlays = [ (import rust-overlay) ]; # 一時シェルで上書きで導入する場合
          };
        in
        with pkgs;{
          default = mkShell {
            buildInputs = [
              git # poppler_utils
              # gcc gnuplot
              # jq unzip
              # pcl meshlab
              # libreoffice lapce
              # protontricks # winetricks
            ];
            # shellHook = '''';
          };
          # $ nix develop .#<name> で使う
          django = mkshell {
            buildInputs = [
              python311
              python311Packages.django
              python311Packages.asgiref
              python311Packages.sqlparse
            ];
            shellHook = ''
              alias runserver='python3 manage.py runserver'
            '';
          };
          nkf = mkShell {
            buildInputs = [ nkf ];
            shellHook = ''
              alias nkfsj='nkf -w --overwrite'
            '';
          };
          rust = mkShell {
            buildInputs = [
              openssl
              pkg-config # zed-editor
              # rust-bin.stable.latest.default
              (rust-bin.stable.latest.default.override { extensions = [ "rust-src" ]; })
            ];
            # shellHook = '''';
          };
          vera = mkShell {
            buildInputs = [ veracrypt ];
            shellHook = ''
              WXSUPPRESS_SIZER_FLAGS_CHECK=1
            '';
          };
        });
    };
}
