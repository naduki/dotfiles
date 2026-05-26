{ inputs, ... }:
{
  perSystem = { system, ... }: {
    # Home-manager Standalone Setting
    legacyPackages.homeConfigurations = {
      naduki = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.stable.legacyPackages.${system};
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [ ../modules/home-manager/home.nix ];
      };
    };
  };
}
