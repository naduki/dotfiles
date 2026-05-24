{ pkgs, ... }:
{
  programs.zed-editor = {
    # package = pkgs.zed-editor;
    extensions = [
      # Theme
      "poimandres"
    ];
    extraPackages = with pkgs; [
      package-version-server
      shellcheck-minimal
    ];

    userSettings = {
      "restore_on_startup" = "none";
      "auto_update" = false;
      "autosave" = "on_focus_change";
      "base_keymap" = "VSCode";
      "buffer_font_size" = 17;
      "buffer_font_family" = "Moralerspace Radon HW";
      "buffer_font_features"."calt" = 1;
      "ui_font_size" = 16;
      "ui_font_family" = "LXGW WenKai";
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
      "theme" = "poimandres blurry";
      "collaboration_panel"."button" = false;
      "notification_panel"."button" = false;
      "show_call_status_icon" = false;
      "inlay_hints" = {
        "enabled" = true;
        "show_value_hints" = true;
        "show_type_hints" = true;
        "show_parameter_hints" = true;
        "show_other_hints" = true;
        "show_background" = false;
        "edit_debounce_ms" = 700;
        "scroll_debounce_ms" = 50;
        "toggle_on_modifiers_press" = {
          "control" = false;
          "alt" = false;
          "shift" = false;
          "platform" = false;
          "function" = false;
        };
        };
        "terminal" = {
          "font_size" = 15;
          "toolbar"."breadcrumbs" = false;
        };
        "languages" = {
          "Makefile" = {
            "hard_tabs" = true;
          };
        };
        "telemetry" = {
          "diagnostics" = false;
          "metrics" = false;
        };
      };
    };
  }
