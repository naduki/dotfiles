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

    plugins = with pkgs.hyprlandPlugins;[
      # hyprbars
      hyprexpo
    ];

    settings = {
      exec = [
        "${pkgs-stable.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
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
    # My packages
    celluloid
    file-roller
    gnome-calculator
    glib  # for trash
    nemo-with-extensions
    polkit_gnome
    xed-editor
    xviewer

    ## Screenshot
    # grim
    # swappy
    # wl-clipboard-rs
    imagemagick_light
    hyprshot
    slurp
    wl-screenrec

    ## Audio
    # cava

    # curl
    cliphist
    ddcutil
    # swww
    libqalculate  # for searchwidget
    networkmanagerapplet    
    translate-shell # for left sidebar

    # python313
    jq  # for HyprlandData
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
  ] ++ (with pkgs;[ hyprsunset ]);
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
  home.sessionVariables.ILLOGICAL_IMPULSE_VIRTUAL_ENV = "~/.local/state/quickshell/.venv";
  # Additional icons
  home.file = {
    # ".local/share/icons/MoreWaita/scalable/apps" = 
    ".local/share/icons/Mint-Y/apps/48@2x" = 
    {
      source = "${inputs.illogical-impulse-dotfiles}/.local/share/icons";
    };
  };
}
