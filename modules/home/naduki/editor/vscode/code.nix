{ config, lib, inputs, pkgs, ... }:
let
  fhsPackages = import ./fhs-packages.nix;
in
{
  config = lib.mkIf (config.modules.editors.vscode.variant == "vscode") {
    nixpkgs = {
      overlays = [ inputs.nix-vscode-extensions.overlays.default ];
      config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
        "code"
        "vscode"
        "vscode-extension-github-copilot"
      ];
    };
    programs.vscode = {
      package = pkgs.vscode.fhsWithPackages fhsPackages;
      profiles.default.extensions = (with pkgs.vscode-marketplace; [
        # UI Language
        ms-ceintl.vscode-language-pack-ja

        # Theme & flair
        pmndrs.pmndrs
        cdonohue.quill-icons
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
      # (pkgs.forVSCodeVersion "${pkgs.vscode.version}").vscode-marketplace-release
      (with pkgs.vscode-marketplace-release; [
        # Copilot
        github.copilot
        # Copilot-chat
        github.copilot-chat
        # Rust
        rust-lang.rust-analyzer
      ]);
    };
  };
}
