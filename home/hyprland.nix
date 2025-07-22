{ pkgs-stable, pkgs, inputs, ...}:
let
  quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  colloid-gtk-theme = pkgs-stable.colloid-gtk-theme.override {
    colorVariants = [ "dark" ];
    themeVariants = [ "teal" ];
  };
in {
  programs = {
    quickshell = {
      enable = true;
      package = quickshell;
    };
    hyprlock.enable = true;
    chromium.commandLineArgs = [
      "--ozone-platform-hint=auto"
      "--enable-wayland-ime"
    ];

  };
  wayland.windowManager.hyprland = {
    enable = true;
    # systemd.enable = false;

    settings = {
      exec = [
        "hyprctl dispatch submap global"
      ];
      submap = "global"; # This is required for catchall to work
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
  services.hypridle.enable = true;
  # Icons and themes
  gtk = {
    enable = true;
    iconTheme = {
      name = "Mint-Y-Cyan";
      package = pkgs-stable.mint-y-icons;
    };
    theme = {
      name = "Colloid-Teal-Dark";
      package = colloid-gtk-theme;
    };
  };
  # setting up QML2_IMPORT_PATH
  qt.enable = true;

  home.packages = with pkgs-stable; [
    hyprshot
    slurp
    wl-screenrec

    file-roller
    gnome-calculator
    glib  # for trash

    celluloid
    nemo-with-extensions
    xed-editor
    xviewer

    cliphist
    ddcutil
    swww
    translate-shell # for left sidebar

    hyprland-qt-support
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
  # Illogical Impulse's file links
  xdg.configFile = {
    "quickshell".source = "${inputs.illogical-impulse-dotfiles}/.config/quickshell";
    "hypr/hyprland".source = "${inputs.illogical-impulse-dotfiles}/.config/hypr/hyprland";
    "hypr/hyprlock".source = "${inputs.illogical-impulse-dotfiles}/.config/hypr/hyprlock";
    "hypr/shaders".source = "${inputs.illogical-impulse-dotfiles}/.config/hypr/shaders";
    "hypr/hypridle.conf".source = "${inputs.illogical-impulse-dotfiles}/.config/hypr/hypridle.conf";
    "hypr/hyprlock.conf".source = "${inputs.illogical-impulse-dotfiles}/.config/hypr/hyprlock.conf";
    # "hypr/custom".source = "./hypr_custom";
  };
  # Additional icons
  home.file = {
    # ".local/share/icons/MoreWaita/scalable/apps" = 
    ".local/share/icons/Mint-Y/apps/48@2x" = 
    {
      source = "${inputs.illogical-impulse-dotfiles}/.local/share/icons";
    };
  };
}
