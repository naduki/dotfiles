{ pkgs, ... }:
{
  # Nix Setting
  nix = {
    # nix_version -> nix , latest , git , lix
    package = pkgs.nixVersions.latest;
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ]; # 実験機能 (Flakeを有効化)
      warn-dirty = false; # Git の dirty を抑止
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };
}
