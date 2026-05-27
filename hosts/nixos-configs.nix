{ inputs, user, ... }:
let
  SpecialArgs = { inherit inputs user; };
in {
  # NixOS configurations for different hosts.
  flake.nixosConfigurations = {
    Sway = inputs.stable.lib.nixosSystem {
      specialArgs = SpecialArgs;
      modules = [
        ../hardware-configuration.nix
        ./sway
      ];
    };
    Cinnamon = inputs.unstable.lib.nixosSystem {
      specialArgs = SpecialArgs;
      modules = [
        ../hardware-configuration.nix
        ./cinnamon
      ];
    };
    wsl = inputs.stable.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./wsl ];
    };
  };
}
