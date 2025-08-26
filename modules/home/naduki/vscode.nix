{ pkgs, inputs, ... }:
{
  # nixpkgs.overlays / allowUnfreePredicate Settings
  nixpkgs = {
    overlays = [ inputs.nix-vscode-extensions.overlays.default ];
    config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
      "code" "vscode" "vscode-extension-github-copilot"
    ];
  };

  programs.vscode = {
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [ clang-tools nixpkgs-fmt nil shellcheck-minimal ]);
    # If you don't use Copilot or Remote-SSH, you can also use VSCodium.
    # package = pkgs.vscodium.fhsWithPackages (ps: with ps; [ clang-tools shellcheck-minimal nixpkgs-fmt nil ]);
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      userSettings = {
        # "C_Cpp.intelliSenseEngine" = "disabled"; # default or Tag Parser or disabled
        # "C_Cpp.errorSquiggles" = "disabled";
        # "C_Cpp.clang_format_style" = "Google";
        # "C_Cpp.clang_format_path" = "${pkgs.clang-tools}/bin/clang-format";
        # "editor.defaultFormatter" = "esbenp.prettier-vscode";

        "clangd.path" = "${pkgs.clang-tools}/bin/clangd";
        "breadcrumbs.enabled" = true;
        "files.autoGuessEncoding" = true;

        "editor.bracketPairColorization.enabled" = true;
        "editor.cursorBlinking" = "phase";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.fontFamily" = "'moralerspace Radon HWNF', 'LXGW WenKai Mono Light', 'Noto Sans Symbols', 'monospace', monospace";
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
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nil}/bin/nil";
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
        "diffEditor.ignoreTrimWhitespace" = false;

        "path-intellisense.autoSlashAfterDirectory" = true;
        "path-intellisense.autoTriggerNextSuggestion" = true;
        "path-intellisense.extensionOnImport" = true;
        "path-intellisense.showHiddenFiles" = true;
        "geminicodeassist.enableTelemetry" = false;

        "github.copilot.chat.commitMessageGeneration.instructions" = [
          {
            "text" = "Please make sure to write in English."; 
          }
        ];

        "nix.serverSettings"."nil"."formatting"."command" = [ "nixpkgs-fmt" ];
        "files.associations".".envrc" = "plaintext";  # Prevent shellcheck from triggering on .envrc files

        "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
        "[c]"."editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
        "[cpp]"."editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
        "[cu]"."editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
        "[cuh]"."editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
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

        # AI
        # saoudrizwan.claude-dev  # Cline
        # google.geminicodeassist

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
}
