{ inputs, ... }: {
  # nix devshells
  perSystem = { system, ... }:
    let
      pkgs = import inputs.package {
        inherit system;
      };
      pkgsRust = import inputs.package {
        inherit system;
        overlays = [ inputs.rust-overlay.overlays.default ];
      };
      pkgsCuda = import inputs.package {
        inherit system;
        config.allowUnfree = true;
        config.cudaSupport = true;
      };
    in {
      # nix develop <flakeDir>#<name>
      devShells = {
        default = import ./shells/shell.nix { inherit pkgs; };
        cuda    = import ./shells/environments/cuda/shell.nix { pkgs = pkgsCuda; };
        imagen  = import ./shells/environments/imagen/shell-fhs.nix { inherit pkgs; };
        rust    = import ./shells/environments/rust/shell.nix { pkgs = pkgsRust; };
      };
    };
}