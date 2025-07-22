{ pkgs-stable, pkgs, inputs, lib, ...}:
let
  quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  # colloid-icon-theme = pkgs-stable.colloid-icon-theme.override {
  #   colorVariants = [ "teal" ];
  # };
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
    hyprlock = {
      enable = true;
      # package = inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
    chromium = {
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--enable-wayland-ime"
      ];
    };
  };
  services = {
    hypridle = {
      enable = true;
      # package = inputs.hypridle.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };
  # Icons and themes
  gtk = {
    enable = true;
    iconTheme = {
      # name = "Colloid-teal-dark";
      # package = colloid-icon-theme;
      name = "MoreWaita";
      package = pkgs-stable.morewaita-icon-theme;
    };
    theme = {
      name = "Colloid-Teal-Dark";
      package = colloid-gtk-theme;
    };
  };

  home.packages = with pkgs-stable; [
    hyprshot
    slurp
    wl-screenrec

    file-roller
    gnome-calculator
    glib  # for trash

    adwaita-icon-theme
    hicolor-icon-theme
    mint-y-icons

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

  home.sessionVariables.QML2_IMPORT_PATH = lib.concatStringsSep ":" [
    "${quickshell}/lib/qt-6/qml"
    "${pkgs-stable.kdePackages.qt5compat}/lib/qt-6/qml"
    "${pkgs-stable.kdePackages.qtdeclarative}/lib/qt-6/qml"
    "${pkgs-stable.kdePackages.qtmultimedia}/lib/qt-6/qml"
    "${pkgs-stable.kdePackages.qtpositioning}/lib/qt-6/qml"
    "${pkgs-stable.kdePackages.qtquicktimeline}/lib/qt-6/qml"
    "${pkgs-stable.kdePackages.qtsensors}/lib/qt-6/qml"
    "${pkgs-stable.kdePackages.qtvirtualkeyboard}/lib/qt-6/qml"
    "${pkgs-stable.kdePackages.qtwayland}/lib/qt-6/qml"
    "${pkgs-stable.kdePackages.syntax-highlighting}/lib/qt-6/qml"
  ];
  home.sessionVariables.ILLOGICAL_IMPULSE_VIRTUAL_ENV = "~/.local/state/quickshell/.venv";

  xdg.configFile."quickshell".source = "${inputs.illogical-impulse-dotfiles}/.config/quickshell";
  xdg.configFile."hypr/hypridle.conf".source = "${inputs.illogical-impulse-dotfiles}/.config/hypr/hypridle.conf";
  # Additional icons
  home.file = {
    ".local/share/icons/MoreWaita/scalable/apps" = {
      source = "${inputs.illogical-impulse-dotfiles}/.local/share/icons";
    };
  };
}
