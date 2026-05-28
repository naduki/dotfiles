{ config, pkgs, ... }:
{
  imports = [
    ../gtk-theme.nix
    ../../cli/scripts/fuzzel_power.nix
    ../../cli/scripts/sc-recoder.nix
  ];

  home = {
    # --- Essential Packages ---
    packages = with pkgs; [
      celluloid
      glib # for trash
      nemo-with-extensions
      pavucontrol

      xed-editor
      xreader
      xviewer

      libnotify
      grim          # Screenshot
      slurp         # Region selection
      # sway-audio-idle-inhibit
      # wf-recorder   # Screen recorder
    ];
    # --- Cursor Theme Settings ---
    pointerCursor = {
      gtk.enable = true;
      name = "catppuccin-mocha-teal-cursors";
      package = pkgs.catppuccin-cursors.mochaTeal;
      size = 24;
    };
  };

  programs = {
    # Automatically start Sway on tty1. If it fails or is run on another virtual terminal, set LANG=C.
    bash.initExtra = ''
      [ -z "$DISPLAY" ] && { [ "''${XDG_VTNR:-0}" -eq 1 ] && exec sway || export LANG=C; }
    '';
    # Launcher
    fuzzel = {
      enable = true;
      package = pkgs.fuzzel;
      settings = {
        main = {
          cache = "/dev/null";  # Effectively reset or disable sorting by frequency
          font = "monospace:size=14";
          icon-theme="Mint-Y";
          match-mode = "fzf";
          show-actions = "yes";
          sort-result = "yes";
          terminal = "wezterm";
          width = 40;
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
      package = pkgs.swaylock;
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
      package = pkgs.waybar;
      style = builtins.readFile ../waybar/style.css;
    };
  };

  services = {
    autotiling = {
      enable = true;
      package = pkgs.autotiling-rs;
    };
    # Clipboard
    cliphist = {
      enable = true;
      package = pkgs.cliphist;
      clipboardPackage = pkgs.wl-clipboard;
    };
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-gnome3;
    };
    polkit-gnome.enable = true;
    # Notifications
    mako = {
      enable = true;
      package = pkgs.mako;
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
      package = pkgs.swayidle;
      events = {
        "before-sleep" = "${config.programs.swaylock.package}/bin/swaylock -f";
      };
      timeouts = [
        {
          timeout = 300;
          command = "${config.programs.swaylock.package}/bin/swaylock -f";
        }
        {
          timeout = 600;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
    # Enable playerctld daemon for media player control
    playerctld = {
      enable = true;
      package = pkgs.playerctl;
    };
  };

  # sway-audio-idle-inhibitをログイン時にサービスから起動する
  # ターミナルからさわれないようにするため
  # sway/configをNix式で管理する場合は、Swayから起動させてもよい
  systemd.user.services.sway-audio-idle-inhibit = {
    Unit = {
      Description = "Run sway-audio-idle-inhibit";
    };
    Service = {
      Type = "oneshot";

      ExecStart = "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit &";
      RemainAfterExit = true;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # --- Configuration Files Management ---
  xdg.configFile = {
    "sway/config".source = ./config;
    "sway/cheatsheet.txt".source = ./cheatsheet.txt;
    "waybar/config".source = ../waybar/config;
  };
}
