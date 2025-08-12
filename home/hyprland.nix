{ inputs, pkgs-stable, pkgs, ... }:
let
  colloid-gtk-theme = pkgs-stable.colloid-gtk-theme.override {
    colorVariants = [ "dark" ];
    themeVariants = [ "teal" ];
  };
in {
  programs = {
    chromium.commandLineArgs = [
      "--ozone-platform-hint=auto"
      "--enable-wayland-ime"
    ];
    hyprlock.enable = true;
    jq = { # for HyprlandData
      enable = true;
      package = pkgs-stable.jq;
    };
    quickshell = {
      enable = true;
      # package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
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
      enable = true;
      package = pkgs-stable.swww;
    };
  };
  # Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;

    plugins = with pkgs.hyprlandPlugins;[ hyprexpo ];

    settings = {
      exec-once = [
        "${pkgs-stable.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "hyprctl dispatch submap global"
      ];
      submap = "global";
    };

    extraConfig = ''
      $qsConfig = ii
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

  # Icons and themes
  gtk = {
    enable = true;
    iconTheme.name = "Mint-Y-Cyan";
    theme = {
      name = "Colloid-Teal-Dark";
      package = colloid-gtk-theme;
    };
  };
  # setting up QML2_IMPORT_PATH
  qt.enable = true;

  # dbus.packages = [ pkgs-stable.nemo-with-extensions ];
  home = {
    # Additional icons
    file = {
      ".local/share/icons/Mint-Y/apps/48@2x".source = "${inputs.illogical-impulse-dotfiles}/.local/share/icons";
    };
    sessionVariables.ILLOGICAL_IMPULSE_VIRTUAL_ENV = "~/.local/state/quickshell/.venv";
    packages = with pkgs-stable; [
      ## My packages
      bulky
      celluloid
      file-roller
      # glib # for trash
      # nemo-with-extensions
      networkmanagerapplet
      polkit_gnome
      xviewer
      xreader
      xed-editor

      ## Screenshot
      # grim
      # swappy
      imagemagick ## _light not work
      libnotify
      hyprshot
      slurp
      wf-recorder

      ## Python
      (python3.withPackages (python-pkgs: [
        python-pkgs.pywayland
      ]))

      ## etc ...
      ddcutil
      libqalculate # for searchwidget
      # matugen
      pomodoro
      translate-shell # for left sidebar
      wl-clipboard

      ## Quickshell
      kdePackages.kdialog
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
    ];
  };
  # Illogical Impulse's file links
  xdg.configFile = {
    "quickshell".source = "${inputs.illogical-impulse-dotfiles}/.config/quickshell";
    "hypr/hyprland".source = "${inputs.illogical-impulse-dotfiles}/.config/hypr/hyprland";
    "hypr/hyprlock".source = "${inputs.illogical-impulse-dotfiles}/.config/hypr/hyprlock";
    "hypr/shaders".source = "${inputs.illogical-impulse-dotfiles}/.config/hypr/shaders";
    "hypr/hypridle.conf".source = "${inputs.illogical-impulse-dotfiles}/.config/hypr/hypridle.conf";
    "hypr/hyprlock.conf".source = "${inputs.illogical-impulse-dotfiles}/.config/hypr/hyprlock.conf";
    # "hypr/custom".source = "./hypr_custom";
    # "hypr/custom".source =  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/.dotfiles/hypr_custom";
  };
}
