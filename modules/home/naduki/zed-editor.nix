{ pkgs, ... }:
{
  programs.zed-editor = {
    # package = pkgs.zed-editor;
    extensions = [
      # Theme
      "poimandres"
      # Nix
      "nix"
      # Latex
      "LaTeX"
    ];
    extraPackages = with pkgs; [
      clang-tools
      shellcheck-minimal
      nixpkgs-fmt
      nil
    ];
  };
}
