{ lib, pkgs, ... }:
{
  # Allow unfree packages Nvidia Driver と Steam を許可する
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11" "nvidia-settings" "nvidia-persistenced"
    "steam" "steam-original" "steam-unwrapped" "steam-run"
  ];
  # Nix Setting
  nix = {
    # nixversion -> nix , latest , git , lix
    package = pkgs.nixVersions.latest;
    settings = {
      auto-optimise-store = true; # Nix storeの最適化
      experimental-features = [ "nix-command" "flakes" ]; # 実験機能 (Flakeを有効化)
      warn-dirty = false; # Git の dirty を抑止
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };
}