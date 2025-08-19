{ inputs, ... }:
let
  myconf = import ./myconf.nix;
in {
  flake.nixosConfigurations = {
    "${myconf.user}@${myconf.host}" = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs myconf; };
      modules = [
        ../hardware-configuration.nix
        ./hosts/${myconf.host}.nix
      ];
    };
    wsl = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./hosts/wsl.nix ];
    };
  };
}