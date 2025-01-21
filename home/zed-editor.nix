{pkgs, ...}:
{
  programs.zed-editor = {
    enable = true;
    # package = pkgs.zed-editor;
    extensions = [
      # Theme
      "poimandres"
      # Nix
      "nix"
    ];
    extraPackages = with pkgs;[ clang-tools shellcheck-minimal nixpkgs-fmt nil ];
    # userKeymaps = [];
    userSettings = {
      "restore_on_startup" = "none";
      "auto_update" = false;
      "ui_font_size" = 16;
      "ui_font_family" = "Moralerspace Radon HWNF";
      "buffer_font_size" = 17;
      "buffer_font_family" = "Moralerspace Radon HWNF";
      "tab_size" = 2;
      # "load_direnv" = "shell_hook";
      "current_line_highlight" = "gutter";
      "cursor_shape" = "block";
      "theme" = {
        "mode" = "system";
        "light" = "poimandres";
        "dark" = "poimandres";
      };
      "collaboration_panel" = {
        "button" = false;
      };
      "notification_panel" = {
        "button" = false;
      };
      "show_call_status_icon" = false;
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
	    "languages" = {
		    "Nix" = {
			    "language_servers" = [ "nil" "!nixd" ];
					"formatter" = {
            "external" = {
              "command" = "nixpkgs-fmt";
						};
          };
		    };
	    };
			"lsp" =  {
        "nil" = {
          "initialization_options" = {
            "formatting" = {
              "command"= [ "nixpkgs-fmt" ];
            };
          };
        };
      };
      "telemetry" = {
        "diagnostics" = false;
        "metrics" = false;
      };
    };
  };
}
