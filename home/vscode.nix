{ pkgs, ... }:
{
  programs.vscode = {
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [ clang-tools shellcheck-minimal nixpkgs-fmt nil ]);
    # Copilot Remote-SSH を使わないなら VSCodium でも OK
    # package = pkgs.vscodium.fhsWithPackages (ps: with ps; [ clang-tools shellcheck-minimal nixpkgs-fmt nil ]);
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
      "editor.fontFamily" = "'moralerspace Radon HWNF','Klee One','Material Design Icons',monospace";
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

      "path-intellisense.autoSlashAfterDirectory" = true;
      "path-intellisense.autoTriggerNextSuggestion" = true;
      "path-intellisense.extensionOnImport" = true;
      "path-intellisense.showHiddenFiles" = true;

      "nix.serverSettings"."nil"."formatting"."command" = [ "nixpkgs-fmt" ];
      "files.associations".".envrc" = "plaintext";  # shellcheckが反応しないようにする

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
      # pkief.material-icon-theme
      # sazumiviki.kawaine-theme
      pmndrs.pmndrs
      cdonohue.quill-icons
      antfu.icons-carbon

      # C/C++
      llvm-vs-code-extensions.vscode-clangd

      # AI
      saoudrizwan.claude-dev

      # Nix
      jnoortheen.nix-ide

      # Lua
      # sumneko.lua

      # Misc
      # hediet.vscode-drawio
      timonwong.shellcheck
      mkhl.direnv
      usernamehw.errorlens
      donjayamanne.githistory
      christian-kohler.path-intellisense
    ]
    ) ++ (with pkgs.vscode-marketplace-release; [
      # Copilot
      github.copilot
      github.copilot-chat
      # Rust
      rust-lang.rust-analyzer
      # Misc
      # ms-vscode-remote.remote-ssh
    ]
    # ) ++ (with pkgs.vscode-extensions; [
    #   # C/C++ | nix-vscode-extensions では導入できないので
    #   ms-vscode.cpptools
    # ]
    );
  };
}
