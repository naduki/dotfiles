{ inputs, pkgs-stable, pkgs, ... }:
let
  colloid-gtk-theme = pkgs-stable.colloid-gtk-theme.override {
    colorVariants = [ "dark" ];
    themeVariants = [ "teal" ];
  };
in {
  programs = {
    quickshell = {
      enable = true;
      package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
    hyprlock.enable = true;
    chromium.commandLineArgs = [
      "--ozone-platform-hint=auto"
      "--enable-wayland-ime"
    ];
  };

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
    # My packages
    bulky
    celluloid
    file-roller
    gnome-calculator
    glib # for trash
    nemo-with-extensions
    networkmanagerapplet
    polkit_gnome
    xed-editor
    xviewer

    ## Screenshot
    # grim
    # swappy
    imagemagick_light
    libnotify
    hyprshot
    slurp
    wf-recorder

    wl-clipboard
    cliphist
    ddcutil
    # swww
    libqalculate # for searchwidget
    # matugen
    translate-shell # for left sidebar

    # python
    (python3.withPackages (python-pkgs: [
      python-pkgs.pywayland
    ]))
    # ...
    jq # for HyprlandData
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
  ] ++ (with pkgs; [ hyprsunset ]);
  dbus.packages = [ pkgs-stable.nemo-with-extensions ];
  # Illogical Impulse's file links
  xdg.configFile = {
    "quickshell".source = "${inputs.illogical-impulse-dotfiles}/.config/quickshell";
    "hypr/hyprland".source = "${inputs.illogical-impulse-dotfiles}/.config/hypr/hyprland";
    "hypr/hyprlock".source = "${inputs.illogical-impulse-dotfiles}/.config/hypr/hyprlock";
    "hypr/shaders".source = "${inputs.illogical-impulse-dotfiles}/.config/hypr/shaders";
    "hypr/hypridle.conf".source = "${inputs.illogical-impulse-dotfiles}/.config/hypr/hypridle.conf";
    "hypr/hyprlock.conf".source = "${inputs.illogical-impulse-dotfiles}/.config/hypr/hyprlock.conf";
    # "hypr/custom".source = "./hypr_custom";
    # "hypr/custom".source =  config.lib.file.mkOutOfStoreSymlink "/home/${names.user}/.config/.dotfiles/hypr_custom";
  };
  home.sessionVariables.ILLOGICAL_IMPULSE_VIRTUAL_ENV = "~/.local/state/quickshell/.venv";
  # Additional icons
  home.file = {
    ".local/share/icons/Mint-Y/apps/48@2x" ={
      source = "${inputs.illogical-impulse-dotfiles}/.local/share/icons";
    };
  };
}
