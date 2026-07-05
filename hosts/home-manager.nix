{ inputs, user, ... }:
{
  perSystem = { system, ... }: {
    # Home-manager Standalone Setting
    legacyPackages.homeConfigurations = {
      naduki = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.stable.legacyPackages.${system};
        extraSpecialArgs = {
          inherit inputs user;
        };
        modules = [ ../modules/home-manager/home.nix ];
      };
    };
  };
}
