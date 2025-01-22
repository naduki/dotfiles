{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    # package = pkgs.zed-editor;
    extensions = [
      # Theme
      "poimandres"
      # Shell
      "basher"
      # Nix
      "nix"
    ];
    extraPackages = with pkgs; [ clang-tools shellcheck-minimal nixpkgs-fmt nil ];
    # userKeymaps = [];
    userSettings = {
      "restore_on_startup" = "none";
      "auto_update" = false;
      "autosave" = "on_focus_change";
      "buffer_font_size" = 17;
      "buffer_font_family" = "Moralerspace Radon HWNF";
      "ui_font_size" = 16;
      "ui_font_family" = "Moralerspace Radon HWNF";
      "tab_size" = 2;
      "format_on_save" = "off";
      "file_scan_exclusions" = [
        "**/.git"
        "**/.svn"
        "**/.hg"
        "**/.jj"
        "**/CVS"
        "**/.DS_Store"
        "**/Thumbs.db"
        "**/.classpath"
        "**/.settings"
        "**/.direnv"
      ];
      "current_line_highlight" = "gutter";
      "cursor_shape" = "block";
      "theme" = "poimandres";
      "collaboration_panel"."button" = false;
      "notification_panel"."button" = false;
      "show_call_status_icon" = false;
      "assistant" = {
        "enabled" = true;
        "version" = "2";
        "default_model" = {
          "provider" = "copilot_chat";
          "model" = "claude-3-5-sonnet";
        };
      };
      "terminal" = {
        "font_size" = 15;
        "toolbar"."breadcrumbs" = false;
      };
      "languages" = {
        "Nix" = {
          "language_servers" = [ "nil" "!nixd" ];
          "formatter"."external"."command" = "nixpkgs-fmt";
        };
      };
      "lsp" = {
        "nil"."initialization_options"."formatting"."command" = [ "nixpkgs-fmt" ];
      };
      "telemetry" = {
        "diagnostics" = false;
        "metrics" = false;
      };
    };
  };
}
