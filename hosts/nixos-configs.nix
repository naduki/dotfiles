{ inputs, ... }:
{
  # NixOS configurations for different hosts.
  flake.nixosConfigurations = {
    Sway = inputs.stable.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ../hardware-configuration.nix
        ./sway
      ];
    };
    Cinnamon = inputs.unstable.lib.nixosSystem {
      specialArgs = { inherit inputs; };
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
