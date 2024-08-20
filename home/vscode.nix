{ pkgs, lib, ...}: 
{
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium-fhs;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      # mutableExtensionsDir = true;
      userSettings = {
        # "C_Cpp.intelliSenseEngine" = "disabled";  # default or Tag Parser or disabled
        "C_Cpp.errorSquiggles" = "disabled";
        "breadcrumbs.enabled" = true;
        "files.autoGuessEncoding" = true;

        "editor.bracketPairColorization.enabled" = true;
        "editor.cursorBlinking" = "phase";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.fontFamily" = "'moralerspace Radon HWNF','Klee One','Material Design Icons',monospace";
        "editor.fontSize" = 17;
        "editor.formatOnSave" = false;  # ? prettier
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
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
        # "workbench.action.configureLocale" = "ja";
      };
      extensions = with pkgs.vscode-extensions;
        [
          # UI Language
          # ms-ceintl.vscode-language-pack-ja

          # Theme & flair
          # pkief.material-icon-theme

          # C/C++
          ms-vscode.cpptools
          # llvm-vs-code-extensions.vscode-clangd

          # Nix
          # bbenoist.nix
          jnoortheen.nix-ide
          # kamadorueda.alejandra

          # Python
          # ms-python.python

          # Lua
          sumneko.lua

          # Rust
          rust-lang.rust-analyzer
          serayuzgur.crates

          # Misc
          mkhl.direnv
          usernamehw.errorlens
          donjayamanne.githistory
          # esbenp.prettier-vscode
          christian-kohler.path-intellisense
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        # Nixpkgになかったり、あっても古い・おかしな挙動をする拡張機能を別で導入・管理する
          {
            # 日本語化 1年前は流石に古すぎ
            name = "vscode-language-pack-ja";
            publisher = "ms-ceintl";
            version = "1.92.2024081409";
            sha256 = "142qilsz5j5adwfkxbicm6jnblgvp9bc33hh8jpzzfnld33n8mfr";
          }
          {
            # ShellCheck: 最新版があると勝手にアップグレードする
            # -> upgrade時にはversionだけ変えてsha256を一旦コメントアウト。エラー出力のsha256にしてインストール
            publisher = "timonwong";
            name = "shellcheck";
            version = "0.37.1";
            sha256 = "sha256-JSS0GY76+C5xmkQ0PNjt2Nu/uTUkfiUqmPL51r64tl0=";
          }
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
            # Prettier: 最新版を勝ってに入れてる？
            name = "prettier-vscode";
            publisher = "esbenp";
            version = "11.0.0";
            sha256 = "1fcz8f4jgnf24kblf8m8nwgzd5pxs2gmrv235cpdgmqz38kf9n54";
          }
          # {
          #   # Draw.io
          #   publisher = "hediet";
          #   name = "vscode-drawio";
          #   version = "1.6.6";
          #   sha256 = "0hwvcncl2206p7yjh7flr9qxxpk80mdj32fqh7wi57fb5sfi5xs8";
          # }
          # {
          #   # Nsight (CUDA)
          #   publisher = "NVIDIA";
          #   name = "nsight-vscode-edition";
          #   version = "2023.2.32964508";
          #   sha256 = "1vzpgh153zc142cc8c99pymmnf6j64nykfzikmc42sikcinifg3l";
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
  # $HOME/.vscode-oss/argv.jsonに # "locale": "ja" があるようにしたい
}
