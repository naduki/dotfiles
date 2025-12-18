{ inputs, lib, myconf, pkgs, pkgs-stable, ... }:
{
  # Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Monitors
      monitor = "DP-1, 2560x1440@75.00Hz, 0x0, 1";

      # Programs
      "$browser" = "brave";
      "$ide" = "antigravity";
      "$terminal" = "wezterm";
      "$fileManager" = "nemo";

      # Environment Variables
      env = [
        "QT_IM_MODULE, fcitx"
        "XMODIFIERS, @im=fcitx"
        "SDL_IM_MODULE, fcitx"
        "GLFW_IM_MODULE, ibus"
        "INPUT_METHOD, fcitx"

        "QT_QPA_PLATFORM, wayland"
        "QT_QPA_PLATFORMTHEME, gtk3"
        "QT_QPA_PLATFORMTHEME_QT6,gtk3"
        "GTK_THEME, Colloid-Teal-Dark"
        "XDG_MENU_PREFIX, cinnamon-"
        
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "NIXOS_OZONE_WL,1"
      ];

      # Autostart
      exec-once = [
        "fcitx5 -d -r"
        "bash -c \"wl-paste --watch cliphist store &\""
      ];

      # Look and Feel
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = "yes";
        bezier = [
          "easeOutQuint,   0.23, 1,    0.32, 1"
          "easeInOutCubic, 0.65, 0.05, 0.36, 1"
          "linear,         0,    0,    1,    1"
          "almostLinear,   0.5,  0.5,  0.75, 1"
          "quick,          0.15, 0,    0.1,  1"
        ];
        animation = [
          "global,        1,     10,    default"
          "border,        1,     5.39,  easeOutQuint"
          "windows,       1,     4.79,  easeOutQuint"
          "windowsIn,     1,     4.1,   easeOutQuint, popin 87%"
          "windowsOut,    1,     1.49,  linear,       popin 87%"
          "fadeIn,        1,     1.73,  almostLinear"
          "fadeOut,       1,     1.46,  almostLinear"
          "fade,          1,     3.03,  quick"
          "layers,        1,     3.81,  easeOutQuint"
          "layersIn,      1,     4,     easeOutQuint, fade"
          "layersOut,     1,     1.5,   linear,       fade"
          "fadeLayersIn,  1,     1.79,  almostLinear"
          "fadeLayersOut, 1,     1.39,  almostLinear"
          "workspaces,    1,     1.94,  almostLinear, fade"
          "workspacesIn,  1,     1.21,  almostLinear, fade"
          "workspacesOut, 1,     1.94,  almostLinear, fade"
          "zoomFactor,    1,     7,     quick"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
            natural_scroll = false;
        };
      };

      ecosystem = {
          no_update_news = true;
      };

      # Keybindings
      bind = [
        "SUPER, Q, exec, $terminal"
        "SUPER, W, exec, $browser"
        "SUPER, X, exec, $ide"
        "SUPER, C, killactive,"
        "SUPER, E, exec, $fileManager"
        "SUPER, R, togglefloating,"
        "SUPER, P, pseudo,"
        "SUPER, J, togglesplit,"
        
        "CTRL SHIFT, escape, exec, hyprctl reload"

        "SUPER, space, exec, dms ipc call spotlight toggle"
        "SUPER, V, exec, dms ipc call clipboard toggle"
        "SUPER, M, exec, dms ipc call processlist focusOrToggle"
        "SUPER, comma, exec, dms ipc call settings focusOrToggle"
        "SUPER, N, exec, dms ipc call notifications toggle"
        "SUPER, Y, exec, dms ipc call dankdash wallpaper"
        "SUPER, TAB, exec, dms ipc call hypr toggleOverview"
        "SUPER, slash, exec, dms ipc call keybinds toggle hyprland"

        # Screen recording
        "SUPER ALT, R, exec, ~/.config/hypr/scripts/screen-record.sh"
        
        # Screenshot (dms)
        ", Print, exec, dms screenshot region"
        "SHIFT, Print, exec, dms screenshot full"
        "CTRL, Print, exec, dms screenshot window"
        
        "$mod ALT, L, exec, dms ipc call lock lock"

        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"

        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"

        "SUPER, S, togglespecialworkspace, magic"
        "SUPER SHIFT, S, movetoworkspace, special:magic"

        "SUPER, mouse_down, workspace, e+1"
        "SUPER, mouse_up, workspace, e-1"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, dms ipc call audio increment 3"
        ", XF86AudioLowerVolume, exec, dms ipc call audio decrement 3"
        ", XF86MonBrightnessUp, exec, dms ipc call brightness increment 5"
        ", XF86MonBrightnessDown, exec, dms ipc call brightness decrement 5"

        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];

      bindl = [
        ", XF86AudioMute, exec, dms ipc call audio mute"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      layerrule = [
        "noanim, ^(dms)$"
      ];

      windowrule = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];

      windowrulev2 = [
        "float, class:^(org.quickshell)$,title:^(設定)(.*)$"
        "float, title:^(ピクチャー イン ピクチャー)(.*)$"
        "keepaspectratio, title:^(ピクチャー イン ピクチャー)(.*)$"
        "move 73% 72%, title:^(ピクチャー イン ピクチャー)(.*)$"
        "size 25%, title:^(ピクチャー イン ピクチャー)(.*)$"
        "pin, title:^(ピクチャー イン ピクチャー)(.*)$"
      ];
    };
    extraConfig = ''
      # Legacy/Other settings
      gesture = 3, horizontal, workspace
    '';
  };

  # Screen recording script
  xdg.configFile."hypr/scripts/screen-record.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p libnotify

      # Check if wf-recorder is running
      if pgrep -x "wf-recorder" > /dev/null; then
          pkill -INT wf-recorder
          notify-send "Screen Recording" "Recording stopped and saved."
      else
          # Define file name with timestamp
          FILENAME="$HOME/Videos/recording_$(date +'%Y-%m-%d_%H-%M-%S').mp4"
          
          # Ensure Videos directory exists
          mkdir -p "$HOME/Videos"
          
          # Select region with slurp
          REGION=$(slurp)
          
          # If selection was cancelled (empty region), exit
          if [ -z "$REGION" ]; then
              exit 0
          fi
          
          # Start recording
          # -g: geometry from slurp
          # -f: output file
          notify-send "Screen Recording" "Recording started..."
          wf-recorder -g "$REGION" -f "$FILENAME" &
      fi
    '';
  };

  dbus.packages = [ pkgs-stable.nemo-with-extensions ];
  
  home = {
    sessionVariables = { } // lib.optionalAttrs (builtins.length myconf.environment == 1) {
      NIX_GSETTINGS_OVERRIDES_DIR = "${pkgs-stable.cinnamon-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";
    };
    packages = with pkgs-stable; [
      ## screen recorder
      slurp
      wf-recorder

      ## etc ...
      pavucontrol
      xdg-user-dirs
    ];
    # --- Cursor Theme Settings ---
    pointerCursor = {
      gtk.enable = true;
      hyprcursor.enable = true;
      name = "catppuccin-mocha-teal-cursors";
      package = pkgs-stable.catppuccin-cursors.mochaTeal;
      size = 24;
    };
  };

  programs.chromium.commandLineArgs = [ "--ozone-platform-hint=auto" ];
}
