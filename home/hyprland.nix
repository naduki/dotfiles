{ pkgs-stable, pkgs, inputs, lib, ...}:
let
  quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  colloid-icon-theme = pkgs-stable.colloid-icon-theme.override {
    colorVariants = [ "teal" ];
  };
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
  };
  services = {
    hypridle = {
      enable = true;
      # package = inputs.hypridle.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
    hyprshell = {
      enable = true;
      systemd.enable = false;
      # package = inputs.hyprshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
    hyprpaper = {
      enable = true;
    };
  };
  # Icons and themes
  gtk = {
    enable = true;
    iconTheme = {
      # name = "Colloid-teal-dark";
      # package = colloid-gtk-theme;
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

    swaynotificationcenter
    
    gnome-calculator
    glib  # for trash

    mint-y-icons
    nemo-with-extensions
    xed-editor

    cliphist
    ddcutil

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
  ] ++ [ colloid-icon-theme ];

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
  # Additional icons
  home.file = {
    ".local/share/icons/MoreWaita/scalable/apps" = {
      source = "${inputs.illogical-impulse-dotfiles}/.local/share/icons";
    };
  };
}
