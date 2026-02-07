{ config, lib, inputs, pkgs, ... }:
let
  fhsPackages = import ./fhs-packages.nix;
in
{
  config = lib.mkIf (config.modules.editors.vscode.variant == "vscodium") {
    nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];

    programs.vscode = {
      package = pkgs.vscodium.fhsWithPackages fhsPackages;
      profiles.default.extensions = (with pkgs.open-vsx; [
        # UI Language
        ms-ceintl.vscode-language-pack-ja

        # Theme & flair
        antfu.icons-carbon

        # C/C++
        llvm-vs-code-extensions.vscode-clangd

        # Nix
        jnoortheen.nix-ide

        # Misc
        timonwong.shellcheck
        mkhl.direnv
        usernamehw.errorlens
        donjayamanne.githistory
        christian-kohler.path-intellisense
      ]) ++
      (with pkgs.open-vsx-release; [
        # Rust
        rust-lang.rust-analyzer
      ]) ++
      (with pkgs.vscode-marketplace; [
        # Common (Explicitly from Marketplace)
        pmndrs.pmndrs
        cdonohue.quill-icons
      ]);
    };
  };
}
