{ inputs, ... }:
let
  myconf = import ./myconf.nix;
in
{
  perSystem = { system, ... }: {
    # Home-manager Standalone Setting
    legacyPackages.homeConfigurations = {
      ${myconf.user} = inputs.home-manager.lib.homeManagerConfiguration {
        # Use unstable packages by default
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {
          inherit inputs myconf;
          # Pass stable package set with alias for use
          pkgs-stable = import inputs.stable {
            inherit system;
            config.allowUnfreePredicate = pkg: builtins.elem (inputs.stable.lib.getName pkg) [
              # Allow Blender CUDA
              "blender" "cuda_cudart" "cuda_nvcc" "cuda_cccl"
            ];
          };
        };
        modules = [ ./home/home.nix ];
      };
    };
  };
}
