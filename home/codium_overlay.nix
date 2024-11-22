final: prev: {
  # https://nixos-and-flakes.thiscute.world/nixpkgs/overlays
  # https://vscodium.com/
  # https://github.com/VSCodium/vscodium
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/editors/vscode/vscodium.nix
  vscodium = prev.vscodium.overrideAttrs (oldAttrs: rec {
    version = "1.95.3.24321";
    src = (builtins.fetchurl {
      url = "https://github.com/VSCodium/vscodium/releases/download/${version}/VSCodium-linux-x64-${version}.tar.gz";
      sha256 = "0948jbnhjra09bvf9acrl6b2dp1xar5ajahmzy0cwf6dbidfms5y";
    });
  });
}