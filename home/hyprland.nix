{pkgs-stable, pkgs, inputs, ...}:
{
  programs = {
    quickshell = {
      enable = true;
      package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
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
  };

  home.packages = with pkgs-stable; [
    hyprshot
    slurp
    wl-screenrec

    swaynotificationcenter
    
    trash-cli
    gnome-calculator
    mint-y-icons
    mint-themes
    nemo-with-extensions
    xed-editor

    cliphist
    ddcutil

    kdePackages.kdialog
    kdePackages.qt5compat
    kdePackages.qtbase
    kdePackages.qtdeclarative
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

  home.sessionVariables.ILLOGICAL_IMPULSE_VIRTUAL_ENV = "~/.local/state/quickshell/.venv";
  home.sessionVariables.QML2_IMPORT_PATH = "${pkgs.kdePackages.qt5compat}/lib/qt-6/qml:${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml:${pkgs.kdePackages.qtmultimedia}/lib/qt-6/qml:${pkgs.kdePackages.qtpositioning}/lib/qt-6/qml:${pkgs.kdePackages.qtquicktimeline}/lib/qt-6/qml:${pkgs.kdePackages.qtsensors}/lib/qt-6/qml:${pkgs.kdePackages.qtvirtualkeyboard}/lib/qt-6/qml:${pkgs.kdePackages.qtwayland}/lib/qt-6/qml";

  xdg.configFile."quickshell".source = "${inputs.illogical-impulse-dotfiles}/.config/quickshell";
}
