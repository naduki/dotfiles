{ pkgs, lib, ... }:
{
  # todo: # $HOME/.vscode-oss/argv.jsonに # "locale": "ja" があるようにしたい
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhsWithPackages (ps: with ps; [ shellcheck-minimal nixpkgs-fmt ]); # pkgs.vscodium-fhs;
    # package = pkgs.vscodium.fhsWithPackages (ps: with ps; [ clang clang-tools shellcheck-minimal nixpkgs-fmt ]);
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    # mutableExtensionsDir = true;
    userSettings = {
      # "C_Cpp.intelliSenseEngine" = "disabled"; # default or Tag Parser or disabled
      "C_Cpp.errorSquiggles" = "disabled";
      # "clangd.path" = "${pkgs.clang-tools}/bin/clangd";
      # "clang-format.executable" = "${pkgs.clang-tools}/bin/clang-format";
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
      "nix.serverPath" = "${lib.getExe pkgs.nil}";
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
      
      "nix.serverSettings"."nil"."formatting"."command" = [ "nixpkgs-fmt" ];
      "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
      # "[c]"."editor.defaultFormatter" = "xaver.clang-format";
      # "[cpp]"."editor.defaultFormatter" = "xaver.clang-format";
    };
    extensions = with pkgs.vscode-extensions; [
      # UI Language
      # ms-ceintl.vscode-language-pack-ja

      # Theme & flair
      # pkief.material-icon-theme

      # C/C++
      ms-vscode.cpptools
      # llvm-vs-code-extensions.vscode-clangd

      # Nix
      jnoortheen.nix-ide
      # kamadorueda.alejandra

      # Lua
      # sumneko.lua

      # Rust
      rust-lang.rust-analyzer
      serayuzgur.crates

      # Misc
      mkhl.direnv
      usernamehw.errorlens
      donjayamanne.githistory
      # esbenp.prettier-vscode
      christian-kohler.path-intellisense
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # Nixpkgになかったり、あっても古い・勝手に最新版を入れる拡張機能を別で導入・管理する
      {
        # poimandres
        publisher = "pmndrs";
        name = "pmndrs";
        version = "0.3.7";
        sha256 = "0sn1mg8iik51l9pqscy1g8xs4q6x4mgg2xpxjqxilgya3bw0f122";
      }
      {
        # Quill Icons
        publisher = "cdonohue";
        name = "quill-icons";
        version = "0.0.2";
        sha256 = "06lsv6jk0ncss7gq6rh1597jnp6nv6sc9gd6x1l8abn9a8wwsbw6";
      }
      {
        # Carbon Product Icons
        publisher = "antfu";
        name = "icons-carbon";
        version = "0.2.6";
        sha256 = "05rv2piclq0sa2mxa7xfbfvfh9k3k8b2ikyi5bd02zlvwwp8gis7";
      }
      {
        # 日本語化 1年前は流石に古い
        name = "vscode-language-pack-ja";
        publisher = "ms-ceintl";
        version = "1.93.2024090409";
        sha256 = "0mf8m65w2lm0r3yjjrlgkmc860y77bqxb6kx64a668pw7gk4rlwh";
      }
      {
        # ShellCheck
        publisher = "timonwong";
        name = "shellcheck";
        version = "0.37.1";
        sha256 = "sha256-JSS0GY76+C5xmkQ0PNjt2Nu/uTUkfiUqmPL51r64tl0=";
      }
      # {
      #   # Draw.io
      #   publisher = "hediet";
      #   name = "vscode-drawio";
      #   version = "1.6.6";
      #   sha256 = "0hwvcncl2206p7yjh7flr9qxxpk80mdj32fqh7wi57fb5sfi5xs8";
      # }
      # {
      #   # Kawaine Theme
      #   publisher = "sazumiviki";
      #   name = "kawaine-theme";
      #   version = "0.0.7";
      #   sha256 = "06k4sxb3ajfm6k1jxfrh0nmcmsqjh1zn9jgp5gignsbd0rhzzsng";
      # }
      # template
      # {
      #   publisher = "";
      #   name = "";
      #   version = "";
      #   sha256 = "";
      # }
    ];
  };
}
