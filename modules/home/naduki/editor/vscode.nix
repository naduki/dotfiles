{ config, inputs, lib, pkgs, ... }:
let
  cfg = config.modules.editors.vscode;
  notVSCode = cfg.variant != "vscode";
  isVSCodium = cfg.variant == "vscodium";
  isAntigravity = cfg.variant == "antigravity";

  marketplace = if notVSCode then pkgs.open-vsx else pkgs.vscode-marketplace;

  fhsPackages = ps: with ps; [
    clang-tools
    nixd
    nixfmt
    shellcheck-minimal
  ];
in
{
  config = lib.mkIf (config.programs.vscode.enable) {
    # nixpkgs.overlays / allowUnfreePredicate Settings
    nixpkgs = {
      overlays = [ inputs.nix-vscode-extensions.overlays.default ];
      config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
        "code"
        "vscode"
        "vscode-extension-github-copilot"
        "antigravity"
      ];
    };

    programs.vscode = {
      package = if isAntigravity
      then pkgs.antigravity.fhsWithPackages fhsPackages
      else pkgs.vscode.fhsWithPackages fhsPackages;
      profiles.default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;
        userSettings = {
          "breadcrumbs.enabled" = true;
          "clangd.path" = "clangd";
          "diffEditor.ignoreTrimWhitespace" = false;
          "diffEditor.experimental.useTrueInlineView" = true;

          "editor.bracketPairColorization.enabled" = true;
          "editor.cursorBlinking" = "phase";
          "editor.cursorSmoothCaretAnimation" = "on";
          "editor.cursorStyle" = "line-thin";
          "editor.fontFamily" = "'moralerspace Radon HW', 'LXGW WenKai Mono Light', 'Noto Sans Symbols', 'monospace', monospace";
          "editor.fontSize" = 18;
          "editor.formatOnSave" = false;
          "editor.guides.bracketPairs" = true;
          "editor.tabSize" = 2;
          "editor.minimap.enabled" = false;
          "editor.renderLineHighlight" = "all";
          "editor.renderControlCharacters" = true;
          "editor.renderWhitespace" = "none";
          "editor.scrollbar.vertical" = "visible";
          "editor.smoothScrolling" = true;
          "editor.suggestSelection" = "first";

          "extensions.autoCheckUpdates" = false;
          "extensions.autoUpdate" = false;
          "extensions.ignoreRecommendations" = true;

          "files.autoSave" = "onWindowChange";
          "files.autoGuessEncoding" = true;
          "files.associations".".envrc" = "plaintext"; # Prevent shellcheck from triggering on .envrc files
          "files.exclude" = {
            "**/.direnv" = true;
            "**/.git" = true;
            "**/.DS_Store" = true;
          };

          "nix.enableLSP" = true;
          "nix.serverPath" = "nixd";
          "nix.formatterPath" = "nixfmt";
          "nix.serverSettings"."nixd"."formatting"."command" = [ "nixfmt" ];

          "path-intellisense.autoSlashAfterDirectory" = true;
          "path-intellisense.autoTriggerNextSuggestion" = true;
          "path-intellisense.extensionOnImport" = true;
          "path-intellisense.showHiddenFiles" = true;

          "shellcheck.disableVersionCheck" = true;
          "update.mode" = "none";

          "window.titleBarStyle" = "custom";
          "window.zoomLevel" = 0.5;
          "workbench.colorTheme" = "poimandres";
          "workbench.editor.limit.enabled" = true;
          "workbench.editor.limit.perEditorGroup" = true;
          "workbench.editor.limit.value" = 5;
          # "workbench.iconTheme" = "quill-icons-minimal";
          "workbench.productIconTheme" = "icons-carbon";
          "workbench.sideBar.location" = "left";
          "workbench.startupEditor" = "none";
          "workbench.activityBar.location" = "top";
          "workbench.panel.showLabels" = false;

          "[c]"."editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
          "[cpp]"."editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
          "[cu]"."editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
          "[cuh]"."editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
          "[nix]" = {
            "editor.defaultFormatter" = "jnoortheen.nix-ide";
            "editor.autoClosingBrackets" = "always";
            "editor.tabSize" = 2;
          };
        };
      } // lib.optionalAttrs (!isAntigravity) {
        extensions =
          (with marketplace; [
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
          ])
          ++ (with pkgs.vscode-marketplace; [
            # Common (Explicitly from Marketplace)
            pmndrs.pmndrs
            cdonohue.quill-icons
          ])
          ++ lib.optionals notVSCode (with pkgs.open-vsx-release; [
            rust-lang.rust-analyzer
          ])
          ++ lib.optionals (!notVSCode) (
            (with (pkgs.forVSCodeVersion "${pkgs.vscode.version}").vscode-marketplace-release; [
              # Copilot
              github.copilot
            ]) ++
            (with pkgs.vscode-marketplace-release; [
              # Copilot-chat
              github.copilot-chat
              # Rust
              rust-lang.rust-analyzer
            ])
          );
      };
    };
  };
}
