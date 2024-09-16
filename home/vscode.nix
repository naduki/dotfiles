{ pkgs, ... }:
{
  # todo: # $HOME/.vscode-oss/argv.jsonに # "locale": "ja" があるようにしたい
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhsWithPackages (ps: with ps; [ clang-tools shellcheck-minimal nixpkgs-fmt nil ]); # pkgs.vscodium-fhs;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    # mutableExtensionsDir = true;
    userSettings = {
      "C_Cpp.intelliSenseEngine" = "disabled"; # default or Tag Parser or disabled
      "C_Cpp.errorSquiggles" = "disabled";
      "clangd.path" = "${pkgs.clang-tools}/bin/clangd";
      "clang-format.executable" = "${pkgs.clang-tools}/bin/clang-format";
      "breadcrumbs.enabled" = true;
      "files.autoGuessEncoding" = true;

      "editor.bracketPairColorization.enabled" = true;
      "editor.cursorBlinking" = "phase";
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.fontFamily" = "'moralerspace Radon HWNF','Klee One','Material Design Icons',monospace";
      "editor.fontSize" = 17;
      "editor.formatOnSave" = false;
      # "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "editor.minimap.enabled" = false;
      "editor.renderLineHighlight" = "all";
      "editor.renderControlCharacters" = true;
      "editor.renderWhitespace" = "none";
      "editor.scrollbar.vertical" = "visible";
      "editor.smoothScrolling" = true;
      "editor.suggestSelection" = "first";

      "extensions.autoCheckUpdates" = false;
      "files.autoSave" = "onWindowChange";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nil}/bin/nil";  # "${lib.getExe pkgs.nil}"
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

      "path-intellisense.autoSlashAfterDirectory" = true;
      "path-intellisense.autoTriggerNextSuggestion" = true;
      "path-intellisense.extensionOnImport" = true;
      "path-intellisense.showHiddenFiles" = true;

      "nix.serverSettings"."nil"."formatting"."command" = [ "nixpkgs-fmt" ];
      "files.associations".".envrc" = "plaintext";

      "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
      "[c]"."editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd"; # "xaver.clang-format"
      "[cpp]"."editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
      "[cu]"."editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
      "[cuh]"."editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
    };
    extensions = with pkgs.vscode-marketplace; [
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

      # Nix
      # jnoortheen.nix-ide
      # kamadorueda.alejandra

      # Lua
      # sumneko.lua

      # Rust
      rust-lang.rust-analyzer
      serayuzgur.crates

      # hediet.vscode-drawio
      timonwong.shellcheck

      # Misc
      # esbenp.prettier-vscode
      mkhl.direnv
      usernamehw.errorlens
      donjayamanne.githistory
      christian-kohler.path-intellisense
    ] ++ ( with pkgs.vscode-extensions; [
      # C/C++
      # nix-vscode-extensions では導入できないので
      ms-vscode.cpptools
      # Nix
      # 24.05のCodiumで動かすためにバージョンダウン
      jnoortheen.nix-ide
    ]);
  };
}
