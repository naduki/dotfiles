{ inputs, user, ... }:
let
  # Override user.env per configuration so that values derived from it
  # (e.g. networking.hostName) match the configuration being built.
  mkSpecialArgs = env: {
    inherit inputs;
    user = user // { inherit env; };
  };
in {
  # NixOS configurations for different hosts.
  flake.nixosConfigurations = {
    Sway = inputs.stable.lib.nixosSystem {
      specialArgs = mkSpecialArgs "Sway";
      modules = [
        ./kokona
        ./desktop/sway/for_cinnamon.nix
        ./desktop/sway
      ];
    };
    # Intentionally built on unstable to use the latest Cinnamon
    Cinnamon = inputs.unstable.lib.nixosSystem {
      specialArgs = mkSpecialArgs "Cinnamon";
      modules = [
        ./kokona
        ./desktop/cinnamon
      ];
    };
    wsl = inputs.stable.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./wsl ];
    };
  };
}
