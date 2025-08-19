{ inputs, ... }: {
  perSystem = { system, ... }:
    let
      pkgs = import inputs.package {
        inherit system;
        config.allowUnfree = true;
        overlays = [ inputs.rust-overlay.overlays.default ];
      };
    in {
      devShells = {
        default = import ./shells/shell.nix { inherit pkgs; };
        cuda    = import ./shells/environments/cuda/shell.nix { inherit pkgs; };
        rust    = import ./shells/environments/rust/shell.nix { inherit pkgs; };
        ilp     = import ./shells/environments/illogical_python/shell.nix { inherit pkgs; };
        tools   = import ./shells/environments/tools/shell.nix { inherit pkgs; };
        sdui    = import ./shells/environments/stablediffusion/shell-fhs.nix { inherit pkgs; };
      };
    };
}