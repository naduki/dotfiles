{ pkgs-stable, ... }:
{
  imports = [
    ./gtk-theme.nix
    ./sc-recoder.nix
  ];

  dbus.packages = [ pkgs-stable.nemo-with-extensions ];

  home = {
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
  # Automatically start Hyprland on tty1. If it fails or is run on another virtual terminal, set LANG=C.
  programs.bash.initExtra = ''
    [ -z "$DISPLAY" ] && { [ "''${XDG_VTNR:-0}" -eq 1 ] && exec start-hyprland || export LANG=C; }
  '';

  # Hyprland configuration
  # When launched from the dank linux launcher, it starts as XWayland or ignores gsettings.
  # Therefore, launch browsers and IDEs via shortcuts.
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
      "$guiEditor" = "xed";

      # Environment Variables
      env = [
        "QT_IM_MODULE, fcitx"
        "QT_IM_MODULES, wayland;fcitx"
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
        "wl-paste --watch cliphist store &"
        "${pkgs-stable.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
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
        kb_options = "caps:super";
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
        "SUPER, T, exec, $terminal"
        "SUPER, B, exec, $browser"
        "SUPER, I, exec, $ide"
        "SUPER, X, exec, $guiEditor"
        "SUPER, E, exec, $fileManager"
        "SUPER, Q, killactive,"
        "SUPER, R, togglefloating,"
        "SUPER, P, pseudo,"
        "SUPER, J, togglesplit,"

        "CTRL SHIFT, escape, exec, hyprctl reload"

        "SUPER, V, exec, dms ipc call clipboard toggle"
        "SUPER, M, exec, dms ipc call processlist focusOrToggle"
        "SUPER, comma, exec, dms ipc call settings focusOrToggle"
        "SUPER, N, exec, dms ipc call notifications toggle"
        "SUPER, Y, exec, dms ipc call dankdash wallpaper"
        "SUPER, TAB, exec, dms ipc call hypr toggleOverview"
        "SUPER, slash, exec, dms ipc call keybinds toggle hyprland"

        # Screen recording
        "SUPER ALT, R, exec, ~/.config/screen-record.sh"

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

      # Hyprland version 0.53.0
      windowrule = [
        "suppress_event maximize, match:class .*"
        "no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0"

        "center on, match:title ^(印刷|Print)$"
        "float on, size (monitor_w*0.7) (monitor_h*0.7), match:class ^(org.quickshell)$, match:title ^(設定)$"
        "float on, keep_aspect_ratio on, move ((monitor_w*0.73)) ((monitor_h*0.72)), size (monitor_w*0.25) (monitor_h*0.25), pin on, match:title ^(ピクチャー イン ピクチャー|Picture in picture)$"

        # Float & center Brave file save/open dialogs
        "float on, center on, size (monitor_w*0.7) (monitor_h*0.7), match:class ^(brave)$, match:title ^(.*)(を要求しています|wants to)(.*)$"

        # Float & center VS Code / VSCodium (Electron) file/folder/workspace dialogs
        "float on, center on, match:class ^(code|code-url-handler|codium|codium-url-handler|antigravity)$, match:title ^(Open File|Open Folder|Select Folder|Save File|Save As|Open Workspace|Open Workspace from File|Add Folder to Workspace|Save Workspace|ファイルを開く|フォルダーを開く|フォルダーの選択|名前を付けて保存|ワークスペース)(.*)$"

        # celluloid
        "center on, match:class ^(io.github.celluloid_player.Celluloid)$, match:title ^(ファイルを開く|Open File|フォルダーを開く|Open Folder|設定|Preferences)$"
        # pulseaudio
        "float on, match:class ^(org.pulseaudio.pavucontrol)$"
        # xed
        "center on, match:class ^(xed)$,match:title ^(ファイルを開く|Open Files|名前を付けて保存|Save As|Xed の設定|Xed Preferences)(.*)"
        # xviewer
        "float on, center on, match:class ^(xviewer)$, match:title ^(画像を開く|Open Image|画像を保存|Save Image)$"
        "center on, match:class ^(xviewer)$, match:title ^(設定|Preferences)$"
      ];
    };
  };
}
