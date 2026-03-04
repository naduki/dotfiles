{ pkgs-stable, ... }:
{
  imports = [
    ./gtk-theme.nix
    ./scripts/fuzzel_power.nix
    ./scripts/sc-recoder.nix
  ];

  # --- Essential Packages ---
  home.packages = with pkgs-stable; [
    pavucontrol

    libnotify
    grim          # Screenshot
    slurp         # Region selection
    sway-audio-idle-inhibit
    wf-recorder   # Screen recorder
  ];

  programs = {
    # Automatically start Sway on tty1. If it fails or is run on another virtual terminal, set LANG=C.
    bash.initExtra = ''
      [ -z "$DISPLAY" ] && { [ "''${XDG_VTNR:-0}" -eq 1 ] && exec sway || export LANG=C; }
    '';
    # Launcher
    fuzzel = {
      enable = true;
      package = pkgs-stable.fuzzel;
      settings = {
        main = {
          terminal = "wezterm";
          sort-result = "yes";
          match-mode = "fzf";
          # Effectively reset or disable sorting by frequency
          cache = "/dev/null";
        };
        colors = {
          background="1b1e28ff";
          text="a6accdff";
          match="5de4c7ff";
          selection="303340ff";
          selection-text="e4f0fbff";
          selection-match="5de4c7ff";
          border="303340ff";
        };
      };
    };
    # Sway Screen Lock
    swaylock = {
      enable = true;
      package = pkgs-stable.swaylock;
      settings = {
        daemonize = true;
        show-failed-attempts = true;
        ignore-empty-password = true;

        image="/home/naduki/.config/wallpaper/wallpaper";

        # Appearance
        color="1b1e28";
        font="Sans";
        # Ring colors
        inside-color="1b1e28";
        ring-color="303340";
        line-color="1b1e28";
        separator-color="1b1e28";
        # Text colors
        text-color="a6accd";
        key-hl-color="5de4c7";
        bs-hl-color="d0679d";
        # Ring colors (verifying)
        inside-ver-color="1b1e28";
        ring-ver-color="add7ff";
        text-ver-color="add7ff";
        # Ring colors (wrong)
        inside-wrong-color="1b1e28";
        ring-wrong-color="d0679d";
        text-wrong-color="d0679d";
        # Ring colors (clear)
        inside-clear-color="1b1e28";
        ring-clear-color="e4f0fb";
        text-clear-color="e4f0fb";
        # Layout text
        layout-bg-color="1b1e28";
        layout-text-color="a6accd";
      };
    };
    # Sway Status bar
    waybar = {
      enable = true;
      package = pkgs-stable.waybar;
      style = builtins.readFile ../../../config/waybar/style.css;
    };
  };

  services = {
    autotiling = {
      enable = true;
      package = pkgs-stable.autotiling-rs;
    };
    # Clipboard
    cliphist = {
      enable = true;
      package = pkgs-stable.cliphist;
      clipboardPackage = pkgs-stable.wl-clipboard;
    };
    polkit-gnome.enable = true;
    # Notifications
    mako = {
      enable = true;
      package = pkgs-stable.mako;
      settings = {
        "actionable=true" = {
          anchor = "top-left";
        };
        actions = true;
        anchor = "top-right";
        background-color = "#1b1e28";
        text-color = "#a6accd";
        border-color = "#303340";
        border-size = 2;
        border-radius = 15;
        padding = "10,20";
        default-timeout = 5000;
        font = "monospace 10";
        height = 110;
        icons = true;
        max-icon-size = 64;
        ignore-timeout = false;
        layer = "overlay";
        margin = "20";
        markup = true;
        width = 300;
      };
      extraConfig = "
        [urgency=low]
        border-color=#303340

        [urgency=normal]
        border-color=#5de4c7

        [urgency=high]
        border-color=#d0679d
        default-timeout=0

        [category=mpd]
        default-timeout=2000
        group-by=category
      ";
    };
    # Sway Idle management
    swayidle = {
      enable = true;
      package = pkgs-stable.swayidle;
      events = {
        "before-sleep" = "swaylock -f";
      };
      timeouts = [
        {
          timeout = 300;
          command = "swaylock -f";
        }
        {
          timeout = 600;
          command = ''swaymsg "output * power off"'';
          resumeCommand = ''swaymsg "output * power on"'';
        }
      ];
    };
    # Enable playerctld daemon for media player control
    playerctld = {
      enable = true;
      package = pkgs-stable.playerctl;
    };
  };

  # --- Configuration Files Management ---
  xdg.configFile = {
    "sway/config".source = ../../../config/sway/config;
    "sway/cheatsheet.txt".source = ../../../config/sway/cheatsheet.txt;
    "waybar/config".source = ../../../config/waybar/config;
  };
}