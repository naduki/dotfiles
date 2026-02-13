{ config, lib, ... }:
{
  imports = [
    ./code.nix
    ./codium.nix
    ./antigravity.nix
  ];

  config = lib.mkIf (config.programs.vscode.enable) {
    programs.vscode.profiles.default = {
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

        "json.schemaDownload.enable" = false;

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
    };
  };
}