{ pkgs ? import <nixpkgs> {}, ... }:

pkgs.mkShell {
  # Basic development tools
  nativeBuildInputs = with pkgs; [ git wget nixd nixfmt ];

  # Isolate the host environment (for nix-shell)
  # This setting prevents inheritance of the host environment
  pure = true;

  shellHook = ''
    echo "Welcome to nix development environment!"
  '';
}
