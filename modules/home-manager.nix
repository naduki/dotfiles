{ inputs, ... }:
let
  myconf = import ./myconf.nix;
in {
  perSystem = { system, ... }: {
    legacyPackages.homeConfigurations =
      let
        pkgs-stable = import inputs.stable {
          inherit system;
          config.allowUnfreePredicate = pkg: builtins.elem (inputs.stable.lib.getName pkg) [
            "blender" "cuda_cudart" "cuda_nvcc" "cuda_cccl"
          ];
        };
      in {
        ${myconf.user} = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfreePredicate = pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) [
              "code" "vscode" "vscode-extension-github-copilot"
            ];
            overlays = [
              inputs.nix-vscode-extensions.overlays.default
            ];
          };
          extraSpecialArgs = { inherit inputs myconf pkgs-stable; };
          modules = [ ./home/home.nix ];
        };
      };
  };
}