{ inputs, ... }: {
  # nix devshells
  perSystem = { system, ... }:
    let
      pkgs = import inputs.package {
        inherit system;
      };
      pkgsCuda = import inputs.package {
        inherit system;
        config = {
          allowUnfree = true;
          cudaSupport = true;
          cudaCapabilities = [ "8.9" ];  # for 4000
        };
      };
    in {
      # nix develop <flakeDir>#<name>
      devShells = {
        default = import ./shells/shell.nix { inherit pkgs; };
        cuda    = import ./shells/environments/cuda/shell.nix { pkgs = pkgsCuda; };
        imagen  = import ./shells/environments/imagen/shell-fhs.nix { inherit pkgs; };
      };
    };
}