{ config, inputs, lib, pkgs, ... }:
{
  config = lib.mkIf (config.programs.vscode.enable) {
    # nixpkgs.overlays / allowUnfreePredicate Settings
    nixpkgs = {
      overlays = [ inputs.nix-vscode-extensions.overlays.default ];
      config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
        "code"
        "vscode"
        "vscode-extension-github-copilot"
      ];
    };

    programs.vscode = {
      package = pkgs.vscode.fhsWithPackages (ps: with ps; [ clang-tools nixd nixfmt-rfc-style shellcheck-minimal ]);
      # If you don't use Copilot or Remote-SSH, you can also use VSCodium.
      # package = pkgs.vscodium.fhsWithPackages (ps: with ps; [ clang-tools shellcheck-minimal nixpkgs-fmt nil ]);
      profiles.default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;
        userSettings = {
          "breadcrumbs.enabled" = true;
          "clangd.path" = "clangd";
          "diffEditor.ignoreTrimWhitespace" = false;

          "editor.bracketPairColorization.enabled" = true;
          "editor.cursorBlinking" = "phase";
          "editor.cursorSmoothCaretAnimation" = "on";
          "editor.fontFamily" = "'moralerspace Radon HW', 'LXGW WenKai Mono Light', 'Noto Sans Symbols', 'monospace', monospace";
          "editor.fontSize" = 19;
          "editor.formatOnSave" = false;
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
          "workbench.iconTheme" = "quill-icons-minimal";
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
        extensions = (with pkgs.vscode-marketplace; [
          # UI Language
          ms-ceintl.vscode-language-pack-ja

          # Theme & flair
          # sazumiviki.kawaine-theme
          pmndrs.pmndrs
          cdonohue.quill-icons
          antfu.icons-carbon

          # C/C++
          llvm-vs-code-extensions.vscode-clangd

          # Nix
          jnoortheen.nix-ide

          # Misc
          # hediet.vscode-drawio
          timonwong.shellcheck
          mkhl.direnv
          usernamehw.errorlens
          donjayamanne.githistory
          christian-kohler.path-intellisense
        ]
        ) ++ (with (pkgs.forVSCodeVersion "${pkgs.vscode.version}").vscode-marketplace-release; [
          # Copilot
          github.copilot
          ## Cannot be installed because engineversion contains a date
          # github.copilot-chat
        ]
        ) ++ (with pkgs.vscode-marketplace-release; [
          # Copilot-chat
          github.copilot-chat
          # Rust
          rust-lang.rust-analyzer
          # Misc
          # ms-vscode-remote.remote-ssh
        ]
          # ) ++ (with pkgs.vscode-extensions; [
          #   # C/C++ | It cannot be installed with nix-vscode-extensions, so if necessary
          #   ms-vscode.cpptools
          # ]
        );
      };
    };
  };
}
