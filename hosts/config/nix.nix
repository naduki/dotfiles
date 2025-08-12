{ pkgs, ... }:
{
  # Nix configuration
  nix = {
    # nix_version -> nix , latest , git , lix
    package = pkgs.nixVersions.latest;
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ]; # Enable experimental features (Flakes)
      warn-dirty = false; # Suppress Git dirty warnings
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };
}
