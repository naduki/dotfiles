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
            # Allow Blender CUDA
            # config = {
            #   allowUnfreePredicate = pkg:
            #     let
            #       pkgName = inputs.stable.lib.getName pkg;
            #     in
            #       builtins.elem pkgName [
            #         "blender" "optix" # "cuda_cudart" "cuda_nvcc" "cuda_cccl"
            #       ] || inputs.stable.lib.hasPrefix "cuda_" pkgName;
            #   cudaCapabilities = [ "8.9" ];  # for 4000
            # };
          };
        };
        modules = [ ./home/home.nix ];
      };
    };
  };
}
