{ pkgs-stable, ... }:
{
  imports = [
    ./gtk-theme.nix
    ./sc-recoder.nix
  ];

  home = {
    # --- Essential Packages ---
    packages = with pkgs-stable; [
      pavucontrol

      libnotify
      grim          # Screenshot
      slurp         # Region selection
      sway-audio-idle-inhibit
      wf-recorder   # Screen recorder
    ];

    # --- Cursor Theme Settings ---
    pointerCursor = {
      gtk.enable = true;
      name = "catppuccin-mocha-teal-cursors";
      package = pkgs-stable.catppuccin-cursors.mochaTeal;
      size = 24;
    };
  };

  programs = {
    # Automatically start Sway on tty1. If it fails or is run on another virtual terminal, set LANG=C.
    bash.initExtra = ''
      [ -z "$DISPLAY" ] && { [ "''${XDG_VTNR:-0}" -eq 1 ] && exec sway || export LANG=C; }
    '';
    # Sway Screen Lock
    swaylock = {
      enable = true;
      package = pkgs-stable.swaylock;
    };
    # Sway Status bar
    waybar = {
      enable = true;
      package = pkgs-stable.waybar;
      style = builtins.readFile ../../../config/waybar/style.css;
    };
    # Logout menu
    wlogout = {
      enable = true;
      package = pkgs-stable.wlogout;
      style = builtins.readFile ../../../config/wlogout/style.css;
    };
    # Launcher
    wofi = {
      enable = true;
      package = pkgs-stable.wofi;
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
    # Notifications
    mako = {
      enable = true;
      package = pkgs-stable.mako;
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
    "sway/config".text = builtins.readFile ../../../config/sway/config + ''

      # Start Polkit Authentication Agent
      exec ${pkgs-stable.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
    '';

    "sway/cheatsheet.txt".source = ../../../config/sway/cheatsheet.txt;
    "waybar/config".source = ../../../config/waybar/config;
    "wlogout/layout".source = ../../../config/wlogout/layout;
    "swaylock/config".source = ../../../config/swaylock/config;
  };
}