{ inputs, lib, myconf, pkgs, pkgs-stable, ... }:
{
  # Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$qsConfig" = "ii";
      exec-once = [
        "${pkgs-stable.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "hyprctl dispatch submap global"
      ];
      submap = "global";
    };

    extraConfig = ''
      # Defaults
      source=~/.config/hypr/hyprland/general.conf
      source=~/.config/hypr/hyprland/rules.conf
      source=~/.config/hypr/hyprland/colors.conf
      source=~/.config/hypr/hyprland/keybinds.conf

      # Custom
      source=~/.config/hypr/custom/env.conf
      source=~/.config/hypr/custom/execs.conf
      source=~/.config/hypr/custom/general.conf
      source=~/.config/hypr/custom/rules.conf
      source=~/.config/hypr/custom/keybinds.conf
    '';
  };
  # setting up QML2_IMPORT_PATH
  qt.enable = true;
  programs = {
    # Automatically start Hyprland on tty1. If it fails or is run on another virtual terminal, set LANG=C.
    bash.initExtra = ''
      [ -z "$DISPLAY" ] && { [ "''${XDG_VTNR:-0}" -eq 1 ] && exec Hyprland >"$HOME/.hyprland.log" 2>&1 || export LANG=C; }
    '';
    hyprlock.enable = true;
    hyprshot.enable = true;
    jq = {
      # for HyprlandData
      enable = true;
      package = pkgs-stable.jq;
    };
    starship = {
      enable = false;
      enableBashIntegration = true;
      package = pkgs-stable.starship;
    };
    micro.package = lib.mkForce pkgs-stable.micro-with-wl-clipboard;
    quickshell = {
      enable = true;
      package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };
  services = {
    cliphist = {
      enable = true;
      package = pkgs-stable.cliphist;
    };
    easyeffects = {
      enable = true;
      package = pkgs-stable.easyeffects;
    };
    hypridle.enable = true;
    hyprsunset.enable = true;
    swww = {
      enable = false;
      package = pkgs-stable.swww;
    };
  };
  dbus.packages = [ pkgs-stable.nemo-with-extensions ];
  home = {
    # Additional icons
    file = {
      ".local/share/icons/Mint-Y/apps/48@2x".source = "${inputs.illogical-impulse-dotfiles}/dots/.local/share/icons";
    };
    sessionVariables = {
      # Python virtual environment path
      # No longer used with fork, so setting is optional,
      # but if not set, required packages must be added to home.packages for proper operation
      # ILLOGICAL_IMPULSE_VIRTUAL_ENV = "${config.home.homeDirectory}/.local/state/quickshell/.venv";
    } // lib.optionalAttrs (builtins.length myconf.environment == 1) {
      NIX_GSETTINGS_OVERRIDES_DIR = "${pkgs-stable.cinnamon-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";
    };
    packages = (with pkgs-stable; [
      ## Audio
      # cava
      # lxqt.pavucontrol-qt
      # wireplumber
      # libdbusmenu-gtk3
      # playerctl

      ## Screenshot
      # grim
      # swappy
      imagemagick ## _light not work (need image format support)
      libnotify
      slurp
      wf-recorder

      ## Python
      python3
      # (python3.withPackages (ps: with ps; [
        ## generate_colors_material
        # build
        # kde-material-you-colors
        # libsass
        # materialyoucolor
        # material-color-utilities
        # pillow
        # psutil
        # setproctitle
        # setuptools-scm
        # wheel
        ## thumbgen
        # click
        # loguru
        # pygobject3
        # tqdm
      # ]))

      ## Switchwall
      bc
      xdg-user-dirs
      ## fix: dbus.exceptions.DBusException: org.freedesktop.DBus.Error.ServiceUnknown:
      ##      The name org.kde.KWin was not provided by any .service files
      # kdePackages.plasma-workspace  # for plasma-apply-colorscheme
      # matugen
      # mpvpaper

      ## etc ...
      # ddcutil # for brightness
      # gobject-introspection
      libqalculate # for searchwidget
      pomodoro
      translate-shell # for left sidebar
      wl-clipboard
    ]) ++ (with pkgs; [
      ## Quickshell
      # kdePackages.kdialog
      kdePackages.qt5compat
      kdePackages.qtbase
      kdePackages.qtdeclarative
      kdePackages.qtimageformats
      kdePackages.qtmultimedia
      kdePackages.qtpositioning
      kdePackages.qtquicktimeline
      kdePackages.qtsensors
      kdePackages.qtsvg
      kdePackages.qttools
      kdePackages.qttranslations
      kdePackages.qtvirtualkeyboard
      kdePackages.qtwayland
      kdePackages.syntax-highlighting
    ]);
  };
  # Illogical Impulse's file links
  xdg.configFile = {
    "kwalletrc".text = ''
      [Wallet]
      Enabled=false
    '';
    "quickshell".source = "${inputs.illogical-impulse-dotfiles}/dots/.config/quickshell";
    "matugen/templates/kde/kde-material-you-colors-wrapper.sh".source = "${inputs.illogical-impulse-dotfiles}/dots/.config/matugen/templates/kde/kde-material-you-colors-wrapper.sh";
    "hypr/hyprland".source = "${inputs.illogical-impulse-dotfiles}/dots/.config/hypr/hyprland";
    "hypr/hyprlock".source = "${inputs.illogical-impulse-dotfiles}/dots/.config/hypr/hyprlock";
    # "hypr/shaders".source = "${inputs.illogical-impulse-dotfiles}/dots/.config/hypr/shaders";
    "hypr/hypridle.conf".source = "${inputs.illogical-impulse-dotfiles}/dots/.config/hypr/hypridle.conf";
    "hypr/hyprlock.conf".source = "${inputs.illogical-impulse-dotfiles}/dots/.config/hypr/hyprlock.conf";
    # "starship.toml".source = "${inputs.illogical-impulse-dotfiles}/dots/.config/starship.toml";
    # "hypr/custom".source =  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dots/.config/.dotfiles/hypr_custom";
  };
}
